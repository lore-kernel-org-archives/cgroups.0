From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 33/40] move stack capture functionality into a separate
 function for reuse
Date: Mon,  1 May 2023 09:54:43 -0700
Message-ID: <20230501165450.15352-34-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960183; x=1685552183;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bfMxO5ATd5n4S/fh5B/Nudv/nxDkBrDhDPER315pa0U=;
        b=ebS+MuTL+cQNWT4eZEJvTQOcTARn+QnzuJah4/SMgcb7+qkoUNzC7ex8MrpVKhZRXc
         KgeXlio4zrfdxmOppnmcCQe6TR+hOuBdIc9ihcKiKIEVRbsGHe8ObZbrrM4utujRh9wG
         TqBTS5rCEI/Jizsrf15UbPFacomNmio9VSdaY4o+amTMj91xth7X0uCHsGdXYXQ52AxU
         vnIxBaA8u69160qtwfedxuqqybJKyd5xlJm5XUDfPQCWKc/CaKvS4YCnPYvKKCkeigKq
         aazNcodiJ2//C8yradLEHTJBg1grANJmustwDAaYwDmuE541j3ivI8Z4B8/7N+gU15xY
         5tZw==
In-Reply-To: <20230501165450.15352-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org

Make save_stack() function part of stackdepot API to be used outside of
page_owner. Also rename task_struct's in_page_owner to in_capture_stack
flag to better convey the wider use of this flag.

Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/sched.h      |  6 ++--
 include/linux/stackdepot.h | 16 +++++++++
 lib/stackdepot.c           | 68 ++++++++++++++++++++++++++++++++++++++
 mm/page_owner.c            | 52 ++---------------------------
 4 files changed, 90 insertions(+), 52 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 33708bf8f191..6eca46ab6d78 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -942,9 +942,9 @@ struct task_struct {
 	/* Stalled due to lack of memory */
 	unsigned			in_memstall:1;
 #endif
-#ifdef CONFIG_PAGE_OWNER
-	/* Used by page_owner=on to detect recursion in page tracking. */
-	unsigned			in_page_owner:1;
+#ifdef CONFIG_STACKDEPOT
+	/* Used by stack_depot_capture_stack to detect recursion. */
+	unsigned			in_capture_stack:1;
 #endif
 #ifdef CONFIG_EVENTFD
 	/* Recursion prevention for eventfd_signal() */
diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index e58306783d8e..baf7e80cf449 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -164,4 +164,20 @@ depot_stack_handle_t __must_check stack_depot_set_extra_bits(
  */
 unsigned int stack_depot_get_extra_bits(depot_stack_handle_t handle);
 
+/**
+ * stack_depot_capture_init - Initialize stack depot capture mechanism
+ *
+ * Return: Stack depot initialization status
+ */
+bool stack_depot_capture_init(void);
+
+/**
+ * stack_depot_capture_stack - Capture current stack trace into stack depot
+ *
+ * @flags:	Allocation GFP flags
+ *
+ * Return: Handle of the stack trace stored in depot, 0 on failure
+ */
+depot_stack_handle_t stack_depot_capture_stack(gfp_t flags);
+
 #endif
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 2f5aa851834e..c7e5e22fcb16 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -539,3 +539,71 @@ unsigned int stack_depot_get_extra_bits(depot_stack_handle_t handle)
 	return parts.extra;
 }
 EXPORT_SYMBOL(stack_depot_get_extra_bits);
+
+static depot_stack_handle_t recursion_handle;
+static depot_stack_handle_t failure_handle;
+
+static __always_inline depot_stack_handle_t create_custom_stack(void)
+{
+	unsigned long entries[4];
+	unsigned int nr_entries;
+
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
+	return stack_depot_save(entries, nr_entries, GFP_KERNEL);
+}
+
+static noinline void register_recursion_stack(void)
+{
+	recursion_handle = create_custom_stack();
+}
+
+static noinline void register_failure_stack(void)
+{
+	failure_handle = create_custom_stack();
+}
+
+bool stack_depot_capture_init(void)
+{
+	static DEFINE_MUTEX(stack_depot_capture_init_mutex);
+	static bool utility_stacks_ready;
+
+	mutex_lock(&stack_depot_capture_init_mutex);
+	if (!utility_stacks_ready) {
+		register_recursion_stack();
+		register_failure_stack();
+		utility_stacks_ready = true;
+	}
+	mutex_unlock(&stack_depot_capture_init_mutex);
+
+	return utility_stacks_ready;
+}
+
+/* TODO: teach stack_depot_capture_stack to use off stack temporal storage */
+#define CAPTURE_STACK_DEPTH (16)
+
+depot_stack_handle_t stack_depot_capture_stack(gfp_t flags)
+{
+	unsigned long entries[CAPTURE_STACK_DEPTH];
+	depot_stack_handle_t handle;
+	unsigned int nr_entries;
+
+	/*
+	 * Avoid recursion.
+	 *
+	 * Sometimes page metadata allocation tracking requires more
+	 * memory to be allocated:
+	 * - when new stack trace is saved to stack depot
+	 * - when backtrace itself is calculated (ia64)
+	 */
+	if (current->in_capture_stack)
+		return recursion_handle;
+	current->in_capture_stack = 1;
+
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
+	handle = stack_depot_save(entries, nr_entries, flags);
+	if (!handle)
+		handle = failure_handle;
+
+	current->in_capture_stack = 0;
+	return handle;
+}
diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8b6086c666e6..9fafbc290d5b 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -15,12 +15,6 @@
 
 #include "internal.h"
 
-/*
- * TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stack)
- * to use off stack temporal storage
- */
-#define PAGE_OWNER_STACK_DEPTH (16)
-
 struct page_owner {
 	unsigned short order;
 	short last_migrate_reason;
@@ -37,8 +31,6 @@ struct page_owner {
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
-static depot_stack_handle_t dummy_handle;
-static depot_stack_handle_t failure_handle;
 static depot_stack_handle_t early_handle;
 
 static void init_early_allocated_pages(void);
@@ -68,16 +60,6 @@ static __always_inline depot_stack_handle_t create_dummy_stack(void)
 	return stack_depot_save(entries, nr_entries, GFP_KERNEL);
 }
 
-static noinline void register_dummy_stack(void)
-{
-	dummy_handle = create_dummy_stack();
-}
-
-static noinline void register_failure_stack(void)
-{
-	failure_handle = create_dummy_stack();
-}
-
 static noinline void register_early_stack(void)
 {
 	early_handle = create_dummy_stack();
@@ -88,8 +70,7 @@ static __init void init_page_owner(void)
 	if (!page_owner_enabled)
 		return;
 
-	register_dummy_stack();
-	register_failure_stack();
+	stack_depot_capture_init();
 	register_early_stack();
 	static_branch_enable(&page_owner_inited);
 	init_early_allocated_pages();
@@ -107,33 +88,6 @@ static inline struct page_owner *get_page_owner(struct page_ext *page_ext)
 	return (void *)page_ext + page_owner_ops.offset;
 }
 
-static noinline depot_stack_handle_t save_stack(gfp_t flags)
-{
-	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
-	depot_stack_handle_t handle;
-	unsigned int nr_entries;
-
-	/*
-	 * Avoid recursion.
-	 *
-	 * Sometimes page metadata allocation tracking requires more
-	 * memory to be allocated:
-	 * - when new stack trace is saved to stack depot
-	 * - when backtrace itself is calculated (ia64)
-	 */
-	if (current->in_page_owner)
-		return dummy_handle;
-	current->in_page_owner = 1;
-
-	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
-	handle = stack_depot_save(entries, nr_entries, flags);
-	if (!handle)
-		handle = failure_handle;
-
-	current->in_page_owner = 0;
-	return handle;
-}
-
 void __reset_page_owner(struct page *page, unsigned short order)
 {
 	int i;
@@ -146,7 +100,7 @@ void __reset_page_owner(struct page *page, unsigned short order)
 	if (unlikely(!page_ext))
 		return;
 
-	handle = save_stack(GFP_NOWAIT | __GFP_NOWARN);
+	handle = stack_depot_capture_stack(GFP_NOWAIT | __GFP_NOWARN);
 	for (i = 0; i < (1 << order); i++) {
 		__clear_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 		page_owner = get_page_owner(page_ext);
@@ -189,7 +143,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
 	struct page_ext *page_ext;
 	depot_stack_handle_t handle;
 
-	handle = save_stack(gfp_mask);
+	handle = stack_depot_capture_stack(gfp_mask);
 
 	page_ext = page_ext_get(page);
 	if (unlikely(!page_ext))
-- 
2.40.1.495.gc816e09b53d-goog

