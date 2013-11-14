From: David Rientjes <rientjes@google.com>
Subject: [patch 2/2] mm, memcg: add memory.oom_control notification for system
 oom
Date: Thu, 14 Nov 2013 15:26:55 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311141526300.30112@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com> <20131031054942.GA26301@cmpxchg.org> <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com> <20131113233419.GJ707@cmpxchg.org> <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org> <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com> <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=aMrIDgg6iYMxwzq9O/0P22BtB+ImF+Qq6t2FSjGDQkk=;
        b=d3mz2LQ+m7kY/6QB9pTvVMkS/1rWCuCpi3Kalf4vMeM2v55DzpwiYnHNlg0LGJ4udJ
         j945CAJhwHFBTr6ZPkyhcNxWym44ooI25XFd3I9Zo4S1/iiXrvPu80mKyCh6HK9bTYNA
         KFCILY0U5OxRCOe6vxUUfWgqFvPUD/UW2VRLYWlTsb0Bb70GfazgEspEizjdO1OXucEb
         YuWjK1KcOICv9AgLgpt7sC7xdWJGPd7l47BWSIjDOpcHxUTNEYMZby+QnH4O/3MRgRQ2
         BQhxhgiTRSdZL/JTxmcqG+BHEWjBs/ovy1QC95kIe0Q87cYFEDSU2nlB6D8WPsAfjLCZ
         sDGg==
In-Reply-To: <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

A subset of applications that wait on memory.oom_control don't disable
the oom killer for that memcg and simply log or cleanup after the kernel
oom killer kills a process to free memory.

We need the ability to do this for system oom conditions as well, i.e.
when the system is depleted of all memory and must kill a process.  For
convenience, this can use memcg since oom notifiers are already present.

When a userspace process waits on the root memcg's memory.oom_control, it
will wake up anytime there is a system oom condition so that it can log
the event, including what process was killed and the stack, or cleanup
after the kernel oom killer has killed something.

This is a special case of oom notifiers since it doesn't subsequently
notify all memcgs under the root memcg (all memcgs on the system).  We
don't want to trigger those oom handlers which are set aside specifically
for true memcg oom notifications that disable their own oom killers to
enforce their own oom policy, for example.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/cgroups/memory.txt | 11 ++++++-----
 include/linux/memcontrol.h       |  5 +++++
 mm/memcontrol.c                  |  9 +++++++++
 mm/oom_kill.c                    |  4 ++++
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -743,18 +743,19 @@ delivery and gets notification when OOM happens.
 
 To register a notifier, an application must:
  - create an eventfd using eventfd(2)
- - open memory.oom_control file
+ - open memory.oom_control file for reading
  - write string like "<event_fd> <fd of memory.oom_control>" to
    cgroup.event_control
 
-The application will be notified through eventfd when OOM happens.
-OOM notification doesn't work for the root cgroup.
+The application will be notified through eventfd when OOM happens, including
+on system oom when used with the root memcg.
 
 You can disable the OOM-killer by writing "1" to memory.oom_control file, as:
 
-	#echo 1 > memory.oom_control
+	# echo 1 > memory.oom_control
 
-This operation is only allowed to the top cgroup of a sub-hierarchy.
+This operation is only allowed to the top cgroup of a sub-hierarchy and does
+not include the root memcg.
 If OOM-killer is disabled, tasks under cgroup will hang/sleep
 in memory cgroup's OOM-waitqueue when they request accountable memory.
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -155,6 +155,7 @@ static inline bool task_in_memcg_oom(struct task_struct *p)
 }
 
 bool mem_cgroup_oom_synchronize(bool wait);
+void mem_cgroup_root_oom_notify(void);
 
 #ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
@@ -397,6 +398,10 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
 	return false;
 }
 
+static inline void mem_cgroup_root_oom_notify(void)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_stat_index idx)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5648,6 +5648,15 @@ static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
 		mem_cgroup_oom_notify_cb(iter);
 }
 
+/*
+ * Notify any process waiting on the root memcg's memory.oom_control, but do not
+ * notify any child memcgs to avoid triggering their per-memcg oom handlers.
+ */
+void mem_cgroup_root_oom_notify(void)
+{
+	mem_cgroup_oom_notify_cb(root_mem_cgroup);
+}
+
 static int mem_cgroup_usage_register_event(struct cgroup_subsys_state *css,
 	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
 {
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -632,6 +632,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		return;
 	}
 
+	/* Avoid waking up processes for oom kills triggered by sysrq */
+	if (!force_kill)
+		mem_cgroup_root_oom_notify();
+
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
