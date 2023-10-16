Return-Path: <cgroups-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B4CCDB474
	for <cgroups@archiver.kernel.org>; Mon, 16 Oct 2023 22:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjJPWTk (ORCPT <rfc822;cgroups@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbjJPWTi (ORCPT
        <rfc822;cgroups@vger.kernel.org>); Mon, 16 Oct 2023 18:19:38 -0400
Received: from out-196.mta1.migadu.com (out-196.mta1.migadu.com [95.215.58.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC90F1
        for <cgroups@vger.kernel.org>; Mon, 16 Oct 2023 15:19:36 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697494775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3kIxRaEQpjFFVG+rl0/tQDkNcffLjJm9ou/emwznPps=;
        b=AUkcAyERB4hjOs5JPnQxOrvAqevb5Ye/YTZ14NxTy/hXzOKKR1ln2/5IM9q7l/vu2I4i4H
        Uk9W4bOiOxtW9TjZ38qFfyyzfpGSdK17v8XcmOMmSTtvViVbGekkE3dXtgFowX5dW1xCPc
        2SN88q3ySEhGI2F8mcSxfcpDQtyxUH0=
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, Shakeel@vger.kernel.org,
        Butt@vger.kernel.org, shakeelb@google.com,
        Muchun Song <muchun.song@linux.dev>,
        Dennis Zhou <dennis@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v3 5/5] percpu: scoped objcg protection
Date:   Mon, 16 Oct 2023 15:19:00 -0700
Message-ID: <20231016221900.4031141-6-roman.gushchin@linux.dev>
In-Reply-To: <20231016221900.4031141-1-roman.gushchin@linux.dev>
References: <20231016221900.4031141-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <cgroups.vger.kernel.org>
X-Mailing-List: cgroups@vger.kernel.org

Similar to slab and kmem, switch to a scope-based protection of the
objcg pointer to avoid.

Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
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

