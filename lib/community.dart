import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gaia/base_page.dart';
import 'package:provider/provider.dart';
import 'package:gaia/theme_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:gaia/create_post_page.dart';

class CommunityPost {
  final int id;
  final String username;
  final String content;
  final String? image;
  final String category;
  final String tags;
  final int impact;

  CommunityPost({
    required this.id,
    required this.username,
    required this.content,
    this.image,
    required this.category,
    required this.tags,
    required this.impact,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    int parsedImpact = 0;
    if (json['peopleNo'] != null) {
      parsedImpact = int.tryParse(json['peopleNo'].toString()) ?? 0;
    }
    return CommunityPost(
      id: json['id'] ?? 0,
      username: json['username'] ?? 'Unknown User',
      content: json['content'] ?? '',
      image: json['image'] as String?,
      category: json['category'] ?? 'General',
      tags: json['tags'] ?? '',
      impact: parsedImpact,
    );
  }

  List<String> get tagList {
    if (tags.isEmpty) return [];
    return tags.split(',').map((tag) => tag.trim()).toList();
  }
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Controllers for the post creation dialog
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _peopleNoController = TextEditingController(text: '0');

  // State for dialog
  String? _selectedCategory;
  String? _pickedImageBase64;

  // State variable for upload loading
  bool _isUploading = false;

  final Set<int> _likedPosts = {};

  List<CommunityPost> _posts = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);
    _loadPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    // Dispose dialog controllers
    _titleController.dispose();
    _usernameController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _peopleNoController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  void _showCreatePostDialog() {
    // Navigate to the CreatePostPage
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatePostPage(
          onPostCreated: (Map<String, dynamic> postData) {
            // Create a CommunityPost from the API response
            final newPost = CommunityPost.fromJson(postData);
            
            // Add the new post to the top of the list
            setState(() {
              _posts.insert(0, newPost);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    var filteredPosts = _selectedFilter == 'All'
        ? _posts
        : _posts.where((post) => post.category == _selectedFilter).toList();

    if (_searchQuery.isNotEmpty) {
      filteredPosts = filteredPosts.where((post) {
        return post.content
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            post.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            post.tagList.any((tag) =>
                tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    return BasePage(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Search posts, users, tags...',
                          hintStyle: TextStyle(
                            color: theme.hintColor,
                            fontSize: 15,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: theme.colorScheme.primary,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, size: 20),
                                  onPressed: _clearSearch,
                                  color: theme.hintColor,
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                            ),
                          ),
                          SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: _showCreatePostDialog,
                            tooltip: 'Create Post',
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 50,
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFilterChip('All', theme),
                  _buildFilterChip('Volunteer', theme),
                  _buildFilterChip('Donation', theme),
                  _buildFilterChip('Environment', theme),
                  _buildFilterChip('News', theme),
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 48),
                                SizedBox(height: 16),
                                Text(
                                  _error!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _loadPosts,
                                  icon: Icon(Icons.refresh),
                                  label: Text('Retry'),
                                )
                              ],
                            ),
                          ))
                      : filteredPosts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sentiment_dissatisfied,
                            size: 64,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No results found for "$_searchQuery"'
                                : 'No posts found in this category',
                            style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                          : RefreshIndicator(
                              onRefresh: _loadPosts,
                              child: AnimationLimiter(
                                child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration: const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: _buildPostCard(post, theme),
                                        ),
                                      ),
                                    );
                      },
                    ),
            ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String category, ThemeData theme) {
    final isSelected = _selectedFilter == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(category),
        onSelected: (selected) {
          setState(() {
            _selectedFilter = category;
          });
        },
        backgroundColor: theme.cardColor,
        selectedColor: theme.colorScheme.primary.withOpacity(0.2),
        checkmarkColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post, ThemeData theme) {
    IconData categoryIcon;
    Color categoryColor;

    switch (post.category) {
      case 'Volunteer':
        categoryIcon = Icons.people;
        categoryColor = Colors.blue;
        break;
      case 'Donation':
        categoryIcon = Icons.card_giftcard;
        categoryColor = Colors.purple;
        break;
      case 'Environment':
        categoryIcon = Icons.nature;
        categoryColor = Colors.green;
        break;
      case 'News':
        categoryIcon = Icons.article;
        categoryColor = Colors.orange;
        break;
      default:
        categoryIcon = Icons.help_outline;
        categoryColor = Colors.grey;
    }

    final isLiked = _likedPosts.contains(post.id);
    int baseLikes = 0;
    final likeCount = isLiked ? baseLikes + 1 : baseLikes;

    Uint8List? imageBytes;
    if (post.image != null && post.image!.isNotEmpty) {
      try {
        String base64String = post.image!;
        if (base64String.startsWith('data:image')) {
            base64String = base64String.split(',').last;
        }
        base64String = base64.normalize(base64String);
        imageBytes = base64Decode(base64String);
      } catch (e) {
        print("Error decoding base64 image for post ${post.id}: $e");
      }
    }

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  child: Icon(Icons.person, color: theme.colorScheme.primary),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(categoryIcon, size: 14, color: categoryColor),
                      SizedBox(width: 4),
                      Text(
                        post.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              post.content,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ),

          if (imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                constraints: BoxConstraints(
                  maxHeight: 300,
                ),
                width: double.infinity,
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                     return Container(
                       height: 150,
                       color: Colors.grey[300],
                       child: Center(child: Icon(Icons.broken_image, color: Colors.grey[600]))
                     );
                  },
                ),
              ),
            ),

          if (post.impact > 0)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.healing,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Positive Impact: ',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                'Helped ${post.impact} ${post.impact == 1 ? 'person' : 'people'}',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),

          if (post.tagList.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: post.tagList.map((tag) {
                  return Container(
                    margin: EdgeInsets.only(right: 6),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _toggleLike(post.id),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_outline,
                          size: 20,
                          color: isLiked
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        SizedBox(width: 6),
                        Text(
                          likeCount.toString(),
                          style: TextStyle(
                            color: isLiked
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inDays > 0) {
      return difference.inDays == 1
          ? '1 day ago'
          : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1
          ? '1 hour ago'
          : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1
          ? '1 minute ago'
          : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void _toggleLike(int postId) {
    setState(() {
      if (_likedPosts.contains(postId)) {
        _likedPosts.remove(postId);
      } else {
        _likedPosts.add(postId);
      }
    });
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(
        Uri.parse('https://ngo-app-15sa.onrender.com/api/community/fetch'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _posts = data.map((json) => CommunityPost.fromJson(json)).toList()
            ..sort((a, b) => b.id.compareTo(a.id));
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load posts: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        _error = 'Failed to load posts. Check connection.';
        _isLoading = false;
      });
    }
  }

  // Helper for consistent input border style
  OutlineInputBorder _inputBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: theme.colorScheme.onSurface.withOpacity(0.2),
      ),
    );
  }
}
