Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204EC2D7DD3;
	Fri, 13 Feb 2026 07:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770967463; cv=none; b=SBDkS6RjbpRpNDfhPSJK6YZeLWWuY6ljUYvxRZeHoosmCcQ4keYpFb6Eu1Fk6n5/mCeaBzyxyOzhYXdPuJ7B0IyWnT82GsQdDfIGs0IVtqzndPjbgeairExo4BXrYQs/10YwbwG6qEMoQfsETObHWRKOwfLbc1+iiE/A6S35Z6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770967463; c=relaxed/simple;
	bh=/y1+LlZYtoPLhLVI3OIgJxxN7FJlVk5SJJIQ0nJt5eg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxb0EFb8gELCIBZGrJRKY4u5R0KOS96HwSec6P4Pmh0gG53spS+dXHrLiY3d+y4uJM44y8siyajJ3EHMp/PiVkuz/AjGxA0qPTcOlRk3Ig+FZX4LzFfpKvC8NNTpfNUxvzoJGtlxljH4v0G+0IxRa01JIlEfMQ3DEnT4/ZadfpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AxOI7my/; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AxOI7my/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E55JfgQKp+ZEiIAnBu3r9GQXW9g+xnXnuS4C381ry3Y=;
	b=AxOI7my/78Mr4e23DAMG8qSm8RywqTJoU/wugb08PyinUbE2c+4BRDnDNkUbmTScXCCZBZ
	hBlp4yETtJ+NjBdDb+TczClhFhU6q1d8Ub0jqbhpQLyaIC9CxgzlOwAhiaPifXtNr33Zye
	CeoaKYGftGe+eQ3I9FNd48m6bPHv0Xg=
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
Subject: [PATCH bpf-next v2 3/3] bpf: selftests: Skip kmem test when cgroup.memory=nokmem is set
Date: Fri, 13 Feb 2026 15:23:41 +0800
Message-ID: <447797edc394ab8a8b2484bb6c92b56115254e27.1770965805.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770965805.git.zhuhui@kylinos.cn>
References: <cover.1770965805.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hui Zhu <zhuhui@kylinos.cn>

When cgroup.memory=nokmem is set in the kernel command line, kmem
accounting is disabled. This causes the test_kmem subtest in
cgroup_iter_memcg to fail because it expects non-zero kmem values.

Fix this by checking /proc/cmdline for the nokmem parameter. If
found, verify that kmem value is zero and return early, skipping
the pipe creation test that would otherwise fail.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
index 897b17b58df3..2b9c148cebf0 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
@@ -134,11 +134,41 @@ static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
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
+		if (!ASSERT_OK(read_stats(link), "read stats"))
+			return;
+		ASSERT_EQ(memcg_query->memcg_kmem, 0, "kmem value");
+		return;
+	}
+
 	/*
 	 * Increase kmem value by creating pipes which will allocate some
 	 * kernel buffers.
-- 
2.43.0

