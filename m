From: Yu Zhao <yuzhao@google.com>
Subject: [PATCH v2 3/3] swap: Increase the max swap files to 8192 on x86_64
Date: Wed,  2 Apr 2014 13:34:09 -0700
Message-ID: <1396470849-26154-4-git-send-email-yuzhao@google.com>
References: <1396470849-26154-1-git-send-email-yuzhao@google.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rKKd33fA8yWZUXaTNk9XBthC1U4UB+1KJPHqBGg5k80=;
        b=TaWMHZ8hMwMJ75VaOml7T5rpR7fSkC46KhqSxgMxWNVyGUGOZZsu6BYPt7Qwlmet7V
         Asl4OognLW5D8/LC2rPKQ8FeqY8kAFelm+50N7swYSOZCQRNgtBHqusdKpy1lZxM4rMM
         5MYNbkDpTeebyH4vQTBT4WRmaYTxLb/ucuO7GlgASCq4+sOYEcF7tJ+qpJbrKibV9Pv8
         Nd2niRR+yRwoAqmMxieKxz8NWgY2N0c1rswgSmEFPXx9u+KGAeyyuEdFToFOua0JWj5U
         wzHPa8DIcyLAzZ9r/hGjikJJ0gJCNcpj9lUzMfvUIUa8/qYLmcn6fMti5rWXab4SIT6f
         Tucw==
In-Reply-To: <1396470849-26154-1-git-send-email-yuzhao@google.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, cgroups@vger.kernel.org, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, jamieliu@google.com, suleiman@google.com, hannes@cmpxchg.org, Yu Zhao <yuzhao@google.com>

From: Suleiman Souhlal <suleiman@google.com>

Allow up to 8192 swap files on x86_64. Prior to this patch the limit was
32 swap files, which is not enough if we want to use per memory cgroup
swap files on a machine that has thousands of cgroups.

While this change also reduces the number of bits available for swap
offsets in the PTE, it does not actually impose any new restrictions on
the maximum size of swap files, as that is currently limited by the use
of 32bit values in other parts of the swap code.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 arch/x86/include/asm/pgtable_64.h | 62 ++++++++++++++++++++++++++++++---------
 include/linux/swap.h              |  7 +++--
 2 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index e22c1db..edb6962 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -142,23 +142,57 @@ static inline int pgd_large(pgd_t pgd) { return 0; }
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
 #define pte_unmap(pte) ((void)(pte))/* NOP */
 
-/* Encode and de-code a swap entry */
-#if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
-#define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
-#define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
-#else
-#define SWP_TYPE_BITS (_PAGE_BIT_PROTNONE - _PAGE_BIT_PRESENT - 1)
-#define SWP_OFFSET_SHIFT (_PAGE_BIT_FILE + 1)
-#endif
+/*
+ * Encode and de-code a swap entry
+ * We need to make sure we don't touch the _PAGE_PRESENT and _PAGE_FILE bits.
+ * All bit ranges below are inclusive.
+ *
+ * Bits 1-5 and 12-19 of the PTE are the type, while bits 20-63 are the offset.
+ *
+ * This enables us to have 8192 different swap types and 44 bit offsets.
+ */
+#define SWP_TYPE_BITS	13
+#define SWP_OFFSET_SHIFT 20
 
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
 
-#define __swp_type(x)			(((x).val >> (_PAGE_BIT_PRESENT + 1)) \
-					 & ((1U << SWP_TYPE_BITS) - 1))
-#define __swp_offset(x)			((x).val >> SWP_OFFSET_SHIFT)
-#define __swp_entry(type, offset)	((swp_entry_t) { \
-					 ((type) << (_PAGE_BIT_PRESENT + 1)) \
-					 | ((offset) << SWP_OFFSET_SHIFT) })
+#define __HAVE_ARCH_MAX_SWAPFILES_SHIFT
+#define MAX_SWAPFILES_SHIFT		13
+
+static inline unsigned long
+___swp_type(unsigned long val)
+{
+	unsigned long type;
+
+	/* Bits 1-5 */
+	type = (val >> 1) & 0x1f;
+	/* Bits 12-19 */
+	type |= (val >> 7) & 0x1fe0;
+
+	return type;
+}
+
+#define __swp_type(x)		(___swp_type((x).val))
+#define __swp_offset(x)		((x).val >> SWP_OFFSET_SHIFT)
+
+static inline unsigned long
+___swp_entry(unsigned long type, pgoff_t off)
+{
+	unsigned long e;
+
+	/* Bits 0-4 of type to bits 1-5 of entry */
+	e = (type & 0x1f) << 1;
+	/* Bits 5-12 of type to bits 12-19 of entry */
+	e |= (type & 0x1fe0) << 7;
+	/* off to bits 20-63 */
+	e |= off << SWP_OFFSET_SHIFT;
+
+	return e;
+}
+
+#define __swp_entry(type, offset)					\
+	((swp_entry_t) { ___swp_entry(type, offset) })
+
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val((pte)) })
 #define __swp_entry_to_pte(x)		((pte_t) { .pte = (x).val })
 
diff --git a/include/linux/swap.h b/include/linux/swap.h
index b6a280e..5e500f8 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -12,6 +12,7 @@
 #include <linux/atomic.h>
 #include <linux/page-flags.h>
 #include <asm/page.h>
+#include <asm/pgtable.h>
 
 struct notifier_block;
 
@@ -42,7 +43,9 @@ static inline int current_is_kswapd(void)
  * on 32-bit-pgoff_t architectures.  And that assumes that the architecture packs
  * the type/offset into the pte as 5/27 as well.
  */
+#ifndef __HAVE_ARCH_MAX_SWAPFILES_SHIFT
 #define MAX_SWAPFILES_SHIFT	5
+#endif
 
 /*
  * Use some of the swap files numbers for other purposes. This
@@ -221,8 +224,8 @@ struct percpu_cluster {
 struct swap_info_struct {
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
-	signed char	type;		/* strange name for an index */
-	signed char	next;		/* next type on the swap list */
+	int		type;		/* strange name for an index */
+	int		next;		/* next type on the swap list */
 	unsigned int	max;		/* extent of the swap_map */
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
-- 
1.9.1.423.g4596e3a

