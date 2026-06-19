'use client';

import React, { useState, useEffect, useRef, useMemo } from 'react';
import { Search, X } from 'lucide-react';

interface Ingredient {
  id: string;
  code: string;
  vi_name: string;
  fr_name: string;
  category: string;
  unit: string;
  price?: number;
  wac_price?: number;
  is_beverage?: boolean;
}

interface UniversalSearchProps {
  ingredients: Ingredient[];
  onSelect: (ingredient: Ingredient) => void;
  placeholder?: string;
  className?: string;
  posMappings?: Record<string, { recipe: string; type: string }>;
}

export default function UniversalSearch({
  ingredients,
  onSelect,
  placeholder = 'Tìm kiếm nguyên liệu (tên, mã, alias POS)...',
  className = '',
  posMappings = {}
}: UniversalSearchProps) {
  const [query, setQuery] = useState('');
  const [isOpen, setIsOpen] = useState(false);
  const [highlightedIndex, setHighlightedIndex] = useState(0);
  const containerRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  // Close dropdown on click outside
  useEffect(() => {
    function handleClickOutside(event: MouseEvent) {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    }
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Filter ingredients based on query
  const suggestions = useMemo(() => {
    if (!query.trim()) return [];
    
    const lowerQuery = query.toLowerCase().trim();

    // Map each ingredient to its POS aliases if any
    return ingredients.filter(ing => {
      const codeMatch = ing.code?.toLowerCase().includes(lowerQuery);
      const viNameMatch = ing.vi_name?.toLowerCase().includes(lowerQuery);
      const frNameMatch = ing.fr_name?.toLowerCase().includes(lowerQuery);
      
      // Find if this ingredient is referenced in POS mapping aliases
      const aliasMatch = Object.entries(posMappings).some(([posCode, mapping]) => {
        const recipeCode = mapping.recipe;
        // Check if the recipe code matches this ingredient code, or if POS alias code matches query
        return posCode.toLowerCase().includes(lowerQuery) && recipeCode === ing.code;
      });

      return codeMatch || viNameMatch || frNameMatch || aliasMatch;
    }).slice(0, 10); // Limit to 10 suggestions for performance & usability
  }, [query, ingredients, posMappings]);

  // Reset highlighted index when suggestions change
  useEffect(() => {
    setHighlightedIndex(0);
  }, [suggestions]);

  const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (!isOpen || suggestions.length === 0) return;

    if (e.key === 'ArrowDown') {
      e.preventDefault();
      setHighlightedIndex(prev => (prev + 1) % suggestions.length);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setHighlightedIndex(prev => (prev - 1 + suggestions.length) % suggestions.length);
    } else if (e.key === 'Enter') {
      e.preventDefault();
      handleSelect(suggestions[highlightedIndex]);
    } else if (e.key === 'Escape') {
      setIsOpen(false);
    }
  };

  const handleSelect = (ing: Ingredient) => {
    onSelect(ing);
    setQuery('');
    setIsOpen(false);
    if (inputRef.current) {
      inputRef.current.blur();
    }
  };

  const handleClear = () => {
    setQuery('');
    setIsOpen(true);
    if (inputRef.current) {
      inputRef.current.focus();
    }
  };

  return (
    <div ref={containerRef} className={`relative w-full ${className}`}>
      <div className="relative flex items-center">
        <Search className="absolute left-3 text-[#C9A581] opacity-70" size={16} />
        <input
          ref={inputRef}
          type="text"
          value={query}
          onChange={(e) => {
            setQuery(e.target.value);
            setIsOpen(true);
          }}
          onFocus={() => setIsOpen(true)}
          onKeyDown={handleKeyDown}
          placeholder={placeholder}
          className="w-full bg-[#102B2A] border border-[#C9A581] hover:border-[#A8884E] focus:border-[#C2A35A] pl-10 pr-9 py-2 rounded text-xs text-[#FBF8F4] placeholder-[#C9A581]/50 focus:outline-none transition-all font-sans"
        />
        {query && (
          <button
            type="button"
            onClick={handleClear}
            className="absolute right-3 text-[#C9A581] hover:text-[#FBF8F4] transition-colors"
          >
            <X size={14} />
          </button>
        )}
      </div>

      {/* Suggestion Dropdown */}
      {isOpen && suggestions.length > 0 && (
        <div className="absolute z-50 w-full mt-1.5 bg-[#042726] border border-[#C9A581] rounded shadow-xl max-h-60 overflow-y-auto overflow-x-hidden font-sans">
          {suggestions.map((ing, idx) => {
            const isHighlighted = idx === highlightedIndex;
            return (
              <div
                key={ing.id || ing.code}
                onClick={() => handleSelect(ing)}
                onMouseEnter={() => setHighlightedIndex(idx)}
                className={`flex justify-between items-center px-4 py-2.5 cursor-pointer border-b border-[#C9A581]/20 last:border-0 transition-colors ${
                  isHighlighted ? 'bg-[#102B2A] text-[#C2A35A]' : 'text-[#FBF8F4]'
                }`}
              >
                <div className="flex flex-col min-w-0 pr-2">
                  <div className="flex items-center gap-2">
                    <span className="font-mono text-xs font-bold text-[#A8884E]">{ing.code}</span>
                    <span className="text-xs font-semibold truncate text-gray-100">{ing.vi_name}</span>
                  </div>
                  <span className="text-[10px] text-gray-400 truncate italic mt-0.5">{ing.fr_name}</span>
                </div>
                <div className="flex flex-col items-end shrink-0">
                  <span className="bg-[#102B2A] text-gray-300 px-1.5 py-0.5 rounded text-[9px] font-mono border border-[#C9A581]/30">
                    {ing.unit}
                  </span>
                  <span className="text-[9px] text-gray-400 mt-1">{ing.category}</span>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* No results message */}
      {isOpen && query.trim() && suggestions.length === 0 && (
        <div className="absolute z-50 w-full mt-1.5 bg-[#042726] border border-[#C9A581] rounded shadow-xl p-4 text-center text-xs text-gray-400 italic">
          Không tìm thấy nguyên liệu phù hợp.
        </div>
      )}
    </div>
  );
}
