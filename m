From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] mm: memcontrol: print proper OOM header when no eligible victim left
Date: Tue, 21 Aug 2018 12:04:06 -0400
Message-ID: <20180821160406.22578-1-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=HQveg+wwOvTMgdq8w8V2TDKUdmzAZcRDjRhbO3q1zV8=;
        b=0l/jvN1YJk7d1P79vzNblx2RXEFZ05NKLc8X7lXMrwjyeWL8pCT5aqWoohrk+lsppp
         Zkh1FJTP/GVyTfoCHUBwZvt/vRq1Grva0fuG/+ocLK9jR4mX4BHCLGNpLytptrmD/HUo
         ekuSezfHj9CEUVzoMrFbKK8QXyhtddhDsjDicxzwwF7Ejnzp8rtwwI3+5OfABBap5ObG
         0B+PTiAICHD470ZOQf1QtlXk0atuMOw4JzYy/SjzEfLoJoaiNb39csjsaBPktqZitd6b
         6DW3ceomGLxsrWsHBBiOfcmgq0vbAnHIUKZTUiBGBaNcSwDQ/XWKB24bDd8C/FRwDzoM
         Djpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Dmitry Vyukov <dvyukov@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

When the memcg OOM killer runs out of killable tasks, it currently
prints a WARN with no further OOM context. This has caused some user
confusion.

Warnings indicate a kernel problem. In a reported case, however, the
situation was triggered by a non-sensical memcg configuration (hard
limit set to 0). But without any VM context this wasn't obvious from
the report, and it took some back and forth on the mailing list to
identify what is actually a trivial issue.

Handle this OOM condition like we handle it in the global OOM killer:
dump the full OOM context and tell the user we ran out of tasks.

This way the user can identify misconfigurations easily by themselves
and rectify the problem - without having to go through the hassle of
running into an obscure but unsettling warning, finding the
appropriate kernel mailing list and waiting for a kernel developer to
remote-analyze that the memcg configuration caused this.

If users cannot make sense of why the OOM killer was triggered or why
it failed, they will still report it to the mailing list, we know that
from experience. So in case there is an actual kernel bug causing
this, kernel developers will very likely hear about it.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 mm/memcontrol.c |  2 --
 mm/oom_kill.c   | 13 ++++++++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4e3c1315b1de..29d9d1a69b36 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1701,8 +1701,6 @@ static enum oom_status mem_cgroup_oom(struct mem_cgroup *memcg, gfp_t mask, int
 	if (mem_cgroup_out_of_memory(memcg, mask, order))
 		return OOM_SUCCESS;
 
-	WARN(1,"Memory cgroup charge failed because of no reclaimable memory! "
-		"This looks like a misconfiguration or a kernel bug.");
 	return OOM_FAILED;
 }
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index b5b25e4dcbbb..95fbbc46f68f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1103,10 +1103,17 @@ bool out_of_memory(struct oom_control *oc)
 	}
 
 	select_bad_process(oc);
-	/* Found nothing?!?! Either we hang forever, or we panic. */
-	if (!oc->chosen && !is_sysrq_oom(oc) && !is_memcg_oom(oc)) {
+	/* Found nothing?!?! */
+	if (!oc->chosen) {
 		dump_header(oc, NULL);
-		panic("Out of memory and no killable processes...\n");
+		pr_warn("Out of memory and no killable processes...\n");
+		/*
+		 * If we got here due to an actual allocation at the
+		 * system level, we cannot survive this and will enter
+		 * an endless loop in the allocator. Bail out now.
+		 */
+		if (!is_sysrq_oom(oc) && !is_memcg_oom(oc))
+			panic("System is deadlocked on memory\n");
 	}
 	if (oc->chosen && oc->chosen != (void *)-1UL)
 		oom_kill_process(oc, !is_memcg_oom(oc) ? "Out of memory" :
-- 
2.18.0

