From: Glauber Costa <glommer@gmail.com>
Subject: [PATCH v10 08/16] memcg: move initialization to memcg creation
Date: Sun,  7 Jul 2013 11:56:48 -0400
Message-ID: <1373212616-11713-9-git-send-email-glommer@openvz.org>
References: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=cbHKdNoB7xCbGp+yuWzPxC+BBra8pRipnUVHCy5et30=;
        b=y6uVu6048Is5gUjdkhKScwxi8dKP+wVIwIXLT0j9Sz0NAKNnxKI/1C0ofq21CbjmKS
         SpO+smDGUPpqU0TgRNPYvdR1xmUGVCwhrD+hqGc6sq9LL4jngx5c/FoOxn1yDS458kQ6
         Ltk+BrAbSwHrTtaSy9QPnjHqUvYH9fPYhTXuhz9FqeazYj+KjH6RPv7Ew6KFx0VJ/Si5
         XTIW/+yrEb8HUFE8A2u+GTkvotxY7wFzRBMzIWuvxCZiYxWW2mMQI5C4j+QoCjwYphUd
         D3iWRMLuaAHkSYnLYB0dlNeW2o9CDvsYg3d3noi6ktyHfuKbMkthvRH8lw8JJJP3Pb2Y
         AMOA==
In-Reply-To: <1373212616-11713-1-git-send-email-glommer@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, mgorman@suse.de, david@fromorbit.com, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suze.cz, hannes@cmpxchg.org, hughd@google.com, gthelen@google.com, akpm@linux-foundation.org, Glauber Costa <glommer@openvz.org>, Dave Chinner <dchinner@redhat.com>, Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>

Those structures are only used for memcgs that are effectively using
kmemcg. However, in a later patch I intend to use scan that list
inconditionally (list empty meaning no kmem caches present), which
simplifies the code a lot.

So move the initialization to early kmem creation.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/memcontrol.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f6b64e8..d853d71 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3173,9 +3173,6 @@ int memcg_update_cache_sizes(struct mem_cgroup *memcg)
 
 	memcg_update_array_size(num + 1);
 
-	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
-	mutex_init(&memcg->slab_caches_mutex);
-
 	return 0;
 out:
 	ida_simple_remove(&kmem_limited_groups, num);
@@ -6085,6 +6082,8 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
 	int ret;
 
+	INIT_LIST_HEAD(&memcg->memcg_slab_caches);
+	mutex_init(&memcg->slab_caches_mutex);
 	memcg->kmemcg_id = -1;
 	ret = memcg_propagate_kmem(memcg);
 	if (ret)
-- 
1.8.2.1

