Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E43D499F1E
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 18:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786647535; cv=none; b=h+eZBTESQ9aGDVQKFgPirrUu6t4tgzN0uxCcTmn8XmffZAt46G2ER0rtVEH6shIoLA3PStTfsRz7eUcpmtNtRDOXoN/AN1IE6s/5gYF8Fnp+/8Ai3Q7M9dyw3v71XSdGnoJLO+iUwKVBvGf25yq4hLf6vsnfU+PMeIxigISu2co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786647535; c=relaxed/simple;
	bh=GOCeIpJRgFyYHMOfCqGUNzxzujcQWvp3QaqDw0/DsqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYJT3nSGWBZzAOvqXfcFVTWcEf9HODk06xL0677Aite3dFw/oeOkiI9NygSeA38KKLIqOYSTm9Blcz/1lE5VWP0XnGhVqoSx5cPzKUHSf86riOgDwuZFpWnjIzogpF5tnRsDNMURSpFTsOSqlKLpOpr2WduJRRcUmTa99Y7/ywQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f0mz3B09; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f0mz3B09"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2caced6038eso1941475ad.0
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 11:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786647533; x=1787252333; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r8vCfOJqlyeUUrhQ0TEVig3puBrFV2IWvi7C6KR3I1g=;
        b=f0mz3B09o42+sgDyicQmHskQV9bYAolwzXKpc9qBHM9Xti973wqzKUBSNZdRdDmMMr
         U8POGVoOCWOTq2sDp8KA1pnfaOebuz+Xrm+ca1Zn46vz9bSeO3KA939NXpOLbfkVGIdE
         xJQ5KNUNj0+egcwiihBd8dZcQmE9dNVRoFkgM+Rs3K4Vxou1TS4oXmIqp3jjM0VIbCl2
         giZuvLtzFMYlFnUKOI84SOBE/RikV71OUt00NdjgLxreJaEr9NPGqCNZrrvnPcrrJxyI
         qK+BDyHLhb3bl0tDto9f1QZ7NjDQtGBMa8jaISbuDKi5+FTxI0oJSIzgPhvZH9FvDJHv
         xUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786647533; x=1787252333;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r8vCfOJqlyeUUrhQ0TEVig3puBrFV2IWvi7C6KR3I1g=;
        b=hGFUzjMeQm+3NoXw5csoRSPUpv799ETrnHopCLcdL8nGBW2dC6n80PGksnLoHMlYfu
         UnBZmcOfkahxgqqQ5ga7yiOqfXkiKm6rYdAp2gfyqj7QbXTpT8jO0klYUbDLRshWnQN0
         UB4s8ayrm4F6t6o9SXdMv5e2r2toCwJXAC04c3cBfQpn9KTizR416aSGOyN/cgexqqyK
         KRsouyqiZUP56nQVorPtSnCMgqma5PwVSgLQGFi99Nt72aK7QcQxK6nQY1I/8BFQ5tPO
         s8KeZ4d0M02/HdKTsVeeFVHvDaScFLdhFkpmwnx5BaJUukZQvWzoDda1yvX++CC04IbW
         FDvg==
X-Forwarded-Encrypted: i=1; AHgh+RoNrQNkmAUtXVXMFd73grPgezYR5AvtMKkTqaW9u9sqnZPeUVcMXqWP1AKnAu2R1N9ctj1F0pMQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8bHcauKFr+swNZ0/u3V1Glt06wKqYB9OcXxSprh+pGGGs3qSk
	fuJ0/paFNt68xOXTB4c21AbIrzxRrJVa9uFeRm3DCbeiVYp07tmLpp4k
X-Gm-Gg: AR+sD10rmnVs7MdZ1JqWFCLQ72j0Z15mK8e+hL7JOv2nuXz9/cTWQS62UESRWjLidpm
	5oI2tlwa+pMJMektruLshTHb7pciVk6+z0zIop2kyIdTdDDMoAS5BbZOwySINHGJ/hDeQsA8rWh
	x0VQmbyoojm9n8J5OeC9Mr5wAqXOca6MYY7uVAJXJnkgmZz8DW8/wFdo0rkY9AbtfZb8gJaYFle
	7/7YNWov1z1wvTPIrVeFb098vs+i5Iu5GjnVyWRI+9YwCg9dZQJo/HqBrHkQMNwbRIKRpNTxc4g
	tuTX5iObTS0XhlNd1XLHU6B9mQOUeqgNVjETUWe8seND0mqv4mdQVnmZsNXDVnJsTuaNJn1fBV5
	J68uDc7EqYgAY+1wagdTxGxF8EwysQCVJvw3Vv3sYhPlhwikEGoN+LIjcWWBIqVVbmJcWWua7+V
	Qo7y2i3Ol7pYx8sv4jvHcA0Jh/+MXDZolmFXtY3XM1m9h6u45nkgXuKg4=
X-Received: by 2002:a17:902:f64e:b0:2cf:70d2:da7c with SMTP id d9443c01a7336-2d37f77fdfemr99897105ad.12.1786647532683;
        Thu, 13 Aug 2026 11:58:52 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:63::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31eb99e2556sm10969714eec.0.2026.08.13.11.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 11:58:52 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Ben Segall <bsegall@google.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Ziyang Men <ziyang.meme@gmail.com>,
	kernel-team@meta.com,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] selftests/bpf: add cgroup_iter_cpu test for cpu cgroup kfuncs
Date: Thu, 13 Aug 2026 11:58:46 -0700
Message-ID: <20260813185846.1216892-3-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260813185846.1216892-1-ziyang.meme@gmail.com>
References: <20260813185846.1216892-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add cgroup_iter_cpu, a selftest for the added CPU controller BPF kfuncs.

The userspace side runs a CPU hog in a test cgroup with cpu.max settled
then:

  - checks the CPU-time and throttling counters are nonzero,
  - compares whether all values the program read are same as those
    reading from cgroup file.

CONFIG_CGROUP_SCHED, CONFIG_FAIR_GROUP_SCHED and CONFIG_CFS_BANDWIDTH
are added to the test config.

Tests passed on v7.2-rc5.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/bpf/cgroup_iter_cpu.h |  22 ++
 tools/testing/selftests/bpf/config            |   3 +
 .../bpf/prog_tests/cgroup_iter_cpu.c          | 259 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_cpu.c     |  53 ++++
 4 files changed, 337 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_cpu.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c

diff --git a/tools/testing/selftests/bpf/cgroup_iter_cpu.h b/tools/testing/selftests/bpf/cgroup_iter_cpu.h
new file mode 100644
index 000000000000..74599a5c0e4d
--- /dev/null
+++ b/tools/testing/selftests/bpf/cgroup_iter_cpu.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#ifndef __CGROUP_ITER_CPU_H
+#define __CGROUP_ITER_CPU_H
+
+struct cpu_query {
+	/* base cpu time, from cpu.stat */
+	__u64 usage_usec;
+	__u64 user_usec;
+	__u64 system_usec;
+	__u64 nice_usec;
+	__u64 forceidle_usec;
+	/* CFS bandwidth throttling, from cpu.stat and cpu.stat.local */
+	__u64 nr_periods;
+	__u64 nr_throttled;
+	__u64 throttled_usec;
+	__u64 nr_bursts;
+	__u64 burst_usec;
+	__u64 throttled_self_usec;
+};
+
+#endif /* __CGROUP_ITER_CPU_H */
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index ea7044f30adc..482b40dde2f9 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -11,6 +11,9 @@ CONFIG_BPF_STREAM_PARSER=y
 CONFIG_BPF_SYSCALL=y
 # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
 CONFIG_CGROUP_BPF=y
+CONFIG_CGROUP_SCHED=y
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_CFS_BANDWIDTH=y
 CONFIG_CRYPTO_HMAC=y
 CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_USER_API=y
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c
new file mode 100644
index 000000000000..cd7e92ababfb
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_cpu.c
@@ -0,0 +1,259 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <sys/prctl.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include "cgroup_helpers.h"
+#include "cgroup_iter_cpu.h"
+#include "cgroup_iter_cpu.skel.h"
+
+static int read_stats(struct bpf_link *link)
+{
+	int fd, ret = 0;
+	ssize_t bytes;
+
+	fd = bpf_iter_create(bpf_link__fd(link));
+	if (!ASSERT_OK_FD(fd, "bpf_iter_create"))
+		return 1;
+
+	bytes = read(fd, NULL, 0);
+	if (!ASSERT_EQ(bytes, 0, "read fd"))
+		ret = 1;
+
+	close(fd);
+	return ret;
+}
+
+/* Read cgroup file @name into @buf. */
+static int read_cgroup_file(int cgroup_fd, const char *name, char *buf,
+			    size_t size)
+{
+	ssize_t n;
+	int fd;
+
+	fd = openat(cgroup_fd, name, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	n = read(fd, buf, size - 1);
+	close(fd);
+	if (n <= 0)
+		return -1;
+	buf[n] = '\0';
+	return 0;
+}
+
+/* Parse the "cpu.stat" file into @out. */
+static int parse_cpu_stat(int cgroup_fd, struct cpu_query *out)
+{
+	char buf[4096], *line, *sp;
+	unsigned long long v;
+
+	if (read_cgroup_file(cgroup_fd, "cpu.stat", buf, sizeof(buf)))
+		return -1;
+
+	for (line = strtok_r(buf, "\n", &sp); line;
+	     line = strtok_r(NULL, "\n", &sp)) {
+		if (sscanf(line, "usage_usec %llu", &v) == 1)
+			out->usage_usec = v;
+		else if (sscanf(line, "user_usec %llu", &v) == 1)
+			out->user_usec = v;
+		else if (sscanf(line, "system_usec %llu", &v) == 1)
+			out->system_usec = v;
+		else if (sscanf(line, "nice_usec %llu", &v) == 1)
+			out->nice_usec = v;
+		else if (sscanf(line, "core_sched.force_idle_usec %llu", &v) == 1)
+			out->forceidle_usec = v;
+		else if (sscanf(line, "nr_periods %llu", &v) == 1)
+			out->nr_periods = v;
+		else if (sscanf(line, "nr_throttled %llu", &v) == 1)
+			out->nr_throttled = v;
+		else if (sscanf(line, "throttled_usec %llu", &v) == 1)
+			out->throttled_usec = v;
+		else if (sscanf(line, "nr_bursts %llu", &v) == 1)
+			out->nr_bursts = v;
+		else if (sscanf(line, "burst_usec %llu", &v) == 1)
+			out->burst_usec = v;
+	}
+	return 0;
+}
+
+/*
+ * Parse the "cpu.stat.local" file into @out.
+ */
+static int parse_cpu_stat_local(int cgroup_fd, struct cpu_query *out)
+{
+	unsigned long long v;
+	char buf[256];
+
+	if (read_cgroup_file(cgroup_fd, "cpu.stat.local", buf, sizeof(buf)))
+		return -1;
+	if (sscanf(buf, "throttled_usec %llu", &v) != 1)
+		return -1;
+	out->throttled_self_usec = v;
+	return 0;
+}
+
+/* Read file value the bpf program reads. */
+static int parse_stats(int cgroup_fd, struct cpu_query *out, bool have_bw)
+{
+	if (parse_cpu_stat(cgroup_fd, out))
+		return -1;
+	if (have_bw && parse_cpu_stat_local(cgroup_fd, out))
+		return -1;
+	return 0;
+}
+
+/*
+ * Check whether this kernel accounts CFS bandwidth.
+ */
+static bool cgroup_has_bw_stat(int cgroup_fd)
+{
+	char buf[4096];
+
+	if (read_cgroup_file(cgroup_fd, "cpu.stat", buf, sizeof(buf)))
+		return false;
+	return strstr(buf, "nr_periods ");
+}
+
+/* Fork a child that spins in the current cgroup, kill it if the test exits. */
+static pid_t spawn_cpu_hog(void)
+{
+	pid_t pid = fork();
+
+	if (pid == 0) {
+		prctl(PR_SET_PDEATHSIG, SIGKILL);
+		while (1)
+			;
+	}
+	return pid;
+}
+
+void test_cgroup_iter_cpu(void)
+{
+	char *cgroup_rel_path = "/cgroup_iter_cpu_test";
+	struct cgroup_iter_cpu *skel;
+	struct cpu_query *q;
+	struct bpf_link *link;
+	bool wrote_max, have_bw;
+	int cgroup_fd;
+	pid_t hog;
+
+	cgroup_fd = cgroup_setup_and_join(cgroup_rel_path);
+	if (!ASSERT_OK_FD(cgroup_fd, "cgroup_setup_and_join"))
+		return;
+
+	wrote_max = !write_cgroup_file(cgroup_rel_path, "cpu.max", "10000 100000");
+
+	skel = cgroup_iter_cpu__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "cgroup_iter_cpu__open_and_load"))
+		goto cleanup_cgroup_fd;
+
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo = {
+		.cgroup.cgroup_fd = cgroup_fd,
+		.cgroup.order = BPF_CGROUP_ITER_SELF_ONLY,
+	};
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	link = bpf_program__attach_iter(skel->progs.cgroup_cpu_query, &opts);
+	if (!ASSERT_OK_PTR(link, "bpf_program__attach_iter"))
+		goto cleanup_skel;
+
+	q = &skel->data_query->cpu_query;
+
+	hog = spawn_cpu_hog();
+	if (!ASSERT_GT(hog, 0, "spawn_cpu_hog"))
+		goto cleanup_link;
+
+	sleep(1);
+
+	/* Run the bpf program before anything here reads cpu.stat. */
+	if (!ASSERT_OK(read_stats(link), "read stats"))
+		goto cleanup_hog;
+
+	have_bw = wrote_max && cgroup_has_bw_stat(cgroup_fd);
+
+	if (test__start_subtest("cgroup_iter_cpu__cputime")) {
+		ASSERT_GT(q->usage_usec, 0, "usage_usec");
+		ASSERT_GT(q->user_usec + q->system_usec, 0, "user+system_usec");
+	}
+	if (test__start_subtest("cgroup_iter_cpu__throttling")) {
+		if (!have_bw) {
+			test__skip();
+		} else {
+			ASSERT_GT(q->nr_periods, 0, "nr_periods");
+			ASSERT_GT(q->nr_throttled, 0, "nr_throttled");
+			ASSERT_GT(q->throttled_usec, 0, "throttled_usec");
+			ASSERT_GT(q->throttled_self_usec, 0, "throttled_self_usec");
+		}
+	}
+
+	/*
+	 * cpu.stat cputime grows on every tick a task in the cgroup runs, so
+	 * stop them all before comparing
+	 */
+	if (test__start_subtest("cgroup_iter_cpu__match")) {
+		struct cpu_query filev = {};
+		int i, stable = 0;
+
+		kill(hog, SIGSTOP);
+		waitpid(hog, NULL, WUNTRACED);
+		if (!ASSERT_OK(join_root_cgroup(), "join_root_cgroup"))
+			goto cleanup_hog;
+
+		/*
+		 * The period timer keeps adding to nr_periods for a while
+		 * after the hog stops
+		 */
+		for (i = 0; i < 20; i++) {
+			struct cpu_query before = {}, after = {};
+
+			if (!ASSERT_OK(parse_stats(cgroup_fd, &before, have_bw), "cpu.stat") ||
+			    !ASSERT_OK(read_stats(link), "read stats") ||
+			    !ASSERT_OK(parse_stats(cgroup_fd, &after, have_bw), "cpu.stat"))
+				goto cleanup_hog;
+
+			if (!memcmp(&before, &after, sizeof(before))) {
+				filev = before;
+				stable = 1;
+				break;
+			}
+			usleep(100000);
+		}
+
+		if (!ASSERT_TRUE(stable, "cpu.stat stable"))
+			goto cleanup_hog;
+
+		ASSERT_EQ(q->usage_usec, filev.usage_usec, "usage_usec");
+		ASSERT_EQ(q->user_usec, filev.user_usec, "user_usec");
+		ASSERT_EQ(q->system_usec, filev.system_usec, "system_usec");
+		ASSERT_EQ(q->nice_usec, filev.nice_usec, "nice_usec");
+		ASSERT_EQ(q->forceidle_usec, filev.forceidle_usec, "forceidle_usec");
+
+		if (have_bw) {
+			ASSERT_EQ(q->nr_periods, filev.nr_periods, "nr_periods");
+			ASSERT_EQ(q->nr_throttled, filev.nr_throttled, "nr_throttled");
+			ASSERT_EQ(q->throttled_usec, filev.throttled_usec, "throttled_usec");
+			ASSERT_EQ(q->nr_bursts, filev.nr_bursts, "nr_bursts");
+			ASSERT_EQ(q->burst_usec, filev.burst_usec, "burst_usec");
+			ASSERT_EQ(q->throttled_self_usec, filev.throttled_self_usec,
+				  "throttled_self_usec");
+		}
+	}
+
+cleanup_hog:
+	kill(hog, SIGKILL);
+	waitpid(hog, NULL, 0);
+cleanup_link:
+	bpf_link__destroy(link);
+cleanup_skel:
+	cgroup_iter_cpu__destroy(skel);
+cleanup_cgroup_fd:
+	close(cgroup_fd);
+	cleanup_cgroup_environment();
+}
diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c b/tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c
new file mode 100644
index 000000000000..6a288a00c25a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+#include "cgroup_iter_cpu.h"
+
+char _license[] SEC("license") = "GPL";
+
+struct cpu_query cpu_query SEC(".data.query");
+
+SEC("iter.s/cgroup")
+int cgroup_cpu_query(struct bpf_iter__cgroup *ctx)
+{
+	struct cpu_cgroup_cputime ct = {};
+	struct cgroup *cgrp = ctx->cgroup;
+	struct cgroup_subsys_state *css;
+	struct task_group *tg;
+
+	if (!cgrp)
+		return 1;
+
+	bpf_cpu_cgroup_flush_stats(cgrp);
+	bpf_cpu_cgroup_cputime(cgrp, &ct);
+
+	cpu_query.usage_usec = ct.usage_usec;
+	cpu_query.user_usec = ct.user_usec;
+	cpu_query.system_usec = ct.system_usec;
+	cpu_query.nice_usec = ct.nice_usec;
+	cpu_query.forceidle_usec = ct.forceidle_usec;
+
+	bpf_rcu_read_lock();
+	css = cgrp->subsys[cpu_cgrp_id];
+	tg = (struct task_group *)css;
+	if (tg && bpf_core_field_exists(tg->cfs_bandwidth.nr_periods)) {
+		cpu_query.nr_periods =
+			(__u32)BPF_CORE_READ(tg, cfs_bandwidth.nr_periods);
+		cpu_query.nr_throttled =
+			(__u32)BPF_CORE_READ(tg, cfs_bandwidth.nr_throttled);
+		cpu_query.throttled_usec =
+			BPF_CORE_READ(tg, cfs_bandwidth.throttled_time) / 1000;
+		cpu_query.nr_bursts =
+			(__u32)BPF_CORE_READ(tg, cfs_bandwidth.nr_burst);
+		cpu_query.burst_usec =
+			BPF_CORE_READ(tg, cfs_bandwidth.burst_time) / 1000;
+	}
+	bpf_rcu_read_unlock();
+
+	/* a sum over every possible cpu, so the test uses a kfunc */
+	cpu_query.throttled_self_usec = bpf_cpu_cgroup_throttled_self(cgrp);
+
+	return 0;
+}
-- 
2.53.0-Meta

