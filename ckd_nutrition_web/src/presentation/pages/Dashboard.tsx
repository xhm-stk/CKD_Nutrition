import React from 'react';
import { useApp } from '../contexts/AppContext';
import { useAuth } from '../contexts/AuthContext';
import { AlertCircle, ArrowUpRight, ArrowDownRight, Droplets, Info } from 'lucide-react';

export const Dashboard: React.FC = () => {
  const { user } = useAuth();
  const { t, dailyLog, quotas, meals } = useApp();

  // Net Balance Calculation
  const waterIn = dailyLog?.totalWaterMl || 0;
  const urineOut = dailyLog?.totalUrineMl || 0;
  const netBalance = waterIn - urineOut;

  // Limits alert checks
  const isAnyOverLimit = quotas.some((q) => q.limit > 0 && q.consumed > q.limit);
  const isAnyNearLimit = quotas.some(
    (q) => q.limit > 0 && q.consumed / q.limit >= 0.8 && q.consumed <= q.limit
  );

  return (
    <div className="view-wrapper">
      <div className="title-row">
        <div>
          <h2 className="title-large">สวัสดี, {user?.name || 'ผู้ใช้งาน'}</h2>
          <span className="subtitle-body">
            ติดตามภาวะโภชนาการสำหรับโรคไต {user?.ckdStage?.toUpperCase().replace('_', ' ')}
          </span>
        </div>
      </div>

      {/* Warning/Alert Banners */}
      {isAnyOverLimit && (
        <div className="alert-card alert-card-error">
          <AlertCircle className="alert-icon-error" size={24} />
          <div className="alert-text-container">
            <span className="alert-title">{t('warningOver')}</span>
            <span className="alert-desc">กรุณาจำกัดการทานอาหารประเภทโปรตีนและโพแทสเซียมในมื้อถัดไป</span>
          </div>
        </div>
      )}

      {!isAnyOverLimit && isAnyNearLimit && (
        <div className="alert-card alert-card-warning">
          <AlertCircle className="alert-icon-warning" size={24} />
          <div className="alert-text-container">
            <span className="alert-title">{t('warningNear')}</span>
            <span className="alert-desc">สารอาหารบางตัวใกล้เกินเกณฑ์ที่ปลอดภัยแล้ว</span>
          </div>
        </div>
      )}

      {/* Water Net Balance Card */}
      <div
        className="progress-card"
        style={{
          background: 'linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%)',
          borderColor: '#bae6fd',
          boxShadow: '0 8px 24px rgba(2, 132, 199, 0.1)',
        }}
      >
        <span style={{ fontWeight: '800', color: 'var(--color-primary-dark)', fontSize: '15px' }}>
          {t('netBalance')}
        </span>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', margin: '8px 0' }}>
          {/* Inlet Water */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <div style={{ width: '36px', height: '36px', borderRadius: '50%', backgroundColor: '#ffffff', display: 'flex', justifyContent: 'center', alignItems: 'center', color: 'var(--color-primary)' }}>
              <ArrowUpRight size={20} />
            </div>
            <div style={{ display: 'flex', flexDirection: 'column', textAlign: 'left' }}>
              <span style={{ fontSize: '12px', color: 'var(--color-primary-dark)', fontWeight: '600' }}>น้ำดื่มเข้า</span>
              <span style={{ fontSize: '16px', fontWeight: '800', color: 'var(--color-on-surface)' }}>{waterIn} มล.</span>
            </div>
          </div>

          {/* Balance Output Display */}
          <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
            <span style={{ fontSize: '12px', color: 'var(--color-primary-dark)', fontWeight: '600' }}>คงเหลือสุทธิ</span>
            <span style={{ fontSize: '24px', fontWeight: '900', color: netBalance >= 0 ? 'var(--color-primary-dark)' : 'var(--color-error)' }}>
              {netBalance >= 0 ? `+${netBalance}` : netBalance} มล.
            </span>
          </div>

          {/* Outlet Urine */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <div style={{ display: 'flex', flexDirection: 'column', textAlign: 'right' }}>
              <span style={{ fontSize: '12px', color: 'var(--color-primary-dark)', fontWeight: '600' }}>ปัสสาวะออก</span>
              <span style={{ fontSize: '16px', fontWeight: '800', color: 'var(--color-on-surface)' }}>{urineOut} มล.</span>
            </div>
            <div style={{ width: '36px', height: '36px', borderRadius: '50%', backgroundColor: '#ffffff', display: 'flex', justifyContent: 'center', alignItems: 'center', color: '#d97706' }}>
              <ArrowDownRight size={20} />
            </div>
          </div>
        </div>
      </div>

      {/* Progress Bars for nutrients */}
      <h3 style={{ fontSize: '18px', fontWeight: '800', color: 'var(--color-on-surface)', textAlign: 'left', margin: '4px 0 -4px 0' }}>
        โควต้าสารอาหารวันนี้
      </h3>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
        {quotas.map((quota) => {
          const ratio = quota.limit > 0 ? quota.consumed / quota.limit : 0;
          const isOver = quota.limit > 0 && quota.consumed > quota.limit;
          const isNear = quota.limit > 0 && ratio >= 0.8 && !isOver;

          let barColor = 'var(--color-primary)';
          if (isOver) barColor = 'var(--color-error)';
          else if (isNear) barColor = 'var(--color-warning)';

          return (
            <div key={quota.label} className="progress-card">
              <div className="progress-header">
                <span style={{ textTransform: 'capitalize', color: 'var(--color-on-surface)' }}>
                  {t(quota.label as any)}
                </span>
                <span style={{ color: 'var(--color-muted)' }}>
                  {quota.consumed.toFixed(1)} / {quota.limit.toFixed(1)} {quota.unit}
                </span>
              </div>
              <div className="progress-bar-container">
                <div
                  className="progress-bar-fill"
                  style={{
                    width: `${Math.min(ratio * 100, 100)}%`,
                    backgroundColor: barColor,
                  }}
                ></div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Logged meals history list */}
      <h3 style={{ fontSize: '18px', fontWeight: '800', color: 'var(--color-on-surface)', textAlign: 'left', margin: '16px 0 -4px 0' }}>
        เมนูอาหารที่ทานวันนี้
      </h3>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
        {meals.length === 0 ? (
          <div
            style={{
              padding: '24px',
              borderRadius: '16px',
              border: '1.5px dashed var(--color-border)',
              color: 'var(--color-muted)',
              fontSize: '14px',
            }}
          >
            {t('noMealsToday')}
          </div>
        ) : (
          meals.map((meal) => (
            <div
              key={meal.id}
              style={{
                padding: '16px',
                borderRadius: '16px',
                border: '1.5px solid var(--color-border)',
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                textAlign: 'left',
              }}
            >
              <div style={{ display: 'flex', flexDirection: 'column', gap: '2px' }}>
                <span style={{ fontWeight: 'bold', fontSize: '14px' }}>{meal.foodName}</span>
                <span style={{ fontSize: '12px', color: 'var(--color-muted)' }}>
                  ปริมาณ {meal.quantityG}g | {t(meal.mealType as any)}
                </span>
              </div>
              <div style={{ fontSize: '13px', fontWeight: '600', color: 'var(--color-primary)' }}>
                โปรตีน {meal.proteinG.toFixed(1)}g
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
};
