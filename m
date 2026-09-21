Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4F5348C66;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971393; cv=none; b=WB/oilJumNoPfM4hsn6jtEya4aIVRNPSpAnvrsYxUSr0aJn8KSR4lhTH4bklgx3uvZahfvB/qzKEEpgjiHK7F80ku/va80NMkn54O74PJelgVqX+f/bRU5pziC64DWHgPZe5AsuGxp0Ci0gXOjJm2OqFIL+dAPloPEws4KdUm3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971393; c=relaxed/simple;
	bh=ZUzMmbQpUdGk2onbydCh5L+k5zmd1xMeNqBbCinbBRE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=NrJKnd2iP9/OaAhRbpQJ98kU3sHUzipne/Cq7x1J9kq5mnoqLC3wU1j2DDbfoHOkc5RQOiXsrI0DMCUkUEJLj/kC+MCWY3H1HgdVt/82SM2KWapOECEBBaMhVks7+QSvPfMcb2XUE8IpbsX98zZxtwBt0gr7rzjkyL+fGxwI0sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mZdKqySA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mZdKqySA"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 015A4C2BCF6;
	Mon, 21 Sep 2026 06:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789971393;
	bh=ZUzMmbQpUdGk2onbydCh5L+k5zmd1xMeNqBbCinbBRE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mZdKqySApf4RZ48SjtA/U8c78d7SzuJAICSaNwPSpR2V7q+yciJsXGTczr3qeSB/z
	 tz+yv06lGv/Mud/zVSClnAPSJKMUnc4zPlpX2sU3R2cxOMABGrcNw2ljTIFaEBgKMP
	 53O7gdCM+1Rdh0D7kZ/ioerAMOD7jl56vm5BouH041+zTxFesvsvkKFIir816X9IY/
	 uSvzfp3Aj5cVnduVxELXRhx+42Taf5Lqaib3MsBucceJQx+d3KlF5dCdxc957YZnaw
	 TY01X1pFNrfiLOgRALffMe8ls32QTkTU9ucge36Na6YoY7vIVnOefkOTZaYmUJnCVw
	 vdYeQx+DFwW7w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48F5C982E1;
	Mon, 21 Sep 2026 06:16:32 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Mon, 21 Sep 2026 14:16:24 +0800
Subject: [PATCH v2 1/4] memcg: keep swap charging under RCU protection
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-bingfangguo-memcgid-rework-v2-1-6c0637dc0edb@tencent.com>
References: <20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com>
In-Reply-To: <20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789971391; l=2959;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=sE3zMklqkcFz3uR1w6qomhpryX2R8nExKsjfG+k30bI=;
 b=jYqZPOQzuqXt3gG9v8XXM4BalCcLyDqai9BvgC5xpefOPP5WMa23il4SGzRfiEbjc9+PIIj0H
 GvQ5nU6AAg/DDtdj1U5G90CxDuQBHe6GOo2QGChpb/L3eR4heGMLTma
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

This is a preparatory work for unbinding memcgid from memcg. No
functional change.

The swap charging path currently drops its RCU read lock after acquiring
a private ID reference. This is safe because the ID reference pins the
memcg's CSS.  After ID references are moved to pin objcgs, that lifetime
guarantee will no longer hold.

Keep the RCU read lock held while accessing the memcg for counter
charging, statistics and failure handling. (This matches what
__memcg1_swapout() already does).  Save the private ID for swap memcg
recording before dropping the RCU read lock. So the swap cluster locking
remains outside the RCU read-side critical section.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 mm/memcontrol.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 791e536efaebe..981a231a76129 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5954,6 +5954,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short private_id;
 
 	if (do_memsw_account())
 		return 0;
@@ -5963,30 +5964,29 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	if (!objcg)
 		return 0;
 
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	if (!folio_test_swapcache(folio)) {
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		rcu_read_unlock();
-		return 0;
-	}
+	scoped_guard(rcu) {
+		memcg = obj_cgroup_memcg(objcg);
+		if (!folio_test_swapcache(folio)) {
+			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+			return 0;
+		}
 
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	/* memcg is pined by memcg ID. */
-	rcu_read_unlock();
+		memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+		/* memcg is pined by memcg ID. */
+		private_id = mem_cgroup_private_id(memcg);
 
-	if (!mem_cgroup_is_root(memcg) &&
-	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
-		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
-		return -ENOMEM;
+		if (!mem_cgroup_is_root(memcg) &&
+		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
+			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+			mem_cgroup_private_id_put(memcg, nr_pages);
+			return -ENOMEM;
+		}
+		mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 	}
-	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
-			  mem_cgroup_private_id(memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
 	swap_cluster_unlock(ci);
 
 	return 0;

-- 
2.43.7


