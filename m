From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 5/9] sched: loadavg: make calc_load_n() public
Date: Tue, 28 Aug 2018 13:22:54 -0400
Message-ID: <20180828172258.3185-6-hannes@cmpxchg.org>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7HJ/faUwNp70pvtX2vst2/bX0oNS92n5Rlox7XiLwSM=;
        b=jIhStVWDliq16204BH4yFa9JfJgW30tWLG33tq/hGkX5TwlOjEM92VNzEy1W/9O7pE
         cBjmnCwdKz8UyEdgbMFr76tZo60U94akOVfnGXPJwGhyJ2jAI6V5EDTlW3ue7cP8Yftu
         SO2cJUVsKNHMkuXOGhhs3rRs17g6cMePZcqzo3fCIh0X2kk147agMiJdTUrE/1sdntV7
         tnRo+E4nB7P/z/MofV9CTqpmRHNbu2EVBa3T/hj8k/wUbpTq3DsTxnyZN+8+xiuxL+gf
         97uIhkbqeig4moFP26DoLBm/yoFJkz7IdLsGW1BQoCbZHX5dSVYcG0/muFaHzH2Wi18f
         3xhw==
In-Reply-To: <20180828172258.3185-1-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

It's going to be used in a later patch. Keep the churn separate.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/sched/loadavg.h |   3 +
 kernel/sched/loadavg.c        | 138 +++++++++++++++++-----------------
 2 files changed, 72 insertions(+), 69 deletions(-)

diff --git a/include/linux/sched/loadavg.h b/include/linux/sched/loadavg.h
index cc9cc62bb1f8..4859bea47a7b 100644
--- a/include/linux/sched/loadavg.h
+++ b/include/linux/sched/loadavg.h
@@ -37,6 +37,9 @@ calc_load(unsigned long load, unsigned long exp, unsigned long active)
 	return newload / FIXED_1;
 }
 
+extern unsigned long calc_load_n(unsigned long load, unsigned long exp,
+				 unsigned long active, unsigned int n);
+
 #define LOAD_INT(x) ((x) >> FSHIFT)
 #define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
 
diff --git a/kernel/sched/loadavg.c b/kernel/sched/loadavg.c
index 54fbdfb2d86c..28a516575c18 100644
--- a/kernel/sched/loadavg.c
+++ b/kernel/sched/loadavg.c
@@ -91,6 +91,75 @@ long calc_load_fold_active(struct rq *this_rq, long adjust)
 	return delta;
 }
 
+/**
+ * fixed_power_int - compute: x^n, in O(log n) time
+ *
+ * @x:         base of the power
+ * @frac_bits: fractional bits of @x
+ * @n:         power to raise @x to.
+ *
+ * By exploiting the relation between the definition of the natural power
+ * function: x^n := x*x*...*x (x multiplied by itself for n times), and
+ * the binary encoding of numbers used by computers: n := \Sum n_i * 2^i,
+ * (where: n_i \elem {0, 1}, the binary vector representing n),
+ * we find: x^n := x^(\Sum n_i * 2^i) := \Prod x^(n_i * 2^i), which is
+ * of course trivially computable in O(log_2 n), the length of our binary
+ * vector.
+ */
+static unsigned long
+fixed_power_int(unsigned long x, unsigned int frac_bits, unsigned int n)
+{
+	unsigned long result = 1UL << frac_bits;
+
+	if (n) {
+		for (;;) {
+			if (n & 1) {
+				result *= x;
+				result += 1UL << (frac_bits - 1);
+				result >>= frac_bits;
+			}
+			n >>= 1;
+			if (!n)
+				break;
+			x *= x;
+			x += 1UL << (frac_bits - 1);
+			x >>= frac_bits;
+		}
+	}
+
+	return result;
+}
+
+/*
+ * a1 = a0 * e + a * (1 - e)
+ *
+ * a2 = a1 * e + a * (1 - e)
+ *    = (a0 * e + a * (1 - e)) * e + a * (1 - e)
+ *    = a0 * e^2 + a * (1 - e) * (1 + e)
+ *
+ * a3 = a2 * e + a * (1 - e)
+ *    = (a0 * e^2 + a * (1 - e) * (1 + e)) * e + a * (1 - e)
+ *    = a0 * e^3 + a * (1 - e) * (1 + e + e^2)
+ *
+ *  ...
+ *
+ * an = a0 * e^n + a * (1 - e) * (1 + e + ... + e^n-1) [1]
+ *    = a0 * e^n + a * (1 - e) * (1 - e^n)/(1 - e)
+ *    = a0 * e^n + a * (1 - e^n)
+ *
+ * [1] application of the geometric series:
+ *
+ *              n         1 - x^(n+1)
+ *     S_n := \Sum x^i = -------------
+ *             i=0          1 - x
+ */
+unsigned long
+calc_load_n(unsigned long load, unsigned long exp,
+	    unsigned long active, unsigned int n)
+{
+	return calc_load(load, fixed_power_int(exp, FSHIFT, n), active);
+}
+
 #ifdef CONFIG_NO_HZ_COMMON
 /*
  * Handle NO_HZ for the global load-average.
@@ -210,75 +279,6 @@ static long calc_load_nohz_fold(void)
 	return delta;
 }
 
-/**
- * fixed_power_int - compute: x^n, in O(log n) time
- *
- * @x:         base of the power
- * @frac_bits: fractional bits of @x
- * @n:         power to raise @x to.
- *
- * By exploiting the relation between the definition of the natural power
- * function: x^n := x*x*...*x (x multiplied by itself for n times), and
- * the binary encoding of numbers used by computers: n := \Sum n_i * 2^i,
- * (where: n_i \elem {0, 1}, the binary vector representing n),
- * we find: x^n := x^(\Sum n_i * 2^i) := \Prod x^(n_i * 2^i), which is
- * of course trivially computable in O(log_2 n), the length of our binary
- * vector.
- */
-static unsigned long
-fixed_power_int(unsigned long x, unsigned int frac_bits, unsigned int n)
-{
-	unsigned long result = 1UL << frac_bits;
-
-	if (n) {
-		for (;;) {
-			if (n & 1) {
-				result *= x;
-				result += 1UL << (frac_bits - 1);
-				result >>= frac_bits;
-			}
-			n >>= 1;
-			if (!n)
-				break;
-			x *= x;
-			x += 1UL << (frac_bits - 1);
-			x >>= frac_bits;
-		}
-	}
-
-	return result;
-}
-
-/*
- * a1 = a0 * e + a * (1 - e)
- *
- * a2 = a1 * e + a * (1 - e)
- *    = (a0 * e + a * (1 - e)) * e + a * (1 - e)
- *    = a0 * e^2 + a * (1 - e) * (1 + e)
- *
- * a3 = a2 * e + a * (1 - e)
- *    = (a0 * e^2 + a * (1 - e) * (1 + e)) * e + a * (1 - e)
- *    = a0 * e^3 + a * (1 - e) * (1 + e + e^2)
- *
- *  ...
- *
- * an = a0 * e^n + a * (1 - e) * (1 + e + ... + e^n-1) [1]
- *    = a0 * e^n + a * (1 - e) * (1 - e^n)/(1 - e)
- *    = a0 * e^n + a * (1 - e^n)
- *
- * [1] application of the geometric series:
- *
- *              n         1 - x^(n+1)
- *     S_n := \Sum x^i = -------------
- *             i=0          1 - x
- */
-static unsigned long
-calc_load_n(unsigned long load, unsigned long exp,
-	    unsigned long active, unsigned int n)
-{
-	return calc_load(load, fixed_power_int(exp, FSHIFT, n), active);
-}
-
 /*
  * NO_HZ can leave us missing all per-CPU ticks calling
  * calc_load_fold_active(), but since a NO_HZ CPU folds its delta into
-- 
2.18.0

