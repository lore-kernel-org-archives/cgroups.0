From: David Rientjes <rientjes@google.com>
Subject: [patch 11/11] mm, memcg: allow system oom killer to be disabled
Date: Tue, 4 Mar 2014 19:59:46 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1403041957340.8067@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=DM1afpsefwwveOSK++VkPIC2mMfhXEQKhMVryOQvgVs=;
        b=GudTMt/ljPaC1vR67pydL5Vh5Er2+n2T6CeHhmytmEeaCVL59NVTyE/widKWASYCux
         qHTdEYi+/jSbO2+uTVgnNfOEClxleIpEAJNmvOC+Gi5Ji/4oHkDUhg15Y4ZwUVd8W6o2
         xC+Stod1N9xImw71u9b64+Cotm2KI8S4v4L0fRSsJ9SQYm5xFyup3maWyMLEOuY5nXrD
         /B3a+88yzWgdxl3xmsbxMN40Vf8j2ncmQ0F2PHgnLedGIEO+sTEUltLh+VI71NEwN8Pw
         lX1DezY7FKUuEpdu8exDCh72UndSStVxVgloJ/9/1ED2BqO+50oylLnaLy30t8DXpKPC
         QmnA==
In-Reply-To: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

Now that system oom conditions can properly be handled from userspace,
allow the oom killer to be disabled.  Otherwise, the kernel will
immediately kill a process and memory will be freed.  The userspace oom
handler may have a different policy.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/cgroups/memory.txt |  4 ++--
 include/linux/memcontrol.h       |  6 ++++++
 mm/memcontrol.c                  | 11 ++++++++---
 mm/oom_kill.c                    |  3 +++
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -755,8 +755,8 @@ You can disable the OOM-killer by writing "1" to memory.oom_control file, as:
 
 	# echo 1 > memory.oom_control
 
-This operation is only allowed to the top cgroup of a sub-hierarchy and does
-not include the root memcg.
+This operation is only allowed to the top cgroup of a sub-hierarchy.  If
+disabled for the root memcg, the system oom killer is disabled.
 If OOM-killer is disabled, tasks under cgroup will hang/sleep
 in memory cgroup's OOM-waitqueue when they request accountable memory.
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -159,6 +159,7 @@ bool mem_cgroup_oom_synchronize(bool wait);
 extern bool mem_cgroup_alloc_use_oom_reserve(void);
 extern u64 mem_cgroup_root_oom_reserve(void);
 extern void mem_cgroup_root_oom_notify(void);
+extern bool mem_cgroup_root_oom_disable(void);
 
 #ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
@@ -415,6 +416,11 @@ static inline void mem_cgroup_root_oom_notify(void)
 {
 }
 
+static inline bool mem_cgroup_root_oom_disable(void)
+{
+	return false;
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_stat_index idx)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5976,13 +5976,13 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 	struct mem_cgroup *parent = mem_cgroup_from_css(css_parent(&memcg->css));
 
-	/* cannot set to root cgroup and only 0 and 1 are allowed */
-	if (!parent || !((val == 0) || (val == 1)))
+	/* only 0 and 1 are allowed */
+	if (val != !!val)
 		return -EINVAL;
 
 	mutex_lock(&memcg_create_mutex);
 	/* oom-kill-disable is a flag for subhierarchy. */
-	if ((parent->use_hierarchy) || memcg_has_children(memcg)) {
+	if (parent && (parent->use_hierarchy || memcg_has_children(memcg))) {
 		mutex_unlock(&memcg_create_mutex);
 		return -EINVAL;
 	}
@@ -6062,6 +6062,11 @@ u64 mem_cgroup_root_oom_reserve(void)
 	return root_mem_cgroup->oom_reserve >> PAGE_SHIFT;
 }
 
+bool mem_cgroup_root_oom_disable(void)
+{
+	return root_mem_cgroup->oom_kill_disable;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 {
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -656,6 +656,9 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
 	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
 
+	if (mem_cgroup_root_oom_disable())
+		return;
+
 	if (sysctl_oom_kill_allocating_task && current->mm &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
