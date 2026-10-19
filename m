Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1EF5D6C8C;
	Mon, 19 Oct 2026 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418512; cv=none; b=AU+vEqCOUPuCXG9lu/LJGK7u84Y2suceJ/uPQfcJL0wNESYpILNrNP0Qt99cwDnyWUGrVKP+jL368MklPrUA0fxvDDHT5w8WKJ/Iaf8mTsrMw1XVRb/eDM9BPbrs85+wwG6vMCB0Lqm3fbX+f8a6XhDYqjsK95OQr4MVvvbVYJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418512; c=relaxed/simple;
	bh=Ldn3g9pm8KgpRUyYul0Z2x5+VApmaplofuvShAA5s7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YXvdhkx1mt4BgsrpzEH7dnty8fc115XdyvqeB8zgjJvE/y9DkcXVF20eEZ530dczgN2iEZ5CvOEUF9pZpsWbS9zSaG8ymHGkT/kgc8/htjz1wOs6l5tSDc9uHrirWgK6yjVULAfNtblBqtIgXu4pqBqq4IgYxcuhVVQ4DGnhydU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C/qidoLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/qidoLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974231F000C7;
	Mon, 19 Oct 2026 14:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418509;
	bh=5fYDhfE3WWxP0b5e/isSFx+04+F0Wkjxq4I0dZ4CyrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/qidoLD7U2R8Bw9XoHqsOqhMxMFvrLWslkUMA5SdqkEF076/mspzlsKCZtQ3CnBk
	 f3nEtaj+H8nAe2pSOjJuWLausL5kqgTU91uOH0Qn0mqJiLhVUnSgCvEH7uAjGnT3CO
	 aCzhLgn191iaY12GhUwLRrjksD3ohLrv90xMLKrwjlNoLvDYG5LQOiZcgHjSfbb1c0
	 nx+5H1f9XBmqN9K3LyF8HKTh8LvzXMtPed4BfYmaVKN8MZDM66Z58cob0HuYdGVg0i
	 c8Hxv2rlkMbzDwUaHlH1eo/4v+JoTCsLyvuGSNoDg2q6fszv3GhmE8xBCsL1PiWg7X
	 epSZPOlf+EF5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joe Simmons-Talbott <joest@redhat.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	hannes@cmpxchg.org,
	shuah@kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] selftests/cgroup: Adjust cpu test duration based on HZ
Date: Mon, 19 Oct 2026 09:49:50 -0400
Message-ID: <20261019135441.1420968-299-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Joe Simmons-Talbott <joest@redhat.com>

[ Upstream commit a2703c2980c0776e9be7d8f9e144afd054dddb12 ]

For lower HZ values a quota of 1000us is much lower than the amount
of microseconds per tick which makes the tests test_cpucg_max and
test_cpugc_max_nested fail. Increase the test duration to accommodate
for lower HZ values.

Link: https://lore.kernel.org/lkml/20260625203307.1114538-1-joest@redhat.com/
Signed-off-by: Joe Simmons-Talbott <joest@redhat.com>
Acked-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `selftests/cgroup`
- Action verb: **Adjust** (makes tests pass on low-HZ kernels)
- Claimed intent: scale `test_cpucg_max` / `test_cpucg_max_nested`
  duration from `CONFIG_HZ` so a 1000µs quota is not smaller than one
  tick.

Record: `[selftests/cgroup] [Adjust] [scale cpu.max test duration by HZ
so tests do not fail on low-HZ kernels]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Link: https://lore.kernel.org/lkml/20260625203307.1114538-1-
  joest@redhat.com/`
- `Signed-off-by: Joe Simmons-Talbott <joest@redhat.com>` (author)
- `Acked-by: Michal Koutný <mkoutny@suse.com>` (cgroup reviewer)
- `Signed-off-by: Tejun Heo <tj@kernel.org>` (cgroup maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable` (absence expected)
- Ignoring pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  ...]`

Record: Author Red Hat; Ack from Michal Koutný; applied by Tejun Heo;
lore link present; no syzbot/CVE.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The body is two sentences: a 1000µs `cpu.max` quota is much smaller than
microseconds-per-tick at low HZ, so `test_cpucg_max` and
`test_cpugc_max_nested` (typo for `test_cpucg_max_nested`) fail. The fix
is a longer run so averaging can absorb tick quantization.

Record:
- Bug: kselftest false FAIL on low `CONFIG_HZ`
- Symptom: `test_cpu` cpu.max cases fail
- Root cause: 1000µs quota vs tick (HZ=100 → 10ms/tick)
- No kernel oops/corruption described; kernel bandwidth behavior is
  expected

**Step 1.4: DETECT HIDDEN BUG FIXES**
Not disguised cleanup. It is an explicit test-robustness fix. Not a
kernel bug.

Record: `[Not a hidden kernel bug; it is a selftest false-failure fix]`

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- `tools/testing/selftests/cgroup/lib/include/cgroup_util.h`: +1
  (`NSEC_PER_USEC`)
- `tools/testing/selftests/cgroup/test_cpu.c`: +38 / −6
- Functions: new `get_config_hz()`; modified `test_cpucg_max()`,
  `test_cpucg_max_nested()`

Record: `[2 files, +38/−6] [get_config_hz, test_cpucg_max,
test_cpucg_max_nested] [single-subsystem surgical selftest fix]`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before: hog runs 1.0s wall time; expected usage = 10 periods × 1000µs =
10ms; pass if within 10% via `values_close_report`.
After: `duration_usec = 1s * 1000 / hz` (HZ=1000 → 1s; HZ=250 → 4s;
HZ=100 → 10s). Hog timespec and expected-usage math both use the scaled
duration.

Record: `[normal test path only: 1s hog → HZ-scaled hog; expected usage
scales with duration]`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **logic / test correctness** (tick quantization vs tight 10%
check).

Michal Koutný’s v2 review: tasks overrun quota on a long tick; CFS
compensates over several periods; 1s is too short for that average to
land inside 10%. Longer duration was chosen over changing the quota (so
the same 1000µs quantity is still what is tested). Joe confirmed both
approaches passed 10 iterations; they took the simpler duration
approach.

Record: `[test robustness] [quota < tick ⇒ usage noise; longer run
shrinks relative error]`

**Step 2.4: ASSESS THE FIX QUALITY**
- Small, reviewed, v1→v5, Acked, applied to `cgroup/for-7.3`.
- `duration_usec % USEC_PER_SEC * NSEC_PER_USEC` is left-to-right and
  correct.
- `1 * USEC_PER_SEC * 1000` fits in 32-bit `long`.
- Residual issues: `get_config_hz()` only reads `/proc/config.gz`;
  fallback HZ=1000 leaves duration at 1s, so kernels without
  `CONFIG_IKCONFIG_PROC` still fail (Tao Cui raised this on v2 for the
  old quota fallback; v5 still defaults to 1000). `popen`+`grep` is
  best-effort. Reviewer noted SMP noise may still need later work. No
  follow-up changed `get_config_hz()` on `origin/master`.

Record: `[obviously correct for the stated goal; residual fallback
limitation; userspace-only so kernel regression risk is none]`

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
`test_cpucg_max` added in `889ab8113ef13` (David Vernet, 2022-04).
Duration/quota/10% check came from `954bacce36d97` (“selftests/cgroup:
fix cpu.max tests”, 2025-07, in v6.18). That commit replaced a broken
inverted 95% check with a real 10% comparison, which is what makes low-
HZ mismatch actually fail.

Record: `[buggy tightness: 954bacce36d97, in v6.18; tests themselves:
889ab8113ef13 / a79906570f964, v5.19 era]`

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag. N/A.

**Step 3.3: CHECK FILE HISTORY**
Recent related: `954bacce36d97` (cpu.max expected-usage math),
`4cdde87d723a0` (`values_close_report`). Standalone; not patch X/Y.

Record: `[standalone follow-on to the 2025 cpu.max test correction
already in this tree]`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Joe Simmons-Talbott: this is the only cgroup selftest commit in this
history. Michal Koutný Ack; Tejun Heo applied.

Record: `[distro engineer + subsystem maintainer path]`

**Step 3.5: DEPENDENT/PREREQUISITE COMMITS**
Needs `values_close_report` and the 2025 expected-usage math — both in
v6.18.53. `NSEC_PER_USEC` is added here. `BUF_SIZE` vs `PAGE_SIZE`
header rename (`6e9f5c2eecd10`) is **not** in v6.18.53 and is **not**
required.

Record: `[no missing prerequisites in this tree; can apply standalone]`

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c a2703c2980c0776e9be7d8f9e144afd054dddb12` matched:
- v3: https://patch.msgid.link/20260624160358.430354-1-joest@redhat.com
- v4 RESEND:
  https://patch.msgid.link/20260625203307.1114538-1-joest@redhat.com
- v5 (applied):
  https://patch.msgid.link/20260626202925.1527524-1-joest@redhat.com

v1/v2 changed **quota** to one tick. Michal asked not to change the
tested value; Joe tried unaligned-expectation math and longer duration;
both passed 10 runs; v3+ uses duration. v4 naming nits; v5 inlines
timespec math. No NAKs. No `Cc: stable` in review.

Record: `[v5 applied; no NAK; no stable nomination in thread]`

**Step 4.2: CHECK WHO REVIEWED**
`b4 dig -w`: Tejun Heo, Johannes Weiner, Michal Koutný, Shuah Khan,
cgroups@, linux-kselftest@. Michal Acked v5; Tejun: “Applied to
cgroup/for-7.3.”

Record: `[right lists; maintainer applied]`

**Step 4.3: SEARCH FOR THE BUG REPORT**
No bugzilla/syzbot. Author hit it in testing. Tao Cui confirmed the low-
HZ failure mode in review.

Record: `[reproduced by author; 10 clean iterations after the duration
change]`

**Step 4.4: RELATED PATCHES AND SERIES**
Standalone. Later `origin/master` commits on the same file
(`77bc7e952f660`, `0c893d170ff8e`) are unrelated.

Record: `[standalone]`

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
lore.kernel.org returned 403; `lei q` hung and was killed.

Record: `[UNVERIFIED: no stable@ thread retrieved; none in the cgroup
thread]`

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
`get_config_hz`, `test_cpucg_max`, `test_cpucg_max_nested`.

**Step 5.2: TRACE CALLERS**
Both tests are registered with `T(test_cpucg_max)` /
`T(test_cpucg_max_nested)` in `test_cpu.c` (v6.18.53 lines 791–792).
Invoked only when running that kselftest as root. Not kernel, IRQ, or
syscall.

**Step 5.3: TRACE CALLEES**
`cg_create` / `cg_write("cpu.max")` / `cg_run(..., hog_cpus_timed)` /
`cg_read_key_long("cpu.stat")` / `values_close_report`. `hog_cpus_timed`
burns CPU for the given timespec on `CLOCK_MONOTONIC`.

**Step 5.4: CALL CHAIN / REACHABILITY**
Userspace kselftest only. Trigger: run `test_cpu` on a low-HZ kernel
with cgroup cpu controller. Unprivileged users do not hit this.

**Step 5.5: SIMILAR PATTERNS**
No other `get_config_hz` in this cgroup selftest dir. Michal noted BPF
selftests have similar HZ helpers. No sibling drivers with the same bug.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Local tree: **v6.18.53** (`VERSION=6`, `PATCHLEVEL=18`, `SUBLEVEL=53`;
`git describe HEAD` starts at `v6.18.53`).
v6.18.53 `test_cpu.c` still uses `duration_seconds = 1` and `quota_usec
= 1000` in both tests. Upstream
`a2703c2980c0776e9be7d8f9e144afd054dddb12` is **not** an ancestor of
v6.18.53.

Record: `[yes, buggy 1s/1000µs tests are in v6.18.53]`

**Step 6.2: BACKPORT COMPLICATIONS**
`git show a2703c… | patch -p1 --dry-run` on a v6.18.53 archive of
`tools/testing/selftests/cgroup` succeeded on both files.

Record: `[clean apply]`

**Step 6.3: RELATED FIXES ALREADY HERE**
`954bacce36d97` (correct expected-usage + 10% check) is in v6.18. No
later HZ-duration fix. No equivalent workaround.

Record: `[no substitute already present]`

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
`tools/testing/selftests/cgroup` — kselftests, not `kernel/` or `mm/`.

Record: `[kselftests / cgroup cpu controller] [PERIPHERAL for production
runtime; IMPORTANT for distro/CI validation of this tree]`

**Step 7.2: SUBSYSTEM ACTIVITY**
v6.18..v6.18.53 has **236** commits under `tools/testing/selftests/`,
including cgroup ones (`13cf95d19e84b`, `0ef3f5629051f`). This series
already takes kselftest correctness/flake fixes.

Record: `[this 6.18.y tree regularly backports selftest fixes]`

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
People running `selftests/cgroup/test_cpu` on `CONFIG_HZ` 100/250/300.
Production cgroup cpu.max behavior is unchanged.

Record: `[config-specific kselftest users / distro CI]`

**Step 8.2: TRIGGER CONDITIONS**
Run the cpu.max tests on low HZ. Common on Debian-style HZ=250 and some
servers at HZ=100. Not unprivileged. Not a race; quantization + short
window.

**Step 8.3: FAILURE MODE SEVERITY**
False kselftest FAIL. Kernel stays up. No corruption/UAF.

Record: `[false test failure] [LOW for runtime; MEDIUM for CI that gates
6.18.y]`

**Step 8.4: RISK-BENEFIT**
- Benefit: stops known false FAILs on configs this tree still ships;
  matches other selftest backports already in 6.18.53.
- Risk: userspace-only; no kernel locking/alloc/API change. Worst case:
  tests stay FAIL without `/proc/config.gz`, same as today; or tests run
  up to ~10s on HZ=100.

Record: `[moderate CI benefit / very low risk]`

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

FOR:
- Real, reproduced failure of tests that exist in v6.18.53
- Small (+38/−6), clean apply, no kernel code
- v5 reviewed; Acked-by Michal Koutný; applied by Tejun Heo
- This 6.18.y tree already backports kselftest flake/correctness fixes
- Zero production regression surface

AGAINST:
- Not a kernel crash/security/corruption/deadlock
- Best-effort HZ probe; fallback HZ=1000 does not help without
  `config.gz`
- Reviewer expected possible later SMP tuning
- No `Cc: stable` in the thread (not used as a negative per
  instructions)

UNRESOLVED:
- Stable@ archive search (lore 403, lei hung)

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — v5 after review; author ran
   10 iterations; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — false FAILs of in-
   tree tests on valid HZ; Red Hat author hit it.
3. Important issue? **PASS** under this tree’s practice (“oh, that’s not
   good” kselftest failures), not under oops/CVE. Analogous to flake
   fixes already in 6.18.y.
4. Small and contained? **PASS** — two selftest files, &lt;50 lines.
5. No new features or APIs? **PASS** — duration scaling only.
6. Can apply to the local tree? **PASS** — dry-run clean on v6.18.53;
   prerequisites present.

**Step 9.3: EXCEPTION CATEGORIES**
Not a device ID/quirk/DT/build/doc fix. Closest: isolated userspace test
fix with the same risk profile as a build/doc fix.

**Step 9.4: DECISION**
The tests and the tight 10% check are in this 6.18.53 tree; the kernel
bug is not, because there is no kernel bug. The patch only stops those
tests from failing on low HZ, applies cleanly, and cannot regress kernel
runtime. For this tree, that is enough.

What it solves for stable users: distro/CI `test_cpu` cpu.max cases on
HZ&lt;1000. It meets the written rules as a small, tested, in-tree test
fix. Risk is negligible versus the CI benefit.

---

## Verification

- [Phase 1] Parsed tags: Link to lore; SOB Joe Simmons-Talbott; Ack
  Michal Koutný; SOB Tejun Heo; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body: low HZ + 1000µs quota ⇒ `test_cpucg_max` / nested fail
- [Phase 2] Diff: +`NSEC_PER_USEC`; +`get_config_hz()` via `zcat
  /proc/config.gz`; duration `* 1000 / hz` in both tests
- [Phase 2] Operator precedence of `%`/`*` verified; 1e9 fits in 32-bit
  long
- [Phase 3] `git describe HEAD` / Makefile: **6.18.53**
- [Phase 3] `git merge-base --is-ancestor
  a2703c2980c0776e9be7d8f9e144afd054dddb12 v6.18.53` → not present
- [Phase 3] blame: tests 889ab8113ef13 / a79906570f964 (2022); 10% check
  954bacce36d97 (in v6.18)
- [Phase 3] `values_close_report` present at v6.18.53 test_cpu.c:694,765
- [Phase 4] `b4 dig -c a2703c…`: v3/v4/v5 msgid links; `b4 dig -a/-w/-m`
  used
- [Phase 4] v2 thread: Michal proposed duration formula; Joe: both
  approaches passed 10 runs
- [Phase 4] v5: Michal Ack; Tejun applied to cgroup/for-7.3; no NAK; no
  stable Cc
- [Phase 4] lore.kernel.org WebFetch 403; lei stable search killed after
  30s → UNVERIFIED stable@
- [Phase 5] Tests only in `T(...)` table; `hog_cpus_timed` is wall-clock
  hog
- [Phase 6] v6.18.53 still has `duration_seconds = 1` / `quota_usec =
  1000`
- [Phase 6] `patch --dry-run` of a2703c on v6.18.53 cgroup selftests:
  clean
- [Phase 6] `6e9f5c2eecd10` BUF_SIZE rename not in v6.18.53; not
  required
- [Phase 6] no later `get_config_hz` change on origin/master
- [Phase 7] `git log v6.18..v6.18.53 -- tools/testing/selftests/` → 236
  commits
- [Phase 8] Failure = kselftest FAIL only; kernel path untouched
- UNVERIFIED: whether `/proc/config.gz` is typical on 6.18.y distro test
  images (fallback limitation stands either way)

The tests this commit repairs are in this 6.18.53 tree, the patch
applies cleanly, and it does not touch kernel runtime.

**YES**

 .../cgroup/lib/include/cgroup_util.h          |  1 +
 tools/testing/selftests/cgroup/test_cpu.c     | 43 ++++++++++++++++---
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 7ab2824ed7b54..b9cd00e0e8349 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -8,6 +8,7 @@
 
 #define MB(x) (x << 20)
 
+#define NSEC_PER_USEC	1000L
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000L
 
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index d54e2317efff2..de60967279668 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -639,6 +639,31 @@ test_cpucg_nested_weight_underprovisioned(const char *root)
 	return run_cpucg_nested_weight_test(root, false);
 }
 
+/*
+ * Best effort attempt to get the kernel's HZ value from the config.
+ * Return the HZ value if found otherwise return 1000 (the default) to
+ * indicate failure.
+ */
+static long
+get_config_hz(void)
+{
+	long hz = 1000;
+	FILE *f;
+	char cmd[256] = "zcat /proc/config.gz 2>/dev/null | grep '^CONFIG_HZ='";
+
+	f = popen(cmd, "r");
+
+	if (!f)
+		return hz;
+
+	if (fscanf(f, "CONFIG_HZ=%ld", &hz) == EOF)
+		goto out;
+
+out:
+	pclose(f);
+	return hz;
+}
+
 /*
  * This test creates a cgroup with some maximum value within a period, and
  * verifies that a process in the cgroup is not overscheduled.
@@ -646,15 +671,18 @@ test_cpucg_nested_weight_underprovisioned(const char *root)
 static int test_cpucg_max(const char *root)
 {
 	int ret = KSFT_FAIL;
+	long hz = get_config_hz();
 	long quota_usec = 1000;
 	long default_period_usec = 100000; /* cpu.max's default period */
 	long duration_seconds = 1;
 
-	long duration_usec = duration_seconds * USEC_PER_SEC;
+	long duration_usec;
 	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
 	char *cpucg;
 	char quota_buf[32];
 
+	duration_usec = duration_seconds * USEC_PER_SEC * 1000 / hz;
+
 	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
 
 	cpucg = cg_name(root, "cpucg_test");
@@ -670,8 +698,8 @@ static int test_cpucg_max(const char *root)
 	struct cpu_hog_func_param param = {
 		.nprocs = 1,
 		.ts = {
-			.tv_sec = duration_seconds,
-			.tv_nsec = 0,
+			.tv_sec = duration_usec / USEC_PER_SEC,
+			.tv_nsec = duration_usec % USEC_PER_SEC * NSEC_PER_USEC,
 		},
 		.clock_type = CPU_HOG_CLOCK_WALL,
 	};
@@ -710,15 +738,18 @@ static int test_cpucg_max(const char *root)
 static int test_cpucg_max_nested(const char *root)
 {
 	int ret = KSFT_FAIL;
+	long hz = get_config_hz();
 	long quota_usec = 1000;
 	long default_period_usec = 100000; /* cpu.max's default period */
 	long duration_seconds = 1;
 
-	long duration_usec = duration_seconds * USEC_PER_SEC;
+	long duration_usec;
 	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
 	char *parent, *child;
 	char quota_buf[32];
 
+	duration_usec = duration_seconds * USEC_PER_SEC * 1000 / hz;
+
 	snprintf(quota_buf, sizeof(quota_buf), "%ld", quota_usec);
 
 	parent = cg_name(root, "cpucg_parent");
@@ -741,8 +772,8 @@ static int test_cpucg_max_nested(const char *root)
 	struct cpu_hog_func_param param = {
 		.nprocs = 1,
 		.ts = {
-			.tv_sec = duration_seconds,
-			.tv_nsec = 0,
+			.tv_sec = duration_usec / USEC_PER_SEC,
+			.tv_nsec = duration_usec % USEC_PER_SEC * NSEC_PER_USEC,
 		},
 		.clock_type = CPU_HOG_CLOCK_WALL,
 	};
-- 
2.53.0

