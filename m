Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB014734C6;
	Tue,  1 Sep 2026 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788253097; cv=none; b=e0/8TGL5qHY0WiRVj6FS8WEGsMp0+s9ZRwsWXX+K9/fhtgTl5xBA0G+6WQlBMW/RnWwNAXEgnISWDxaT2UgDFM8Mi98wQzD7p3DNHQ+upbiQ81hjrT1LTu7wimY3IJCAfiqt9MoCbjSbyhX9kBb4LmlNK78qm6gbmzUYHFa7/tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788253097; c=relaxed/simple;
	bh=aIiuh9ou8roZ4tGxttm9/MkqYiiC/wiCDtUiGOaAUGY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gBq0/SA1n1eYwM+fKaR70bMpl8Xa0hkieMLg7/ZgiEsdBarKgkMSGPw18YDtvYQI6127Cw09UpMyUQaydz/w2O9Bg/JWGzrYlQTUUS0BZvuwXS/MrVzFhq0nK2AnKBJvX7YUkVUmVsI7ofNPq6and/EK4wpt3OdSk3fSojH1AKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NV3Gp4if; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NV3Gp4if"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCB02C2BD00;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788253096;
	bh=aIiuh9ou8roZ4tGxttm9/MkqYiiC/wiCDtUiGOaAUGY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=NV3Gp4ifFweltofgntqM4I5Ys5cvDmz7WMnaPulUCAhHV8UA3bQpbGbDNECc/Q5yc
	 +KyB9lsEcxniPZmA85tkj+SJ6Mz0KAr+YAnizrLvfs4EKNquNP01JnctXttyhG/ijJ
	 WIO9scwhne+xGVzEAUbed2MUkvjtu+mp89mRNOa15Xxp26oA8xN1qaUM+yMT1EbOdf
	 qnwBXyn+TYx+zECCoo0+b6T1ixcSvpoUIOdsL4ia+RVeYtC6adkSoWJ0jxopeU713C
	 aCL7yfnv5et2Q7KRow+nKvpFvheQDIs7AOEd6TA7UOE1ZThyDXb5PJsDcUH2GTe0fL
	 9TTUBbEmltPzw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB832C624C6;
	Tue,  1 Sep 2026 08:58:16 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 01 Sep 2026 16:58:01 +0800
Subject: [PATCH RFC v2 2/6] mm/memcg: get memcgid reference only after swap
 charging success
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-bingfangguo-memcgid-rework-v2-2-8edd7f7a7251@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788253095; l=2079;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=ErkCRKG7+ifvfMdPwACVPkm46ElNXWlnuq1XQ4FUIi8=;
 b=DDtDUpfBr/Cr35KrVKoFXS5DDP6UzA+O0oBVcDic8cgdd5zeProvls7hwZXdQbkadI2cVWUcU
 lmlkGHHPgxyDvquRgY9UsYRryi10Q4EWn81coSXY+EukseXogsThSAF
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com

From: Bingfang Guo <bingfangguo@tencent.com>

__mem_cgroup_try_charge_swap() pinned the memcg private id before the
swap counter was charged and had to undo the pin on the failure path.
Hold RCU lock for an extended period (which should be fine,
__memcg1_swapout() does this as well) so concurrent memcg release can
be avoided, and take the id reference to its online parent only after
charging has succeeded.

The failure path is now a plain return, and the id is only pinned for
entries that actually end up charged to swap.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 31cec9dde55f0..ecb4fb07d7735 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5755,6 +5755,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short memcgid;
 
 	if (do_memsw_account())
 		return 0;
@@ -5772,22 +5773,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	/* memcg is pined by memcg ID. */
-	rcu_read_unlock();
+	while (memcg_is_dying(memcg))
+		memcg = parent_mem_cgroup(memcg);
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		rcu_read_unlock();
 		return -ENOMEM;
 	}
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
+	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+	memcgid = mem_cgroup_private_id(memcg);
+	rcu_read_unlock();
+
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
-			  mem_cgroup_private_id(memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, memcgid);
 	swap_cluster_unlock(ci);
 
 	return 0;

-- 
2.43.7


