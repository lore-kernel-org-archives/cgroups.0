From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2 cgroup/for-3.20] cgroup: reorder SUBSYS(blkio) in
 cgroup_subsys.h
Date: Tue, 6 Jan 2015 11:57:20 -0500
Message-ID: <20150106165720.GI3077@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=MTN+Nh0hRASUnv6bq6wZ6G/pdP02OdJvkV4OSYS6NnY=;
        b=1DYOOGbN2PCgTsZ/TZOfmaxPmB2yKIk3ERUn17b+jHd63xG7y4vocEWhcKFa9Bpf1g
         lsQMAwcc5/TMYe4l2wDzBNZxQoNItewI6W6pcJ1C+FI70Qf6N2dO25ePcouJ2ymC7D7f
         I+CcIbqGagcJfXfDBCuCPsbHaapgfoLEY70KCjjmlTyLAT9WiaR7HA5MJDsEr8zkHlqa
         v4YQwT7M0NpxReF+0/1XM5TuNzQC7rw0kB/w1nanr1/pJQkM0No7LI9+KHNa62KaEZez
         QppxQ4XNh+gBYyXIwvdxsbuA2WS5r99lnv+CJaoCFZgktv571Zw6M8cGCFdAm8eQAu7r
         0tEA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The scheduled cgroup writeback support requires blkio to be
initialized before memcg as memcg needs to provide certain blkcg
related functionalities.  Relocate blkio so that it's right above
memory.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Hello,

These are two trivial patches to prepare for the cgroup writeback
support.  Applying to cgroup/for-3.20.

Thanks.

 include/linux/cgroup_subsys.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -15,6 +15,10 @@ SUBSYS(cpu)
 SUBSYS(cpuacct)
 #endif
 
+#if IS_ENABLED(CONFIG_BLK_CGROUP)
+SUBSYS(blkio)
+#endif
+
 #if IS_ENABLED(CONFIG_MEMCG)
 SUBSYS(memory)
 #endif
@@ -31,10 +35,6 @@ SUBSYS(freezer)
 SUBSYS(net_cls)
 #endif
 
-#if IS_ENABLED(CONFIG_BLK_CGROUP)
-SUBSYS(blkio)
-#endif
-
 #if IS_ENABLED(CONFIG_CGROUP_PERF)
 SUBSYS(perf_event)
 #endif
