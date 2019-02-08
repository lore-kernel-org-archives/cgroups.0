From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 2/2] mm: Consider subtrees in memory.events
Date: Fri, 8 Feb 2019 22:44:19 +0000
Message-ID: <20190208224419.GA24772@chrisdown.name>
References: <20190208224319.GA23801@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=mjddCA9wdnVApIjl0ZZ2ZUbqGTtZyeVvjAgYguybxu8=;
        b=XqsDTNDBEVx/mbh2ors4k2T4HQm+KlJh5iPPedK9W1L3xXjwkynI8mquKSDUWUkZFU
         5crlPxrdHaBR8UCng3p+GwZoGlMLK+gfEhV45GVwmIN89dTq78TdfNpmODXiy0NeRSI3
         +mYQPXQABF7Fe4il0jUCr/qbgyJX7HR0XRiuc=
Content-Disposition: inline
In-Reply-To: <20190208224319.GA23801@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

memory.stat and other files already consider subtrees in their output,
and we should too in order to not present an inconsistent interface.

The current situation is fairly confusing, because people interacting
with cgroups expect hierarchical behaviour in the vein of memory.stat,
cgroup.events, and other files. For example, this causes confusion when
debugging reclaim events under low, as currently these always read "0"
at non-leaf memcg nodes, which frequently causes people to misdiagnose
breach behaviour. The same confusion applies to other counters in this
file when debugging issues.

Aggregation is done at write time instead of at read-time since these
counters aren't hot (unlike memory.stat which is per-page, so it does it
at read time), and it makes sense to bundle this with the file
notifications.

After this patch, events are propagated up the hierarchy:

    [root@ktst ~]# cat /sys/fs/cgroup/system.slice/memory.events
    low 0
    high 0
    max 0
    oom 0
    oom_kill 0
    [root@ktst ~]# systemd-run -p MemoryMax=1 true
    Running as unit: run-r251162a189fb4562b9dabfdc9b0422f5.service
    [root@ktst ~]# cat /sys/fs/cgroup/system.slice/memory.events
    low 0
    high 0
    max 7
    oom 1
    oom_kill 1

As this is a change in behaviour, this can be reverted to the old
behaviour by mounting with the `memory_localevents` flag set. However,
we use the new behaviour by default as there's a lack of evidence that
there are any current users of memory.events that would find this change
undesirable.

Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kernel-team@fb.com
---
 Documentation/admin-guide/cgroup-v2.rst |  9 +++++++++
 include/linux/cgroup-defs.h             |  5 +++++
 include/linux/memcontrol.h              | 10 ++++++++--
 kernel/cgroup/cgroup.c                  | 16 ++++++++++++++--
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index ab9f3ee4ca33..841eb80f32d2 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -177,6 +177,15 @@ cgroup v2 currently supports the following mount options.
 	ignored on non-init namespace mounts.  Please refer to the
 	Delegation section for details.
 
+  memory_localevents
+
+        Only populate memory.events with data for the current cgroup,
+        and not any subtrees. This is legacy behaviour, the default
+        behaviour without this option is to include subtree counts.
+        This option is system wide and can only be set on mount or
+        modified through remount from the init namespace. The mount
+        option is ignored on non-init namespace mounts.
+
 
 Organizing Processes and Threads
 --------------------------------
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 1c70803e9f77..53669fdd5fad 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -83,6 +83,11 @@ enum {
 	 * Enable cpuset controller in v1 cgroup to use v2 behavior.
 	 */
 	CGRP_ROOT_CPUSET_V2_MODE = (1 << 4),
+
+	/*
+	 * Enable legacy local memory.events.
+	 */
+	CGRP_ROOT_MEMORY_LOCAL_EVENTS = (1 << 5),
 };
 
 /* cftype->flags */
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 94f9c5bc26ff..534267947664 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -789,8 +789,14 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 static inline void memcg_memory_event(struct mem_cgroup *memcg,
 				      enum memcg_memory_event event)
 {
-	atomic_long_inc(&memcg->memory_events[event]);
-	cgroup_file_notify(&memcg->events_file);
+	do {
+		atomic_long_inc(&memcg->memory_events[event]);
+		cgroup_file_notify(&memcg->events_file);
+
+		if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+			break;
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		 !mem_cgroup_is_root(memcg));
 }
 
 static inline void memcg_memory_event_mm(struct mm_struct *mm,
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3f2b4bde0f9c..46e3bce3c7bc 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1775,11 +1775,13 @@ int cgroup_show_path(struct seq_file *sf, struct kernfs_node *kf_node,
 
 enum cgroup2_param {
 	Opt_nsdelegate,
+	Opt_memory_localevents,
 	nr__cgroup2_params
 };
 
 static const struct fs_parameter_spec cgroup2_param_specs[] = {
-	fsparam_flag  ("nsdelegate",		Opt_nsdelegate),
+	fsparam_flag("nsdelegate",		Opt_nsdelegate),
+	fsparam_flag("memory_localevents",	Opt_memory_localevents),
 	{}
 };
 
@@ -1802,6 +1804,9 @@ static int cgroup2_parse_param(struct fs_context *fc, struct fs_parameter *param
 	case Opt_nsdelegate:
 		ctx->flags |= CGRP_ROOT_NS_DELEGATE;
 		return 0;
+	case Opt_memory_localevents:
+		ctx->flags |= CGRP_ROOT_MEMORY_LOCAL_EVENTS;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -1813,6 +1818,11 @@ static void apply_cgroup_root_flags(unsigned int root_flags)
 			cgrp_dfl_root.flags |= CGRP_ROOT_NS_DELEGATE;
 		else
 			cgrp_dfl_root.flags &= ~CGRP_ROOT_NS_DELEGATE;
+
+		if (root_flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+			cgrp_dfl_root.flags |= CGRP_ROOT_MEMORY_LOCAL_EVENTS;
+		else
+			cgrp_dfl_root.flags &= ~CGRP_ROOT_MEMORY_LOCAL_EVENTS;
 	}
 }
 
@@ -1820,6 +1830,8 @@ static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root
 {
 	if (cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
 		seq_puts(seq, ",nsdelegate");
+	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
+		seq_puts(seq, ",memory_localevents");
 	return 0;
 }
 
@@ -6116,7 +6128,7 @@ static struct kobj_attribute cgroup_delegate_attr = __ATTR_RO(delegate);
 static ssize_t features_show(struct kobject *kobj, struct kobj_attribute *attr,
 			     char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "nsdelegate\n");
+	return snprintf(buf, PAGE_SIZE, "nsdelegate\nmemory_localevents\n");
 }
 static struct kobj_attribute cgroup_features_attr = __ATTR_RO(features);
 
-- 
2.20.1

