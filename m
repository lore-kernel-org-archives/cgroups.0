From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] cpuset: Remove set but not used variable 'cs'
Date: Sat, 1 Dec 2018 03:12:56 +0000
Message-ID: <1543633976-183380-1-git-send-email-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan@huawei.com>, tj@kernel.org, mingo@kernel.org
Cc: YueHaibing <yuehaibing@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

kernel/cgroup/cpuset.c: In function 'cpuset_cancel_attach':
kernel/cgroup/cpuset.c:2167:17: warning:
 variable 'cs' set but not used [-Wunused-but-set-variable]

It never used since introduction in commit 1f7dd3e5a6e4 ("cgroup: fix handling
of multi-destination migration from subtree_control enabling")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 kernel/cgroup/cpuset.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e9f6906..48cfe55 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2164,10 +2164,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
-	struct cpuset *cs;
 
 	cgroup_taskset_first(tset, &css);
-	cs = css_cs(css);
 
 	mutex_lock(&cpuset_mutex);
 	css_cs(css)->attach_in_progress--;



