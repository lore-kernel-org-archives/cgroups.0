Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B47D33D4E4;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971393; cv=none; b=qFzeYgp1HIDCSCMGBsU6VqBC2PG0D0vhXCyHZkrK/IZrUTNosOakyL3Z9e09buftpwuZ50yZRYiDEQGjJ0uqzp67yvK3SnLNBj60wSyjnoKVlV3CpRKxyAQTj5nITGPvZ+8+mq8HGrPHLeduq5yqvdheQSYUkQvkbMLngzKg1Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971393; c=relaxed/simple;
	bh=U6IJBz+i/+RpNC92aGMPddAzaye9fft8TYEREBbrLpI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bHZrVmxhRIwOQLdWM8Bl2jip/ZxKhzKNExr7ICS5YspGCyY+IVwjs+14Zkq41IFoQTO/TJxwUSU8KsiwvPm6268XksqyIcBbCIkDIWpDtBCrpr6bu7smS0ijMNfAwvb7Y90F762Asoz2WvOu4YObR5nBIsX1Av9i4TuCFL/IEWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8nwYHGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8nwYHGR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20A78C2BCFF;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789971393;
	bh=U6IJBz+i/+RpNC92aGMPddAzaye9fft8TYEREBbrLpI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R8nwYHGRDyg8Spm/+MaxA2+4GfQH+EUu9wf2wHkkHlPBxp4MRLKBdEl+/Ahq2vqXU
	 DlFcSIIuTasHG4dTPROTgqY2acGgTznEuF4fdx40QnFq8E1SGaEznRZxH14G0Dkx/T
	 D50Uon7SgI+ST180fQsIkKi2HX4olrEz35cab/IJ+tEkLoPgfeJ2q1CfOooEPPPEUl
	 ymoRRljLiewy1wqT5HDRrFST7AEFSd8qMnMEQO6+eb3Fnvdlg37jatYQQRapPn9Gwe
	 IgONgo4RU8Khjow7KrhhSq0Nf3nxj9PKTjKKLGLTio7nmq2IyHM0SjPsRO3GOWxWTV
	 YGyIt6nYuosAA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05422C982F1;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Mon, 21 Sep 2026 14:16:26 +0800
Subject: [PATCH v2 3/4] memcg: manipulate memcg private ID references by ID
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-bingfangguo-memcgid-rework-v2-3-6c0637dc0edb@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789971391; l=5897;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=E/d7cKYlZS695bYLUx8GLbGIAsbKGpTfoYLw2/gVq1I=;
 b=Wm3yHxcAKRDeuCKrXxNXOuYN8MX6LQ9zMhjOChRyOsyEUMDxBxGHZ7daRvab31sh43CXhE+II
 R2DnCOPlJJjByjCUTUIyA0SEyd8nnDOGHmLX8/mjtrbu7GFWOi6cDm7
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
Acked-by: Muchun Song <muchun.song@linux.dev>
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
index aedac862fe254..0dd398029057a 100644
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
+	lockdep_assert_in_rcu_read_lock();
+
+	memcg = mem_cgroup_from_private_id(id);
+	__mem_cgroup_private_id_put(memcg, n);
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
@@ -5971,15 +5987,13 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 			return 0;
 		}
 
-		memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-		/* memcg is pined by memcg ID. */
-		private_id = mem_cgroup_private_id(memcg);
+		private_id = mem_cgroup_private_id_get(memcg, nr_pages);
 
 		if (!mem_cgroup_private_id_is_root(private_id) &&
 		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-			mem_cgroup_private_id_put(memcg, nr_pages);
+			mem_cgroup_private_id_put(private_id, nr_pages);
 			return -ENOMEM;
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
@@ -6011,7 +6025,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
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


