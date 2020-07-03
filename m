From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] arm64: Allocate crashkernel always in ZONE_DMA
Date: Fri, 3 Jul 2020 13:09:23 +0530
Message-ID: <CACi5LpOTwu-xYbPA2PDY3m-jKU50iO9UvkkkjuMb7wUit7Kpdg@mail.gmail.com>
References: <1593641660-13254-1-git-send-email-bhsharma@redhat.com>
 <1593641660-13254-3-git-send-email-bhsharma@redhat.com> <20200702075001.GA16113@willie-the-truck>
 <CACi5LpPn4QUjC692G=5UxLchpi+ZL+xFCcxqLbFvgvvcso28ww@mail.gmail.com> <eeea529a-14cd-3e2f-7a1c-c4c940967749@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593761981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=COuTBdKKfATNGseQylBEQ8M25EUASJk469Iefivx6yI=;
        b=JE791qR6G8o9hBNDoP62w50s6IoKAZiuTpUM0xx9w4DBP1JA05BeQVP0nzDDhDPGvZU3qt
        7XFvTJPcQr1kAr2LVji7dQuJpy8YKYOcna1lE+lLvVFAU0O5HL77NnnXj6x82vChwPawcY
        l9KlA29eSfH/UGJ8gxSFSwmhQ8rP7cg=
In-Reply-To: <eeea529a-14cd-3e2f-7a1c-c4c940967749-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Bhupesh SHARMA <bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kexec mailing list <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

Hi Chen,

On Fri, Jul 3, 2020 at 10:54 AM chenzhou <chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> Hi Bhupesh,
>
>
> On 2020/7/3 3:22, Bhupesh Sharma wrote:
> > Hi Will,
> >
> > On Thu, Jul 2, 2020 at 1:20 PM Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> On Thu, Jul 02, 2020 at 03:44:20AM +0530, Bhupesh Sharma wrote:
> >>> commit bff3b04460a8 ("arm64: mm: reserve CMA and crashkernel in
> >>> ZONE_DMA32") allocates crashkernel for arm64 in the ZONE_DMA32.
> >>>
> >>> However as reported by Prabhakar, this breaks kdump kernel booting in
> >>> ThunderX2 like arm64 systems. I have noticed this on another ampere
> >>> arm64 machine. The OOM log in the kdump kernel looks like this:
> >>>
> >>>   [    0.240552] DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
> >>>   [    0.247713] swapper/0: page allocation failure: order:1, mode:0xcc1(GFP_KERNEL|GFP_DMA), nodemask=(null),cpuset=/,mems_allowed=0
> >>>   <..snip..>
> >>>   [    0.274706] Call trace:
> >>>   [    0.277170]  dump_backtrace+0x0/0x208
> >>>   [    0.280863]  show_stack+0x1c/0x28
> >>>   [    0.284207]  dump_stack+0xc4/0x10c
> >>>   [    0.287638]  warn_alloc+0x104/0x170
> >>>   [    0.291156]  __alloc_pages_slowpath.constprop.106+0xb08/0xb48
> >>>   [    0.296958]  __alloc_pages_nodemask+0x2ac/0x2f8
> >>>   [    0.301530]  alloc_page_interleave+0x20/0x90
> >>>   [    0.305839]  alloc_pages_current+0xdc/0xf8
> >>>   [    0.309972]  atomic_pool_expand+0x60/0x210
> >>>   [    0.314108]  __dma_atomic_pool_init+0x50/0xa4
> >>>   [    0.318504]  dma_atomic_pool_init+0xac/0x158
> >>>   [    0.322813]  do_one_initcall+0x50/0x218
> >>>   [    0.326684]  kernel_init_freeable+0x22c/0x2d0
> >>>   [    0.331083]  kernel_init+0x18/0x110
> >>>   [    0.334600]  ret_from_fork+0x10/0x18
> >>>
> >>> This patch limits the crashkernel allocation to the first 1GB of
> >>> the RAM accessible (ZONE_DMA), as otherwise we might run into OOM
> >>> issues when crashkernel is executed, as it might have been originally
> >>> allocated from either a ZONE_DMA32 memory or mixture of memory chunks
> >>> belonging to both ZONE_DMA and ZONE_DMA32.
> >> How does this interact with this ongoing series:
> >>
> >> https://lore.kernel.org/r/20200628083458.40066-1-chenzhou10-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
> >>
> >> (patch 4, in particular)
> > Many thanks for having a look at this patchset. I was not aware that
> > Chen had sent out a new version.
> > I had noted in the v9 review of the high/low range allocation
> > <https://lists.gt.net/linux/kernel/3726052#3726052> that I was working
> > on a generic solution (irrespective of the crashkernel, low and high
> > range allocation) which resulted in this patchset.
> >
> > The issue is two-fold: OOPs in memcfg layer (PATCH 1/2, which has been
> > Acked-by memcfg maintainer) and OOM in the kdump kernel due to
> > crashkernel allocation in ZONE_DMA32 regions(s) which is addressed by
> > this PATCH.
> >
> > I will have a closer look at the v10 patchset Chen shared, but seems
> > it needs some rework as per Dave's review comments which he shared
> > today.
> > IMO, in the meanwhile this patchset  can be used to fix the existing
> > kdump issue with upstream kernel.
> Thanks for your work.
> There is no progress on the issue for long time, so i sent my solution in v8 comments
> and sent v9 recently.

Thanks a lot for your inputs. Well, I was working on the OOPs seen
with cgroups layer even when the memory cgroup is disabled via kdump
command line. As the cgroup maintainer also noted during the review of
PATCH 1/2 of this series, it's quite a corner case and hence hard to
debug. Hence the delay in sending out this series.

> I think direct limiting the crashkernel in ZONE_DMA isn't a good idea:
> 1. For parameter "crashkernel=Y", reserving crashkernel in first 1G memory will increase
> the probability of memory allocation failure.
> Previous discuss from https://lkml.org/lkml/2019/10/21/725:
>     "With ZONE_DMA=y, this config will fail to reserve 512M CMA on a server"

That is correct. However, we have limited options anyways at the
moment, hence the need for the crashkernel hi/low support series which
you are already working on. Unfortunately as I noted in the review of
the v10 series today, it still needs rework to fix
the OOM issue seen on ThunderX2 and ampere boards with crashkernel=X
kind of format.

See <http://lists.infradead.org/pipermail/kexec/2020-July/020825.html>
 for details.

So, to workaround the issue (while the crashkernel hi/lo support
series is reworked), the idea is to have similar kdump behaviour as we
were having on these boards before ZONE_DMA32 changes were introduced.

I am also working on fixing the '__dma_atomic_pool_init' behaviour
itself (inside 'kernel/dma/pool.c') to adapt to ZONE_DMA and
ZONE_DMA32 range availability in the kdump kernel, but this is a
complex implementation and requires thorough checks (especially with
drivers which can only work within ZONE_DMA memory regions in the
kdump kernel). Hence it might take some iterations to share a RFC
patch on the same.

I will send a v2 addressing Will's inputs shortly.

Thanks,
Bhupesh

> 2. For parameter "crashkernel=Y@X", limiting the crashkernel in ZONE_DMA is unreasonable
> for someone really want to reserve crashkernel from specified start address.
>
> I have sent v10: https://www.spinics.net/lists/arm-kernel/msg819408.html, any commets are welcome.
>
> Thanks,
> Chen Zhou
> >
> >>> Fixes: bff3b04460a8 ("arm64: mm: reserve CMA and crashkernel in ZONE_DMA32")
> >>> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >>> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >>> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>> Cc: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> >>> Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> >>> Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >>> Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> >>> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> >>> Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> >>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >>> Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> >>> Reported-by: Prabhakar Kushwaha <pkushwaha-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>
> >>> Signed-off-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>> ---
> >>>  arch/arm64/mm/init.c | 16 ++++++++++++++--
> >>>  1 file changed, 14 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> >>> index 1e93cfc7c47a..02ae4d623802 100644
> >>> --- a/arch/arm64/mm/init.c
> >>> +++ b/arch/arm64/mm/init.c
> >>> @@ -91,8 +91,15 @@ static void __init reserve_crashkernel(void)
> >>>       crash_size = PAGE_ALIGN(crash_size);
> >>>
> >>>       if (crash_base == 0) {
> >>> -             /* Current arm64 boot protocol requires 2MB alignment */
> >>> -             crash_base = memblock_find_in_range(0, arm64_dma32_phys_limit,
> >>> +             /* Current arm64 boot protocol requires 2MB alignment.
> >>> +              * Also limit the crashkernel allocation to the first
> >>> +              * 1GB of the RAM accessible (ZONE_DMA), as otherwise we
> >>> +              * might run into OOM issues when crashkernel is executed,
> >>> +              * as it might have been originally allocated from
> >>> +              * either a ZONE_DMA32 memory or mixture of memory
> >>> +              * chunks belonging to both ZONE_DMA and ZONE_DMA32.
> >>> +              */
> >> This comment needs help. Why does putting the crashkernel in ZONE_DMA
> >> prevent "OOM issues"?
> > Sure, I can work on adding more details in the comment so that it
> > explains the potential OOM issue(s) better.
> >
> > Thanks,
> > Bhupesh
> >
> >
> > .
> >
>
>

