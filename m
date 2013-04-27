From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cpuset: fix cpu hotplug vs rebuild_sched_domains() race
Date: Sat, 27 Apr 2013 17:53:48 +0800
Message-ID: <517BA02C.8080005@huawei.com>
References: <517BA01C.6060806@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517BA01C.6060806-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zhong <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

rebuild_sched_domains() might pass doms with offlined cpu to
partition_sched_domains(), which results in an oops:

general protection fault: 0000 [#1] SMP
...
RIP: 0010:[<ffffffff81077a1e>]  [<ffffffff81077a1e>] get_group+0x6e/0x90
...
Call Trace:
 [<ffffffff8107f07c>] build_sched_domains+0x70c/0xcb0
 [<ffffffff8107f2a7>] ? build_sched_domains+0x937/0xcb0
 [<ffffffff81173f64>] ? kfree+0xe4/0x1b0
 [<ffffffff8107f6e0>] ? partition_sched_domains+0xc0/0x470
 [<ffffffff8107f905>] partition_sched_domains+0x2e5/0x470
 [<ffffffff8107f6e0>] ? partition_sched_domains+0xc0/0x470
 [<ffffffff810c9007>] ? generate_sched_domains+0xc7/0x530
 [<ffffffff810c94a8>] rebuild_sched_domains_locked+0x38/0x70
 [<ffffffff810cb4a4>] cpuset_write_resmask+0x1a4/0x500
 [<ffffffff810c8700>] ? cpuset_mount+0xe0/0xe0
 [<ffffffff810c7f50>] ? cpuset_read_u64+0x100/0x100
 [<ffffffff810be890>] ? cgroup_iter_next+0x90/0x90
 [<ffffffff810cb300>] ? cpuset_css_offline+0x70/0x70
 [<ffffffff810c1a73>] cgroup_file_write+0x133/0x2e0
 [<ffffffff8118995b>] vfs_write+0xcb/0x130
 [<ffffffff8118a174>] sys_write+0x64/0xa0

Reported-by: Li Zhong <zhong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b0f18ba..ef05901 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -769,12 +769,20 @@ static void rebuild_sched_domains_locked(void)
 	lockdep_assert_held(&cpuset_mutex);
 	get_online_cpus();
 
+	/*
+	 * We have raced with CPU hotplug. Don't do anything to avoid
+	 * passing doms with offlined cpu to partition_sched_domains().
+	 * Anyways, hotplug work item will rebuild sched domains.
+	 */
+	if (!cpumask_equal(top_cpuset.cpus_allowed, cpu_active_mask))
+		goto out;
+
 	/* Generate domain masks and attrs */
 	ndoms = generate_sched_domains(&doms, &attr);
 
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-
+out:
 	put_online_cpus();
 }
 #else /* !CONFIG_SMP */
-- 
1.8.0.2
