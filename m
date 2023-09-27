Return-Path: <cgroups-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC077E82CA1
	for <cgroups@archiver.kernel.org>; Wed, 27 Sep 2023 15:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbjI0PJR (ORCPT <rfc822;cgroups@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbjI0PJO (ORCPT
        <rfc822;cgroups@vger.kernel.org>); Wed, 27 Sep 2023 11:09:14 -0400
Received: from out-209.mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BD71B8
        for <cgroups@vger.kernel.org>; Wed, 27 Sep 2023 08:09:07 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695827344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j6TjL0tOzMm9uw8Y9niPXJ1ezOtPxfS6WilpL+cESRE=;
        b=V//ihQR3BNX8mCaIN2RHbsj24ybf5tsZR80ZurjIq/P4zdNE6/CNiqXGaUHELfnQzFCvFu
        ald/Rulhzhr/xKdfWTbsCyE4U6wbBWcnVys7yuOgrgVNmXQqA6dKbwvtqUzJLSfKLVSbkz
        VEv/GP4pB24vCqh16SVt3PIzQgO5+VI=
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <muchun.song@linux.dev>,
        Dennis Zhou <dennis@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH rfc 5/5] percpu: scoped objcg protection
Date:   Wed, 27 Sep 2023 08:08:32 -0700
Message-ID: <20230927150832.335132-6-roman.gushchin@linux.dev>
In-Reply-To: <20230927150832.335132-1-roman.gushchin@linux.dev>
References: <20230927150832.335132-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <cgroups.vger.kernel.org>
X-Mailing-List: cgroups@vger.kernel.org

Similar to slab and kmem, switch to a scope-based protection of the
objcg pointer to avoid.

Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
---
 mm/percpu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index a7665de8485f..f53ba692d67a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1628,14 +1628,12 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!memcg_kmem_online() || !(gfp & __GFP_ACCOUNT))
 		return true;
 
-	objcg = get_obj_cgroup_from_current();
+	objcg = current_obj_cgroup();
 	if (!objcg)
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size))) {
-		obj_cgroup_put(objcg);
+	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
 		return false;
-	}
 
 	*objcgp = objcg;
 	return true;
@@ -1649,6 +1647,7 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		return;
 
 	if (likely(chunk && chunk->obj_cgroups)) {
+		obj_cgroup_get(objcg);
 		chunk->obj_cgroups[off >> PCPU_MIN_ALLOC_SHIFT] = objcg;
 
 		rcu_read_lock();
@@ -1657,7 +1656,6 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		rcu_read_unlock();
 	} else {
 		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
-		obj_cgroup_put(objcg);
 	}
 }
 
-- 
2.42.0

