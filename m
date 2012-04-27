From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [RFC][PATCH 3/7 v2] res_counter: add res_counter_uncharge_until()
Date: Fri, 27 Apr 2012 14:53:03 +0900
Message-ID: <4F9A343F.7020409@jp.fujitsu.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F9A327A.6050409-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

From bb0168d5c85f62f36434956e4728a67d0cc41e55 Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Date: Thu, 26 Apr 2012 18:48:07 +0900
Subject: [PATCH 3/9] memcg: add res_counter_uncharge_until()

At killing res_counter which is a child of other counter,
we need to do
	res_counter_uncharge(child, xxx)
	res_counter_charge(parent, xxx)

This is not atomic and wasting cpu. This patch adds
res_counter_uncharge_until(). This function's uncharge propagates
to ancestors until specified res_counter.

	res_counter_uncharge_until(child, parent, xxx)

This ops is atomic and more efficient.

Originaly-written-by: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 Documentation/cgroups/resource_counter.txt |    8 ++++++++
 include/linux/res_counter.h                |    3 +++
 kernel/res_counter.c                       |   13 +++++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
index 95b24d7..703103a 100644
--- a/Documentation/cgroups/resource_counter.txt
+++ b/Documentation/cgroups/resource_counter.txt
@@ -92,6 +92,14 @@ to work with it.
 
 	The _locked routines imply that the res_counter->lock is taken.
 
+ f. void res_counter_uncharge_until
+		(struct res_counter *rc, struct res_counter *top,
+		 unsinged long val)
+
+	Almost same as res_cunter_uncharge() but propagation of uncharge
+	stops when rc == top. This is useful when kill a res_coutner in
+	child cgroup.
+
  2.1 Other accounting routines
 
     There are more routines that may help you with common needs, like
diff --git a/include/linux/res_counter.h b/include/linux/res_counter.h
index da81af0..d11c1cd 100644
--- a/include/linux/res_counter.h
+++ b/include/linux/res_counter.h
@@ -135,6 +135,9 @@ int __must_check res_counter_charge_nofail(struct res_counter *counter,
 void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val);
 void res_counter_uncharge(struct res_counter *counter, unsigned long val);
 
+void res_counter_uncharge_until(struct res_counter *counter,
+				struct res_counter *top,
+				unsigned long val);
 /**
  * res_counter_margin - calculate chargeable space of a counter
  * @cnt: the counter
diff --git a/kernel/res_counter.c b/kernel/res_counter.c
index d508363..f4ec411 100644
--- a/kernel/res_counter.c
+++ b/kernel/res_counter.c
@@ -66,6 +66,8 @@ done:
 	return ret;
 }
 
+
+
 int res_counter_charge_nofail(struct res_counter *counter, unsigned long val,
 			      struct res_counter **limit_fail_at)
 {
@@ -99,13 +101,15 @@ void res_counter_uncharge_locked(struct res_counter *counter, unsigned long val)
 	counter->usage -= val;
 }
 
-void res_counter_uncharge(struct res_counter *counter, unsigned long val)
+void res_counter_uncharge_until(struct res_counter *counter,
+				struct res_counter *top,
+				unsigned long val)
 {
 	unsigned long flags;
 	struct res_counter *c;
 
 	local_irq_save(flags);
-	for (c = counter; c != NULL; c = c->parent) {
+	for (c = counter; c != top; c = c->parent) {
 		spin_lock(&c->lock);
 		res_counter_uncharge_locked(c, val);
 		spin_unlock(&c->lock);
@@ -113,6 +117,11 @@ void res_counter_uncharge(struct res_counter *counter, unsigned long val)
 	local_irq_restore(flags);
 }
 
+void res_counter_uncharge(struct res_counter *counter, unsigned long val)
+{
+	res_counter_uncharge_until(counter, NULL, val);
+}
+
 
 static inline unsigned long long *
 res_counter_member(struct res_counter *counter, int member)
-- 
1.7.4.1

