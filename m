Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903E6444707
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 20:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786134072; cv=none; b=Y2yRpaMcEvXU1xhyl8sqVF7pBEhjvJuGvst43taQ/qHDDSATttXVK6BGv1TYFqqGA0J6oftimrfJibAg8zil7QhjZxWb/r1NJl0CcNZB8u8JmOLvi5f15yvG7/2qSeCP/U/7jI1FwvNtP/CeInTPDh0I8klTYdaBoCv+L7RDfOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786134072; c=relaxed/simple;
	bh=ZG8mhq/oRDYPChzRStWZmZ7lpPUxxEq9apfKos3UvZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVA3uuveh+AbqF3bJIZpCGucmkjOErg6ubCJZ6FPXLS438In2084j0O9Zx6+GuEx3UvKcRT/2k8ELj7VPa1iubWVr3y2U6r5oRa/+SfeKlSQLmpqru5o85AbNSA9TqyjUpOg7T4KS6fApY0/4V5b9A8d1Bf+AeW1IzUQNglBfs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qm7J3Ovx; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qm7J3Ovx"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-44aeefa1c00so1921073fac.0
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 13:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134069; x=1786738869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VEYEX02IKWE90JSQ/XOJ17bp5Gj7dbgYbm77S6gqa2M=;
        b=Qm7J3OvxDalvZ2pKHv3CBSQQbttnQmHcCJ94rfl7H29NISOsC3XyDumI/CbhJtqy1j
         RomUEomOOgBIusPKaxLA+9pncuzliPNnv9BKCGuCchoK5DWDR2kY8CPonezWqHJSBo5/
         r5mIyY65ci7GSc6hAACm5rdHtxLiDdDd7YFobHQ+f2zUAjBI//boLdEcjT80YNU9WHxq
         q92+OV7YNsGvN1h33vBANDRvIhA0Vcdwv5OmTOM6RzTineVEDxnG046jE9S+Y08UrH5n
         68tyxY/lHCXe3YtwguRZpD19TxXjmCDjXS5ILz4ZLvvD4MmEaMTlTyNFl6R1bXQLM1n+
         6oqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134069; x=1786738869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VEYEX02IKWE90JSQ/XOJ17bp5Gj7dbgYbm77S6gqa2M=;
        b=QO/N4v3MiuWlEXzyys3ArCr+GZcN0mBY31gymR56qw0hWEdVdA2WVfMnypcH0WuDQd
         J8+jLWKO0R/WJ29fYl+K4Rqr96EITXJhY95BnpsoNC3/q471VB4SAd0LW8UjeZDxdk/g
         iNcDb8jKwlrjJx4Hlc0mGwiG8Mf5iJUsMKOPziuLGZlwT0YR9U1zM9hu+LkBkYIOfuKV
         I8XATxvR7k8LQFmVdF0XPx2TIu07MsVl3paEzofBf4cthKhbT49Lza86y5KqjdqhelMt
         wVkkTKmeKXBjW7yl0hwS15pdzvknOCWMLP+htGtFSb93eNfjMGQWyyU1FYvZJR2aeHNm
         e3jQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr206uEuMB+ku1ge1EECbgUeFk2h+EE/fK2PZPka7RWUn+rW1xeWjLIiuSmXYDMOvkt2jf6bCfR@vger.kernel.org
X-Gm-Message-State: AOJu0YyP7AdMwaRYOCrcbwQ8gDxrhNF/uh44n0Iete2+pK91rXzFBzDR
	cpkN/hiKZRIU5k1Y7YoK3DyonQFsf2CQbYpPmbd/thZwMbPn/wrfEv8V
X-Gm-Gg: AR+sD13ST6zyvWLdbrgQnwATI3BMDRnn+lG9/+SmtuDa4pL0lmTMDaU3GSZmn3JfLjq
	Xt9PAneK4w5Q6+YdkN6dUIHecwX7HpKnu/yDFiiaStTL9TnnX6tyW4dPpN1CgIAz8KB3mQhUe4K
	vlJQT37+ORH3t2uaH387V8Xr80tfROHWhzIb9qIY3ZSEUIqqFTjucJ+9qZUVGp3epWHP8niDjGA
	yoqc9CeT53d8wppW5hiwU5WZuTUxYWEh7Cu77EWbhIu9c7ZnMw6Jl2rPO5jgoX1iQ6bZguNQh8R
	3rL+nJPrXvljQEXJV52/zo3JhuzN/+9LpY10gjtgyeSMLI53+iTZ/K84biA1nJrzZOXksu8HS4e
	AgQNP/OoJNLcc6h9WHM8+m11Y7MVbgbLm4++RKvLxYXxspZrKKcJBhO+0H3ylt0x2LZ95j/QVhQ
	D/GEaIn54qmnPfcZDaKD27ERdhy10WLMO3++QiYk7mbRw0H4e2nj64hiCByofpAavtiZdVWfwT+
	KO7HbjNrI3uskGI67I/1E4ME9wooDT7FAZozLQ=
X-Received: by 2002:a05:6870:478d:b0:424:801:49fe with SMTP id 586e51a60fabf-45a15e2f25dmr397157fac.8.1786134069430;
        Fri, 07 Aug 2026 13:21:09 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1a9e431sm2643069fac.6.2026.08.07.13.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 06/14] mm/vmscan, memcontrol: Add nodemask to try_to_free_mem_cgroup_pages
Date: Fri,  7 Aug 2026 13:20:49 -0700
Message-ID: <20260807202059.2620949-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new nodemask parameter to try_to_free_mem_cgroup_pages to allow
selective reclaim on certain nodes. This new function signature can be
used in future patches to selectively perform reclaim on toptier and
place downward pressure when toptier limits are breached but memcg-wide
limits are not yet breached.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/internal.h      |  3 ++-
 mm/memcontrol-v1.c |  5 +++--
 mm/memcontrol.c    | 11 +++++++----
 mm/vmscan.c        | 10 +++++++---
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index f47f06c555481..5f2f6a1757bd9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -84,7 +84,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness);
+					   int *swappiness,
+					   const nodemask_t *allowed);
 unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 				     gfp_t gfp_mask, bool noswap,
 				     pg_data_t *pgdat,
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 835fc8e511844..688896b59efe4 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1815,7 +1815,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
+				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
+				NULL, NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -1851,7 +1852,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 			break;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP, NULL))
+					MEMCG_RECLAIM_MAY_SWAP, NULL, NULL))
 			nr_retries--;
 	}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index defd04acfb3fd..6c67d9d2c9ac7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2397,7 +2397,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL);
+							NULL, NULL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2710,7 +2710,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+						    gfp_mask, reclaim_options,
+						    NULL, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -4946,7 +4947,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -5007,7 +5009,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17d2b793cbfc4..ffe7ea3c5aff6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6859,7 +6859,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   const nodemask_t *allowed)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6875,6 +6876,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.nodemask = allowed,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -6900,7 +6902,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   const nodemask_t *allowed)
 {
 	return 0;
 }
@@ -8033,7 +8036,8 @@ int user_proactive_reclaim(char *buf,
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						 batch_size, gfp_mask,
 						 reclaim_options,
-						 swappiness == -1 ? NULL : &swappiness);
+						 swappiness == -1 ? NULL : &swappiness,
+						 NULL);
 		} else {
 			struct scan_control sc = {
 				.gfp_mask = current_gfp_context(gfp_mask),
-- 
2.53.0-Meta

