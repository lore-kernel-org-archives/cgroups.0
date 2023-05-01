From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 18/40] lib: introduce support for page allocation tagging
Date: Mon,  1 May 2023 09:54:28 -0700
Message-ID: <20230501165450.15352-19-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960149; x=1685552149;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ANclwoiguD8BsbfKgYnGL1LnBw+SqNV6XnzUrNDvkRU=;
        b=PkT7GX0UpBWBL3ZxZZQ1u+ssYXtbTc+WLolVY9j+MP76VowH5UScBu+NGiGIbJ7Y6L
         eZfY/6ZYqoCRi2CKlp/WtuvsiD21usF1/P37qu0gPbOtENmIl51pQz/p9+lm6j/kWelt
         Ov6MNUZwC6/nK8n86rfdlgBHbFP156NpwLcMsML+lMt+4KcACeUQ1EH3vrJuTYlZHnxu
         7BuZUefNEtoVSDEOw+FF7cwg3Q8gxPu6E4rHt6NEwlnEpLRRqtUVy0vsJsqLucVJRBrd
         gANWGNYs/01Nqy3PLDr7YbpWPHn8hbMhpjK41s03TQMV5IjienckbULG1YjCuS8h+b0d
         B72Q==
In-Reply-To: <20230501165450.15352-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

Introduce helper functions to easily instrument page allocators by
storing a pointer to the allocation tag associated with the code that
allocated the page in a page_ext field.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Co-developed-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/pgalloc_tag.h | 33 +++++++++++++++++++++++++++++++++
 lib/Kconfig.debug           |  1 +
 lib/alloc_tag.c             | 17 +++++++++++++++++
 mm/page_ext.c               | 12 +++++++++---
 4 files changed, 60 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/pgalloc_tag.h

diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
new file mode 100644
index 000000000000..f8c7b6ef9c75
--- /dev/null
+++ b/include/linux/pgalloc_tag.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * page allocation tagging
+ */
+#ifndef _LINUX_PGALLOC_TAG_H
+#define _LINUX_PGALLOC_TAG_H
+
+#include <linux/alloc_tag.h>
+#include <linux/page_ext.h>
+
+extern struct page_ext_operations page_alloc_tagging_ops;
+struct page_ext *lookup_page_ext(const struct page *page);
+
+static inline union codetag_ref *get_page_tag_ref(struct page *page)
+{
+	if (page && mem_alloc_profiling_enabled()) {
+		struct page_ext *page_ext = lookup_page_ext(page);
+
+		if (page_ext)
+			return (void *)page_ext + page_alloc_tagging_ops.offset;
+	}
+	return NULL;
+}
+
+static inline void pgalloc_tag_dec(struct page *page, unsigned int order)
+{
+	union codetag_ref *ref = get_page_tag_ref(page);
+
+	if (ref)
+		alloc_tag_sub(ref, PAGE_SIZE << order);
+}
+
+#endif /* _LINUX_PGALLOC_TAG_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index da0a91ea6042..d3aa5ee0bf0d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -967,6 +967,7 @@ config MEM_ALLOC_PROFILING
 	depends on DEBUG_FS
 	select CODE_TAGGING
 	select LAZY_PERCPU_COUNTER
+	select PAGE_EXTENSION
 	help
 	  Track allocation source code and record total allocation size
 	  initiated at that code location. The mechanism can be used to track
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 3c4cfeb79862..4a0b95a46b2e 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -4,6 +4,7 @@
 #include <linux/fs.h>
 #include <linux/gfp.h>
 #include <linux/module.h>
+#include <linux/page_ext.h>
 #include <linux/seq_buf.h>
 #include <linux/uaccess.h>
 
@@ -159,6 +160,22 @@ static bool alloc_tag_module_unload(struct codetag_type *cttype, struct codetag_
 	return module_unused;
 }
 
+static __init bool need_page_alloc_tagging(void)
+{
+	return true;
+}
+
+static __init void init_page_alloc_tagging(void)
+{
+}
+
+struct page_ext_operations page_alloc_tagging_ops = {
+	.size = sizeof(union codetag_ref),
+	.need = need_page_alloc_tagging,
+	.init = init_page_alloc_tagging,
+};
+EXPORT_SYMBOL(page_alloc_tagging_ops);
+
 static int __init alloc_tag_init(void)
 {
 	struct codetag_type *cttype;
diff --git a/mm/page_ext.c b/mm/page_ext.c
index dc1626be458b..eaf054ec276c 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -10,6 +10,7 @@
 #include <linux/page_idle.h>
 #include <linux/page_table_check.h>
 #include <linux/rcupdate.h>
+#include <linux/pgalloc_tag.h>
 
 /*
  * struct page extension
@@ -82,6 +83,9 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
 #if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
 	&page_idle_ops,
 #endif
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+	&page_alloc_tagging_ops,
+#endif
 #ifdef CONFIG_PAGE_TABLE_CHECK
 	&page_table_check_ops,
 #endif
@@ -90,7 +94,7 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
 unsigned long page_ext_size;
 
 static unsigned long total_usage;
-static struct page_ext *lookup_page_ext(const struct page *page);
+struct page_ext *lookup_page_ext(const struct page *page);
 
 bool early_page_ext __meminitdata;
 static int __init setup_early_page_ext(char *str)
@@ -199,7 +203,7 @@ void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
 	pgdat->node_page_ext = NULL;
 }
 
-static struct page_ext *lookup_page_ext(const struct page *page)
+struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long index;
@@ -219,6 +223,7 @@ static struct page_ext *lookup_page_ext(const struct page *page)
 					MAX_ORDER_NR_PAGES);
 	return get_entry(base, index);
 }
+EXPORT_SYMBOL(lookup_page_ext);
 
 static int __init alloc_node_page_ext(int nid)
 {
@@ -278,7 +283,7 @@ static bool page_ext_invalid(struct page_ext *page_ext)
 	return !page_ext || (((unsigned long)page_ext & PAGE_EXT_INVALID) == PAGE_EXT_INVALID);
 }
 
-static struct page_ext *lookup_page_ext(const struct page *page)
+struct page_ext *lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
@@ -295,6 +300,7 @@ static struct page_ext *lookup_page_ext(const struct page *page)
 		return NULL;
 	return get_entry(page_ext, pfn);
 }
+EXPORT_SYMBOL(lookup_page_ext);
 
 static void *__meminit alloc_page_ext(size_t size, int nid)
 {
-- 
2.40.1.495.gc816e09b53d-goog

