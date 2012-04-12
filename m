From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 1/7] res_counter: add a function res_counter_move_parent().
Date: Thu, 12 Apr 2012 20:20:06 +0900
Message-ID: <4F86BA66.2010503@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F86B9BE.8000105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>


This function is used for moving accounting information to its
parent in the hierarchy of res_counter.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 include/linux/res_counter.h |    3 +++
 kernel/res_counter.c        |   13 +++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index da81af0..8919d3c 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -135,6 +135,9 @@ int __must_check res_counter_charge_nofail(struct res_counter *counter,
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
 void res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
+/* move resource to parent counter...i.e. just forget accounting in a child */
+void res_counter_move_parent(struct res_counter *counter, unsigned long val);
+
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index d508363..fafebf0 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -113,6 +113,19 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val)
 	local_irq_restore(flags);
 }
 
+/*
+ * In hierarchical accounting, child's usage is accounted into ancestors.
+ * To move local usage to its parent, just forget current level usage.
+ */
+void res_counter_move_parent(struct res_counter *counter, unsigned long val)
+{
+	unsigned long flags;
+
+	BUG_ON(!counter->parent);
+	spin_lock_irqsave(&counter->lock, flags);
+	res_counter_uncharge_locked(counter, val);
+	spin_unlock_irqrestore(&counter->lock, flags);
+}
 
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
-- 
1.7.4.1

