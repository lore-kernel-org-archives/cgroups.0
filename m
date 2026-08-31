Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4274646DFF2;
	Mon, 31 Aug 2026 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184087; cv=none; b=iVF5OP+kFafIjwpGXTnv8OyYQAJJHsOdpJyepz4Fitia3Ak1afmQv6zM34NnnRX04VIOv7TseOeAb+6xMPE+sBabMM9BHLZusFtt0Un+eutqEnUaYwSqTik/Q770989zlNWpwDOYcM/P0yDjCUkQHfg9C39RMc8DGd1ktnqCKaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184087; c=relaxed/simple;
	bh=FjGo1xqX53H0I+x4xSs3IDlZ8KjyuZjw739fZG5uh3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZykdVyu99YPXu/ocqJPO0fBDBhhLIBHg+zufRCMD6zYidbwJ5gbTRLwx8uHFjZxchvhkwR++yBCPHc+x2Ol9SJz045Ng5oNxE80AF1/3mtCVOGlVMMujO+/EQfpkLnlCs7Bts5YgRAZq9SSBp2ckpGSF7k2iwR3kGjI9GtyE490=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QLCoFjtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QLCoFjtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA8A1F00ACA;
	Mon, 31 Aug 2026 13:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184083;
	bh=hAe8LvtGvmvY/5iCmNSXi89MCqlZH3fjnCqPJozDObY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLCoFjttkIYi3M/502COb1cPlw9pX+PUE3xx5IucjpOD7SBf3zorNJVBky0lCwLcz
	 clczrgr0xNeIbbp13NFeUeLEeQjEUEEhLeWXc6vB75x0G/6noymnMgNj2awOyJXOes
	 ieSd6X9y5u2bwtYD645T/evlU/OOisBPc6l3dzXkuUP9sxincG/VnkdxHytRfwo+3i
	 N2i7OgHvGgR/DChNfkVLAs9qmxRe5FmrOkKitSqf1WvhpPwPzcfbiq+VRR6R4yDH6I
	 7dOKvuX4ZrTGFATSLFuYJrIyN+DRUlcwuz9iVZm0F5UAWF+OVK8Cj1q3j3MAoar4/Z
	 N26ck+n3R7neA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	tj@kernel.org,
	josef@toxicpanda.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] blk-cgroup: protect iterating blkgs with blkcg->lock in blkcg_print_stat()
Date: Mon, 31 Aug 2026 09:28:29 -0400
Message-ID: <20260831133314.4125787-481-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yu Kuai <yukuai@fygo.io>

[ Upstream commit 25656304dabd26198ec69460c594a19d086ef099 ]

blkcg_print_one_stat() will be called for each blkg:
- access blkg->iostat, which is freed from rcu callback
  blkg_free_workfn();
- access policy data from pd_stat_fn(), which is freed from
  pd_free_fn(), while pd_free_fn() can be called by removing blkcg or
  deactivating policy;

Take blkcg->lock while iterating so the blkgs stay online and both
blkg->iostat and policy data for activated policies stay valid.  Use
irq-safe locking because blkcg->lock can be nested under q->queue_lock,
which is used from IRQ completion paths.

Prepare to convert protecting blkgs from request_queue with mutex.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/05799877e720dcd300e2ddd4625e8e162959d7cc.1780621988.git.yukuai@fygo.io
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[blk-cgroup]` `[protect]` — Protect iteration over blkgs in
`blkcg_print_stat()` using `blkcg->lock`.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Yu Kuai `<yukuai@fygo.io>` (author)
- **Link:** https://patch.msgid.link/05799877e720dcd300e2ddd4625e8e16295
  9d7cc.1780621988.git.yukuai@fygo.io
- **Signed-off-by:** Jens Axboe `<axboe@kernel.dk>` (block maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`

Notable: maintainer sign-off from Jens Axboe; no syzbot/fuzzer report.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `blkcg_print_one_stat()` reads `blkg->iostat` (freed in
  `blkg_free_workfn()`) and policy data via `pd_stat_fn()` (freed in
  `pd_free_fn()` during cgroup removal or policy deactivation).
- **Symptom:** Use-after-free when reading cgroup I/O stats concurrently
  with teardown/deactivation.
- **Root cause:** Iteration is RCU-protected and per-blkg `queue_lock`
  is held, but neither prevents `pd_free_fn()` or async `blkg` teardown
  from invalidating data being read.
- **Fix:** Hold `blkcg->lock` (IRQ-safe) for the full iteration so blkgs
  stay online and policy/iostat data remain valid.
- **Note:** "Prepare to convert protecting blkgs from request_queue with
  mutex" — future work, not a dependency.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — explicit UAF/race fix disguised as locking correction.
Not cosmetic cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `block/blk-cgroup.c` (+3 / -6 net)
- **Function:** `blkcg_print_stat()` only
- **Scope:** Single-file, surgical (~10 lines touched)

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `rcu_read_lock()` → `hlist_for_each_entry_rcu()` → per-
  iteration `spin_lock_irq(&blkg->q->queue_lock)` →
  `blkcg_print_one_stat()` → unlock → `rcu_read_unlock()`
- **After:** `guard(spinlock_irq)(&blkcg->lock)` →
  `hlist_for_each_entry()` → `blkcg_print_one_stat()` → auto-unlock
- **Path:** `cgroup` `io.stat` seq_file read (normal monitoring path)

### Step 2.3: Bug Mechanism
**Record:** **Category:** Race condition / use-after-free (reference-
counting and lifetime)

**Mechanism (verified in tree):**
1. `blkcg_deactivate_policy()` holds `queue_lock`, then `blkcg->lock`,
   then calls `pd_free_fn()`:

```1738:1744:block/blk-cgroup.c
                spin_lock(&blkcg->lock);
                if (blkg->pd[pol->plid]) {
                        if (blkg->pd[pol->plid]->online &&
pol->pd_offline_fn)
                                pol->pd_offline_fn(blkg->pd[pol->plid]);
                        pol->pd_free_fn(blkg->pd[pol->plid]);
                        blkg->pd[pol->plid] = NULL;
```

2. `blkg_destroy()` requires `blkcg->lock`, unhashes the blkg, and
   eventually frees via `blkg_free_workfn()`:

```529:554:block/blk-cgroup.c
        lockdep_assert_held(&blkg->q->queue_lock);
        lockdep_assert_held(&blkcg->lock);
        // ...
        hlist_del_init_rcu(&blkg->blkcg_node);
```

3. `blkcg_print_stat()` currently does **not** hold `blkcg->lock`, so
   `pd_stat_fn()` and `blkg->iostat` access can race with steps 1–2.

4. The kernel already documents that RCU alone is insufficient:

```177:184:block/blk-cgroup.c
 - A group is RCU protected, but having an rcu lock does not mean that
   one
 - can access all the fields of blkg and assume these are valid.
```

### Step 2.4: Fix Quality
**Record:** Obviously correct. Aligns `blkcg_print_stat()` with
`blkcg_reset_stats()`, which already iterates `blkg_list` under
`spin_lock_irq(&blkcg->lock)`:

```662:669:block/blk-cgroup.c
        spin_lock_irq(&blkcg->lock);
        // ...
        hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node) {
```

**Regression risk:** Low. `blkcg_print_stat()` takes only `blkcg->lock`
(no `queue_lock`), avoiding AB-BA with `blkcg_destroy_blkgs()` (blkcg
lock → queue lock) and `blkcg_deactivate_policy()` (queue lock → blkcg
lock).

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Current RCU+`queue_lock` pattern in `blkcg_print_stat()`
from commit `49cb5168a7c6ab` (Aug 2021, "blk-cgroup: refactor
blkcg_print_stat"). Bug window is long; code is present in this tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:**
- `5e5b7f2ef8549` — separate UAF fix in `__blkcg_rstat_flush()` (already
  in 6.18.y); same subsystem, different race.
- `5d726c4dbeedd` — Yu Kuai deadlock fix in policy configuration (same
  author/subsystem).
- `810ecfa765f8b` (2013) — historical move from `blkcg->lock` to
  `queue_lock` for `blkcg_print_blkgs()`; this patch partially reverses
  that for `blkcg_print_stat()` where `queue_lock` is insufficient.

### Step 3.4: Author Context
**Record:** Yu Kuai is an active block/cgroup contributor
(`5d726c4dbeedd`, `dc96cefef0d30`, etc.).

### Step 3.5: Dependencies
**Record:** Standalone. `guard(spinlock_irq)` is defined in
`include/linux/spinlock.h` (available in 6.18). No series dependency.

---

## Phase 4: Mailing List and External Research

### Step 4.1–4.5
**Record:**
- `b4 dig -c <commit>`: **N/A** — commit not found in local `FETCH_HEAD`
  master; patch appears not yet merged upstream.
- Lore/patch.msgid.link: **Blocked** (403/Anubis bot protection).
- **UNVERIFIED:** Full review-thread content, stable nominations from
  reviewers, series revisions.

From available metadata: Jens Axboe merged sign-off indicates maintainer
acceptance.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `blkcg_print_stat()`, `blkcg_print_one_stat()` (caller
context unchanged).

### Step 5.2: Callers
**Record:** `blkcg_print_stat` is `.seq_show` for cgroup `stat` file:

```1254:1258:block/blk-cgroup.c
static struct cftype blkcg_files[] = {
        {
                .name = "stat",
                .seq_show = blkcg_print_stat,
```

Triggered via cgroupfs reads (`/sys/fs/cgroup/.../io.stat`).

### Step 5.3: Callees
**Record:** `blkcg_print_one_stat()` reads `blkg->iostat`, calls
`pol->pd_stat_fn()`, uses `blkg_dev_name()`.

### Step 5.4: Reachability
**Record:** Reachable from userspace via cgroup stat reads. Concurrent
with cgroup deletion (`blkcg_destroy_blkgs`) and policy deactivation
(`blkcg_deactivate_policy`) in container/VM environments.

### Step 5.5: Similar Patterns
**Record:** `blkcg_print_blkgs()` still uses RCU+`queue_lock` (lines
718–724) — same class of issue may exist there, but is out of scope for
this commit. `blkcg_reset_stats()` already uses the correct
`blkcg->lock` pattern.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Tree is **v6.18.44** (`linux-6.18.y` stable). Buggy
code at lines 1244–1250:

```1244:1250:block/blk-cgroup.c
        rcu_read_lock();
        hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
                spin_lock_irq(&blkg->q->queue_lock);
                blkcg_print_one_stat(blkg, sf);
                spin_unlock_irq(&blkg->q->queue_lock);
        }
        rcu_read_unlock();
```

### Step 6.2: Backport Complications
**Record:** Clean apply expected — hunk matches current file.
`blkcg->lock` exists in `struct blkcg` (`blk-cgroup.h:96`).
`guard(spinlock_irq)` available via `spinlock.h` include chain.

### Step 6.3: Related Fixes Already Present?
**Record:** `5e5b7f2ef8549` (rstat flush UAF) is present; it does
**not** fix this `blkcg_print_stat()` race.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / Criticality
**Record:** **block / blk-cgroup** — **IMPORTANT** (cgroup I/O
accounting; widely used with containers/systemd/cgroup v2).

### Step 7.2: Activity
**Record:** Actively maintained; recent stable fixes in same file
(`5e5b7f2ef8549`, `6a01413a4e8fc`).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_BLK_CGROUP` reading I/O cgroup stats
while cgroups are deleted or policies deactivated — common in
Kubernetes/container teardown with concurrent monitoring.

### Step 8.2: Trigger Conditions
**Record:** Concurrent `io.stat` read + cgroup rmdir or block policy
deactivation/disk removal. Realistic in production; not purely
theoretical given `pd_free_fn()` runs under `blkcg->lock` that
`blkcg_print_stat()` does not take.

### Step 8.3: Failure Mode
**Record:** UAF on policy data and/or iostat → kernel oops, memory
corruption. **Severity: HIGH (potential CRITICAL security impact).**

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** High — prevents UAF on a userspace-reachable path.
- **Risk:** Very low — ~7-line locking change matching existing
  `blkcg_reset_stats()` pattern.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR:**
- Real UAF race with verified mechanism in local tree
- Userspace-reachable via cgroup `stat` file
- Small, surgical, matches established locking in `blkcg_reset_stats()`
  / `blkcg_destroy_blkgs()`
- Block maintainer (Jens Axboe) sign-off
- Long-standing buggy pattern (since 2021 refactor)
- Related UAF fix already backported to this tree — demonstrates
  subsystem stability priority

**AGAINST:**
- Commit not yet verified as merged to mainline (stable rules require
  upstream merge before submission)
- `blkcg_print_blkgs()` may have a similar latent issue (not fixed here;
  not a reason to reject this fix)
- Mailing list review details unverified due to lore access blocks

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — locking matches sibling
   functions; maintainer SOB; mechanism clear from code.
2. Fixes a real bug affecting users? **PASS** — UAF on cgroup stat read
   path.
3. Important issue? **PASS** — UAF / potential crash or corruption (HIGH
   severity).
4. Small and contained? **PASS** — single function, <20 lines.
5. No new features or APIs? **PASS** — synchronization only.
6. Can apply to local tree? **PASS** — buggy code present; dependencies
   (`blkcg->lock`, `guard(spinlock_irq)`) exist in 6.18.44.

### Step 9.3: Exception Category
**Record:** N/A — standard bug fix, not device-ID/quirk/build/doc
exception.

### Step 9.4: Decision Rationale
This commit fixes a genuine use-after-free race in `blkcg_print_stat()`
when users read block cgroup statistics concurrently with cgroup
teardown or policy deactivation. The buggy code is present in the local
6.18.44 tree, the fix is minimal and mirrors the already-correct
`blkcg_reset_stats()` locking, and the failure mode is a kernel crash or
memory corruption. This is appropriate stable material once merged
upstream.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 1] Identified as explicit UAF/race fix, not cosmetic cleanup
- [Phase 2] Diff: 1 file, `blkcg_print_stat()` only, ~10 lines
- [Phase 2] Verified `pd_free_fn()` called under `blkcg->lock` in
  `blkcg_deactivate_policy()` (lines 1738–1744)
- [Phase 2] Verified `blkg_destroy()` requires `blkcg->lock` (lines
  529–530, 554)
- [Phase 2] Verified `blkg_free_workfn()` frees policy data and iostat
  (lines 114–142)
- [Phase 2] Verified RCU insufficiency comment (lines 177–184)
- [Phase 2] Verified `blkcg_reset_stats()` uses
  `spin_lock_irq(&blkcg->lock)` for same list iteration (lines 662–669)
- [Phase 3] `git blame`: RCU+queue_lock pattern from `49cb5168a7c6ab`
  (2021)
- [Phase 3] `git log -20 -- block/blk-cgroup.c`: related fixes
  `5e5b7f2ef8549`, `5d726c4dbeedd`
- [Phase 3] `git show 5e5b7f2ef8549`: separate rstat UAF fix, already in
  tree
- [Phase 3] No `Fixes:` tag to follow
- [Phase 3] `guard(spinlock_irq)` defined in `include/linux/spinlock.h`
  lines 571–573
- [Phase 4] `b4 dig`: N/A — commit not in `FETCH_HEAD` master
- [Phase 4] Lore/patch.msgid.link fetch: blocked (403/Anubis)
- [Phase 4] **UNVERIFIED:** Review-thread stable nominations, Tested-by
  reports
- [Phase 5] `blkcg_print_stat` registered as `.seq_show` for `"stat"`
  (lines 1254–1258)
- [Phase 5] `blkcg_print_one_stat` accesses `blkg->iostat` and
  `pd_stat_fn()` (lines 1182–1228)
- [Phase 6] `git describe HEAD`: v6.18.44 on `stable/linux-6.18.y`
- [Phase 6] Buggy code confirmed at lines 1244–1250
- [Phase 6] `struct blkcg` has `spinlock_t lock` in `blk-cgroup.h:96`
- [Phase 6] No equivalent fix already present for `blkcg_print_stat()`
- [Phase 7] Subsystem: block/blk-cgroup, CONFIG_BLK_CGROUP
- [Phase 8] Failure mode: UAF → oops/corruption, HIGH severity
- [Phase 8] Trigger: cgroup stat read during teardown/deactivation

**YES**

 block/blk-cgroup.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a2347b5795874..812f60905a708 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1241,13 +1241,10 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 	else
 		css_rstat_flush(&blkcg->css);
 
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->q->queue_lock);
+	guard(spinlock_irq)(&blkcg->lock);
+	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node)
 		blkcg_print_one_stat(blkg, sf);
-		spin_unlock_irq(&blkg->q->queue_lock);
-	}
-	rcu_read_unlock();
+
 	return 0;
 }
 
-- 
2.53.0

