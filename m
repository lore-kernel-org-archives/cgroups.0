From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: charge before adding to swapcache on swapin
Date: Mon, 22 Feb 2021 10:45:54 -0800
Message-ID: <CALvZod6Uf4w1xTrM6wSuGyefqWSfauXiJbCex_OnhY2g-Kadhw@mail.gmail.com>
References: <20210219224405.1544597-1-shakeelb@google.com> <YDBZFY8WnLewRqLg@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EF4DZ8/YPHLgiqcKgmmLocSOb1RhL6xlS59EKbvTOMk=;
        b=l7F/ZAQ0Ut25vN6NuV1Mgnps+4oWPHrywIpIgaIMkipU6kKTEaaav9qFISBOq1DdyE
         NxV5B0YqGvSpNTeBTU4M8gA9rVt3DhfzqEvukbwx9tXDmt6zQ2n3ccGgf5qIKe49GnOK
         +MG8d7OArOJULgO1WVyGHqga7pkUYoKEF0jYlWUT7KupD2fnJOKOBEvX+wG9rctXY6A0
         huZx9EPyD30ZfcsfqJCpapDIv4dTgJ9lGV8+dWQVJX0mNpKcf+5Bv88WBKvJOqVaTD7s
         YZ1Umhgva/38fQ8BD83N9bpYvAW5BKOdVqDYTmQ9f7UVVfHRMuI58kMKCF4Rq1tWhOEZ
         1ufg==
In-Reply-To: <YDBZFY8WnLewRqLg-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 19, 2021 at 4:34 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> On Fri, Feb 19, 2021 at 02:44:05PM -0800, Shakeel Butt wrote:
> > Currently the kernel adds the page, allocated for swapin, to the
> > swapcache before charging the page. This is fine but now we want a
> > per-memcg swapcache stat which is essential for folks who wants to
> > transparently migrate from cgroup v1's memsw to cgroup v2's memory and
> > swap counters.
> >
> > To correctly maintain the per-memcg swapcache stat, one option which
> > this patch has adopted is to charge the page before adding it to
> > swapcache. One challenge in this option is the failure case of
> > add_to_swap_cache() on which we need to undo the mem_cgroup_charge().
> > Specifically undoing mem_cgroup_uncharge_swap() is not simple.
> >
> > This patch circumvent this specific issue by removing the failure path
> > of  add_to_swap_cache() by providing __GFP_NOFAIL. Please note that in
> > this specific situation ENOMEM was the only possible failure of
> > add_to_swap_cache() which is removed by using __GFP_NOFAIL.
> >
> > Another option was to use __mod_memcg_lruvec_state(NR_SWAPCACHE) in
> > mem_cgroup_charge() but then we need to take of the do_swap_page() case
> > where synchronous swap devices bypass the swapcache. The do_swap_page()
> > already does hackery to set and reset PageSwapCache bit to make
> > mem_cgroup_charge() execute the swap accounting code and then we would
> > need to add additional parameter to tell to not touch NR_SWAPCACHE stat
> > as that code patch bypass swapcache.
> >
> > This patch added memcg charging API explicitly foe swapin pages and
> > cleaned up do_swap_page() to not set and reset PageSwapCache bit.
> >
> > Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> The patch makes sense to me. While it extends the charge interface, I
> actually quite like that it charges the page earlier - before putting
> it into wider circulation. It's a step in the right direction.
>
> But IMO the semantics of mem_cgroup_charge_swapin_page() are a bit too
> fickle: the __GFP_NOFAIL in add_to_swap_cache() works around it, but
> having a must-not-fail-after-this line makes the code tricky to work
> on and error prone.
>
> It would be nicer to do a proper transaction sequence.
>
> > @@ -497,16 +497,15 @@ struct page *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> >       __SetPageLocked(page);
> >       __SetPageSwapBacked(page);
> >
> > -     /* May fail (-ENOMEM) if XArray node allocation failed. */
> > -     if (add_to_swap_cache(page, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow)) {
> > -             put_swap_page(page, entry);
> > +     if (mem_cgroup_charge_swapin_page(page, NULL, gfp_mask, entry))
> >               goto fail_unlock;
> > -     }
> >
> > -     if (mem_cgroup_charge(page, NULL, gfp_mask)) {
> > -             delete_from_swap_cache(page);
> > -             goto fail_unlock;
> > -     }
> > +     /*
> > +      * Use __GFP_NOFAIL to not worry about undoing the changes done by
> > +      * mem_cgroup_charge_swapin_page() on failure of add_to_swap_cache().
> > +      */
> > +     add_to_swap_cache(page, entry,
> > +                       (gfp_mask|__GFP_NOFAIL) & GFP_RECLAIM_MASK, &shadow);
>
> How about:
>
>         mem_cgroup_charge_swapin_page()
>         add_to_swap_cache()
>         mem_cgroup_finish_swapin_page()
>
> where finish_swapin_page() only uncharges the swap entry (on cgroup1)
> once the swap->memory transition is complete?
>
> Otherwise the patch looks good to me.

Thanks for the review and yes this makes the code much more clear and
maintainable.
