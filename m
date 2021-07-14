From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 5/6] sched/isolation: Make HK_FLAG_DOMAIN mutable
Date: Wed, 14 Jul 2021 15:54:19 +0200
Message-ID: <20210714135420.69624-6-frederic@kernel.org>
References: <20210714135420.69624-1-frederic@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626270883;
        bh=O229mw0OsYonqnla3B0erH7G0s9Elg+HGWDgWtK6t+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhSb6Pq7sjBh+cqtbSrpESdStSIYlsy4oWUPELHUbDVe0MC5v2nk3FuTV0A1ojsXE
         2yrnEBq1nQYP8/nm01SxPj7bHq+eByuI66TfNuVP3rtHWvscebpUGamncVIHRBB0FT
         9KkilYvvqz9ugnA1/iq7xUcZT9JvJ3ORTL5cU6hhxTIa9/kHtLKkS2aoCBoP1D0Zbj
         RlN8I47s8ydI/OXPPE/ZFB47WkukDGq5Qrz8BhlPn66IajrBnKXJthKFwaFWC+GI0R
         2s2pOAXN6dryXF3v4krQfikp+JOjqt0Ztz4NmsL4+D3k7QgMBUE5ikWvW2SUbmQMmn
         EzekiOFu22keQ==
In-Reply-To: <20210714135420.69624-1-frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>, Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In order to prepare supporting "isolcpus=" changes toward cpuset,
provide an API to modify the "isolcpus=" cpumask passed on boot.

TODO:

* Propagate the change to all interested subsystems (workqueue, net, pci)
* Make sure we can't concurrently change this cpumask (assert cpuset_rwsem
  is held).

Signed-off-by: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nitesh Lal <nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Nicolas Saenz <nsaenzju-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Christoph Lameter <cl-LoxgEY9JZOazQB+pC5nmwQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Alex Belits <abelits-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>
---
 include/linux/sched/isolation.h |  4 ++++
 kernel/sched/isolation.c        | 19 +++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cc9f393e2a70..a5960cb357d2 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -21,6 +21,7 @@ enum hk_flags {
 DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
 extern int housekeeping_any_cpu(enum hk_flags flags);
 extern const struct cpumask *housekeeping_cpumask(enum hk_flags flags);
+extern void housekeeping_cpumask_set(struct cpumask *mask, enum hk_flags flags);
 extern bool housekeeping_enabled(enum hk_flags flags);
 extern void housekeeping_affine(struct task_struct *t, enum hk_flags flags);
 extern bool housekeeping_test_cpu(int cpu, enum hk_flags flags);
@@ -38,6 +39,9 @@ static inline const struct cpumask *housekeeping_cpumask(enum hk_flags flags)
 	return cpu_possible_mask;
 }
 
+static inline void housekeeping_cpumask_set(struct cpumask *mask,
+					    enum hk_flags flags) { }
+
 static inline bool housekeeping_enabled(enum hk_flags flags)
 {
 	return false;
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index c2bdf7e6dc39..c071433059cf 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -68,7 +68,26 @@ bool housekeeping_test_cpu(int cpu, enum hk_flags flags)
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
+// Only support HK_FLAG_DOMAIN for now
+// TODO: propagate the changes through all interested subsystems:
+// workqueues, net, pci; ...
+void housekeeping_cpumask_set(struct cpumask *mask, enum hk_flags flags)
+{
+	/* Only HK_FLAG_DOMAIN change supported for now */
+	if (WARN_ON_ONCE(flags != HK_FLAG_DOMAIN))
+		return;
 
+	if (!static_key_enabled(&housekeeping_overridden.key)) {
+		if (cpumask_equal(mask, cpu_possible_mask))
+			return;
+		if (WARN_ON_ONCE(!alloc_cpumask_var(&hk_domain_mask, GFP_KERNEL)))
+			return;
+		cpumask_copy(hk_domain_mask, mask);
+		static_branch_enable(&housekeeping_overridden);
+	} else {
+		cpumask_copy(hk_domain_mask, mask);
+	}
+}
 
 void __init housekeeping_init(void)
 {
-- 
2.25.1

