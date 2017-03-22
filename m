From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: workingset: fix premature shadow node shrinking with cgroups
Date: Tue, 21 Mar 2017 20:53:20 -0400
Message-ID: <20170322005320.8165-1-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:
	Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9vy5gp6urssa1xt3aC77Kvg6bFDRYFsRjeV/LTgr/ys=; b=Mpv4G1B/T5SLLlu7xeYNO+Yk9H
	DON0R09ptIySnXFi5ql2JUbxzrJfaZhzUnBDpSxu6enTbVzM/gTCvlmDc0W3S448QVynugoMZPDK4
	QJg1OZ5+zc0n3ajgBuDzgR98+zGh53BID4Vz/pRNReEyGM8F61x+tBx4yO4oecMYFLEs=;
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

0a6b76dd23fa ("mm: workingset: make shadow node shrinker memcg aware")
enabled cgroup-awareness in the shadow node shrinker, but forgot to
also enable cgroup-awareness in the list_lru the shadow nodes sit on.

Consequently, all shadow nodes are sitting on a global (per-NUMA node)
list, while the shrinker applies the limits according to the amount of
cache in the cgroup its shrinking. The result is excessive pressure on
the shadow nodes from cgroups that have very little cache.

Enable memcg-mode on the shadow node LRUs, such that per-cgroup limits
are applied to per-cgroup lists.

Fixes: 0a6b76dd23fa ("mm: workingset: make shadow node shrinker memcg aware")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org> # 4.6+
---
 mm/workingset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index ac839fca0e76..eda05c71fa49 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -532,7 +532,7 @@ static int __init workingset_init(void)
 	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
 	       timestamp_bits, max_order, bucket_order);
 
-	ret = list_lru_init_key(&shadow_nodes, &shadow_nodes_key);
+	ret = __list_lru_init(&shadow_nodes, true, &shadow_nodes_key);
 	if (ret)
 		goto err;
 	ret = register_shrinker(&workingset_shadow_shrinker);
-- 
2.12.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
