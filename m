From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/40] Lazy percpu counters
Date: Mon,  1 May 2023 09:54:17 -0700
Message-ID: <20230501165450.15352-8-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960124; x=1685552124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O9K7OqGn67XevhyLqxW8/t3YPJ+QYtYh9lmzl+bkJrg=;
        b=uyQWn2HtrGHHQPYjCaEXS71WFvIKKSc7//EwH6w5zT7RuLTJsJvg4Siy51jlaOTMsf
         DmzxgGzQqK6buMAxRdIZF5co25tsVldyDbaF7rOabJEbLpi4XheA+l5VWP2IJDBlEIui
         J3jFl+rVymLiKhaaXfPqFSO8pBqa31LbX5CWrS5Wner2pA7Sqr1hkvfcI6t4MxiQZt9K
         qhkEpMVbiHPNZp9IQ6O2D9+a8gKMVQ/1Gtf9GajnR6izUu8XnftHHBs+v4IcA0SDdYNk
         NO/g09kaGZENLPill52iLrjrZMs4uUM92aRcipfW+xL+/5JdYb7kKitjTzDH4s2JKlli
         slTg==
In-Reply-To: <20230501165450.15352-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

This patch adds lib/lazy-percpu-counter.c, which implements counters
that start out as atomics, but lazily switch to percpu mode if the
update rate crosses some threshold (arbitrarily set at 256 per second).

Signed-off-by: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/lazy-percpu-counter.h | 102 ++++++++++++++++++++++
 lib/Kconfig                         |   3 +
 lib/Makefile                        |   2 +
 lib/lazy-percpu-counter.c           | 127 ++++++++++++++++++++++++++++
 4 files changed, 234 insertions(+)
 create mode 100644 include/linux/lazy-percpu-counter.h
 create mode 100644 lib/lazy-percpu-counter.c

diff --git a/include/linux/lazy-percpu-counter.h b/include/linux/lazy-percpu-counter.h
new file mode 100644
index 000000000000..45ca9e2ce58b
--- /dev/null
+++ b/include/linux/lazy-percpu-counter.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Lazy percpu counters:
+ * (C) 2022 Kent Overstreet
+ *
+ * Lazy percpu counters start out in atomic mode, then switch to percpu mode if
+ * the update rate crosses some threshold.
+ *
+ * This means we don't have to decide between low memory overhead atomic
+ * counters and higher performance percpu counters - we can have our cake and
+ * eat it, too!
+ *
+ * Internally we use an atomic64_t, where the low bit indicates whether we're in
+ * percpu mode, and the high 8 bits are a secondary counter that's incremented
+ * when the counter is modified - meaning 55 bits of precision are available for
+ * the counter itself.
+ */
+
+#ifndef _LINUX_LAZY_PERCPU_COUNTER_H
+#define _LINUX_LAZY_PERCPU_COUNTER_H
+
+#include <linux/atomic.h>
+#include <asm/percpu.h>
+
+struct lazy_percpu_counter {
+	atomic64_t			v;
+	unsigned long			last_wrap;
+};
+
+void lazy_percpu_counter_exit(struct lazy_percpu_counter *c);
+void lazy_percpu_counter_add_slowpath(struct lazy_percpu_counter *c, s64 i);
+void lazy_percpu_counter_add_slowpath_noupgrade(struct lazy_percpu_counter *c, s64 i);
+s64 lazy_percpu_counter_read(struct lazy_percpu_counter *c);
+
+/*
+ * We use the high bits of the atomic counter for a secondary counter, which is
+ * incremented every time the counter is touched. When the secondary counter
+ * wraps, we check the time the counter last wrapped, and if it was recent
+ * enough that means the update frequency has crossed our threshold and we
+ * switch to percpu mode:
+ */
+#define COUNTER_MOD_BITS		8
+#define COUNTER_MOD_MASK		~(~0ULL >> COUNTER_MOD_BITS)
+#define COUNTER_MOD_BITS_START		(64 - COUNTER_MOD_BITS)
+
+/*
+ * We use the low bit of the counter to indicate whether we're in atomic mode
+ * (low bit clear), or percpu mode (low bit set, counter is a pointer to actual
+ * percpu counters:
+ */
+#define COUNTER_IS_PCPU_BIT		1
+
+static inline u64 __percpu *lazy_percpu_counter_is_pcpu(u64 v)
+{
+	if (!(v & COUNTER_IS_PCPU_BIT))
+		return NULL;
+
+	v ^= COUNTER_IS_PCPU_BIT;
+	return (u64 __percpu *)(unsigned long)v;
+}
+
+/**
+ * lazy_percpu_counter_add: Add a value to a lazy_percpu_counter
+ *
+ * @c: counter to modify
+ * @i: value to add
+ */
+static inline void lazy_percpu_counter_add(struct lazy_percpu_counter *c, s64 i)
+{
+	u64 v = atomic64_read(&c->v);
+	u64 __percpu *pcpu_v = lazy_percpu_counter_is_pcpu(v);
+
+	if (likely(pcpu_v))
+		this_cpu_add(*pcpu_v, i);
+	else
+		lazy_percpu_counter_add_slowpath(c, i);
+}
+
+/**
+ * lazy_percpu_counter_add_noupgrade: Add a value to a lazy_percpu_counter,
+ * without upgrading to percpu mode
+ *
+ * @c: counter to modify
+ * @i: value to add
+ */
+static inline void lazy_percpu_counter_add_noupgrade(struct lazy_percpu_counter *c, s64 i)
+{
+	u64 v = atomic64_read(&c->v);
+	u64 __percpu *pcpu_v = lazy_percpu_counter_is_pcpu(v);
+
+	if (likely(pcpu_v))
+		this_cpu_add(*pcpu_v, i);
+	else
+		lazy_percpu_counter_add_slowpath_noupgrade(c, i);
+}
+
+static inline void lazy_percpu_counter_sub(struct lazy_percpu_counter *c, s64 i)
+{
+	lazy_percpu_counter_add(c, -i);
+}
+
+#endif /* _LINUX_LAZY_PERCPU_COUNTER_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 5c2da561c516..7380292a8fcd 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -505,6 +505,9 @@ config ASSOCIATIVE_ARRAY
 
 	  for more information.
 
+config LAZY_PERCPU_COUNTER
+	bool
+
 config HAS_IOMEM
 	bool
 	depends on !NO_IOMEM
diff --git a/lib/Makefile b/lib/Makefile
index 876fcdeae34e..293a0858a3f8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -164,6 +164,8 @@ obj-$(CONFIG_DEBUG_PREEMPT) += smp_processor_id.o
 obj-$(CONFIG_DEBUG_LIST) += list_debug.o
 obj-$(CONFIG_DEBUG_OBJECTS) += debugobjects.o
 
+obj-$(CONFIG_LAZY_PERCPU_COUNTER) += lazy-percpu-counter.o
+
 obj-$(CONFIG_BITREVERSE) += bitrev.o
 obj-$(CONFIG_LINEAR_RANGES) += linear_ranges.o
 obj-$(CONFIG_PACKING)	+= packing.o
diff --git a/lib/lazy-percpu-counter.c b/lib/lazy-percpu-counter.c
new file mode 100644
index 000000000000..4f4e32c2dc09
--- /dev/null
+++ b/lib/lazy-percpu-counter.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/atomic.h>
+#include <linux/gfp.h>
+#include <linux/jiffies.h>
+#include <linux/lazy-percpu-counter.h>
+#include <linux/percpu.h>
+
+static inline s64 lazy_percpu_counter_atomic_val(s64 v)
+{
+	/* Ensure output is sign extended properly: */
+	return (v << COUNTER_MOD_BITS) >>
+		(COUNTER_MOD_BITS + COUNTER_IS_PCPU_BIT);
+}
+
+static void lazy_percpu_counter_switch_to_pcpu(struct lazy_percpu_counter *c)
+{
+	u64 __percpu *pcpu_v = alloc_percpu_gfp(u64, GFP_ATOMIC|__GFP_NOWARN);
+	u64 old, new, v;
+
+	if (!pcpu_v)
+		return;
+
+	preempt_disable();
+	v = atomic64_read(&c->v);
+	do {
+		if (lazy_percpu_counter_is_pcpu(v)) {
+			free_percpu(pcpu_v);
+			return;
+		}
+
+		old = v;
+		new = (unsigned long)pcpu_v | 1;
+
+		*this_cpu_ptr(pcpu_v) = lazy_percpu_counter_atomic_val(v);
+	} while ((v = atomic64_cmpxchg(&c->v, old, new)) != old);
+	preempt_enable();
+}
+
+/**
+ * lazy_percpu_counter_exit: Free resources associated with a
+ * lazy_percpu_counter
+ *
+ * @c: counter to exit
+ */
+void lazy_percpu_counter_exit(struct lazy_percpu_counter *c)
+{
+	free_percpu(lazy_percpu_counter_is_pcpu(atomic64_read(&c->v)));
+}
+EXPORT_SYMBOL_GPL(lazy_percpu_counter_exit);
+
+/**
+ * lazy_percpu_counter_read: Read current value of a lazy_percpu_counter
+ *
+ * @c: counter to read
+ */
+s64 lazy_percpu_counter_read(struct lazy_percpu_counter *c)
+{
+	s64 v = atomic64_read(&c->v);
+	u64 __percpu *pcpu_v = lazy_percpu_counter_is_pcpu(v);
+
+	if (pcpu_v) {
+		int cpu;
+
+		v = 0;
+		for_each_possible_cpu(cpu)
+			v += *per_cpu_ptr(pcpu_v, cpu);
+	} else {
+		v = lazy_percpu_counter_atomic_val(v);
+	}
+
+	return v;
+}
+EXPORT_SYMBOL_GPL(lazy_percpu_counter_read);
+
+void lazy_percpu_counter_add_slowpath(struct lazy_percpu_counter *c, s64 i)
+{
+	u64 atomic_i;
+	u64 old, v = atomic64_read(&c->v);
+	u64 __percpu *pcpu_v;
+
+	atomic_i  = i << COUNTER_IS_PCPU_BIT;
+	atomic_i &= ~COUNTER_MOD_MASK;
+	atomic_i |= 1ULL << COUNTER_MOD_BITS_START;
+
+	do {
+		pcpu_v = lazy_percpu_counter_is_pcpu(v);
+		if (pcpu_v) {
+			this_cpu_add(*pcpu_v, i);
+			return;
+		}
+
+		old = v;
+	} while ((v = atomic64_cmpxchg(&c->v, old, old + atomic_i)) != old);
+
+	if (unlikely(!(v & COUNTER_MOD_MASK))) {
+		unsigned long now = jiffies;
+
+		if (c->last_wrap &&
+		    unlikely(time_after(c->last_wrap + HZ, now)))
+			lazy_percpu_counter_switch_to_pcpu(c);
+		else
+			c->last_wrap = now;
+	}
+}
+EXPORT_SYMBOL(lazy_percpu_counter_add_slowpath);
+
+void lazy_percpu_counter_add_slowpath_noupgrade(struct lazy_percpu_counter *c, s64 i)
+{
+	u64 atomic_i;
+	u64 old, v = atomic64_read(&c->v);
+	u64 __percpu *pcpu_v;
+
+	atomic_i  = i << COUNTER_IS_PCPU_BIT;
+	atomic_i &= ~COUNTER_MOD_MASK;
+
+	do {
+		pcpu_v = lazy_percpu_counter_is_pcpu(v);
+		if (pcpu_v) {
+			this_cpu_add(*pcpu_v, i);
+			return;
+		}
+
+		old = v;
+	} while ((v = atomic64_cmpxchg(&c->v, old, old + atomic_i)) != old);
+}
+EXPORT_SYMBOL(lazy_percpu_counter_add_slowpath_noupgrade);
-- 
2.40.1.495.gc816e09b53d-goog

