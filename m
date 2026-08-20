Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE9648551E
	for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 21:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787260693; cv=none; b=LmFcqAxvPWs8I6+aQhcY/rYLJTTc2GnMd4tm2OEcthTPQCv/XBz8QMWmxiYEsheNDGYMocVNjJJe8v0Lig5glc/Q3evtOtZRxkxgEeE6nE3d1pfB+l9DO8tOogJHD3yRTvYYS5LEmYjK8emwH4+485NKAWagwiuDr7wxCxwuDMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787260693; c=relaxed/simple;
	bh=OJSpf69yMcsfGIyak4mMels4G2wsnfckBxcquoS3tvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0toSR0GSvntnlMcl9MvpZiDl6J07fhPYEnTAp3BlraTGGKDSCSlufsNrZYle99s2k0VsyeY0mr1RIpov/r5mfWIk5IjsqZIDVpkpz4OtrXptT8qdEA09sPMpZ5Lcd4TNbMrPtbzK7Mf30GMLeWD6ifmEua0cCdJ98oI/UvDjOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aTiCEloJ; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aTiCEloJ"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cb5b8572b70so404449a12.2
        for <cgroups@vger.kernel.org>; Thu, 20 Aug 2026 14:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787260685; x=1787865485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=si8wyumoq2U2f4OwgM7HXzPkBFFrINH56EYQucTf6UU=;
        b=aTiCEloJfUL19anIQoysndVlNACXvFQ7bLbZDTIqCENAihLneesxO5x0U2dhVqIWmO
         iw/Jb93aJEHauKy+oLgQneSyONL4svUbByBxlEaJnOViSiIdVUEk5gInBdmY7wWjl0vT
         HyQkL+aVsFU6MaF8h6F/anXaU+mY09leGh6DCwNyYVrgIXjfWVDvQbiZmZSizy7Xo+UB
         g5h3w45PWhhIemE+rMOaWdBhChR9dmY0DEWkw/A9K2eK2dpsG6yEAWIZZxgCTxSvsFmf
         Mx/Ri+Q4eRR91BUdymWaV7snIRjI4fYuP/5GIArJyaa+dZ5u0U+YA9Jf14Q2rQUHKy84
         7DvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787260685; x=1787865485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=si8wyumoq2U2f4OwgM7HXzPkBFFrINH56EYQucTf6UU=;
        b=loksRiU+Cb/2Py9JSp53a+m9cknhf5bFhzmBsBESBAhqJwNYoAFVueEZ4nkLU6nMOD
         rOivfZT73f8QpPUpJnHmNxdi8+y5pXFvBtfFSqy70kBltPFcbONICzjyaoUr/HHfmxLu
         5D5ueaFu6KHOm9zz+kjZclR1LpgOFGnKgwfGRkWZ7oe7DOQGP1s/xqjfDnaxAvNR4kkq
         qlRZNv3ZkhrT/dNAgXMXJfUCLloRPgKN/fxucnYTvn0FHdV6Bgx6zoUiqvPhHEYmQcn7
         ZJgw1uInFZQd0vQTb8BHOFWSOl02sdDq+LI8F+EJ2GiWmfW+RpW6n1mcy5TV3AGhNYWS
         +OxQ==
X-Forwarded-Encrypted: i=1; AHgh+RooywA4eh7pmr2Bl8NYOJhzFn3bcAAj4nJJDLOJeUlNVzRFJkN/FW1Nu+EfICiI1lCPeL4e2b+d@vger.kernel.org
X-Gm-Message-State: AOJu0YzajBteGK8KXfJQpe6M3QGt3m24PVuc3aCKv/NUaYFzMas1jNwr
	2jfXFCmTGy+TjLth+qG8Rvwicwp8NBvQY5qbnesRYP2Q0V7okAHWOD9d
X-Gm-Gg: AR+sD13uhgBokMRPyIGqGmMhyL1kVjsL7U1gtli19quqvuXXbo3sholf/qURWca2BvP
	7PB/V528gjcZm0xSfSNWuEwW1KW5QApstyT1HP5ETP1oTq1skqducmX4LDWW5Vt+IeWVIj2fjXQ
	Gnqe6SCWwIzgcPJuC8WXJfelGyZq2lUFGw3wyYkP85H3k/XM4+xP1qcRamAFPKScU6i4IeQLDuJ
	Fv+cAGuJUClIpij33oM4BrZDABx/esEvYhYdAhuLzqtolslvSFGPY1uaRp6qsK36SQDdta5sslZ
	TxpBs6L9mFLkwRwInMrRJv/HS0PH33DT8QSWzwmG/PWJYQuH7ZOCetCe8UGXAKLL/f8Ha0GbuI1
	6xTxRYZUkPHjww2wboO65+CLrYEPw9nzMqDjP7Vp7Xf4llMITQkdUnYzPUj3XazlPTUw1Jg0nv3
	Gc77tnuYOD0ixfcZee0Iaz2AUFHsSxrZuLT5SZneQBjp/CkiKDs74hsHiL9xu3reEpUA==
X-Received: by 2002:a05:6a21:790:b0:3c3:7ac4:dac0 with SMTP id adf61e73a8af0-3cd300d467dmr2643686637.13.1787260684565;
        Thu, 20 Aug 2026 14:18:04 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:40::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ae1416dsm26285932c88.11.2026.08.20.14.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 14:18:04 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: kernel-team@meta.com,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Ben Segall <bsegall@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Ziyang Men <ziyang.meme@gmail.com>,
	linux-block@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] selftests/bpf: add cgroup_iter_cpu test for cpu cgroup kfuncs
Date: Thu, 20 Aug 2026 14:17:56 -0700
Message-ID: <20260820211758.3393984-3-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260820211758.3393984-1-ziyang.meme@gmail.com>
References: <20260820211758.3393984-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add cgroup_iter_cpu, a selftest for the CPU controller BPF kfuncs.

The userspace side runs a CPU hog in a test cgroup with cpu.max settled
then:

  - checks the CPU-time and throttling counters are nonzero,
  - compares whether all values the program read are same as those
    reading from cgroup file.

Enable CONFIG_CGROUP_SCHED, CONFIG_FAIR_GROUP_SCHED and
CONFIG_CFS_BANDWIDTH in the selftest config.

Tested on VM with v7.2-rc5.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/bpf/cgroup_iter_cpu.h |  22 ++
 tools/testing/selftests/bpf/config            |   3 +
 .../bpf/prog_tests/cgroup_iter_cpu.c          | 259 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_cpu.c     | 113 ++++++++
 4 files changed, 397 insertions(+)
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
index 000000000000..0e916234e7eb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_cpu.c
@@ -0,0 +1,113 @@
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
+extern const void __cpu_possible_mask __ksym;
+
+struct cgroup_base_stat___local {
+	struct task_cputime cputime;
+	__u64 forceidle_sum;
+	__u64 ntime;
+} __attribute__((preserve_access_index));
+
+static __always_inline __u64 read_throttled_self(struct task_group *tg, __u32 cpu)
+{
+	struct cfs_rq *cfs_rq;
+
+	cfs_rq = bpf_per_cpu_ptr(tg->cfs_rq, cpu);
+	if (!cfs_rq)
+		return 0;
+
+	return BPF_CORE_READ(cfs_rq, throttled_clock_self_time);
+}
+
+SEC("iter.s/cgroup")
+int cgroup_cpu_query(struct bpf_iter__cgroup *ctx)
+{
+	struct cgroup_base_stat___local bstat = {};
+	struct cgroup *cgrp = ctx->cgroup;
+	struct cgroup_subsys_state *css;
+	struct task_group *tg;
+	__u64 throttled_self = 0;
+	int ssid;
+
+	if (!cgrp)
+		return 1;
+
+	css_rstat_flush(&cgrp->self);
+	bpf_cgroup_base_stat(cgrp, (struct cgroup_base_stat *)&bstat);
+
+	cpu_query.usage_usec = bstat.cputime.sum_exec_runtime / 1000;
+	cpu_query.user_usec = bstat.cputime.utime / 1000;
+	cpu_query.system_usec = bstat.cputime.stime / 1000;
+	cpu_query.nice_usec = bstat.ntime / 1000;
+	cpu_query.forceidle_usec = 0;
+	if (bpf_core_field_exists(bstat.forceidle_sum))
+		cpu_query.forceidle_usec = bstat.forceidle_sum / 1000;
+
+	bpf_rcu_read_lock();
+	if (!bpf_core_enum_value_exists(enum cgroup_subsys_id, cpu_cgrp_id) ||
+	    !bpf_ksym_exists(bpf_css_to_task_group))
+		goto unlock;
+
+	ssid = bpf_core_enum_value(enum cgroup_subsys_id, cpu_cgrp_id);
+	css = cgrp->subsys[ssid];
+	if (!css)
+		goto unlock;
+
+	tg = bpf_css_to_task_group(css);
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
+
+	if (tg && bpf_core_field_exists(tg->cfs_rq) &&
+	    bpf_core_field_exists(struct cfs_rq, throttled_clock_self_time)) {
+		__u32 mask_bytes = bpf_core_type_size(struct cpumask);
+		__u32 full_words = mask_bytes / sizeof(__u64);
+		int *cpu;
+
+		if (full_words)
+			bpf_for_each(bits, cpu,
+				     (const __u64 *)&__cpu_possible_mask,
+				     full_words)
+				throttled_self += read_throttled_self(tg, *cpu);
+
+		if (mask_bytes & (sizeof(__u64) - 1)) {
+			__u32 tail = 0;
+			const void *src = (const char *)&__cpu_possible_mask +
+					  full_words * sizeof(__u64);
+			int bit;
+
+			if (!bpf_probe_read_kernel(&tail, sizeof(tail), src))
+				bpf_for(bit, 0, 32)
+					if (tail & (1U << bit)) {
+						__u32 tail_cpu = full_words * 64 + bit;
+
+						throttled_self +=
+							read_throttled_self(tg, tail_cpu);
+					}
+		}
+	}
+
+unlock:
+	bpf_rcu_read_unlock();
+	cpu_query.throttled_self_usec = throttled_self / 1000;
+
+	return 0;
+}
-- 
2.53.0-Meta

