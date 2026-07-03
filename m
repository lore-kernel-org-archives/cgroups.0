Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C743806C1
	for <cgroups@vger.kernel.org>; Fri,  3 Jul 2026 06:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783060729; cv=none; b=eDl/Xk7xa6j/6/c2j1UoZtyIjfjxlDwOfoU7wOk6M1T4X+bcgBBS7u9SGVGFQyuoqDrCRgFPCsNehqAs+UkHRfMncAvajljZ7AA+1O15djmsbZDEkehzcvB4/MgJOPh7R4evPCYIbNoW6R++UkyySqnzhFzpEQMTj9YCCQ2fM/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783060729; c=relaxed/simple;
	bh=S1dwmhLP7HXeAgFQGef9hM0uREtmrK4DVQcBOln1gmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQxN94pSRcriapE/lSwCIRxofNK7+EtSf8snhevZUAKawF8dPOwcfUh59JzlX3KvQkiTtIoDlOT7rnxyBYMGYOWUGrarixfgTwDcIOAs/t4OCLHvfGu5VwFCAk64COaN4UItuF7RpzjxJCLHDLjEUQytpPaPQiRQ3uUJycrE6sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Kf+KTADP; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Kf+KTADP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783060724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0fEkK9pnSJD0txsSBPtdtsEE+U5WFOOOSBGYT3LbvKE=;
	b=Kf+KTADPxIaSTV+fpz3zkI31900PahAzK4oDrKTYL2hq76L6jqeC1Z6rsae9oA+qGkPsrb
	MmUFdtb27N8LjAkSWVFxCJNOTAjLsHP2MnhQG2EvGZ1Jlw5nlmfsM1ioniGKXkzUH/zN8v
	c15uJL34DaqaCj6QOnE0Iw+ptapp6c0=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] mm: memcg: reset oom_group in css_reset
Date: Fri,  3 Jul 2026 14:38:24 +0800
Message-ID: <20260703063826.306878-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260703063826.306878-1-jiayuan.chen@linux.dev>
References: <20260703063826.306878-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jiayuan Chen <jiayuan.chen@shopee.com>

memory.oom.group defaults to disabled, but css_reset did not clear
memcg->oom_group when a disabled memory css is kept alive by another
controller dependency.

Reset it with the other memory controller policies so a hidden memcg
cannot keep applying stale group OOM kill policy.

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
It is found when Sashiko reviewed my previous patch.
https://sashiko.dev/#/patchset/20260702024827.353185-1-jiayuan.chen%40linux.dev
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c20ef3c1d6fe..c7de62c8f86f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4362,6 +4362,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
+	WRITE_ONCE(memcg->oom_group, false);
 #ifdef CONFIG_ZSWAP
 	WRITE_ONCE(memcg->zswap_max, PAGE_COUNTER_MAX);
 	WRITE_ONCE(memcg->zswap_writeback, true);
-- 
2.43.0

