// Before (Vulnerable Code):
// const historyItems = d.slice(0, 10);

// After (Defensive, Compliant Code):
const historyItems = Array.isArray(d) ? d.slice(0, 10) : [];
