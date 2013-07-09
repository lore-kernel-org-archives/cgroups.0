From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.11-fixes] cgroup: remove bcache_subsys_id which
 got added stealthily
Date: Tue, 9 Jul 2013 16:33:38 -0700
Message-ID: <20130709233338.GB10374@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=+1Y+JKTA+iDNcLK7QONBTa1iLUqHCMqLBgjvSFrvwb4=;
        b=WfuiS+ju9/H6QtdyI5f7mbO1CAwvb9YkZKrEhzhWyHXusOq21IAzT1xo+kI+JPsBSu
         UeARx0L+Vy0pine7DNlMIobzuUfPYdBHrronudr1UzsfL/Hry9bokRX0mz+FclTCZG72
         LIiZZqfoMRTzZIvOlkTlSOoff6OA597GM/RtOAZhEiw5O7X1pm0uCV3F0dmiVvkh3HOu
         Lo2nQqYL43/BzqwQrT64D/A/LIqazM6w1ao8fnkblUNV3cV/lySYCzImMzKDaIvf7lGf
         DROLjDAmUP7PCfUgUEMH3gYGB4v1OdXoV/ruELewVTx9u86LU/hqnEjCXL5YrNfHT3KM
         DrRA==
Content-Disposition: inline
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From add0c59d802e6118e51e21244c3871be35164e4b Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 9 Jul 2013 16:17:39 -0700

cafe563591 ("bcache: A block layer cache") added a new cgroup
subsystem bcache_subsys without proper review and ack.  bcache_subsys
seems to use cgroup for group stats and per-group cache_mode
configuration.  This is very much the type of usage that we don't want
to allow.

Fortunately, CONFIG_CGROUP_BCACHE which enables bcache_subsys is
currently commented out, so this shouldn't have any upstream users.
Let's nip in the bud.  While at it, clarify in cgroup_subsys.h that no
new subsystem should be added without explicit acks from cgroup
maintainers.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Applied to cgroup/for-3.11-fixes.  Please don't do things like this
ever again.

Thanks.

 include/linux/cgroup_subsys.h | 45 +++++++------------------------------------
 1 file changed, 7 insertions(+), 38 deletions(-)

diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index 6e7ec64..b613ffd 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -1,86 +1,55 @@
-/* Add subsystem definitions of the form SUBSYS(<name>) in this
- * file. Surround each one by a line of comment markers so that
- * patches don't collide
+/*
+ * List of cgroup subsystems.
+ *
+ * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
  */
-
-/* */
-
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CPUSETS)
 SUBSYS(cpuset)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_DEBUG)
 SUBSYS(debug)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_SCHED)
 SUBSYS(cpu_cgroup)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_CPUACCT)
 SUBSYS(cpuacct)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_MEMCG)
 SUBSYS(mem_cgroup)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_DEVICE)
 SUBSYS(devices)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_FREEZER)
 SUBSYS(freezer)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_NET_CLS_CGROUP)
 SUBSYS(net_cls)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_BLK_CGROUP)
 SUBSYS(blkio)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_PERF)
 SUBSYS(perf)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_NETPRIO_CGROUP)
 SUBSYS(net_prio)
 #endif
 
-/* */
-
 #if IS_SUBSYS_ENABLED(CONFIG_CGROUP_HUGETLB)
 SUBSYS(hugetlb)
 #endif
-
-/* */
-
-#ifdef CONFIG_CGROUP_BCACHE
-SUBSYS(bcache)
-#endif
-
-/* */
+/*
+ * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
+ */
-- 
1.8.3.1
