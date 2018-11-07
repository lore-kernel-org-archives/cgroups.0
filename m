From: Yi Wang <wang.yi59@zte.com.cn>
Subject: [PATCH] cpuset: remove set but not used variable 'cs'
Date: Wed, 7 Nov 2018 15:18:31 +0800
Message-ID: <1541575111-36000-1-git-send-email-wang.yi59@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, zhong.weidong@zte.com.cn, Yi Wang <wang.yi59@zte.com.cn>

This fixes the following warning:
kernel/cgroup/cpuset.c: In function ‘cpuset_cancel_attach’:
kernel/cgroup/cpuset.c:1501:17: warning: variable ‘cs’ set but not used [-Wunused-but-set-variable]
  struct cpuset *cs;
                 ^

Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 kernel/cgroup/cpuset.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 266f10c..784f948 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1498,10 +1498,8 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 static void cpuset_cancel_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
-	struct cpuset *cs;
 
 	cgroup_taskset_first(tset, &css);
-	cs = css_cs(css);
 
 	mutex_lock(&cpuset_mutex);
 	css_cs(css)->attach_in_progress--;
-- 
1.8.3.1

