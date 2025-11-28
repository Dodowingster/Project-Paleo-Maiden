document.addEventListener('DOMContentLoaded', () => {
    // --- Smooth Scrolling for Anchor Links ---
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            // Prevent the default instant jump behavior
            e.preventDefault();

            const href = this.getAttribute('href');
            const targetId = href.substring(1); // Remove the '#'
            const targetElement = document.getElementById(targetId);

            if (targetElement) {
                // Scroll to the element smoothly
                targetElement.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });

    // --- Floating Table of Contents Toggle ---
    const tocContainer = document.getElementById('floating-toc-container');
    const tocToggleBtn = document.getElementById('toc-toggle-btn');

    if (tocContainer && tocToggleBtn) {
        tocToggleBtn.addEventListener('click', (e) => {
            e.stopPropagation(); // Prevent click from closing the menu immediately
            tocContainer.classList.toggle('active');
        });

        // Close the menu if you click anywhere else on the page
        document.addEventListener('click', (e) => {
            if (tocContainer.classList.contains('active') && !tocContainer.contains(e.target)) {
                tocContainer.classList.remove('active');
            }
        });
    }
});