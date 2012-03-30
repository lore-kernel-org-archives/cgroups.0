From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [RFC 1/7] split percpu_counter_sum
Date: Fri, 30 Mar 2012 10:04:39 +0200
Message-ID: <1333094685-5507-2-git-send-email-glommer@parallels.com>
References: <1333094685-5507-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333094685-5507-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

Split the locked part so we can do other operations with the counter
in other call sites.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 include/linux/percpu_counter.h |    1 +
 lib/percpu_counter.c           |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index b9df9ed..8310548 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -40,6 +40,7 @@ void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 __percpu_counter_sum(struct percpu_counter *fbc);
+s64 __percpu_counter_sum_locked(struct percpu_counter *fbc);
 int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs);
 
 static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index f8a3f1a..0b6a672 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -93,17 +93,25 @@ EXPORT_SYMBOL(__percpu_counter_add);
  * Add up all the per-cpu counts, return the result.  This is a more accurate
  * but much slower version of percpu_counter_read_positive()
  */
-s64 __percpu_counter_sum(struct percpu_counter *fbc)
+s64 __percpu_counter_sum_locked(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
 
-	raw_spin_lock(&fbc->lock);
 	ret = fbc->count;
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
+	return ret;
+}
+EXPORT_SYMBOL(__percpu_counter_sum_locked);
+
+s64 __percpu_counter_sum(struct percpu_counter *fbc)
+{
+	s64 ret;
+	raw_spin_lock(&fbc->lock);
+	ret = __percpu_counter_sum_locked(fbc);
 	raw_spin_unlock(&fbc->lock);
 	return ret;
 }
-- 
1.7.4.1
