Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393A613B58C
	for <cgroups@vger.kernel.org>; Thu, 12 Feb 2026 08:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770884646; cv=none; b=EzPksiwwzpWtxn5lO83R3vBwiyBNgoHTgWyfVQrDQeEG0w5iX8IKwdkPn3b4/z7YzmRiS7SA8OUaXaGw4z0uiNydnOHCtX/UeFRCFlII0ZNUHWm7BYz1uYnn2rlQB1T9BUGrqY4uB70BNVLl18DE6BOHYWQcbfa0dzz03PR3aGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770884646; c=relaxed/simple;
	bh=Yw/U2u1kO0ZIn9Mc2bMQ0zLjlvy7XjdcIIQ7GR3MAd4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlXqiaZq2HzeE+wqENaLTQXCW14H06XyLjd/GXhj2Xq8tCu8hVJyxCaD1SSC9Pc8jELuxpNgSdjn2NpgPON8hYpTu2iW0W/cC2ddTbThq48lZ3YpUuRrlGanNkyoOMqig4u+t/7N4vH6lJqnODzRv0BwPhjX0vm4AhMxU92ncKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mtLG1Cj7; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mtLG1Cj7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770884643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qa7yRxcpGL3PnKF4R1l2meMqj6ZYK13/0dyEKREpmhI=;
	b=mtLG1Cj7F/NN0pQvl1k5tAmMqtzQ0Q7TM4SCVi9GMjgpIDSLSvRuNgxNUBKEWiMccVbj7z
	K8W4rDks82e97Z8KcgkhM8a3y1wY/HTQgqGjhSAkMrndvzi66dbkI4Pxi7c8hQrM0ljZR8
	mAMheL03KE5ojdB75JZXNKsapNcnw0A=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Hui Zhu <zhuhui@kylinos.cn>,
	JP Kobryn <inwardvessel@gmail.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 3/3] selftests/bpf: Skip test_kmem when cgroup.memory=nokmem
Date: Thu, 12 Feb 2026 16:23:16 +0800
Message-ID: <2f6ee1db173b67a636b2caa85744cb4ce8114e64.1770883926.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770883926.git.zhuhui@kylinos.cn>
References: <cover.1770883926.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hui Zhu <zhuhui@kylinos.cn>

When cgroup.memory=nokmem is set in kernel command line, kmem
accounting is disabled and the test_kmem subtest will fail.

Add a check to skip this test when the parameter is present.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
index 13b299512429..203e6b091a21 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
@@ -134,11 +134,39 @@ static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
 	shm_unlink("/tmp_shmem");
 }
 
+static bool cmdline_has(const char *arg)
+{
+	char cmdline[4096];
+	int fd;
+	ssize_t len;
+	bool ret = false;
+
+	fd = open("/proc/cmdline", O_RDONLY);
+	if (fd < 0)
+		return false;
+
+	len = read(fd, cmdline, sizeof(cmdline) - 1);
+	close(fd);
+	if (len < 0)
+		return false;
+
+	cmdline[len] = '\0';
+	if (strstr(cmdline, arg))
+		ret = true;
+
+	return ret;
+}
+
 #define NR_PIPES 64
 static void test_kmem(struct bpf_link *link, struct memcg_query *memcg_query)
 {
 	int fds[NR_PIPES][2], i;
 
+	if (cmdline_has("cgroup.memory=nokmem")) {
+		test__skip();
+		return;
+	}
+
 	/*
 	 * Increase kmem value by creating pipes which will allocate some
 	 * kernel buffers.
-- 
2.43.0

