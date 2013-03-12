From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 6/8] cgroup: remove unneeded includes from cgroup.h
Date: Tue, 12 Mar 2013 14:53:22 +0800
Message-ID: <513ED0E2.20302@huawei.com>
References: <513ED010.5060906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <513ED010.5060906@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>


Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 7e818a3..1f75a59 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -9,11 +9,8 @@
  */
 
 #include <linux/sched.h>
-#include <linux/cpumask.h>
-#include <linux/nodemask.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
-#include <linux/cgroupstats.h>
 #include <linux/prio_heap.h>
 #include <linux/rwsem.h>
 #include <linux/idr.h>
@@ -22,6 +19,7 @@
 
 #ifdef CONFIG_CGROUPS
 
+struct cgroupstats;
 struct cgroupfs_root;
 struct cgroup_subsys;
 struct inode;
-- 1.8.0.2 
