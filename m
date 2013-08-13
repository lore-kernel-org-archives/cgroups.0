From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] cpuset: remove an unncessary forward declaration
Date: Tue, 13 Aug 2013 09:17:33 +0800
Message-ID: <5209892D.8070502@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cpuset.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index bf69717..9d8d637 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -68,9 +68,6 @@
  */
 int number_of_cpusets __read_mostly;
 
-/* Forward declare cgroup structures */
-struct cgroup_subsys cpuset_subsys;
-
 /* See "Frequency meter" comments, below. */
 
 struct fmeter {
-- 
1.8.0.2
