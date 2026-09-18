Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4656623EAA0;
	Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723140; cv=none; b=Rs2b94eRHXW1URDWYqbVgaCM1gDevILjKxrWeTRKYy7QKnr1YI6GkofsVOa/BpOnTw1vCYPXBz2kRUJyAYHYyKvbjl/Ry0ymRA8FcADsd8++5HXqQXvsAjMCm9Xapak3zzrk0Si+81MJnenN4gLj9mi3aDwuZbaHQw3j0hMaVXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723140; c=relaxed/simple;
	bh=XdjX33riuk2EpI/N/nnFyKprsD5MLEVM/f265lMaRc8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Txq4hd9ykZB1ag622szNkOn5gw9UC1eqIlQTO5eI2aml75yAaGk7n29knyQBS5a31iLO91VWMaYfIIVelqXxZ5P+LN3IbuR8jH6nSb8a5XoxEl7pb07i7cNzl/2/FWUZNWit2aRgMOwNmqfAWdH4NszPHzDLB+QOgH+0IjFlFUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ncx3N3vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ncx3N3vN"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2451C2BCB9;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789723139;
	bh=XdjX33riuk2EpI/N/nnFyKprsD5MLEVM/f265lMaRc8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ncx3N3vNlh7x1qtuI6JhHocww4d8MLEvCk4yTLWdSnIg/ViYRXOaVBMGYFKQzzY+7
	 FNaRRj03BvtrKpJ6nnATiyfVoLkSuDVj3BJUvW2yD/OWABVONRrb0Nc4U9/jS7wYdh
	 hRDexf/20tDW8EzV8uv7vo9vBydS6IIciIz4h0DP/bNvpSRuPsI1MT2Scnavw/LRPn
	 eaJO0Q2LkWUMLVtMnJXdjTqIsGDVYmpgkPoLRToHYUsy2SGlFuEo2ySCi013NV4kNv
	 855DiG2Yd35ZKCQ1RsLdVwYEfXmMT8v9THQkpK+bNa+reb6QPJJ3eTmLYTk2Sx27RC
	 3u02cCh3Sy7vA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36D6C982D7;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 17:18:40 +0800
Subject: [PATCH 1/4] memcg: keep swap charging under RCU protection
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789723137; l=2119;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=aNz5CIHBA0S+5g/N6vd9VKb1cpBJlA1cYu/omCgqzbc=;
 b=85Mfwmjg8Hw0ij0tgq5WRMyNU987rySAkUozMzMbKjZ4EMuLJjIpx4j/3IQ2O6QO3UEKF4Ac2
 Bd4qZmnpAuUD0TVgkE277fCPMZ0RJDGGHP/A5uHi2CEtksfylrjwdne
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
memcg's CSS.

Moving private ID references to objcgs will remove that lifetime
guarantee. Keep the RCU read lock held while accessing the memcg for
counter charging, statistics and failure handling. (This matches what
__memcg1_swapout() already does.).

Save the private ID before dropping the RCU read lock, and use the saved
value when recording the swap entry. The swap cluster locking remains
outside the RCU read-side critical section.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 791e536efaebe..72522ec827c9a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5954,6 +5954,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short private_id;
 
 	if (do_memsw_account())
 		return 0;
@@ -5973,20 +5974,21 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 
 	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
 	/* memcg is pined by memcg ID. */
-	rcu_read_unlock();
+	private_id = mem_cgroup_private_id(memcg);
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
 		mem_cgroup_private_id_put(memcg, nr_pages);
+		rcu_read_unlock();
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
+	rcu_read_unlock();
 
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
-			  mem_cgroup_private_id(memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
 	swap_cluster_unlock(ci);
 
 	return 0;

-- 
2.43.7


