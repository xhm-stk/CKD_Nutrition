import React, { useState } from 'react';
import { AuthProvider, useAuth } from './presentation/contexts/AuthContext';
import { AppProvider, useApp } from './presentation/contexts/AppContext';
import { Login } from './presentation/pages/Login';
import { HealthSetup } from './presentation/pages/HealthSetup';
import { Dashboard } from './presentation/pages/Dashboard';
import { History } from './presentation/pages/History';
import { Profile } from './presentation/pages/Profile';
import { AddActionSheet } from './presentation/components/AddActionSheet';
import { WaterEntrySheet } from './presentation/components/WaterEntrySheet';
import { UrineEntrySheet } from './presentation/components/UrineEntrySheet';
import { FoodEntrySheet } from './presentation/components/FoodEntrySheet';
import { LayoutDashboard, Calendar, User, Plus } from 'lucide-react';
import './presentation/styles/theme.css';
import './presentation/styles/components.css';

const MainAppContent: React.FC = () => {
  const { user, loading: authLoading } = useAuth();
  const { loading: appLoading, t } = useApp();
  const [activeTab, setActiveTab] = useState<'dashboard' | 'history' | 'profile'>('dashboard');
  
  // Sheet states
  const [showAddActions, setShowAddActions] = useState(false);
  const [showWaterSheet, setShowWaterSheet] = useState(false);
  const [showUrineSheet, setShowUrineSheet] = useState(false);
  const [showFoodSheet, setShowFoodSheet] = useState(false);
  const [isEditingHealth, setIsEditingHealth] = useState(false);

  if (authLoading) {
    return (
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100vh', width: '100%' }}>
        <span>กำลังโหลดเซสชันผู้ใช้...</span>
      </div>
    );
  }

  // Not logged in -> Show login
  if (!user) {
    return <Login />;
  }

  // Logged in but profile data is incomplete (no weight or ckd stage) -> Show health setup
  if ((!user.weightKg || !user.ckdStage) || isEditingHealth) {
    return (
      <div className="app-container">
        <HealthSetup />
        {isEditingHealth && (
          <button
            className="premium-btn premium-btn-secondary"
            onClick={() => setIsEditingHealth(false)}
            style={{ position: 'absolute', top: '16px', right: '16px', width: 'auto', height: '36px', padding: '0 16px', borderRadius: '12px' }}
          >
            {t('cancel')}
          </button>
        )}
      </div>
    );
  }

  const renderActiveView = () => {
    switch (activeTab) {
      case 'dashboard':
        return <Dashboard />;
      case 'history':
        return <History />;
      case 'profile':
        return <Profile onEditHealth={() => setIsEditingHealth(true)} />;
      default:
        return <Dashboard />;
    }
  };

  return (
    <div className="app-container">
      {/* Scrollable View Area */}
      <div style={{ flex: 1, overflowY: 'auto', width: '100%' }}>
        {renderActiveView()}
      </div>

      {/* Bottom Nav Bar */}
      <div className="bottom-nav">
        <div
          className={`nav-item ${activeTab === 'dashboard' ? 'nav-item-active' : ''}`}
          onClick={() => setActiveTab('dashboard')}
        >
          <LayoutDashboard size={22} />
          <span>{t('dashboard')}</span>
        </div>

        <div className="nav-fab" onClick={() => setShowAddActions(true)}>
          <Plus size={28} />
        </div>

        <div
          className={`nav-item ${activeTab === 'history' ? 'nav-item-active' : ''}`}
          onClick={() => setActiveTab('history')}
        >
          <Calendar size={22} />
          <span>{t('history')}</span>
        </div>

        <div
          className={`nav-item ${activeTab === 'profile' ? 'nav-item-active' : ''}`}
          onClick={() => setActiveTab('profile')}
        >
          <User size={22} />
          <span>{t('profile')}</span>
        </div>
      </div>

      {/* Action Sheet Dialogs */}
      {showAddActions && (
        <AddActionSheet
          onClose={() => setShowAddActions(false)}
          onOpenWater={() => {
            setShowAddActions(false);
            setShowWaterSheet(true);
          }}
          onOpenUrine={() => {
            setShowAddActions(false);
            setShowUrineSheet(true);
          }}
          onOpenLogFood={() => {
            setShowAddActions(false);
            setShowFoodSheet(true);
          }}
        />
      )}

      {showWaterSheet && (
        <WaterEntrySheet onClose={() => setShowWaterSheet(false)} />
      )}

      {showUrineSheet && (
        <UrineEntrySheet onClose={() => setShowUrineSheet(false)} />
      )}

      {showFoodSheet && (
        <FoodEntrySheet onClose={() => setShowFoodSheet(false)} />
      )}
    </div>
  );
};

function App() {
  return (
    <AuthProvider>
      <AppProvider>
        <MainAppContent />
      </AppProvider>
    </AuthProvider>
  );
}

export default App;
