import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { Button } from './ui/button';
import { Input } from './ui/input';
import { Badge } from './ui/badge';
import { Avatar, AvatarFallback } from './ui/avatar';
import { 
  ChefHat, 
  Search, 
  Heart, 
  Clock, 
  Star,
  Filter,
  LogOut,
  Settings,
  BookMarked,
  TrendingUp,
  Flame
} from 'lucide-react';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from './ui/dropdown-menu';
import { ImageWithFallback } from './figma/ImageWithFallback';

const MOCK_RECIPES = [
  {
    id: '1',
    title: 'Authentic Italian Carbonara',
    image: 'https://images.unsplash.com/photo-1722938687754-d77c159da3c8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxwYXN0YSUyMGRpc2glMjBmb29kfGVufDF8fHx8MTc2MDk5OTQzMHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    rating: 4.8,
    reviews: 234,
    cookTime: '25 min',
    difficulty: 'Intermediate',
    cuisine: 'Italian',
    author: 'Maria Romano',
    authorInitials: 'MR',
    saved: false,
  },
  {
    id: '2',
    title: 'Thai Green Curry',
    image: 'https://images.unsplash.com/photo-1514025224826-8d3c22eecd02?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmb29kJTIwcmVjaXBlJTIwZGlzaHxlbnwxfHx8fDE3NjEwMTY0ODR8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    rating: 4.9,
    reviews: 189,
    cookTime: '40 min',
    difficulty: 'Advanced',
    cuisine: 'Thai',
    author: 'Chef Somchai',
    authorInitials: 'CS',
    saved: true,
  },
  {
    id: '3',
    title: 'Mediterranean Buddha Bowl',
    image: 'https://images.unsplash.com/photo-1627279001674-4c7dbd9edb88?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzYWxhZCUyMGhlYWx0aHklMjBib3dsfGVufDF8fHx8MTc2MDk5NDE0NHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    rating: 4.7,
    reviews: 156,
    cookTime: '20 min',
    difficulty: 'Beginner',
    cuisine: 'Mediterranean',
    author: 'Elena Costa',
    authorInitials: 'EC',
    saved: false,
  },
  {
    id: '4',
    title: 'Classic French Croissants',
    image: 'https://images.unsplash.com/photo-1707569859750-b1a954a9de3d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxkZXNzZXJ0JTIwY2FrZSUyMHN3ZWV0fGVufDF8fHx8MTc2MDk3MjU5OHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    rating: 4.9,
    reviews: 312,
    cookTime: '3 hours',
    difficulty: 'Expert',
    cuisine: 'French',
    author: 'Pierre Dubois',
    authorInitials: 'PD',
    saved: true,
  },
  {
    id: '5',
    title: 'Healthy Breakfast Bowl',
    image: 'https://images.unsplash.com/photo-1564636242997-77953084df48?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxoZWFsdGh5JTIwbWVhbCUyMHBsYXRlfGVufDF8fHx8MTc2MDk2MjYxOHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    rating: 4.6,
    reviews: 98,
    cookTime: '15 min',
    difficulty: 'Beginner',
    cuisine: 'American',
    author: 'Sarah Johnson',
    authorInitials: 'SJ',
    saved: false,
  },
  {
    id: '6',
    title: 'Homemade Ramen Bowl',
    image: 'https://images.unsplash.com/photo-1590759485285-0e5c13ebba50?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjb29raW5nJTIwaW5ncmVkaWVudHMlMjBraXRjaGVufGVufDF8fHx8MTc2MDk3NDUwNXww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral',
    rating: 4.8,
    reviews: 267,
    cookTime: '1.5 hours',
    difficulty: 'Advanced',
    cuisine: 'Japanese',
    author: 'Kenji Tanaka',
    authorInitials: 'KT',
    saved: false,
  },
];

const FILTER_CATEGORIES = [
  { id: 'all', label: 'All Recipes', icon: ChefHat },
  { id: 'trending', label: 'Trending', icon: Flame },
  { id: 'saved', label: 'Saved', icon: BookMarked },
];

export function DashboardPage() {
  const navigate = useNavigate();
  const { user, logout } = useAuth();
  const [searchQuery, setSearchQuery] = useState('');
  const [activeFilter, setActiveFilter] = useState('all');
  const [recipes, setRecipes] = useState(MOCK_RECIPES);

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  const toggleSave = (recipeId: string) => {
    setRecipes(prev => prev.map(recipe => 
      recipe.id === recipeId ? { ...recipe, saved: !recipe.saved } : recipe
    ));
  };

  const filteredRecipes = recipes.filter(recipe => {
    if (activeFilter === 'saved' && !recipe.saved) return false;
    if (searchQuery) {
      return recipe.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
             recipe.cuisine.toLowerCase().includes(searchQuery.toLowerCase());
    }
    return true;
  });

  return (
    <div className="min-h-screen bg-surface">
      {/* Material 3 App Bar */}
      <header className="bg-surface-container-low border-b border-outline-variant sticky top-0 z-50 backdrop-blur-xl">
        <div className="container mx-auto px-6 py-4">
          <div className="flex items-center justify-between gap-6">
            {/* Logo */}
            <div className="flex items-center gap-3">
              <div className="w-11 h-11 rounded-[14px] bg-primary flex items-center justify-center shadow-md">
                <ChefHat className="w-6 h-6 text-on-primary" />
              </div>
              <span className="text-xl font-semibold text-on-surface hidden sm:block">GlobalFlavors</span>
            </div>

            {/* Material 3 Search Bar */}
            <div className="flex-1 max-w-xl">
              <div className="relative">
                <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-on-surface-variant" />
                <Input
                  type="search"
                  placeholder="Search recipes, cuisines..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-12 h-12 rounded-full bg-surface-container-highest border-outline-variant text-on-surface placeholder:text-on-surface-variant focus:border-primary"
                />
              </div>
            </div>

            {/* User Menu */}
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <button className="flex items-center gap-3 hover:bg-surface-container-highest rounded-[16px] p-2 pr-4 transition-colors">
                  <Avatar className="w-11 h-11">
                    <AvatarFallback className="bg-primary text-on-primary">
                      {user?.name?.charAt(0).toUpperCase() || 'U'}
                    </AvatarFallback>
                  </Avatar>
                  <div className="text-left hidden lg:block">
                    <p className="text-sm font-semibold text-on-surface">{user?.name || 'User'}</p>
                    <p className="text-xs text-on-surface-variant">{user?.skillLevel || 'Chef'}</p>
                  </div>
                </button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-56 bg-surface-container-high border-outline-variant rounded-[16px]">
                <DropdownMenuLabel className="text-on-surface">My Account</DropdownMenuLabel>
                <DropdownMenuSeparator className="bg-outline-variant" />
                <DropdownMenuItem className="text-on-surface hover:bg-surface-container-highest rounded-lg">
                  <Settings className="w-4 h-4 mr-3" />
                  Settings
                </DropdownMenuItem>
                <DropdownMenuItem className="text-on-surface hover:bg-surface-container-highest rounded-lg">
                  <BookMarked className="w-4 h-4 mr-3" />
                  Saved Recipes
                </DropdownMenuItem>
                <DropdownMenuSeparator className="bg-outline-variant" />
                <DropdownMenuItem onClick={handleLogout} className="text-error hover:bg-error-container rounded-lg">
                  <LogOut className="w-4 h-4 mr-3" />
                  Log Out
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="container mx-auto px-6 py-8">
        {/* Welcome Section */}
        <div className="mb-10">
          <h1 className="text-4xl font-bold mb-3 text-on-surface">
            Welcome back, {user?.name?.split(' ')[0] || 'Chef'}! 👋
          </h1>
          <p className="text-lg text-on-surface-variant">
            Discover new recipes tailored to your preferences
          </p>
        </div>

        {/* Material 3 Preferences Card */}
        {(user?.dietaryPreferences?.length || user?.cuisinePreferences?.length) && (
          <div className="bg-surface-container-low rounded-[24px] p-6 mb-8 border border-outline-variant shadow-sm">
            <div className="flex items-center justify-between mb-4">
              <h3 className="font-semibold text-on-surface">Your Preferences</h3>
              <Button 
                variant="ghost" 
                size="sm" 
                onClick={() => navigate('/onboarding')}
                className="text-primary hover:bg-primary-container hover:text-on-primary-container rounded-full"
              >
                Edit
              </Button>
            </div>
            <div className="flex flex-wrap gap-2">
              {user.dietaryPreferences?.map((pref) => (
                <Badge key={pref} className="bg-primary-container text-on-primary-container border-0 px-3 py-1.5 rounded-full">
                  {pref}
                </Badge>
              ))}
              {user.cuisinePreferences?.map((cuisine) => (
                <Badge key={cuisine} className="bg-secondary-container text-on-secondary-container border-0 px-3 py-1.5 rounded-full">
                  {cuisine}
                </Badge>
              ))}
            </div>
          </div>
        )}

        {/* Material 3 Filter Chips */}
        <div className="flex items-center gap-3 mb-8 overflow-x-auto pb-2">
          {FILTER_CATEGORIES.map((category) => {
            const Icon = category.icon;
            const isActive = activeFilter === category.id;
            return (
              <button
                key={category.id}
                onClick={() => setActiveFilter(category.id)}
                className={`flex items-center gap-2 px-5 py-3 rounded-full whitespace-nowrap transition-all ${
                  isActive
                    ? 'bg-primary text-on-primary shadow-md'
                    : 'bg-surface-container text-on-surface border border-outline-variant hover:bg-surface-container-high'
                }`}
              >
                <Icon className="w-5 h-5" />
                {category.label}
              </button>
            );
          })}
          <Button 
            variant="outline" 
            size="sm" 
            className="ml-auto rounded-full border-outline text-on-surface hover:bg-surface-container-highest"
          >
            <Filter className="w-4 h-4 mr-2" />
            Filters
          </Button>
        </div>

        {/* Material 3 Recipe Grid */}
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredRecipes.map((recipe) => (
            <div 
              key={recipe.id} 
              className="bg-surface-container-low rounded-[24px] overflow-hidden border border-outline-variant hover:shadow-lg transition-all group"
            >
              {/* Recipe Image */}
              <div className="relative aspect-video overflow-hidden bg-surface-container">
                <ImageWithFallback
                  src={recipe.image}
                  alt={recipe.title}
                  className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
                />
                <button
                  onClick={() => toggleSave(recipe.id)}
                  className="absolute top-4 right-4 w-11 h-11 rounded-full bg-surface-container/95 backdrop-blur-md flex items-center justify-center hover:bg-surface-container transition-colors shadow-lg border border-outline-variant"
                >
                  <Heart 
                    className={`w-5 h-5 transition-all ${recipe.saved ? 'fill-error text-error' : 'text-on-surface-variant'}`}
                  />
                </button>
                <div className="absolute bottom-4 left-4">
                  <Badge className="bg-surface-container/95 backdrop-blur-md text-on-surface border-outline-variant shadow-md rounded-full px-3 py-1.5">
                    {recipe.cuisine}
                  </Badge>
                </div>
              </div>

              {/* Recipe Info */}
              <div className="p-6">
                <h3 className="font-bold text-lg mb-3 line-clamp-1 text-on-surface">{recipe.title}</h3>
                
                {/* Stats */}
                <div className="flex items-center gap-4 text-sm text-on-surface-variant mb-4">
                  <div className="flex items-center gap-1.5">
                    <Star className="w-4 h-4 fill-[#FFB800] text-[#FFB800]" />
                    <span className="font-semibold text-on-surface">{recipe.rating}</span>
                    <span>({recipe.reviews})</span>
                  </div>
                  <div className="flex items-center gap-1.5">
                    <Clock className="w-4 h-4" />
                    <span>{recipe.cookTime}</span>
                  </div>
                </div>

                {/* Author & Difficulty */}
                <div className="flex items-center justify-between pt-4 border-t border-outline-variant">
                  <div className="flex items-center gap-2">
                    <Avatar className="w-7 h-7">
                      <AvatarFallback className="bg-tertiary-container text-on-tertiary-container text-xs">
                        {recipe.authorInitials}
                      </AvatarFallback>
                    </Avatar>
                    <span className="text-sm text-on-surface-variant">{recipe.author}</span>
                  </div>
                  <Badge className="bg-surface-container-highest text-on-surface border-0 text-xs px-2.5 py-1 rounded-full">
                    {recipe.difficulty}
                  </Badge>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* Empty State */}
        {filteredRecipes.length === 0 && (
          <div className="text-center py-20">
            <div className="w-24 h-24 rounded-full bg-surface-container flex items-center justify-center mx-auto mb-6 border border-outline-variant">
              <Search className="w-12 h-12 text-on-surface-variant" />
            </div>
            <h3 className="text-2xl font-semibold mb-3 text-on-surface">No recipes found</h3>
            <p className="text-on-surface-variant mb-8">Try adjusting your search or filters</p>
            <Button 
              onClick={() => { setSearchQuery(''); setActiveFilter('all'); }}
              className="bg-primary text-on-primary hover:bg-primary/90 rounded-full px-8 shadow-md"
            >
              Clear Filters
            </Button>
          </div>
        )}
      </main>
    </div>
  );
}
