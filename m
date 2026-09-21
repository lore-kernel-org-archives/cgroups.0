Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E056361DA6;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971393; cv=none; b=Lz6GNhLL6ZL+PUjfYK3CfmyvmOUz/0tYVrC45ldfiDOM3atIQluKv7Vhmvw/gZBJ2FzAKyoPCCvZBHC54g4fNIsn6UceK0MrSq5dfv68F8Bw4CZGLQ6dmop1zubRGzBrQxPBQ/dV3e4dWY3MBnUAVpsrL5Dqqke3Jb/QbgfjyOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971393; c=relaxed/simple;
	bh=goaapdMZ9AhxqIWhW85tY5V8jajiUFY3jjaPFkkKHjs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=O8cEqjmtJ/4SkpYjrFU1or9w0Z+ukyF1uTRu02/dtJ1gtlZiMpHTHH2CjXJgmQ87fa0WVz/u+n3JIL4xZ0qNs1mJn+JvxcgUUAlXFLAWOP0TlhzDezzsLZCJ+vi2LKsIWOVM92M/OiMk4wS17QWfWH65VtyOysamj/YuBlR2hf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VsJSDQoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsJSDQoj"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B0F5C2BCFC;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789971393;
	bh=goaapdMZ9AhxqIWhW85tY5V8jajiUFY3jjaPFkkKHjs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VsJSDQoj+V3FtURs2Y3RmxOPJs/Z/ypWeBw+BAs86L1lyJjXgLhmI5HJRDG5w5xMl
	 iRaWJNBpdrdlvpK66LHn0kDrsY0cp9EGT659yoF/v3JddsbBuhRFHpSNxGELtSaM1F
	 qaBpcl7MzSiz8WyvJUJyPHVmjO+94LoTguRSNWBNI1DVPQIW2y4Rj80zEC/KBmpiZ4
	 2hykgBPc7wgNZYRrexEzReOpXIYcKGGyp3TjTRZAyPmKH4q7IoQk4bjYbEl5ZFSBpI
	 VwQDU6Uvu9EhZH2k/hFo51cSjaLKTzZLYF/vz1oITFroF7ZVc85NKT3xn++mmVybhC
	 BjQg6G/Lzl4zQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C0AC982ED;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Mon, 21 Sep 2026 14:16:27 +0800
Subject: [PATCH v2 4/4] memcg: move memcg private ID refcount to objcg
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-bingfangguo-memcgid-rework-v2-4-6c0637dc0edb@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789971391; l=9479;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=aXhbLZU24XSfkf7X99DsJOXPFhB18u8ETT9g48kLTKw=;
 b=3JlCLO6RLQE71Z0ZoU6+JAfNEztaKGqONZDV+zrVY+mgXwrXcyIgPcUVrzvAAzGdA2WgRMkhx
 mM54MPFHWGCAG8fzRWTHUb41Xj0wqUyuS2KJsOTU/2jkANE8ioRsyqk
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

The memcg private ID is used by objects that can't afford storing a
whole pointer and can outlive memcgs to track the memcg (notably swap
entries). The current design holds a refcount to the css, preventing the
memcg from being freed.

This patch unbinds the lifetime of memcgid from the memcg so it can be
freed.  The idea is to move the refcount of memcgid to one of the
memcg's objcg. The objcg is stored in the global memcgid xarray instead
and used for retrieving the online memcg from it.  So swapped out pages
no longer pin the dying memcg.

After the change, a memcgid can refer to a non present memcg. To handle
this situation, when trying to get the original memcg from the id,
compare the memcgid passed in with that of the memcg, and return NULL to
indicate its death if they differ. NULL checks are added for
list_lru_walk_node(), workingset_test_recent() to skip dead memcgs. For
MGLRU recency test, mem_cgroup_lruvec() will substitute NULL with
root_mem_cgroup.

In the earlier patch, an extra xarray lookup was introduced in swap
uncharging path.  Now that we have the objcg pointer in the function,
the extra overhead can be removed by using it for putting directly.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 include/linux/memcontrol.h |  7 +++--
 mm/list_lru.c              |  2 +-
 mm/memcontrol.c            | 73 ++++++++++++++++++++++++++++++++++------------
 mm/workingset.c            |  2 +-
 4 files changed, 60 insertions(+), 24 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 46bf724cae7af..2041505a84ce2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -180,6 +180,7 @@ struct obj_cgroup {
 	struct percpu_ref refcnt;
 	struct mem_cgroup *memcg;
 	atomic_t nr_charged_bytes;
+	refcount_t private_id_ref;
 	union {
 		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
@@ -225,9 +226,6 @@ struct mem_cgroup {
 	/* vmpressure notifications. Written on every reclaim iteration. */
 	struct vmpressure vmpressure;
 
-	/* Written on every swap charge and uncharge. */
-	refcount_t private_id_ref;
-
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	/* MEMCG_KMEM for nmi context */
 	atomic_t		kmem_stat;
@@ -324,6 +322,9 @@ struct mem_cgroup {
 	unsigned long zswap_max;
 #endif
 
+	/* The objcg holding private memcg ID. */
+	struct obj_cgroup *private_id_objcg;
+
 	/* Private memcg ID. Used to ID objects that outlive the cgroup */
 	int private_id;
 
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 8a6dd0a489e12..7edd79113cc56 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -428,7 +428,7 @@ unsigned long list_lru_walk_node(struct list_lru *lru, int nid,
 		xa_for_each(&lru->xa, index, mlru) {
 			rcu_read_lock();
 			memcg = mem_cgroup_from_private_id(index);
-			if (!mem_cgroup_tryget(memcg)) {
+			if (!memcg || !mem_cgroup_tryget(memcg)) {
 				rcu_read_unlock();
 				continue;
 			}
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0dd398029057a..b74e50c7674f0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4074,6 +4074,13 @@ static void memcg_wb_domain_size_changed(struct mem_cgroup *memcg)
 #define MEM_CGROUP_ID_MAX	((1UL << MEM_CGROUP_ID_SHIFT) - 1)
 static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
 
+static inline struct obj_cgroup *obj_cgroup_from_private_id(unsigned short id)
+{
+	lockdep_assert_once(rcu_read_lock_held());
+
+	return xa_load(&mem_cgroup_private_ids, id);
+}
+
 static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 {
 	if (memcg->private_id > 0) {
@@ -4082,34 +4089,44 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
-static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+static void __mem_cgroup_private_id_put(struct obj_cgroup *objcg,
+		unsigned short id, unsigned int n)
 {
-	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
-		mem_cgroup_private_id_remove(memcg);
+	struct obj_cgroup *objcg_free;
 
-		/* Memcg ID pins CSS */
-		css_put(&memcg->css);
+	if (refcount_sub_and_test(n, &objcg->private_id_ref)) {
+		objcg_free = xa_erase(&mem_cgroup_private_ids, id);
+		VM_WARN_ON(objcg_free != objcg);
+
+		/* Memcg ID pins the objcg */
+		obj_cgroup_put(objcg);
 	}
 }
 
 static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
 {
-	struct mem_cgroup *memcg;
+	struct obj_cgroup *objcg;
 
 	lockdep_assert_in_rcu_read_lock();
 
-	memcg = mem_cgroup_from_private_id(id);
-	__mem_cgroup_private_id_put(memcg, n);
+	objcg = obj_cgroup_from_private_id(id);
+	__mem_cgroup_private_id_put(objcg, id, n);
 }
 
 static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
 {
-	__mem_cgroup_private_id_put(memcg, 1);
+	__mem_cgroup_private_id_put(memcg->private_id_objcg, memcg->private_id, 1);
 }
 
 unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
 {
-	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
+	struct obj_cgroup *objcg;
+
+	lockdep_assert_once(rcu_read_lock_held());
+
+	objcg = memcg->private_id_objcg;
+
+	while (!refcount_add_not_zero(n, &objcg->private_id_ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -4119,6 +4136,7 @@ unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int
 			break;
 		}
 		memcg = parent_mem_cgroup(memcg);
+		objcg = memcg->private_id_objcg;
 	}
 
 	return mem_cgroup_private_id(memcg);
@@ -4129,11 +4147,25 @@ unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int
  * @id: the memcg id to look up
  *
  * Caller must hold rcu_read_lock().
+ *
+ * @return: the memcg, or NULL if the memcg referred to is already dead.
  */
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 {
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *memcg;
+
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return xa_load(&mem_cgroup_private_ids, id);
+
+	objcg = obj_cgroup_from_private_id(id);
+	if (!objcg)
+		return NULL;
+
+	memcg = obj_cgroup_memcg(objcg);
+	if (mem_cgroup_private_id(memcg) != id)
+		return NULL;
+
+	return memcg;
 }
 
 struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
@@ -4380,9 +4412,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 
-	/* Online state pins memcg ID, memcg ID pins CSS */
-	refcount_set(&memcg->private_id_ref, 1);
-	css_get(css);
+	/* CSS pins memcg ID, memcg ID pins obj cgroup */
+	memcg->private_id_objcg = objcg;
+	refcount_set(&memcg->private_id_objcg->private_id_ref, 1);
+	obj_cgroup_get(memcg->private_id_objcg);
 
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
@@ -4394,7 +4427,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg, GFP_KERNEL);
+	xa_store(&mem_cgroup_private_ids, memcg->private_id, memcg->private_id_objcg, GFP_KERNEL);
 
 	return 0;
 free_objcg:
@@ -5832,8 +5865,6 @@ static void __init memcg_struct_check(void)
 				      memory_events_local);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
 				      vmpressure);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
-				      private_id_ref);
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_write_hot,
 				      kmem_stat);
@@ -5878,6 +5909,8 @@ static void __init memcg_struct_check(void)
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      zswap_writeback);
 #endif
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      private_id_objcg);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      private_id);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
@@ -6013,10 +6046,12 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
  */
 void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 {
+	struct obj_cgroup *objcg;
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
+	objcg = obj_cgroup_from_private_id(id);
+	memcg = obj_cgroup_memcg(objcg);
 	if (memcg) {
 		if (!mem_cgroup_private_id_is_root(id)) {
 			if (do_memsw_account())
@@ -6025,7 +6060,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(id, nr_pages);
+		__mem_cgroup_private_id_put(objcg, id, nr_pages);
 	}
 	rcu_read_unlock();
 }
diff --git a/mm/workingset.c b/mm/workingset.c
index 8412f4840ae35..1504f91cdca5f 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -470,7 +470,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_private_id(memcgid);
-	if (!mem_cgroup_tryget(eviction_memcg))
+	if (eviction_memcg && !mem_cgroup_tryget(eviction_memcg))
 		eviction_memcg = NULL;
 	rcu_read_unlock();
 

-- 
2.43.7


