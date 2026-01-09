## CloudKit setup for FeatureVoterCloudKit

This voter stores per-user votes in the Private database and aggregated vote counts in the Public database.

### What it stores

1. Private database  
   **Record type:** `RoadmapUserVote`  
   **Purpose:** Stores one vote marker per user per feature key to prevent double voting.

2. Public database  
   **Record type:** `RoadmapFeatureCount`  
   **Purpose:** Stores a global counter per feature key to show total votes across users.

---

## Requirements

- The app target must have iCloud enabled with CloudKit.
- A CloudKit container must be selected in Xcode Signing & Capabilities.
- The CloudKit schema and security roles must be configured in CloudKit Console.

---

## Step 1: Enable iCloud and CloudKit in Xcode

1. Open your app target in Xcode.
2. Go to **Signing & Capabilities**.
3. Add the **iCloud** capability.
4. Enable:
   - Key-value storage
   - iCloud Documents
   - CloudKit
5. Under **Containers**, select your CloudKit container.

Important: The container identifier used by the app must match the container selected here. A mismatch results in a CKError “Bad Container”.

---

## Step 2: Open CloudKit Console

1. Open **CloudKit Console** from Xcode or the Apple Developer tools.
2. Select the correct CloudKit container.
3. Select the **Development** environment.

---

## Step 3: Create the record types

In CloudKit Console:

1. Go to **CloudKit Database**.
2. Ensure the **Development** environment is selected.
3. Create the following record types under **Schema → Record Types**.

### Public database record type

- **Record type:** `RoadmapFeatureCount`
- **Fields:**
  - `key` (String)
  - `count` (Int64)

Notes:
- `key` should be queryable and searchable.
- `count` stores the aggregated vote total.

### Private database record type

- **Record type:** `RoadmapUserVote`
- **Fields:**
  - `featureKey` (String)

---

## Step 4: Configure Public database permissions

The aggregated vote counter is written to the Public database. To allow normal users to vote, the `_icloud` role must be allowed to write to `RoadmapFeatureCount`.

1. Go to **Schema → Security Roles**.
2. Select the **_icloud** role.
3. Find the `RoadmapFeatureCount` record type.
4. Enable:
   - Create
   - Read
   - Write

Do not modify the `_world` role.

You do not need to enable Public database write access for `RoadmapUserVote` if it is stored in the Private database.

---

## Step 5: Save and deploy schema changes

After changing record types or security roles:

1. Click **Save**.
2. Click **Deploy Schema Changes**.
3. Deploy **Development** changes to the **Development** environment.

Skipping this step can cause different behavior across devices due to CloudKit caching.

---

## Step 6: Verify on devices

If voting works on one device but fails on another:

1. Delete the app from the failing device.
2. Reinstall the app from Xcode.
3. Ensure the device is signed into iCloud.
4. Test voting again.

---

## Troubleshooting

### CKError: “Bad Container”

**Cause:** CloudKit container identifier mismatch.

**Fix:**
- Verify the container selected in Xcode Signing & Capabilities.
- Ensure the app uses the same container identifier in code or relies on `.default()` with correct entitlements.

---

### CKError: “Permission Failure” or “WRITE operation not permitted”

**Cause:** Public database write access is not enabled for the `_icloud` role on `RoadmapFeatureCount`.

**Fix:**
- Open **CloudKit Console → Security Roles → _icloud**.
- Enable **Create** and **Write** for `RoadmapFeatureCount`.
- Save and deploy schema changes.

---

## Notes on the trust model

This configuration allows authenticated iCloud users to write aggregated vote counts in the Public database. This enables global voting without running a server but is not tamper-proof. For roadmap voting and similar low-risk features, this trade-off is typically acceptable.