Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A472E2D2488
	for <cgroups@vger.kernel.org>; Thu, 12 Feb 2026 08:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770884638; cv=none; b=MliwC8tZVklLU3M+vC9diP0N2H2C6/ZcJMJzBjPaclHQdc95xjffKq0yIqwTbPKnv+1jz2aP2jHBPZoIn7osn3NvbBdL2AdpOOMIP55gg+4BLV5i8E3LDF6rQd7Mj0P28c/GJ8HkoI0DjFNJiY3vpS88OlDzGriAvwXd63X24M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770884638; c=relaxed/simple;
	bh=nc9UqMakTgTVpIVgbrfrdJ3wNfSWNxcL+yXxgJfcvJo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=huOFJ9G5eag1yK3Vksf4Nvrf9BjGsS7UTdTAUvmsOt9xftZueiFbJ2yofAWHs4PbIvQSczsG9uN+mM+Me904kol03r737YlO354vdr5zBe3dRTgUq0PrXE8Us9lFb38PEMYL0HG71f5eLfHMWOkOgr98YxW96aHrosXryQG3Hlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XijP+Aja; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XijP+Aja"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770884624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nG1F/Kmp6JwkFcrp15JMZNDubf9nKflBRchreJY3ZlM=;
	b=XijP+AjafbjgMxF/DSBHdAP+2rp4pvVbeq7EN/TaXPqfY/pR/Rh9/uS4pSE0MRoKKY/n6k
	29dxRtBU7+TC7UIz82mkX2pafsIH8X30sEEfHjJk+VFee9nJuGpQeBsMg7Lg7hjZ7kl+Xr
	6cLpO7nAWVNrWW21hZwdyYyQKsgRNFk=
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
Subject: [PATCH bpf-next 0/3] Fix test_cgroup_iter_memcg issues found during back-porting
Date: Thu, 12 Feb 2026 16:23:13 +0800
Message-ID: <cover.1770883926.git.zhuhui@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Hui Zhu <zhuhui@kylinos.cn>

While back-porting "mm: bpf kfuncs to access memcg data", I
encountered issues with test_cgroup_iter_memcg, specifically
in test_kmem.

The test_cgroup_iter_memcg test would falsely pass when
bpf_mem_cgroup_page_state() failed due to incompatible enum
values across kernel versions. Additionally, test_kmem would
fail on systems with cgroup.memory=nokmem enabled.

This series addresses these issues:
1. Add return value checks for bpf_mem_cgroup_page_state()
2. Return error when accessing kmem with nokmem enabled
3. Skip test_kmem when cgroup.memory=nokmem is set

Hui Zhu (3):
  selftests/bpf: Check bpf_mem_cgroup_page_state return value
  mm/memcontrol: Return error when accessing kmem with nokmem
  selftests/bpf: Skip test_kmem when cgroup.memory=nokmem

 mm/memcontrol.c                               |  3 +-
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 40 +++++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

-- 
2.43.0

