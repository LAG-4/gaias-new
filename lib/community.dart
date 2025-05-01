import 'package:flutter/material.dart';
import 'package:gaia/base_page.dart';
import 'package:gaia/news_api.dart';
import 'package:gaia/news_api_service.dart';
import 'package:provider/provider.dart';
import 'package:gaia/theme_provider.dart';

class CommunityPost {
  final String id;
  final String username;
  final String userImage;
  final String content;
  final String? image;
  final String category;
  final int likes;
  final DateTime timestamp;
  final List<String> tags;
  final int impact;

  CommunityPost({
    required this.id,
    required this.username,
    required this.userImage,
    required this.content,
    this.image,
    required this.category,
    required this.likes,
    required this.timestamp,
    required this.tags,
    required this.impact,
  });
}

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
    NewsApi? _newsData;//mapping
    bool _isLoading = true;

  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Set to track liked posts by their ID
  final Set<String> _likedPosts = {};

  // Mock data - to be replaced with Firebase data
  final List<CommunityPost> _posts = [
    CommunityPost(
      id: '1',
      username: 'Shwet Siwach',
      userImage: 'assets/u1.jpg',
      content:
          'Just volunteered at a food drive organized by Feed The Future NGO. We managed to provide meals to over 200 underprivileged children today!',
      image: 'assets/n1.jpg',
      category: 'Volunteer',
      likes: 124,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      tags: ['FoodDrive', 'Volunteer', 'Community'],
      impact: 200,
    ),
    CommunityPost(
      id: '2',
      username: 'Anurag Yadav',
      userImage: 'assets/u2.jpg',
      content:
          'Donated winter clothes to Warm Hearts foundation. They\'ll be distributed to homeless people as winter approaches. It feels great to help others stay warm!',
      image: 'assets/n2.jpg',
      category: 'Donation',
      likes: 89,
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
      tags: ['WinterClothes', 'Donation', 'Homeless'],
      impact: 50,
    ),
    CommunityPost(
      id: '3',
      username: 'NGO United',
      userImage: 'assets/u3.jpg',
      content:
          '17 measures undertaken by NGOs and communities in India contributing to Sustainable Development Goals. Together we can make a difference!',
      image: 'assets/b.jpg',
      category: 'News',
      likes: 215,
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      tags: ['SDGs', 'NGOs', 'SustainableDevelopment'],
      impact: 1000,
    ),
    CommunityPost(
      id: '4',
      username: 'Green Earth Initiative',
      userImage: 'assets/u4.jpg',
      content:
          'Today we planted 100 trees in Urban Park with the help of 30 volunteers. Small steps toward a greener future!',
      image: 'assets/c.jpg',
      category: 'Environment',
      likes: 178,
      timestamp: DateTime.now().subtract(Duration(days: 2)),
      tags: ['TreePlantation', 'Environment', 'GreenFuture'],
      impact: 100,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);
     fetchNewsData();
  }
    void fetchNewsData() async {
    final data = await NewsApiService().fetchNews();
    setState(() {
      _newsData = data;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
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
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Share Your Contribution',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'What positive impact did you make today?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                    ),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.photo_library_outlined),
                    label: Text('Add Photo'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.tag),
                    label: Text('Add Tags'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Post shared with the community!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Share with Community',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // First filter by category
    var filteredPosts = _selectedFilter == 'All'
        ? _posts
        : _posts.where((post) => post.category == _selectedFilter).toList();

    // Then filter by search
    if (_searchQuery.isNotEmpty) {
      filteredPosts = filteredPosts.where((post) {
        return post.content
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            post.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            post.tags.any((tag) =>
                tag.toLowerCase().contains(_searchQuery.toLowerCase()));
      }).toList();
    }

    return BasePage(
      body: SafeArea(
        child: Column(
          children: [
            // New persistent search bar design
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
                  ),
                ],
              ),
            ),

            // Category filters
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

            // Posts list
            Expanded(
              child: filteredPosts.isEmpty
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
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = filteredPosts[index];
                        return _buildPostCard(post, theme);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreatePostDialog,
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        tooltip: 'Create Post',
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
    // Choose icon and color based on category
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

    // Check if this post is liked
    final isLiked = _likedPosts.contains(post.id);
    final likeCount = isLiked ? post.likes + 1 : post.likes;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and post time
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(post.userImage),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _getTimeAgo(post.timestamp),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 12,
                        ),
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

          // Post content
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

          // Post image
          if (post.image != null)
            ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                constraints: BoxConstraints(
                  maxHeight: 300,
                ),
                width: double.infinity,
                child: Image.asset(
                  post.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          // Impact info
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

          // Tags
          if (post.tags.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: post.tags.map((tag) {
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

          // Actions row
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Like button
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
                Spacer(),
                // Share button
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _sharePost(post),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.share_outlined,
                          size: 20,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Share",
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
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

  // Add these methods for the like and share functionality
  void _toggleLike(String postId) {
    setState(() {
      if (_likedPosts.contains(postId)) {
        _likedPosts.remove(postId);
      } else {
        _likedPosts.add(postId);
      }
    });
  }

  void _sharePost(CommunityPost post) {
    final message =
        "Check out this post from ${post.username}: ${post.content}";
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: $message'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () {},
        ),
      ),
    );
    // In a real app, you would use a package like share_plus here
    // to implement actual sharing functionality
  }
}
