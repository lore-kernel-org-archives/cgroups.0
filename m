From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [patch v3] oom, memcg: fix exclusion of memcg threads after they
 have detached their mm
Date: Thu, 15 Dec 2011 13:36:11 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1112151335370.17878@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1112131659100.32369@chino.kir.corp.google.com> <20111214102942.GA11786@tiehlicka.suse.cz> <alpine.DEB.2.00.1112141838470.27595@chino.kir.corp.google.com> <20111215155926.GA22819@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=9UfI/6PqMEDsPWmNqlOMn/UXGUju2sdc1zC5WOITuck=;
        b=w/jA6gsZB0/yF+JhCzrptA/lHZMGsUQQWk/SdJxZS3Gd4N4har4treD1TaT6uid9tU
         4T9SQHxOBDo4hfPs2Dag==
In-Reply-To: <20111215155926.GA22819-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

The oom killer relies on logic that identifies threads that have already
been oom killed when scanning the tasklist and, if found, deferring until
such threads have exited.  This is done by checking for any candidate
threads that have the TIF_MEMDIE bit set.

For memcg ooms, candidate threads are first found by calling
task_in_mem_cgroup() since the oom killer should not defer if there's an
oom killed thread in another memcg.

Unfortunately, task_in_mem_cgroup() excludes threads if they have
detached their mm in the process of exiting so TIF_MEMDIE is never
detected for such conditions.  This is different for global, mempolicy,
and cpuset oom conditions where a detached mm is only excluded after
checking for TIF_MEMDIE and deferring, if necessary, in
select_bad_process().

The fix is to return true if a task has a detached mm but is still in the
memcg or its hierarchy that is currently oom.  This will allow the oom
killer to appropriately defer rather than kill unnecessarily or, in the
worst case, panic the machine if nothing else is available to kill.

Acked-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Signed-off-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1109,10 +1109,21 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *memcg)
 	struct task_struct *p;
 
 	p = find_lock_task_mm(task);
-	if (!p)
-		return 0;
-	curr = try_get_mem_cgroup_from_mm(p->mm);
-	task_unlock(p);
+	if (p) {
+		curr = try_get_mem_cgroup_from_mm(p->mm);
+		task_unlock(p);
+	} else {
+		/*
+		 * All threads may have already detached their mm's, but the oom
+		 * killer still needs to detect if they have already been oom
+		 * killed to prevent needlessly killing additional tasks.
+		 */
+		task_lock(task);
+		curr = mem_cgroup_from_task(task);
+		if (curr)
+			css_get(&curr->css);
+		task_unlock(task);
+	}
 	if (!curr)
 		return 0;
 	/*
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
