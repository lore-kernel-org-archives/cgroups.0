Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F00B3C3F40;
	Fri,  4 Sep 2026 03:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788494065; cv=none; b=reC1SGGGkU9U5Z5CF3XFVbWCEw0fVZzkPmnLmclJEJC/cEaDQ7XN4rOj1HnT5Oyjdi/nNwFdtR/MG8mSxia6iUCI8QdZy2RL6n4Gi8PNTIf8ba4Ot15wW/OwAL7qKnJMPekCE5Tc90vtsbfP22ikEzcI/GUHOuTggRV3NA6v7gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788494065; c=relaxed/simple;
	bh=s/3aC/ZXAMh7VrMGokeDjiJo/yCY3Q3/Z2I2nTEt9A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/oktDg4cqAX9zsC468/xuhBB95nfG1V6zWI7a1WlLd1frCyi8sYvD/2YBGf5Y+1aVELfolHzt/3nfv+4pUHDYLBTPeULAXNciZDdtrOqq8dAyqnOfJZ75SO3Y76GLNJe4mH+YIZqpEAVZQ4rpYU4otwaNrZpYXXwBA31aJLRqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=CfXS1Rcz; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="CfXS1Rcz"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788494058; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=YPr2nhosCXoKcsIhMPeI7fzZvZMIzTsZ4k4iope2HB0=;
	b=CfXS1Rczv8avVDiR4oV64HPFuIQFGElvCJdaU/kl+RYm3/xxsTdjeZXbvneYoLzk2FEOxvL6Ae4prPbVfjYf5C1r8jXAznIfPn6S8SbVlCKxninC/We/UI8mXbdBF08DNnsW79s6Who5hsgwVAyp8zUlmWj+Cdu3l/B0NMO6FEs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=29;SR=0;TI=SMTPD_---0XAHc.di_1788494054;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAHc.di_1788494054 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 11:54:16 +0800
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
Subject: [PATCH 2/2] mm: memcg: settle memory.high debt after large folio swapin
Date: Fri,  4 Sep 2026 11:54:07 +0800
Message-ID: <20260904035407.4098627-3-qinyuntan@linux.alibaba.com>
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

On SWP_SYNCHRONOUS_IO swap devices (zram) with mTHP swapin enabled,
swapping a range back in from within a single kernel entry -- the
populate loop of mlock() or MADV_POPULATE_READ, or any GUP-driven
population -- drives a memcg's usage from memory.high straight up to
memory.max with zero reclaim and zero penalty sleep.

This defeats the containment memory.high is supposed to provide: the
high..max buffer that userspace OOM handlers (oomd, Kubernetes) rely
on as their reaction window is consumed in well under a second, and
when the swapped-in pages are mlocked the burst ends in memcg OOM.

The cause is the swapin instance of the problem fixed by the
previous patch for anonymous THP faults.  memory.high is enforced
either on return to userspace, which a populate loop does not reach
between faults, or synchronously in try_charge_memcg() for large
overcharges, which is gated on gfpflags_allow_blocking().  Since
commit 242d12c98174 ("mm: support large folios swap-in for sync io
devices"), swapping in a large folio charges it with the gfp derived
from vma_thp_gfp_mask() (nowadays via __swap_cache_alloc(), which
overrides the caller's GFP_HIGHUSER_MOVABLE for order > 0 before
calling mem_cgroup_swapin_charge_folio()).  With the default
defrag=madvise and no MADV_HUGEPAGE the resulting gfp is
GFP_TRANSHUGE_LIGHT based and does not allow blocking.  That is the
right policy for the physical allocation, but try_charge_memcg()
also reads it as "this context cannot sleep" and skips the
synchronous enforcement, even though swapin fault context sleeps
just fine.  Order-0 swapin is unaffected: it charges with the
caller's GFP_HIGHUSER_MOVABLE and throttles as expected.

Fix this by settling the debt at the end of do_swap_page(), where
sleeping is known to be safe: the folio lock, the page table lock
and the swap device reference have all been dropped, only the
mmap/VMA read lock is held -- the same context in which the order-0
charge path already throttles today.  This is a no-op read of
current->memcg_nr_pages_over_high when there is no debt.

The charge gfp is deliberately kept coupled to the allocation gfp so
the fail-fast fallback to order-0 at memory.max is preserved,
matching the previous patch.

Verified on zram swap with hugepages-64kB/enabled=always and zswap
disabled at boot: memory.high=30M, memory.max=140M, then a single
MADV_POPULATE_READ over a 200M swapped-out range (~3200 64k large
folio swapins, confirmed via mTHP swpin stats).  Without this patch
the populate bursts through the whole high..max buffer in 0.24s and
memory.events max goes 0->1.  With it, max stays 0 across repeated
runs and usage is held at memory.high by reclaim throughout (high
0->~680).  Populate time is unchanged (0.22s): settling on every
fault keeps the overage within one charge batch, reclaim keeps up
with the swapin rate and the penalty sleep never needs to engage.

The penalty-sleep regime (mlock'd populate, so swapped-in pages are
immediately unreclaimable) was verified separately: without this
patch the locked burst blows through the entire high..max buffer
(~132M of 64k swapins) within 0.1s and ends in memcg OOM; with it,
usage climbs from memory.high at a quadratically decaying pace (33M
after 5s, reproducibly) and never approaches memory.max within the
observation window.

Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devices")
Cc: <stable@vger.kernel.org>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---

 mm/memory.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..dd56b43d3aa3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5267,6 +5267,14 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 out:
 	if (si)
 		put_swap_device(si);
+	/*
+	 * Large folio swapin charges with the THP allocation gfp, which may
+	 * not allow blocking, making try_charge skip its synchronous
+	 * memory.high throttling. Settle any over-high debt here instead,
+	 * where sleeping is safe: the folio lock, the page table lock and
+	 * the swap device reference have all been dropped.
+	 */
+	mem_cgroup_handle_over_high(GFP_KERNEL);
 	return ret;
 out_nomap:
 	if (vmf->pte)
--
2.55.0
