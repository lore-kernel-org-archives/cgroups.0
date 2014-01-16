From: David Rientjes <rientjes@google.com>
Subject: [patch -mm] mm, oom: prefer thread group leaders for display
 purposes
Date: Wed, 15 Jan 2014 18:40:41 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401151837560.1835@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=FRDWekK+WTn/4nM0qU6rSJjhnIHULt44y7m2leCZw4s=;
        b=KJbwvfBgqEF/qLG0fTaxjje9bNFX9/hsCiCNit/LBYV/DwY+AlzpiuKh686q7OoMCO
         rGAleuNfOnPq3EDbotGmgKHsMGtsSt9e28J3xMAHqfPdUx16rYx82hmGTxvylt7+3KZx
         wEbGlM4S2lyUYGLNsIplHsIKCvrsjcUFEOnJP5+50fwBe5HOWtWaFNR/Utcl3Je1oaEf
         5KlHwucj2I4YejyYpi1u5YHJooFKCoXRYQ5N/n8nH/MlqvHgwEY7t+ykvllJ+QqrXhdZ
         FcKjHVYN3ktQADieMyIdO7FZimrYULrntCP02qxUoYeR6Qs3R96f6dS8RxzBjgDs3Tke
         bMfQ==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

When two threads have the same badness score, it's preferable to kill the 
thread group leader so that the actual process name is printed to the 
kernel log rather than the thread group name which may be shared amongst 
several processes.

This was the behavior when select_bad_process() used to do 
for_each_process(), but it now iterates threads instead and leads to 
ambiguity.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c | 18 +++++++++++-------
 mm/oom_kill.c   | 12 ++++++++----
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a815686..b482f49 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1841,13 +1841,17 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 				break;
 			};
 			points = oom_badness(task, memcg, NULL, totalpages);
-			if (points > chosen_points) {
-				if (chosen)
-					put_task_struct(chosen);
-				chosen = task;
-				chosen_points = points;
-				get_task_struct(chosen);
-			}
+			if (points < chosen_points)
+				continue;
+			/* Prefer thread group leaders for display purposes */
+			if (points == chosen_points &&
+			    thread_group_leader(chosen))
+				continue;
+
+			if (chosen)
+				put_task_struct(chosen);
+			chosen = task;
+			chosen_points = points;
 		}
 		css_task_iter_end(&it);
 	}
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 054ff47..1dca3d8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -327,10 +327,14 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 			break;
 		};
 		points = oom_badness(p, NULL, nodemask, totalpages);
-		if (points > chosen_points) {
-			chosen = p;
-			chosen_points = points;
-		}
+		if (points < chosen_points)
+			continue;
+		/* Prefer thread group leaders for display purposes */
+		if (points == chosen_points && thread_group_leader(chosen))
+			continue;
+
+		chosen = p;
+		chosen_points = points;
 	}
 	if (chosen)
 		get_task_struct(chosen);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
