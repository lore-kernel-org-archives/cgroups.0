Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A542D7DD3
	for <cgroups@vger.kernel.org>; Fri, 13 Feb 2026 07:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770967458; cv=none; b=Y2Wsr2DtiVxA5RcjXazedO8OYXJutwazN4qmInPXOq5JUlELY84FMziPHj0asCMGrBXreZjuK1AhFvVrcGuZfalwlzNVZoiecCYh8PIrjpSUPRsnL5/jGfXZRJf4Ij4O2hNDsRkf+OMQ6pRO3hxfyns6gF0OKeADJP+G9pzOSZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770967458; c=relaxed/simple;
	bh=Iuf/jG1P1xgDjqZYNlxi2enRJMWQkBrEDPdJgXR1x88=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hx3Ewy4Q43C7nwCHEB7BVdutHm02hr/AjezI62z9NU0K4hqPVxfhHFrS9jVoXogIHpCk49fY1BFfAXd+caOrgk0ChZf00e/gKYVEMCrKjCcp8LRPIxTU4Jjo5f8Dhy4bUotrYchYY2Do7+UWt5Pc+DbiwNykNBVhkueUby8kdXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cc3fpTVf; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cc3fpTVf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HW+lAdpZxdJcNgAcGUXKCZ/ga5dHaGdja+4OcUdB4U4=;
	b=cc3fpTVfk4UjRwRea3SPdpj0kMzH1jIgL2ZENeZFz4l/ch+kXyBmx4iuQ6GHsvobdljBxm
	Zjd3mc9KkrGsTIZwIDoqz4fE63dyYV5bc5DJZFI87FljWPb7n7Gza8GpxVzbE3/jZb23Yg
	ia+RRy9hEvB7mBrPZqh015f4DQ+PNzQ=
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
Subject: [PATCH bpf-next v2 2/3] selftests/bpf: Check bpf_mem_cgroup_page_state return value
Date: Fri, 13 Feb 2026 15:23:40 +0800
Message-ID: <ba61b77c71b6285eefa022a84bf80c5913b313de.1770965805.git.zhuhui@kylinos.cn>
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

When back-porting test_progs to different kernel versions, I encountered
an issue where the test_cgroup_iter_memcg test would falsely pass even
when bpf_mem_cgroup_page_state() failed.

This patch adds explicit checks to ensure bpf_mem_cgroup_page_state()
doesn't return -1 before validating the actual statistics values.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../selftests/bpf/prog_tests/cgroup_iter_memcg.c     | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
index a5afd16705f0..897b17b58df3 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
@@ -53,6 +53,8 @@ static void test_anon(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	ASSERT_NEQ(memcg_query->nr_anon_mapped, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state NR_ANON_MAPPED");
 	ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val");
 
 cleanup:
@@ -88,6 +90,10 @@ static void test_file(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup_map;
 
+	ASSERT_NEQ(memcg_query->nr_file_pages, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state NR_FILE_PAGES");
+	ASSERT_NEQ(memcg_query->nr_file_mapped, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state NR_FILE_MAPPED");
 	ASSERT_GT(memcg_query->nr_file_pages, 0, "final file value");
 	ASSERT_GT(memcg_query->nr_file_mapped, 0, "final file mapped value");
 
@@ -119,6 +125,8 @@ static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	ASSERT_NEQ(memcg_query->nr_shmem, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state NR_SHMEM");
 	ASSERT_GT(memcg_query->nr_shmem, 0, "final shmem value");
 
 cleanup:
@@ -143,6 +151,8 @@ static void test_kmem(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	ASSERT_NEQ(memcg_query->memcg_kmem, (unsigned long)-1,
+		  "bpf_mem_cgroup_vm_events MEMCG_KMEM");
 	ASSERT_GT(memcg_query->memcg_kmem, 0, "kmem value");
 
 cleanup:
@@ -170,6 +180,8 @@ static void test_pgfault(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	ASSERT_NEQ(memcg_query->pgfault, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state PGFAULT");
 	ASSERT_GT(memcg_query->pgfault, 0, "final pgfault val");
 
 cleanup:
-- 
2.43.0

