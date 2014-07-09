From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH v3 12/12] cpuset: export effective masks to userspace
Date: Wed, 9 Jul 2014 16:49:25 +0800
Message-ID: <53BD0215.8060305@huawei.com>
References: <53BD0174.4060002@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53BD0174.4060002@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>

cpuset.cpus and cpuset.mems are the configured masks, and we need
to export effective masks to userspace, so users know the real
cpus_allowed and mems_allowed that apply to the tasks in a cpuset.

v2:
- export those masks unconditionally, suggested by Tejun.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 65878a7..53a9bbf 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1535,6 +1535,8 @@ typedef enum {
 	FILE_MEMORY_MIGRATE,
 	FILE_CPULIST,
 	FILE_MEMLIST,
+	FILE_EFFECTIVE_CPULIST,
+	FILE_EFFECTIVE_MEMLIST,
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
 	FILE_MEM_HARDWALL,
@@ -1701,6 +1703,12 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	case FILE_MEMLIST:
 		s += nodelist_scnprintf(s, count, cs->mems_allowed);
 		break;
+	case FILE_EFFECTIVE_CPULIST:
+		s += cpulist_scnprintf(s, count, cs->effective_cpus);
+		break;
+	case FILE_EFFECTIVE_MEMLIST:
+		s += nodelist_scnprintf(s, count, cs->effective_mems);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out_unlock;
@@ -1786,6 +1794,18 @@ static struct cftype files[] = {
 	},
 
 	{
+		.name = "effective_cpus",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_EFFECTIVE_CPULIST,
+	},
+
+	{
+		.name = "effective_mems",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_EFFECTIVE_MEMLIST,
+	},
+
+	{
 		.name = "cpu_exclusive",
 		.read_u64 = cpuset_read_u64,
 		.write_u64 = cpuset_write_u64,
-- 
1.8.0.2
