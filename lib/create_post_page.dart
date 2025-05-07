import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:gaia/theme_provider.dart';

class CreatePostPage extends StatefulWidget {
  final Function(Map<String, dynamic>)? onPostCreated;

  const CreatePostPage({super.key, this.onPostCreated});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // Controllers for the form inputs
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController(text: "Demo User");
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _peopleNoController = TextEditingController(text: '0');

  // State variables
  String? _selectedCategory;
  String? _pickedImageBase64;
  bool _isUploading = false;
  int _currentStep = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _usernameController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _peopleNoController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Navigate to the next step
  void _goToNextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // Navigate to the previous step
  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // If on first step, go back to previous page
      Navigator.of(context).pop();
    }
  }

  // Submit the post to the API
  Future<void> _submitPost() async {
    final String title = _titleController.text.trim();
    final String username = _usernameController.text.trim();
    final String content = _contentController.text.trim();
    final String tags = _tagsController.text.trim();
    final String peopleNo = _peopleNoController.text.trim();
    final String? category = _selectedCategory;
    final String? imageBase64 = _pickedImageBase64;

    // Basic validation
    if (title.isEmpty) {
      _showValidationError('Please enter a title for your post.');
      return;
    }
    if (username.isEmpty) {
      _showValidationError('Please enter your name.');
      return;
    }
    if (content.isEmpty) {
      _showValidationError('Please enter content for your post.');
      return;
    }
    if (category == null) {
      _showValidationError('Please select a category.');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Create the post data JSON object
    final Map<String, dynamic> postData = {
      "title": title,
      "username": username,
      "content": content,
      "peopleNo": peopleNo.isEmpty ? "0" : peopleNo,
      "tags": tags,
      "category": category,
    };

    try {
      // Create a multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://ngo-community.onrender.com/api/community/upload'),
      );
      
      // Add the post data as a form field
      request.fields['post'] = json.encode(postData);
      
      // Add the image file if available
      if (imageBase64 != null && imageBase64.isNotEmpty) {
        // Convert base64 to bytes
        final bytes = base64Decode(imageBase64);
        
        // Create a multipart file
        final imageFile = http.MultipartFile.fromBytes(
          'imageFile',
          bytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        
        // Add the file to the request
        request.files.add(imageFile);
      }
      
      // Send the request
      final streamedResponse = await request.send();
      
      // Get the response
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic>) {
          if (widget.onPostCreated != null) {
            widget.onPostCreated!(responseData);
          }

          // Success - return to previous screen
          if (mounted) {
            Navigator.of(context).pop(true); // Return success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Post shared successfully!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } else {
          throw Exception('Invalid response format from server.');
        }
      } else {
        print('Server error: ${response.statusCode} - ${response.body}');
        _showValidationError('Failed to share post. Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting post: $e');
      _showValidationError('Failed to share post. Check connection or input.');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    theme.colorScheme.primary.withOpacity(0.2),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.8),
                    theme.colorScheme.primary.withOpacity(0.1),
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with step indicators
              _buildHeader(theme),
              
              // Main content - PageView for steps
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  children: [
                    // Step 1: Basic Info
                    _buildStep1(theme),
                    
                    // Step 2: Content and Details
                    _buildStep2(theme),
                    
                    // Step 3: Impact and Category
                    _buildStep3(theme),
                    
                    // Step 4: Preview and Submit
                    _buildStep4(theme),
                  ],
                ),
              ),
              
              // Bottom navigation
              _buildBottomNavigation(theme),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the header with step indicators
  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back/Close button
              IconButton(
                icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                onPressed: () => Navigator.of(context).pop(),
              ),
              
              // Title
              Text(
                'Create Impact',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ).animate().slideY(
                begin: 0.5,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOutQuad,
              ).fade(),
              
              // Spacer for alignment
              const SizedBox(width: 48),
            ],
          ),
          
          // Step indicators
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              4,
              (index) => _buildStepIndicator(index, theme),
            ),
          ),
        ],
      ),
    );
  }
  
  // Builds a single step indicator dot
  Widget _buildStepIndicator(int index, ThemeData theme) {
    final bool isActive = index == _currentStep;
    final bool isPast = index < _currentStep;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : isPast
                ? theme.colorScheme.primary.withOpacity(0.5)
                : theme.colorScheme.onSurface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
    ).animate(target: isActive ? 1 : 0).scaleXY(
      begin: 1.0,
      end: 1.2,
      duration: 300.ms,
    );
  }

  // Step 1: Title and User info
  Widget _buildStep1(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // User Avatar section
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Share Your Story',
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  'Let the community know about your contribution',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ).animate()
              .fade(duration: 400.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms),
          ),
          
          const SizedBox(height: 40),
          
          // Title field with animation
          Text(
            'Give your post a title',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate()
            .fade(delay: 200.ms)
            .slideX(begin: -0.2, end: 0),
            
          const SizedBox(height: 16),
          
          TextField(
            controller: _titleController,
            style: theme.textTheme.titleLarge,
            decoration: InputDecoration(
              hintText: 'My Sustainable Action...',
              hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surface.withOpacity(0.8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
          ).animate()
            .fade(delay: 300.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms),
            
          const SizedBox(height: 24),
          
          // User name field
          Text(
            'Your name',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate()
            .fade(delay: 400.ms)
            .slideX(begin: -0.2, end: 0),
            
          const SizedBox(height: 16),
          
          TextField(
            controller: _usernameController,
            style: theme.textTheme.titleMedium,
            decoration: InputDecoration(
              hintText: 'Your name',
              hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surface.withOpacity(0.8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ).animate()
            .fade(delay: 500.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms),
        ],
      ),
    );
  }
  
  // Step 2: Content and Image
  Widget _buildStep2(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Content field
          Text(
            'Tell your story',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate()
            .fade(duration: 400.ms)
            .slideX(begin: -0.2, end: 0),
            
          const SizedBox(height: 16),
          
          TextField(
            controller: _contentController,
            style: theme.textTheme.bodyLarge,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Share the details of your positive impact...',
              hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surface.withOpacity(0.8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            ),
          ).animate()
            .fade(delay: 500.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms),
            
          const SizedBox(height: 32),
          
          // Image picker section
          Text(
            'Add a visual',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate()
            .fade(delay: 300.ms)
            .slideX(begin: -0.2, end: 0),
            
          const SizedBox(height: 16),
          
          // Image picker container
          GestureDetector(
            onTap: () => _showImageSourceDialog(),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: _pickedImageBase64 != null
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.memory(
                          base64Decode(_pickedImageBase64!),
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () => _showImageSourceDialog(),
                            iconSize: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to add an image',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
            ),
          ).animate()
            .fade(delay: 400.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms),
          
          const SizedBox(height: 16),
          
          // Tags field
          Text(
            'Add tags (comma-separated)',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate()
            .fade(delay: 500.ms)
            .slideX(begin: -0.2, end: 0),
            
          const SizedBox(height: 16),
          
          TextField(
            controller: _tagsController,
            style: theme.textTheme.bodyLarge,
            decoration: InputDecoration(
              hintText: 'environment, sustainability, community...',
              hintStyle: TextStyle(color: theme.hintColor.withOpacity(0.5)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: theme.colorScheme.surface.withOpacity(0.8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              prefixIcon: const Icon(Icons.tag),
            ),
          ).animate()
            .fade(delay: 600.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms),
        ],
      ),
    );
  }
  
  // Step 3: Impact and Category
  Widget _buildStep3(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Category section
          Text(
            'Select a category',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate()
            .fade(duration: 400.ms)
            .slideX(begin: -0.2, end: 0),
            
          const SizedBox(height: 24),
          
          // Category cards
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildCategoryCard('Volunteer', Icons.people, Colors.blue, theme),
              _buildCategoryCard('Donation', Icons.card_giftcard, Colors.purple, theme),
              _buildCategoryCard('Environment', Icons.nature, Colors.green, theme),
              _buildCategoryCard('News', Icons.article, Colors.orange, theme),
            ],
          ).animate()
            .fade(delay: 200.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms),
            
          const SizedBox(height: 32),
          
          // Impact section
          Text(
            'Impact Counter',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate()
            .fade(delay: 400.ms)
            .slideX(begin: -0.2, end: 0),
            
          const SizedBox(height: 8),
          
          Text(
            'Approximately how many people were positively impacted?',
            style: theme.textTheme.bodyMedium,
          ).animate()
            .fade(delay: 500.ms),
            
          const SizedBox(height: 24),
          
          // Impact counter
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImpactButton(
                  Icons.remove,
                  theme,
                  () {
                    final currentValue = int.tryParse(_peopleNoController.text) ?? 0;
                    if (currentValue > 0) {
                      setState(() {
                        _peopleNoController.text = (currentValue - 1).toString();
                      });
                    }
                  },
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    Text(
                      _peopleNoController.text,
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'People',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                _buildImpactButton(
                  Icons.add,
                  theme,
                  () {
                    final currentValue = int.tryParse(_peopleNoController.text) ?? 0;
                    setState(() {
                      _peopleNoController.text = (currentValue + 1).toString();
                    });
                  },
                ),
              ],
            ),
          ).animate()
            .fade(delay: 600.ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms),
        ],
      ),
    );
  }
  
  // Step 4: Preview and Submit
  Widget _buildStep4(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          Text(
            'Preview Your Post',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).animate()
            .fade(duration: 400.ms)
            .slideX(begin: -0.2, end: 0),
            
          const SizedBox(height: 24),
          
          // Post preview card
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                        child: Icon(Icons.person, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _usernameController.text.toUpperCase(),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Just now',
                            style: TextStyle(
                              color: theme.hintColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Category indicator
                      if (_selectedCategory != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(_selectedCategory!).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getCategoryIcon(_selectedCategory!),
                                size: 14,
                                color: _getCategoryColor(_selectedCategory!),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _selectedCategory!,
                                style: TextStyle(
                                  color: _getCategoryColor(_selectedCategory!),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Title
                if (_titleController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      _titleController.text,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                
                // Content
                if (_contentController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      _contentController.text,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                
                // Image
                if (_pickedImageBase64 != null)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    constraints: const BoxConstraints(
                      maxHeight: 300,
                    ),
                    width: double.infinity,
                    child: Image.memory(
                      base64Decode(_pickedImageBase64!),
                      fit: BoxFit.cover,
                    ),
                  ),
                
                // Impact indicator
                if (_peopleNoController.text != '0')
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Positive Impact: ',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Helped ${_peopleNoController.text} ${int.parse(_peopleNoController.text) == 1 ? 'person' : 'people'}',
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Tags
                if (_tagsController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _tagsController.text.split(',').map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '#${tag.trim()}',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                
                const SizedBox(height: 16),
              ],
            ),
          ).animate()
            .fade(delay: 300.ms, duration: 800.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms),
            
          const SizedBox(height: 16),
          
          // Submit button area
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: _isUploading ? null : () => _submitPost(),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: _isUploading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Share with Community',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ).animate()
            .fade(delay: 700.ms, duration: 400.ms)
            .scaleXY(begin: 0.9, end: 1.0, duration: 400.ms),
        ],
      ),
    );
  }

  // Bottom navigation for step control
  Widget _buildBottomNavigation(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          TextButton.icon(
            onPressed: _goToPreviousStep,
            icon: const Icon(Icons.arrow_back),
            label: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface,
            ),
          ),
          
          // Next/Submit button
          ElevatedButton(
            onPressed: _currentStep == 3 ? () => _submitPost() : _goToNextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentStep == 3 ? 'Submit' : 'Next',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to build a category card
  Widget _buildCategoryCard(
    String title,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    final isSelected = _selectedCategory == title;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.onSurface.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? color : theme.colorScheme.onSurface.withOpacity(0.7),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? color : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to build impact button
  Widget _buildImpactButton(
    IconData icon,
    ThemeData theme,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: theme.colorScheme.primary),
        onPressed: onPressed,
        iconSize: 24,
      ),
    );
  }
  
  // Helper for getting category color
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Volunteer':
        return Colors.blue;
      case 'Donation':
        return Colors.purple;
      case 'Environment':
        return Colors.green;
      case 'News':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  // Helper for getting category icon
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Volunteer':
        return Icons.people;
      case 'Donation':
        return Icons.card_giftcard;
      case 'Environment':
        return Icons.nature;
      case 'News':
        return Icons.article;
      default:
        return Icons.help_outline;
    }
  }

  // Show dialog to choose Camera or Gallery
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Select Image Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to pick image and convert to base64
  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        final String base64String = base64Encode(imageBytes);

        setState(() {
          _pickedImageBase64 = base64String;
        });
      } else {
        // User canceled the picker
        print('No image selected.');
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e'), backgroundColor: Colors.red),
      );
    }
  }
} 