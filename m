From: Jiading Gai <jiading.gai@gmail.com>
Subject: [PATCH] mm: memcontrol: fixed three spelling errors.
Date: Wed, 16 Dec 2015 01:45:05 -0500
Message-ID: <1450248305-7971-1-git-send-email-jiading.gai@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=aZOIY/AKwNd1OJEw4QGA5tMeuSLd8tWnsNEKsqIQPQ4=;
        b=xW3bEjpUmabIfiDZoRPlFRkZ2DTaoQgbLpyjBMAmwdxjvGi979GVGofJwJ7KDwBSzY
         po+HhOvVMLdOrP9CKhhAAZTTrCbmcWybiDEQWwyHcSWLY2+xy8CrNH45yaogJjMiofD4
         CJHMvxllsKkbICTI7Q84rUiZKIJuxOzvZEUbe3NR657YuxFwf2nl/n67XjrecTOK8d6e
         89Rs9yrLkbUQL2S4ueqcEqyfebjw9ypR4IjS3KyQ8YMPC2s06MADjb9dycZoR9AM111T
         ys++KTdm3bh7VrueOjI01GHZ1sIw8wpvnirTgYSdIJ2NpvRwjSJsc8DjrA1YUNqxKRSJ
         Ywug==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Jiading Gai <paul.paul.mit@gmail.com>, Jiading Gai <jiading.gai@gmail.com>

From: Jiading Gai <paul.paul.mit@gmail.com>

Fixed three spelling errors.

Signed-off-by: Jiading Gai <jiading.gai@gmail.com>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e234c21..4e424fc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1744,7 +1744,7 @@ bool mem_cgroup_oom_synchronize(bool handle)
 		/*
 		 * There is no guarantee that an OOM-lock contender
 		 * sees the wakeups triggered by the OOM kill
-		 * uncharges.  Wake any sleepers explicitely.
+		 * uncharges.  Wake any sleepers explicitly.
 		 */
 		memcg_oom_recover(memcg);
 	}
@@ -4277,7 +4277,7 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 		page_counter_init(&memcg->memsw, NULL);
 		page_counter_init(&memcg->kmem, NULL);
 		/*
-		 * Deeper hierachy with use_hierarchy == false doesn't make
+		 * Deeper hierarchy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
 		 * unfortunate state in our controller.
 		 */
@@ -4809,7 +4809,7 @@ static int mem_cgroup_can_attach(struct cgroup_taskset *tset)
 		return 0;
 
 	/*
-	 * We are now commited to this value whatever it is. Changes in this
+	 * We are now committed to this value whatever it is. Changes in this
 	 * tunable will only affect upcoming migrations, not the current one.
 	 * So we need to save it, and keep it going.
 	 */
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
