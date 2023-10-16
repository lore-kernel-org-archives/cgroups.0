Return-Path: <cgroups-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C4ACDB465
	for <cgroups@archiver.kernel.org>; Mon, 16 Oct 2023 22:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234226AbjJPWTg (ORCPT <rfc822;cgroups@archiver.kernel.org>);
        Mon, 16 Oct 2023 18:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbjJPWTe (ORCPT
        <rfc822;cgroups@vger.kernel.org>); Mon, 16 Oct 2023 18:19:34 -0400
Received: from out-204.mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DDBE1
        for <cgroups@vger.kernel.org>; Mon, 16 Oct 2023 15:19:31 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1697494769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8nbWMqlQbup8L2PuI3o6aZR+b1Gh4bcn04UHgRGHul4=;
        b=GVxjccE0wRDPf3xmRq5yp+EZpFthfbOTdOcitturXfYEyCKxOFwUAdjvcbfQaAHmjoiYHf
        XchZu3Jj3LIkIaTLAvXdaMbdYfKBOOd4vnoDv+0zus1yi0xwVi2DEtoTht+7fcm4V0ms/G
        FLHpSoYdp6Gpzdvw2ssI9g/dgNewT7w=
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
Subject: [PATCH v3 3/5] mm: kmem: make memcg keep a reference to the original objcg
Date:   Mon, 16 Oct 2023 15:18:58 -0700
Message-ID: <20231016221900.4031141-4-roman.gushchin@linux.dev>
In-Reply-To: <20231016221900.4031141-1-roman.gushchin@linux.dev>
References: <20231016221900.4031141-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <cgroups.vger.kernel.org>
X-Mailing-List: cgroups@vger.kernel.org

Keep a reference to the original objcg object for the entire life
of a memcg structure.

This allows to simplify the synchronization on the kernel memory
allocation paths: pinning a (live) memcg will also pin the
corresponding objcg.

The memory overhead of this change is minimal because object cgroups
usually outlive their corresponding memory cgroups even without this
change, so it's only an additional pointer per memcg.

Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
---
 include/linux/memcontrol.h | 8 +++++++-
 mm/memcontrol.c            | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ab94ad4597d0..277690af383d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -299,7 +299,13 @@ struct mem_cgroup {
 
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
-	struct obj_cgroup __rcu *objcg;
+	/*
+	 * memcg->objcg is wiped out as a part of the objcg repaprenting
+	 * process. memcg->orig_objcg preserves a pointer (and a reference)
+	 * to the original objcg until the end of live of memcg.
+	 */
+	struct obj_cgroup __rcu	*objcg;
+	struct obj_cgroup	*orig_objcg;
 	/* list of inherited objcgs, protected by objcg_lock */
 	struct list_head objcg_list;
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0605e45bd4a2..d90cc19e4113 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3808,6 +3808,8 @@ static int memcg_online_kmem(struct mem_cgroup *memcg)
 
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
+	obj_cgroup_get(objcg);
+	memcg->orig_objcg = objcg;
 
 	static_branch_enable(&memcg_kmem_online_key);
 
@@ -5302,6 +5304,9 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
 
+	if (memcg->orig_objcg)
+		obj_cgroup_put(memcg->orig_objcg);
+
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	kfree(memcg->vmstats);
-- 
2.42.0

