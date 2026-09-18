Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B73547046;
	Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723140; cv=none; b=lUv/Rzef9At3oDJa8lW6eZlE38eITQ4rKq/SdYbKG8lVnKHhqy7MuuXjVZZ5vMHf9ioY/Ct8LlspWw+d2+Y4YVa0qrqupceX+24ZF/fGDbcF3Vx0VFCkcRIKBnHQAC6wr0U9KxN0if4nhXhH7Y00MnOvkC8mgJH2pKqURzayB70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723140; c=relaxed/simple;
	bh=C+aZ/PHCHVwPqKCsmHIkGeCsoWqK7M+a2bgJxBzAS6s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O1k3YmdHNPk4+d5MbZlrJEwqpNe6lzRXmA//fMYj2acDfxECly03NQ93Q8s9JuBrLiIgUvsw2X4X95ihCNLpe5okAaD2g/fXRd1znM8GVWX0ILI76mGWt1wTq0Y+RBk1xZeoRJobU9+ham7ursp6E3P7qo6b/PQX6I6q383ULTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mxOSpZGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mxOSpZGv"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F363BC4AF09;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789723140;
	bh=C+aZ/PHCHVwPqKCsmHIkGeCsoWqK7M+a2bgJxBzAS6s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mxOSpZGvxT5tYcAJ4npmZNQ/Puq3w5SG3WfTQCbiiOIAmw3u8QDC2Yuyhf4ZAhUOD
	 onO3v5MGj/LLjoG/rFOYp2Gr104VKE1T7hDU4QGQGYjlKpjz+vuCefZw8Z5MW7Ws5H
	 ivKgAlz26wZEeaWtFsy0SBOiOfS/d9cLGCAacop1KR/6BIPr3H0lZKQVcunF4nQzUf
	 dk5dbruLON7jjz/HUgEDJhmHd/LJ9rFGVkAIUNwrQKjmPjCDpzFgd7q1+8cNVDTY6x
	 OoxZLMfgaDLaU2YUYrIyqMGCr+1uTEzFqlqsuaGydBO0ZbwOUHERi3M1OBII51xOhH
	 WD/EvHOp9FQAQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF0AC982DC;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 17:18:42 +0800
Subject: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789723137; l=5810;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=6P3XefKks8CnjRxUmQqiyNUvDBHLa0aO+gsTJIsTI0E=;
 b=Pvgko5tDjB9FVjV0Ty8Jov0miIgcIg+4+4UcwUj5o0qs+t4mPU7JmBhHLFt3MlZtZXEjOur5N
 fqGR0rot3OvDoSYo0FqJpwOZsycCmkYXA0blmpFz2v9EdJBp2kcKO/G
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

This is a preparatory work for moving memcgid from memcg to objcg.

Swap entries retain a private ID rather than a memcg pointer. Once
private ID references are moved to objcgs, the ID can also outlive the
memcg to which it was originally assigned.  So it's better to make the
get and put functions accept the ID itself instead of the memcg.

Rename mem_cgroup_private_id_get_online() to
mem_cgroup_private_id_get(), and make it return the ID only.  If the
memcg is already dying, the dying memcg will still be used for charging
and stats accounting in v2 swap charging path. But they are hierarchical
and will be reparented after offlining so it doesn't matter.

Make mem_cgroup_private_id_put() take the ID and resolve the reference
holder internally. Convert swap uncharge and charge rollback to release
the reference using that ID.  This introduces an extra xarray lookup for
now, which will be removed in the final patch.

Separate the online-state reference release into
mem_cgroup_private_id_kill(). The offline path already has the memcg
pointer and can call the underlying put helper directly.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol-v1.c |  7 +++----
 mm/memcontrol-v1.h |  3 +--
 mm/memcontrol.c    | 32 +++++++++++++++++++++++---------
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index ed015fdd95123..b7f2868885071 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -268,7 +268,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
  */
 void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 {
-	struct mem_cgroup *memcg, *swap_memcg;
+	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
 	unsigned short private_id;
@@ -298,9 +298,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	 * if the ID refers to the root memcg.
 	 */
 	nr_entries = folio_nr_pages(folio);
-	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
-	private_id = mem_cgroup_private_id(swap_memcg);
-	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
+	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
 
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
 
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 23be2512702dc..281425273ea97 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -27,8 +27,7 @@ static inline bool mem_cgroup_private_id_is_root(unsigned short id)
 	return id == mem_cgroup_private_id(root_mem_cgroup);
 }
 
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
-						    unsigned int n);
+unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 				       struct mem_cgroup *parent, int idx);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bfe53e4392f09..ed44b3e7ac938 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4082,7 +4082,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
 		mem_cgroup_private_id_remove(memcg);
@@ -4092,7 +4092,22 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
 	}
 }
 
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
+static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	__mem_cgroup_private_id_put(memcg, n);
+	rcu_read_unlock();
+}
+
+static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
+{
+	__mem_cgroup_private_id_put(memcg, 1);
+}
+
+unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
 {
 	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
 		/*
@@ -4105,7 +4120,8 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
 		}
 		memcg = parent_mem_cgroup(memcg);
 	}
-	return memcg;
+
+	return mem_cgroup_private_id(memcg);
 }
 
 /**
@@ -4430,7 +4446,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_private_id_put(memcg, 1);
+	mem_cgroup_private_id_kill(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5972,15 +5988,13 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	/* memcg is pined by memcg ID. */
-	private_id = mem_cgroup_private_id(memcg);
+	private_id = mem_cgroup_private_id_get(memcg, nr_pages);
 
 	if (!mem_cgroup_private_id_is_root(private_id) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		mem_cgroup_private_id_put(private_id, nr_pages);
 		rcu_read_unlock();
 		return -ENOMEM;
 	}
@@ -6013,7 +6027,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		mem_cgroup_private_id_put(id, nr_pages);
 	}
 	rcu_read_unlock();
 }

-- 
2.43.7


