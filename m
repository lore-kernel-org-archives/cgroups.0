From: Shaun Tancheff <shaun.tancheff-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] memcg: Default value setting in memcg-v1
Date: Thu,  6 Apr 2023 16:14:50 +0700
Message-ID: <20230406091450.167779-1-shaun.tancheff@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680772509;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ipUTWGxdYRj74U+3DQNtSBrS5nB5CEomlPaYC6O7z0k=;
        b=pK/TUbF9znkVQNFvKpzD8pRU/hqSACTv3jLy5n+Vt1LkSUM50jTDWJTsTz55PeX/f4
         ZKkHVHIalzFZnVrmuI2CrAd/hFqi2HP7zk/rSwt8yqMpuYkPRVswuCz+BtACRsB2EfWT
         n49yDrGrQqSTtyDK7FoW2zjaAjOhbiXOdvCWtXYakbayY5F1ovxk/Zdo6TKVhewBEyBs
         R/Exit9+ZqDLQpovjLZzH1L6dXnRFA81L8x64l4os+1Rbfu3RnfmT0WfCDe5nKhRdPwt
         5l0OEkpliXZm3BiHEp2HpaSjFLR0UO6J/DUl2mMQtvyrxogsuwofUcbjQa7zus+Nel3m
         hnxA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Shaun Tancheff <shaun.tancheff-ZPxbGqLxI0U@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Shaun Tancheff <shaun.tancheff-ZPxbGqLxI0U@public.gmane.org>

Setting min, low and high values with memcg-v1
provides bennefits for  users that are unable to update
to memcg-v2.

Setting min, low and high can be set in memcg-v1
to apply enough memory pressure to effective throttle
filesystem I/O without hitting memcg oom.

This can be enabled by setting the sysctl values:
  vm.memcg_v1_min_default
  vm.memcg_v1_low_default
  vm.memcg_v1_high_default

When a memory control group is newly crated the
min, low and high values are set to percent of the
maximum based on the min, low and high default
values respectively.

This resolves an issue with memory pressure when users
initiate unbounded I/O on various file systems such as
ext4, XFS and NFS.

Signed-off-by: Shaun Tancheff <shaun.tancheff-ZPxbGqLxI0U@public.gmane.org>
---
v0: Initial hard coded limits by percent.
v1: Added sysfs access and module parameters for percent values to enable
v2: Fix 32-bit, remove need for missing __udivdi3
v3: Added sysctl parameters and documentation
 .../admin-guide/cgroup-v1/memory.rst          | 33 +++++++++
 Documentation/admin-guide/sysctl/vm.rst       | 33 +++++++++
 include/linux/memcontrol.h                    |  5 ++
 kernel/sysctl.c                               | 29 ++++++++
 mm/memcontrol.c                               | 69 ++++++++++++++++++-
 5 files changed, 168 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 258e45cc3b2d..4b44e0da49d6 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -70,6 +70,15 @@ Brief summary of control files.
  memory.memsw.usage_in_bytes	     show current usage for memory+Swap
 				     (See 5.5 for details)
  memory.limit_in_bytes		     set/show limit of memory usage
+ memory.limit_in_bytes.min	     show current memory min setting not present
+				     on the root control group.
+				     (See sysctl's vm.memcg_v1_min_default)
+ memory.limit_in_bytes.low	     show current memory low setting not present
+				     on the root control group.
+				     (See sysctl's vm.memcg_v1_low_default)
+ memory.limit_in_bytes.high	     show current memory low setting not present
+				     on the root control group.
+				     (See sysctl's vm.memcg_v1_high_default)
  memory.memsw.limit_in_bytes	     set/show limit of memory+Swap usage
  memory.failcnt			     show the number of memory usage hits limits
  memory.memsw.failcnt		     show the number of memory+Swap hits limits
@@ -648,6 +657,30 @@ The output format of memory.numa_stat is::
 
 The "total" count is sum of file + anon + unevictable.
 
+5.6 limit_in_bytes.low, min, and high
+-------------------------------------
+
+These read-only values enable viewing the current low, min and high
+restrictions added to a newly created cgroup when the sysctl vm
+parameters: vm.memcg_v1_low_default, vm.memcg_v1_min_default,
+and vm.memcg_v1_high_default are enabled.
+
+Example usage:
+  sudo sysctl -w vm.memcg_v1_min_default=10
+  sudo sysctl -w vm.memcg_v1_low_default=30
+  sudo sysctl -w vm.memcg_v1_high_default=80
+
+  sudo mkdir /sys/fs/cgroup/memory/restrict
+  echo 100M | sudo tee /sys/fs/cgroup/memory/restrict/memory.limit_in_bytes
+  cat /sys/fs/cgroup/memory/restrict/memory.limit_in_bytes.min
+  2560
+  cat /sys/fs/cgroup/memory/restrict/memory.limit_in_bytes.low
+  7680
+  cat /sys/fs/cgroup/memory/restrict/memory.limit_in_bytes.high
+  20480
+  echo $$ | sudo tee /sys/fs/cgroup/memory/restrict/tasks
+  dd if=/dev/zero of=~/file.bin bs=10M status=progress
+
 6. Hierarchy support
 ====================
 
diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 988f6a4c8084..87eefa165f92 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -43,6 +43,9 @@ Currently, these files are in /proc/sys/vm:
 - legacy_va_layout
 - lowmem_reserve_ratio
 - max_map_count
+- memcg_v1_high_default
+- memcg_v1_low_default
+- memcg_v1_min_default
 - memory_failure_early_kill
 - memory_failure_recovery
 - min_free_kbytes
@@ -425,6 +428,36 @@ e.g., up to one or two maps per allocation.
 The default value is 65530.
 
 
+memcg_v1_min_default:
+=====================
+
+This file contains a percentage of the cgroup memory limit used to
+set the min value of a newly memory cgroup. This value is only used
+with memory cgroup v1 interface.
+
+The default is 0 (disabled). Range is [0, 100].
+
+
+memcg_v1_low_default:
+=====================
+
+This file contains a percentage of the cgroup memory limit used to
+set the low value of a newly memory cgroup. This value is only used
+with memory cgroup v1 interface.
+
+The default is 0 (disabled). Range is [0, 100].
+
+
+memcg_v1_high_default:
+======================
+
+This file contains a percentage of the cgroup memory limit used to
+set the high value of a newly memory cgroup. This value is only used
+with memory cgroup v1 interface.
+
+The default is 0 (disabled). Range is [0, 100].
+
+
 memory_failure_early_kill:
 ==========================
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 85dc9b88ea37..0592b5e19883 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -68,6 +68,11 @@ struct mem_cgroup_id {
 	refcount_t ref;
 };
 
+/* System default memory protection setting */
+extern int sysctl_memcg_min_default;
+extern int sysctl_memcg_low_default;
+extern int sysctl_memcg_high_default;
+
 /*
  * Per memcg event counter is incremented at every pagein/pageout. With THP,
  * it will be incremented by the number of pages. This counter is used
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 1c240d2c99bc..bf923e50e597 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2449,6 +2449,35 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+#endif
+#ifdef CONFIG_MEMCG
+	{
+		.procname	= "memcg_v1_min_default",
+		.data		= &sysctl_memcg_min_default,
+		.maxlen		= sizeof(sysctl_memcg_min_default),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE_HUNDRED,
+	},
+	{
+		.procname	= "memcg_v1_low_default",
+		.data		= &sysctl_memcg_low_default,
+		.maxlen		= sizeof(sysctl_memcg_low_default),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE_HUNDRED,
+	},
+	{
+		.procname	= "memcg_v1_high_default",
+		.data		= &sysctl_memcg_high_default,
+		.maxlen		= sizeof(sysctl_memcg_high_default),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE_HUNDRED,
+	},
 #endif
 	{ }
 };
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2eee092f8f11..74875178b48b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -82,6 +82,11 @@ struct mem_cgroup *root_mem_cgroup __read_mostly;
 DEFINE_PER_CPU(struct mem_cgroup *, int_active_memcg);
 EXPORT_PER_CPU_SYMBOL_GPL(int_active_memcg);
 
+/* System default memory protection setting */
+int sysctl_memcg_min_default __read_mostly = 0;
+int sysctl_memcg_low_default __read_mostly = 0;
+int sysctl_memcg_high_default __read_mostly = 0;
+
 /* Socket memory accounting disabled? */
 static bool cgroup_memory_nosocket __ro_after_init;
 
@@ -205,6 +210,7 @@ enum res_type {
 	_MEMSWAP,
 	_KMEM,
 	_TCP,
+	_MEM_V1,
 };
 
 #define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
@@ -3676,6 +3682,9 @@ enum {
 	RES_MAX_USAGE,
 	RES_FAILCNT,
 	RES_SOFT_LIMIT,
+	RES_LIMIT_MIN,
+	RES_LIMIT_LOW,
+	RES_LIMIT_HIGH,
 };
 
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
@@ -3686,6 +3695,7 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 
 	switch (MEMFILE_TYPE(cft->private)) {
 	case _MEM:
+	case _MEM_V1:
 		counter = &memcg->memory;
 		break;
 	case _MEMSWAP:
@@ -3716,6 +3726,12 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 		return counter->failcnt;
 	case RES_SOFT_LIMIT:
 		return (u64)memcg->soft_limit * PAGE_SIZE;
+	case RES_LIMIT_MIN:
+		return (u64)READ_ONCE(memcg->memory.min);
+	case RES_LIMIT_LOW:
+		return (u64)READ_ONCE(memcg->memory.low);
+	case RES_LIMIT_HIGH:
+		return (u64)READ_ONCE(memcg->memory.high);
 	default:
 		BUG();
 	}
@@ -3815,6 +3831,34 @@ static int memcg_update_tcp_max(struct mem_cgroup *memcg, unsigned long max)
 	return ret;
 }
 
+static inline void mem_cgroup_v1_set_defaults(struct mem_cgroup *memcg,
+					      unsigned long nr_pages)
+{
+	unsigned long min, low, high;
+
+	if (mem_cgroup_is_root(memcg) || PAGE_COUNTER_MAX == nr_pages)
+		return;
+
+	min = READ_ONCE(memcg->memory.min);
+	low = READ_ONCE(memcg->memory.low);
+	if (min || low)
+		return;
+
+	if (!min && sysctl_memcg_min_default > 0) {
+		min = (nr_pages * sysctl_memcg_min_default) / 100;
+		page_counter_set_min(&memcg->memory, min);
+	}
+	if (!low && sysctl_memcg_low_default > 0) {
+		low = (nr_pages * sysctl_memcg_low_default) / 100;
+		page_counter_set_low(&memcg->memory, low);
+	}
+	high = READ_ONCE(memcg->memory.high);
+	if (high == PAGE_COUNTER_MAX && sysctl_memcg_high_default) {
+		high = (nr_pages * sysctl_memcg_high_default) / 100;
+		page_counter_set_high(&memcg->memory, high);
+	}
+}
+
 /*
  * The user of this function is...
  * RES_LIMIT.
@@ -3838,6 +3882,11 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 			break;
 		}
 		switch (MEMFILE_TYPE(of_cft(of)->private)) {
+		case _MEM_V1:
+			ret = mem_cgroup_resize_max(memcg, nr_pages, false);
+			if (!ret)
+				mem_cgroup_v1_set_defaults(memcg, nr_pages);
+			break;
 		case _MEM:
 			ret = mem_cgroup_resize_max(memcg, nr_pages, false);
 			break;
@@ -5000,10 +5049,28 @@ static struct cftype mem_cgroup_legacy_files[] = {
 	},
 	{
 		.name = "limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEM, RES_LIMIT),
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT),
 		.write = mem_cgroup_write,
 		.read_u64 = mem_cgroup_read_u64,
 	},
+	{
+		.name = "limit_in_bytes.min",
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT_MIN),
+		.read_u64 = mem_cgroup_read_u64,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "limit_in_bytes.low",
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT_LOW),
+		.read_u64 = mem_cgroup_read_u64,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+	{
+		.name = "limit_in_bytes.high",
+		.private = MEMFILE_PRIVATE(_MEM_V1, RES_LIMIT_HIGH),
+		.read_u64 = mem_cgroup_read_u64,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{
 		.name = "soft_limit_in_bytes",
 		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
-- 
2.34.1

