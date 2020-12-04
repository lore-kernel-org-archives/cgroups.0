From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v2] mm/memcontrol: make the slab
 calculation consistent
Date: Sat, 5 Dec 2020 00:19:30 +0800
Message-ID: <CAMZfGtUkQUoy39qyHLPTdBY_38U23yThmFaHx2yfqz5ocfMViw@mail.gmail.com>
References: <20201203031111.3187-1-songmuchun@bytedance.com> <20201204154613.GA176901@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fe+vbNKf2orQSQdQfp84tFWO7dmTK0e8xZVK2kuk9vc=;
        b=00ymjmeHcRm+t9WqfDypR12xjjGpRELcXY0sIkHfHtMG6GdeFg8EcQt28ccHWoeOIk
         tOcEiwui9V9z5lzZCtEYUMXKoXacmBh3GI5G/Obk0zIwy7KXlWsq7P8hxvuUC9JLs4cT
         NatI8Rdmu1F+VnftUvhJ6bJj+11mSL4aVSPk7Qt8f5pEYc29Sva7p5t1SmunuF4uZlLV
         DAoYBcmG/3chKFux9QqTK0Y+YruaH4fHQglRAaT4ywJ5KetCdUKm5N5kWPd6ultHAUpO
         G6oupDP9ndJQ4STkntJw/zwi4f1qtk5NJbc4eX9ND0GJAgw6X5UEcw2iFT1Opd4n3cKz
         V6IA==
In-Reply-To: <20201204154613.GA176901-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Fri, Dec 4, 2020 at 11:48 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Thu, Dec 03, 2020 at 11:11:11AM +0800, Muchun Song wrote:
> > Although the ratio of the slab is one, we also should read the ratio
> > from the related memory_stats instead of hard-coding. And the local
> > variable of size is already the value of slab_unreclaimable. So we
> > do not need to read again. Simplify the code here.
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
>
> I agree that ignoring the ratio right now is not very pretty, but
>
>                 size = memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
>                        memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B);
>                 seq_buf_printf(&s, "slab %llu\n", size);
>
> is way easier to understand and more robust than using idx and idx + 1
> and then requiring a series of BUG_ONs to ensure these two items are
> actually adjacent and in the right order.
>
> There is a redundant call to memcg_page_state(), granted, but that
> function is extremely cheap compared with e.g. seq_buf_printf().
>
> >  mm/memcontrol.c | 26 +++++++++++++++++++++-----
> >  1 file changed, 21 insertions(+), 5 deletions(-)
>
> IMO this really just complicates the code with little discernible
> upside. It's going to be a NAK from me, unfortunately.
>
>
> In retrospect, I think that memory_stats[] table was a mistake. It
> would probably be easier to implement this using a wrapper for
> memcg_page_state() that has a big switch() for unit
> conversion. Something like this:
>
> /* Translate stat items to the correct unit for memory.stat output */
> static unsigned long memcg_page_state_output(memcg, item)
> {
>         unsigned long value = memcg_page_state(memcg, item);
>         int unit = PAGE_SIZE;
>
>         switch (item) {
>         case NR_SLAB_RECLAIMABLE_B:
>         case NR_SLAB_UNRECLAIMABLE_B:
>         case WORKINGSET_REFAULT_ANON:
>         case WORKINGSET_REFAULT_FILE:
>         case WORKINGSET_ACTIVATE_ANON:
>         case WORKINGSET_ACTIVATE_FILE:
>         case WORKINGSET_RESTORE_ANON:
>         case WORKINGSET_RESTORE_FILE:
>         case MEMCG_PERCPU_B:
>                 unit = 1;
>                 break;
>         case NR_SHMEM_THPS:
>         case NR_FILE_THPS:
>         case NR_ANON_THPS:
>                 unit = HPAGE_PMD_SIZE;
>                 break;
>         case NR_KERNEL_STACK_KB:
>                 unit = 1024;
>                 break;
>         }
>
>         return value * unit;
> }
>
> This would fix the ratio inconsistency, get rid of the awkward mix of
> static and runtime initialization of the table, is probably about the
> same amount of code, but simpler and more obvious overall.

Good idea. I can do that :)

Thanks.

-- 
Yours,
Muchun
