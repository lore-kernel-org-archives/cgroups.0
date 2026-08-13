Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0054374E5B;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611133; cv=none; b=WS6AMPh+ey8lmaAyp7OHheYb5Ptve1NV6Abqt9ggmEtgtUyHsTQizzpIo+emQ9oqRIuvfDXR4r5yvUYVs5Vcg7Mf9FvMJa18Mbf3ztI9mUDw3FYKCJ+37vpZQEDnRowRFWaaJziqk6HMxmwyOD+OtK9YAvBy0wdUg5dxBXPzM5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611133; c=relaxed/simple;
	bh=/jY3lCvj/S6s/mtmnK+py0Ta55+PVDMUn3Xj23a2mm0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FIOPPmE/1tmLQyQszeshINuPQYovPpz/kV+eDu9P3I2BqQ7lV6kVoO4QkrklAm8asMIyZZUkH9b36IucQ1iWD6uYWBnhrTP6J+q5iKqGpGBtIkorBdTHerCluUz4TJGNs8AWDxNFUnEw93dWMChPUcLn7/T4OKnTERGJkWslRpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MG30tG0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MG30tG0j"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EBC9C2BCF6;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786611132;
	bh=/jY3lCvj/S6s/mtmnK+py0Ta55+PVDMUn3Xj23a2mm0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MG30tG0jIAAQO2Ms23J181a/6qTNlDEYvNG5iUsZ7Qz0g/wihw24Na1LKrGju3ORc
	 BEaLfFTEPlqQVhqZJLgm6kPMqXp7/rmT5K2fn86gfLsLSXsFR9bBDRHPM2Ne1RnfxV
	 ImdPv5IN2lK2NY/lBp2mLFp1nBjEYNA1MYESY6Cb1GEvNr7Kags3r7XGOfv2Kw+IzV
	 lbsFmj/ix9YtbOFDTVi9QPty6BwWEQbSXUnRN8/XSyi3FFj4p8z4aP+JZ6ustXBlOp
	 0qJYLaajY9wtQMyDcvKppGMwiD7SXh5w5XnrlCvlYwKCjt7yZDrS3B6rMuW6BfWTy7
	 3g7fhapR9qMSA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3DAC5AC67;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 16:52:02 +0800
Subject: [PATCH RFC 1/5] memcg: move memcg private ID refcount to objcg
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-memcgid-objcg-v1-1-83d21c685b77@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786611130; l=8568;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=OoA5ZvY6U2Ek43M1DA077LOuBUDVK9W5rd1MBAq9D6g=;
 b=NwGka+2hgzQ2Y53VCMURN987ApMGmBKou7N9EagAAGcK2Q2VVI1BH6fu3bLRHKx9tvNOph6Lt
 eXCDryxHaP5CdWdcA+uqx7j5Po2BLAQ14+bFpf6rPcRc1GuJt1MoIGm
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

In the previous series by Muchun Song and Qi Zheng, folios are charged
to the objcg and reparented as the memcg offlines. Same can be done to
memcg private ID and its main user: swap entries. Make the memcgid
xarray hold a pointer and a reference to an objcg of the memcg, which is
used to find the memcg (or its parent) later on. The online state now
pins the objcg instead of the css, so swapped out pages no longer pin
the dying memcg.

The id reference held by the online state is released in css_released()
after reparenting instead of in css_offline(). This is the key
invariant the rest of the series builds on: css_offline() runs while
other css references may still be held, but css_released() only runs
once the last reference is gone, so a caller holding a memcg reference
can always count on the id refcount being alive. To prevent races
between memcgid put in css offline and memcgid get, the release is put
off till css_released, which could delay the release of the memcgid and
the objcg it pins, but overall it should be fine.

After reparenting, the objcg points to a live ancestor, so
mem_cgroup_from_private_id() now returns that ancestor instead of the
memcg the ID originally belonged to. Callers that need the exact memcg
are fixed in patch 5.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 include/linux/memcontrol.h | 10 +++--
 mm/memcontrol.c            | 99 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 76 insertions(+), 33 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8170bb8066a22..c33ec7efad50b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -191,6 +191,7 @@ struct obj_cgroup {
 		struct rcu_head rcu;
 	};
 	bool is_root;
+	refcount_t id_ref;
 };
 
 /*
@@ -202,8 +203,8 @@ struct obj_cgroup {
 struct mem_cgroup {
 	struct cgroup_subsys_state css;
 
-	/* Private memcg ID. Used to ID objects that outlive the cgroup */
-	struct mem_cgroup_private_id id;
+	/* The objcg holding private memcg ID. */
+	struct obj_cgroup *id_objcg;
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
@@ -270,6 +271,9 @@ struct mem_cgroup {
 #endif
 	int kmemcg_id;
 
+	/* Private memcg ID. Used to ID objects that outlive the cgroup */
+	int id;
+
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -820,7 +824,7 @@ static inline unsigned short mem_cgroup_private_id(struct mem_cgroup *memcg)
 	if (mem_cgroup_disabled())
 		return 0;
 
-	return memcg->id.id;
+	return memcg->id;
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23a..5f30e76ee93d7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3697,7 +3697,7 @@ static void memcg_online_kmem(struct mem_cgroup *memcg)
 
 	static_branch_enable(&memcg_kmem_online_key);
 
-	memcg->kmemcg_id = memcg->id.id;
+	memcg->kmemcg_id = memcg->id;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
@@ -3956,25 +3956,40 @@ static DEFINE_XARRAY_ALLOC1(mem_cgroup_private_ids);
 
 static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 {
-	if (memcg->id.id > 0) {
-		xa_erase(&mem_cgroup_private_ids, memcg->id.id);
-		memcg->id.id = 0;
+	if (memcg->id > 0) {
+		xa_erase(&mem_cgroup_private_ids, memcg->id);
+		memcg->id = 0;
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+/**
+ * @objcg: the objcg returned by mem_cgroup_private_id_objcg
+ * @id: the corresponding memcg private id
+ */
+static void __mem_cgroup_private_id_put(struct obj_cgroup *objcg,
+		unsigned short id, unsigned int n)
 {
-	if (refcount_sub_and_test(n, &memcg->id.ref)) {
-		mem_cgroup_private_id_remove(memcg);
+	struct obj_cgroup *objcg_free;
 
-		/* Memcg ID pins CSS */
-		css_put(&memcg->css);
+	if (refcount_sub_and_test(n, &objcg->id_ref)) {
+		objcg_free = xa_erase(&mem_cgroup_private_ids, id);
+		VM_WARN_ON(objcg_free != objcg);
+
+		/* Memcg ID pins the objcg */
+		obj_cgroup_put(objcg);
 	}
 }
 
+static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+{
+	__mem_cgroup_private_id_put(memcg->id_objcg, memcg->id, n);
+}
+
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
 {
-	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
+	struct obj_cgroup *objcg = memcg->id_objcg;
+
+	while (!refcount_add_not_zero(n, &objcg->id_ref)) {
 		/*
 		 * The root cgroup cannot be destroyed, so it's refcount must
 		 * always be >= 1.
@@ -3984,6 +3999,7 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
 			break;
 		}
 		memcg = parent_mem_cgroup(memcg);
+		objcg = memcg->id_objcg;
 	}
 	return memcg;
 }
@@ -3996,8 +4012,29 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
  */
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 {
+	struct obj_cgroup *objcg;
 	WARN_ON_ONCE(!rcu_read_lock_held());
-	return xa_load(&mem_cgroup_private_ids, id);
+
+	objcg = xa_load(&mem_cgroup_private_ids, id);
+	if (!objcg)
+		return NULL;
+
+	return obj_cgroup_memcg(objcg);
+}
+
+static struct mem_cgroup *mem_cgroup_take_from_private_id(unsigned short id, unsigned int n)
+{
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *memcg;
+
+	objcg = xa_load(&mem_cgroup_private_ids, id);
+	if (!objcg)
+		return NULL;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+
+	__mem_cgroup_private_id_put(objcg, id, n);
+	return memcg;
 }
 
 struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
@@ -4098,7 +4135,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
 
-	error = xa_alloc(&mem_cgroup_private_ids, &memcg->id.id, NULL,
+	error = xa_alloc(&mem_cgroup_private_ids, &memcg->id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
 	if (error)
 		goto fail;
@@ -4243,9 +4280,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 				   FLUSH_TIME);
 	lru_gen_online_memcg(memcg);
 
-	/* Online state pins memcg ID, memcg ID pins CSS */
-	refcount_set(&memcg->id.ref, 1);
-	css_get(css);
+	/* CSS pins memcg ID, memcg ID pins obj cgroup */
+	memcg->id_objcg = memcg->nodeinfo[0]->objcg;
+	refcount_set(&memcg->id_objcg->id_ref, 1);
+	obj_cgroup_get(memcg->id_objcg);
 
 	/*
 	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
@@ -4257,7 +4295,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 * publish it here at the end of onlining. This matches the
 	 * regular ID destruction during offlining.
 	 */
-	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
+	xa_store(&mem_cgroup_private_ids, memcg->id, objcg, GFP_KERNEL);
 
 	return 0;
 free_objcg:
@@ -4308,8 +4346,6 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	lru_gen_offline_memcg(memcg);
 
 	drain_all_stock(memcg);
-
-	mem_cgroup_private_id_put(memcg, 1);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -4318,6 +4354,9 @@ static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
 
 	invalidate_reclaim_iterators(memcg);
 	lru_gen_release_memcg(memcg);
+
+	mem_cgroup_private_id_put(memcg, 1);
+	memcg->id_objcg = NULL;
 }
 
 static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
@@ -5651,19 +5690,19 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 {
 	struct mem_cgroup *memcg;
 
-	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
-	if (memcg) {
-		if (!mem_cgroup_is_root(memcg)) {
-			if (do_memsw_account())
-				page_counter_uncharge(&memcg->memsw, nr_pages);
-			else
-				page_counter_uncharge(&memcg->swap, nr_pages);
-		}
-		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+	memcg = mem_cgroup_take_from_private_id(id, nr_pages);
+	if (!memcg)
+		return;
+
+	if (!mem_cgroup_is_root(memcg)) {
+		if (do_memsw_account())
+			page_counter_uncharge(&memcg->memsw, nr_pages);
+		else
+			page_counter_uncharge(&memcg->swap, nr_pages);
 	}
-	rcu_read_unlock();
+	mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
+
+	mem_cgroup_put(memcg);
 }
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)

-- 
2.43.7


