From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 02/10] mm: workingset: tell cache transitions from
 workingset thrashing
Date: Mon, 23 Jul 2018 11:23:23 -0400
Message-ID: <20180723152323.GA3699@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-3-hannes@cmpxchg.org>
 <CAK8P3a3Nsmt54-ed_gWNev3CBS6_Sv5QGOw4G0sY4ZXOi1R4_Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8gUbTY31L9jtetP0QKK3YjtiDCim5q5h65mAiTslKbw=;
        b=p7XI6YoKQwZcvFSJmHIXpvLWyj5yI6RiKM4gZmxuCD0IVsLKLG0lw/eDMDfwPGL63F
         iZ3COdpapwZgJ9MlXlPUSW1TBb0wgrG//Uoo8qiXgQa0xofMyjl+HoZNCIvgosV2VOQY
         uavcNM/30Xnw2t2qQM61jJY7zQ7rJ7jFb21hyvgqp8uP2MFCJyXnf4QBpwHgJ/wHCKUJ
         4oPh86PH2c6wGHFMIqk61SaeqVlW8r8kA1CAfrUxqVAJn7h3XSLtXl8+QFHIa4rrbrzU
         CIv2XdUpir8J9aaadztO5V0ziRqzlanyhcMLLoXCH8D4m1iuRp3XEdEyhBQKd0wW/ch1
         5Xgg==
Content-Disposition: inline
In-Reply-To: <CAK8P3a3Nsmt54-ed_gWNev3CBS6_Sv5QGOw4G0sY4ZXOi1R4_Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Linux-MM <linux-mm@kvack.org>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>

Hi Arnd,

On Mon, Jul 23, 2018 at 03:36:09PM +0200, Arnd Bergmann wrote:
> On Thu, Jul 12, 2018 at 7:29 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > How many page->flags does this leave us with on 32-bit?
> >
> >         20 bits are always page flags
> >
> >         21 if you have an MMU
> >
> >         23 with the zone bits for DMA, Normal, HighMem, Movable
> >
> >         29 with the sparsemem section bits
> >
> >         30 if PAE is enabled
> >
> >         31 with this patch.
> >
> > So on 32-bit PAE, that leaves 1 bit for distinguishing two NUMA
> > nodes. If that's not enough, the system can switch to discontigmem and
> > re-gain the 6 or 7 sparsemem section bits.
> >
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> It seems we ran out of bits on arm64 in randconfig builds:
> 
> In file included from /git/arm-soc/include/linux/kernel.h:10,
>                  from /git/arm-soc/arch/arm64/mm/init.c:20:
> /git/arm-soc/arch/arm64/mm/init.c: In function 'mem_init':
> /git/arm-soc/include/linux/compiler.h:357:38: error: call to
> '__compiletime_assert_618' declared with attribute error: BUILD_BUG_ON
> failed: sizeof(struct page) > (1 << STRUCT_PAGE_MAX_SHIFT)

This BUILD_BUG_ON() is to make sure we're sizing the VMEMMAP struct
page array properly (address space divided by struct page size).

From the code:

/*
 * Log2 of the upper bound of the size of a struct page. Used for sizing
 * the vmemmap region only, does not affect actual memory footprint.
 * We don't use sizeof(struct page) directly since taking its size here
 * requires its definition to be available at this point in the inclusion
 * chain, and it may not be a power of 2 in the first place.
 */
#define STRUCT_PAGE_MAX_SHIFT	6

> Apparently this triggered
> 
> #if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_CPUPID_SHIFT <=
> BITS_PER_LONG - NR_PAGEFLAGS
> #define LAST_CPUPID_WIDTH LAST_CPUPID_SHIFT
> #else
> #define LAST_CPUPID_WIDTH 0
> #endif
> 
> and in turn
> 
> #if defined(CONFIG_NUMA_BALANCING) && LAST_CPUPID_WIDTH == 0
> #define LAST_CPUPID_NOT_IN_PAGE_FLAGS
> #endif
> 
> and that _last_cpupid in struct page made sizeof(struct page) larger than 64.
> 
> This is for a randconfig build, see https://pastebin.com/YuwSTah3
> for the configuration file, some of the relevant options are
> 
> CONFIG_64BIT=y
> CONFIG_MEMCG=y
> CONFIG_SPARSEMEM=y
> CONFIG_ARM64_PA_BITS=52
> CONFIG_ARM64_64K_PAGES=y
> CONFIG_NR_CPUS=64
> CONFIG_NUMA_BALANCING=y
> # CONFIG_SPARSEMEM_VMEMMAP is not set

However, the check isn't conditional on that config option. And when
VMEMMAP is disabled, we need 22 additional bits to identify the sparse
memory sections in page->flags as well:

> CONFIG_NODES_SHIFT=2
> # CONFIG_ARCH_USES_PG_UNCACHED is not set
> CONFIG_MEMORY_FAILURE=y
> CONFIG_IDLE_PAGE_TRACKING=y
> 
> #define MAX_NR_ZONES 3
> #define ZONES_SHIFT 2
> #define MAX_PHYSMEM_BITS 52
> #define SECTION_SIZE_BITS 30
> #define SECTIONS_WIDTH 22

^^^ Those we get back with VMEMMAP enabled.

So for configs for which the check is intended, it passes. We just
need to make it conditional to those.

---

From 1d24635a6c7cd395bad5c29a3b9e5d2e98d9ab84 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Mon, 23 Jul 2018 10:18:23 -0400
Subject: [PATCH] arm64: fix vmemmap BUILD_BUG_ON() triggering on !vmemmap
 setups

Arnd reports the following arm64 randconfig build error with the PSI
patches that add another page flag:

  /git/arm-soc/arch/arm64/mm/init.c: In function 'mem_init':
  /git/arm-soc/include/linux/compiler.h:357:38: error: call to
  '__compiletime_assert_618' declared with attribute error: BUILD_BUG_ON
  failed: sizeof(struct page) > (1 << STRUCT_PAGE_MAX_SHIFT)

The additional page flag causes other information stored in
page->flags to get bumped into their own struct page member:

  #if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_CPUPID_SHIFT <=
  BITS_PER_LONG - NR_PAGEFLAGS
  #define LAST_CPUPID_WIDTH LAST_CPUPID_SHIFT
  #else
  #define LAST_CPUPID_WIDTH 0
  #endif

  #if defined(CONFIG_NUMA_BALANCING) && LAST_CPUPID_WIDTH == 0
  #define LAST_CPUPID_NOT_IN_PAGE_FLAGS
  #endif

which in turn causes the struct page size to exceed the size set in
STRUCT_PAGE_MAX_SHIFT. This value is an an estimate used to size the
VMEMMAP page array according to address space and struct page size.

However, the check is performed - and triggers here - on a !VMEMMAP
config, which consumes an additional 22 page bits for the sparse
section id. When VMEMMAP is enabled, those bits are returned, cpupid
doesn't need its own member, and the page passes the VMEMMAP check.

Restrict that check to the situation it was meant to check: that we
are sizing the VMEMMAP page array correctly.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/arm64/mm/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 1b18b4722420..72c9b6778b0a 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -611,11 +611,13 @@ void __init mem_init(void)
 	BUILD_BUG_ON(TASK_SIZE_32			> TASK_SIZE_64);
 #endif
 
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
 	/*
 	 * Make sure we chose the upper bound of sizeof(struct page)
-	 * correctly.
+	 * correctly when sizing the VMEMMAP array.
 	 */
 	BUILD_BUG_ON(sizeof(struct page) > (1 << STRUCT_PAGE_MAX_SHIFT));
+#endif
 
 	if (PAGE_SIZE >= 16384 && get_num_physpages() <= 128) {
 		extern int sysctl_overcommit_memory;
-- 
2.18.0

