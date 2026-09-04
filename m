Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2AE3CB560;
	Fri,  4 Sep 2026 03:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788494064; cv=none; b=L1lhLwHVWIhdyn/O/e92G8f2KyPOFDsRaDIv9fKEp8LoljWtCzxfB4PmcPyPNaT1vo7wUr2u+2cxKcbBO2WQtCdV/0EdFPIZAgW85zeXrs0NYZmcPNKE/VG027ZdMZNoTXALOD84bRFXlDpLBfrgZ1ZzzqO0DtPBzlq7mO9S07w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788494064; c=relaxed/simple;
	bh=ebor0g1BFAIKniYcU917NfVGH7CoX6RUYNUy0P5yL60=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gDiz1n3UJBc6h8zQ7Turn48rIUqpn4I3d7mX+yVSJxl+IY3w/Zqf2tb/lIyGFXO3fnIfySl/Vh4Il42CJnuxs+erIps4Xc1ttFFajq2dXu6UflMN9vD/r8WxPDDbOs6mJxNSvqaUKUDYQ08QxwnkWMm4uxPsSCxIC4YB5LcoAW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Zwx1zUzh; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Zwx1zUzh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788494053; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=/3xAFCi4zSn+vaxb4ofxRbStLSppBczqCnom+pPRFYE=;
	b=Zwx1zUzhKWCcly88hWsbNnOahDUb40EnvCP8DZL61/ZHyiqkVwE0/VSP8Ar3HCpyJah4Wgd6nopKednffzOLrbMx5iJ8e6XLhzcjI1J/Z0H5vqJHoYb1igyDWdbAnnronm7HIsCZPBPyMEEAOOgSXSEGpwURxJLWsQnM8UPBWOk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0XAHc.cH_1788494049;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAHc.cH_1788494049 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 11:54:11 +0800
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
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH 0/2] mm: memcg: settle memory.high debt for non-blocking THP charges
Date: Fri,  4 Sep 2026 11:54:05 +0800
Message-ID: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memory.high is enforced at two points after a charge succeeds: on
return to userspace, and synchronously in try_charge_memcg() for
large overcharges, the latter gated on gfpflags_allow_blocking().

THP charge paths pass the physical allocation gfp from
vma_thp_gfp_mask() to the memcg charge.  With the default
defrag=madvise (and no MADV_HUGEPAGE), as well as with defrag=defer,
that gfp does not allow blocking.  This is the right allocation
policy -- a THP is not worth direct compaction, fall back to smaller
orders instead -- but the charge code also reads it as "this context
cannot sleep" and skips the synchronous enforcement, even though
fault context sleeps just fine.  Inside a single-syscall populate
loop (mlock(), MADV_POPULATE_*, any GUP-driven population) the
return-to-userspace hook is not reached between faults either, so
nothing throttles at all: a memcg's usage runs from memory.high
straight up to memory.max with zero reclaim and zero penalty sleep,
consuming the reaction window that userspace OOM handlers (oomd,
Kubernetes) depend on.

Patch 1 fixes the anonymous THP/mTHP fault path.  The pre-existing
selftest test_memcg_high_sync readily reproduces the problem: with
transparent_hugepage/enabled=always it fails without the patch and
passes with it.

Patch 2 fixes the same problem for large folio swapin on
SWP_SYNCHRONOUS_IO devices (zram) with mTHP swapin enabled.  Its
changelog carries measured before/after numbers for both the
reclaim-keeps-up regime and the penalty-sleep regime.

In both patches the charge gfp deliberately stays coupled to the
allocation gfp, so the fail-fast fallback at memory.max is fully
preserved; the over-high debt is instead settled from the fault
path, which knows its context can sleep.

A note for stable backports: mem_cgroup_handle_over_high() only
gained its gfp_mask argument in v6.6, from commit 9ea9cb00a82b ("mm:
memcontrol: fix GFP_NOFS recursion in memory.high enforcement");
older kernels take no argument.  On kernels predating the swap table
rework the swapin charge sits in alloc_swap_folio() rather than
__swap_cache_alloc(), but patch 2's fix location at the end of
do_swap_page() applies unchanged.

Qinyun Tan (2):
  mm: memcg: settle memory.high debt after THP faults with
    non-blocking gfp
  mm: memcg: settle memory.high debt after large folio swapin

 mm/huge_memory.c |  8 ++++++++
 mm/memory.c      | 10 ++++++++++
 2 files changed, 18 insertions(+)

--
2.55.0
