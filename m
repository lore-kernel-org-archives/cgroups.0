From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH] memcg: Add comment to mem_cgroup_css_online()
Date: Thu, 2 Aug 2018 11:13:24 +0300
Message-ID: <521f9e5f-c436-b388-fe83-4dc870bfb489@virtuozzo.com>
References: <20180413115454.GL17484@dhcp22.suse.cz>
 <abfd4903-c455-fac2-7ed6-73707cda64d1@virtuozzo.com>
 <20180413121433.GM17484@dhcp22.suse.cz>
 <20180413125101.GO17484@dhcp22.suse.cz>
 <20180726162512.6056b5d7c1d2a5fbff6ce214@linux-foundation.org>
 <20180727193134.GA10996@cmpxchg.org>
 <20180729192621.py4znecoinw5mqcp@esperanza>
 <20180730153113.GB4567@cmpxchg.org>
 <20180731163908.603d7a27c6534341e1afa724@linux-foundation.org>
 <20180801155552.GA8600@cmpxchg.org>
 <20180801162235.j3v7xipyw5afnj4x@esperanza>
 <7a836e47-f0a4-6802-9b90-cc473e5ab90b@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkje5KObdeCL9Mg0m2BuDypAqtl41PK80v6lc2wQ36U=;
 b=YrouCAQcrzEIBLPilLobs4ev65kgZCaNkFNDI3PgtrwHnfpbLdJzUW2kRC1IjOqO6XTfiaMuI0//fyTTEUHtydPslVMOx5cZgodtmy19mA5yVF5RktkPvtZhQ5/wk+K66zAWos8kgrtcmA39dOw9X3C+xE5CUQnWnVb0uRU+8t0=
In-Reply-To: <7a836e47-f0a4-6802-9b90-cc473e5ab90b@virtuozzo.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Explain relationships between allocation and expanding.

Suggested-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d90993ef1d7d..34e5ff72ce87 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4703,6 +4703,11 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+	/*
+	 * A memcg must be visible for memcg_expand_shrinker_maps()
+	 * by the time the maps are allocated. So, we allocate maps
+	 * here, when for_each_mem_cgroup() can't skip it.
+	 */
 	if (memcg_alloc_shrinker_maps(memcg)) {
 		mem_cgroup_id_remove(memcg);
 		return -ENOMEM;

