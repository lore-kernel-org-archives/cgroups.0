Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281424;
	b=hPl4TTAbyxdaCROmlCZCKmx2HWVusggGLgjfX+q9T2kEGZHvGraK/G/Oj2vbLBmeQiD/
	 xiM2g0+a3ad9xNy5jPrzZYRTXazeXzzXdnz5Iec/Qboko1Y/CCvPAEn7k1C6JMMeB5mst
	 iwUoNJUTUkNxs8XR7w76WUEFejS1Tfcl0c7E5qPtSqtB6AvZ8ysWP19ZMnOTk85Fc68Og
	 Nq64JQqgLiVb9NKel5Ge/Z9rqRiTtvmQEJzvDNdOo4GqQRaIqE74IBwLid/9dZIsSy2oN
	 C57EqjfDf/ra+I7Sg+NHsT56toHLTun0rsTd5z+/+L0AvI0ZXZTbFevmiuxW9rOsWQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281424;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gxdjfkE2u6hMgUrERKs9IK41dx8VvemjPSvlkCJqFUU=;
	b=Xcg2a+2ocnW8cHPsd3hZYVLh7NnaNJ5bTWJDFWy8YnFwGZchh6YJtBBEwR5DFHgXQbgy
	 ftRePCAzqnDY7ReTFA+gzNhIK+/WIn0HTjXVxmwjFEYp2nAgFE4ppWOhgk8JC0ln9zyKs
	 Y27iLdpmFtHKWUFdalAQrJtmzqgTW8s+wugqsvVbnzQKKZWo83NYRObWpc9HKj8G9hr07
	 4j4jL5HAt0cHWrHjZ5RV2R2Z57hVF+Bl1gLcI3VzQRpxGzhSUiKhAYY6ATMfN3ZH5IOPE
	 WnA5dpyLWEWnEooJybhXwFssL+D+L9wfncCaggxphl7t638m5XOp4VgvFAStPAappCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AtTkhZae;
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E5D606A31C
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 03:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0E5D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AtTkhZae
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cc758830601so993524a12.2
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 19:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794281423; x=1794886223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gxdjfkE2u6hMgUrERKs9IK41dx8VvemjPSvlkCJqFUU=;
        b=AtTkhZaeU4hUtuGnRtS0F/N3iO+1WlWiKDM4IHXPrTmT37Z72Qbpkeu80eTmvSZz1x
         AOiLkMjr9VvaO6BXCIp6zPi09rXrwfIlg6eUx9QNDXS94b9GRPE5nJeUg+U04ltfJegk
         NeJPojTsts2wX0CGibfvU4BXioqxU9amayLrlaUZ3DNU3T2PvSfZoMADJMfLW72c+weH
         mid1sbiKiU3UFS1h35zuS6M09zx4cyWj4tiNUioRG4LWjWPehHSzU8X48KZUY8Vod05f
         +rYgjcYRO6VyDI/9dzqrSiXq51iiV1YIqefrLkeCvnthY7SMT/Sb/JNek/ZQMxEheQk8
         /lDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794281423; x=1794886223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gxdjfkE2u6hMgUrERKs9IK41dx8VvemjPSvlkCJqFUU=;
        b=mBevpvaJm7o82vF9V+L0kWzfOIlFaJr28S429wQiOigbLebiJq7p2rAKgf9k2BcjgB
         /RrjMH8ZtDcTZGK/I4lLKb6RWqnXzHjwrl1v2zm54+li0y8CqNGzXzktBdgMtIj5N85H
         saHUdlW1zDDqevgshToc9V1/j+O0xQ/WyH/KJXXE9WQsZxjsYU63PiWwBcNpQJODA/qC
         /Gnt+xELtNFbtXBqW9PC35ytkEf+XkC6lMzQG9cQu+lembvq/ovEYxwB6dRDm6VW+r07
         MTp0HFCFzx5Hec72+602fDJ9g9sDa2SR9GyptsGDDN+HuVLKyH92XxywC0i5dYvf/kWI
         U1pQ==
X-Forwarded-Encrypted: i=1; AL+hErHgEApvAfKhTt0VRe4lk2SoVnpm3qMJwb+hCgQylWCyYHOhlaSj1ZqYgRBTdh2c7QnbtOYWUm6c@vger.kernel.org
X-Gm-Message-State: APuU4Z/qalhkV7BWNuAIA4AGht+BwWRDSaolIP7t+wVVajhT6aWcAULY
	JkmtL/Cx2OhNBqBHGxdbs866ZTSu4VXjTZcq7Zx3NZMFuiI2PpoRIJz+
X-Gm-Gg: AYBFou2TuQ6X8C90H2SC1qaPA3zrwal9Ux6r68Hz3hY/TkrvasQ/3b3D8gi1gUtebqR
	vdtrxuvUqtYtUZh4ZODbNJlUOIsQ1NelzJAJLmBBS7oToWL6bV9uswbE7xV9BuPFHKh6ZyPaz3L
	1whLI9qt9PES8rL/Fxk+wpJwekoSH4h4YmiGxY1ZCyu9oOnp0KCvlyr4ea2Tu83FBMdgq8rkida
	/ESufleGVISpRPNcEsEF89ziJFTDmT29DVIMWpGnPi5k/MoG2STVlpeUVMmNalmqhWzcZAblp8p
	0bC1wrRwus5TfGCTGJLtHaFcq1OJ30zskhasabolcw1/hQNtZ5D3hDjctbgzLPMdj+sypcMzGxO
	d22xMZgm970DW1mo5uH/Iuw+MZPN62sAUEXqbDQBHZBq52HkhjN4ntfap+eKgTYPL9WqLX9dKgf
	VSUJgzkjfMphRuIGKC/+IP88jdxK1nXukHY5N7U3W44YGoZE8akYwboNV/HcqtL3PukCeFzcMsy
	KNqsqkBJw1zFeauAdg8WOAzLr8qTVs5eiGbBwJc3GT/r4ekwSqkIGBFGfr9xJLyLHTVUK9F4XrL
	mGEI8LeJ+tk6TXHcibiVqKByKuxyUxH0bk+Yn6X/gTqxiT8MgkXV+Klzl+KVuptMD5YsOxioYp/
	nhkFDssCtP51RM+hsy5rZ0szq
X-Received: by 2002:a05:6a21:2013:b0:3e2:a9cc:3ece with SMTP id adf61e73a8af0-3f18e8c5cb6mr1040170637.23.1794281423096;
        Mon, 09 Nov 2026 19:30:23 -0800 (PST)
Received: from localhost.localdomain ([240e:46d:1d00:5ed4:58d0:d294:d44c:6ae8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm336973b3a.42.2026.11.09.19.30.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:30:22 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com,
	ziy@nvidia.com,
	mgorman@suse.de
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next v4 4/4] selftests/bpf: add tests for the numab kfuncs
Date: Tue, 10 Nov 2026 11:29:13 +0800
Message-ID: <20261110032913.71974-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Exercise the bpf_numab_set_mode() and bpf_numab_get_mode() kfuncs
through BPF_PROG_TYPE_SYSCALL programs: the set/get roundtrip, the
mode domain (NUMAB_FOLLOW_SYSTEM and the NUMA_BALANCING_* bitmasks
accepted, anything else rejected with -EINVAL), unknown cgroup ids
rejected with -ENOENT, and the hierarchy combination the memcg walk
produces (inheritance, OR-ing, and an opt-out winning over every
request in the chain). Also verify the memory-controller requirement:
setting on a cgroup without a memcg is rejected with -EOPNOTSUPP,
while bpf_numab_get_mode() resolves it to the nearest ancestor memcg.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/bpf_numab.c      | 273 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_numab.c |  32 ++
 3 files changed, 307 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 49dfe939467c..e56c8872e51a 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -7,6 +7,7 @@ CONFIG_BPF_JIT=y
 CONFIG_BPF_KPROBE_OVERRIDE=y
 CONFIG_BPF_LIRC_MODE2=y
 CONFIG_BPF_LSM=y
+CONFIG_BPF_NUMAB=y
 CONFIG_BPF_STREAM_PARSER=y
 CONFIG_BPF_SYSCALL=y
 # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
@@ -78,6 +79,7 @@ CONFIG_NET_CLS_FLOWER=y
 CONFIG_NET_CLS_MATCHALL=y
 CONFIG_NET_FOU=y
 CONFIG_NET_FOU_IP_TUNNELS=y
+CONFIG_NUMA_BALANCING=y
 CONFIG_NET_IPGRE=y
 CONFIG_NET_IPGRE_DEMUX=y
 CONFIG_NET_IPIP=y
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_numab.c b/tools/testing/selftests/bpf/prog_tests/bpf_numab.c
new file mode 100644
index 000000000000..6fb6a4d9f291
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_numab.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "bpf_numab.skel.h"
+
+#define CGROUP_PATH	"/bpf_numab"
+#define CHILD_PATH	CGROUP_PATH "/child"
+#define HIER_PATH	"/bpf_numab_hier"
+#define HIER_CHILD_PATH	HIER_PATH "/child"
+#define NOMEM_PATH	"/bpf_numab_nomem"
+#define NOMEM_CHILD_PATH NOMEM_PATH "/child"
+
+/* The per-cgroup request domain, mirroring the kernel constants. */
+#define NUMAB_FOLLOW_SYSTEM	(-1)
+#define NUMAB_DISABLED		0
+#define NUMAB_NORMAL		1
+#define NUMAB_TIERING		2
+#define NUMAB_NORMAL_TIERING	3
+
+static int numab_set(struct bpf_numab *skel, u64 cgid,
+		     long mode)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
+	int ret;
+
+	skel->bss->set_cgid = cgid;
+	skel->bss->set_mode = mode;
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.numab_set),
+				     &opts);
+	if (!ASSERT_OK(ret, "set run"))
+		return -1;
+	return skel->bss->set_ret;
+}
+
+static long numab_get(struct bpf_numab *skel, u64 cgid)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
+	int ret;
+
+	skel->bss->get_cgid = cgid;
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.numab_get),
+				     &opts);
+	if (!ASSERT_OK(ret, "get run"))
+		return -EIO;
+	return skel->bss->get_mode;
+}
+
+static void test_set_get(void)
+{
+	struct bpf_numab *skel;
+	int cgroup_fd;
+	u64 cgid;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	cgid = get_cgroup_id(CGROUP_PATH);
+	if (!ASSERT_GT(cgid, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_NORMAL), 0, "set normal");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_NORMAL, "get normal");
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_TIERING), 0, "set tiering");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_TIERING, "get tiering");
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_NORMAL_TIERING), 0, "set both");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_NORMAL_TIERING, "get both");
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_DISABLED), 0, "set disabled");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_DISABLED, "get disabled");
+
+	/* Back to the system setting. */
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_FOLLOW_SYSTEM), 0, "unset");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_FOLLOW_SYSTEM, "get unset");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(cgroup_fd);
+}
+
+static void test_invalid_mode(void)
+{
+	struct bpf_numab *skel;
+	int cgroup_fd;
+	u64 cgid;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	cgid = get_cgroup_id(CGROUP_PATH);
+	if (!ASSERT_GT(cgid, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	ASSERT_EQ(numab_set(skel, cgid, -2), -EINVAL, "set below domain");
+	ASSERT_EQ(numab_set(skel, cgid, 4), -EINVAL, "set above domain");
+	ASSERT_EQ(numab_set(skel, cgid, 0x1000), -EINVAL, "set far above");
+
+	/* The rejected requests must not have stuck. */
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_FOLLOW_SYSTEM, "get unchanged");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(cgroup_fd);
+}
+
+static void test_bad_cgid(void)
+{
+	struct bpf_numab *skel;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	ASSERT_EQ(numab_set(skel, 0, NUMAB_NORMAL), -ENOENT, "set cgid 0");
+	ASSERT_EQ(numab_get(skel, 0), -ENOENT, "get cgid 0");
+	ASSERT_EQ(numab_set(skel, 0xdeadbeef, NUMAB_NORMAL), -ENOENT,
+		  "set bad cgid");
+	ASSERT_EQ(numab_get(skel, 0xdeadbeef), -ENOENT, "get bad cgid");
+
+	bpf_numab__destroy(skel);
+}
+
+static void test_hierarchy(void)
+{
+	u64 parent_cgid, child_cgid;
+	int runner_fd, parent_fd, child_fd;
+	struct bpf_numab *skel;
+
+	runner_fd = test__join_cgroup("/bpf_numab_runner");
+	if (!ASSERT_GE(runner_fd, 0, "join_runner_cgroup"))
+		return;
+
+	parent_fd = create_and_get_cgroup(HIER_PATH);
+	if (!ASSERT_GE(parent_fd, 0, "create_parent_cgroup"))
+		goto cleanup_runner;
+
+	if (!ASSERT_OK(enable_controllers(HIER_PATH, "memory"),
+		       "enable_memory_controller"))
+		goto cleanup_parent;
+
+	child_fd = create_and_get_cgroup(HIER_CHILD_PATH);
+	if (!ASSERT_GE(child_fd, 0, "create_child_cgroup"))
+		goto cleanup_parent;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	parent_cgid = get_cgroup_id(HIER_PATH);
+	child_cgid = get_cgroup_id(HIER_CHILD_PATH);
+	if (!ASSERT_GT(parent_cgid, 0, "get_parent_cgid") ||
+	    !ASSERT_GT(child_cgid, 0, "get_child_cgid"))
+		goto cleanup;
+
+	/* The child inherits an ancestor's request untouched. */
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_TIERING), 0,
+		  "set parent tiering");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_TIERING,
+		  "child inherits");
+
+	/* A request ORs with the ancestor's; NORMAL does not undo TIERING. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_NORMAL), 0,
+		  "set child normal");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_NORMAL_TIERING,
+		  "or both");
+
+	/* The child's own opt-out wins. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_DISABLED), 0,
+		  "set child disabled");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_DISABLED,
+		  "own opt-out wins");
+
+	/* So does an ancestor's: a task is never forced into balancing. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_TIERING), 0,
+		  "set child tiering");
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_DISABLED), 0,
+		  "set parent disabled");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_DISABLED,
+		  "ancestor opt-out wins");
+
+	/* Unsetting the parent re-exposes the child's own request. */
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_FOLLOW_SYSTEM), 0,
+		  "unset parent");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_TIERING,
+		  "child request again");
+
+	/* Unsetting the child leaves the chain with no request. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_FOLLOW_SYSTEM), 0,
+		  "unset child");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_FOLLOW_SYSTEM,
+		  "no request");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(child_fd);
+	remove_cgroup(HIER_CHILD_PATH);
+cleanup_parent:
+	close(parent_fd);
+	remove_cgroup(HIER_PATH);
+cleanup_runner:
+	close(runner_fd);
+}
+
+static void test_no_memcg(void)
+{
+	struct bpf_numab *skel;
+	int parent_fd, child_fd;
+	u64 parent_cgid, child_cgid;
+
+	parent_fd = test__join_cgroup(NOMEM_PATH);
+	if (!ASSERT_GE(parent_fd, 0, "join_nomem_parent"))
+		return;
+
+	child_fd = create_and_get_cgroup(NOMEM_CHILD_PATH);
+	if (!ASSERT_GE(child_fd, 0, "create_nomem_child"))
+		goto cleanup_parent;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	parent_cgid = get_cgroup_id(NOMEM_PATH);
+	child_cgid = get_cgroup_id(NOMEM_CHILD_PATH);
+	if (!ASSERT_GT(parent_cgid, 0, "get_nomem_parent_cgid") ||
+	    !ASSERT_GT(child_cgid, 0, "get_nomem_child_cgid"))
+		goto cleanup;
+
+	/*
+	 * The parent has a memcg; the child was created without enabling
+	 * the memory controller in the parent's subtree, so it has none.
+	 */
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_NORMAL), 0,
+		  "set parent normal");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_NORMAL,
+		  "child resolves to parent memcg");
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_TIERING), -EOPNOTSUPP,
+		  "child set rejected");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_NORMAL,
+		  "child get unchanged");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(child_fd);
+	remove_cgroup(NOMEM_CHILD_PATH);
+cleanup_parent:
+	close(parent_fd);
+}
+
+void test_bpf_numab(void)
+{
+	if (test__start_subtest("set_get"))
+		test_set_get();
+	if (test__start_subtest("invalid_mode"))
+		test_invalid_mode();
+	if (test__start_subtest("bad_cgid"))
+		test_bad_cgid();
+	if (test__start_subtest("hierarchy"))
+		test_hierarchy();
+	if (test__start_subtest("no_memcg"))
+		test_no_memcg();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_numab.c b/tools/testing/selftests/bpf/progs/bpf_numab.c
new file mode 100644
index 000000000000..25da97bce82f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_numab.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+/* Inputs, set from userspace before each run. */
+u64 set_cgid;
+long set_mode;
+u64 get_cgid;
+
+/* Results, read back after each run. */
+long set_ret;
+long get_mode;
+
+extern int bpf_numab_set_mode(u64 cgid, enum numab_mode mode) __ksym;
+extern s64 bpf_numab_get_mode(u64 cgid) __ksym;
+
+SEC("syscall")
+int numab_set(void *ctx)
+{
+	set_ret = bpf_numab_set_mode(set_cgid, (enum numab_mode)set_mode);
+	return 0;
+}
+
+SEC("syscall")
+int numab_get(void *ctx)
+{
+	get_mode = bpf_numab_get_mode(get_cgid);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.52.0

