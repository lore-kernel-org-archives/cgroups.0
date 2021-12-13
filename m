From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: [PATCH] mm: add group_oom_kill memory.event fix
Date: Mon, 13 Dec 2021 08:25:10 -0800
Message-ID: <20211213162511.2492267-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nu0e3REkbFkXwUCLY/t28Mz7Y046BFRzaKZrlwttw5A=;
        b=AfF1bilD8S8n3fyC8TdgEVD0nCb7TFtTyXL6lV8hjUsZ43EkGsaTXH7JrcGFrJkKad
         Pr2F3aZ53Yy/fyREFZeLULo93p539ZBfTtBZjVqZ1KeD3hDw1e6tPh1RNnrPJdQ9rfAZ
         4eOT9ab3ciHjBYtgmCBOLE4ed8/N7ROJsj8Ie9VazehcR+BLwFGsmxQ1anpdx/4KuYcm
         IdSWnsHSGBgRuNtedTLPapppi4nGCMmz2U6RFYFbitW+LXWCSvvalTKzfRxpBi5BMbnZ
         rXxBOzMs0F6BVaxF29XfcggrKFOPc0TptUvhh+TjJo1Qz5rqFYhzM6GRQyQBGAUeI9un
         1QGA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <linux-mm@kvack.org>

Andrew, could you please amend the prior patch "mm: add group_oom_kill
memory.event" with these changes from Johannes and Chris?

Also - small nit: it makes better sense to
s/group_oom_kill/oom_group_kill/g in the patch title.

Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 3 +--
 mm/memcontrol.c                         | 3 ---
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index eec830ce2068..8269bfa240f4 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1269,8 +1269,7 @@ PAGE_SIZE multiple when read back.
 		killed by any kind of OOM killer.
 
           oom_group_kill
-                The number of times all tasks in the cgroup were killed
-                due to memory.oom.group.
+                The number of times a group OOM has occurred.
 
   memory.events.local
 	Similar to memory.events but the fields in the file are local
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5ab3b9ce90de..b5454d8fc344 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4390,9 +4390,6 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
 	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
 	seq_printf(sf, "oom_kill %lu\n",
 		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
-	seq_printf(sf, "oom_group_kill %lu\n",
-		   atomic_long_read(
-			&memcg->memory_events[MEMCG_OOM_GROUP_KILL]));
 	return 0;
 }
 
-- 
2.30.2

