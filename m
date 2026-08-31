Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E3C508383;
	Mon, 31 Aug 2026 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183746; cv=none; b=lR2uQkvY6N5+R2EZ+aadLauu12zKGmOkSvKcPUmowt3RJhkujt5ZhNTWhbiXq3aUeEoZZM5c3dOG4ZSqFFnXVyNMeDempNf39rSJwmGs9L2khd6jJFw0tcAmWdIYGjy2IitjXrBcDJU1nV209G6qu/9oY/QjNvce0AIoQ+m0h28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183746; c=relaxed/simple;
	bh=JoEP6Ipo6byrIOxydR9E/h7I219CBrDGqwfEdH+p5vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=motusp1plkhpW9vGnybXNDg6x7fwcX+h8JC8Q75TD5zasjoAJHO4BxvTWhJdh7ggFT7ebVwkGDa8zyx07hR6axyDop401Ginn+9ffF5G4hAkjcU1HZ/oxT+vOhgX0BcJ+F4ZcGC8OwJ6ZV5Lqhre/uDcO2ZAF2rpy5JFoeHTHyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYQx37Ic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYQx37Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F5D1F00ACF;
	Mon, 31 Aug 2026 13:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183744;
	bh=nIglp5nNykqg/DFMdZW1G8RO3BXqE82KyiWcozCeWXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XYQx37IcbrCggZJ2YBDULgVqlxxMI29dJ4Z/MYW6m+O7T37Nxsa/ag799g2AUeaIb
	 oGjpKnVRVF8KczTmSUfOsmY7ImSaf5OTU4nzAcDOSbJJ9j4Exkddow/SXDempuMeMv
	 B62bIHnJ0hjmndTL8psNA6//TLZvx0YvhufEzc7ZZYzD55DexWehdLiwM8htEk/zQR
	 xNrM4ulsgToBpEgzRMwDFLBXX20up4g0ldiivxA1mgjvMJ9ELEBvxvjLp7MjRV9hnf
	 bxIFzX1nVfKgF9wAub5SuXz9Cu1BzbMmwJ+Chp4q5Dzhvl+eleonFClbEG+VP4rm8W
	 Bil0dmwX48XIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	josef@toxicpanda.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] blk-cgroup: fix leaks and online flag on radix_tree_insert failure
Date: Mon, 31 Aug 2026 09:25:06 -0400
Message-ID: <20260831133314.4125787-278-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit dbbca20764382b4d411ec2918f4e278ffe547acc ]

When radix_tree_insert() fails in blkg_create(), the error path has two
issues:

1. blkg->online is set to true unconditionally, even when the blkg was
   never fully inserted.  Move the assignment inside the success block.

2. The error path calls blkg_put() without first calling
   percpu_ref_kill().  Because the refcount is still in percpu mode,
   percpu_ref_put() only does this_cpu_sub() without checking for zero,
   so blkg_release() is never triggered.  This permanently leaks the
   blkg memory, its percpu iostat, policy data, the parent blkg
   reference, and the cgroup css reference — the latter preventing the
   cgroup from ever being destroyed.

Fix by replacing blkg_put() with percpu_ref_kill(), matching the pattern
used in blkg_destroy().

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Link: https://patch.msgid.link/20260715132407.1469777-1-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `blk-cgroup: fix leaks and online flag on
radix_tree_insert failure`

**Local tree:** `v6.18.44` (Linux 6.18.44 stable)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**

Record: `[blk-cgroup]` `[fix]` — fixes resource leaks and incorrect
`online` flag when `radix_tree_insert()` fails in `blkg_create()`.

**Step 1.2 — Tags**

Record:
- **Acked-by:** Tejun Heo `<tj@kernel.org>` (cgroup/block-cgroup
  maintainer)
- **Signed-off-by:** Tao Cui `<cuitao@kylinos.cn>` (author)
- **Signed-off-by:** Jens Axboe `<axboe@kernel.dk>` (block layer
  maintainer)
- **Link:**
  https://patch.msgid.link/20260715132407.1469777-1-cui.tao@linux.dev
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, or Cc: stable tags
- (Ignoring pipeline-added Signed-off-by: Sasha Levin per instructions)

**Step 1.3 — Body analysis**

Record:
- **Bug:** When `radix_tree_insert()` fails in `blkg_create()`, two
  errors occur:
  1. `blkg->online = true` is set even though the blkg was never
     inserted into the tree.
  2. Error path calls `blkg_put()` without `percpu_ref_kill()`. While
     the refcount is still in percpu mode, `percpu_ref_put()` only
     decrements a per-CPU counter and never checks for zero, so
     `blkg_release()` is never called.
- **Symptom/failure mode:** Permanent leak of blkg memory, percpu
  iostat, policy data, parent blkg reference, and cgroup css reference —
  the css leak prevents the cgroup from ever being destroyed.
- **Root cause:** Wrong teardown primitive on the error path;
  `blkg_destroy()` correctly uses `percpu_ref_kill()`.

**Step 1.4 — Hidden bug fix?**

Record: No — this is an explicit bug fix, not disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**

Record:
- **Files:** `block/blk-cgroup.c` only (+2 / −2 lines, 4 lines touched)
- **Function:** `blkg_create()`
- **Scope:** Single-file, surgical fix

**Step 2.2 — Code flow change**

Record:
- **Hunk 1:** `blkg->online = true` moved inside the `if (likely(!ret))`
  success block.
  - Before: online set unconditionally after insert attempt.
  - After: online only set when insert succeeds.
- **Hunk 2:** Error path changed from `blkg_put(blkg)` to
  `percpu_ref_kill(&blkg->refcnt)`.
  - Before: percpu-mode put never triggers release callback.
  - After: switches to atomic mode and triggers `blkg_release()` →
    `__blkg_release()` → `css_put()` + `blkg_free()`.

**Step 2.3 — Bug mechanism**

Record: **Reference counting / resource leak fix.** Category (a) error-
path leak + (g) logic correctness (online flag). The percpu_ref
lifecycle requires `percpu_ref_kill()` before the final drop can trigger
the release function — documented in `include/linux/percpu-refcount.h`
lines 19–24.

**Step 2.4 — Fix quality**

Record: Obviously correct — mirrors `blkg_destroy()` at line 568.
Minimal change. Very low regression risk; only affects the rare
`radix_tree_insert()` failure path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**

Record: Buggy lines in this tree all from `5d324e5159d9e` (v6.18 merge,
Nov 2025). Same pattern present in `v6.12` and `v6.17` per `git show`.

**Step 3.2 — Fixes: tag**

Record: Not applicable — no Fixes: tag in commit message.

**Step 3.3 — Related file history**

Record:
- `93383b6681074` — "wait for blkcg cleanup before initializing new
  disk" — reduces `-EEXIST` from `radix_tree_insert()` during disk
  rebind, but does not fix the broken error path when insert still
  fails.
- `5e5b7f2ef8549` — UAF fix in `__blkcg_rstat_flush()` (related
  subsystem, separate issue).
- Fix commit on master: `dbbca20764382` (Jul 15, 2026); **not** an
  ancestor of current HEAD (`merge-base` exit 1).

**Step 3.4 — Author context**

Record: Tao Cui; Acked-by Tejun Heo (blk-cgroup/cgroup maintainer). No
other Tao Cui commits in this tree's `block/blk-cgroup.c` history.

**Step 3.5 — Dependencies**

Record: Standalone — no series dependencies, no prerequisite commits
required. Self-contained 4-line change.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**

Record:
- `b4 dig -c dbbca20764382`:
  https://patch.msgid.link/20260715132407.1469777-1-cui.tao@linux.dev
- Series: v4 only (no v1–v3 in b4 results; v4 is the applied version)
- No NAKs found in saved mbox
- No explicit Cc: stable nomination in thread headers

**Step 4.2 — Reviewers**

Record: `b4 dig -w` CC'd: tj@kernel.org, axboe@kernel.dk,
josef@toxicpanda.com, cgroups@vger.kernel.org, linux-
block@vger.kernel.org. Tejun Heo Acked-by.

**Step 4.3 — Bug report**

Record: No external bug report or syzbot link. Bug identified via code
review of percpu_ref lifecycle.

**Step 4.4 — Related patches**

Record: Complementary to `93383b6681074` (reduces trigger frequency) but
independently needed for correct error handling.

**Step 4.5 — Stable list**

Record: No stable@vger.kernel.org discussion found for this specific
fix.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**

Record: `blkg_create()` modified; related: `blkg_destroy()`,
`blkg_release()`, `__blkg_release()`, `blkg_free()`.

**Step 5.2 — Callers**

Record: `blkg_create()` called from:
- `blkg_lookup_create()` — I/O hot path via `blkg_tryget_closest()` →
  `bio_assoc_blkcg()` (line 2113)
- `blkg_conf_prep()` — cgroup sysfs configuration (uses
  `radix_tree_preload`)
- `blkcg_init_disk()` — disk initialization (uses `radix_tree_preload`)

`blkg_lookup_create()` does **not** call `radix_tree_preload()`, so
`-ENOMEM` from `radix_tree_insert()` is reachable under memory pressure.

**Step 5.3 — Callees**

Record: On failure path after fix: `percpu_ref_kill()` →
`blkg_release()` → `__blkcg_rstat_flush()` + `call_rcu(__blkg_release)`
→ `css_put()` + `blkg_free()` → `blkg_free_workfn()` releases parent
ref, policy data, queue ref, percpu iostat.

**Step 5.4 — Reachability**

Record: Reachable from block I/O path when `CONFIG_BLK_CGROUP` is
enabled and a new blkg must be created for a cgroup/disk pair. Userspace
cgroup management can also trigger via `blkg_conf_prep()`. Unprivileged
users can trigger via I/O in their cgroup.

**Step 5.5 — Similar patterns**

Record: `blkg_destroy()` at line 568 already uses
`percpu_ref_kill(&blkg->refcnt)` — fix aligns error path with
established pattern. `include/linux/percpu-refcount.h` documents that
`percpu_ref_put()` does not check for zero before `percpu_ref_kill()`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

**Step 6.1 — Buggy code present?**

Record: **YES.** Current tree at lines 436 and 443:

```436:444:block/blk-cgroup.c
        blkg->online = true;
        spin_unlock(&blkcg->lock);

        if (!ret)
                return blkg;

        /* @blkg failed fully initialized, use the usual release path */
        blkg_put(blkg);
        return ERR_PTR(ret);
```

Bug present since at least v6.12 in this repository's history.

**Step 6.2 — Backport complications**

Record: Trivial change; `git apply --check` on upstream patch fails only
because stable has `err_put_css:` label that mainline parent lacks
(context line difference below the hunk). The three actual changed lines
apply without modification. Expected difficulty: **minor context
adjustment, not rework**.

**Step 6.3 — Related fixes already present?**

Record: `93383b6681074` is present (reduces `-EEXIST` trigger). This
specific leak fix is **not** present.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**

Record: **block/blk-cgroup** — CORE/IMPORTANT subsystem. Affects all
systems using cgroup v1/v2 block controller (`CONFIG_BLK_CGROUP`).

**Step 7.2 — Activity**

Record: Active maintenance in 6.18.y — recent fixes include UAF
(`5e5b7f2ef8549`), disk reference leak (`b3e005f16cd98`), blkcg cleanup
wait (`93383b6681074`).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**

Record: Systems with `CONFIG_BLK_CGROUP` enabled — container hosts
(Kubernetes, Docker, systemd cgroups), cloud VMs, any workload using
block I/O cgroup controller.

**Step 8.2 — Trigger conditions**

Record:
- `radix_tree_insert()` returns error (`-ENOMEM` most likely in
  `blkg_lookup_create()` without preload; `-EEXIST` possible in races
  despite `93383b6681074`)
- Requires blkg creation for a new cgroup/disk pair
- Unprivileged cgroup users can trigger via I/O; cgroup admin via sysfs
- Not every boot — requires memory pressure or specific race — but
  consequences are permanent

**Step 8.3 — Failure mode severity**

Record:
- **Permanent memory/resource leak** (blkg, iostat, policy data)
- **Cgroup css reference leak → cgroup cannot be destroyed** —
  functional breakage for container lifecycle
- **Incorrect online flag** — minor (e.g., `blkcg_print_one_stat()` at
  line 1190 may process a non-inserted blkg)
- Severity: **HIGH** (resource leak with cgroup destruction blocked; not
  a crash but serious operational impact)

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** HIGH — prevents unrecoverable resource leaks and stuck
  cgroups
- **Risk:** VERY LOW — 4-line change, matches existing `blkg_destroy()`
  pattern, only affects error path
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

**FOR:**
- Real, verifiable resource leak on error path
- Cgroup css leak prevents cgroup destruction — serious for production
  container workloads
- Small, surgical, maintainer-acked fix
- Buggy code confirmed present in v6.18.44
- Matches documented percpu_ref semantics and existing `blkg_destroy()`
  pattern
- Reachable from common I/O and cgroup configuration paths

**AGAINST:**
- Rare trigger (radix_tree_insert failure)
- No syzbot/user crash report
- Upstream patch needs trivial context adjustment for `err_put_css:`
  label

**UNRESOLVED:**
- No quantitative data on how often `radix_tree_insert()` fails in
  production

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — mechanism verified against
   `percpu-refcount.h` and `blkg_destroy()`; Acked-by cgroup maintainer
2. Fixes real bug affecting users? **PASS** — permanent leak + cgroup
   destruction blocked
3. Important issue? **PASS** — HIGH severity resource leak affecting
   cgroup lifecycle
4. Small and contained? **PASS** — 4 lines, one function, one file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — trivial manual apply (minor
   context difference only)

**Step 9.3 — Exception categories**

Record: Not applicable (standard bug fix, not device ID/quirk/build/doc
exception).

**Step 9.4 — Decision rationale**

This commit fixes a genuine error-path bug in `blkg_create()` where
failed `radix_tree_insert()` leaves resources permanently leaked because
`blkg_put()` cannot trigger `blkg_release()` while the percpu refcount
is still in percpu mode. The css reference leak prevents cgroup
destruction — a significant operational issue for any system using block
cgroups. The fix is minimal, follows the established `blkg_destroy()`
pattern, is acked by the cgroup maintainer, and the buggy code is
present in this v6.18.44 tree without the fix.

---

## Verification

- [Phase 1] `git show dbbca20764382`: parsed subject, tags, body; Acked-
  by Tejun Heo confirmed
- [Phase 2] Read `block/blk-cgroup.c` lines 371–452, 524–569, 1190; read
  `include/linux/percpu-refcount.h` lines 19–24, 147–150, 326–352
- [Phase 2] Confirmed `blkg_put()` → `percpu_ref_put()` in `block/blk-
  cgroup.h` line 336–338
- [Phase 3] `git describe HEAD`: v6.18.44; `git blame -L 419,452`: buggy
  code from 5d324e5159d9e
- [Phase 3] `git merge-base --is-ancestor dbbca20764382 HEAD`: exit 1 —
  fix NOT in tree
- [Phase 3] `git show v6.12/v6.17:v6.18:block/blk-cgroup.c`: same buggy
  pattern back to v6.12
- [Phase 3] `93383b6681074` present in tree; complementary, not
  substitute
- [Phase 4] `b4 dig -c dbbca20764382`: lore URL found; v4 series
- [Phase 4] `b4 dig -w`: maintainers CC'd; Tejun Heo Acked-by
- [Phase 4] `b4 dig -m /tmp/blkcg_fix.mbox`: no Cc: stable in thread
- [Phase 5] Grep callers: `blkg_create` at lines 510, 936, 1526;
  `blkg_lookup_create` at 2113
- [Phase 5] Confirmed `blkg_lookup_create` does not use
  `radix_tree_preload` (only `blkg_conf_prep` and `blkcg_init_disk` do)
- [Phase 6] Buggy code at lines 436, 443 confirmed in working tree
- [Phase 6] `git apply --check` fails on context below hunk
  (`err_put_css:` vs `err_free_blkg:`); actual 3 changed lines are
  identical — trivial backport
- [Phase 8] Failure mode: permanent leak + cgroup destruction blocked;
  severity HIGH

**YES**

 block/blk-cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 812f60905a708..9aa3b6ae81ca8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -432,15 +432,15 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 				blkg->pd[i]->online = true;
 			}
 		}
+		blkg->online = true;
 	}
-	blkg->online = true;
 	spin_unlock(&blkcg->lock);
 
 	if (!ret)
 		return blkg;
 
 	/* @blkg failed fully initialized, use the usual release path */
-	blkg_put(blkg);
+	percpu_ref_kill(&blkg->refcnt);
 	return ERR_PTR(ret);
 
 err_put_css:
-- 
2.53.0

