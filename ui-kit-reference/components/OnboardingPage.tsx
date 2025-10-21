import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import { Button } from './ui/button';
import { Badge } from './ui/badge';
import { Progress } from './ui/progress';
import { ChefHat, ArrowRight, ArrowLeft, Check } from 'lucide-react';

const DIETARY_OPTIONS = [
  { id: 'vegetarian', label: 'Vegetarian', emoji: '🥗' },
  { id: 'vegan', label: 'Vegan', emoji: '🌱' },
  { id: 'glutenfree', label: 'Gluten-Free', emoji: '🌾' },
  { id: 'dairyfree', label: 'Dairy-Free', emoji: '🥛' },
  { id: 'keto', label: 'Keto', emoji: '🥑' },
  { id: 'paleo', label: 'Paleo', emoji: '🍖' },
  { id: 'halal', label: 'Halal', emoji: '🕌' },
  { id: 'kosher', label: 'Kosher', emoji: '✡️' },
];

const CUISINE_OPTIONS = [
  { id: 'italian', label: 'Italian', emoji: '🍝' },
  { id: 'asian', label: 'Asian', emoji: '🍜' },
  { id: 'mexican', label: 'Mexican', emoji: '🌮' },
  { id: 'mediterranean', label: 'Mediterranean', emoji: '🫒' },
  { id: 'indian', label: 'Indian', emoji: '🍛' },
  { id: 'french', label: 'French', emoji: '🥖' },
  { id: 'american', label: 'American', emoji: '🍔' },
  { id: 'middleeastern', label: 'Middle Eastern', emoji: '🧆' },
  { id: 'japanese', label: 'Japanese', emoji: '🍱' },
  { id: 'thai', label: 'Thai', emoji: '🍲' },
];

const SKILL_LEVELS = [
  { id: 'beginner', label: 'Beginner', description: 'Just starting out in the kitchen', emoji: '👶' },
  { id: 'intermediate', label: 'Intermediate', description: 'Comfortable with basic techniques', emoji: '👨‍🍳' },
  { id: 'advanced', label: 'Advanced', description: 'Experienced home chef', emoji: '⭐' },
  { id: 'expert', label: 'Expert', description: 'Professional or culinary expert', emoji: '🏆' },
];

export function OnboardingPage() {
  const navigate = useNavigate();
  const { updateUserPreferences } = useAuth();
  const [step, setStep] = useState(1);
  const [selectedDietary, setSelectedDietary] = useState<string[]>([]);
  const [selectedCuisines, setSelectedCuisines] = useState<string[]>([]);
  const [selectedSkillLevel, setSelectedSkillLevel] = useState('');

  const progress = (step / 3) * 100;

  const toggleDietary = (id: string) => {
    setSelectedDietary(prev => 
      prev.includes(id) ? prev.filter(item => item !== id) : [...prev, id]
    );
  };

  const toggleCuisine = (id: string) => {
    setSelectedCuisines(prev => 
      prev.includes(id) ? prev.filter(item => item !== id) : [...prev, id]
    );
  };

  const handleNext = () => {
    if (step < 3) {
      setStep(step + 1);
    } else {
      updateUserPreferences({
        dietaryPreferences: selectedDietary,
        cuisinePreferences: selectedCuisines,
        skillLevel: selectedSkillLevel,
        onboardingComplete: true,
      });
      navigate('/dashboard');
    }
  };

  const handleSkip = () => {
    updateUserPreferences({ onboardingComplete: true });
    navigate('/dashboard');
  };

  const canProceed = () => {
    if (step === 1) return selectedDietary.length > 0;
    if (step === 2) return selectedCuisines.length > 0;
    if (step === 3) return selectedSkillLevel !== '';
    return false;
  };

  return (
    <div className="min-h-screen bg-surface flex items-center justify-center p-4">
      <div className="w-full max-w-3xl">
        {/* Material 3 Header */}
        <div className="text-center mb-10">
          <div className="inline-flex items-center gap-3 mb-6">
            <div className="w-14 h-14 rounded-[16px] bg-primary flex items-center justify-center shadow-lg">
              <ChefHat className="w-8 h-8 text-on-primary" />
            </div>
          </div>
          <h1 className="text-4xl font-bold mb-3 text-on-surface">Let's Personalize Your Experience</h1>
          <p className="text-lg text-on-surface-variant">Help us recommend the perfect recipes for you</p>
          <div className="mt-8 max-w-md mx-auto">
            <Progress value={progress} className="h-2 bg-surface-container-highest" />
            <div className="flex justify-between mt-3">
              <span className="text-sm text-on-surface-variant">Step {step} of 3</span>
              <span className="text-sm text-primary font-medium">{Math.round(progress)}%</span>
            </div>
          </div>
        </div>

        {/* Material 3 Content Card */}
        <div className="bg-surface-container-low rounded-[28px] shadow-lg p-10 border border-outline-variant">
          {step === 1 && (
            <div className="space-y-8">
              <div>
                <h2 className="text-3xl font-bold mb-3 text-on-surface">Dietary Preferences</h2>
                <p className="text-lg text-on-surface-variant">Select any dietary restrictions or preferences</p>
              </div>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {DIETARY_OPTIONS.map((option) => (
                  <button
                    key={option.id}
                    onClick={() => toggleDietary(option.id)}
                    className={`p-5 rounded-[20px] border-2 transition-all hover:scale-105 relative ${
                      selectedDietary.includes(option.id)
                        ? 'border-primary bg-primary-container'
                        : 'border-outline-variant bg-surface-container hover:bg-surface-container-high'
                    }`}
                  >
                    {selectedDietary.includes(option.id) && (
                      <div className="absolute top-2 right-2 w-6 h-6 rounded-full bg-primary flex items-center justify-center">
                        <Check className="w-4 h-4 text-on-primary" />
                      </div>
                    )}
                    <div className="text-4xl mb-3">{option.emoji}</div>
                    <div className={`text-sm font-semibold ${
                      selectedDietary.includes(option.id) ? 'text-on-primary-container' : 'text-on-surface'
                    }`}>
                      {option.label}
                    </div>
                  </button>
                ))}
              </div>
            </div>
          )}

          {step === 2 && (
            <div className="space-y-8">
              <div>
                <h2 className="text-3xl font-bold mb-3 text-on-surface">Favorite Cuisines</h2>
                <p className="text-lg text-on-surface-variant">Choose the cuisines you love to explore</p>
              </div>
              <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
                {CUISINE_OPTIONS.map((option) => (
                  <button
                    key={option.id}
                    onClick={() => toggleCuisine(option.id)}
                    className={`p-5 rounded-[20px] border-2 transition-all hover:scale-105 relative ${
                      selectedCuisines.includes(option.id)
                        ? 'border-secondary bg-secondary-container'
                        : 'border-outline-variant bg-surface-container hover:bg-surface-container-high'
                    }`}
                  >
                    {selectedCuisines.includes(option.id) && (
                      <div className="absolute top-2 right-2 w-6 h-6 rounded-full bg-secondary flex items-center justify-center">
                        <Check className="w-4 h-4 text-on-secondary" />
                      </div>
                    )}
                    <div className="text-4xl mb-3">{option.emoji}</div>
                    <div className={`text-sm font-semibold ${
                      selectedCuisines.includes(option.id) ? 'text-on-secondary-container' : 'text-on-surface'
                    }`}>
                      {option.label}
                    </div>
                  </button>
                ))}
              </div>
            </div>
          )}

          {step === 3 && (
            <div className="space-y-8">
              <div>
                <h2 className="text-3xl font-bold mb-3 text-on-surface">Cooking Skill Level</h2>
                <p className="text-lg text-on-surface-variant">This helps us suggest recipes at the right difficulty</p>
              </div>
              <div className="space-y-4">
                {SKILL_LEVELS.map((level) => (
                  <button
                    key={level.id}
                    onClick={() => setSelectedSkillLevel(level.id)}
                    className={`w-full p-6 rounded-[20px] border-2 transition-all text-left hover:scale-[1.02] ${
                      selectedSkillLevel === level.id
                        ? 'border-tertiary bg-tertiary-container'
                        : 'border-outline-variant bg-surface-container hover:bg-surface-container-high'
                    }`}
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-4">
                        <div className="text-4xl">{level.emoji}</div>
                        <div>
                          <div className={`font-bold text-xl mb-1 ${
                            selectedSkillLevel === level.id ? 'text-on-tertiary-container' : 'text-on-surface'
                          }`}>
                            {level.label}
                          </div>
                          <div className={`text-sm ${
                            selectedSkillLevel === level.id ? 'text-on-tertiary-container/80' : 'text-on-surface-variant'
                          }`}>
                            {level.description}
                          </div>
                        </div>
                      </div>
                      {selectedSkillLevel === level.id && (
                        <div className="w-8 h-8 rounded-full bg-tertiary flex items-center justify-center flex-shrink-0">
                          <Check className="w-5 h-5 text-on-tertiary" />
                        </div>
                      )}
                    </div>
                  </button>
                ))}
              </div>
            </div>
          )}

          {/* Material 3 Action Buttons */}
          <div className="flex items-center justify-between mt-10 pt-8 border-t border-outline-variant">
            <Button 
              variant="ghost" 
              onClick={handleSkip}
              className="text-on-surface-variant hover:text-on-surface hover:bg-surface-container-highest"
            >
              Skip for now
            </Button>
            <div className="flex items-center gap-3">
              {step > 1 && (
                <Button 
                  variant="outline" 
                  onClick={() => setStep(step - 1)}
                  className="border-outline text-on-surface hover:bg-surface-container-highest rounded-full px-6"
                >
                  <ArrowLeft className="w-4 h-4 mr-2" />
                  Back
                </Button>
              )}
              <Button 
                onClick={handleNext}
                disabled={!canProceed()}
                className="bg-primary text-on-primary hover:bg-primary/90 shadow-md rounded-full px-8 disabled:opacity-50"
              >
                {step === 3 ? 'Complete' : 'Next'}
                <ArrowRight className="w-4 h-4 ml-2" />
              </Button>
            </div>
          </div>
        </div>

        {/* Material 3 Summary Chip Container */}
        {(selectedDietary.length > 0 || selectedCuisines.length > 0 || selectedSkillLevel) && (
          <div className="mt-6 p-6 bg-surface-container-low/60 backdrop-blur-xl rounded-[20px] border border-outline-variant">
            <p className="text-sm font-medium text-on-surface-variant mb-3">Your selections:</p>
            <div className="flex flex-wrap gap-2">
              {selectedDietary.map(id => {
                const option = DIETARY_OPTIONS.find(o => o.id === id);
                return option ? (
                  <Badge key={id} className="bg-primary-container text-on-primary-container border-0 px-3 py-1.5 rounded-full">
                    {option.emoji} {option.label}
                  </Badge>
                ) : null;
              })}
              {selectedCuisines.map(id => {
                const option = CUISINE_OPTIONS.find(o => o.id === id);
                return option ? (
                  <Badge key={id} className="bg-secondary-container text-on-secondary-container border-0 px-3 py-1.5 rounded-full">
                    {option.emoji} {option.label}
                  </Badge>
                ) : null;
              })}
              {selectedSkillLevel && (
                <Badge className="bg-tertiary-container text-on-tertiary-container border-0 px-3 py-1.5 rounded-full">
                  {SKILL_LEVELS.find(l => l.id === selectedSkillLevel)?.emoji}{' '}
                  {SKILL_LEVELS.find(l => l.id === selectedSkillLevel)?.label}
                </Badge>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
