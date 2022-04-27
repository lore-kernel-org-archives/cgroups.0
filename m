From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 1/5] mm: Kconfig: move swap and slab config options to the MM section
Date: Wed, 27 Apr 2022 12:00:12 -0400
Message-ID: <20220427160016.144237-2-hannes@cmpxchg.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bsj16Ee0guBN0gpdXp2AuLzbDIq1BETjMO2kD2xZlKg=;
        b=xi8WITLcAxwkSdTOuZL5LSJbzMRqu28W9ukS7yVDQ8SJy5Neabs9pQJOQ3iK1+e8FY
         NdIdJ9ggDKHPS/HSOBpDp6kjIYsmL+fLdAQICPOJJFmnlnh92CvZK5RZkvDYlmD05Xh9
         vEixjTl/uHsygAbohQm+HoKc9nk7cGrcyWoVSNrEfNYiZZtMrlbqAW+uTczPRJGSCDTm
         ClTVAFYUMgRydj0oOKOPLkCleCYl8J5At648Erjc496dnGgfHg9YCJyt4kCFPGRAbuJu
         16KbgJrA5NqyF4ktmStgevvE9dOM0RoW0wkWCXt3XSKUXovHFI2N+v4JoIBrVHv3n6Zd
         uxrg==
In-Reply-To: <20220427160016.144237-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

These are currently under General Setup. MM seems like a better fit.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 init/Kconfig | 123 ---------------------------------------------------
 mm/Kconfig   | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+), 123 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 4489416f1e5c..468fe27cec0b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -375,23 +375,6 @@ config DEFAULT_HOSTNAME
 	  but you may wish to use a different default here to make a minimal
 	  system more usable with less configuration.
 
-#
-# For some reason microblaze and nios2 hard code SWAP=n.  Hopefully we can
-# add proper SWAP support to them, in which case this can be remove.
-#
-config ARCH_NO_SWAP
-	bool
-
-config SWAP
-	bool "Support for paging of anonymous memory (swap)"
-	depends on MMU && BLOCK && !ARCH_NO_SWAP
-	default y
-	help
-	  This option allows you to choose whether you want to have support
-	  for so called swap devices or swap files in your kernel that are
-	  used to provide more virtual memory than the actual RAM present
-	  in your computer.  If unsure say Y.
-
 config SYSVIPC
 	bool "System V IPC"
 	help
@@ -1909,112 +1892,6 @@ config COMPAT_BRK
 
 	  On non-ancient distros (post-2000 ones) N is usually a safe choice.
 
-choice
-	prompt "Choose SLAB allocator"
-	default SLUB
-	help
-	   This option allows to select a slab allocator.
-
-config SLAB
-	bool "SLAB"
-	depends on !PREEMPT_RT
-	select HAVE_HARDENED_USERCOPY_ALLOCATOR
-	help
-	  The regular slab allocator that is established and known to work
-	  well in all environments. It organizes cache hot objects in
-	  per cpu and per node queues.
-
-config SLUB
-	bool "SLUB (Unqueued Allocator)"
-	select HAVE_HARDENED_USERCOPY_ALLOCATOR
-	help
-	   SLUB is a slab allocator that minimizes cache line usage
-	   instead of managing queues of cached objects (SLAB approach).
-	   Per cpu caching is realized using slabs of objects instead
-	   of queues of objects. SLUB can use memory efficiently
-	   and has enhanced diagnostics. SLUB is the default choice for
-	   a slab allocator.
-
-config SLOB
-	depends on EXPERT
-	bool "SLOB (Simple Allocator)"
-	depends on !PREEMPT_RT
-	help
-	   SLOB replaces the stock allocator with a drastically simpler
-	   allocator. SLOB is generally more space efficient but
-	   does not perform as well on large systems.
-
-endchoice
-
-config SLAB_MERGE_DEFAULT
-	bool "Allow slab caches to be merged"
-	default y
-	depends on SLAB || SLUB
-	help
-	  For reduced kernel memory fragmentation, slab caches can be
-	  merged when they share the same size and other characteristics.
-	  This carries a risk of kernel heap overflows being able to
-	  overwrite objects from merged caches (and more easily control
-	  cache layout), which makes such heap attacks easier to exploit
-	  by attackers. By keeping caches unmerged, these kinds of exploits
-	  can usually only damage objects in the same cache. To disable
-	  merging at runtime, "slab_nomerge" can be passed on the kernel
-	  command line.
-
-config SLAB_FREELIST_RANDOM
-	bool "Randomize slab freelist"
-	depends on SLAB || SLUB
-	help
-	  Randomizes the freelist order used on creating new pages. This
-	  security feature reduces the predictability of the kernel slab
-	  allocator against heap overflows.
-
-config SLAB_FREELIST_HARDENED
-	bool "Harden slab freelist metadata"
-	depends on SLAB || SLUB
-	help
-	  Many kernel heap attacks try to target slab cache metadata and
-	  other infrastructure. This options makes minor performance
-	  sacrifices to harden the kernel slab allocator against common
-	  freelist exploit methods. Some slab implementations have more
-	  sanity-checking than others. This option is most effective with
-	  CONFIG_SLUB.
-
-config SHUFFLE_PAGE_ALLOCATOR
-	bool "Page allocator randomization"
-	default SLAB_FREELIST_RANDOM && ACPI_NUMA
-	help
-	  Randomization of the page allocator improves the average
-	  utilization of a direct-mapped memory-side-cache. See section
-	  5.2.27 Heterogeneous Memory Attribute Table (HMAT) in the ACPI
-	  6.2a specification for an example of how a platform advertises
-	  the presence of a memory-side-cache. There are also incidental
-	  security benefits as it reduces the predictability of page
-	  allocations to compliment SLAB_FREELIST_RANDOM, but the
-	  default granularity of shuffling on the "MAX_ORDER - 1" i.e,
-	  10th order of pages is selected based on cache utilization
-	  benefits on x86.
-
-	  While the randomization improves cache utilization it may
-	  negatively impact workloads on platforms without a cache. For
-	  this reason, by default, the randomization is enabled only
-	  after runtime detection of a direct-mapped memory-side-cache.
-	  Otherwise, the randomization may be force enabled with the
-	  'page_alloc.shuffle' kernel command line parameter.
-
-	  Say Y if unsure.
-
-config SLUB_CPU_PARTIAL
-	default y
-	depends on SLUB && SMP
-	bool "SLUB per cpu partial cache"
-	help
-	  Per cpu partial caches accelerate objects allocation and freeing
-	  that is local to a processor at the price of more indeterminism
-	  in the latency of the free. On overflow these caches will be cleared
-	  which requires the taking of locks that may cause latency spikes.
-	  Typically one would choose no for a realtime system.
-
 config MMAP_ALLOW_UNINITIALIZED
 	bool "Allow mmapped anonymous memory to be uninitialized"
 	depends on EXPERT && !MMU
diff --git a/mm/Kconfig b/mm/Kconfig
index c2141dd639e3..675a6be43739 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -2,6 +2,129 @@
 
 menu "Memory Management options"
 
+#
+# For some reason microblaze and nios2 hard code SWAP=n.  Hopefully we can
+# add proper SWAP support to them, in which case this can be remove.
+#
+config ARCH_NO_SWAP
+	bool
+
+config SWAP
+	bool "Support for paging of anonymous memory (swap)"
+	depends on MMU && BLOCK && !ARCH_NO_SWAP
+	default y
+	help
+	  This option allows you to choose whether you want to have support
+	  for so called swap devices or swap files in your kernel that are
+	  used to provide more virtual memory than the actual RAM present
+	  in your computer.  If unsure say Y.
+
+choice
+	prompt "Choose SLAB allocator"
+	default SLUB
+	help
+	   This option allows to select a slab allocator.
+
+config SLAB
+	bool "SLAB"
+	depends on !PREEMPT_RT
+	select HAVE_HARDENED_USERCOPY_ALLOCATOR
+	help
+	  The regular slab allocator that is established and known to work
+	  well in all environments. It organizes cache hot objects in
+	  per cpu and per node queues.
+
+config SLUB
+	bool "SLUB (Unqueued Allocator)"
+	select HAVE_HARDENED_USERCOPY_ALLOCATOR
+	help
+	   SLUB is a slab allocator that minimizes cache line usage
+	   instead of managing queues of cached objects (SLAB approach).
+	   Per cpu caching is realized using slabs of objects instead
+	   of queues of objects. SLUB can use memory efficiently
+	   and has enhanced diagnostics. SLUB is the default choice for
+	   a slab allocator.
+
+config SLOB
+	depends on EXPERT
+	bool "SLOB (Simple Allocator)"
+	depends on !PREEMPT_RT
+	help
+	   SLOB replaces the stock allocator with a drastically simpler
+	   allocator. SLOB is generally more space efficient but
+	   does not perform as well on large systems.
+
+endchoice
+
+config SLAB_MERGE_DEFAULT
+	bool "Allow slab caches to be merged"
+	default y
+	depends on SLAB || SLUB
+	help
+	  For reduced kernel memory fragmentation, slab caches can be
+	  merged when they share the same size and other characteristics.
+	  This carries a risk of kernel heap overflows being able to
+	  overwrite objects from merged caches (and more easily control
+	  cache layout), which makes such heap attacks easier to exploit
+	  by attackers. By keeping caches unmerged, these kinds of exploits
+	  can usually only damage objects in the same cache. To disable
+	  merging at runtime, "slab_nomerge" can be passed on the kernel
+	  command line.
+
+config SLAB_FREELIST_RANDOM
+	bool "Randomize slab freelist"
+	depends on SLAB || SLUB
+	help
+	  Randomizes the freelist order used on creating new pages. This
+	  security feature reduces the predictability of the kernel slab
+	  allocator against heap overflows.
+
+config SLAB_FREELIST_HARDENED
+	bool "Harden slab freelist metadata"
+	depends on SLAB || SLUB
+	help
+	  Many kernel heap attacks try to target slab cache metadata and
+	  other infrastructure. This options makes minor performance
+	  sacrifices to harden the kernel slab allocator against common
+	  freelist exploit methods. Some slab implementations have more
+	  sanity-checking than others. This option is most effective with
+	  CONFIG_SLUB.
+
+config SHUFFLE_PAGE_ALLOCATOR
+	bool "Page allocator randomization"
+	default SLAB_FREELIST_RANDOM && ACPI_NUMA
+	help
+	  Randomization of the page allocator improves the average
+	  utilization of a direct-mapped memory-side-cache. See section
+	  5.2.27 Heterogeneous Memory Attribute Table (HMAT) in the ACPI
+	  6.2a specification for an example of how a platform advertises
+	  the presence of a memory-side-cache. There are also incidental
+	  security benefits as it reduces the predictability of page
+	  allocations to compliment SLAB_FREELIST_RANDOM, but the
+	  default granularity of shuffling on the "MAX_ORDER - 1" i.e,
+	  10th order of pages is selected based on cache utilization
+	  benefits on x86.
+
+	  While the randomization improves cache utilization it may
+	  negatively impact workloads on platforms without a cache. For
+	  this reason, by default, the randomization is enabled only
+	  after runtime detection of a direct-mapped memory-side-cache.
+	  Otherwise, the randomization may be force enabled with the
+	  'page_alloc.shuffle' kernel command line parameter.
+
+	  Say Y if unsure.
+
+config SLUB_CPU_PARTIAL
+	default y
+	depends on SLUB && SMP
+	bool "SLUB per cpu partial cache"
+	help
+	  Per cpu partial caches accelerate objects allocation and freeing
+	  that is local to a processor at the price of more indeterminism
+	  in the latency of the free. On overflow these caches will be cleared
+	  which requires the taking of locks that may cause latency spikes.
+	  Typically one would choose no for a realtime system.
+
 config SELECT_MEMORY_MODEL
 	def_bool y
 	depends on ARCH_SELECT_MEMORY_MODEL
-- 
2.35.3

