From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 02/10] mm: workingset: tell cache transitions from
 workingset thrashing
Date: Mon, 23 Jul 2018 15:36:09 +0200
Message-ID: <CAK8P3a3Nsmt54-ed_gWNev3CBS6_Sv5QGOw4G0sY4ZXOi1R4_Q@mail.gmail.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org> <20180712172942.10094-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=iy5DSd5SsMWRiRXoq36+M3ypjGDnNjEaGXsy5jowv6I=;
        b=RtlIiOpfW2dTDuyKCF0KzS9myXba1x5VKhiDT01yYMF7SPWwd2eqnQvGP93ZFYK7ED
         eJbPt0yyiyhhlr3dwMClb90V7AI62ee/Edi0aubkRML8W5mdrNpLlrZxRs8ZtvWG5Vt/
         HnMmpGAdX5bmTWFv2ag7dAmbR13D3EbMg9EYGx7rcR3pxbO373IZly2sSsbIqztazSvv
         T20LzQBkueF59VKWr/PjH6OL+U2GeU6sQsGYCNhg0h9NDukNiSYHahPNxLJVPxGygRrK
         SitAfbxYIDR4cukeVkEminzTPgOkIzTucSRnE8Lh+jQt+xZCW+cGpt7f65mFA0CPpnX4
         phqg==
In-Reply-To: <20180712172942.10094-3-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Linux-MM <linux-mm@kvack.org>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>

On Thu, Jul 12, 2018 at 7:29 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> How many page->flags does this leave us with on 32-bit?
>
>         20 bits are always page flags
>
>         21 if you have an MMU
>
>         23 with the zone bits for DMA, Normal, HighMem, Movable
>
>         29 with the sparsemem section bits
>
>         30 if PAE is enabled
>
>         31 with this patch.
>
> So on 32-bit PAE, that leaves 1 bit for distinguishing two NUMA
> nodes. If that's not enough, the system can switch to discontigmem and
> re-gain the 6 or 7 sparsemem section bits.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

It seems we ran out of bits on arm64 in randconfig builds:

In file included from /git/arm-soc/include/linux/kernel.h:10,
                 from /git/arm-soc/arch/arm64/mm/init.c:20:
/git/arm-soc/arch/arm64/mm/init.c: In function 'mem_init':
/git/arm-soc/include/linux/compiler.h:357:38: error: call to
'__compiletime_assert_618' declared with attribute error: BUILD_BUG_ON
failed: sizeof(struct page) > (1 << STRUCT_PAGE_MAX_SHIFT)
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
                                      ^
/git/arm-soc/include/linux/compiler.h:337:4: note: in definition of
macro '__compiletime_assert'
    prefix ## suffix();    \
    ^~~~~~
/git/arm-soc/include/linux/compiler.h:357:2: note: in expansion of
macro '_compiletime_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
  ^~~~~~~~~~~~~~~~~~~
/git/arm-soc/include/linux/build_bug.h:45:37: note: in expansion of
macro 'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
/git/arm-soc/include/linux/build_bug.h:69:2: note: in expansion of
macro 'BUILD_BUG_ON_MSG'
  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
  ^~~~~~~~~~~~~~~~
/git/arm-soc/arch/arm64/mm/init.c:618:2: note: in expansion of macro
'BUILD_BUG_ON'
  BUILD_BUG_ON(sizeof(struct page) > (1 << STRUCT_PAGE_MAX_SHIFT));
  ^~~~~~~~~~~~
/git/arm-soc/scripts/Makefile.build:317: recipe for target
'arch/arm64/mm/init.o' failed

Apparently this triggered

#if SECTIONS_WIDTH+ZONES_WIDTH+NODES_SHIFT+LAST_CPUPID_SHIFT <=
BITS_PER_LONG - NR_PAGEFLAGS
#define LAST_CPUPID_WIDTH LAST_CPUPID_SHIFT
#else
#define LAST_CPUPID_WIDTH 0
#endif

and in turn

#if defined(CONFIG_NUMA_BALANCING) && LAST_CPUPID_WIDTH == 0
#define LAST_CPUPID_NOT_IN_PAGE_FLAGS
#endif

and that _last_cpupid in struct page made sizeof(struct page) larger than 64.

This is for a randconfig build, see https://pastebin.com/YuwSTah3
for the configuration file, some of the relevant options are

CONFIG_64BIT=y
CONFIG_MEMCG=y
CONFIG_SPARSEMEM=y
CONFIG_ARM64_PA_BITS=52
CONFIG_ARM64_64K_PAGES=y
CONFIG_NR_CPUS=64
CONFIG_NUMA_BALANCING=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_NODES_SHIFT=2
# CONFIG_ARCH_USES_PG_UNCACHED is not set
CONFIG_MEMORY_FAILURE=y
CONFIG_IDLE_PAGE_TRACKING=y

#define MAX_NR_ZONES 3
#define ZONES_SHIFT 2
#define MAX_PHYSMEM_BITS 52
#define SECTION_SIZE_BITS 30
#define SECTIONS_WIDTH 22
#define ZONES_WIDTH 2
#define NODES_SHIFT 2
#define LAST__PID_SHIFT 8
#define NR_CPUS_BITS 6
#define LAST_CPUPID_SHIFT 14
#define NR_PAGEFLAGS 25

With the extra page flag, the sum of SECTIONS_WIDTH, NODES_SHIFT,  ZONES_WIDTH,
LAST_CPUPID_SHIFT, and NR_PAGEFLAGS is now 65. Before this change, I could
not trigger that error in randconfig builds. However, setting CONFIG_NR_CPUS or
CONFIG_NODES_SHIFT higher than the defaults would trigger it as well (randconfig
does not randomize those options).

       Arnd
