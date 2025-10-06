import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'loan-page.dart';
import 'online-application.dart';
import 'profile.dart';
import 'explore_services_page.dart';
import 'smart_money_tips_page.dart';
import 'news_details_page.dart';

// Constants
const Duration kDefaultTransitionDuration = Duration(milliseconds: 800);
const double kDefaultPadding = 16.0;
const Color kPrimaryColor = Colors.green;
const Color kAppBarTextColor = Colors.black;
const Color kScaffoldBackgroundColor = Color(0xFFF9FAFB);

class NewsEvent {
  final String title;
  final String description;
  final String imagePath;
  final List<String>? imagePaths;
  final String? date;
  final String? category;

  const NewsEvent({
    required this.title,
    required this.description,
    required this.imagePath,
    this.imagePaths,
    this.date,
    this.category,
  });
}

// Notification Manager
class NotificationManager {
  static List<String> notifications = [
    'Loan application approved',
    'New payment due date',
    'System maintenance scheduled',
    'New message from support',
    'Loan application is under review',
    'Loan application is rejected',
  ];

  static Set<int> unreadNotificationIndexes = {0, 1, 2, 3, 4, 5};

  static int get unreadCount => unreadNotificationIndexes.length;
}

// Navigation Helper
Future<void> navigateWithFade(BuildContext context, Widget page) {
  HapticFeedback.lightImpact();
  return Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: kDefaultTransitionDuration,
      pageBuilder: (context, animation, _) => page,
      transitionsBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return FadeTransition(opacity: curved, child: child);
      },
    ),
  );
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showGreeting = true;
  late AnimationController _fabController;

  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  bool _showFab = false;

  final List<NewsEvent> _newsAndEvents = const [
    NewsEvent(
      title: 'Annual General Assembly',
      description: 'Join us for our annual meeting and updates.',
      imagePath: 'assets/images/gbldc_event_annual_assembly.jpg',
      date: 'October 15, 2025',
      category: 'Event',
      imagePaths: [
        'assets/images/event1.jpg',
        'assets/images/gbldc_event_2-20.jpg',
        'assets/images/gbldc_event_3-20.jpg',
        'assets/images/gbldc_event_4-20.jpg',
        'assets/images/gbldc_event_5-20.jpg',
        'assets/images/gbldc_event-6-20.jpg',
        'assets/images/gbldc_event_7-20.jpg',
        'assets/images/gbldc_event_8-20.jpg',
        'assets/images/gbldc_event_9-20.jpg',
        'assets/images/gbldc_event_10-20.jpg',
        'assets/images/gbldc_event_11-20.jpg',
        'assets/images/gbldc_event_12-20.jpg',
        'assets/images/gbldc_event_13-20.jpg',
        'assets/images/gbldc_event_14-20.jpg',
        'assets/images/gbldc_event_15-20.jpg',
      ],
    ),
    NewsEvent(
      title: 'Community Outreach Program',
      description: 'Serving the barangay together through health and donation drives.',
      imagePath: 'assets/images/event4.jpg',
      date: 'September 20, 2025',
      category: 'Community',
      imagePaths: [
        'assets/images/event4.jpg',
        'assets/images/community_outreach_1.jpg',
        'assets/images/community_outreach_2.jpg',
      ],
    ),
    NewsEvent(
      title: 'Kick-Off Ceremony and Launching of Go Koop',
      description: 'Empowering Cooperatives in line with the Celebration of Cooperative Month 2023',
      imagePath: 'assets/images/event2.jpg',
      date: 'July 10, 2025',
      category: 'Launch',
      imagePaths: [
        'assets/images/event2.jpg',
        'assets/images/go_koop_launch_1.jpg',
      ],
    ),
    NewsEvent(
      title: 'GBLDC - Team Building',
      description: 'Strengthening teamwork through fun and engaging activities with all departments.',
      imagePath: 'assets/images/gbldc_event_team_building.jpg',
      date: 'August 5, 2025',
      category: 'Team Building',
      imagePaths: [
        'assets/images/gbldc_event_team_building_1.jpg',
        'assets/images/gbldc_event_team_building_2.jpg',
        'assets/images/gbldc_event_team_building_3.jpg',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !_showFab) {
        setState(() => _showFab = true);
        _fabController.forward();
      } else if (_scrollController.offset <= 200 && _showFab) {
        setState(() => _showFab = false);
        _fabController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _showGreeting = true;
      });
    }
  }

  void _onItemTapped(int index) {
    HapticFeedback.selectionClick();

    if (index == 0 && _selectedIndex == 0) {
      _refreshKey.currentState?.show();
      return;
    }

    if (index == 0) {
      setState(() => _selectedIndex = index);
    } else if (index == 1) {
      navigateWithFade(context, LoanPageHomepage());
    } else if (index == 2) {
      navigateWithFade(context, AccountPage());
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning!';
    if (hour >= 12 && hour < 17) return 'Good Afternoon!';
    return 'Good Evening!';
  }

  void _scrollToTop() {
    HapticFeedback.lightImpact();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _showFab
          ? ScaleTransition(
        scale: _fabController,
        child: FloatingActionButton.small(
          onPressed: _scrollToTop,
          backgroundColor: kPrimaryColor,
          child: const Icon(Iconsax.arrow_up_2, color: Colors.white, size: 20),
        ),
      )
          : null,
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _refreshData,
          color: kPrimaryColor,
          backgroundColor: Colors.white,
          strokeWidth: 3.0,
          displacement: 60.0,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(kDefaultPadding, 20, kDefaultPadding, 16),
                        child: _buildAppBarContent(),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 12),
                    if (_showGreeting) ...[
                      _GreetingCard(
                        greeting: _getGreeting(),
                        onDismissed: () => setState(() => _showGreeting = false),
                      ),
                      const SizedBox(height: 20),
                    ],
                    _buildNewsAndEventsCarousel(),
                    const SizedBox(height: 24),

                    _buildMainActionCards(),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kAppBarTextColor.withOpacity(0.6),
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              activeIcon: Icon(Iconsax.home_15),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.money_4),
              activeIcon: Icon(Iconsax.money_45),
              label: 'Loan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.profile_circle),
              activeIcon: Icon(Iconsax.profile_circle5),
              label: 'Profile',
            ),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildAppBarContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset('assets/images/logocoop.png', height: 32, width: 32),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GBLDC',
                  style: TextStyle(
                    fontSize: 18,
                    color: kAppBarTextColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'Cooperative',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        _NotificationBell(
          unreadCount: NotificationManager.unreadCount,
          onPressed: () => _showNotificationsBottomSheet(context),
        ),
      ],
    );
  }

  Widget _buildNewsAndEventsCarousel() {
    if (_newsAndEvents.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Icon(Iconsax.document, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                "No news or events at the moment.",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'News & Events',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kAppBarTextColor,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all news page
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Iconsax.arrow_right_3, size: 14, color: kPrimaryColor),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.easeInOutCubic,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: const Duration(milliseconds: 1000),
            viewportFraction: 0.88,
          ),
          items: _newsAndEvents.map((eventItem) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    navigateWithFade(
                      context,
                      NewsDetailPage(
                        title: eventItem.title,
                        description: eventItem.description,
                        imagePath: eventItem.imagePaths ?? [eventItem.imagePath],
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 6.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            eventItem.imagePath,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                                stops: const [0.5, 1.0],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (eventItem.category != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      eventItem.category!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  eventItem.title,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  eventItem.description,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (eventItem.date != null) ...[
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(
                                        Iconsax.calendar_1,
                                        size: 12,
                                        color: Colors.white70,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        eventItem.date!,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMainActionCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kAppBarTextColor,
          ),
        ),
        const SizedBox(height: 16),
        _ActionCard(
          title: 'Borrow Your Way',
          subtitle: 'Apply once for continuous access to cash.',
          imagePath: 'assets/images/gbldc-borrow-money.png',
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100],
          ),
          buttons: [
            ElevatedButton.icon(
              onPressed: () => navigateWithFade(context, const RegistrationForm()),
              icon: const Icon(Iconsax.edit, size: 18),
              label: const Text('Apply Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                elevation: 0,
              ),
            ),
          ],
        ),
        _ActionCard(
          title: 'Explore Our Services',
          subtitle: 'Microloans, livelihood programs, and more.',
          imagePath: 'assets/images/gbldc-explore-services.png',
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
          buttons: [
            OutlinedButton.icon(
              onPressed: () => navigateWithFade(context, const ExploreServicesPage()),
              icon: const Icon(Iconsax.search_normal_1, size: 18),
              label: const Text('Explore'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue.shade700,
                side: BorderSide(color: Colors.blue.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
        _ActionCard(
          title: 'Smart Money Tips',
          subtitle: 'Save, budget, and manage your finances.',
          imagePath: 'assets/images/finance-tips.png',
          gradient: LinearGradient(
            colors: [Colors.orange.shade50, Colors.orange.shade100],
          ),
          buttons: [
            OutlinedButton.icon(
              onPressed: () => navigateWithFade(context, const SmartMoneyTipsPage()),
              icon: const Icon(Iconsax.book, size: 18),
              label: const Text('Learn More'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange.shade700,
                side: BorderSide(color: Colors.orange.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showNotificationsBottomSheet(BuildContext context) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NotificationsBottomSheet(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _GreetingCard extends StatelessWidget {
  final String greeting;
  final VoidCallback onDismissed;

  const _GreetingCard({required this.greeting, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('greetingCard'),
      direction: DismissDirection.horizontal,
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        onDismissed();
      },
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerLeft,
        child: const Icon(Iconsax.trash, color: Colors.white),
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Iconsax.trash, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor.withOpacity(0.1), Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kPrimaryColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Iconsax.sun_15, color: kPrimaryColor, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome to Greater Bulacan Livelihood Development Cooperative',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: kPrimaryColor.withOpacity(0.7), size: 22),
              onPressed: () {
                HapticFeedback.lightImpact();
                onDismissed();
              },
              tooltip: 'Dismiss',
            )
          ],
        ),
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onPressed;

  const _NotificationBell({required this.unreadCount, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Iconsax.notification, color: kPrimaryColor, size: 24),
            onPressed: onPressed,
          ),
        ),
        if (unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Center(
                child: Text(
                  unreadCount > 9 ? '9+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Widget> buttons;
  final Gradient? gradient;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.buttons,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: gradient ?? LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: kAppBarTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(spacing: 8, runSpacing: 8, children: buttons),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsBottomSheet extends StatefulWidget {
  @override
  State<_NotificationsBottomSheet> createState() => _NotificationsBottomSheetState();
}

class _NotificationsBottomSheetState extends State<_NotificationsBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Iconsax.notification,
                          color: kPrimaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (NotificationManager.unreadCount > 0)
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        setState(() {
                          NotificationManager.unreadNotificationIndexes.clear();
                        });
                      },
                      child: const Text(
                        'Mark all read',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: NotificationManager.notifications.isEmpty
                  ? Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.notification_bing,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notifications',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: NotificationManager.notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  bool isUnread = NotificationManager.unreadNotificationIndexes.contains(index);
                  return Dismissible(
                    key: Key(NotificationManager.notifications[index]),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Iconsax.trash, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        NotificationManager.unreadNotificationIndexes.remove(index);
                        NotificationManager.notifications.removeAt(index);
                        NotificationManager.unreadNotificationIndexes =
                            NotificationManager.unreadNotificationIndexes
                                .where((i) => i != index)
                                .map((i) => i > index ? i - 1 : i)
                                .toSet();
                      });
                    },
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          NotificationManager.unreadNotificationIndexes.remove(index);
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isUnread ? Colors.green.shade50 : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isUnread
                                ? Colors.green.shade200
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isUnread
                                    ? Colors.green.shade100
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Iconsax.notification,
                                color: isUnread ? Colors.green : Colors.grey,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                NotificationManager.notifications[index],
                                style: TextStyle(
                                  fontWeight: isUnread
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isUnread ? Colors.black : Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kAppBarTextColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}