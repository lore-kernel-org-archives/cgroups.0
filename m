From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: update debug controller to print out thread mode
 information
Date: Thu, 15 Jun 2017 16:17:59 -0400
Message-ID: <20170615201759.GC25445@htj.duckdns.org>
References: <20170610140351.10703-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fncJ+gIQKcZ0YHFfH/uvHbPBAJZbv/JTMEvUrGDi+eM=;
        b=QchjC9tE/dT94SC/3qr51XLBwkTvpaG1tT98xOtzCMBLo7Udcvtao4v3giIcciDH6K
         ZlPPms3ZfgDdzc59gm7c2OUzBNab+Ush0X70DU2bmlDvipP3kjQuWnUYq5c5QRkVQea6
         2KuLdJdAR/Cjq4myef4PcnZS3/wXxsP448A2nfgE5nwCJS5UTb8XjRL97YGQghGuYgqr
         EOLzLivkGMR9ivhs2cDo38sa1Sq+/C0C6F7ZnxlKdP1oYXwpvKXaKRnNMzGZBBswI3Jh
         lIG6OkwXOqHRaZibEuSrqotg5VhNGZTCqdxkw3K8zt30YHG/I54thuQF0rA3v0G5eX2d
         +t1g==
Content-Disposition: inline
In-Reply-To: <20170610140351.10703-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Update debug controller so that it prints out debug info about thread
mode.

 1) The relationship between proc_cset and threaded_csets are displayed.
 2) The status of being a thread root or threaded cgroup is displayed.

This patch is extracted from Waiman's larger patch.

Patch-originally-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Hello,

Waiman, this is the thread mode support part of your debug patch.
I'll include this in the thread mode patchset and apply it together.
It seems to work fine but if you spot anything silly, please let me
know.

Thanks.

 kernel/cgroup/debug.c |   57 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 14 deletions(-)

--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -114,27 +114,53 @@ static int cgroup_css_links_read(struct
 {
 	struct cgroup_subsys_state *css = seq_css(seq);
 	struct cgrp_cset_link *link;
-	int dead_cnt = 0, extra_refs = 0;
+	int dead_cnt = 0, extra_refs = 0, threaded_csets = 0;
 
 	spin_lock_irq(&css_set_lock);
+
+	if (css->cgroup->proc_cgrp)
+		seq_puts(seq, (css->cgroup->proc_cgrp == css->cgroup) ?
+			 "[thread root]\n" : "[threaded]\n");
+
 	list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
 		struct css_set *cset = link->cset;
 		struct task_struct *task;
 		int count = 0;
 		int refcnt = refcount_read(&cset->refcount);
 
-		seq_printf(seq, " %d", refcnt);
-		if (refcnt - cset->nr_tasks > 0) {
-			int extra = refcnt - cset->nr_tasks;
-
-			seq_printf(seq, " +%d", extra);
-			/*
-			 * Take out the one additional reference in
-			 * init_css_set.
-			 */
-			if (cset == &init_css_set)
-				extra--;
-			extra_refs += extra;
+		/*
+		 * Print out the proc_cset and threaded_cset relationship
+		 * and highlight difference between refcount and task_count.
+		 */
+		seq_printf(seq, "css_set %pK", cset);
+		if (rcu_dereference_protected(cset->proc_cset, 1) != cset) {
+			threaded_csets++;
+			seq_printf(seq, "=>%pK", cset->proc_cset);
+		}
+		if (!list_empty(&cset->threaded_csets)) {
+			struct css_set *tcset;
+			int idx = 0;
+
+			list_for_each_entry(tcset, &cset->threaded_csets,
+					    threaded_csets_node) {
+				seq_puts(seq, idx ? "," : "<=");
+				seq_printf(seq, "%pK", tcset);
+				idx++;
+			}
+		} else {
+			seq_printf(seq, " %d", refcnt);
+			if (refcnt - cset->nr_tasks > 0) {
+				int extra = refcnt - cset->nr_tasks;
+
+				seq_printf(seq, " +%d", extra);
+				/*
+				 * Take out the one additional reference in
+				 * init_css_set.
+				 */
+				if (cset == &init_css_set)
+					extra--;
+				extra_refs += extra;
+			}
 		}
 		seq_puts(seq, "\n");
 
@@ -163,10 +189,12 @@ static int cgroup_css_links_read(struct
 	}
 	spin_unlock_irq(&css_set_lock);
 
-	if (!dead_cnt && !extra_refs)
+	if (!dead_cnt && !extra_refs && !threaded_csets)
 		return 0;
 
 	seq_puts(seq, "\n");
+	if (threaded_csets)
+		seq_printf(seq, "threaded css_sets = %d\n", threaded_csets);
 	if (extra_refs)
 		seq_printf(seq, "extra references = %d\n", extra_refs);
 	if (dead_cnt)
@@ -342,6 +370,7 @@ struct cgroup_subsys debug_cgrp_subsys =
 	.css_alloc	= debug_css_alloc,
 	.css_free	= debug_css_free,
 	.legacy_cftypes	= debug_legacy_files,
+	.threaded	= true,
 };
 
 /*
