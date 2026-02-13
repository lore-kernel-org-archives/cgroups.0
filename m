Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68E32D7DDC
	for <cgroups@vger.kernel.org>; Fri, 13 Feb 2026 07:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770967454; cv=none; b=L50g6WVXBYtBBQxGgUM/+kATP4dTe71gBk8d32bew767uZSvzZzB/p6yLwi1yeAALQc1rfjtvTpViJbckwvysIvGTUKcRTe009fUCB393E08aTPTtvULdvLri/7DTFt9HHMUomlKlGb1BXh09VQTZKNx8REX1k3Fze/dAdDTqiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770967454; c=relaxed/simple;
	bh=2HsD6dslEUHwTb02HytZjoVAdwwYRkGD0QIcC0gqh8E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWH5s8+S/de9redbsLUZv6PHnYD7Zhxzlh6BGVqc09gA1JSiyQ1LUVNUzrqi0arRQbMjNlz2TaQGB72a0aDghiWyXW1rnzA90Zh5Q3PiEkGdULUeqw0Hx8uV7F3EZwrf8Rjur2dMKrxoEqLVABNhccYcSL4JQ7wPXJPaeAOcOhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bwmg6GyB; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bwmg6GyB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nAgB8oFd5RIbhmI0zJ6vnRRfguX9/AUjdmRvUVXFkXc=;
	b=Bwmg6GyBinlCH54henK1zV60MzTL0l3tu5CSTyFpVvZxpMIPuMmzpLyguS+1lZAgtfxThx
	ZRYE8Z7/rCz3jQGeSoknWuAxJ+v/PGn0dILItTfznzId6qwBPYUZX05uQ5YyBcDaRfQ8Ss
	HMBzLtIOGY20FvjryGC6Mjg6pUishBw=
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
Subject: [PATCH bpf-next v2 1/3] bpf: Use bpf_core_enum_value for stats in cgroup_iter_memcg
Date: Fri, 13 Feb 2026 15:23:39 +0800
Message-ID: <24ac7bab25d8d2a24a35ab87a5283263eb6a4575.1770965805.git.zhuhui@kylinos.cn>
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

Replace hardcoded enum values with bpf_core_enum_value() calls in
cgroup_iter_memcg test to improve portability across different
kernel versions.

The change adds runtime enum value resolution for:
- node_stat_item: NR_ANON_MAPPED, NR_SHMEM, NR_FILE_PAGES,
  NR_FILE_MAPPED
- memcg_stat_item: MEMCG_KMEM
- vm_event_item: PGFAULT

This ensures the BPF program can adapt to enum value changes
between kernel versions, returning early if any enum value is
unavailable (returns 0).

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../selftests/bpf/progs/cgroup_iter_memcg.c   | 41 +++++++++++++++----
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
index 59fb70a3cc50..b020951dd7e6 100644
--- a/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
+++ b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
@@ -15,6 +15,8 @@ int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
 	struct cgroup *cgrp = ctx->cgroup;
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg;
+	int ret = 1;
+	int idx;
 
 	if (!cgrp)
 		return 1;
@@ -26,14 +28,39 @@ int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
 
 	bpf_mem_cgroup_flush_stats(memcg);
 
-	memcg_query.nr_anon_mapped = bpf_mem_cgroup_page_state(memcg, NR_ANON_MAPPED);
-	memcg_query.nr_shmem = bpf_mem_cgroup_page_state(memcg, NR_SHMEM);
-	memcg_query.nr_file_pages = bpf_mem_cgroup_page_state(memcg, NR_FILE_PAGES);
-	memcg_query.nr_file_mapped = bpf_mem_cgroup_page_state(memcg, NR_FILE_MAPPED);
-	memcg_query.memcg_kmem = bpf_mem_cgroup_page_state(memcg, MEMCG_KMEM);
-	memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, PGFAULT);
+	idx = bpf_core_enum_value(enum node_stat_item, NR_ANON_MAPPED);
+	if (idx == 0)
+		goto out;
+	memcg_query.nr_anon_mapped = bpf_mem_cgroup_page_state(memcg, idx);
 
+	idx = bpf_core_enum_value(enum node_stat_item, NR_SHMEM);
+	if (idx == 0)
+		goto out;
+	memcg_query.nr_shmem = bpf_mem_cgroup_page_state(memcg, idx);
+
+	idx = bpf_core_enum_value(enum node_stat_item, NR_FILE_PAGES);
+	if (idx == 0)
+		goto out;
+	memcg_query.nr_file_pages = bpf_mem_cgroup_page_state(memcg, idx);
+
+	idx = bpf_core_enum_value(enum node_stat_item, NR_FILE_MAPPED);
+	if (idx == 0)
+		goto out;
+	memcg_query.nr_file_mapped = bpf_mem_cgroup_page_state(memcg, idx);
+
+	idx = bpf_core_enum_value(enum memcg_stat_item, MEMCG_KMEM);
+	if (idx == 0)
+		goto out;
+	memcg_query.memcg_kmem = bpf_mem_cgroup_page_state(memcg, idx);
+
+	idx = bpf_core_enum_value(enum vm_event_item, PGFAULT);
+	if (idx == 0)
+		goto out;
+	memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, idx);
+
+	ret = 0;
+out:
 	bpf_put_mem_cgroup(memcg);
 
-	return 0;
+	return ret;
 }
-- 
2.43.0

