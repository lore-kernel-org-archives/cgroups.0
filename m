Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4CF47669B;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788253097; cv=none; b=liUqf8oP9qSA9gJyWrNW9mFwHSaMdvJjw79DU2xnVb37Ge4roU5ZkkWugrc/jsQ0bn8scw3b712fdg0oTGoomv8roqEw2j89vFlIoXXSOQDF+akJNLOdhNssxToCExXO2r0D/y9dVt4lMahRuOhamEsrZjzcxDjxSBFaOpZcu6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788253097; c=relaxed/simple;
	bh=RhjZ8Agl3sbbRZCe+duMO20xLmPNeawkGM6PaCP7BIU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mGHucXi8N2/eABPM0I/4xvzD5LHQgQmThnnEJnNJkM7Zezz2NvzpSxWAPjQ4JTWaSfg1pWJ9dotLegXj/jDGZkpWAsa/fhriu5f8mIGBwAUalIpw/6R5t2nrRL+mltJ9puiri6ckcCJtQm4jgZVO+0ROcp6VGVH/jciRgv4l3iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eNWnrYfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eNWnrYfv"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 34C27C2BCF5;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253097;
	bh=RhjZ8Agl3sbbRZCe+duMO20xLmPNeawkGM6PaCP7BIU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eNWnrYfvyw2Nw5Ae/WmE6KRgB71Jmk+QUTfqxG0E0jixwesnQjD286+bgs/Nvdlfj
	 JQeNVGKl8C5wwutpJCWWcf9U+ZCTtimqNGsIYzcE8SYk056VbTH1qjVxo5vHkFsyd0
	 Cg0TsSSs1sdFrqf7Yh9/2RrnyTCGy9IvN8AS7pLTNs0YSRZ/x85Ry9pLPZpFxbsIr4
	 r8THGowmgpumSPzeFm7QROsdrBgAeWPQRHmkDGcZIWlocVEdLgSZjif6F4QPw8v6hA
	 5NQ+VShwIhVaApCOCBvMQ6I33biHNj7UkXxpCtbAGPtMs4mJb05aKvzXC/cEXrbgMx
	 g9xg7zfjtkRBA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DA7C624CF;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:05 +0800
Subject: [PATCH RFC v2 6/6] mm/memcg: filter out reparented memcgs got from
 memcgid
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-6-8edd7f7a7251@tencent.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=2534;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=lyLjAgWvu8z4Mx3sqViPTPHcL3MXNW/gr5r9+kucGwg=;
 b=5xj+J76UVmxnZQVNFQ+zRSPDR6UAzTih6ycgAZjO5VvTHyXssOM33/ei2NDEyHihaq21+da96
 MKCaUTHN9j0A6KLo/1zLukpvbxwxLE1BM6WpuN+T9oeiSyyRVaMXTp2
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
returned memcg still owns the id and return NULL otherwise. In this
case, make list_lru just skip and workingset tests use the root (as the
comments said in workingset.c:460).

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/list_lru.c   | 2 +-
 mm/memcontrol.c | 9 ++++++++-
 mm/workingset.c | 2 +-
 3 files changed, 10 insertions(+), 3 deletions(-)

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
index 38d2b00657a7a..84dcab3acb8a2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4112,17 +4112,24 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
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
 
 struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
diff --git a/mm/workingset.c b/mm/workingset.c
index 7ac2b88c80ae5..4e9b7b163c01e 100644
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


