From: David Rientjes <rientjes@google.com>
Subject: [patch 10/11] mm, memcg: add memory.oom_control notification for
 system oom
Date: Tue, 4 Mar 2014 19:59:41 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403041957140.8067@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=1R9vWTr1xGKUQCUBorJg+D0uwcp7/X+tW85pkWRt2Z4=;
        b=frVBNWb8y+d8qMdTKO5hPL/D4QhgV9dIftONbDyEsfxI9t/RdovnuPBRpuUZFwpwUi
         5EZ6w8Z4eXti4zPM6iSjHFi4tT71jfZ9D114JqEAzMOMuX4qAuA9YKzvEm17zet+MI2M
         gwpdbG1bLRegBW6e15HErbT/O+6F8spFnSOVRsidm3ES3uvFC85VEPkED/WoI3whI/hQ
         go7At+MPxclTKNvkep2qldMhv8TeM7+aGtkQg66FmvRn7dDxxfWiltZjj9dVcHrFT4S5
         Z9L2bAwTBAzu/1dhVCz5Nel5vOSM/yWf+VIcF5s1WEOlTHvl9wzYUipiEdwZFn9Lf3O0
         y13w==
In-Reply-To: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

Now that process handling system oom conditions have access to a small
amount of memory reserves, we need a way to notify those process on
system oom conditions.

When a userspace process waits on the root memcg's memory.oom_control, it
will wake up anytime there is a system oom condition.

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
@@ -744,18 +744,19 @@ delivery and gets notification when OOM happens.
 
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
@@ -158,6 +158,7 @@ bool mem_cgroup_oom_synchronize(bool wait);
 
 extern bool mem_cgroup_alloc_use_oom_reserve(void);
 extern u64 mem_cgroup_root_oom_reserve(void);
+extern void mem_cgroup_root_oom_notify(void);
 
 #ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
@@ -410,6 +411,10 @@ static inline u64 mem_cgroup_root_oom_reserve(void)
 	return 0;
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
@@ -5721,6 +5721,15 @@ static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
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
 static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 	struct eventfd_ctx *eventfd, const char *args, enum res_type type)
 {
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -643,6 +643,10 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
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
