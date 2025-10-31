import '../entities/obituaryy_screen.dart';

class Client {
  // ✅ Fetch all obituaries (mocked for now)
  Future<List<Obituary>> fetchObituaries() async {
    await Future.delayed(const Duration(milliseconds: 800)); // simulate network

    // ✅ Mock data - replace with actual API call later
    return [
      Obituary(
        fullName: 'Juan Carlos Santos',
        birthDate: DateTime(1945, 5, 12),
        passingDate: DateTime(2024, 1, 15),
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
        shortTribute: 'A loving father, devoted husband, and respected community leader.',
        fullObituary: 'Juan Carlos Santos peacefully passed away on January 15, 2024, surrounded by his loving family. Born in Dumaguete City, he dedicated his life to education and community service. He is survived by his wife Maria, three children, and seven grandchildren.',
        section: 'Garden Section A',
        galleryUrls: [
          'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=400&q=80',
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&q=80',
        ],
        condolences: [
          Condolence(
            name: 'Maria Rodriguez',
            message: 'My deepest condolences to the family. He was a wonderful man.',
            date: DateTime(2024, 1, 16),
          ),
          Condolence(
            name: 'Pedro Gonzales',
            message: 'Rest in peace, sir. You will be greatly missed.',
            date: DateTime(2024, 1, 17),
          ),
        ],
      ),
      Obituary(
        fullName: 'Rosa Maria Fernandez',
        birthDate: DateTime(1952, 8, 23),
        passingDate: DateTime(2024, 2, 3),
        photoUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400&q=80',
        shortTribute: 'A kind soul who touched everyone she met with grace and compassion.',
        fullObituary: 'Rosa Maria Fernandez, beloved mother and grandmother, passed away peacefully at age 71. She was known for her generous spirit and dedication to her family. Her legacy lives on through her children and grandchildren.',
        section: 'Memorial Section B',
        galleryUrls: [
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
        ],
        condolences: [
          Condolence(
            name: 'Ana Santos',
            message: 'She was like a second mother to me. I will miss her dearly.',
            date: DateTime(2024, 2, 4),
          ),
        ],
      ),
      Obituary(
        fullName: 'Manuel Reyes',
        birthDate: DateTime(1938, 3, 15),
        passingDate: DateTime(2024, 3, 10),
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&q=80',
        shortTribute: 'Veteran, grandfather, and pillar of strength for our family.',
        fullObituary: 'Manuel Reyes served his country with honor and raised a beautiful family. His wisdom, humor, and love will forever be remembered by all who knew him.',
        section: 'Veterans Garden',
        galleryUrls: [],
        condolences: [],
      ),
      Obituary(
        fullName: 'Luz Angela Cruz',
        birthDate: DateTime(1960, 11, 8),
        passingDate: DateTime(2024, 3, 22),
        photoUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=400&q=80',
        shortTribute: 'Teacher, friend, and inspiration to many generations.',
        fullObituary: 'Luz Angela Cruz dedicated over 30 years to education, shaping young minds and inspiring countless students. Her passion for teaching and nurturing spirit will never be forgotten.',
        section: 'Peace Garden',
        galleryUrls: [
          'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=400&q=80',
          'https://images.unsplash.com/photo-1524503033411-c9566986fc8f?w=400&q=80',
        ],
        condolences: [
          Condolence(
            name: 'Former Student',
            message: 'Mrs. Cruz changed my life. Thank you for everything.',
            date: DateTime(2024, 3, 23),
          ),
        ],
      ),
    ];
  }

  // ✅ Update obituary (mocked for now)
  Future<void> updateObituary(String id, Obituary updatedObituary) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulate network
    print('Mock updateObituary called for ID: $id');
    print('Updated condolences: ${updatedObituary.condolences}');
  }

  // ✅ Fetch single obituary by ID (optional, for future use)
  Future<Obituary?> fetchObituaryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final obituaries = await fetchObituaries();
    try {
      return obituaries.firstWhere((o) => o.fullName.hashCode.toString() == id);
    } catch (e) {
      return null;
    }
  }
}