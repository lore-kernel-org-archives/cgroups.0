From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/5] mm, memcg: always call __mod_node_page_state() with
 preempt disabled
Date: Thu, 29 Jul 2021 07:39:08 -0700
Message-ID: <CALvZod6n1EwcyLTi=Eb8t=NVVPLRh9=Ng=VJ93pQyCRkOcLo9Q@mail.gmail.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com> <20210729125755.16871-6-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pQ+TosWiDAdG8+90eQclOC0l7J20f+GG4ER7QwTBKX8=;
        b=R23L4N03E0Cp8DvPNPKl1idmWh2CJdaYEmaLa1zbfrqP6vbUf+kVIxIr+waUl74KJ7
         Mphdxreoppmm+jRPzPzsh1BxrZm8LVudhznf1T4QIzuK2yPi+akMMez82h2jumMlbVBf
         S4s7yiBKeS5xYqWyj6/0VB0Gc5h/lkfbSVQ8/wSDflor4uoM7saLwFNOPaGtfgypCOj/
         +WIjAxfYsT6tTBO/q53IY7HCwDcgVv78qaKosze2J5wD59XRmrOEtTa4h7EmF5Pf5cK0
         nkmiVrgBr2zJPDiZ0MD0JZ5mxei1/97cIXhT5vYsbRVqwrZO7WrhQf5r9ywwwTopzLvU
         jR6g==
In-Reply-To: <20210729125755.16871-6-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jul 29, 2021 at 5:58 AM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> We should always ensure __mod_node_page_state() is called with preempt
> disabled or percpu ops may manipulate the wrong cpu when preempt happened.
>
> Fixes: b4e0b68fbd9d ("mm: memcontrol: use obj_cgroup APIs to charge kmem pages")
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 70a32174e7c4..616d1a72ece3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -697,8 +697,8 @@ void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
>         memcg = page_memcg(head);
>         /* Untracked pages have no memcg, no lruvec. Update only the node */
>         if (!memcg) {
> -               rcu_read_unlock();
>                 __mod_node_page_state(pgdat, idx, val);
> +               rcu_read_unlock();

This rcu is for page_memcg. The preemption and interrupts are disabled
across __mod_lruvec_page_state().

>                 return;
>         }
>
> --
> 2.23.0
>
