<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JOY-RIDE - Bike Rental & Ride Sharing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

<!-- Header (Navigation Bar) -->
<nav class="bg-[#f76b64] shadow-lg">
    <div class="container mx-auto px-6 py-4 flex justify-between items-center">
        <!-- Logo -->
        <a href="#" class="text-4xl font-extrabold text-black">JOY-RIDE</a>

        <!-- Search Bar -->
        <div class="hidden lg:flex items-center w-full max-w-lg">
            <input type="text" placeholder="Search bikes or rides..." class="w-full px-4 py-2 rounded-l-lg focus:outline-none" />
            <button class="bg-white text-[#f76b64] px-4 py-2 rounded-r-lg hover:bg-gray-200 transition">Search</button>
        </div>

        <!-- Navigation Links -->
        <ul class="hidden lg:flex space-x-6">
            <li><a href="#" class="text-white hover:underline">Home</a></li>
            <li><a href="#" class="text-white hover:underline">About</a></li>
            <li><a href="#" class="text-white hover:underline">Services</a></li>
            <li><a href="#" class="text-white hover:underline">Bikes</a></li>
            <li><a href="#" class="text-white hover:underline">Contact</a></li>
        </ul>

        <!-- Authentication Buttons -->
        <div class="hidden lg:flex items-center gap-4">
            <a href="#" class="text-white hover:underline">Login</a>
            <a href="#" class="bg-white text-[#f76b64] px-4 py-2 rounded-lg hover:bg-gray-200 transition">Sign Up</a>
        </div>

        <!-- Mobile Menu Button -->
        <button id="menu-toggle" class="lg:hidden text-white focus:outline-none">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"></path>
            </svg>
        </button>
    </div>

    <!-- Mobile Menu -->
    <div id="mobile-menu" class="lg:hidden hidden bg-[#f76b64] p-4 space-y-4">
        <input type="text" placeholder="Search..." class="w-full px-4 py-2 rounded-lg focus:outline-none" />
        <a href="#" class="block text-white hover:underline">Home</a>
        <a href="#" class="block text-white hover:underline">About</a>
        <a href="#" class="block text-white hover:underline">Services</a>
        <a href="#" class="block text-white hover:underline">Bikes</a>
        <a href="#" class="block text-white hover:underline">Contact</a>
        <a href="#" class="block text-white hover:underline">Login</a>
        <a href="#" class="block bg-white text-[#f76b64] text-center px-4 py-2 rounded-lg hover:bg-gray-200 transition">Sign Up</a>
    </div>
</nav>

<section id="hero" class="relative bg-cover bg-center bg-no-repeat py-40 text-white transition-all duration-1000">
    <div class="absolute inset-0 bg-black opacity-50"></div>

    <div class="container mx-auto px-6 relative z-10 flex flex-col lg:flex-row items-center justify-between">
        <div class="max-w-2xl mb-12 lg:mb-0">
            <h1 class="text-5xl font-extrabold mb-6">Bike Rental and Ride Sharing Platform</h1>
            <p class="text-lg mb-8">JOY-RIDE offers a seamless, user-friendly experience. Our intuitive platform ensures smooth ride bookings, efficient fleet management, and hassle-free operations—keeping your service on the move.</p>
            <a href="#" class="bg-[#f76b64] text-white px-8 py-3 rounded-lg text-lg font-bold hover:bg-[#fa8a76] transition">Book a Ride</a>
        </div>

    </div>
</section>

<script>
    const images = [
        'images/1.jpg',
        'images/2.jpg',
        'images/3.jpg'
    ];
    let index = 0;
    const heroSection = document.getElementById('hero');

    function changeBackground() {
        heroSection.style.backgroundImage = `url('${images[index]}')`;
        index = (index + 1) % images.length;
    }

    setInterval(changeBackground, 6000);
    changeBackground(); // Initial call to set the first image
</script>

<!-- Featured Bikes & Ride Options -->
<section class="container mx-auto px-6 py-16">
    <h2 class="text-3xl font-bold text-center mb-8">Featured Bikes & Ride Options</h2>
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div class="bg-white shadow-lg rounded-lg overflow-hidden flex flex-col">
            <div class="h-60 overflow-hidden">
                <img src="images/6.jpg" alt="Electric Scooter" class="w-full h-full object-cover">
            </div>
            <div class="p-4 flex flex-col flex-grow">
                <h3 class="text-xl font-semibold">Electric Scooter</h3>
                <p class="text-gray-700 mt-2 flex-grow">Electric bike for a smooth ride.</p>
                <a href="#" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg mt-4 text-lg font-bold hover:bg-[#fa8a76] transition inline-block text-center">Rent Now</a>
            </div>
        </div>

        <div class="bg-white shadow-lg rounded-lg overflow-hidden flex flex-col">
            <div class="h-60 overflow-hidden">
                <img src="images/5.jpg" alt="Scooter-Dio" class="w-full h-full object-cover">
            </div>
            <div class="p-4 flex flex-col flex-grow">
                <h3 class="text-xl font-semibold">Scooter-Dio</h3>
                <p class="text-gray-700 mt-2 flex-grow">Classic scooter for urban commuting.</p>
                <a href="#" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg mt-4 text-lg font-bold hover:bg-[#fa8a76] transition inline-block text-center">Rent Now</a>
            </div>
        </div>

        <div class="bg-white shadow-lg rounded-lg overflow-hidden flex flex-col">
            <div class="h-60 overflow-hidden">
                <img src="images/4.jpg" alt="Motor Bike" class="w-full h-full object-cover">
            </div>
            <div class="p-4 flex flex-col flex-grow">
                <h3 class="text-xl font-semibold">Motor Bike</h3>
                <p class="text-gray-700 mt-2 flex-grow">Standard bike for all-purpose use.</p>
                <a href="#" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg mt-4 text-lg font-bold hover:bg-[#fa8a76] transition inline-block text-center">Rent Now</a>
            </div>
        </div>
    </div>
</section>
<script>
    const menuToggle = document.getElementById('menu-toggle');
    const mobileMenu = document.getElementById('mobile-menu');

    menuToggle.addEventListener('click', () => {
        mobileMenu.classList.toggle('hidden');
    });
</script>

<!-- Footer Section -->
<footer class="bg-[#f76b64] text-white py-8">
    <div class="container mx-auto px-6 flex flex-col md:flex-row justify-between items-center">
        <!-- Quick Links -->
        <div class="mb-6 md:mb-0">
            <h3 class="font-semibold text-lg">Quick Links</h3>
            <ul class="mt-4">
                <li><a href="#" class="hover:underline">About Us</a></li>
                <li><a href="#" class="hover:underline">Privacy Policy</a></li>
                <li><a href="#" class="hover:underline">Terms & Conditions</a></li>
            </ul>
        </div>

        <!-- Contact Info -->
        <div class="mb-6 md:mb-0">
            <h3 class="font-semibold text-lg">Contact Info</h3>
            <ul class="mt-4">
                <p>Whatsapp</p>
                <li><a href="tel:+94703983620" class="hover:underline">+94703983620</a></li>
            </ul>
        </div>

        <!-- Copyright Notice -->
        <div class="text-center md:text-right mt-6 md:mt-0">
            <p>&copy; 2025 JOY-RIDE. All rights reserved.</p>
        </div>
    </div>
</footer>

</body>
</html>
