document.getElementById("year").textContent = new Date().getFullYear();

const revealEls = document.querySelectorAll("[data-reveal]");
const io = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible");
        io.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.1 }
);
revealEls.forEach((el) => io.observe(el));
