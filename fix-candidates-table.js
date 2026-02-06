require('dotenv').config();
const db = require('./server/db');

async function fixCandidatesTable() {
  try {
    console.log('🔧 Fixing candidates table constraints...');
    
    const result = await db.query(`
      ALTER TABLE candidates 
        ALTER COLUMN first_name DROP NOT NULL,
        ALTER COLUMN last_name DROP NOT NULL,
        ALTER COLUMN position_applied DROP NOT NULL;
    `);
    
    console.log('✅ Candidates table fixed successfully');
    process.exit(0);
  } catch (err) {
    console.error('❌ Error fixing candidates table:', err.message);
    process.exit(1);
  }
}

fixCandidatesTable();
