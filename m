Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B274442FB2;
	Thu, 13 Aug 2026 08:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611133; cv=none; b=Kqi2PrApvZpUxnbOc9Kp+czal5FZpVQ5AGLGorYOvlPysjHG3a+0PwGRSkcXT6eimJ/0mDhKK5LoKif6cAM6W0nKAykuqac80v9MeODiPZuzUIoY7J1+EgNpqT8N++vksEZqz5HghiKgZShN46npeC7x+N0SnQPssgVXe2gNTjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611133; c=relaxed/simple;
	bh=meapVXEGFdDb6NF7sii95w8iasCv07pp1/gAqS5rawg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d+x4+msaA1Gw+iqUGJoqguhdxFFN3azKOiM2OT9yrVQpKyuHEEo4lGKI5sdaCm0Damz425UN9h+weCkt7kJeYywwgmNfk5ynaTwvMoINCqq6G9i7RaWwwpc0OdlqT7TPTLAQ1xvu0mHh0Pm8aDZB0ZC3YLP6gwZqPD+jCK7wmZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fF3ITC1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fF3ITC1F"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2653C2BD04;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786611132;
	bh=meapVXEGFdDb6NF7sii95w8iasCv07pp1/gAqS5rawg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fF3ITC1FGfkSq+//ZPnwjAjYDzwqhnID02bRoPebzrOkwCsZkcIoaLMNULErC4KM/
	 J4HjoSjFkzSgDho8I3gN+xfJGQtvFyq/UuIwnHVUeXUJLroRG0jg0cZV9gKBw+1NmM
	 LH59MDg4B8EiF1uFv4ZCuqOyP5a6IVByqZO59CIinw1Ti9wy46GK5YWHmcrKO0Rzun
	 xDW/71H7UFy8nFxLvVDPhn3txw2pPMdlOBCIbHMzLpHqgkK7oELkFSDPJneKoOLB85
	 1v1WCRmMPEHpAyZv9pikwgrcFqx07I6Ikzefyg4+wrVawxS8Egz8SDX4dGTnEgUEoH
	 4K6ab0qMorjpQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F93C5DF67;
	Thu, 13 Aug 2026 08:52:12 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 16:52:06 +0800
Subject: [PATCH RFC 5/5] memcg: filter out reparented memcgs got using
 memcgid
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-memcgid-objcg-v1-5-83d21c685b77@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786611130; l=2805;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=zY1JXeipRRE4x+8HShYlKEllHTJG9Rn8M3UwjRUwSJk=;
 b=CusELUTT7HqgDWh2KGQvd8fGGqtxEXggEBLMydLTG5KzIJxwbuc5HVMPhaTVT/r1MjFsRGMGg
 Wp/8xlAWmeCC0QRq+pJq/R8DkaLIDm1Gd2BHzegRT2mnbwkdEmg/i4o
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

mem_cgroup_from_private_id() looks up the objcg that owns the id and
returns the objcg's current memcg.  After reparenting, that memcg can
differ from the one the id originally belonged to.

Callers such as the list lru and workingset refault code expect to get
back exactly the memcg referred to by the memcgid, so check that the
returned memcg still owns the id and return NULL otherwise, letting
the callers skip the entry.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/list_lru.c   | 2 +-
 mm/memcontrol.c | 9 ++++++++-
 mm/workingset.c | 6 +++++-
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..bc956267f6835 100644
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
index fdf2e0d1f17e5..e7555eca77019 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3999,17 +3999,24 @@ void mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
  * @id: the memcg id to look up
  *
  * Caller must hold rcu_read_lock().
+ *
+ * @return: the memcg, or NULL if the memcg is already reparented.
  */
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
 {
 	struct obj_cgroup *objcg;
+	struct mem_cgroup *memcg;
 	WARN_ON_ONCE(!rcu_read_lock_held());
 
 	objcg = xa_load(&mem_cgroup_private_ids, id);
 	if (!objcg)
 		return NULL;
 
-	return obj_cgroup_memcg(objcg);
+	memcg = obj_cgroup_memcg(objcg);
+	if (mem_cgroup_private_id(memcg) != id)
+		return NULL;
+
+	return memcg;
 }
 
 /**
diff --git a/mm/workingset.c b/mm/workingset.c
index f351798e723ac..b6e22536a5240 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -283,6 +283,10 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 	memcg = mem_cgroup_from_private_id(memcg_id);
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
+	/* reparented memcg loses its max_seq */
+	if (!memcg)
+		return false;
+
 	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
 	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_WIDTH;
 
@@ -470,7 +474,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_private_id(memcgid);
-	if (!mem_cgroup_tryget(eviction_memcg))
+	if (!eviction_memcg || !mem_cgroup_tryget(eviction_memcg))
 		eviction_memcg = NULL;
 	rcu_read_unlock();
 

-- 
2.43.7


