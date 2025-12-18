document.addEventListener('DOMContentLoaded', () => {
    const backgroundMusic = document.getElementById('bg-music');
    const volumeSlider = document.getElementById('volume-slider');
    const playPauseBtn = document.getElementById('play-pause-btn');
    const muteBtn = document.getElementById('mute-btn');

    // Only run the script if all music player elements are found on the page
    if (backgroundMusic && volumeSlider && playPauseBtn && muteBtn) {

        // --- FADE-IN LOGIC ---
        const targetVolume = volumeSlider.value / 100;
        backgroundMusic.volume = 0; // Start at 0 for fade-in

        const fadeInAudio = () => {
            const fadeDuration = 2000; // 2 seconds
            const fadeInterval = 50;
            const volumeStep = targetVolume / (fadeDuration / fadeInterval);

            const fade = setInterval(() => {
                if (backgroundMusic.volume + volumeStep < targetVolume) {
                    backgroundMusic.volume += volumeStep;
                } else {
                    backgroundMusic.volume = targetVolume;
                    clearInterval(fade);
                }
            }, fadeInterval);
        };

        // Use { once: true } so the fade-in only happens the first time.
        backgroundMusic.addEventListener('play', fadeInAudio, { once: true });

        // --- PLAYER CONTROLS ---
        volumeSlider.addEventListener('input', (e) => {
            backgroundMusic.volume = e.target.value / 100;
            backgroundMusic.muted = false;
            muteBtn.textContent = '🔊';
        });

        playPauseBtn.addEventListener('click', () => {
            if (backgroundMusic.paused) {
                backgroundMusic.play();
                playPauseBtn.textContent = '❚❚';
            } else {
                backgroundMusic.pause();
                playPauseBtn.textContent = '▶';
            }
        });

        muteBtn.addEventListener('click', () => {
            backgroundMusic.muted = !backgroundMusic.muted;
            muteBtn.textContent = backgroundMusic.muted ? '🔇' : '🔊';
        });

        // --- AUTOPLAY HANDLING ---
        const playPromise = backgroundMusic.play();
        if (playPromise !== undefined) {
            playPromise.catch(error => {
                console.log("Autoplay was prevented. Waiting for user interaction.");
                playPauseBtn.textContent = '▶';
            });
        }

        // --- FADE-OUT ON NAVIGATION ---
        const fadeOutAudioAndNavigate = (destinationUrl) => {
            document.body.style.animation = 'pageFadeOut 0.5s ease-in-out forwards';
            const fadeDuration = 500; // 0.5s
            setTimeout(() => {
                window.location.href = destinationUrl;
            }, fadeDuration);
        };

        document.querySelectorAll('a').forEach(link => {
            link.addEventListener('click', (e) => {
                // Only apply the fade-out for links that navigate away from the page.
                // Ignore in-page anchor links (that start with '#').
                if (link.getAttribute('href') && !link.getAttribute('href').startsWith('#')) {
                    e.preventDefault(); // Stop immediate navigation
                    fadeOutAudioAndNavigate(link.href);
                }
            });
        });

        // --- BFCACHE (BACK/FORWARD CACHE) HANDLING ---
        // Reset page state if it's loaded from the back/forward cache
        window.addEventListener('pageshow', (event) => {
            if (event.persisted) {
                document.body.style.animation = ''; // Remove the fade-out animation
            }
        });
    }
});