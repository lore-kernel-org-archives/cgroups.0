From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] cgroup: define empty cftype structure for !CONFIG_CGROUPS
Date: Fri, 21 Apr 2017 23:41:43 +0200
Message-ID: <20170421214206.1825504-1-arnd@arndb.de>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There is a new forward declaration for two global cftype arrays, but
that fails to build when CONFIG_CGROUPS is disabled:

In file included from /git/arm-soc/block/bfq-iosched.c:105:0:
block/bfq-iosched.h:820:22: error: array type has incomplete element type 'struct cftype'
 extern struct cftype bfq_blkcg_legacy_files[];
 extern struct cftype bfq_blkg_files[];

This adds an empty definition for the type to make it build again.

Fixes: ea25da48086d ("block, bfq: split bfq-iosched.c into multiple source files")
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 include/linux/cgroup-defs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 21745946cae1..cb3cc9588622 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -556,6 +556,9 @@ static inline void cgroup_threadgroup_change_end(struct task_struct *tsk)
 
 #else	/* CONFIG_CGROUPS */
 
+struct cftype {
+};
+
 #define CGROUP_SUBSYS_COUNT 0
 
 static inline void cgroup_threadgroup_change_begin(struct task_struct *tsk)
-- 
2.9.0
