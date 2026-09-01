Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4205847424E;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788253097; cv=none; b=goebwcwEneD7hTTjeIBTKWHkoYTN0pZyIoFXDsy3y2sCueOOYfm6ko4J/mdk1OJKf7SeQfOgUgxfrSJfER2oayS6kJNnEdJ1Phs2M5IqtYWAP287SQqfYzY64mByiDzXAduCghXS+kYFhQXKiEn0OfNfgC2gbE3lqtOp64dZoR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788253097; c=relaxed/simple;
	bh=At7AKn+WQ2iI4/tDQ568q/Nwj4sMXoMHy77RVQT6EGs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TyooH0B1Z+F1D/ntofc02vancatHa+pqzXgUmRnGzv1WezThMBCL598s8PVSUt7T2wuJ00X9CHmcCTSdWIxbLdMbeY5te1R/blOF6tGGC+nRN75BqdxOH8gs3BS8gRa4RIjvEGDaaV+iDxH7wkpSrX3cE/Zoy7hYZ+rg2DzDlVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VaoAPBX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VaoAPBX4"
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0639C2BD04;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253097;
	bh=At7AKn+WQ2iI4/tDQ568q/Nwj4sMXoMHy77RVQT6EGs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VaoAPBX4yW0gZ33XcEMkQYlvgaVKptCDrdCsxygWTNMey8yQJR/OINpETZMfmTKDc
	 BupBWrw2vyyjRGbB+lcm8KJquzTfoNlJ0SC0NvGztizsje6gMZre79gqcgWwwxwD28
	 W5DcUhM4ovHzlk0GVwZGtVydMn/ZmkuBzfmVe8wtjtLkIa45LJ5VK2CLYDD6DU4SAN
	 WtYnGkaw/fxZ2vfpH4o59ZWWoJkNRMVanrRUIsqcNcOaItWfYQXzzxZIdKugEdaR8X
	 XVpq+qOgU5FD5b1TAAsvmZD/wdvzLlPAM9dfXRtUyRyr0lhFJNR3EXD4yWvXBwH14s
	 Fh7ElzAzOXRVg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE4BC624D1;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:02 +0800
Subject: [PATCH RFC v2 3/6] mm/memcg: pass the id itself instead of memcg
 for putting ID
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-3-8edd7f7a7251@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=2276;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=Hme7alp92v7qswodLGOz+AEsobF9FQa4tLBqDCAkCtM=;
 b=c8nFHb4AUhwzs6oAknyCqJ0Pm1qLXpvYuxZxHbNmRGZsdbLVMb09sl90FHGF647pHZfMqOyHs
 cmyhPaHJmgHACPLgmtpGf/+GzZKmjR+RGTDIcB4wtk93DT2tIPbQDeH
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

Swap uncharge knows the memcg only by its private id, and the id can
outlive the memcg it used to belong to after we rebind memcgid to
objcgs.  Make mem_cgroup_private_id_put() take the id and resolve the
memcg containing the refcount internally, and keep the underlying
__mem_cgroup_private_id_put() for the offline path that still holds a
memcg pointer.

In the uncharge path, the memcg pointer will have to be read from the
xarray twice, but we'll fix that later by returning the memcg from the
put path, so the uncharge path can obtain a reference in the same step.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ecb4fb07d7735..048c9bb0fad79 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4038,7 +4038,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->id.ref)) {
 		mem_cgroup_private_id_remove(memcg);
@@ -4048,9 +4048,19 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
 	}
 }
 
+static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	__mem_cgroup_private_id_put(memcg, n);
+	rcu_read_unlock();
+}
+
 static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
 {
-	mem_cgroup_private_id_put(memcg, 1);
+	__mem_cgroup_private_id_put(memcg, 1);
 }
 
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
@@ -5815,9 +5825,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		mem_cgroup_private_id_put(id, nr_pages);
 	}
 	rcu_read_unlock();
+
 }
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)

-- 
2.43.7


