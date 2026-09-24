Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10954B1293
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 18:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790275695; cv=none; b=Zwp9tIfvVzxBAGjoOnUlHJAID/5AfyH0pxV3oMuZ82LfosYo0NnpaK0iAq6uzdg2ARP0QMpHhWyBEMGKGhkzP8tHqABBhmBD7XPRniD3D8FL11J+i/kGYRZzIDgBfa4bWGeo6gQj9rJQa+CpOQ/KTjkAyGwqrGtqnIkW+WnI0DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790275695; c=relaxed/simple;
	bh=9jyiyub5pkrnacT6pD4Pz1+9t1/b6Bu7Fi8ftJHlMSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibykCp6MrrBCJx4XIlw8MvimER+mzo+eZ+AZ/hJB1FBXpm1JTtR6v/iDxRSokx/eepuauLy/IkEQbLtFO8aPNGM/Dee9HF09itNWcXObPGFTFxWzqAwebrItNk0aTn6/udskkIYsoXqyvbLvuZ+rttCfolrNc4L/CyydR1vzBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OH9wo06k; arc=none smtp.client-ip=95.215.58.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OH9wo06k"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9jyiyub5pkrnacT6pD4Pz1+9t1/b6Bu7Fi8ftJHlMSQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790275683; v=1; x=1790880483;
 b=OH9wo06k9/Fnu35XwoLBll23iqCQGlAEPK/fZrp1NIsjqWL4AoK+57TmyYAIXhjd3LlgOU40
 wk/Q49psUZi0DQRSbLOE4IqagUfT6Blu76471uezZmTTc7ruCQtPQSNtq182el/aYCOM6BVqHKz
 82sHkBTL+v5+97pVPYWa+Ezc=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f865f6d5c743fba8;
	Thu, 24 Sep 2026 18:48:02 +0000
X-Mizu-Trace-ID: f865f6d5c743fba8
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>,
	kernel-team@meta.com,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 7/7] selftests: cgroup: check that high_work reclaim is charged to the memcg
Date: Thu, 24 Sep 2026 11:47:11 -0700
Message-ID: <20260924184714.912181-8-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fill a memcg's TCP receive buffers from softirq while its only task
sleeps, so the memcg goes over memory.high and high_work reclaims.

test_memcg_high_work checks that the memcg's cpu.stat and
memory.pressure grow, which only happens if that reclaim is charged to
the memcg.

test_memcg_high_work_cpu_max also runs a CPU hog in the memcg under a
cpu.max limit. The reclaim time should come out of the memcg's quota,
so the hog should get less CPU while high_work is busy.

Both need swap, so the anon memory can be reclaimed.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 .../selftests/cgroup/test_memcontrol.c        | 332 ++++++++++++++++++
 1 file changed, 332 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ed82347044e..00802804c0d9 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -18,6 +18,7 @@
 #include <netdb.h>
 #include <errno.h>
 #include <sys/mman.h>
+#include <time.h>
 
 #include "kselftest.h"
 #include "cgroup_util.h"
@@ -1474,6 +1475,335 @@ static int test_memcg_sock(const char *root)
 	return ret;
 }
 
+#define HIGH_WORK_NCONN		16
+
+struct high_work_args {
+	int ctl[2];
+};
+
+/*
+ * Fill some anon memory, accept HIGH_WORK_NCONN connections, then sleep
+ * without ever reading, so all received data stays charged to the memcg.
+ */
+static int high_work_receiver(const char *cgroup, void *arg)
+{
+	struct high_work_args *args = arg;
+	struct sockaddr_in sa = { .sin_family = AF_INET };
+	socklen_t len = sizeof(sa);
+	int sk, i, rcvbuf = MB(8);
+	unsigned long long x = 1, *p;
+	size_t size = MB(256);
+
+	close(args->ctl[0]);
+
+	/* Hard to compress, so reclaiming it to swap takes real work. */
+	p = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (p == MAP_FAILED)
+		return -1;
+	for (size_t j = 0; j < size / sizeof(*p); j++) {
+		x = x * 6364136223846793005ULL + 1442695040888963407ULL;
+		p[j] = x;
+	}
+
+	sk = socket(AF_INET, SOCK_STREAM, 0);
+	if (sk < 0)
+		return -1;
+	if (setsockopt(sk, SOL_SOCKET, SO_RCVBUFFORCE, &rcvbuf, sizeof(rcvbuf)))
+		return -1;
+	sa.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+	if (bind(sk, (struct sockaddr *)&sa, len) || listen(sk, HIGH_WORK_NCONN))
+		return -1;
+	if (getsockname(sk, (struct sockaddr *)&sa, &len))
+		return -1;
+	if (write(args->ctl[1], &sa.sin_port, sizeof(sa.sin_port)) !=
+	    sizeof(sa.sin_port))
+		return -1;
+
+	for (i = 0; i < HIGH_WORK_NCONN; i++)
+		if (accept(sk, NULL, NULL) < 0)
+			return -1;
+	if (write(args->ctl[1], "A", 1) != 1)
+		return -1;
+
+	for (;;)
+		pause();
+	return 0;
+}
+
+static long psi_some_total(const char *cgroup, const char *control)
+{
+	char buf[BUF_SIZE];
+	long total;
+
+	if (cg_read(cgroup, control, buf, sizeof(buf)))
+		return -1;
+	if (sscanf(buf, "some avg10=%*f avg60=%*f avg300=%*f total=%ld",
+		   &total) != 1)
+		return -1;
+	return total;
+}
+
+/*
+ * Socket memory charged from softirq can push a memcg over memory.high.
+ * The reclaim then runs from high_work on a kworker. The memcg's only task
+ * sleeps the whole time here, so its cpu.stat and memory.pressure only move
+ * if that reclaim is charged to the memcg.
+ */
+static int test_memcg_high_work(const char *root)
+{
+	int ret = KSFT_FAIL, pid = -1, i, sk[HIGH_WORK_NCONN];
+	long usage, high, some, current, sent = 0;
+	struct high_work_args args;
+	char *memcg, *buf = NULL, c;
+	in_port_t port;
+	time_t last;
+
+	for (i = 0; i < HIGH_WORK_NCONN; i++)
+		sk[i] = -1;
+
+	if (!is_swap_enabled())
+		return KSFT_SKIP;
+
+	memcg = cg_name(root, "memcg_test");
+	if (!memcg)
+		goto cleanup;
+	if (cg_create(memcg))
+		goto cleanup;
+	if (pipe(args.ctl))
+		goto cleanup;
+
+	pid = cg_run_nowait(memcg, high_work_receiver, &args);
+	if (pid < 0)
+		goto cleanup;
+	close(args.ctl[1]);
+	if (read(args.ctl[0], &port, sizeof(port)) != sizeof(port))
+		goto cleanup;
+
+	for (i = 0; i < HIGH_WORK_NCONN; i++) {
+		struct sockaddr_in sa = { .sin_family = AF_INET, .sin_port = port };
+
+		sa.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		sk[i] = socket(AF_INET, SOCK_STREAM, 0);
+		if (sk[i] < 0 || connect(sk[i], (struct sockaddr *)&sa, sizeof(sa)))
+			goto cleanup;
+	}
+	if (read(args.ctl[0], &c, 1) != 1)
+		goto cleanup;
+
+	/* Just above the current usage, so this write does not reclaim. */
+	current = cg_read_long(memcg, "memory.current");
+	if (current < 0 || cg_write_numeric(memcg, "memory.high", current + MB(2)))
+		goto cleanup;
+
+	usage = cg_read_key_long(memcg, "cpu.stat", "usage_usec ");
+	high = cg_read_key_long(memcg, "memory.events", "high ");
+	some = psi_some_total(memcg, "memory.pressure");
+
+	/* Fill all sockets until they stop taking data. */
+	buf = calloc(1, MB(1));
+	if (!buf)
+		goto cleanup;
+	last = time(NULL);
+	while (time(NULL) - last < 2) {
+		for (i = 0; i < HIGH_WORK_NCONN; i++) {
+			long n = send(sk[i], buf, MB(1), MSG_DONTWAIT);
+
+			if (n > 0) {
+				sent += n;
+				last = time(NULL);
+			}
+		}
+	}
+	sleep(2);
+
+	if (cg_read_key_long(memcg, "memory.events", "high ") <= high) {
+		ksft_print_msg("high_work did not run, sent %ld bytes\n", sent);
+		goto cleanup;
+	}
+	if (cg_read_key_long(memcg, "cpu.stat", "usage_usec ") <= usage) {
+		ksft_print_msg("high_work CPU time not charged to the memcg\n");
+		goto cleanup;
+	}
+	if (some >= 0 && psi_some_total(memcg, "memory.pressure") <= some) {
+		ksft_print_msg("high_work stall not in memcg memory.pressure\n");
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+
+cleanup:
+	for (i = 0; i < HIGH_WORK_NCONN; i++)
+		if (sk[i] >= 0)
+			close(sk[i]);
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+	}
+	free(buf);
+	cg_destroy(memcg);
+	free(memcg);
+
+	return ret;
+}
+
+static int high_work_spinner(const char *cgroup, void *arg)
+{
+	for (;;)
+		;
+	return 0;
+}
+
+/* CPU time @pid has used so far, in microseconds. */
+static long task_cpu_usec(int pid)
+{
+	unsigned long long ns;
+	char buf[128];
+
+	if (proc_read_text(pid, false, "schedstat", buf, sizeof(buf)) <= 0 ||
+	    sscanf(buf, "%llu", &ns) != 1)
+		return -1;
+	return ns / 1000;
+}
+
+static long now_usec(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	return ts.tv_sec * 1000000L + ts.tv_nsec / 1000;
+}
+
+/*
+ * The setup of test_memcg_high_work, plus a CPU hog in the memcg and a
+ * cpu.max limit. The reclaim that high_work does for the memcg should come
+ * out of the memcg's CPU quota, so the hog should get less CPU while
+ * high_work is busy than it gets otherwise.
+ */
+static int test_memcg_high_work_cpu_max(const char *root)
+{
+	int ret = KSFT_FAIL, pid = -1, hog = -1, i, sk[HIGH_WORK_NCONN];
+	long current, h0, h1, h2, t0, t1, t2, u1, u2, reclaim, lost;
+	bool cpu_enabled = false;
+	struct high_work_args args;
+	char *memcg = NULL, *buf = NULL, c;
+	in_port_t port;
+	time_t last;
+
+	for (i = 0; i < HIGH_WORK_NCONN; i++)
+		sk[i] = -1;
+
+	if (!is_swap_enabled())
+		return KSFT_SKIP;
+	if (cg_read_strstr(root, "cgroup.controllers", "cpu"))
+		return KSFT_SKIP;
+	if (cg_read_strstr(root, "cgroup.subtree_control", "cpu")) {
+		if (cg_write(root, "cgroup.subtree_control", "+cpu"))
+			return KSFT_SKIP;
+		cpu_enabled = true;
+	}
+
+	memcg = cg_name(root, "memcg_test");
+	if (!memcg || cg_create(memcg))
+		goto cleanup;
+	/* 20% of a CPU, in short periods so the numbers come out smooth. */
+	if (cg_write(memcg, "cpu.max", "2000 10000"))
+		goto cleanup;
+	if (pipe(args.ctl))
+		goto cleanup;
+
+	pid = cg_run_nowait(memcg, high_work_receiver, &args);
+	if (pid < 0)
+		goto cleanup;
+	close(args.ctl[1]);
+	if (read(args.ctl[0], &port, sizeof(port)) != sizeof(port))
+		goto cleanup;
+
+	for (i = 0; i < HIGH_WORK_NCONN; i++) {
+		struct sockaddr_in sa = { .sin_family = AF_INET, .sin_port = port };
+
+		sa.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		sk[i] = socket(AF_INET, SOCK_STREAM, 0);
+		if (sk[i] < 0 || connect(sk[i], (struct sockaddr *)&sa, sizeof(sa)))
+			goto cleanup;
+	}
+	if (read(args.ctl[0], &c, 1) != 1)
+		goto cleanup;
+
+	hog = cg_run_nowait(memcg, high_work_spinner, NULL);
+	if (hog < 0)
+		goto cleanup;
+
+	current = cg_read_long(memcg, "memory.current");
+	if (current < 0 || cg_write_numeric(memcg, "memory.high", current + MB(2)))
+		goto cleanup;
+
+	/* How much CPU the hog gets without high_work. */
+	sleep(1);
+	h0 = task_cpu_usec(hog);
+	t0 = now_usec();
+	sleep(3);
+	h1 = task_cpu_usec(hog);
+	t1 = now_usec();
+	u1 = cg_read_key_long(memcg, "cpu.stat", "usage_usec ");
+
+	/* Fill the sockets slowly, so high_work runs many times. */
+	buf = calloc(1, 64 << 10);
+	if (!buf)
+		goto cleanup;
+	last = time(NULL);
+	while (time(NULL) - last < 2) {
+		for (i = 0; i < HIGH_WORK_NCONN; i++)
+			if (send(sk[i], buf, 64 << 10, MSG_DONTWAIT) > 0)
+				last = time(NULL);
+		usleep(15000);
+	}
+	h2 = task_cpu_usec(hog);
+	t2 = now_usec();
+	u2 = cg_read_key_long(memcg, "cpu.stat", "usage_usec ");
+
+	if (h0 < 0 || h1 <= h0 || h2 < 0 || u1 < 0 || u2 < 0)
+		goto cleanup;
+
+	/* The receiver sleeps, so the rest of the memcg's time is high_work. */
+	reclaim = (u2 - u1) - (h2 - h1);
+	lost = (h1 - h0) * (t2 - t1) / (t1 - t0) - (h2 - h1);
+	if (reclaim < 30000) {
+		ksft_print_msg("high_work used only %ld us, too little to test\n",
+			       reclaim);
+		ret = KSFT_SKIP;
+		goto cleanup;
+	}
+	if (lost < reclaim / 3) {
+		ksft_print_msg("hog lost %ld us, high_work used %ld us\n",
+			       lost, reclaim);
+		goto cleanup;
+	}
+
+	ret = KSFT_PASS;
+
+cleanup:
+	for (i = 0; i < HIGH_WORK_NCONN; i++)
+		if (sk[i] >= 0)
+			close(sk[i]);
+	if (hog > 0) {
+		kill(hog, SIGKILL);
+		waitpid(hog, NULL, 0);
+	}
+	if (pid > 0) {
+		kill(pid, SIGKILL);
+		waitpid(pid, NULL, 0);
+	}
+	free(buf);
+	if (memcg)
+		cg_destroy(memcg);
+	free(memcg);
+	if (cpu_enabled)
+		cg_write(root, "cgroup.subtree_control", "-cpu");
+
+	return ret;
+}
+
 /*
  * This test disables swapping and tries to allocate anonymous memory
  * up to OOM with memory.group.oom set. Then it checks that all
@@ -1780,6 +2110,8 @@ struct memcg_test {
 	T(test_memcg_oom_events),
 	T(test_memcg_swap_max_peak),
 	T(test_memcg_sock),
+	T(test_memcg_high_work),
+	T(test_memcg_high_work_cpu_max),
 	T(test_memcg_oom_group_leaf_events),
 	T(test_memcg_oom_group_parent_events),
 	T(test_memcg_oom_group_score_events),
-- 
2.53.0-Meta

