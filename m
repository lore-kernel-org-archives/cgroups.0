Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793991335;
	b=lMhydiW6aBDoYtgzG3h/bnc5KcLOKw72jjIUveDMH5aneG7Shq1tEZfrH0O4Bm9HDODQ
	 tDZWShYY5Tr0K9y7O2VeHiNdt7n5zIDhT8U/r8W/yqvV9wsuUtZxyK5iVlt6UlSgxq88Q
	 BtLqaEc0r2luIE2G6Vsjalrw611i75Xb21NXlwfFnw5/MpzyG1NmKEpIJK650st8eUdpU
	 rHL6T812ROyOx2PmeZ+N+VtpVhck/LJWkxZ2/lgxTNPRKerWzd58Mh9eSdMThV2sh4nWY
	 +EjtBQmuu9Bp6M1kyekcopGn8eAYy4FHoMCttfdtq6b7MGtAzGyoa+FDn+il13+Dj5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793991335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=iGPFYuRx8NC9IEEDOsVNQKCy3Zv4UP69j0QTMjXO1nA=;
	b=rgOi523biPkWIT4a6lKgzxc3ohuM0MRypJU7ERjfITott2Juaq1/U2l7Y1gzQb3Qy6Zi
	 UBZbo7y/7AXfnKDnPLcQxl9rBSbVS6+31zyQ77wbaBkF7/FUH6SB9X5dVARrbnaGms6Vn
	 SpM8OQPfytWD3GAj/uG2bPKIJrjLaUSen5tYQ+3qS5UO2szt1u8vC1f08MDAXf2V/Vblt
	 prXfJkxwOo+lT9bJM2HSBQhh0+p941F3L97am6aUkEmtPU3wjJrcGwNHWaHGRbSVC7AU1
	 ZojBUiPXkY8fJUy6ebvTU3fOxyI0zbEyK//Sl5RegeYNNiIpztioirfsMcsV/yBUFCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JM8I5Ig0;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDA4606A329
	for <cgroups@vger.kernel.org>; Fri,  6 Nov 2026 18:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CDA4606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wfelipe.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JM8I5Ig0
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-82315dbce25so613251a34.2
        for <cgroups@vger.kernel.org>; Fri, 06 Nov 2026 10:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793991333; x=1794596133; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=iGPFYuRx8NC9IEEDOsVNQKCy3Zv4UP69j0QTMjXO1nA=;
        b=JM8I5Ig0QDG72rF0zMCUKCCX2RXfanN0lLaw+NgiOXhRJZl5XFhFL1C5xmhLyJznRU
         k77Q84AbZh0UW1/SVIQg5SXaFKMyoMtTCrUUrV3rINVzGAOY7PpajsMbmwPLJWJ9B418
         Ny4PunrmYlSqccyO3KSa4nCdDKCkQALr2OZKCWVQofYo/dpo5RnyRUYWEChe5UjNJIqI
         JF1dpE7B6y3q+d5UWaQNEVuLWB/HQ0zQXsivuM12/Yb2z/Xgui6P4Wn51NOb0b7eB3tf
         33JNmEysB72RDU6llpFzrbDoT1Kbpl9p8r0+n9+JuTAg8hgG9nL9/+z23IvKwiJrAztt
         5ujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793991333; x=1794596133;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iGPFYuRx8NC9IEEDOsVNQKCy3Zv4UP69j0QTMjXO1nA=;
        b=qD8/n5s1E3JodqLbuUWv1fGgMCnwG8UtJPvgWJvvpAwWc4Sda5fZN6DSYGi30Tbj/1
         nqrbUPKWQsIHumkNbAfhHr/fUl5EdQEe0uNTD3Max8BeE/WZ2aTji2bjIbbPvnnGKbYU
         mCkeVvcb4dRl72Z3ujmWMVHyFLx9ChIqquv7FbBZu3L1KHHepPTD7j2UEHQ9zbJqMxho
         xYPL0k8rmcf0Zkvrlu5V7yYpsiliXNxEYCkN62Bhwm5De/JsTCRr28XL4lWbnMxN5IcA
         PC0dQDz/antA1vHkFzU9m4cWnYBIrMhFmTwbrCe2+1+oBSXyrZDhlYfBQQw0jJJst8by
         sU5w==
X-Forwarded-Encrypted: i=1; AKwUvBydvQaPgyZM/hn36cikutnd/9J54Jfoy4V7IRYneiK67zRS7kb3+RluJeCqGjOC9G7KniIPd1mD@vger.kernel.org
X-Gm-Message-State: APuU4Z/w6OczIoqJfBYyYJGEQzNRa2Ey2KCuq8oViHStEW0artyEny49
	tLJpGdPFvtL7B0Akoli5LTz7A5jKMWJgMdPnEsrcestDXWqNa6U3SRZ/1d+2tYXvu9yATWY94Qq
	Cv2oiitj4OQ==
X-Received: from ioo20-n2.prod.google.com ([2002:a05:6602:8654:20b0:9c7:6af8:db91])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:508e:b0:4f5:eaac:5151
 with SMTP id 5614622812f47-567e112a634mr2516579b6e.39.1793991332303; Fri, 06
 Nov 2026 10:55:32 -0800 (PST)
Date: Fri,  6 Nov 2026 18:55:06 +0000
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261106185520.290139-1-wfelipe@google.com>
Subject: [PATCH v2] selftests/cgroup: convert cg_read_*long*() helpers to s64
From: Wilson Felipe Pereira <wfelipe@google.com>
To: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Cgroup byte and time counters in control files (such as memory.current,
memory.peak, memory.stat, and cpu.stat) are exported by the kernel as
64-bit values, while cg_read_long(), cg_read_long_fd(), and
cg_read_key_long() parse them with atol() and return a signed long. On
32-bit platforms, atol() clamps values above 2 GiB to LONG_MAX.

Although current tests do not allocate enough memory to hit LONG_MAX,
converting these helpers to 64-bit keeps the selftest types consistent
with the kernel counters and avoids 32-bit truncation:

- Define s64 as int64_t in cgroup_util.h (matching
  tools/include/linux/types.h) and use PRId64 from <inttypes.h>.
- Convert cg_read_long(), cg_read_long_fd(), cg_read_key_long(), and
  cg_read_key_long_poll() to cg_read_s64(), cg_read_s64_fd(),
  cg_read_key_s64(), and cg_read_key_s64_poll() using atoll().
- Update cg_write_numeric(), values_close(), and values_close_report()
  to take s64 and use llabs().
- Update callers across the cgroup selftests to use s64 and PRId64.

Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
v1 -> v2:
- Rebase on linus/master (v7.4-rc1+) and convert the new
  cg_read_key_long() call in test_pids_events_notify() (Tejun Heo).
- Define s64 as int64_t in cgroup_util.h (matching
  tools/include/linux/types.h) and use PRId64 from <inttypes.h> to fix
  the KVM selftests build failure (Tejun Heo).
- Convert cg_read_long(), cg_read_long_fd(), and cg_write_numeric() to
  s64 alongside the remaining callers in test_freezer.c, test_cpu.c,
  test_hugetlb_memcg.c, test_kmem.c, test_memcontrol.c, and test_zswap.c
  (Tejun Heo).
- Update commit description to note atol() saturates at LONG_MAX and
  clean up stray whitespace/alignment changes (Tejun Heo).

v1: https://lore.kernel.org/all/20261022042921.711624-1-wfelipe@google.com/

 .../selftests/cgroup/lib/cgroup_util.c        |  26 +--
 .../cgroup/lib/include/cgroup_util.h          |  32 +--
 tools/testing/selftests/cgroup/test_cpu.c     |  48 ++---
 tools/testing/selftests/cgroup/test_freezer.c |  88 +++++----
 .../selftests/cgroup/test_hugetlb_memcg.c     |  26 +--
 tools/testing/selftests/cgroup/test_kmem.c    |  62 +++---
 .../selftests/cgroup/test_memcontrol.c        | 183 +++++++++---------
 tools/testing/selftests/cgroup/test_pids.c    |   6 +-
 tools/testing/selftests/cgroup/test_zswap.c   |  77 ++++----
 9 files changed, 284 insertions(+), 264 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testi=
ng/selftests/cgroup/lib/cgroup_util.c
index 823b0312b2b2..279dfc5acfe1 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -175,27 +175,27 @@ int cg_read_strstr(const char *cgroup, const char *co=
ntrol, const char *needle)
 	return strstr(buf, needle) ? 0 : -1;
 }
=20
-long cg_read_long(const char *cgroup, const char *control)
+s64 cg_read_s64(const char *cgroup, const char *control)
 {
 	char buf[128];
=20
 	if (cg_read(cgroup, control, buf, sizeof(buf)))
 		return -1;
=20
-	return atol(buf);
+	return atoll(buf);
 }
=20
-long cg_read_long_fd(int fd)
+s64 cg_read_s64_fd(int fd)
 {
 	char buf[128];
=20
 	if (pread(fd, buf, sizeof(buf), 0) <=3D 0)
 		return -1;
=20
-	return atol(buf);
+	return atoll(buf);
 }
=20
-long cg_read_key_long(const char *cgroup, const char *control, const char =
*key)
+s64 cg_read_key_s64(const char *cgroup, const char *control, const char *k=
ey)
 {
 	char buf[BUF_SIZE];
 	char *ptr;
@@ -207,18 +207,18 @@ long cg_read_key_long(const char *cgroup, const char =
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
@@ -270,12 +270,12 @@ int cg_open(const char *cgroup, const char *control, =
int flags)
 	return open(path, flags);
 }
=20
-int cg_write_numeric(const char *cgroup, const char *control, long value)
+int cg_write_numeric(const char *cgroup, const char *control, s64 value)
 {
 	char buf[64];
 	int ret;
=20
-	ret =3D sprintf(buf, "%lu", value);
+	ret =3D sprintf(buf, "%" PRId64, value);
 	if (ret < 0)
 		return ret;
=20
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/too=
ls/testing/selftests/cgroup/lib/include/cgroup_util.h
index 5307f3bf32a0..bc0dd25f24ee 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -1,7 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#include <inttypes.h>
 #include <stdbool.h>
 #include <stdlib.h>
=20
+typedef int64_t s64;
+
 #ifndef BUF_SIZE
 #define BUF_SIZE 4096
 #endif
@@ -27,26 +30,27 @@
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
-			"tolerance=3D%d%% | actual_error=3D%.2f%%\n",
+			"[FAIL] actual=3D%" PRId64 " expected=3D%" PRId64
+			" | diff=3D%" PRId64 " | limit=3D%" PRId64
+			" | tolerance=3D%d%% | actual_error=3D%.2f%%\n",
 			a, b, diff, limit, err, actual_err);
=20
 	return close;
@@ -70,16 +74,16 @@ extern int cg_read_strcmp_wait(const char *cgroup, cons=
t char *control,
 				   const char *expected);
 extern int cg_read_strstr(const char *cgroup, const char *control,
 			  const char *needle);
-extern long cg_read_long(const char *cgroup, const char *control);
-extern long cg_read_long_fd(int fd);
-long cg_read_key_long(const char *cgroup, const char *control, const char =
*key);
-long cg_read_key_long_poll(const char *cgroup, const char *control,
-			   const char *key, long expected, int retries,
-			   useconds_t wait_interval_us);
+s64 cg_read_s64(const char *cgroup, const char *control);
+s64 cg_read_s64_fd(int fd);
+s64 cg_read_key_s64(const char *cgroup, const char *control, const char *k=
ey);
+s64 cg_read_key_s64_poll(const char *cgroup, const char *control,
+			 const char *key, s64 expected, int retries,
+			 useconds_t wait_interval_us);
 extern long cg_read_lc(const char *cgroup, const char *control);
 extern int cg_write(const char *cgroup, const char *control, char *buf);
 extern int cg_open(const char *cgroup, const char *control, int flags);
-int cg_write_numeric(const char *cgroup, const char *control, long value);
+int cg_write_numeric(const char *cgroup, const char *control, s64 value);
 extern int cg_run(const char *cgroup,
 		  int (*fn)(const char *cgroup, void *arg),
 		  void *arg);
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/self=
tests/cgroup/test_cpu.c
index 3456e3e988c6..1db8ff3f0e5c 100644
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
@@ -400,7 +400,7 @@ overprovision_validate(const struct cpu_hogger *childre=
n, int num_children)
 	int ret =3D KSFT_FAIL, i;
=20
 	for (i =3D 0; i < num_children - 1; i++) {
-		long delta;
+		s64 delta;
=20
 		if (children[i + 1].usage <=3D children[i].usage)
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
@@ -581,7 +581,7 @@ run_cpucg_nested_weight_test(const char *root, bool ove=
rprovisioned)
 		goto cleanup;
=20
=20
-	child_usage =3D cg_read_key_long(child, "cpu.stat", "usage_usec");
+	child_usage =3D cg_read_key_s64(child, "cpu.stat", "usage_usec");
 	if (child_usage <=3D 0)
 		goto cleanup;
 	if (!values_close_report(child_usage, nested_leaf_usage, 1))
@@ -679,7 +679,8 @@ static int test_cpucg_max(const char *root)
 	long duration_seconds =3D 1;
=20
 	long duration_usec;
-	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
+	long n_periods, remainder_usec, expected_usage_usec;
+	s64 usage_usec;
 	char *cpucg;
 	char quota_buf[32];
=20
@@ -708,7 +709,7 @@ static int test_cpucg_max(const char *root)
 	if (cg_run(cpucg, hog_cpus_timed, (void *)&param))
 		goto cleanup;
=20
-	usage_usec =3D cg_read_key_long(cpucg, "cpu.stat", "usage_usec");
+	usage_usec =3D cg_read_key_s64(cpucg, "cpu.stat", "usage_usec");
 	if (usage_usec <=3D 0)
 		goto cleanup;
=20
@@ -746,7 +747,8 @@ static int test_cpucg_max_nested(const char *root)
 	long duration_seconds =3D 1;
=20
 	long duration_usec;
-	long usage_usec, n_periods, remainder_usec, expected_usage_usec;
+	long n_periods, remainder_usec, expected_usage_usec;
+	s64 usage_usec;
 	char *parent, *child;
 	char quota_buf[32];
=20
@@ -782,7 +784,7 @@ static int test_cpucg_max_nested(const char *root)
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
index f28bb02e9783..266b1a0f889f 100644
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
+		debug("Expect time (%" PRId64 ") to be 0\n", curr);
 		goto cleanup;
 	}
=20
@@ -853,7 +852,7 @@ static int test_cgfreezer_time_empty(const char *root)
 	usleep(1000);
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr < 1000) {
-		debug("Expect time (%ld) to be at least 1000 us\n",
+		debug("Expect time (%" PRId64 ") to be at least 1000 us\n",
 		      curr);
 		goto cleanup;
 	}
@@ -867,7 +866,7 @@ static int test_cgfreezer_time_empty(const char *root)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr <=3D prev) {
-		debug("Expect time (%ld) to be more than previous check (%ld)\n",
+		debug("Expect time (%" PRId64 ") to be more than previous check (%" PRId=
64 ")\n",
 		      curr, prev);
 		goto cleanup;
 	}
@@ -879,8 +878,8 @@ static int test_cgfreezer_time_empty(const char *root)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr !=3D prev) {
-		debug("Expect time (%ld) to be unchanged from previous check (%ld)\n",
-		      curr, prev);
+		debug("Expect time (%" PRId64 ") to be unchanged from previous check (%"
+		      PRId64 ")\n", curr, prev);
 		goto cleanup;
 	}
=20
@@ -902,7 +901,7 @@ static int test_cgfreezer_time_simple(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *cgroup =3D NULL;
-	long prev, curr;
+	s64 prev, curr;
=20
 	cgroup =3D cg_name(root, "cg_time_test_simple");
 	if (!cgroup)
@@ -920,7 +919,7 @@ static int test_cgfreezer_time_simple(const char *root)
 		goto cleanup;
 	}
 	if (curr > 0) {
-		debug("Expect time (%ld) to be 0\n", curr);
+		debug("Expect time (%" PRId64 ") to be 0\n", curr);
 		goto cleanup;
 	}
=20
@@ -932,7 +931,7 @@ static int test_cgfreezer_time_simple(const char *root)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr > prev) {
-		debug("Expect time (%ld) to be 0\n", curr);
+		debug("Expect time (%" PRId64 ") to be 0\n", curr);
 		goto cleanup;
 	}
=20
@@ -947,7 +946,7 @@ static int test_cgfreezer_time_simple(const char *root)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr < 1000) {
-		debug("Expect time (%ld) to be at least 1000 us\n",
+		debug("Expect time (%" PRId64 ") to be at least 1000 us\n",
 		      curr);
 		goto cleanup;
 	}
@@ -961,7 +960,7 @@ static int test_cgfreezer_time_simple(const char *root)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr <=3D prev) {
-		debug("Expect time (%ld) to be more than previous check (%ld)\n",
+		debug("Expect time (%" PRId64 ") to be more than previous check (%" PRId=
64 ")\n",
 		      curr, prev);
 		goto cleanup;
 	}
@@ -974,8 +973,8 @@ static int test_cgfreezer_time_simple(const char *root)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr !=3D prev) {
-		debug("Expect time (%ld) to be unchanged from previous check (%ld)\n",
-		      curr, prev);
+		debug("Expect time (%" PRId64 ") to be unchanged from previous check (%"
+		      PRId64 ")\n", curr, prev);
 		goto cleanup;
 	}
=20
@@ -996,7 +995,7 @@ static int test_cgfreezer_time_populate(const char *roo=
t)
 {
 	int ret =3D KSFT_FAIL;
 	char *cgroup =3D NULL;
-	long prev, curr;
+	s64 prev, curr;
 	int i;
=20
 	cgroup =3D cg_name(root, "cg_time_test_populate");
@@ -1012,7 +1011,7 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
 		goto cleanup;
 	}
 	if (curr > 0) {
-		debug("Expect time (%ld) to be 0\n", curr);
+		debug("Expect time (%" PRId64 ") to be 0\n", curr);
 		goto cleanup;
 	}
=20
@@ -1025,7 +1024,7 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr !=3D prev) {
-		debug("Expect time (%ld) to be 0\n", curr);
+		debug("Expect time (%" PRId64 ") to be 0\n", curr);
 		goto cleanup;
 	}
=20
@@ -1038,7 +1037,7 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr !=3D prev) {
-		debug("Expect time (%ld) to be 0\n", curr);
+		debug("Expect time (%" PRId64 ") to be 0\n", curr);
 		goto cleanup;
 	}
=20
@@ -1051,7 +1050,7 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr <=3D prev) {
-		debug("Expect time (%ld) to be more than previous check (%ld)\n",
+		debug("Expect time (%" PRId64 ") to be more than previous check (%" PRId=
64 ")\n",
 		      curr, prev);
 		goto cleanup;
 	}
@@ -1061,7 +1060,7 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr <=3D prev) {
-		debug("Expect time (%ld) to be more than previous check (%ld)\n",
+		debug("Expect time (%" PRId64 ") to be more than previous check (%" PRId=
64 ")\n",
 		      curr, prev);
 		goto cleanup;
 	}
@@ -1075,7 +1074,7 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr <=3D prev) {
-		debug("Expect time (%ld) to be more than previous check (%ld)\n",
+		debug("Expect time (%" PRId64 ") to be more than previous check (%" PRId=
64 ")\n",
 		      curr, prev);
 		goto cleanup;
 	}
@@ -1089,7 +1088,7 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr <=3D prev) {
-		debug("Expect time (%ld) to be more than previous check (%ld)\n",
+		debug("Expect time (%" PRId64 ") to be more than previous check (%" PRId=
64 ")\n",
 		      curr, prev);
 		goto cleanup;
 	}
@@ -1103,8 +1102,8 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr !=3D prev) {
-		debug("Expect time (%ld) to be unchanged from previous check (%ld)\n",
-		      curr, prev);
+		debug("Expect time (%" PRId64 ") to be unchanged from previous check (%"
+		      PRId64 ")\n", curr, prev);
 		goto cleanup;
 	}
=20
@@ -1119,7 +1118,7 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
 	prev =3D curr;
 	curr =3D cg_check_freezetime(cgroup);
 	if (curr <=3D prev) {
-		debug("Expect time (%ld) to be more than previous check (%ld)\n",
+		debug("Expect time (%" PRId64 ") to be more than previous check (%" PRId=
64 ")\n",
 		      curr, prev);
 		goto cleanup;
 	}
@@ -1140,7 +1139,7 @@ static int test_cgfreezer_time_populate(const char *r=
oot)
  */
 static int test_cgfreezer_time_migrate(const char *root)
 {
-	long prev_A, curr_A, curr_B;
+	s64 prev_A, curr_A, curr_B;
 	char *cgroup[2] =3D {0};
 	int ret =3D KSFT_FAIL;
 	int pid;
@@ -1173,12 +1172,12 @@ static int test_cgfreezer_time_migrate(const char *=
root)
=20
 	curr_A =3D cg_check_freezetime(cgroup[0]);
 	if (curr_A) {
-		debug("Expect time (%ld) to be 0\n", curr_A);
+		debug("Expect time (%" PRId64 ") to be 0\n", curr_A);
 		goto cleanup;
 	}
 	curr_B =3D cg_check_freezetime(cgroup[1]);
 	if (curr_B) {
-		debug("Expect time (%ld) to be 0\n", curr_B);
+		debug("Expect time (%" PRId64 ") to be 0\n", curr_B);
 		goto cleanup;
 	}
=20
@@ -1190,7 +1189,7 @@ static int test_cgfreezer_time_migrate(const char *ro=
ot)
 	prev_A =3D curr_A;
 	curr_A =3D cg_check_freezetime(cgroup[0]);
 	if (curr_A <=3D prev_A) {
-		debug("Expect time (%ld) to be > 0\n", curr_A);
+		debug("Expect time (%" PRId64 ") to be > 0\n", curr_A);
 		goto cleanup;
 	}
=20
@@ -1203,14 +1202,14 @@ static int test_cgfreezer_time_migrate(const char *=
root)
 	usleep(1000);
 	curr_B =3D cg_check_freezetime(cgroup[1]);
 	if (curr_B) {
-		debug("Expect time (%ld) to be 0\n", curr_B);
+		debug("Expect time (%" PRId64 ") to be 0\n", curr_B);
 		goto cleanup;
 	}
=20
 	prev_A =3D curr_A;
 	curr_A =3D cg_check_freezetime(cgroup[0]);
 	if (curr_A <=3D prev_A) {
-		debug("Expect time (%ld) to be more than previous check (%ld)\n",
+		debug("Expect time (%" PRId64 ") to be more than previous check (%" PRId=
64 ")\n",
 		      curr_A, prev_A);
 		goto cleanup;
 	}
@@ -1238,7 +1237,7 @@ static int test_cgfreezer_time_parent(const char *roo=
t)
 {
 	char *parent, *child =3D NULL;
 	int ret =3D KSFT_FAIL;
-	long ptime, ctime;
+	s64 ptime, ctime;
=20
 	parent =3D cg_name(root, "cg_test_parent_A");
 	if (!parent)
@@ -1277,7 +1276,8 @@ static int test_cgfreezer_time_parent(const char *roo=
t)
 	ptime =3D cg_check_freezetime(parent);
 	ctime =3D cg_check_freezetime(child);
 	if (ptime <=3D ctime) {
-		debug("Expect ptime (%ld) > ctime (%ld)\n", ptime, ctime);
+		debug("Expect ptime (%" PRId64 ") > ctime (%" PRId64 ")\n",
+		      ptime, ctime);
 		goto cleanup;
 	}
=20
@@ -1296,7 +1296,8 @@ static int test_cgfreezer_time_parent(const char *roo=
t)
 	ptime =3D cg_check_freezetime(parent);
=20
 	if (ctime <=3D ptime) {
-		debug("Expect ctime (%ld) > ptime (%ld)\n", ctime, ptime);
+		debug("Expect ctime (%" PRId64 ") > ptime (%" PRId64 ")\n",
+		      ctime, ptime);
 		goto cleanup;
 	}
=20
@@ -1321,7 +1322,7 @@ static int test_cgfreezer_time_child(const char *root=
)
 {
 	char *parent, *child =3D NULL;
 	int ret =3D KSFT_FAIL;
-	long ptime, ctime;
+	s64 ptime, ctime;
=20
 	parent =3D cg_name(root, "cg_test_child_A");
 	if (!parent)
@@ -1348,12 +1349,13 @@ static int test_cgfreezer_time_child(const char *ro=
ot)
 	ctime =3D cg_check_freezetime(child);
 	ptime =3D cg_check_freezetime(parent);
 	if (ptime !=3D 0) {
-		debug("Expect ptime (%ld) to be 0\n", ptime);
+		debug("Expect ptime (%" PRId64 ") to be 0\n", ptime);
 		goto cleanup;
 	}
=20
 	if (ctime <=3D ptime) {
-		debug("Expect ctime (%ld) > ptime (%ld)\n", ctime, ptime);
+		debug("Expect ctime (%" PRId64 ") > ptime (%" PRId64 ")\n",
+		      ctime, ptime);
 		goto cleanup;
 	}
=20
@@ -1386,7 +1388,7 @@ static int test_cgfreezer_time_nested(const char *roo=
t)
 {
 	char *cgroup[3] =3D {0};
 	int ret =3D KSFT_FAIL;
-	long time[3] =3D {0};
+	s64 time[3] =3D {0};
 	int i;
=20
 	cgroup[0] =3D cg_name(root, "cg_test_time_A");
@@ -1440,12 +1442,14 @@ static int test_cgfreezer_time_nested(const char *r=
oot)
 	time[0] =3D cg_check_freezetime(cgroup[0]);
=20
 	if (time[2] <=3D time[1]) {
-		debug("Expect C's time (%ld) > B's time (%ld)", time[2], time[1]);
+		debug("Expect C's time (%" PRId64 ") > B's time (%" PRId64 ")",
+		      time[2], time[1]);
 		goto cleanup;
 	}
=20
 	if (time[1] <=3D time[0]) {
-		debug("Expect B's time (%ld) > A's time (%ld)", time[1], time[0]);
+		debug("Expect B's time (%" PRId64 ") > A's time (%" PRId64 ")",
+		      time[1], time[0]);
 		goto cleanup;
 	}
=20
diff --git a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c b/tools/te=
sting/selftests/cgroup/test_hugetlb_memcg.c
index 8c5aced813b6..803248c496e4 100644
--- a/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
+++ b/tools/testing/selftests/cgroup/test_hugetlb_memcg.c
@@ -96,16 +96,17 @@ static int hugetlb_test_program(const char *cgroup, voi=
d *arg)
 {
 	char *test_group =3D (char *)arg;
 	void *addr;
-	long old_current, expected_current, current;
+	s64 old_current, expected_current, current;
 	int ret =3D EXIT_FAILURE;
=20
-	old_current =3D cg_read_long(test_group, "memory.current");
+	old_current =3D cg_read_s64(test_group, "memory.current");
 	set_nr_hugepages(20);
-	current =3D cg_read_long(test_group, "memory.current");
+	current =3D cg_read_s64(test_group, "memory.current");
 	if (current - old_current >=3D MB(2)) {
 		ksft_print_msg(
 			"setting nr_hugepages should not increase hugepage usage.\n");
-		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
+		ksft_print_msg("before: %" PRId64 ", after: %" PRId64 "\n",
+			       old_current, current);
 		return EXIT_FAILURE;
 	}
=20
@@ -114,10 +115,11 @@ static int hugetlb_test_program(const char *cgroup, v=
oid *arg)
 		ksft_print_msg("fail to mmap.\n");
 		return EXIT_FAILURE;
 	}
-	current =3D cg_read_long(test_group, "memory.current");
+	current =3D cg_read_s64(test_group, "memory.current");
 	if (current - old_current >=3D MB(2)) {
 		ksft_print_msg("mmap should not increase hugepage usage.\n");
-		ksft_print_msg("before: %ld, after: %ld\n", old_current, current);
+		ksft_print_msg("before: %" PRId64 ", after: %" PRId64 "\n",
+			       old_current, current);
 		goto out_failed_munmap;
 	}
 	old_current =3D current;
@@ -125,35 +127,35 @@ static int hugetlb_test_program(const char *cgroup, v=
oid *arg)
 	/* read the first page */
 	check_first(addr);
 	expected_current =3D old_current + MB(2);
-	current =3D cg_read_long(test_group, "memory.current");
+	current =3D cg_read_s64(test_group, "memory.current");
 	if (!values_close(expected_current, current, 5)) {
 		ksft_print_msg("memory usage should increase by around 2MB.\n");
 		ksft_print_msg(
-			"expected memory: %ld, actual memory: %ld\n",
+			"expected memory: %" PRId64 ", actual memory: %" PRId64 "\n",
 			expected_current, current);
 		goto out_failed_munmap;
 	}
=20
 	/* write to the whole range */
 	write_data(addr);
-	current =3D cg_read_long(test_group, "memory.current");
+	current =3D cg_read_s64(test_group, "memory.current");
 	expected_current =3D old_current + MB(8);
 	if (!values_close(expected_current, current, 5)) {
 		ksft_print_msg("memory usage should increase by around 8MB.\n");
 		ksft_print_msg(
-			"expected memory: %ld, actual memory: %ld\n",
+			"expected memory: %" PRId64 ", actual memory: %" PRId64 "\n",
 			expected_current, current);
 		goto out_failed_munmap;
 	}
=20
 	/* unmap the whole range */
 	munmap(addr, LENGTH);
-	current =3D cg_read_long(test_group, "memory.current");
+	current =3D cg_read_s64(test_group, "memory.current");
 	expected_current =3D old_current;
 	if (!values_close(expected_current, current, 5)) {
 		ksft_print_msg("memory usage should go back down.\n");
 		ksft_print_msg(
-			"expected memory: %ld, actual memory: %ld\n",
+			"expected memory: %" PRId64 ", actual memory: %" PRId64 "\n",
 			expected_current, current);
 		return ret;
 	}
diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/sel=
ftests/cgroup/test_kmem.c
index 30af47ad6979..43a8eb094f48 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -54,7 +54,7 @@ static int test_kmem_basic(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *cg =3D NULL;
-	long slab0, slab1, current;
+	s64 slab0, slab1, current;
=20
 	cg =3D cg_name(root, "kmem_basic_test");
 	if (!cg)
@@ -66,7 +66,7 @@ static int test_kmem_basic(const char *root)
 	if (cg_run(cg, alloc_dcache, (void *)100000))
 		goto cleanup;
=20
-	slab0 =3D cg_read_key_long(cg, "memory.stat", "slab ");
+	slab0 =3D cg_read_key_s64(cg, "memory.stat", "slab ");
 	if (slab0 < (1 << 20))
 		goto cleanup;
=20
@@ -75,11 +75,11 @@ static int test_kmem_basic(const char *root)
 	/* wait for RCU freeing */
 	sleep(1);
=20
-	slab1 =3D cg_read_key_long(cg, "memory.stat", "slab ");
+	slab1 =3D cg_read_key_s64(cg, "memory.stat", "slab ");
 	if (slab1 < 0)
 		goto cleanup;
=20
-	current =3D cg_read_long(cg, "memory.current");
+	current =3D cg_read_s64(cg, "memory.current");
 	if (current < 0)
 		goto cleanup;
=20
@@ -167,7 +167,7 @@ static int cg_run_in_subcgroups(const char *parent,
  */
 static int test_kmem_memcg_deletion(const char *root)
 {
-	long current, anon, file, kernel, sock, sum;
+	s64 current, anon, file, kernel, sock, sum;
 	int ret =3D KSFT_FAIL;
 	char *parent;
=20
@@ -184,24 +184,24 @@ static int test_kmem_memcg_deletion(const char *root)
 	if (cg_run_in_subcgroups(parent, alloc_kmem_smp, NULL, 100))
 		goto cleanup;
=20
-	current =3D cg_read_long(parent, "memory.current");
-	anon =3D cg_read_key_long(parent, "memory.stat", "anon ");
-	file =3D cg_read_key_long(parent, "memory.stat", "file ");
-	kernel =3D cg_read_key_long(parent, "memory.stat", "kernel ");
-	sock =3D cg_read_key_long(parent, "memory.stat", "sock ");
+	current =3D cg_read_s64(parent, "memory.current");
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
-		printf("memory.current =3D %ld\n", current);
-		printf("anon + file + kernel + sock =3D %ld\n", sum);
-		printf("anon =3D %ld\n", anon);
-		printf("file =3D %ld\n", file);
-		printf("kernel =3D %ld\n", kernel);
-		printf("sock =3D %ld\n", sock);
+		printf("memory.current =3D %" PRId64 "\n", current);
+		printf("anon + file + kernel + sock =3D %" PRId64 "\n", sum);
+		printf("anon =3D %" PRId64 "\n", anon);
+		printf("file =3D %" PRId64 "\n", file);
+		printf("kernel =3D %" PRId64 "\n", kernel);
+		printf("sock =3D %" PRId64 "\n", sock);
 	}
=20
 cleanup:
@@ -248,7 +248,7 @@ static int spawn_1000_threads(const char *cgroup, void =
*arg)
 	int nr_threads =3D 1000;
 	pthread_t *tinfo;
 	unsigned long i;
-	long stack;
+	s64 stack;
 	int ret =3D -1;
=20
 	tinfo =3D calloc(nr_threads, sizeof(pthread_t));
@@ -263,7 +263,7 @@ static int spawn_1000_threads(const char *cgroup, void =
*arg)
 		}
 	}
=20
-	stack =3D cg_read_key_long(cgroup, "memory.stat", "kernel_stack ");
+	stack =3D cg_read_key_s64(cgroup, "memory.stat", "kernel_stack ");
 	if (stack >=3D 4096 * 1000)
 		ret =3D 0;
=20
@@ -307,7 +307,7 @@ static int test_kmem_dead_cgroups(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *parent;
-	long dead =3D -1;
+	s64 dead =3D -1;
=20
 	parent =3D cg_name(root, "kmem_dead_cgroups_test");
 	if (!parent)
@@ -328,9 +328,10 @@ static int test_kmem_dead_cgroups(const char *root)
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
@@ -353,7 +354,7 @@ static int test_percpu_basic(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *parent, *child;
-	long current, percpu, slab;
+	s64 current, percpu, slab;
 	int i;
=20
 	parent =3D cg_name(root, "percpu_basic_test");
@@ -381,16 +382,17 @@ static int test_percpu_basic(const char *root)
 		free(child);
 	}
=20
-	current =3D cg_read_long(parent, "memory.current");
-	percpu =3D cg_read_key_long(parent, "memory.stat", "percpu ");
-	slab =3D cg_read_key_long(parent, "memory.stat", "slab ");
+	current =3D cg_read_s64(parent, "memory.current");
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
+		printf("memory.current %" PRId64 "\npercpu %" PRId64 "\nslab %"
+		       PRId64 "\ndelta %" PRId64 "\n",
+		       current, percpu, slab, current - (percpu + slab));
=20
 cleanup_children:
 	for (i =3D 0; i < 1000; i++) {
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testi=
ng/selftests/cgroup/test_memcontrol.c
index bb673012dcf0..9ff43e7c87b4 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -195,21 +195,21 @@ static int alloc_anon_50M_check(const char *cgroup, v=
oid *arg)
 {
 	size_t size =3D MB(50);
 	char *buf;
-	long anon, current;
+	s64 anon, current;
 	int ret =3D -1;
=20
 	buf =3D alloc_and_populate_anon(size);
 	if (!buf)
 		return -1;
=20
-	current =3D cg_read_long(cgroup, "memory.current");
+	current =3D cg_read_s64(cgroup, "memory.current");
 	if (current < size)
 		goto cleanup;
=20
 	if (!values_close(size, current, 3))
 		goto cleanup;
=20
-	anon =3D cg_read_key_long(cgroup, "memory.stat", "anon ");
+	anon =3D cg_read_key_s64(cgroup, "memory.stat", "anon ");
 	if (anon < 0)
 		goto cleanup;
=20
@@ -226,7 +226,7 @@ static int alloc_pagecache_50M_check(const char *cgroup=
, void *arg)
 {
 	size_t size =3D MB(50);
 	int ret =3D -1;
-	long current, file;
+	s64 current, file;
 	int fd;
=20
 	fd =3D get_temp_fd();
@@ -236,11 +236,11 @@ static int alloc_pagecache_50M_check(const char *cgro=
up, void *arg)
 	if (alloc_pagecache(fd, size))
 		goto cleanup;
=20
-	current =3D cg_read_long(cgroup, "memory.current");
+	current =3D cg_read_s64(cgroup, "memory.current");
 	if (current < size)
 		goto cleanup;
=20
-	file =3D cg_read_key_long(cgroup, "memory.stat", "file ");
+	file =3D cg_read_key_s64(cgroup, "memory.stat", "file ");
 	if (file < 0)
 		goto cleanup;
=20
@@ -262,7 +262,8 @@ static int alloc_pagecache_50M_check(const char *cgroup=
, void *arg)
 static int test_memcg_current_peak(const char *root)
 {
 	int ret =3D KSFT_FAIL;
-	long current, peak, peak_reset;
+	s64 current, peak;
+	long peak_reset;
 	char *memcg;
 	bool fd2_closed =3D false, fd3_closed =3D false, fd4_closed =3D false;
 	int peak_fd =3D -1, peak_fd2 =3D -1, peak_fd3 =3D -1, peak_fd4 =3D -1;
@@ -275,18 +276,18 @@ static int test_memcg_current_peak(const char *root)
 	if (cg_create(memcg))
 		goto cleanup;
=20
-	current =3D cg_read_long(memcg, "memory.current");
+	current =3D cg_read_s64(memcg, "memory.current");
 	if (current !=3D 0)
 		goto cleanup;
=20
-	peak =3D cg_read_long(memcg, "memory.peak");
+	peak =3D cg_read_s64(memcg, "memory.peak");
 	if (peak !=3D 0)
 		goto cleanup;
=20
 	if (cg_run(memcg, alloc_anon_50M_check, NULL))
 		goto cleanup;
=20
-	peak =3D cg_read_long(memcg, "memory.peak");
+	peak =3D cg_read_s64(memcg, "memory.peak");
 	if (peak < MB(50))
 		goto cleanup;
=20
@@ -342,7 +343,7 @@ static int test_memcg_current_peak(const char *root)
 		goto cleanup;
=20
 	/* Make sure a completely independent read isn't affected by our  FD-loca=
l reset above*/
-	peak =3D cg_read_long(memcg, "memory.peak");
+	peak =3D cg_read_s64(memcg, "memory.peak");
 	if (peak < MB(50))
 		goto cleanup;
=20
@@ -359,23 +360,23 @@ static int test_memcg_current_peak(const char *root)
 	if (peak_reset !=3D sizeof(reset_string))
 		goto cleanup;
=20
-	peak =3D cg_read_long_fd(peak_fd);
+	peak =3D cg_read_s64_fd(peak_fd);
 	if (peak > MB(30) || peak < 0)
 		goto cleanup;
=20
 	if (cg_run(memcg, alloc_pagecache_50M_check, NULL))
 		goto cleanup;
=20
-	peak =3D cg_read_long(memcg, "memory.peak");
+	peak =3D cg_read_s64(memcg, "memory.peak");
 	if (peak < MB(50))
 		goto cleanup;
=20
 	/* Make sure everything is back to normal */
-	peak =3D cg_read_long_fd(peak_fd);
+	peak =3D cg_read_s64_fd(peak_fd);
 	if (peak < MB(50))
 		goto cleanup;
=20
-	peak =3D cg_read_long_fd(peak_fd4);
+	peak =3D cg_read_s64_fd(peak_fd4);
 	if (peak < MB(50))
 		goto cleanup;
=20
@@ -451,7 +452,7 @@ static int cg_test_proc_killed(const char *cgroup)
 	return -1;
 }
=20
-static bool reclaim_until(const char *memcg, long goal);
+static bool reclaim_until(const char *memcg, s64 goal);
=20
 /*
  * First, this test creates the following hierarchy:
@@ -495,8 +496,8 @@ static int test_memcg_protection(const char *root, bool=
 min)
 	char *parent[3] =3D {NULL};
 	char *children[4] =3D {NULL};
 	const char *attribute =3D min ? "memory.min" : "memory.low";
-	long c[4];
-	long current;
+	s64 c[4];
+	s64 current;
 	int i, attempts;
 	int fd;
=20
@@ -519,7 +520,7 @@ static int test_memcg_protection(const char *root, bool=
 min)
 	if (cg_create(parent[0]))
 		goto cleanup;
=20
-	if (cg_read_long(parent[0], attribute)) {
+	if (cg_read_s64(parent[0], attribute)) {
 		/* No memory.min on older kernels is fine */
 		if (min)
 			ret =3D KSFT_SKIP;
@@ -571,7 +572,7 @@ static int test_memcg_protection(const char *root, bool=
 min)
 		goto cleanup;
=20
 	attempts =3D 0;
-	while (!values_close(cg_read_long(parent[1], "memory.current"),
+	while (!values_close(cg_read_s64(parent[1], "memory.current"),
 			     MB(150), 3)) {
 		if (attempts++ > 5)
 			break;
@@ -581,11 +582,11 @@ static int test_memcg_protection(const char *root, bo=
ol min)
 	if (cg_run(parent[2], alloc_anon, (void *)MB(148)))
 		goto cleanup;
=20
-	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
+	if (!values_close(cg_read_s64(parent[1], "memory.current"), MB(50), 3))
 		goto cleanup;
=20
 	for (i =3D 0; i < ARRAY_SIZE(children); i++)
-		c[i] =3D cg_read_long(children[i], "memory.current");
+		c[i] =3D cg_read_s64(children[i], "memory.current");
=20
 	if (!values_close(c[0], MB(29), 15))
 		goto cleanup;
@@ -606,7 +607,7 @@ static int test_memcg_protection(const char *root, bool=
 min)
 	}
=20
 	current =3D min ? MB(50) : MB(30);
-	if (!values_close(cg_read_long(parent[1], "memory.current"), current, 3))
+	if (!values_close(cg_read_s64(parent[1], "memory.current"), current, 3))
 		goto cleanup;
=20
 	if (!reclaim_until(children[0], MB(10)))
@@ -626,10 +627,10 @@ static int test_memcg_protection(const char *root, bo=
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
@@ -678,11 +679,11 @@ static int alloc_pagecache_max_30M(const char *cgroup=
, void *arg)
 {
 	size_t size =3D MB(50);
 	int ret =3D -1;
-	long current, high, max;
+	s64 current, high, max;
 	int fd;
=20
-	high =3D cg_read_long(cgroup, "memory.high");
-	max =3D cg_read_long(cgroup, "memory.max");
+	high =3D cg_read_s64(cgroup, "memory.high");
+	max =3D cg_read_s64(cgroup, "memory.max");
 	if (high !=3D MB(30) && max !=3D MB(30))
 		return -1;
=20
@@ -693,7 +694,7 @@ static int alloc_pagecache_max_30M(const char *cgroup, =
void *arg)
 	if (alloc_pagecache(fd, size))
 		goto cleanup;
=20
-	current =3D cg_read_long(cgroup, "memory.current");
+	current =3D cg_read_s64(cgroup, "memory.current");
 	if (!values_close(current, MB(30), 5))
 		goto cleanup;
=20
@@ -714,7 +715,7 @@ static int test_memcg_high(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *memcg;
-	long high;
+	s64 high;
=20
 	memcg =3D cg_name(root, "memcg_test");
 	if (!memcg)
@@ -741,7 +742,7 @@ static int test_memcg_high(const char *root)
 	if (cg_run(memcg, alloc_pagecache_max_30M, NULL))
 		goto cleanup;
=20
-	high =3D cg_read_key_long(memcg, "memory.events", "high ");
+	high =3D cg_read_key_s64(memcg, "memory.events", "high ");
 	if (high <=3D 0)
 		goto cleanup;
=20
@@ -777,8 +778,8 @@ static int test_memcg_high_sync(const char *root)
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
@@ -787,8 +788,8 @@ static int test_memcg_high_sync(const char *root)
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
@@ -811,8 +812,8 @@ static int test_memcg_high_sync(const char *root)
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
@@ -839,7 +840,7 @@ static int test_memcg_max(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *memcg;
-	long current, max;
+	s64 current, max;
=20
 	memcg =3D cg_name(root, "memcg_test");
 	if (!memcg)
@@ -864,11 +865,11 @@ static int test_memcg_max(const char *root)
 	if (cg_run(memcg, alloc_pagecache_max_30M, NULL))
 		goto cleanup;
=20
-	current =3D cg_read_long(memcg, "memory.current");
+	current =3D cg_read_s64(memcg, "memory.current");
 	if (current > MB(30) || !current)
 		goto cleanup;
=20
-	max =3D cg_read_key_long(memcg, "memory.events", "max ");
+	max =3D cg_read_key_s64(memcg, "memory.events", "max ");
 	if (max <=3D 0)
 		goto cleanup;
=20
@@ -896,15 +897,15 @@ static int test_memcg_max(const char *root)
  * false if memory.reclaim's error codes do not make sense, even if
  * the usage goal was satisfied.
  */
-static bool reclaim_until(const char *memcg, long goal)
+static bool reclaim_until(const char *memcg, s64 goal)
 {
 	char buf[64];
 	int retries, err;
-	long current, to_reclaim;
+	s64 current, to_reclaim;
 	bool reclaimed =3D false;
=20
 	for (retries =3D 5; retries > 0; retries--) {
-		current =3D cg_read_long(memcg, "memory.current");
+		current =3D cg_read_s64(memcg, "memory.current");
=20
 		if (current < goal || values_close(current, goal, 3))
 			break;
@@ -913,7 +914,7 @@ static bool reclaim_until(const char *memcg, long goal)
 			return false;
=20
 		to_reclaim =3D current - goal;
-		snprintf(buf, sizeof(buf), "%ld", to_reclaim);
+		snprintf(buf, sizeof(buf), "%" PRId64, to_reclaim);
 		err =3D cg_write(memcg, "memory.reclaim", buf);
 		if (!err)
 			reclaimed =3D true;
@@ -933,7 +934,7 @@ static int test_memcg_reclaim(const char *root)
 	int fd =3D -1;
 	int retries;
 	char *memcg;
-	long current, expected_usage;
+	s64 current, expected_usage;
=20
 	memcg =3D cg_name(root, "memcg_test");
 	if (!memcg)
@@ -942,7 +943,7 @@ static int test_memcg_reclaim(const char *root)
 	if (cg_create(memcg))
 		goto cleanup;
=20
-	current =3D cg_read_long(memcg, "memory.current");
+	current =3D cg_read_s64(memcg, "memory.current");
 	if (current !=3D 0)
 		goto cleanup;
=20
@@ -967,14 +968,14 @@ static int test_memcg_reclaim(const char *root)
 	 * retries).
 	 */
 	retries =3D 5;
-	while (!values_close(cg_read_long(memcg, "memory.current"),
-			    expected_usage, 10)) {
+	while (!values_close(cg_read_s64(memcg, "memory.current"),
+			     expected_usage, 10)) {
 		if (retries--) {
 			sleep(1);
 			continue;
 		} else {
 			fprintf(stderr,
-				"failed to allocate %ld for memcg reclaim test\n",
+				"failed to allocate %" PRId64 " for memcg reclaim test\n",
 				expected_usage);
 			goto cleanup;
 		}
@@ -1001,18 +1002,18 @@ static int alloc_anon_50M_check_swap(const char *cg=
roup, void *arg)
 	long mem_max =3D (long)arg;
 	size_t size =3D MB(50);
 	char *buf;
-	long mem_current, swap_current;
+	s64 mem_current, swap_current;
 	int ret =3D -1;
=20
 	buf =3D alloc_and_populate_anon(size);
 	if (!buf)
 		return -1;
=20
-	mem_current =3D cg_read_long(cgroup, "memory.current");
+	mem_current =3D cg_read_s64(cgroup, "memory.current");
 	if (!mem_current || !values_close(mem_current, mem_max, 3))
 		goto cleanup;
=20
-	swap_current =3D cg_read_long(cgroup, "memory.swap.current");
+	swap_current =3D cg_read_s64(cgroup, "memory.swap.current");
 	if (!swap_current ||
 	    !values_close(mem_current + swap_current, size, 3))
 		goto cleanup;
@@ -1032,7 +1033,7 @@ static int test_memcg_swap_max_peak(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *memcg;
-	long max, peak;
+	s64 max, peak;
 	struct stat ss;
 	int swap_peak_fd =3D -1, mem_peak_fd =3D -1;
=20
@@ -1049,7 +1050,7 @@ static int test_memcg_swap_max_peak(const char *root)
 	if (cg_create(memcg))
 		goto cleanup;
=20
-	if (cg_read_long(memcg, "memory.swap.current")) {
+	if (cg_read_s64(memcg, "memory.swap.current")) {
 		ret =3D KSFT_SKIP;
 		goto cleanup;
 	}
@@ -1081,10 +1082,10 @@ static int test_memcg_swap_max_peak(const char *roo=
t)
 	if (mem_peak_fd =3D=3D -1)
 		goto cleanup;
=20
-	if (cg_read_long(memcg, "memory.swap.peak"))
+	if (cg_read_s64(memcg, "memory.swap.peak"))
 		goto cleanup;
=20
-	if (cg_read_long_fd(swap_peak_fd))
+	if (cg_read_s64_fd(swap_peak_fd))
 		goto cleanup;
=20
 	/* switch the swap and mem fds into local-peak tracking mode*/
@@ -1093,20 +1094,20 @@ static int test_memcg_swap_max_peak(const char *roo=
t)
 	if (peak_reset !=3D sizeof(reset_string))
 		goto cleanup;
=20
-	if (cg_read_long_fd(swap_peak_fd))
+	if (cg_read_s64_fd(swap_peak_fd))
 		goto cleanup;
=20
-	if (cg_read_long(memcg, "memory.peak"))
+	if (cg_read_s64(memcg, "memory.peak"))
 		goto cleanup;
=20
-	if (cg_read_long_fd(mem_peak_fd))
+	if (cg_read_s64_fd(mem_peak_fd))
 		goto cleanup;
=20
 	peak_reset =3D write(mem_peak_fd, reset_string, sizeof(reset_string));
 	if (peak_reset !=3D sizeof(reset_string))
 		goto cleanup;
=20
-	if (cg_read_long_fd(mem_peak_fd))
+	if (cg_read_s64_fd(mem_peak_fd))
 		goto cleanup;
=20
 	if (cg_read_strcmp(memcg, "memory.max", "max\n"))
@@ -1125,25 +1126,25 @@ static int test_memcg_swap_max_peak(const char *roo=
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
-	peak =3D cg_read_long(memcg, "memory.peak");
+	peak =3D cg_read_s64(memcg, "memory.peak");
 	if (peak < MB(29))
 		goto cleanup;
=20
-	peak =3D cg_read_long(memcg, "memory.swap.peak");
+	peak =3D cg_read_s64(memcg, "memory.swap.peak");
 	if (peak < MB(29))
 		goto cleanup;
=20
-	peak =3D cg_read_long_fd(mem_peak_fd);
+	peak =3D cg_read_s64_fd(mem_peak_fd);
 	if (peak < MB(29))
 		goto cleanup;
=20
-	peak =3D cg_read_long_fd(swap_peak_fd);
+	peak =3D cg_read_s64_fd(swap_peak_fd);
 	if (peak < MB(29))
 		goto cleanup;
=20
@@ -1168,7 +1169,7 @@ static int test_memcg_swap_max_peak(const char *root)
 	if (peak_reset !=3D sizeof(reset_string))
 		goto cleanup;
=20
-	peak =3D cg_read_long_fd(swap_peak_fd);
+	peak =3D cg_read_s64_fd(swap_peak_fd);
 	if (peak > MB(10))
 		goto cleanup;
=20
@@ -1176,36 +1177,36 @@ static int test_memcg_swap_max_peak(const char *roo=
t)
 	 * The cgroup is now empty, but there may be a page or two associated
 	 * with the open FD accounted to it.
 	 */
-	peak =3D cg_read_long_fd(mem_peak_fd);
+	peak =3D cg_read_s64_fd(mem_peak_fd);
 	if (peak > MB(1))
 		goto cleanup;
=20
-	if (cg_read_long(memcg, "memory.peak") < MB(29))
+	if (cg_read_s64(memcg, "memory.peak") < MB(29))
 		goto cleanup;
=20
-	if (cg_read_long(memcg, "memory.swap.peak") < MB(29))
+	if (cg_read_s64(memcg, "memory.swap.peak") < MB(29))
 		goto cleanup;
=20
 	if (cg_run(memcg, alloc_anon_50M_check_swap, (void *)MB(30)))
 		goto cleanup;
=20
-	max =3D cg_read_key_long(memcg, "memory.events", "max ");
+	max =3D cg_read_key_s64(memcg, "memory.events", "max ");
 	if (max <=3D 0)
 		goto cleanup;
=20
-	peak =3D cg_read_long(memcg, "memory.peak");
+	peak =3D cg_read_s64(memcg, "memory.peak");
 	if (peak < MB(29))
 		goto cleanup;
=20
-	peak =3D cg_read_long(memcg, "memory.swap.peak");
+	peak =3D cg_read_s64(memcg, "memory.swap.peak");
 	if (peak < MB(29))
 		goto cleanup;
=20
-	peak =3D cg_read_long_fd(mem_peak_fd);
+	peak =3D cg_read_s64_fd(mem_peak_fd);
 	if (peak < MB(29))
 		goto cleanup;
=20
-	peak =3D cg_read_long_fd(swap_peak_fd);
+	peak =3D cg_read_s64_fd(swap_peak_fd);
 	if (peak < MB(19))
 		goto cleanup;
=20
@@ -1251,10 +1252,10 @@ static int test_memcg_oom_events(const char *root)
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
@@ -1339,9 +1340,9 @@ static int tcp_client(const char *cgroup, unsigned sh=
ort port)
 	long budget =3D 4 * MEMCG_FLUSH_BYTES;
 	int rcvbuf =3D 64 * 1024;
 	int sk, ret;
-	long allocated;
+	s64 allocated;
=20
-	allocated =3D cg_read_long(cgroup, "memory.current");
+	allocated =3D cg_read_s64(cgroup, "memory.current");
 	snprintf(servport, sizeof(servport), "%hd", port);
 	ret =3D getaddrinfo(server, servport, NULL, &ai);
 	if (ret)
@@ -1363,7 +1364,7 @@ static int tcp_client(const char *cgroup, unsigned sh=
ort port)
 	ret =3D KSFT_FAIL;
 	while (budget > 0) {
 		uint8_t buf[0x100000];
-		long current, sock;
+		s64 current, sock;
 		ssize_t len;
=20
 		len =3D read(sk, buf, sizeof(buf));
@@ -1371,8 +1372,8 @@ static int tcp_client(const char *cgroup, unsigned sh=
ort port)
 			goto close_sk;
 		budget -=3D len;
=20
-		current =3D cg_read_long(cgroup, "memory.current");
-		sock =3D cg_read_key_long(cgroup, "memory.stat", "sock ");
+		current =3D cg_read_s64(cgroup, "memory.current");
+		sock =3D cg_read_key_s64(cgroup, "memory.stat", "sock ");
=20
 		if (current < 0 || sock < 0)
 			goto close_sk;
@@ -1422,7 +1423,7 @@ static int test_memcg_sock(const char *root)
 	int bind_retries =3D 5, ret =3D KSFT_FAIL, pid, err;
 	unsigned short port;
 	char *memcg;
-	long sock_post =3D -1;
+	s64 sock_post =3D -1;
 	int flush_rounds =3D 3;
=20
 	if (memcg_sockets_disabled())
@@ -1478,7 +1479,7 @@ static int test_memcg_sock(const char *root)
 	if (WEXITSTATUS(err))
 		goto cleanup;
=20
-	if (cg_read_long(memcg, "memory.current") < 0)
+	if (cg_read_s64(memcg, "memory.current") < 0)
 		goto cleanup;
=20
 	/* the uncharge is done, but a flush still walking the CPUs can hide it f=
rom a read */
@@ -1486,7 +1487,7 @@ static int test_memcg_sock(const char *root)
 		if (cg_run(memcg, alloc_anon, (void *)MEMCG_FLUSH_BYTES))
 			goto cleanup;
=20
-		sock_post =3D cg_read_key_long(memcg, "memory.stat", "sock ");
+		sock_post =3D cg_read_key_s64(memcg, "memory.stat", "sock ");
 		if (!sock_post)
 			break;
 	}
@@ -1512,7 +1513,7 @@ static int test_memcg_oom_group_leaf_events(const cha=
r *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *parent, *child;
-	long parent_oom_events;
+	s64 parent_oom_events;
=20
 	parent =3D cg_name(root, "memcg_test_0");
 	child =3D cg_name(root, "memcg_test_0/memcg_test_1");
@@ -1547,11 +1548,11 @@ static int test_memcg_oom_group_leaf_events(const c=
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
@@ -1667,7 +1668,7 @@ static int test_memcg_oom_group_score_events(const ch=
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
index e775c5510cf2..9c1cda47c73d 100644
--- a/tools/testing/selftests/cgroup/test_pids.c
+++ b/tools/testing/selftests/cgroup/test_pids.c
@@ -114,9 +114,9 @@ static int test_pids_events(const char *root)
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
=20
@@ -179,7 +179,7 @@ static int test_pids_events_notify(const char *root)
 	if (cg_run_nowait(cg_pids, run_success, NULL) !=3D -1 || errno !=3D EAGAI=
N)
 		goto cleanup;
=20
-	if (cg_read_key_long(cg_pids, "pids.events", "max ") !=3D 1)
+	if (cg_read_key_s64(cg_pids, "pids.events", "max ") !=3D 1)
 		goto cleanup;
=20
 	pfd.fd =3D inotify_fd;
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/se=
lftests/cgroup/test_zswap.c
index d50acc1b83ac..a851f6fe5875 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -60,14 +60,14 @@ static int get_zswap_stored_pages(size_t *value)
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
@@ -126,9 +126,10 @@ static char *setup_test_group_1M(const char *root, con=
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
@@ -148,7 +149,7 @@ static long wait_for_writeback(const char *cg, int time=
out_ms)
  */
 static int test_zswap_usage(const char *root)
 {
-	long zswpout_before, zswpout_after;
+	s64 zswpout_before, zswpout_after;
 	int ret =3D KSFT_FAIL;
 	char *test_group;
=20
@@ -192,7 +193,7 @@ static int test_swapin_nozswap(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *test_group, mem_max_buf[32];
-	long swap_peak, zswpout, min_swap;
+	s64 swap_peak, zswpout, min_swap;
 	size_t allocation_size =3D page_size * 512;
=20
 	min_swap =3D allocation_size / 4;
@@ -213,15 +214,15 @@ static int test_swapin_nozswap(const char *root)
 		goto out;
=20
 	/* Verify that pages are swapped out, but no zswap happened */
-	swap_peak =3D cg_read_long(test_group, "memory.swap.peak");
+	swap_peak =3D cg_read_s64(test_group, "memory.swap.peak");
 	if (swap_peak < 0) {
 		ksft_print_msg("failed to get cgroup's swap_peak\n");
 		goto out;
 	}
=20
 	if (swap_peak < min_swap) {
-		ksft_print_msg("at least %ldKB of memory should be swapped out\n",
-				min_swap / 1024);
+		ksft_print_msg("at least %" PRId64 "KB of memory should be swapped out\n=
",
+			       min_swap / 1024);
 		goto out;
 	}
=20
@@ -249,7 +250,7 @@ static int test_zswapin(const char *root)
 {
 	int ret =3D KSFT_FAIL;
 	char *test_group;
-	long zswpin;
+	s64 zswpin;
=20
 	test_group =3D cg_name(root, "zswapin_test");
 	if (!test_group)
@@ -265,7 +266,7 @@ static int test_zswapin(const char *root)
 	if (cg_run(test_group, allocate_and_read_bytes, (void *)MB(32)))
 		goto out;
=20
-	zswpin =3D cg_read_key_long(test_group, "memory.stat", "zswpin ");
+	zswpin =3D cg_read_key_s64(test_group, "memory.stat", "zswpin ");
 	if (zswpin < 0) {
 		ksft_print_msg("failed to get zswpin\n");
 		goto out;
@@ -300,7 +301,7 @@ static int attempt_writeback(const char *cgroup, void *=
arg)
 {
 	size_t memsize =3D page_size * 1024;
 	char buf[page_size];
-	long zswap_usage;
+	s64 zswap_usage;
 	bool wb_enabled =3D *(bool *) arg;
 	int ret =3D -1;
 	char *mem;
@@ -326,7 +327,7 @@ static int attempt_writeback(const char *cgroup, void *=
arg)
 		goto out;
 	}
=20
-	zswap_usage =3D cg_read_long(cgroup, "memory.zswap.current");
+	zswap_usage =3D cg_read_s64(cgroup, "memory.zswap.current");
=20
 	/* zswpin */
 	for (int i =3D 0; i < memsize; i +=3D page_size) {
@@ -365,11 +366,12 @@ static int attempt_writeback(const char *cgroup, void=
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
+		ksft_print_msg("zswpwb_before =3D %" PRId64 " instead of 0\n",
+			       zswpwb_before);
 		return -1;
 	}
=20
@@ -385,8 +387,8 @@ static int test_zswap_writeback_one(const char *cgroup,=
 bool wb)
 		return -1;
=20
 	if (wb !=3D !!zswpwb_after) {
-		ksft_print_msg("zswpwb_after is %ld while wb is %s\n",
-				zswpwb_after, wb ? "enabled" : "disabled");
+		ksft_print_msg("zswpwb_after is %" PRId64 " while wb is %s\n",
+			       zswpwb_after, wb ? "enabled" : "disabled");
 		return -1;
 	}
=20
@@ -475,7 +477,7 @@ static int test_no_invasive_cgroup_shrink(const char *r=
oot)
 {
 	int ret =3D KSFT_FAIL;
 	unsigned int off;
-	long zswpwb_before, zswpwb_after, zswpwb_target;
+	s64 zswpwb_before, zswpwb_after, zswpwb_target;
 	size_t allocation_size =3D page_size * 1024;
 	unsigned int nr_pages =3D allocation_size / page_size;
 	char zswap_max_buf[32], mem_max_buf[32];
@@ -508,7 +510,7 @@ static int test_no_invasive_cgroup_shrink(const char *r=
oot)
 		memset(&zw_allocation[off], 0, page_size);
 		memset(&zw_allocation[off], 'a', page_size/4);
 	}
-	if (cg_read_key_long(zw_group, "memory.stat", "zswapped") < 1)
+	if (cg_read_key_s64(zw_group, "memory.stat", "zswapped") < 1)
 		goto out;
=20
 	/* If the shrinker is enabled, try to let the writebacks finish first */
@@ -663,12 +665,11 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			long zswapped =3D cg_read_key_long(
-				test_group, "memory.stat", "zswapped ");
-			long long delta =3D
-				(long long)stored_pages * page_size - zswapped;
-			long long max_delta =3D
-				(long long)stored_pages * page_size / 4;
+			s64 zswapped =3D cg_read_key_s64(test_group,
+						       "memory.stat",
+						       "zswapped ");
+			s64 delta =3D (s64)stored_pages * page_size - zswapped;
+			s64 max_delta =3D (s64)stored_pages * page_size / 4;
=20
 			ret =3D (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
@@ -739,9 +740,9 @@ static int allocate_random_and_wait(const char *cgroup,=
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
@@ -757,7 +758,7 @@ static int test_zswap_incompressible(const char *root)
 	int ret =3D KSFT_FAIL;
 	struct incomp_child_args *values;
 	char *test_group;
-	long zswap_incomp;
+	s64 zswap_incomp;
 	pid_t child_pid;
 	int child_status;
 	char buf;
@@ -793,12 +794,16 @@ static int test_zswap_incompressible(const char *root=
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
+		s64 zswpout =3D get_zswpout(test_group);
+		s64 zswapped =3D
+			cg_read_key_s64(test_group, "memory.stat", "zswapped ");
+		s64 zswap_b =3D
+			cg_read_key_s64(test_group, "memory.stat", "zswap ");
+
+		ksft_print_msg("zswap_incomp not increased: %" PRId64 "\n",
+			       zswap_incomp);
+		ksft_print_msg("debug: zswpout=3D%" PRId64 " zswapped=3D%" PRId64
+			       " zswap_b=3D%" PRId64 "\n",
 			       zswpout, zswapped, zswap_b);
 		ksft_print_msg("debug: madvise ret=3D%d errno=3D%d\n",
 			       values->madvise_ret, values->madvise_errno);
--=20
2.56.0.506.g506a7eabc5-goog

