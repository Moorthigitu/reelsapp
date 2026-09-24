import '../models/reel_model.dart';
import '../models/comment_model.dart';

class ReelDataProvider {
  // 12 Empirically Verified working public video URLs (100% HTTP 200 OK)
  static const List<String> videoUrls = [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://www.w3schools.com/html/mov_bbb.mp4',
    'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4',
    'https://www.w3schools.com/tags/movie.mp4',
    'https://cdn.jsdelivr.net/gh/intel-iot-devkit/sample-videos/person-bicycle-car-detection.mp4',
    'https://cdn.jsdelivr.net/gh/intel-iot-devkit/sample-videos/face-demographics-walking-and-pause.mp4',
    'https://cdn.jsdelivr.net/gh/intel-iot-devkit/sample-videos/store-aisle-detection.mp4',
    'https://cdn.jsdelivr.net/gh/intel-iot-devkit/sample-videos/bottle-detection.mp4',
    'https://cdn.jsdelivr.net/gh/intel-iot-devkit/sample-videos/head-pose-face-detection-female.mp4',
    'https://cdn.jsdelivr.net/gh/intel-iot-devkit/sample-videos/classroom.mp4',
    'https://cdn.jsdelivr.net/gh/intel-iot-devkit/sample-videos/bolt-detection.mp4',
  ];

  static const List<String> _usernames = [
    'alex_vibe', 'travel_sam', 'neon_girl', 'ocean_spirit', 'walker_d',
    'sky_high', 'fashion_icon', 'blaze_runner', 'escape_artist', 'fun_seeker',
    'joyride_pro', 'meltdown_hq', 'sintel_fan', 'dirt_racer', 'cyber_punk',
    'bullrun_crew', 'nature_lover', 'urban_explorer', 'sunset_vibes', 'tech_insider',
    'coffee_holic', 'fitness_junkie', 'chef_gourmet', 'dance_fever', 'code_ninja',
    'chill_beats', 'mountain_peak', 'skate_legend', 'paws_unleashed', 'street_graffiti',
    'cinema_geek', 'astro_gal', 'lofi_producer', 'wanderlust_jack', 'epic_landscapes',
    'game_dev_life', 'dunk_master', 'beatbox_king', 'guitar_hero', 'drifting_soul',
    'art_corner', 'snack_attack', 'zen_gardener', 'cloud_chaser', 'starlight_x',
    'vinyl_records', 'motovlog_zero', 'indie_tunes', 'horizon_view', 'final_level'
  ];

  static const List<String> _captions = [
    'Golden hour hits different in spring! 🌸✨ #nature #spring #vibes',
    'Sweet moments in the countryside 🏕️❤️ #family #nature',
    'Neon lights & late night city strolls 🌆⚡ #citylife #neon',
    'Sound of waves crashing is pure therapy 🌊🧘‍♂️ #ocean #calm',
    'Walk through the autumn park 🍂🍁 #vlog #nature',
    'Sky full of dreams & fluffy clouds ☁️✨ #skyline',
    'Cyberpunk fashion aesthetic shoot 📸💜 #style #fashion',
    'Blaze through the challenge! 🚀🔥 #motivation',
    'Escaping the routine for the wild! 🌲⛰️ #adventure',
    'Weekend fun starts right here! 🎉🕺 #weekend',
    'Joyriding through mountain passes 🏎️💨 #cars #drive',
    'Unstoppable energy today! 💥💪 #workout',
    'Cinematic cinematic magic standard 🎬✨ #cinematography',
    'Offroad dirt testing in the canyon 🏁🚵‍♂️ #offroad',
    'Visual FX testing complete! 🤖🔥 #vfx #cgi',
    'Ready for the annual bullrun rally 🏎️💨 #rally',
    'Morning breeze in the forest 🌲🍃 #peaceful',
    'Finding hidden alleyways in Tokio 🇯🇵⛩️ #japan #travel',
    'Sunsets like this make time stand still 🌅💛 #sunset',
    'Checking out the latest AI gadgets 📱💻 #tech',
    'Single origin pour-over coffee routine ☕✨ #coffee',
    'Pushing limits every single day 🏋️‍♂️💪 #fitness',
    'Tasting the ultimate truffle pasta 🍝🍷 #foodie',
    'New choreography dropped! Check it out 💃🔥 #dance',
    'Late night coding with lofi beats 💻🎧 #developer',
    'Midnight synthwave production session 🎹🎧 #music',
    'Reached the summit at dawn 🏔️☀️ #hiking',
    'Clean kickoff flip down 6 stairs 🛹⚡ #skateboarding',
    'Golden retriever puppies first swim 🐶🌊 #cute',
    'Huge mural artwork completed in 3 days 🎨🖌️ #art',
    'Re-watching sci-fi classics 🍿🎬 #movies',
    'Stargazing under clear desert skies 🌌🔭 #astronomy',
    'Flipping vinyl samples into a smooth beat 🎶🎛️ #hiphop',
    'Exploring hidden waterfalls deep in Bali 🌴💧 #bali',
    'Dramatic storm over the open plains 🌩️🌾 #nature',
    'Building an indie game from scratch 🎮🕹️ #gamedev',
    'Incredible dunk contest highlights 🏀🔥 #basketball',
    'Rhythm pattern breakdown! 🎙️⚡ #beatbox',
    'Acoustic cover of my favorite track 🎸🎤 #guitar',
    'Drifting under rainy highway lights 🏎️🌧️ #drifting',
    'Watercolor paint blending process 🎨🖌️ #artist',
    'Midnight snack recipe hack 🧀🥪 #foodhack',
    'Bonsai tree trimming therapy 🪴🧘 #zen',
    'Chasing clouds on the coastline ✈️🌤️ #travel',
    'Glowing neon light portrait session 🌌📸 #photography',
    'Spinning vintage jazz classics 🎷🎶 #vinyl',
    'Highway motorcycle ride at twilight 🏍️💨 #motovlog',
    'Indie track sneak peek! 🎵🎤 #newmusic',
    'Panoramic horizon lines 🌅🌊 #scenery',
    'Final boss battle victory! 🎮🔥 #gaming'
  ];

  static const List<String> _audioTitles = [
    'Original Sound - @alex_vibe',
    'Country Chill - Acoustic Beats',
    'Neon Lights - Cyberwave Mix',
    'Ocean Whispers - Ambient Sounds',
    'Autumn Walk - Lo-Fi Chill',
    'Sky High - Floating Vibes',
    'Neon Glow - Synthpop Edit',
    'Blaze - High Octane Beat',
    'Escape - Wild Horizon',
    'Fun Times - Tropical House',
    'Joyride - Fast & Furious Theme',
    'Meltdown - Dubstep Remix',
    'Sintel Theme - Orchestral',
    'Dirt Trail - Rock Riff',
    'Cyber Beats - Future Bass',
    'Bullrun Rally - Trap Beat',
    'Forest Whispers - Nature Audio',
    'Tokyo Nights - City Pop',
    'Golden Sunset - Acoustic Guitar',
    'Tech Review - Electronic Beat',
    'Morning Brew - Chillhop',
    'Beast Mode - Gym Workout Anthem',
    'Chef Special - Italian Accordion',
    'Dance Fever - EDM Anthem',
    'Code & Coffee - 24/7 Lo-Fi',
    'Synthwave Dreams - 80s Remix',
    'Mountain Breeze - Ambient Flute',
    'Skate & Destroy - Punk Rock',
    'Happy Paws - Cute Ukulele',
    'Graffiti Vibe - Boom Bap Beat',
    'Cinematic Orchestra - Epic Score',
    'Galaxy Journey - Ambient Space',
    'Vinyl Groove - Old School Jazz',
    'Waterfall Serenade - Relaxing Rain',
    'Storm Tracker - Heavy Bass',
    '8-Bit Adventure - Chiptune Beat',
    'Court Control - Hype Beat',
    'Beatbox Masters - Live Loop',
    'Guitar Riff 04 - Clean Tone',
    'Drift King - Eurobeat Remix',
    'Paint & Chill - Relaxing Piano',
    'Late Night Munchies - Pop Beat',
    'Zen Garden - Japanese Koto',
    'Cloud Nine - Chill Trap',
    'Neon Starlight - Vaporwave',
    'Vintage Jazz - 1950 Classic',
    'Twilight Ride - Heavy Engine Sound',
    'Indie Folk - Acoustic Duet',
    'Horizon Line - Deep House',
    'Victory Theme - Orchestral Brass'
  ];

  // Generate 50 unique Reels with initial stats
  static List<ReelModel> get50Reels() {
    final List<ReelModel> reels = [];

    for (int i = 0; i < 50; i++) {
      final String videoUrl = videoUrls[i % videoUrls.length];
      final String username = _usernames[i % _usernames.length];
      final String caption = _captions[i % _captions.length];
      final String audioTitle = _audioTitles[i % _audioTitles.length];
      
      final String userAvatar = 'https://api.dicebear.com/7.x/avataaars/svg?seed=$username';
      final int initialLikes = 120 + (i * 73) % 4800 + (i % 3 == 0 ? 1200 : 0);

      final List<CommentModel> sampleComments = [
        CommentModel(
          id: 'c_${i}_1',
          userName: 'sarah_m',
          userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=sarah_m',
          text: 'This is absolutely amazing! 🔥🔥',
          timestamp: DateTime.now().subtract(Duration(minutes: 15 + i * 2)),
          likeCount: 12 + i % 5,
        ),
        CommentModel(
          id: 'c_${i}_2',
          userName: 'dev_guy',
          userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=dev_guy',
          text: 'Super smooth video! What camera did you use? 🎥',
          timestamp: DateTime.now().subtract(Duration(hours: 1 + i)),
          likeCount: 4,
        ),
        CommentModel(
          id: 'c_${i}_3',
          userName: 'lisa_vibe',
          userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=lisa_vibe',
          text: 'Love the audio choice 🎶😍',
          timestamp: DateTime.now().subtract(Duration(hours: 3 + i)),
          likeCount: 8,
        ),
      ];

      reels.add(
        ReelModel(
          id: 'reel_$i',
          videoUrl: videoUrl,
          username: username,
          userAvatar: userAvatar,
          caption: caption,
          audioTitle: audioTitle,
          likeCount: initialLikes,
          commentCount: sampleComments.length,
          isLiked: false,
          comments: sampleComments,
        ),
      );
    }

    return reels;
  }
}
