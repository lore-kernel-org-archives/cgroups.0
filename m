Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42174474267;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788253097; cv=none; b=Xd2vXCx11dqh4gQD+NWTdJwF3ufuWWyRpcy+A8z6q4DRtZ5A1sn91HUNwrAoIsHjdwiFo7mxDviFbZCRXAm/7JUCJxLKI+cuvySnKPwCqpRcS9oZvP5WniU+1Evvgt43JCCoEaJc138sJRQyxVwiM2doZEr6PGJpfMmev8PA+2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788253097; c=relaxed/simple;
	bh=e48zmxDz9kiWmbI8h/PlXtcqt9ITTR5UArZLJzZ8S+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=A8MEMJAYwmMovh3mTQMFV04J68K5LZ/m8UFRYq0I2fUPPoC5IGcRBCISGRvEOsEkdAfQEisLTuUp/lXW6/Id3+AFmEq93cRS+0ee0KQZNQ8nhk4BmuQ6v7n8C6v4bK3cED7VckInqwruwI/N3idazvTN2jxIWVHn8MYuXon8v1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKbRx7OB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKbRx7OB"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D05FC32786;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253097;
	bh=e48zmxDz9kiWmbI8h/PlXtcqt9ITTR5UArZLJzZ8S+M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=FKbRx7OBlFSonSo5DUXAwFKpi3N6sW1nqpa6N/s7w1GujUVkcsgUjiW5bBrBolTld
	 I2zMqn9o3ILxUJ1dbl7HEPwQ+kg4GefQbdE8gu5NJ9Bid967ZyrWFsy85inIn1MAPz
	 dgYw/+CZ6NmBy3aec6QMVw3kZRyLgCPWl4msCWzeakivNWjgH1VSyYXRmXH7GJrOzL
	 6tL6B2fe5YOAZXDmU96Gc1WqpMppP7Bp0V6alvfdWh1JIFB5i11abW78xPGNAMpw4d
	 d9etcydeRFwgG/qiApsIZgQcFzLRq/yZ32o6LihXjaRpOP1DziB2Bbbv6fj0ARoX9M
	 MK0kJiaKighag==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D00C61DD6;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:03 +0800
Subject: [PATCH RFC v2 4/6] mm/memcg: return the memcg when putting memcgid
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=2395;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=A1qQqLP5yDMt8FsMtFOg0bivZFdxXUGUKPpa8uP9vSI=;
 b=SDxnNZGTvufnF2pzh/K+4XYnYFWQcDEg+BL0G/Mxc0c0jXuvvOso6qj3wfuU3pFeXELjN/juH
 /qvaZjgC7g3BEC0Brs8fdvQp+grYKljsPUo0sOADm4168oeOHGOopSQ
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

__mem_cgroup_uncharge_swap() needs both the memcg and the id refcount
drop.  Right now it looks the memcg up by id, uncharges it, then looks
it up again inside mem_cgroup_private_id_put() to drop the reference.

Make mem_cgroup_private_id_put() resolve the id once, drop the
reference, and return the nearest online memcg with a reference held for
the caller.  __mem_cgroup_uncharge_swap() then uses that memcg directly
and drops the reference after uncharging, avoiding the second xarray
lookup.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 048c9bb0fad79..f0503a1e5492d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4048,14 +4048,28 @@ static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
 	}
 }
 
-static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
+/**
+ * mem_cgroup_private_id_put - put memcgid and get the nearest online memcg
+ * @id: the memcg private id got from mem_cgroup_id_get_online
+ * @n: count of references to put
+ */
+static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short id, unsigned int n)
 {
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_private_id(id);
+	if (!memcg)
+		goto out;
+
 	__mem_cgroup_private_id_put(memcg, n);
+
+	while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
+		memcg = parent_mem_cgroup(memcg);
+
+out:
 	rcu_read_unlock();
+	return memcg;
 }
 
 static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
@@ -5816,7 +5830,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 	struct mem_cgroup *memcg;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(id);
+	memcg = mem_cgroup_private_id_put(id, nr_pages);
 	if (memcg) {
 		if (!mem_cgroup_is_root(memcg)) {
 			if (do_memsw_account())
@@ -5825,10 +5839,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(id, nr_pages);
 	}
 	rcu_read_unlock();
 
+	mem_cgroup_put(memcg);
 }
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)

-- 
2.43.7


