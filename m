Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF4B32B114;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611133; cv=none; b=drv8tCF5kpd2+4PwH4rINv+RwKMcUTB96KKvenjgjjtmYp9wMhyHJYAoQzxnV0IIyyaVrgftvUO1fygaOfqrbQ/kOCv7ZXW4TK65WRBeZ4+7trTMsysrXejyMspP8o32lnS7mHe+GhWnwdJDajO4iydKuMrDDmv3mXvzChBszS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611133; c=relaxed/simple;
	bh=kR5zbkSvv/RlKYuZXiHgRuu0UFnNidkDfN2007OyReY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JlZiHeRQq/6rBrwg29ENcG77LN5mRxIkvGvJ0T3yYl07DUNcpP5Q2NUQx2EYriqrhltsOD1nFJL3kGP7QScv8FBVcEM6lN2Edw7EXsDSgM4gVOvYL4wK4CPt5ltInaZ3+Vm39Sz/O29KZIuQ+UdEYB+rqYNBC9xTc2zIfQwNZKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfP6jZ1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfP6jZ1g"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB260C2BCF7;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786611132;
	bh=kR5zbkSvv/RlKYuZXiHgRuu0UFnNidkDfN2007OyReY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=RfP6jZ1ggMa6trUcUGQtCnAYEDpNKuCrnzBMVI5PbQIOu9Xzi6sfL9dnF6vFsVEFu
	 +Xy9acYBGaWqIXo9XIYkcJqrZK1Rn0USRIjDu3py131+38MIq/SpGi5Ob4ltsBRN4n
	 MEg4iKW99OT+2Ne7qVFsqWsJOGwZdB0Jlfv5EN0oQHhk4Bl/o014To5HR3fKHRgNqT
	 ELFNsRYpztYG+EdSGTs4Z1JPWzDErROInTyz4uOS7Yz0bIMjmwE2SYK0PAg46gSP1U
	 M0ok0XuDrdfFvdgndo6P2fWpDEO39+cE5PfaQmmjxtl3eLFy9aZ9+6zEO2Src/KbbJ
	 3b5XjEjRsXSRw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F204C5CFDB;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 16:52:03 +0800
Subject: [PATCH RFC 2/5] memcg: get stable memcg first before getting
 memcgid reference
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-memcgid-objcg-v1-2-83d21c685b77@tencent.com>
References: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
In-Reply-To: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bfguo@icloud.com>, 
 Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786611130; l=4263;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=jO1EJ+YiSvB3LpF8HaBSpgO3Wgmvg81030gxkA7owJQ=;
 b=IuoSLuzL/85amN4CY0wJlbVtvGU0mcWEE5s5ZLz/r+pG0gu1bd9lArAGvkUhpLoBQdNeOaZQn
 /8mlXbtlBnPBY0MdmBu+DAQ0AO/qUgV3bOyPNMKrDjv8rLi+hCRWcs4
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

Storing the memcg private ID in a swap entry used to take the ID
reference under the RCU read lock and rely on
mem_cgroup_private_id_get_online() to hand back a usable (possibly
parent) memcg.

Now that the ID refcount lives on the objcg and stays alive until
css_released(), holding a memcg reference is enough to pin the ID. Both
__memcg1_swapout() and __mem_cgroup_try_charge_swap() take a stable
memcg reference first via get_mem_cgroup_from_objcg() and pin the ID
afterwards, dropping the rcu_read_lock() usage and the get-error-put
handling, and recording exactly the memcg the folio belongs to in the
swap entry.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol-v1.c | 23 +++++++++--------------
 mm/memcontrol.c    |  9 ++++++---
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 2dc599484d006..a913d32ad1e17 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -618,7 +618,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
  */
 void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 {
-	struct mem_cgroup *memcg, *swap_memcg;
+	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
 
@@ -638,19 +638,20 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	if (!objcg)
 		return;
 
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
 	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
-	 * ancestor for the swap instead and transfer the memory+swap charge.
+	 * ancestor for the swap instead.
 	 */
+	memcg = get_mem_cgroup_from_objcg(objcg);
 	nr_entries = folio_nr_pages(folio);
-	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
-	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
+
+	/* we have a reference to it, so we should get exact memcg itself */
+	mem_cgroup_private_id_get_online(memcg, nr_entries);
 
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
-			  mem_cgroup_private_id(swap_memcg));
+			  mem_cgroup_private_id(memcg));
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
@@ -658,12 +659,6 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	if (!obj_cgroup_is_root(objcg))
 		page_counter_uncharge(&memcg->memory, nr_entries);
 
-	if (memcg != swap_memcg) {
-		if (!mem_cgroup_is_root(swap_memcg))
-			page_counter_charge(&swap_memcg->memsw, nr_entries);
-		page_counter_uncharge(&memcg->memsw, nr_entries);
-	}
-
 	/*
 	 * The caller must hold the swap cluster lock with IRQ off. It is
 	 * important here to have the interrupts disabled because it is the
@@ -675,7 +670,7 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	preempt_enable_nested();
 	memcg1_check_events(memcg, folio_nid(folio));
 
-	rcu_read_unlock();
+	mem_cgroup_put(memcg);
 	obj_cgroup_put(objcg);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5f30e76ee93d7..a210fe2501219 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5660,24 +5660,27 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	/* memcg is pined by memcg ID. */
+	memcg = get_mem_cgroup_from_objcg(objcg);
 	rcu_read_unlock();
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		mem_cgroup_put(memcg);
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
+	/* we have a reference to it, so we should get exact memcg itself */
+	mem_cgroup_private_id_get_online(memcg, nr_pages);
+
 	ci = swap_cluster_get_and_lock(folio);
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
 			  mem_cgroup_private_id(memcg));
 	swap_cluster_unlock(ci);
 
+	mem_cgroup_put(memcg);
 	return 0;
 }
 

-- 
2.43.7


