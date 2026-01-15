//
//  OnboardingPage.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 11/07/25.
//


struct OnboardingPage {
    let image: String
    let title: String
    let subtitle: String
    let buttonTitle: String
}

let onboardingData: [OnboardingPage] = [
    OnboardingPage(image: "Onboarding1", title: "Welcome to SloDoggies", subtitle: "Discover a tail-wagging world where dog lovers and trusted local services connect. SLO county’s pet scene just got its own home!", buttonTitle: "Next"),
    OnboardingPage(image: "Onboarding2", title: "Sniff Out Local Pet Pros", subtitle: "Search for groomers, walkers, trainers, and more-powered by real reviews, geolocation, and a love for all things furry.", buttonTitle: "Next"),
    OnboardingPage(image: "Onboarding3", title: "Paws, Play & Participate", subtitle: "Join dog friendly events, follow favorite providers, explore pet places and make lifelong friends – both two-and four-legged.", buttonTitle: "Get Started")
]
