From: Zefan Li <lizefan@huawei.com>
Subject: [PATCH -next] cpuset: initialize cpuset a bit early
Date: Wed, 4 Mar 2015 17:09:33 +0800
Message-ID: <54F6CBCD.50009@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Ming Lei <tom.leiming@gmail.com>, Vladimir Davydov <vdavydov@parallels.com>

Now we call ss->bind() in cgroup_init(), so cgroup_init() will
call cpuset_bind() and then the latter will access top_cpuset's
cpumask, which is NULL, because cpuset_init() is called after
cgroup_init()

The simplest fix is to swap cgroup_init() and cpuset_init().

Cc: Vladimir Davydov <vdavydov@parallels.com>
Fixes: 295458e67284 ("cgroup: call cgroup_subsys->bind on cgroup subsys initialization")
Reported by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 init/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 61b9937..50d1e95 100644
--- a/init/main.c
+++ b/init/main.c
@@ -667,8 +667,8 @@ asmlinkage __visible void __init start_kernel(void)
 	page_writeback_init();
 	proc_root_init();
 	nsfs_init();
-	cgroup_init();
 	cpuset_init();
+	cgroup_init();
 	taskstats_init_early();
 	delayacct_init();
 
-- 
1.8.0.2
