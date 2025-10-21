import { useNavigate } from 'react-router-dom';
import { Button } from './ui/button';
import { ChefHat, Globe, Heart, Users, Star, TrendingUp, Sparkles } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';

export function LandingPage() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-surface">
      {/* Material 3 Header - Elevated Surface */}
      <header className="bg-surface-container-low border-b border-outline-variant sticky top-0 z-50 backdrop-blur-xl">
        <div className="container mx-auto px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-primary flex items-center justify-center shadow-md">
              <ChefHat className="w-6 h-6 text-on-primary" />
            </div>
            <span className="text-2xl font-semibold text-on-surface">
              GlobalFlavors
            </span>
          </div>
          <div className="flex items-center gap-3">
            <Button 
              variant="ghost" 
              onClick={() => navigate('/login')}
              className="text-on-surface hover:bg-surface-container-highest"
            >
              Log In
            </Button>
            <Button 
              onClick={() => navigate('/signup')}
              className="bg-primary text-on-primary hover:bg-primary/90 shadow-md rounded-full px-6"
            >
              Get Started
            </Button>
          </div>
        </div>
      </header>

      {/* Hero Section - Material 3 Layout */}
      <section className="container mx-auto px-6 py-20 lg:py-28">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          <div className="space-y-8">
            <div className="inline-flex items-center gap-2 px-4 py-2 bg-primary-container rounded-full">
              <Sparkles className="w-4 h-4 text-on-primary-container" />
              <span className="text-on-primary-container">Discover World Cuisines</span>
            </div>
            <h1 className="text-5xl lg:text-6xl font-bold leading-tight text-on-surface">
              Explore Recipes from{' '}
              <span className="text-primary">
                Around the World
              </span>
            </h1>
            <p className="text-xl text-on-surface-variant leading-relaxed">
              Join thousands of food lovers discovering authentic recipes, sharing culinary adventures, 
              and connecting with chefs worldwide.
            </p>
            <div className="flex flex-wrap gap-4 pt-4">
              <Button 
                size="lg"
                onClick={() => navigate('/signup')}
                className="bg-primary text-on-primary hover:bg-primary/90 shadow-lg rounded-full px-8 h-14"
              >
                Start Cooking Free
              </Button>
              <Button 
                size="lg" 
                variant="outline"
                onClick={() => navigate('/login')}
                className="border-outline text-on-surface hover:bg-surface-container-highest rounded-full px-8 h-14"
              >
                Browse Recipes
              </Button>
            </div>
            <div className="flex items-center gap-8 pt-6">
              <div className="flex -space-x-3">
                {[1, 2, 3, 4].map((i) => (
                  <div 
                    key={i} 
                    className="w-12 h-12 rounded-full bg-tertiary-container border-4 border-surface flex items-center justify-center"
                  >
                    <span className="text-on-tertiary-container">👤</span>
                  </div>
                ))}
              </div>
              <div>
                <p className="text-sm text-on-surface-variant">Joined by</p>
                <p className="font-semibold text-on-surface">10,000+ home chefs</p>
              </div>
            </div>
          </div>
          <div className="relative">
            <div className="absolute inset-0 bg-primary/20 rounded-[28px] blur-3xl"></div>
            <div className="relative bg-surface-container-high rounded-[28px] overflow-hidden shadow-lg border border-outline-variant">
              <ImageWithFallback 
                src="https://images.unsplash.com/photo-1514025224826-8d3c22eecd02?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmb29kJTIwcmVjaXBlJTIwZGlzaHxlbnwxfHx8fDE3NjEwMTY0ODR8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral"
                alt="Delicious food"
                className="w-full h-[550px] object-cover"
              />
            </div>
          </div>
        </div>
      </section>

      {/* Features Section - Material 3 Cards */}
      <section className="py-20 lg:py-28 bg-surface-container-lowest">
        <div className="container mx-auto px-6">
          <div className="text-center max-w-3xl mx-auto mb-16">
            <h2 className="text-4xl font-bold mb-4 text-on-surface">Why Choose GlobalFlavors?</h2>
            <p className="text-xl text-on-surface-variant">
              Everything you need to explore, create, and share amazing recipes from cultures worldwide
            </p>
          </div>
          <div className="grid md:grid-cols-3 gap-6">
            <div className="bg-surface-container-low rounded-[28px] p-8 border border-outline-variant hover:shadow-lg transition-all hover:bg-surface-container">
              <div className="w-14 h-14 rounded-full bg-primary-container flex items-center justify-center mb-6">
                <Globe className="w-7 h-7 text-on-primary-container" />
              </div>
              <h3 className="text-xl font-semibold mb-3 text-on-surface">Global Cuisine Library</h3>
              <p className="text-on-surface-variant leading-relaxed">
                Access thousands of authentic recipes from over 50 countries and cultures
              </p>
            </div>
            <div className="bg-surface-container-low rounded-[28px] p-8 border border-outline-variant hover:shadow-lg transition-all hover:bg-surface-container">
              <div className="w-14 h-14 rounded-full bg-secondary-container flex items-center justify-center mb-6">
                <Heart className="w-7 h-7 text-on-secondary-container" />
              </div>
              <h3 className="text-xl font-semibold mb-3 text-on-surface">Personalized Experience</h3>
              <p className="text-on-surface-variant leading-relaxed">
                Get recipe recommendations based on your dietary preferences and skill level
              </p>
            </div>
            <div className="bg-surface-container-low rounded-[28px] p-8 border border-outline-variant hover:shadow-lg transition-all hover:bg-surface-container">
              <div className="w-14 h-14 rounded-full bg-tertiary-container flex items-center justify-center mb-6">
                <Users className="w-7 h-7 text-on-tertiary-container" />
              </div>
              <h3 className="text-xl font-semibold mb-3 text-on-surface">Vibrant Community</h3>
              <p className="text-on-surface-variant leading-relaxed">
                Connect with food lovers, share tips, and learn from experienced chefs
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* Stats Section - Material 3 Filled */}
      <section className="py-20 lg:py-28 bg-primary">
        <div className="container mx-auto px-6">
          <div className="grid md:grid-cols-3 gap-12 text-center text-on-primary">
            <div>
              <div className="flex items-center justify-center mb-4">
                <Star className="w-10 h-10 fill-on-primary" />
              </div>
              <p className="text-5xl font-bold mb-3">4.9/5</p>
              <p className="text-lg text-on-primary/80">Average Recipe Rating</p>
            </div>
            <div>
              <div className="flex items-center justify-center mb-4">
                <ChefHat className="w-10 h-10" />
              </div>
              <p className="text-5xl font-bold mb-3">50K+</p>
              <p className="text-lg text-on-primary/80">Recipes Shared</p>
            </div>
            <div>
              <div className="flex items-center justify-center mb-4">
                <TrendingUp className="w-10 h-10" />
              </div>
              <p className="text-5xl font-bold mb-3">1M+</p>
              <p className="text-lg text-on-primary/80">Meals Cooked Monthly</p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section - Material 3 */}
      <section className="py-20 lg:py-28">
        <div className="container mx-auto px-6">
          <div className="max-w-4xl mx-auto bg-primary-container rounded-[28px] p-12 lg:p-16 text-center border border-outline-variant">
            <h2 className="text-4xl lg:text-5xl font-bold mb-6 text-on-primary-container">
              Ready to Start Your Culinary Journey?
            </h2>
            <p className="text-xl text-on-primary-container/80 mb-10 leading-relaxed">
              Join GlobalFlavors today and discover recipes that will transform your cooking
            </p>
            <Button 
              size="lg"
              onClick={() => navigate('/signup')}
              className="bg-primary text-on-primary hover:bg-primary/90 shadow-lg rounded-full px-10 h-14"
            >
              Create Free Account
            </Button>
          </div>
        </div>
      </section>

      {/* Material 3 Footer */}
      <footer className="border-t border-outline-variant py-8 bg-surface-container-low">
        <div className="container mx-auto px-6">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-lg bg-primary flex items-center justify-center">
                <ChefHat className="w-5 h-5 text-on-primary" />
              </div>
              <span className="font-semibold text-on-surface">GlobalFlavors</span>
            </div>
            <p className="text-sm text-on-surface-variant">
              © 2025 GlobalFlavors. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
