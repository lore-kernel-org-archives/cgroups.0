Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793870567;
	b=jmBefvJ8Kd/IxGHfiEzSU6is4R38YaTY7GoBBFWsVt7J4X2pHeZEFIOjX1ilbutGg1uR
	 VfvncIlfTxWhWICPcJjhRzwf4Vu3OkXjdDRdqYG4lDyZASAVMLC48wk67ez/bOB3t2xQr
	 sGgCVktO/krrOnGi4tj2kv2enny75Ndir0dH3qAGc800kOZiJlf4wLsR4yAhmd2QeRNHU
	 Q6jNiBkINYE88pbZ66kuTF6rxZrMfVx0tCTm1U2yKFF4Jyb6PX58KQazKp6hUGKcogcBk
	 jvVbV9cnOyV8+HVKblPtJqyuOfH8Ka/lLuYjS7oMZDycQAEf5dRhxhP8fz6HzjiJOEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793870567;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=mhdlXR8A75L7YeWWJ2AV4SzYhiaJarkmp87eHXPOcrA=;
	b=ikK9rBvvVXhGD9Wqd3XGoWVAqNNZ3R0uiEtQVp5J25GuIp0EEfZwKWEjVcr8HQCHzjJY
	 NRO7KhJ193/3y8m42XVRez7HHP5MzXKVe4UlI/SVKBuhEY2SaerjCkjMIBvxMkAS4Kl5t
	 Qq+Ko2BCM9h0jdRHp1J/bwX8tHYlNgE8dHTkIhz2jql+SRfjYmxp3PNs8OKljQoPasGjt
	 83LPuT/MhzJsrvIXrIzfAbCH/gU/GhW+M+3JAlMSapWtQNAEh6lrySKv3fvabcqZNHOfU
	 NvFOEtbuCD15osHqGjKfigj9C4krbUUmLeIX4/kIOKCuN/gg4gKuVFnFm/5ROrivrIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GBGjJOT6;
	arc=none smtp.remote-ip=115.124.30.100
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A5B606A32C;
	Thu,  5 Nov 2026 09:22:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7A5B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=GBGjJOT6
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793870563; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=mhdlXR8A75L7YeWWJ2AV4SzYhiaJarkmp87eHXPOcrA=;
	b=GBGjJOT6ibqaEvGBrk/qxkgqGW5I8+tzyw/4xIZlBKuyr64cjDBmFUFltQrntxV4fY/DJKXjU+sZkMlszG+I7pvE9woIZUOJ2acC4T0SJqBUaIdNgW2rkzbPWlRllyulkydDFrnErlSubhjCKpOSHcjh+yxU3BUPG+K1ltB48CU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XE8K-1F_1793870560;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XE8K-1F_1793870560 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Nov 2026 17:22:41 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v4 RESEND 4/5] mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
Date: Thu,  5 Nov 2026 17:22:32 +0800
Message-ID: <20261105092233.3558950-5-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
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
flag set the shrinker would run twice per reclaim cycle.

NONSLAB-backed lrus keep their per-memcg lists under nokmem now, so
the shrinker bit identifies the owning memcg again.  Restore the
flag.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers".

Link: https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/
Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
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
index a62d6592af7e..4ddbbdbfcc2d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1059,7 +1059,8 @@ int folio_memcg_alloc_deferred(struct folio *folio)
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

