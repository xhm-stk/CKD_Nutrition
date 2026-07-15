import React, { useState } from 'react';
import { useAuth } from '../contexts/AuthContext';
import { useApp } from '../contexts/AppContext';
import { Globe, User, LogOut, Trash2, Award, Scale, Ruler, Activity } from 'lucide-react';

interface ProfileProps {
  onEditHealth: () => void;
}

export const Profile: React.FC<ProfileProps> = ({ onEditHealth }) => {
  const { user, signOut, deleteAccount } = useAuth();
  const { t, lang, setLang } = useApp();
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [isDeleting, setIsDeleting] = useState(false);

  const handleDeleteAccount = async () => {
    setIsDeleting(true);
    try {
      await deleteAccount();
    } catch (e) {
      alert('เกิดข้อผิดพลาดในการลบบัญชี');
    } finally {
      setIsDeleting(false);
    }
  };

  return (
    <div className="view-wrapper">
      <div className="title-row">
        <div>
          <h2 className="title-large">{t('profile')}</h2>
          <span className="subtitle-body">จัดการข้อมูลส่วนบุคคลและการแปลภาษา</span>
        </div>
      </div>

      {/* User Info Card */}
      <div
        className="progress-card"
        style={{
          background: 'linear-gradient(135deg, #ffffff 0%, #f8fafc 100%)',
          display: 'flex',
          flexDirection: 'column',
          gap: '16px',
          textAlign: 'left',
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
          <div
            style={{
              width: '60px',
              height: '60px',
              borderRadius: '50%',
              backgroundColor: 'var(--color-primary-light)',
              color: 'var(--color-primary)',
              display: 'flex',
              justifyContent: 'center',
              alignItems: 'center',
            }}
          >
            <User size={32} />
          </div>
          <div style={{ display: 'flex', flexDirection: 'column' }}>
            <span style={{ fontWeight: 'bold', fontSize: '18px' }}>{user?.name || 'ผู้ใช้งาน'}</span>
            <span style={{ fontSize: '13px', color: 'var(--color-muted)' }}>{user?.email}</span>
          </div>
        </div>

        <div style={{ height: '1.5px', backgroundColor: 'var(--color-border)' }}></div>

        {/* Health Matrix Summary */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '14px' }}>
            <Scale size={18} style={{ color: 'var(--color-primary)' }} />
            <span>น้ำหนัก: {user?.weightKg || '-'} กก.</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '14px' }}>
            <Ruler size={18} style={{ color: 'var(--color-primary)' }} />
            <span>ส่วนสูง: {user?.heightCm || '-'} ซม.</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '14px' }}>
            <Activity size={18} style={{ color: 'var(--color-primary)' }} />
            <span>เพศ: {user?.gender === 'male' ? t('male') : t('female')}</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontSize: '14px' }}>
            <Award size={18} style={{ color: 'var(--color-primary)' }} />
            <span>ไตระยะที่: {user?.ckdStage?.replace('stage_', '') || '-'}</span>
          </div>
        </div>

        <button className="premium-btn premium-btn-secondary" onClick={onEditHealth} style={{ height: '44px', fontSize: '14px' }}>
          แก้ไขข้อมูลสุขภาพ
        </button>
      </div>

      {/* Language Selection Card */}
      <div className="progress-card" style={{ textAlign: 'left' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px', fontWeight: 'bold', fontSize: '15px' }}>
          <Globe size={18} style={{ color: 'var(--color-primary)' }} />
          <span>เปลี่ยนภาษา (Language)</span>
        </div>
        <div style={{ display: 'flex', gap: '12px', marginTop: '4px' }}>
          <button
            onClick={() => setLang('th')}
            style={{
              flex: 1,
              padding: '10px',
              borderRadius: '12px',
              border: lang === 'th' ? '2px solid var(--color-primary)' : '1.5px solid var(--color-border)',
              backgroundColor: lang === 'th' ? 'var(--color-primary-light)' : 'transparent',
              color: lang === 'th' ? 'var(--color-primary)' : 'var(--color-muted)',
              fontWeight: 'bold',
              cursor: 'pointer',
            }}
          >
            ภาษาไทย (TH)
          </button>
          <button
            onClick={() => setLang('en')}
            style={{
              flex: 1,
              padding: '10px',
              borderRadius: '12px',
              border: lang === 'en' ? '2px solid var(--color-primary)' : '1.5px solid var(--color-border)',
              backgroundColor: lang === 'en' ? 'var(--color-primary-light)' : 'transparent',
              color: lang === 'en' ? 'var(--color-primary)' : 'var(--color-muted)',
              fontWeight: 'bold',
              cursor: 'pointer',
            }}
          >
            English (EN)
          </button>
        </div>
      </div>

      {/* Action Cards */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
        {/* Logout */}
        <button
          onClick={signOut}
          className="premium-btn"
          style={{
            backgroundColor: '#f1f5f9',
            color: 'var(--color-on-surface)',
            border: '1.5px solid var(--color-border)',
            height: '50px',
            fontSize: '15px',
          }}
        >
          <LogOut size={18} />
          {t('logout')}
        </button>

        {/* Delete Account */}
        <button
          onClick={() => setShowDeleteConfirm(true)}
          className="premium-btn premium-btn-danger"
          style={{ height: '50px', fontSize: '15px' }}
        >
          <Trash2 size={18} />
          {t('deleteAccount')}
        </button>
      </div>

      {/* Delete Confirmation Dialog */}
      {showDeleteConfirm && (
        <div className="overlay-backdrop" onClick={() => setShowDeleteConfirm(false)}>
          <div
            className="bottom-sheet"
            onClick={(e) => e.stopPropagation()}
            style={{
              borderTopLeftRadius: '24px',
              borderTopRightRadius: '24px',
              textAlign: 'center',
            }}
          >
            <div className="bottom-sheet-handle"></div>
            <h3 style={{ fontSize: '18px', fontWeight: 'bold', color: 'var(--color-error)' }}>
              {t('confirmDelete')}
            </h3>
            <p style={{ color: 'var(--color-muted)', fontSize: '14px', margin: '8px 0 16px 0' }}>
              {t('confirmDeleteDesc')}
            </p>

            <div style={{ display: 'flex', gap: '12px' }}>
              <button
                className="premium-btn premium-btn-secondary"
                onClick={() => setShowDeleteConfirm(false)}
                style={{ flex: 1 }}
              >
                {t('cancel')}
              </button>
              <button
                className="premium-btn premium-btn-danger"
                disabled={isDeleting}
                onClick={handleDeleteAccount}
                style={{ flex: 1 }}
              >
                {isDeleting ? '...' : t('deleteAccount')}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
