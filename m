From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 1/4] kmemleak: free internal objects only if there're no
 leaks to be reported
Date: Fri, 28 Mar 2014 18:50:10 +0800
Message-ID: <533553E2.7050801@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Currently if you stop kmemleak thread before disabling kmemleak,
kmemleak objects will be freed and so you won't be able to check
previously reported leaks.

With this patch, kmemleak objects won't be freed if there're leaks
that can be reported.

v2: s/kmemleak_as_leaks/kmemleak_found_leaks

Acked-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 mm/kmemleak.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 31f01c5..474379e 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -218,7 +218,8 @@ static int kmemleak_stack_scan = 1;
 static DEFINE_MUTEX(scan_mutex);
 /* setting kmemleak=on, will set this var, skipping the disable */
 static int kmemleak_skip_disable;
-
+/* If there are leaks that can be reported */
+static bool kmemleak_found_leaks;
 
 /*
  * Early object allocation/freeing logging. Kmemleak is initialized after the
@@ -1382,9 +1383,12 @@ static void kmemleak_scan(void)
 	}
 	rcu_read_unlock();
 
-	if (new_leaks)
+	if (new_leaks) {
+		kmemleak_found_leaks = true;
+
 		pr_info("%d new suspected memory leaks (see "
 			"/sys/kernel/debug/kmemleak)\n", new_leaks);
+	}
 
 }
 
@@ -1592,6 +1596,8 @@ static void kmemleak_clear(void)
 		spin_unlock_irqrestore(&object->lock, flags);
 	}
 	rcu_read_unlock();
+
+	kmemleak_found_leaks = false;
 }
 
 /*
@@ -1685,12 +1691,11 @@ static const struct file_operations kmemleak_fops = {
 static void kmemleak_do_cleanup(struct work_struct *work)
 {
 	struct kmemleak_object *object;
-	bool cleanup = scan_thread == NULL;
 
 	mutex_lock(&scan_mutex);
 	stop_scan_thread();
 
-	if (cleanup) {
+	if (!kmemleak_found_leaks) {
 		rcu_read_lock();
 		list_for_each_entry_rcu(object, &object_list, object_list)
 			delete_object_full(object->pointer);
-- 
1.8.0.2
