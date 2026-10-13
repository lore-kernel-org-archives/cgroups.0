Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C961130F52B;
	Tue, 13 Oct 2026 03:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791861171; cv=none; b=mg9eCGzwHB9lYop1FRz0iP1SQyufMjVln+3DKCQ2Xs7JcPpaKndqWcZfZgWx/wTnyVGdpU5iYGjcpSNd0l9ib/xzE2lrSLVgFki4AhgThixqQnbstblU2fKkkSb2uLByjG1FVOyWTDSN+uJDvVTcFzI70qujSW5BiCIJcqRFO9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791861171; c=relaxed/simple;
	bh=J8+idmgSWUPF7X54ve43ssCP/ifMKCYbf41zbi8Z8mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nhz55ZPafvdDkrT6KZltS2XkLKLdaPkAz77delEWOiAMH8qUOqg9ycvd0FhbEzSX/EpSM6fSlSmLx5goccuk7dsdytfsHd6JhlLT5QoivDO0SkpDQ3eispT7cEqHqAvV+b4DW668dodG1fJWzReK28aygaHU3Tb8HMl1edddo4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=b2f+D+Yr; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="b2f+D+Yr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791861153; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=zpf5QsizXx9EkATcGnWqX+gyIM8QWqLtiyYMZfErVsY=;
	b=b2f+D+Yr7FaCZqUy4DlmRpZZ1cC7ZNuF5xA23n0kvkHCT4iEBGaTpDJfweO/D3ITUhIY68kGJtPPvvwLVRiYTFo2Oit1626x7aVb/XR5pPJSOYMBY7EQDU+SgmZPnS1NhMX8qtXwgBRAMJhtn0YPCwpZxxTscDpd7hlekhdpwN4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XCkEjeP_1791861150;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XCkEjeP_1791861150 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 11:12:31 +0800
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
Subject: [PATCH v4 5/5] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
Date: Tue, 13 Oct 2026 11:12:21 +0800
Message-ID: <20261013031221.1997194-6-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With kmem accounting disabled (cgroup.memory=nokmem), memcg reclaim
never invokes the zswap shrinker: a cgroup under memory pressure does
not write back its own zswapped pages to make room; they are only
written back by global reclaim or once the global pool limit kicks in.

The zswap shrinker is registered memcg-aware but without
SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
before commit 03375203e1da ("mm: do not allocate shrinker info with
cgroup.memory=nokmem") it was skipped by the !memcg_kmem_online()
check in shrink_slab_memcg(); since that commit it is demoted to
non-memcg-aware at registration.  But the zswap shrinker is not a slab
shrinker: it tracks zswap entries and resolves the owning memcg from
the folio's objcg, independent of kmem accounting.

This was noticed by Michal during review of the patch "mm/list_lru:
don't copy stale shrinker id from non-memcg-aware shrinkers".

Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
under memcg reclaim with nokmem.

Link: https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Suggested-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 572075bb1c1c..382ed1fb2847 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1348,8 +1348,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
 {
 	struct shrinker *shrinker;
 
-	shrinker =
-		shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE, "mm-zswap");
+	shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE | SHRINKER_MEMCG_AWARE |
+				  SHRINKER_NONSLAB, "mm-zswap");
 	if (!shrinker)
 		return NULL;
 
-- 
2.43.7

