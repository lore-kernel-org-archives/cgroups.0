Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617453D0C18;
	Fri,  4 Sep 2026 03:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788494066; cv=none; b=t9uh4KPkhghdZB1rsLodDWXyp6e2oxGSLYjy2qbXH1e2De/uGcaSYSpaqPEK1EvWZlTnZ51zWiK7quFsRPL8LvlUX2mPl0s8Yx1trgpGhwbH2wq1SvrJUA8hWiRoXL/9qadqZkC1KNs5vED9QMyPoNg8rd5QsYdikmVDaxBc3Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788494066; c=relaxed/simple;
	bh=okoHG7hhrASUbmUWnbL1bbmjPybACR6zl0QBKuH+/SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWVsV/cxswgNFzYQTF3RdSoHAlWPffjBGCZOtqzOG3y+w4EdAS+YfPr1KJonbNzptnshiBZLTi3WX7KkkIc8ufh1mq/CPG+DSNDNWRDYA6vncOfUxAII5svNJMShLVOt6kTUXoVDS+fGMmxm1AfK2cUUbTOlKA9UR/0OiSD71Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=H1DRkfKo; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="H1DRkfKo"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788494056; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=RgILmAj8pZmVgzIjSER8ulyJ/VZ7FZsMUaib2i4Gc/c=;
	b=H1DRkfKoPKGu6Emdmr2jAdGSCpJI8BtCHVoWSSjmHgm84Pog15d+5enW8ZvbDFFUnpEDsnC2h8SA5pusEafE5NAsrZVpLOT9jeBFeiBqZ6l5D6Hml1GqpbfrBjqzRkoIGfWQavhSkNUmDjF3voSHv3UM5XsuZyiuKMuvZjRLH4g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=29;SR=0;TI=SMTPD_---0XAHc.dA_1788494052;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAHc.dA_1788494052 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 11:54:13 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Chris Down <chris@chrisdown.name>,
	Chuanhua Han <hanchuanhua@oppo.com>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm: memcg: settle memory.high debt after THP faults with non-blocking gfp
Date: Fri,  4 Sep 2026 11:54:06 +0800
Message-ID: <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
References: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Anonymous THP faults happening in a kernel loop that does not return
to userspace -- the populate loop of a single mlock() call, or any
GUP-driven population -- can drive a memcg's usage from memory.high
all the way up to memory.max with zero reclaim and zero penalty
sleep.

This defeats the containment memory.high is supposed to provide:
above high, the documented promise is that "the processes of the
cgroup are throttled and put under heavy reclaim pressure", and
userspace OOM handlers (oomd, Kubernetes) rely on the high..max
buffer as their reaction window.  Only after hitting memory.max does
the non-blocking charge fail, THP fall back to 4K, and
folio_prealloc()'s GFP_KERNEL charge finally restore throttling --
by which point the entire buffer has been consumed.

memory.high is enforced at two points after a charge succeeds:

  1. from resume_user_mode_work() on return to userspace, requested
     via set_notify_resume();
  2. synchronously in try_charge_memcg() for large overcharges, added
     by commit c9afe31ec443 ("memcg: synchronously enforce memory.high
     for large overcharges"), gated on gfpflags_allow_blocking().

A populate loop does not return to userspace between faults, so gate
1 never runs.  Gate 2 is defeated by the charge gfp: since
commit 3b3636924dfe ("mm, memcg: sync allocation and memcg charge
gfp flags for THP"), the THP fault path passes the allocation gfp
from vma_thp_gfp_mask() to mem_cgroup_charge().  With defrag=defer
that gfp is GFP_TRANSHUGE_LIGHT | __GFP_KSWAPD_RECLAIM; with the
default defrag=madvise and no MADV_HUGEPAGE it is plain
GFP_TRANSHUGE_LIGHT.  Neither allows blocking.  This is the right
policy for the physical allocation -- a THP is not worth direct
compaction, fall back to 4K instead -- but try_charge_memcg() also
interprets it as "this context cannot sleep" and skips the
synchronous enforcement, even
though fault context sleeps just fine (it holds the mmap or per-VMA
read lock).

Fix this in the fault paths, which know their context can sleep:
after a successful THP/mTHP charge, settle any accrued over-high
debt via mem_cgroup_handle_over_high(GFP_KERNEL).  This reuses the
existing throttling machinery (reclaim + calculate_high_delay()
penalty sleep) and is a no-op read of
current->memcg_nr_pages_over_high when there is no debt.

Deliberately not changed:

 - The charge gfp itself is kept coupled to the allocation gfp, so the
   fail-fast behaviour at memory.max (charge fails -> fall back to 4K
   instead of reclaiming or OOMing for a THP) that the coupling was
   introduced for is fully preserved.

 - try_charge_memcg() is not touched: gfpflags_allow_blocking() is the
   only signal it has, and it must stay conservative for callers that
   genuinely cannot sleep.

The pre-existing selftest test_memcg_high_sync, added alongside the
synchronous enforcement by commit 6323ec54b450 ("selftests: memcg:
test high limit for single entry allocation"), readily reproduces
this: it mlocks 200M against memory.high=30M and memory.max=140M
with swap disabled, and expects high events with no max events.  On
systems with transparent_hugepage/enabled=always it fails without
this patch -- the population bursts through to memory.max -- and
passes with it.

Fixes: c9afe31ec443 ("memcg: synchronously enforce memory.high for large overcharges")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---

Note for stable backports: mem_cgroup_handle_over_high() only gained
its gfp_mask argument in v6.6, from commit 9ea9cb00a82b ("mm:
memcontrol: fix GFP_NOFS recursion in memory.high enforcement"); on
older kernels the call sites take no argument.

 mm/huge_memory.c | 8 ++++++++
 mm/memory.c      | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ced400f72d43..543ba4a74dc3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1329,6 +1329,14 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		return NULL;
 	}
 
+	/*
+	 * The charge gfp encodes THP allocation policy and may not allow
+	 * blocking, which makes try_charge skip its synchronous memory.high
+	 * throttling. Fault context can sleep, so settle any over-high debt
+	 * here instead of letting usage grow unthrottled up to memory.max.
+	 */
+	mem_cgroup_handle_over_high(GFP_KERNEL);
+
 	if (folio_memcg_alloc_deferred(folio)) {
 		folio_put(folio);
 		count_vm_event(THP_FAULT_FALLBACK);
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..24cbf2a26905 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5362,6 +5362,8 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 			folio_put(folio);
 			goto next;
 		}
+		/* Same reasoning as in vma_alloc_anon_folio_pmd(). */
+		mem_cgroup_handle_over_high(GFP_KERNEL);
 		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
 			folio_put(folio);
 			goto fallback;
-- 
2.55.0

