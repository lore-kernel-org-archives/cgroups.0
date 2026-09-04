Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8336C386C0A
	for <cgroups@vger.kernel.org>; Fri,  4 Sep 2026 22:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788562273; cv=none; b=QPlMFYlUXAvyI0K1JwgLIZP+8XrJdTiD0D1Iddi3IEGL/0T72tNEd0ly6ZwKFubEpP4i4PbS27sKs/fKE7bM4a6wns2Emne6DF+0YwC4fTLay0q8zbme80NSvPKw0U4jV19Zui4nlGvApdWJ3ObFCUJzoIVuJWLAropZ4WJsAg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788562273; c=relaxed/simple;
	bh=WiARXsVrcUN7nPEF+Rx5skQuwS7dCACWSBSEeBhA4Ww=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=abYSyEcPJy7veoIpd8TIo0TIakR7snevXislFsxmlUQ99ceDJyuKXy8CHtgskmHwEwOgttkJDS3K41nOMbVEifCfmyoGR0q8NtoqdysDl657ZjHpvdN9iOo1qMikcNEFStH+PqiJEgGfMvnEmeIfhSJJMBMUhwyqoSUiyzXzMAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HAj9O38j; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HAj9O38j"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1b8088202so1559314a12.3
        for <cgroups@vger.kernel.org>; Fri, 04 Sep 2026 15:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788562270; x=1789167070; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Vo1MFgtlqGPiG+qDdKpsYG1y1rkQIQcATIEbRYCEGj0=;
        b=HAj9O38jmIqY/U8Zg6WbrNgriBbAznbx1+Z8TaSoqb6KnoaXhaSOU9bCOugcaLcoNW
         9GmYKUThyz1rT1F4N3lkHu5Ivpt19dhpwqgqMIEX0hyhsuK8jtLDYRbkMjtgaM6KR9YT
         B4FNeI72ClkodFdTrsrd0qsHUZJvoEAdKMPuzu58VU0xI4DohbpMSKP3PQuYwoBuA2kU
         Py0zgwk89wTsL0JkDqfuEN/eLshaDDhSBHNNDjSO6WjghdRtVFOqjFrH4wSGpcMD8i2B
         bDxEFmzJRwiewgItN3z9f7+PMzeDx8xgCwICJWL+bPxT4mbfnZjHeAd08N3aguUmk3Wd
         Lb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788562270; x=1789167070;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vo1MFgtlqGPiG+qDdKpsYG1y1rkQIQcATIEbRYCEGj0=;
        b=A5p9mAKpdHAg46DNuSnMq0sDb5S15u9QUzf/7LTi8jv2asf2NROEotNadq10jAbm8d
         BAr7EO7nq8uk0ugpEcjxI5dxH91945lBkKidHZjivfGhGu6ZuuDoRa70nWy2W3xjeSY5
         jImMUupoYjWl0+Tz/V7EdNO4ejH7ipomInc4WJqvbZFIaiIvSXEfV/q5iI8IRTYUqa/p
         jeIHKwh2GdR6nFW+iDlWSqiX6l7nbRhOaLb54/gsY2GQMMSttIu1/9+2vC2Lo3gFDQQO
         GKF0KvPPw3pxCcnyQIcOEBMd+DW2/K9vexxiaw+xb6noxuvcdfTOOd9cjCHiDXv42CfI
         q1HA==
X-Forwarded-Encrypted: i=1; AKwUvBxUq7lfv5q9mUPof+GWUmQ1hq34WSw3Yn3C9qCBLjXPAKv5Ob65cwVxARE7WS5miH5Ypws2BfzN@vger.kernel.org
X-Gm-Message-State: AFuF++lJEJIRVvOn2609w4qMc12mzXQRMjE3fPihtHTteND7kEJug2LY
	2AoOP7byYvZRbafv242lJbL/HVc9euOU2qRAfc2JzOKtccGHsMm1IJfuz/yM6snRM8Kk8w+tsPI
	D8Ciu7z/aEg==
X-Received: from pgbj10-n1.prod.google.com ([2002:a05:6a02:61ca:10b0:cc1:c7d3:7c7b])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:e58b:b0:3b4:8880:2089
 with SMTP id adf61e73a8af0-3da3a0aa620mr14983327637.16.1788562269370; Fri, 04
 Sep 2026 15:51:09 -0700 (PDT)
Date: Fri,  4 Sep 2026 22:45:14 +0000
In-Reply-To: <20260904225103.2955759-1-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260904225103.2955759-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904225103.2955759-3-wfelipe@google.com>
Subject: [PATCH v6 2/3] selftests/cgroup: convert cg_read_key_*() helpers to s64
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

In the kernel, cgroup statistics and event counters in multi-key control
files (such as memory.stat, cpu.stat, and memory.events) are internally
stored and exported as 64-bit values.

On 32-bit platforms, cg_read_key_long() relies on atol(), which returns a
32-bit signed long. When values in memory.stat or event counters exceed
2.14GB (such as on 32-bit systems with large memory), the parsed value
overflows and wraps into negative numbers, leading to subtle bugs and
false test failures.

Standardize on explicitly-sized 64-bit helpers and types across the
cgroup selftests:

- Define s64 in cgroup_util.h as signed long long.
- Convert cg_read_key_long() to cg_read_key_s64() using atoll().
- Convert cg_read_key_long_poll() to cg_read_key_s64_poll(), updating
  both the return type and the expected argument to s64.
- Update values_close() and values_close_report() to operate on s64 and
  use llabs() to prevent downcasting/truncation of 64-bit differences.
- Migrate helper functions (get_cg_wb_count(), get_zswpout(),
  get_zswap_incomp(), wait_for_writeback(), and cg_check_freezetime())
  and their callers to s64.
- Migrate all callers across test_cpu, test_kmem, test_memcontrol,
  test_pids, test_freezer, and test_zswap to cg_read_key_s64().
- Update corresponding printf formats to %lld and difference checks to
  llabs() for s64.

Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 .../selftests/cgroup/lib/cgroup_util.c        | 14 ++--
 .../cgroup/lib/include/cgroup_util.h          | 22 +++---
 tools/testing/selftests/cgroup/test_cpu.c     | 47 ++++++-------
 tools/testing/selftests/cgroup/test_freezer.c | 16 ++---
 tools/testing/selftests/cgroup/test_kmem.c    | 56 ++++++++-------
 .../selftests/cgroup/test_memcontrol.c        | 69 ++++++++++---------
 tools/testing/selftests/cgroup/test_pids.c    |  5 +-
 tools/testing/selftests/cgroup/test_zswap.c   | 54 ++++++++-------
 8 files changed, 148 insertions(+), 135 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testi=
ng/selftests/cgroup/lib/cgroup_util.c
index 2596c12cd864..ed3c4893833a 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -172,7 +172,7 @@ long cg_read_long_fd(int fd)
 	return atol(buf);
 }
=20
-long cg_read_key_long(const char *cgroup, const char *control, const char =
*key)
+s64 cg_read_key_s64(const char *cgroup, const char *control, const char *k=
ey)
 {
 	char buf[BUF_SIZE];
 	char *ptr;
@@ -184,18 +184,18 @@ long cg_read_key_long(const char *cgroup, const char =
*control, const char *key)
 	if (!ptr)
 		return -1;
=20
-	return atol(ptr + strlen(key));
+	return atoll(ptr + strlen(key));
 }
=20
-long cg_read_key_long_poll(const char *cgroup, const char *control,
-			   const char *key, long expected, int retries,
-			   useconds_t wait_interval_us)
+s64 cg_read_key_s64_poll(const char *cgroup, const char *control,
+			 const char *key, s64 expected, int retries,
+			 useconds_t wait_interval_us)
 {
-	long val =3D -1;
+	s64 val =3D -1;
 	int i;
=20
 	for (i =3D 0; i < retries; i++) {
-		val =3D cg_read_key_long(cgroup, control, key);
+		val =3D cg_read_key_s64(cgroup, control, key);
 		if (val < 0)
 			return val;
=20
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/too=
ls/testing/selftests/cgroup/lib/include/cgroup_util.h
index 5d39c709ac7a..ddb05932d9c7 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -2,6 +2,8 @@
 #include <stdbool.h>
 #include <stdlib.h>
=20
+typedef signed long long s64;
+
 #ifndef BUF_SIZE
 #define BUF_SIZE 4096
 #endif
@@ -24,25 +26,25 @@
 /*
  * Checks if two given values differ by less than err% of their sum.
  */
-static inline int values_close(long a, long b, int err)
+static inline int values_close(s64 a, s64 b, int err)
 {
-	return labs(a - b) <=3D (a + b) / 100 * err;
+	return llabs(a - b) <=3D (a + b) / 100 * err;
 }
=20
 /*
  * Checks if two given values differ by less than err% of their sum and as=
sert
  * with detailed debug info if not.
  */
-static inline int values_close_report(long a, long b, int err)
+static inline int values_close_report(s64 a, s64 b, int err)
 {
-	long diff  =3D labs(a - b);
-	long limit =3D (a + b) / 100 * err;
+	s64 diff  =3D llabs(a - b);
+	s64 limit =3D (a + b) / 100 * err;
 	double actual_err =3D (a + b) ? (100.0 * diff / (a + b)) : 0.0;
 	int close =3D diff <=3D limit;
=20
 	if (!close)
 		fprintf(stderr,
-			"[FAIL] actual=3D%ld expected=3D%ld | diff=3D%ld | limit=3D%ld | "
+			"[FAIL] actual=3D%lld expected=3D%lld | diff=3D%lld | limit=3D%lld | "
 			"tolerance=3D%d%% | actual_error=3D%.2f%%\n",
 			a, b, diff, limit, err, actual_err);
=20
@@ -69,10 +71,10 @@ extern int cg_read_strstr(const char *cgroup, const cha=
r *control,
 			  const char *needle);
 extern long cg_read_long(const char *cgroup, const char *control);
 extern long cg_read_long_fd(int fd);
-long cg_read_key_long(const char *cgroup, const char *control, const char =
*key);
-long cg_read_key_long_poll(const char *cgroup, const char *control,
-			   const char *key, long expected, int retries,
-			   useconds_t wait_interval_us);
+s64 cg_read_key_s64(const char *cgroup, const char *control, const char *k=
ey);
+s64 cg_read_key_s64_poll(const char *cgroup, const char *control,
+			 const char *key, s64 expected, int retries,
+			 useconds_t wait_interval_us);
 extern long cg_read_lc(const char *cgroup, const char *control);
 extern int cg_write(const char *cgroup, const char *control, char *buf);
 extern int cg_open(const char *cgroup, const char *control, int flags);
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/self=
tests/cgroup/test_cpu.c
index 735a53bb222b..11da1de9cdeb 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -24,7 +24,7 @@ enum hog_clock_type {
 struct cpu_hogger {
 	char *cgroup;
 	pid_t pid;
-	long usage;
+	s64 usage;
 };
=20
 struct cpu_hog_func_param {
@@ -185,7 +185,7 @@ static int hog_cpus_timed(const char *cgroup, void *arg=
)
 static int test_cpucg_stats(const char *root)
 {
 	int ret =3D KSFT_FAIL;
-	long usage_usec, user_usec, system_usec;
+	s64 usage_usec, user_usec, system_usec;
 	long usage_seconds =3D 2;
 	long expected_usage_usec =3D usage_seconds * USEC_PER_SEC;
 	char *cpucg;
@@ -197,9 +197,9 @@ static int test_cpucg_stats(const char *root)
 	if (cg_create(cpucg))
 		goto cleanup;
=20
-	usage_usec =3D cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
-	user_usec =3D cg_read_key_long(cpucg, "cpu.stat", "user_usec");
-	system_usec =3D cg_read_key_long(cpucg, "cpu.stat", "system_usec");
+	usage_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "usage_usec");
+	user_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "user_usec");
+	system_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "system_usec");
 	if (usage_usec !=3D 0 || user_usec !=3D 0 || system_usec !=3D 0)
 		goto cleanup;
=20
@@ -214,8 +214,8 @@ static int test_cpucg_stats(const char *root)
 	if (cg_run(cpucg, hog_cpus_timed, (void *)&param))
 		goto cleanup;
=20
-	usage_usec =3D cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
-	user_usec =3D cg_read_key_long(cpucg, "cpu.stat", "user_usec");
+	usage_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "usage_usec");
+	user_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "user_usec");
 	if (user_usec <=3D 0)
 		goto cleanup;
=20
@@ -239,7 +239,7 @@ static int test_cpucg_nice(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	int status;
-	long user_usec, nice_usec;
+	s64 user_usec, nice_usec;
 	long usage_seconds =3D 2;
 	long expected_nice_usec =3D usage_seconds * USEC_PER_SEC;
 	char *cpucg;
@@ -252,8 +252,8 @@ static int test_cpucg_nice(const char *root)
 	if (cg_create(cpucg))
 		goto cleanup;
=20
-	user_usec =3D cg_read_key_long(cpucg, "cpu.stat", "user_usec");
-	nice_usec =3D cg_read_key_long(cpucg, "cpu.stat", "nice_usec");
+	user_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "user_usec");
+	nice_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "nice_usec");
 	if (nice_usec =3D=3D -1)
 		ret =3D KSFT_SKIP;
 	if (user_usec !=3D 0 || nice_usec !=3D 0)
@@ -289,8 +289,8 @@ static int test_cpucg_nice(const char *root)
 		if (!WIFEXITED(status))
 			goto cleanup;
=20
-		user_usec =3D cg_read_key_long(cpucg, "cpu.stat", "user_usec");
-		nice_usec =3D cg_read_key_long(cpucg, "cpu.stat", "nice_usec");
+		user_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "user_usec");
+		nice_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "nice_usec");
 		if (user_usec <=3D 0)
 			goto cleanup;
 		if (!values_close_report(nice_usec, expected_nice_usec, 1))
@@ -357,8 +357,8 @@ run_cpucg_weight_test(
 	}
=20
 	for (i =3D 0; i < ARRAY_SIZE(children); i++)
-		children[i].usage =3D cg_read_key_long(children[i].cgroup,
-				"cpu.stat", "usage_usec");
+		children[i].usage =3D cg_read_key_s64(children[i].cgroup,
+						    "cpu.stat", "usage_usec");
=20
 	if (validate(children, ARRAY_SIZE(children)))
 		goto cleanup;
@@ -486,7 +486,7 @@ run_cpucg_nested_weight_test(const char *root, bool ove=
rprovisioned)
 	int ret =3D KSFT_FAIL, i;
 	char *parent =3D NULL, *child =3D NULL;
 	struct cpu_hogger leaf[3] =3D {};
-	long nested_leaf_usage, child_usage;
+	s64 nested_leaf_usage, child_usage;
 	int nprocs =3D get_nprocs();
=20
 	if (!overprovisioned) {
@@ -567,8 +567,8 @@ run_cpucg_nested_weight_test(const char *root, bool ove=
rprovisioned)
 	}
=20
 	for (i =3D 0; i < ARRAY_SIZE(leaf); i++) {
-		leaf[i].usage =3D cg_read_key_long(leaf[i].cgroup,
-				"cpu.stat", "usage_usec");
+		leaf[i].usage =3D cg_read_key_s64(leaf[i].cgroup, "cpu.stat",
+						"usage_usec");
 		if (leaf[i].usage <=3D 0)
 			goto cleanup;
 	}
@@ -580,8 +580,7 @@ run_cpucg_nested_weight_test(const char *root, bool ove=
rprovisioned)
 	} else if (!values_close_report(leaf[0].usage * 2, nested_leaf_usage, 15)=
)
 		goto cleanup;
=20
-
-	child_usage =3D cg_read_key_long(child, "cpu.stat", "usage_usec");
+	child_usage =3D cg_read_key_s64(child, "cpu.stat", "usage_usec");
 	if (child_usage <=3D 0)
 		goto cleanup;
 	if (!values_close_report(child_usage, nested_leaf_usage, 1))
@@ -679,7 +678,8 @@ static int test_cpucg_max(const char *root)
 	long duration_seconds =3D 1;
=20
 	long duration_usec;
-	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
+	long n_periods, remainder_usec, expected_usage_usec;
+	s64 usage_usec;
 	char *cpucg;
 	char quota_buf[32];
=20
@@ -708,7 +708,7 @@ static int test_cpucg_max(const char *root)
 	if (cg_run(cpucg, hog_cpus_timed, (void *)&param))
 		goto cleanup;
=20
-	usage_usec =3D cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
+	usage_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "usage_usec");
 	if (usage_usec <=3D 0)
 		goto cleanup;
=20
@@ -746,7 +746,8 @@ static int test_cpucg_max_nested(const char *root)
 	long duration_seconds =3D 1;
=20
 	long duration_usec;
-	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
+	long n_periods, remainder_usec, expected_usage_usec;
+	s64 usage_usec;
 	char *parent, *child;
 	char quota_buf[32];
=20
@@ -782,7 +783,7 @@ static int test_cpucg_max_nested(const char *root)
 	if (cg_run(child, hog_cpus_timed, (void *)&param))
 		goto cleanup;
=20
-	usage_usec =3D cg_read_key_long(child, "cpu.stat", "usage_usec");
+	usage_usec =3D cg_read_key_s64(child, "cpu.stat", "usage_usec");
 	if (usage_usec <=3D 0)
 		goto cleanup;
=20
diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/=
selftests/cgroup/test_freezer.c
index f28bb02e9783..f4f082c13d4b 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -807,10 +807,9 @@ static int test_cgfreezer_vfork(const char *root)
 /*
  * Get the current frozen_usec for the cgroup.
  */
-static long cg_check_freezetime(const char *cgroup)
+static s64 cg_check_freezetime(const char *cgroup)
 {
-	return cg_read_key_long(cgroup, "cgroup.stat.local",
-				"frozen_usec ");
+	return cg_read_key_s64(cgroup, "cgroup.stat.local", "frozen_usec ");
 }
=20
 /*
@@ -820,7 +819,7 @@ static int test_cgfreezer_time_empty(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *cgroup =3D NULL;
-	long prev, curr;
+	s64 prev, curr;
=20
 	cgroup =3D cg_name(root, "cg_time_test_empty");
 	if (!cgroup)
@@ -839,7 +838,7 @@ static int test_cgfreezer_time_empty(const char *root)
 		goto cleanup;
 	}
 	if (curr > 0) {
-		debug("Expect time (%ld) to be 0\n", curr);
+		debug("Expect time (%lld) to be 0\n", curr);
 		goto cleanup;
 	}
=20
@@ -853,8 +852,7 @@ static int test_cgfreezer_time_empty(const char *root)
 	usleep(1000);
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr < 1000) {
-		debug("Expect time (%ld) to be at least 1000 us\n",
-		      curr);
+		debug("Expect time (%lld) to be at least 1000 us\n", curr);
 		goto cleanup;
 	}
=20
@@ -867,7 +865,7 @@ static int test_cgfreezer_time_empty(const char *root)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr <=3D prev) {
-		debug("Expect time (%ld) to be more than previous check (%ld)\n",
+		debug("Expect time (%lld) to be more than previous check (%lld)\n",
 		      curr, prev);
 		goto cleanup;
 	}
@@ -879,7 +877,7 @@ static int test_cgfreezer_time_empty(const char *root)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr !=3D prev) {
-		debug("Expect time (%ld) to be unchanged from previous check (%ld)\n",
+		debug("Expect time (%lld) to be unchanged from previous check (%lld)\n",
 		      curr, prev);
 		goto cleanup;
 	}
diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/sel=
ftests/cgroup/test_kmem.c
index 437f2d35f205..249898f3b81e 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -54,7 +54,8 @@ static int test_kmem_basic(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *cg =3D NULL;
-	long slab0, slab1, current;
+	s64 slab0, slab1;
+	long current;
=20
 	cg =3D cg_name(root, "kmem_basic_test");
 	if (!cg)
@@ -66,7 +67,7 @@ static int test_kmem_basic(const char *root)
 	if (cg_run(cg, alloc_dcache, (void *)100000))
 		goto cleanup;
=20
-	slab0 =3D cg_read_key_long(cg, "memory.stat", "slab ");
+	slab0 =3D cg_read_key_s64(cg, "memory.stat", "slab ");
 	if (slab0 < (1 << 20))
 		goto cleanup;
=20
@@ -75,7 +76,7 @@ static int test_kmem_basic(const char *root)
 	/* wait for RCU freeing */
 	sleep(1);
=20
-	slab1 =3D cg_read_key_long(cg, "memory.stat", "slab ");
+	slab1 =3D cg_read_key_s64(cg, "memory.stat", "slab ");
 	if (slab1 < 0)
 		goto cleanup;
=20
@@ -167,7 +168,8 @@ static int cg_run_in_subcgroups(const char *parent,
  */
 static int test_kmem_memcg_deletion(const char *root)
 {
-	long current, anon, file, kernel, sock, sum;
+	long current;
+	s64 anon, file, kernel, sock, sum;
 	int ret =3D KSFT_FAIL;
 	char *parent;
=20
@@ -185,23 +187,23 @@ static int test_kmem_memcg_deletion(const char *root)
 		goto cleanup;
=20
 	current =3D cg_read_long(parent, "memory.current");
-	anon =3D cg_read_key_long(parent, "memory.stat", "anon ");
-	file =3D cg_read_key_long(parent, "memory.stat", "file ");
-	kernel =3D cg_read_key_long(parent, "memory.stat", "kernel ");
-	sock =3D cg_read_key_long(parent, "memory.stat", "sock ");
+	anon =3D cg_read_key_s64(parent, "memory.stat", "anon ");
+	file =3D cg_read_key_s64(parent, "memory.stat", "file ");
+	kernel =3D cg_read_key_s64(parent, "memory.stat", "kernel ");
+	sock =3D cg_read_key_s64(parent, "memory.stat", "sock ");
 	if (current < 0 || anon < 0 || file < 0 || kernel < 0 || sock < 0)
 		goto cleanup;
=20
 	sum =3D anon + file + kernel + sock;
-	if (labs(sum - current) < MAX_VMSTAT_ERROR) {
+	if (llabs(sum - current) < MAX_VMSTAT_ERROR) {
 		ret =3D KSFT_PASS;
 	} else {
 		printf("memory.current =3D %ld\n", current);
-		printf("anon + file + kernel + sock =3D %ld\n", sum);
-		printf("anon =3D %ld\n", anon);
-		printf("file =3D %ld\n", file);
-		printf("kernel =3D %ld\n", kernel);
-		printf("sock =3D %ld\n", sock);
+		printf("anon + file + kernel + sock =3D %lld\n", sum);
+		printf("anon =3D %lld\n", anon);
+		printf("file =3D %lld\n", file);
+		printf("kernel =3D %lld\n", kernel);
+		printf("sock =3D %lld\n", sock);
 	}
=20
 cleanup:
@@ -248,7 +250,7 @@ static int spawn_1000_threads(const char *cgroup, void =
*arg)
 	int nr_threads =3D 1000;
 	pthread_t *tinfo;
 	unsigned long i;
-	long stack;
+	s64 stack;
 	int ret =3D -1;
=20
 	tinfo =3D calloc(nr_threads, sizeof(pthread_t));
@@ -263,7 +265,7 @@ static int spawn_1000_threads(const char *cgroup, void =
*arg)
 		}
 	}
=20
-	stack =3D cg_read_key_long(cgroup, "memory.stat", "kernel_stack ");
+	stack =3D cg_read_key_s64(cgroup, "memory.stat", "kernel_stack ");
 	if (stack >=3D 4096 * 1000)
 		ret =3D 0;
=20
@@ -307,7 +309,7 @@ static int test_kmem_dead_cgroups(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *parent;
-	long dead =3D -1;
+	s64 dead =3D -1;
=20
 	parent =3D cg_name(root, "kmem_dead_cgroups_test");
 	if (!parent)
@@ -328,9 +330,10 @@ static int test_kmem_dead_cgroups(const char *root)
 	 * from a specific kernel constant, and can be adjusted if reclaim
 	 * behavior changes in the future.
 	 */
-	dead =3D cg_read_key_long_poll(parent, "cgroup.stat",
-					"nr_dying_descendants ", 0, KMEM_DEAD_WAIT_RETRIES,
-					DEFAULT_WAIT_INTERVAL_US);
+	dead =3D cg_read_key_s64_poll(parent, "cgroup.stat",
+				    "nr_dying_descendants ", 0,
+				    KMEM_DEAD_WAIT_RETRIES,
+				    DEFAULT_WAIT_INTERVAL_US);
 	if (dead)
 		goto cleanup;
=20
@@ -353,7 +356,8 @@ static int test_percpu_basic(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *parent, *child;
-	long current, percpu, slab;
+	long current;
+	s64 percpu, slab;
 	int i;
=20
 	parent =3D cg_name(root, "percpu_basic_test");
@@ -382,15 +386,15 @@ static int test_percpu_basic(const char *root)
 	}
=20
 	current =3D cg_read_long(parent, "memory.current");
-	percpu =3D cg_read_key_long(parent, "memory.stat", "percpu ");
-	slab =3D cg_read_key_long(parent, "memory.stat", "slab ");
+	percpu =3D cg_read_key_s64(parent, "memory.stat", "percpu ");
+	slab =3D cg_read_key_s64(parent, "memory.stat", "slab ");
=20
 	if (current > 0 && percpu > 0 && slab >=3D 0 &&
-			labs(current - (percpu + slab)) < MAX_VMSTAT_ERROR)
+	    llabs(current - (percpu + slab)) < MAX_VMSTAT_ERROR)
 		ret =3D KSFT_PASS;
 	else
-		printf("memory.current %ld\npercpu %ld\nslab %ld\ndelta %ld\n",
-			current, percpu, slab, current - (percpu + slab));
+		printf("memory.current %ld\npercpu %lld\nslab %lld\ndelta %lld\n",
+		       current, percpu, slab, current - (percpu + slab));
=20
 cleanup_children:
 	for (i =3D 0; i < 1000; i++) {
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testi=
ng/selftests/cgroup/test_memcontrol.c
index 3a84d068fbf3..539650c1d562 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -192,7 +192,8 @@ static int alloc_anon_50M_check(const char *cgroup, voi=
d *arg)
 {
 	size_t size =3D MB(50);
 	char *buf;
-	long anon, current;
+	s64 anon;
+	long current;
 	int ret =3D -1;
=20
 	buf =3D alloc_and_populate_anon(size);
@@ -206,7 +207,7 @@ static int alloc_anon_50M_check(const char *cgroup, voi=
d *arg)
 	if (!values_close(size, current, 3))
 		goto cleanup;
=20
-	anon =3D cg_read_key_long(cgroup, "memory.stat", "anon ");
+	anon =3D cg_read_key_s64(cgroup, "memory.stat", "anon ");
 	if (anon < 0)
 		goto cleanup;
=20
@@ -223,7 +224,8 @@ static int alloc_pagecache_50M_check(const char *cgroup=
, void *arg)
 {
 	size_t size =3D MB(50);
 	int ret =3D -1;
-	long current, file;
+	long current;
+	s64 file;
 	int fd;
=20
 	fd =3D get_temp_fd();
@@ -237,7 +239,7 @@ static int alloc_pagecache_50M_check(const char *cgroup=
, void *arg)
 	if (current < size)
 		goto cleanup;
=20
-	file =3D cg_read_key_long(cgroup, "memory.stat", "file ");
+	file =3D cg_read_key_s64(cgroup, "memory.stat", "file ");
 	if (file < 0)
 		goto cleanup;
=20
@@ -623,10 +625,10 @@ static int test_memcg_protection(const char *root, bo=
ol min)
 	for (i =3D 0; i < ARRAY_SIZE(children); i++) {
 		int ignore_low_events_index =3D has_recursiveprot ? 2 : -1;
 		int no_low_events_index =3D 1;
-		long low, oom;
+		s64 low, oom;
=20
-		oom =3D cg_read_key_long(children[i], "memory.events", "oom ");
-		low =3D cg_read_key_long(children[i], "memory.events", "low ");
+		oom =3D cg_read_key_s64(children[i], "memory.events", "oom ");
+		low =3D cg_read_key_s64(children[i], "memory.events", "low ");
=20
 		if (oom)
 			goto cleanup;
@@ -711,7 +713,7 @@ static int test_memcg_high(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *memcg;
-	long high;
+	s64 high;
=20
 	memcg =3D cg_name(root, "memcg_test");
 	if (!memcg)
@@ -738,7 +740,7 @@ static int test_memcg_high(const char *root)
 	if (cg_run(memcg, alloc_pagecache_max_30M, NULL))
 		goto cleanup;
=20
-	high =3D cg_read_key_long(memcg, "memory.events", "high ");
+	high =3D cg_read_key_s64(memcg, "memory.events", "high ");
 	if (high <=3D 0)
 		goto cleanup;
=20
@@ -774,8 +776,8 @@ static int test_memcg_high_sync(const char *root)
 {
 	int ret =3D KSFT_FAIL, pid, fd =3D -1;
 	char *memcg;
-	long pre_high, pre_max;
-	long post_high, post_max;
+	s64 pre_high, pre_max;
+	s64 post_high, post_max;
=20
 	memcg =3D cg_name(root, "memcg_test");
 	if (!memcg)
@@ -784,8 +786,8 @@ static int test_memcg_high_sync(const char *root)
 	if (cg_create(memcg))
 		goto cleanup;
=20
-	pre_high =3D cg_read_key_long(memcg, "memory.events", "high ");
-	pre_max =3D cg_read_key_long(memcg, "memory.events", "max ");
+	pre_high =3D cg_read_key_s64(memcg, "memory.events", "high ");
+	pre_max =3D cg_read_key_s64(memcg, "memory.events", "max ");
 	if (pre_high < 0 || pre_max < 0)
 		goto cleanup;
=20
@@ -808,8 +810,8 @@ static int test_memcg_high_sync(const char *root)
=20
 	cg_wait_for(fd);
=20
-	post_high =3D cg_read_key_long(memcg, "memory.events", "high ");
-	post_max =3D cg_read_key_long(memcg, "memory.events", "max ");
+	post_high =3D cg_read_key_s64(memcg, "memory.events", "high ");
+	post_max =3D cg_read_key_s64(memcg, "memory.events", "max ");
 	if (post_high < 0 || post_max < 0)
 		goto cleanup;
=20
@@ -836,7 +838,8 @@ static int test_memcg_max(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *memcg;
-	long current, max;
+	long current;
+	s64 max;
=20
 	memcg =3D cg_name(root, "memcg_test");
 	if (!memcg)
@@ -865,7 +868,7 @@ static int test_memcg_max(const char *root)
 	if (current > MB(30) || !current)
 		goto cleanup;
=20
-	max =3D cg_read_key_long(memcg, "memory.events", "max ");
+	max =3D cg_read_key_s64(memcg, "memory.events", "max ");
 	if (max <=3D 0)
 		goto cleanup;
=20
@@ -1029,7 +1032,8 @@ static int test_memcg_swap_max_peak(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *memcg;
-	long max, peak;
+	s64 max;
+	long peak;
 	struct stat ss;
 	int swap_peak_fd =3D -1, mem_peak_fd =3D -1;
=20
@@ -1122,10 +1126,10 @@ static int test_memcg_swap_max_peak(const char *roo=
t)
 	if (!cg_run(memcg, alloc_anon, (void *)MB(100)))
 		goto cleanup;
=20
-	if (cg_read_key_long(memcg, "memory.events", "oom ") !=3D 1)
+	if (cg_read_key_s64(memcg, "memory.events", "oom ") !=3D 1)
 		goto cleanup;
=20
-	if (cg_read_key_long(memcg, "memory.events", "oom_kill ") !=3D 1)
+	if (cg_read_key_s64(memcg, "memory.events", "oom_kill ") !=3D 1)
 		goto cleanup;
=20
 	peak =3D cg_read_long(memcg, "memory.peak");
@@ -1186,7 +1190,7 @@ static int test_memcg_swap_max_peak(const char *root)
 	if (cg_run(memcg, alloc_anon_50M_check_swap, (void *)MB(30)))
 		goto cleanup;
=20
-	max =3D cg_read_key_long(memcg, "memory.events", "max ");
+	max =3D cg_read_key_s64(memcg, "memory.events", "max ");
 	if (max <=3D 0)
 		goto cleanup;
=20
@@ -1248,10 +1252,10 @@ static int test_memcg_oom_events(const char *root)
 	if (cg_read_strcmp(memcg, "cgroup.procs", ""))
 		goto cleanup;
=20
-	if (cg_read_key_long(memcg, "memory.events", "oom ") !=3D 1)
+	if (cg_read_key_s64(memcg, "memory.events", "oom ") !=3D 1)
 		goto cleanup;
=20
-	if (cg_read_key_long(memcg, "memory.events", "oom_kill ") !=3D 1)
+	if (cg_read_key_s64(memcg, "memory.events", "oom_kill ") !=3D 1)
 		goto cleanup;
=20
 	ret =3D KSFT_PASS;
@@ -1354,13 +1358,14 @@ static int tcp_client(const char *cgroup, unsigned =
short port)
 	ret =3D KSFT_FAIL;
 	while (retries--) {
 		uint8_t buf[0x100000];
-		long current, sock;
+		long current;
+		s64 sock;
=20
 		if (read(sk, buf, sizeof(buf)) <=3D 0)
 			goto close_sk;
=20
 		current =3D cg_read_long(cgroup, "memory.current");
-		sock =3D cg_read_key_long(cgroup, "memory.stat", "sock ");
+		sock =3D cg_read_key_s64(cgroup, "memory.stat", "sock ");
=20
 		if (current < 0 || sock < 0)
 			goto close_sk;
@@ -1392,7 +1397,7 @@ static int test_memcg_sock(const char *root)
 	int bind_retries =3D 5, ret =3D KSFT_FAIL, pid, err;
 	unsigned short port;
 	char *memcg;
-	long sock_post =3D -1;
+	s64 sock_post =3D -1;
=20
 	memcg =3D cg_name(root, "memcg_test");
 	if (!memcg)
@@ -1459,7 +1464,7 @@ static int test_memcg_sock(const char *root)
 	 * scheduling slack) and require that the "sock " counter
 	 * eventually drops to zero.
 	 */
-	sock_post =3D cg_read_key_long_poll(memcg, "memory.stat", "sock ", 0,
+	sock_post =3D cg_read_key_s64_poll(memcg, "memory.stat", "sock ", 0,
 					 MEMCG_SOCKSTAT_WAIT_RETRIES,
 					 DEFAULT_WAIT_INTERVAL_US);
 	if (sock_post)
@@ -1484,7 +1489,7 @@ static int test_memcg_oom_group_leaf_events(const cha=
r *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *parent, *child;
-	long parent_oom_events;
+	s64 parent_oom_events;
=20
 	parent =3D cg_name(root, "memcg_test_0");
 	child =3D cg_name(root, "memcg_test_0/memcg_test_1");
@@ -1519,11 +1524,11 @@ static int test_memcg_oom_group_leaf_events(const c=
har *root)
 	if (cg_test_proc_killed(child))
 		goto cleanup;
=20
-	if (cg_read_key_long(child, "memory.events", "oom_kill ") <=3D 0)
+	if (cg_read_key_s64(child, "memory.events", "oom_kill ") <=3D 0)
 		goto cleanup;
=20
-	parent_oom_events =3D cg_read_key_long(
-			parent, "memory.events", "oom_kill ");
+	parent_oom_events =3D
+		cg_read_key_s64(parent, "memory.events", "oom_kill ");
 	/*
 	 * If memory_localevents is not enabled (the default), the parent should
 	 * count OOM events in its children groups. Otherwise, it should not
@@ -1639,7 +1644,7 @@ static int test_memcg_oom_group_score_events(const ch=
ar *root)
 	if (!cg_run(memcg, alloc_anon, (void *)MB(100)))
 		goto cleanup;
=20
-	if (cg_read_key_long(memcg, "memory.events", "oom_kill ") !=3D 3)
+	if (cg_read_key_s64(memcg, "memory.events", "oom_kill ") !=3D 3)
 		goto cleanup;
=20
 	if (kill(safe_pid, SIGKILL))
diff --git a/tools/testing/selftests/cgroup/test_pids.c b/tools/testing/sel=
ftests/cgroup/test_pids.c
index 710109b53dfe..f4d5bc9f5f24 100644
--- a/tools/testing/selftests/cgroup/test_pids.c
+++ b/tools/testing/selftests/cgroup/test_pids.c
@@ -111,12 +111,11 @@ static int test_pids_events(const char *root)
 	if (kill(pid, SIGINT))
 		goto cleanup;
=20
-	if (cg_read_key_long(cg_child, "pids.events", "max ") !=3D 0)
+	if (cg_read_key_s64(cg_child, "pids.events", "max ") !=3D 0)
 		goto cleanup;
-	if (cg_read_key_long(cg_parent, "pids.events", "max ") !=3D 1)
+	if (cg_read_key_s64(cg_parent, "pids.events", "max ") !=3D 1)
 		goto cleanup;
=20
-
 	ret =3D KSFT_PASS;
=20
 cleanup:
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index 8f2c9aa4776c..f4ee440b3c66 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -59,14 +59,14 @@ static int get_zswap_stored_pages(size_t *value)
 	return read_int(PATH_ZSWAP_STORED_PAGES, value);
 }
=20
-static long get_cg_wb_count(const char *cg)
+static s64 get_cg_wb_count(const char *cg)
 {
-	return cg_read_key_long(cg, "memory.stat", "zswpwb");
+	return cg_read_key_s64(cg, "memory.stat", "zswpwb");
 }
=20
-static long get_zswpout(const char *cgroup)
+static s64 get_zswpout(const char *cgroup)
 {
-	return cg_read_key_long(cgroup, "memory.stat", "zswpout ");
+	return cg_read_key_s64(cgroup, "memory.stat", "zswpout ");
 }
=20
 static int allocate_and_read_bytes(const char *cgroup, void *arg)
@@ -125,9 +125,10 @@ static char *setup_test_group_1M(const char *root, con=
st char *name)
  * Writeback is asynchronous; poll until at least one writeback has
  * been recorded for @cg, or until @timeout_ms has elapsed.
  */
-static long wait_for_writeback(const char *cg, int timeout_ms)
+static s64 wait_for_writeback(const char *cg, int timeout_ms)
 {
-	long elapsed, count;
+	long elapsed;
+	s64 count;
 	for (elapsed =3D 0; elapsed < timeout_ms; elapsed +=3D 100) {
 		count =3D get_cg_wb_count(cg);
=20
@@ -147,7 +148,7 @@ static long wait_for_writeback(const char *cg, int time=
out_ms)
  */
 static int test_zswap_usage(const char *root)
 {
-	long zswpout_before, zswpout_after;
+	s64 zswpout_before, zswpout_after;
 	int ret =3D KSFT_FAIL;
 	char *test_group;
=20
@@ -191,7 +192,8 @@ static int test_swapin_nozswap(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *test_group, mem_max_buf[32];
-	long swap_peak, zswpout, min_swap;
+	long swap_peak, min_swap;
+	s64 zswpout;
 	size_t allocation_size =3D page_size * 512;
=20
 	min_swap =3D allocation_size / 4;
@@ -248,7 +250,7 @@ static int test_zswapin(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *test_group;
-	long zswpin;
+	s64 zswpin;
=20
 	test_group =3D cg_name(root, "zswapin_test");
 	if (!test_group)
@@ -264,7 +266,7 @@ static int test_zswapin(const char *root)
 	if (cg_run(test_group, allocate_and_read_bytes, (void *)MB(32)))
 		goto out;
=20
-	zswpin =3D cg_read_key_long(test_group, "memory.stat", "zswpin ");
+	zswpin =3D cg_read_key_s64(test_group, "memory.stat", "zswpin ");
 	if (zswpin < 0) {
 		ksft_print_msg("failed to get zswpin\n");
 		goto out;
@@ -355,11 +357,11 @@ static int attempt_writeback(const char *cgroup, void=
 *arg)
=20
 static int test_zswap_writeback_one(const char *cgroup, bool wb)
 {
-	long zswpwb_before, zswpwb_after;
+	s64 zswpwb_before, zswpwb_after;
=20
 	zswpwb_before =3D get_cg_wb_count(cgroup);
 	if (zswpwb_before !=3D 0) {
-		ksft_print_msg("zswpwb_before =3D %ld instead of 0\n", zswpwb_before);
+		ksft_print_msg("zswpwb_before =3D %lld instead of 0\n", zswpwb_before);
 		return -1;
 	}
=20
@@ -375,7 +377,7 @@ static int test_zswap_writeback_one(const char *cgroup,=
 bool wb)
 		return -1;
=20
 	if (wb !=3D !!zswpwb_after) {
-		ksft_print_msg("zswpwb_after is %ld while wb is %s\n",
+		ksft_print_msg("zswpwb_after is %lld while wb is %s\n",
 				zswpwb_after, wb ? "enabled" : "disabled");
 		return -1;
 	}
@@ -487,7 +489,7 @@ static int test_no_invasive_cgroup_shrink(const char *r=
oot)
 		memset(&zw_allocation[off], 0, page_size);
 		memset(&zw_allocation[off], 'a', page_size/4);
 	}
-	if (cg_read_key_long(zw_group, "memory.stat", "zswapped") < 1)
+	if (cg_read_key_s64(zw_group, "memory.stat", "zswapped") < 1)
 		goto out;
=20
 	/* Push wb_group memory into zswap with hard-to-compress data to trigger =
wb */
@@ -630,7 +632,7 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			int zswapped =3D cg_read_key_long(test_group, "memory.stat", "zswapped =
");
+			s64 zswapped =3D cg_read_key_s64(test_group, "memory.stat", "zswapped "=
);
 			int delta =3D stored_pages * page_size - zswapped;
 			int result_ok =3D delta < stored_pages * page_size / 4;
=20
@@ -703,9 +705,9 @@ static int allocate_random_and_wait(const char *cgroup,=
 void *arg)
 	return 0;
 }
=20
-static long get_zswap_incomp(const char *cgroup)
+static s64 get_zswap_incomp(const char *cgroup)
 {
-	return cg_read_key_long(cgroup, "memory.stat", "zswap_incomp ");
+	return cg_read_key_s64(cgroup, "memory.stat", "zswap_incomp ");
 }
=20
 /*
@@ -721,7 +723,7 @@ static int test_zswap_incompressible(const char *root)
 	int ret =3D KSFT_FAIL;
 	struct incomp_child_args *values;
 	char *test_group;
-	long zswap_incomp;
+	s64 zswap_incomp;
 	pid_t child_pid;
 	int child_status;
 	char buf;
@@ -757,13 +759,15 @@ static int test_zswap_incompressible(const char *root=
)
=20
 	zswap_incomp =3D get_zswap_incomp(test_group);
 	if (zswap_incomp <=3D 0) {
-		long zswpout =3D get_zswpout(test_group);
-		long zswapped =3D cg_read_key_long(test_group, "memory.stat", "zswapped =
");
-		long zswap_b =3D cg_read_key_long(test_group, "memory.stat", "zswap ");
-
-		ksft_print_msg("zswap_incomp not increased: %ld\n", zswap_incomp);
-		ksft_print_msg("debug: zswpout=3D%ld zswapped=3D%ld zswap_b=3D%ld\n",
-			       zswpout, zswapped, zswap_b);
+		s64 zswpout =3D get_zswpout(test_group);
+		s64 zswapped =3D
+			cg_read_key_s64(test_group, "memory.stat", "zswapped ");
+		s64 zswap_b =3D
+			cg_read_key_s64(test_group, "memory.stat", "zswap ");
+
+		ksft_print_msg("zswap_incomp not increased: %lld\n", zswap_incomp);
+		ksft_print_msg("debug: zswpout=3D%lld zswapped=3D%lld zswap_b=3D%lld\n",
+				zswpout, zswapped, zswap_b);
 		ksft_print_msg("debug: madvise ret=3D%d errno=3D%d\n",
 			       values->madvise_ret, values->madvise_errno);
 		goto out_kill;
--=20
2.55.0.979.g7e5102b832-goog

