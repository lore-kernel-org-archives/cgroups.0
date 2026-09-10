Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37EF416844;
	Thu, 10 Sep 2026 08:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789027665; cv=none; b=bFDqQnWivpl0Gof3g+M9GyM7NVdU6W7X4GY5ZJmCHAH1WjwlTSJlGK665Oi8955xTqWlqE5p0R8HF2cwWuK4gI520TDpjsi/vrku2sbUZ8lWq3xsaSjVohaG+VRtL3/Ii90XUIO11NaCpW5swSew7YcPI6n2rGNhH/N3UzpXLYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789027665; c=relaxed/simple;
	bh=jeSTD1mKKdfRm+R1M5Tv0FzCuI2z6+Mfhqu3Z7dGfJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WvRrrF6lgmDARpZ4tfynejTXk4Sp2xJNAFwEA137hOjJOSMFZlEybrKnxhAYmCMPaV/B7vkOwWtM+KZfCBaBXDlrXkgcZagBJIFKMOAHeGOP2ursITjk436XfygmJWFeDQgxD4nVcZ/zl2MB4a+0X/Ei1xKPKRqHOYeZDGBtwNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=hPoj4KHc; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="hPoj4KHc"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789027652; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=yOGxmv+6Opxbs9N7PyJbTc7/4fbErynFF1JLR/lLM04=;
	b=hPoj4KHckDJCNCslu2bE5QRV0T20zOJaL+A3JtD6inni7kvCYNv2BzSpv9AyfJ2hLCcBOEtnyNY4GZLv+sfMTkdUEkl4exIagVptCW+83wffsIlF/vk5nTUwGx0ppSm5ER8SERn0rVdRxGsdHblcKXJalRHwBAxQPNY8QIWFcg0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XAh0I06_1789027649;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAh0I06_1789027649 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 16:07:30 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Usama Arif <usama.arif@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v3 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Thu, 10 Sep 2026 16:07:21 +0800
Message-ID: <20260910080722.3961351-4-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
References: <20260910080722.3961351-1-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On a system booted with cgroup.memory=nokmem, the deferred split
shrinker is demoted to a non-memcg-aware one.  As a result, partially
unmapped THPs are only split under global reclaim; memcg
(limit-induced) reclaim never splits them, so a cgroup under memory
pressure keeps its underused THPs intact.

The shrinker has carried SHRINKER_NONSLAB since commit 0a432dcbeb32
("mm: shrinker: make shrinker not depend on memcg kmem") precisely
so it would keep working with kmem accounting disabled.  Commit
fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
dropped it knowingly: under nokmem the list_lru collapses into a
shared per-node list while __list_lru_add() still sets the shrinker
bit on whichever memcg happens to add the first item, and with the
flag set the shrinker would run twice per reclaim cycle [1].

NONSLAB-backed lrus keep their per-memcg lists under nokmem now, so
the shrinker bit identifies the owning memcg again.  Restore the
flag.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers" [2].

[1] https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/
[2] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c5d11147b69ae..87c9fc48b7cfd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1064,7 +1064,8 @@ int folio_memcg_alloc_deferred(struct folio *folio)
 static int __init thp_shrinker_init(void)
 {
 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
-						 SHRINKER_MEMCG_AWARE,
+						 SHRINKER_MEMCG_AWARE |
+						 SHRINKER_NONSLAB,
 						 "thp-deferred_split");
 	if (!deferred_split_shrinker)
 		return -ENOMEM;
-- 
2.43.7

