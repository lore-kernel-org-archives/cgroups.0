From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 02/10] mm: workingset: tell cache transitions from
 workingset thrashing
Date: Mon, 23 Jul 2018 17:35:35 +0200
Message-ID: <CAK8P3a15K-TXYuFX-ZsJiroqA1GWX2XS4ioZSjcjJYgh1b_xSA@mail.gmail.com>
References: <20180712172942.10094-1-hannes@cmpxchg.org> <20180712172942.10094-3-hannes@cmpxchg.org>
 <CAK8P3a3Nsmt54-ed_gWNev3CBS6_Sv5QGOw4G0sY4ZXOi1R4_Q@mail.gmail.com> <20180723152323.GA3699@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=jOXEUEwojPSzHZIAs2rWvCfXbQ5Gp38MYhPZNpsoJKk=;
        b=E7ahjsC4oB1RgvOCKCDGsvgZOzzE3v836tRhPyESNbXSQ5SjmToZHNyOtFXJ5iz2lL
         yESOr/t/eF0ErNvhtYteGkSl8AmvXBCegyGeM58J97CxWJ9BfPKNn2pQo09xTfYvsoLQ
         033p3HydsU0OAjhOe0rJrnGu+cFbRqo21ccSK5fMYjYxXcuDNm/XJ2X/Kyh4ak6y4uQu
         kL2JY4u9KhmYjj43laWPiZ2dY5H8jTjvSrDd8L3mcMt+Jehb4hMhSsoa6SC8N+Qq1gMd
         vgd7N/nIat264gj88ifitkR9fqkvlRMr1Y2vzX1q5lo1gDporGKkZBH2qHqBI/i+S1v7
         3UpA==
In-Reply-To: <20180723152323.GA3699@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan <surenb@google.com>, Mike Galbraith <efault@gmx.de>, Will Deacon <will.deacon@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-team@fb.com, Linux-MM <linux-mm@kvack.org>, Vinayak Menon <vinmenon@codeaurora.org>, Ingo Molnar <mingo@redhat.com>, Shakeel Butt <shakeelb@google.com>, Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christopher Lameter <cl@linux.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>

On Mon, Jul 23, 2018 at 5:23 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Mon, Jul 23, 2018 at 03:36:09PM +0200, Arnd Bergmann wrote:
>> On Thu, Jul 12, 2018 at 7:29 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> In file included from /git/arm-soc/include/linux/kernel.h:10,
>>                  from /git/arm-soc/arch/arm64/mm/init.c:20:
>> /git/arm-soc/arch/arm64/mm/init.c: In function 'mem_init':
>> /git/arm-soc/include/linux/compiler.h:357:38: error: call to
>> '__compiletime_assert_618' declared with attribute error: BUILD_BUG_ON
>> failed: sizeof(struct page) > (1 << STRUCT_PAGE_MAX_SHIFT)
>
> This BUILD_BUG_ON() is to make sure we're sizing the VMEMMAP struct
> page array properly (address space divided by struct page size).
>
> From the code:
>
> /*
>  * Log2 of the upper bound of the size of a struct page. Used for sizing
>  * the vmemmap region only, does not affect actual memory footprint.
>  * We don't use sizeof(struct page) directly since taking its size here
>  * requires its definition to be available at this point in the inclusion
>  * chain, and it may not be a power of 2 in the first place.
>  */
> #define STRUCT_PAGE_MAX_SHIFT   6
>
...
> However, the check isn't conditional on that config option. And when
> VMEMMAP is disabled, we need 22 additional bits to identify the sparse
> memory sections in page->flags as well:
>
>> CONFIG_NODES_SHIFT=2
>> # CONFIG_ARCH_USES_PG_UNCACHED is not set
>> CONFIG_MEMORY_FAILURE=y
>> CONFIG_IDLE_PAGE_TRACKING=y
>>
>> #define MAX_NR_ZONES 3
>> #define ZONES_SHIFT 2
>> #define MAX_PHYSMEM_BITS 52
>> #define SECTION_SIZE_BITS 30
>> #define SECTIONS_WIDTH 22
>
> ^^^ Those we get back with VMEMMAP enabled.
>
> So for configs for which the check is intended, it passes. We just
> need to make it conditional to those.

Ok, thanks for the analysis, I had missed that and was about to
send a different patch to increase STRUCT_PAGE_MAX_SHIFT
in some configurations, which is not as good.

> From 1d24635a6c7cd395bad5c29a3b9e5d2e98d9ab84 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Mon, 23 Jul 2018 10:18:23 -0400
> Subject: [PATCH] arm64: fix vmemmap BUILD_BUG_ON() triggering on !vmemmap
>  setups
>
> Arnd reports the following arm64 randconfig build error with the PSI
> patches that add another page flag:
>

You could add further text here that I had just added to my
patch description (not sent):

    Further experiments show that the build error already existed before,
    but was only triggered with larger values of CONFIG_NR_CPU and/or
    CONFIG_NODES_SHIFT that might be used in actual configurations but
    not in randconfig builds.

    With longer CPU and node masks, I could recreate the problem with
    kernels as old as linux-4.7 when arm64 NUMA support got added.

    Cc: stable@vger.kernel.org
    Fixes: 1a2db300348b ("arm64, numa: Add NUMA support for arm64 platforms.")
    Fixes: 3e1907d5bf5a ("arm64: mm: move vmemmap region right below
the linear region")

>  arch/arm64/mm/init.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 1b18b4722420..72c9b6778b0a 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -611,11 +611,13 @@ void __init mem_init(void)
>         BUILD_BUG_ON(TASK_SIZE_32                       > TASK_SIZE_64);
>  #endif
>
> +#ifndef CONFIG_SPARSEMEM_VMEMMAP
>         /*

I tested it on two broken configurations, and found that you have
a typo here, it should be 'ifdef', not 'ifndef'. With that change, it
seems to build fine.

Tested-by: Arnd Bergmann <arnd@arndb.de>

      Arnd
