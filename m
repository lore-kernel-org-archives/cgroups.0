Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.118
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795431225;
	b=fOxRgtFasZ+fSaF7rR45cy4b9TsFS5WHDH5z/UogJtdYa2RLfG30SlNjFS0F5sNoBeJc
	 VBrZheZViW8/w7wUcXDqKu4C5fTpeFHA9vjWQUWCcNK5vNZSFApQ4MKVEOq4Ko4cOzYCm
	 JGykEsIqHW7cJyHA0bVTH3Oo7Px/e93G/Ab8ni7mxCuyzlj6ZBhTCCvFbXdO65GXo7FYq
	 hwihvM+z5vIFwHTKOH10/4lCCUHoXY4pONKRL1HgT/RVw7TMwlgYhwf1AtpuYz34R/ndr
	 A7OmG7r9NMiTOk6IPmMKJb/qAnYS2lGxAfTBamAUA5AkCQs0lDkz19ZHjFl7oMoAGgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795431225;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=c9L6jvOwGrAP6YCaPZASj/kNscePV1aVd/8CkGJVXlI=;
	b=MBhHSOMlRWS0KLLhKRpw4oeJ8mNg2fkSJe0uRl++HL+ToyQuQeCUHBCUCvmhMtzO0TqG
	 bCGDvwl9SLwdW1ZdR3/xSUOOx5foV5WTyC2Z1ZyME04AwQWgOJpWHeF0leKAV7kIln9Wl
	 IPqFWByA1cNixVQ6M/Vt2BhX2rqKu+WuLOKFDOedoGPR2hiVqQmEckWYDxZlFzy669XM5
	 1kRqFdxeAp8d99x8dlSRWx57QgM/sJb1uKZXt0PJ0n/onUDir1P1BNdeGF9Wb/gJY67iL
	 K8VrcyyTreGOrMlhJaTK8oNErZxbQt/N1KvSwc9ZNJbg1B0WHMhQRgpMIi+BxkyTCag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dRSiifnu;
	arc=none smtp.remote-ip=115.124.30.118
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F8C606A68E;
	Mon, 23 Nov 2026 10:53:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13F8C606A68E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=dRSiifnu
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795431221; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=c9L6jvOwGrAP6YCaPZASj/kNscePV1aVd/8CkGJVXlI=;
	b=dRSiifnutECFeYiDF25cvuXZLTnVN7a4PMZglPNUWw/epIsmobsfNNCiaEs5tyXj8fnkeDq6aQC7lnuXYUpoKTKyEt0oYudP1ashsdifwsy+SKS+ZTCIaYEw1Lde7mteEV6iIBLpeSOCMxQ1vNEk0tYYA/DcYcqFal3sp54pMeM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XFHJh-e_1795431219;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFHJh-e_1795431219 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:53:40 +0800
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
Subject: [PATCH v5 2/4] mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
Date: Mon, 23 Nov 2026 18:53:32 +0800
Message-ID: <20261123105334.2524066-3-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With cgroup.memory=nokmem, __list_lru_init() collapses every list_lru
into per-node lists.  That is fine for slab objects, which are not
charged per memcg without kmem accounting.  But a lru backed by a
SHRINKER_NONSLAB shrinker, e.g. the THP deferred split queue or the
zswap entries, holds user memory, which is charged regardless of
nokmem.  Collapsing such an lru loses the per-memcg view of its
objects.  Reclaim can no longer target just the cgroup under pressure.

Keep such lrus memcg aware under nokmem when their backing shrinker is
registered SHRINKER_NONSLAB.

This leaves the savings of nokmem intact: slab-backed lrus (e.g. the
superblock dentry/inode lrus) still fall back to the per-node lists,
and the per-memcg lists are allocated only when a memcg actually holds
such objects.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index b4c879d7ba01..78ca07bbc3a3 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -712,7 +712,9 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
+	if (mem_cgroup_disabled() ||
+	    (mem_cgroup_kmem_disabled() &&
+	     (!shrinker || !(shrinker->flags & SHRINKER_NONSLAB))))
 		memcg_aware = false;
 #endif
 
-- 
2.55.0

