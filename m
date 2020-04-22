From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/18] mm: memcontrol: fix theoretical race in charge moving
Date: Wed, 22 Apr 2020 09:51:20 -0700
Message-ID: <CALvZod4gFC1TDo8dtdaeQKj_ZEoOnQvRnw_dZANH7qQYCmnnGA@mail.gmail.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org> <20200420221126.341272-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WMU2sdANRlebnl16w8n5PRa+nqFLI55fKcb7gFihZwY=;
        b=lb8r9xb492dHP5+E9i8W4r6C52dw70KTq4NynepcjSjXvxIqTqRhzsIw/ttkMxrwR+
         j65ZyTEhp61QhtOvHDWc1S1Gaoob8C7seTN0+h615yPlj2d3h6iKXEMBokSYRM7iBfw2
         wOx+DdKKvbiST5q/iSH8Zo6nzHoqELKr4D8cflowDrI/wIZIsZtR+puJFNCBBOQxCPFP
         zooVfRTMyWh0vdBpp4pjpVqBJTo8TpjwReKJMe+TIa/g0NEZPob/vo8o5fdY5lKWvlhe
         SAcrPWWpLCQCvjII891JE5HLeOF2Tg1gHwGQ+Pq6Z6lAAH1rPcLwEnbLP6JvB8ttEoSE
         Mstg==
In-Reply-To: <20200420221126.341272-3-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Mon, Apr 20, 2020 at 3:11 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> The move_lock is a per-memcg lock, but the VM accounting code that
> needs to acquire it comes from the page and follows page->mem_cgroup
> under RCU protection. That means that the page becomes unlocked not
> when we drop the move_lock, but when we update page->mem_cgroup. And
> that assignment doesn't imply any memory ordering. If that pointer
> write gets reordered against the reads of the page state -
> page_mapped, PageDirty etc. the state may change while we rely on it
> being stable and we can end up corrupting the counters.
>
> Place an SMP memory barrier to make sure we're done with all page
> state by the time the new page->mem_cgroup becomes visible.
>
> Also replace the open-coded move_lock with a lock_page_memcg() to make
> it more obvious what we're serializing against.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  mm/memcontrol.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5beea03dd58a..41f5ed79272e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5372,7 +5372,6 @@ static int mem_cgroup_move_account(struct page *page,
>  {
>         struct lruvec *from_vec, *to_vec;
>         struct pglist_data *pgdat;
> -       unsigned long flags;
>         unsigned int nr_pages = compound ? hpage_nr_pages(page) : 1;
>         int ret;
>         bool anon;
> @@ -5399,18 +5398,13 @@ static int mem_cgroup_move_account(struct page *page,
>         from_vec = mem_cgroup_lruvec(from, pgdat);
>         to_vec = mem_cgroup_lruvec(to, pgdat);
>
> -       spin_lock_irqsave(&from->move_lock, flags);
> +       lock_page_memcg(page);
>
>         if (!anon && page_mapped(page)) {
>                 __mod_lruvec_state(from_vec, NR_FILE_MAPPED, -nr_pages);
>                 __mod_lruvec_state(to_vec, NR_FILE_MAPPED, nr_pages);
>         }
>
> -       /*
> -        * move_lock grabbed above and caller set from->moving_account, so
> -        * mod_memcg_page_state will serialize updates to PageDirty.
> -        * So mapping should be stable for dirty pages.
> -        */
>         if (!anon && PageDirty(page)) {
>                 struct address_space *mapping = page_mapping(page);
>
> @@ -5426,15 +5420,23 @@ static int mem_cgroup_move_account(struct page *page,
>         }
>
>         /*
> +        * All state has been migrated, let's switch to the new memcg.
> +        *
>          * It is safe to change page->mem_cgroup here because the page
> -        * is referenced, charged, and isolated - we can't race with
> -        * uncharging, charging, migration, or LRU putback.
> +        * is referenced, charged, isolated, and locked: we can't race
> +        * with (un)charging, migration, LRU putback, or anything else
> +        * that would rely on a stable page->mem_cgroup.
> +        *
> +        * Note that lock_page_memcg is a memcg lock, not a page lock,
> +        * to save space. As soon as we switch page->mem_cgroup to a
> +        * new memcg that isn't locked, the above state can change
> +        * concurrently again. Make sure we're truly done with it.
>          */
> +       smp_mb();

You said theoretical race in the subject but the above comment
convinced me that smp_mb() is required. So, why is the race still
theoretical?

>
> -       /* caller should have done css_get */
> -       page->mem_cgroup = to;
> +       page->mem_cgroup = to;  /* caller should have done css_get */
>
> -       spin_unlock_irqrestore(&from->move_lock, flags);
> +       __unlock_page_memcg(from);
>
>         ret = 0;
>
> --
> 2.26.0
>
