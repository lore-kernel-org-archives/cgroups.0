Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF18D5FC780;
	Mon, 19 Oct 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418569; cv=none; b=Wbv0Jx10holXSqrLe82aKIgdRbrXFoFAw1OxzJDwJMPhBbNRuzd1pzZ3e+zIkdIeg1ZWWi+Quv33Rn0YxU19EIHbcF0MC5rWpipho8smOPBMifJEB0QfWxMcLAvTPeFFGTYNzs/X5h68VGmizw7oW4CJPFikMQ2zinX8HQF6IZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418569; c=relaxed/simple;
	bh=93xRt5SqTDeuO4zPLFVami2lPD1a5rffG1IebGHPqMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FUYuH6siLpBJBnObBG9BcEZpWonnEmPZccHoJ++nTNN221W0vtDLpM+XR+D562xALIRC46BSM2+XNkajG7qh4q95z26hrHrcfpBzlrHxeiwUOlKrM83J9T+lx+QR5i0KA7uiYAk8g7+Ipsjwb2Iowd/+713nfu/EIkQ4z8qbTHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ak8DZthQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ak8DZthQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D1A1F000C6;
	Mon, 19 Oct 2026 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418566;
	bh=xnMRlEbWMji5JvM0Y6k9F2Yr83rEUi+mlxkt5SalFyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ak8DZthQfV7UxlY0jDW5rwrqfp8aI/t4J+IcFWa6FBrHkImQSFd/qB/za0WCdhQWZ
	 xBgAwmKGENXEZhUMXqXql6yJFDjvyqKw3XKrQmG2PzZHH5o/MbENTfJGpKt3RwCXD8
	 5EVmbekqBO2D1n9oPZamGXQrnMyHg2Suz4VzmFStrDB7B5XgmrmSv69l8lE4vDyfzy
	 LWFxgWN/xFUK8udKethalsC0RtmjQzrJeQRiE2hA2Xm55L3lAZxfOCnv8YKfdv6IQl
	 FeDbRQJnTeIlgtd9LS6hTlWK+3yVhJ9QWPR6R8EsMlqDTXMm+SMXVPQrzfoxLV9erY
	 Nxlw+en1BD6HA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhe Liu <liuzhe1@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] docs: cgroup-v2: fix stale "io" controller introduction
Date: Mon, 19 Oct 2026 09:50:30 -0400
Message-ID: <20261019135441.1420968-339-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhe Liu <liuzhe1@kylinos.cn>

[ Upstream commit 3345c7248a9e2a91cb9e2477c29af16881706f4f ]

The introductory paragraph for the IO controller still states that
weight based distribution is "available only if cfq-iosched is in use"
and that "neither scheme is available for blk-mq devices".  This text
dates from when the cgroup v2 documentation was first written (2015)
and was correct at the time, but is no longer accurate:

  * cfq-iosched was removed in v5.0;
  * blk-mq is now the only block I/O path, and both the absolute limit
    scheme (io.max via blk-throttle) and the weight based scheme
    (io.weight via iocost, or io.bfq.weight under BFQ) work on it;
  * latency based protection (iolatency) and I/O priority (ioprio)
    controllers have since been added.

The rest of the section already documents io.weight, io.max,
io.cost.{qos,model}, io.latency and io.prio.class correctly, so the
introduction is the only part that contradicts them.  Rewrite it to
reflect the current state.

Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a docs-only correction of text that is
already wrong in 6.12, and the rewrite matches features this tree
actually ships.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [docs / cgroup-v2] [fix] [rewrite the stale IO controller
introduction so it no longer claims CFQ-only weights and no blk-mq
support]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn> (author)
- Reviewed-by: Tao Cui <cuitao@kylinos.cn>
- Signed-off-by: Tejun Heo <tj@kernel.org> (cgroup maintainer; applied
  the patch)
- No Fixes: tag (expected)
- No Reported-by / Tested-by / Link / Cc: stable
- Ignore any pipeline-added Sasha Levin SOB / "[Upstream commit ...]"
  markers; they are not evidence of selection

Notable pattern: maintainer SOB plus a Reviewed-by; single standalone
patch, not a series.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- [Bug] Admin-guide intro for the cgroup v2 "io" controller still says
  weight-based control needs cfq-iosched and that neither weight nor
  limits work on blk-mq.
- [Symptom] Operators reading the intro are told IO control does not
  work on modern (blk-mq-only) kernels, which contradicts the rest of
  the same document.
- [Version info] Text written in 2015; cfq-iosched removed in v5.0; blk-
  mq is now the only block path.
- [Root cause] Documentation was never updated after CFQ removal and
  after iocost / iolatency / ioprio / BFQ cgroup support landed. The
  rest of the section already documents io.weight, io.max,
  io.cost.{qos,model}, io.latency, and io.prio.class.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a hidden runtime bug. It is an explicit documentation
correction of obsolete, contradictory admin-guide text. No leak/race/UAF
disguised as cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `Documentation/admin-guide/cgroup-v2.rst` (+7 / -3, 10 lines
  with context)
- Functions modified: none (prose only)
- Scope: single-file surgical documentation rewrite of one introductory
  paragraph

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: "weight based distribution is available only if cfq-iosched is
  in use and neither scheme is available for blk-mq devices."
- After: Absolute BPS/IOPS limits via blk-throttle on all devices;
  proportional weight via iocost (`CONFIG_BLK_CGROUP_IOCOST`) and BFQ
  (`io.bfq.weight` when BFQ is the device scheduler); also iolatency
  (`CONFIG_BLK_CGROUP_IOLATENCY`) and ioprio
  (`CONFIG_BLK_CGROUP_IOPRIO`).
- Path affected: documentation readers only; no kernel execution path.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Logic / correctness in documentation] The intro describes
2015-era CFQ/legacy-request_fn constraints that do not exist in this
tree. Not a memory-safety, locking, or refcount bug.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct relative to this tree: CFQ is gone, blk-mq is the
  I/O path, and the named configs/files exist.
- Minimal: one paragraph, no unrelated edits.
- Regression risk: none at runtime. Residual docs risk is only if the
  new sentence were wrong; it matches `block/Kconfig`,
  `block/Kconfig.iosched`, and the later IO sections of the same file.
  `io.bfq.weight` is documented in `Documentation/block/bfq-
  iosched.rst`, not in the cgroup-v2 interface-file list; that is
  consistent with the intro pointing at BFQ's own cgroup support.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Stale paragraph introduced by `6c2920926b10e8` ("cgroup: replace
unified-hierarchy.txt with a proper cgroup v2 documentation", Tejun Heo,
2015-11-16). Present since cgroup v2 docs were written. Converted to rST
by `633b11bee40c37` (2017) without changing that claim. `git merge-base
--is-ancestor 6c2920926b10e8 HEAD` succeeded.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. The "bug" is long-lived stale
documentation, not a later functional regression.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `cgroup-v2.rst` changes in this tree are unrelated
(writeback folio conversion, mm/zswap docs, cgroup-for-6.12 merge). No
prerequisite refactor of the IO intro. Standalone one-patch change (b4:
v1 only, not patch X/Y).

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Zhe Liu has this one commit on `origin/master` for this file.
Tejun Heo (cgroup maintainer) applied it. Tao Cui reviewed and corrected
the CFQ-removal version in the commit message from v4.12 to v5.0.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No code-structure dependencies. The rewrite only names
controllers/configs that already exist in 6.12 (`BLK_CGROUP_IOCOST`,
`BLK_CGROUP_IOLATENCY`, `BLK_CGROUP_IOPRIO`, `BFQ_GROUP_IOSCHED`,
`BLK_DEV_THROTTLING`). Can apply standalone. `git show 3345c7248a9e2 |
git apply --check` succeeded at offset -172 lines.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- Commit: `3345c7248a9e2a91cb9e2477c29af16881706f4f` (not an ancestor of
  this HEAD; `git merge-base --is-ancestor` exit 1)
- b4 dig:
  https://patch.msgid.link/20260810063535.327765-1-liuzhe1@kylinos.cn
- Single v1 series; no v2/v3. Tejun applied v1 after fixing the CFQ
  version in the changelog.
- Reviewer feedback: Tao Cui, "cfq-iosched was removed in v5.0, not
  v4.12 (f382fb0bcef4)". Otherwise "looks good." Reviewed-by added.
- Tejun: "Applied to cgroup/for-7.3 with the cfq removal version in the
  description corrected to v5.0"
- No NAK, no stable nomination in the thread
- Included in the v7.3 cgroup pull (`[GIT PULL] cgroup: Changes for
  v7.3`)
- Later `origin/master` text of this paragraph is unchanged; no follow-
  up rewrite

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (b4 dig -w): To/Cc included tj@kernel.org, hannes@cmpxchg.org,
mkoutny@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, cgroups@,
linux-doc@, linux-kernel@. Those are the cgroup maintainers plus linux-
doc. Applied by Tejun Heo.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by, bugzilla, or syzbot. Author noticed the intro
contradicting the rest of the same document. Severity from a reporter's
perspective: documentation accuracy, not a crash.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone. Later cgroup-v2 doc commits on `origin/master`
(misc.events, io.latency rotational, io.pressure, etc.) do not touch
this paragraph and are not prerequisites.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable WebFetch returned HTTP 403. UNVERIFIED
whether anyone already requested or rejected this on stable@. No
evidence from b4 or lkml mirrors of a stable discussion.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: None. Documentation only.

Step 5.2: TRACE CALLERS
Record: N/A — no functions. Impact surface is readers of the cgroup v2
admin guide (container/cgroup operators), not a call graph.

Step 5.3: TRACE CALLEES
Record: N/A.

Step 5.4: FOLLOW THE CALL CHAIN
Record: N/A for kernel reachability. The misleading text is in the
primary user-facing cgroup v2 document. Userspace does not "trigger" a
bug; operators can be misled about whether io.max / io.weight work.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: `cfq-iosched` in this tree's docs remains only in this stale
intro (plus an unrelated historical RCU lockdep-splat example).
`init/Kconfig` BLK_CGROUP help still mentions CFQ; that is a separate
stale-help issue, not part of this patch.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. Local tree is **6.12.111** (`pending-6.12`, `git describe
HEAD` = p-6.12-3-gc504cf0baa3d8). Stale text is at `Documentation/admin-
guide/cgroup-v2.rst` lines 1834–1838. Features the rewrite describes are
present:
- CFQ source `block/cfq-iosched.c` absent; removed by `f382fb0bcef4`
  (ancestor of HEAD)
- iocost: `block/blk-iocost.c`, `CONFIG_BLK_CGROUP_IOCOST`
  (`7caa47151ab2e`, ancestor)
- iolatency: `block/blk-iolatency.c` (`d70675121546c`, ancestor)
- ioprio: `block/blk-ioprio.c` (`556910e39249d`, ancestor)
- blk-throttle: `CONFIG_BLK_DEV_THROTTLING`
- BFQ cgroup: `CONFIG_BFQ_GROUP_IOSCHED`, `io.bfq.weight` in
  `Documentation/block/bfq-iosched.rst`
- Same file already documents io.cost.*, io.weight, io.max, io.latency,
  io.prio.class

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply with hunk offset -172 (upstream intro at ~1988; this
tree at ~1833). Surrounding Memory Ownership / IO Interface Files
context matches. Difficulty: clean apply.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `git log --grep='stale "io" controller'` and `--grep='cfq-
iosched'` on this file: empty. No equivalent fix in this checkout. `git
merge-base --is-ancestor 3345c7248a9e2 HEAD` failed.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [Documentation / cgroup v2 admin-guide] Criticality: IMPORTANT
for operators (the user-facing contract for cgroup IO), PERIPHERAL for
kernel runtime (no code change). MAINTAINERS: CONTROL GROUP, Tejun Heo
et al., file `Documentation/admin-guide/cgroup-v2.rst`.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: cgroup-v2.rst still receives interface-doc updates. The IO intro
itself has been untouched since 2015. Mature, long-stale paragraph
rather than a bug in brand-new code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Anyone reading the cgroup v2 IO intro on 6.12 (container hosts,
systemd/cgroup users, Kubernetes node kernels). Not a
runtime/config/platform subset. No kernel code path changes.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Reading the admin guide. Common for operators enabling IO
control. Not a race; not triggerable as a crash by unprivileged users.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [Failure mode] Contradictory, obsolete documentation: claims IO
weight/limits do not work on blk-mq, i.e. on essentially all 6.12 block
devices. [Severity] LOW as kernel runtime; the rest of the same chapter
already describes working interfaces. The harm is misleading operators,
not oops/corruption/deadlock.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: medium for documentation accuracy of a widely used
  controller; the intro currently tells 6.12 users the opposite of
  reality.
- Risk: very low (docs-only, 7 insertions / 3 deletions, apply-check
  clean).
- Ratio: high benefit-to-risk for a documentation exception; no runtime
  regression vector.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Stale intro is present in this 6.12 tree and is factually false here
  (CFQ gone since v5.0; blk-mq-only; iocost/iolatency/ioprio/BFQ all
  present).
- Same document already documents the working interfaces; the intro is
  the part that contradicts them.
- Small, obviously correct, maintainer-applied (Tejun Heo), Reviewed-by
  Tao Cui.
- Applies cleanly.
- Zero runtime risk.
- Documentation/comment fixes are an allowed stable exception.
- This pending-6.12 tree already carries other `docs:` backports under
  `Documentation/admin-guide/`.

AGAINST:
- Not a crash, UAF, deadlock, corruption, or security hole.
- No user report / syzbot / Cc: stable (absence of Cc: stable is
  expected and not a negative).
- Later sections already describe the real interfaces, so a careful
  reader can recover.
- `stable-kernel-rules.rst` also says no trivial-without-benefit
  changes; this is more than spelling, but it is still docs-only.

UNRESOLVED:
- lore.kernel.org/stable search HTTP 403; no confirmed stable@ thread.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — matches Kconfig and the rest
   of the same document; reviewed and applied by the cgroup maintainer.
2. Fixes a real bug that affects users? **PASS** (documentation bug) —
   the intro is wrong for every 6.12 blk-mq system.
3. Important issue (crash, security, corruption, deadlock)? **FAIL** as
   a runtime severity; **PASS** under the documentation exception
   (incorrect admin-guide, not a spelling nit).
4. Small and contained? **PASS** — 10 lines, one file.
5. No new features or APIs? **PASS** — describes existing 6.12
   interfaces only.
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Documentation fix** (incorrect/obsolete admin-guide text).
That exception applies. Not a device-ID, quirk, DT, or build fix.

Step 9.4: MAKE YOUR DECISION
This should be backported to **this** 6.12 tree. The buggy paragraph is
here, the features the new text describes are here, the patch applies,
and runtime risk is zero. Stable rules allow documentation corrections
of incorrect material; this is not a feature add and not a whitespace
cleanup.

What it solves for stable users: the cgroup v2 admin guide currently
says weight-based IO control needs CFQ and that neither weights nor
limits work on blk-mq. On 6.12 that is false for all block devices and
contradicts io.max / io.weight / iocost / iolatency / ioprio in the same
file.

Risk vs benefit: documentation-only, surgical, maintainer-acked; benefit
is correcting the primary operator document for a common container
feature.

Concerns: none on apply or prerequisites. Not a crash-class fix;
accepted because it is a contained docs correction of still-present
stale text.

Verification:
- [Phase 1] Parsed tags: SOB Zhe Liu, Reviewed-by Tao Cui, SOB Tejun
  Heo; no Fixes/Reported-by/Cc: stable
- [Phase 1] Body: stale 2015 CFQ/blk-mq claims; cfq removed v5.0
- [Phase 2] Diff: `Documentation/admin-guide/cgroup-v2.rst` +7/-3, IO
  intro only
- [Phase 3] `git describe HEAD` / `make kernelversion`:
  p-6.12-3-gc504cf0baa3d8, 6.12.111, branch pending-6.12
- [Phase 3] `git blame`: stale lines from `6c2920926b10e8` (2015);
  ancestor of HEAD
- [Phase 3] `git merge-base --is-ancestor 3345c7248a9e2 HEAD`: not in
  this tree
- [Phase 3] CFQ removal `f382fb0bcef4` is ancestor; no `block/cfq-
  iosched.c`
- [Phase 3] iocost `7caa47151ab2e`, iolatency `d70675121546c`, ioprio
  `556910e39249d` are ancestors
- [Phase 3] `git apply --check` of 3345c7248a9e2: hunk succeeded at 1833
  (offset -172)
- [Phase 4] b4 dig -c 3345c7248a9e2: msgid
  20260810063535.327765-1-liuzhe1@kylinos.cn
- [Phase 4] b4 dig -a: v1 only
- [Phase 4] b4 dig -w: cgroup maintainers + linux-doc on the original
  To/Cc
- [Phase 4] lkml/openwall: Tao Cui v5.0 correction; Tejun applied to
  cgroup/for-7.3; no NAK
- [Phase 4] origin/master still has the rewritten paragraph; no later
  rewrite
- [Phase 4] lore.kernel.org/stable: HTTP 403, UNVERIFIED
- [Phase 5] No functions/callers; docs-only
- [Phase 6] Stale text at lines 1834–1838 of this tree's cgroup-v2.rst;
  io.cost/io.weight/io.max/io.latency/io.prio.class already documented
  below
- [Phase 6] `CONFIG_BLK_CGROUP_IOCOST`, `IOLATENCY`, `IOPRIO`,
  `BFQ_GROUP_IOSCHED`, `BLK_DEV_THROTTLING` exist in this tree
- [Phase 7] MAINTAINERS CONTROL GROUP: Tejun Heo; file listed
- [Phase 8] Failure mode: misleading admin-guide, severity LOW runtime /
  docs exception
- UNVERIFIED: whether this SHA was already discussed on stable@

**YES**

 Documentation/admin-guide/cgroup-v2.rst | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index edcd125d6992f..a62505e55dd07 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1959,9 +1959,13 @@ IO
 
 The "io" controller regulates the distribution of IO resources.  This
 controller implements both weight based and absolute bandwidth or IOPS
-limit distribution; however, weight based distribution is available
-only if cfq-iosched is in use and neither scheme is available for
-blk-mq devices.
+limit distribution.  Absolute BPS and IOPS limits are enforced by
+blk-throttle and apply to all devices, while weight based proportional
+distribution is provided by the iocost cost model controller
+(CONFIG_BLK_CGROUP_IOCOST) and, when the BFQ I/O scheduler is in use
+for a device, by BFQ's own cgroup support.  Latency-based protection
+(CONFIG_BLK_CGROUP_IOLATENCY) and I/O priority assignment
+(CONFIG_BLK_CGROUP_IOPRIO) are also available.
 
 
 IO Interface Files
-- 
2.53.0

