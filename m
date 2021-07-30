From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH 5/5] mm, memcg: always call
 __mod_node_page_state() with preempt disabled
Date: Fri, 30 Jul 2021 10:33:59 +0800
Message-ID: <CAMZfGtUMBZeo-P48MECO=xM9-apeLMAZZGE3VNsg_u5P523BEg@mail.gmail.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com> <20210729125755.16871-6-linmiaohe@huawei.com>
 <CALvZod6n1EwcyLTi=Eb8t=NVVPLRh9=Ng=VJ93pQyCRkOcLo9Q@mail.gmail.com> <29c4bb2a-ceaf-6c8b-c222-38b30460780f@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OrnW4TDngOfmT4k1Ifughwagt8BmS1Mfblfsw7s1vyw=;
        b=sCBp+WebYpI5Z9F5/Q3Yqxn7z/iABDei+1bGAY6Eb+qvxZnqBq3AoNCMtY7SjlRdCw
         V0gox9Fyqip/WZUwEbnACYCEwQP9fPDxfzFbSVadNYyenjP4DvwlYI6sfO+0wo9PQO++
         DeEOjlwQGzxR7u2teqGXnaffsL1lNMExo9NQlJR00TUC0qx/6sYJopIwQuuBZa+k8aEq
         f6zX0jjLeZGNF0zhY86tGIVqrkY+g6RKKUOvyPh7eP2Cx+MRJIYvdv8pAkt4cG1OLDE+
         nfBed/rDolcbxTZZsQ1QjFY5GQAtGOCGH6OhFu7v/3eWULQji7xUH18UC5PQig+rY30B
         mG4g==
In-Reply-To: <29c4bb2a-ceaf-6c8b-c222-38b30460780f-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alex Shi <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jul 30, 2021 at 9:52 AM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> On 2021/7/29 22:39, Shakeel Butt wrote:
> > On Thu, Jul 29, 2021 at 5:58 AM Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> >>
> >> We should always ensure __mod_node_page_state() is called with preempt
> >> disabled or percpu ops may manipulate the wrong cpu when preempt happened.
> >>
> >> Fixes: b4e0b68fbd9d ("mm: memcontrol: use obj_cgroup APIs to charge kmem pages")
> >> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >> ---
> >>  mm/memcontrol.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 70a32174e7c4..616d1a72ece3 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> >> @@ -697,8 +697,8 @@ void __mod_lruvec_page_state(struct page *page, enum node_stat_item idx,
> >>         memcg = page_memcg(head);
> >>         /* Untracked pages have no memcg, no lruvec. Update only the node */
> >>         if (!memcg) {
> >> -               rcu_read_unlock();
> >>                 __mod_node_page_state(pgdat, idx, val);
> >> +               rcu_read_unlock();
> >
> > This rcu is for page_memcg. The preemption and interrupts are disabled
> > across __mod_lruvec_page_state().
> >
>
> I thought it's used to protect __mod_node_page_state(). Looks somewhat confusing for me.
> Many thanks for pointing this out!

Hi Miaohe,

git show b4e0b68fbd9d can help you find out why we add
the rcu read lock around it.

Thanks.

>
> >>                 return;
> >>         }
> >>
> >> --
> >> 2.23.0
> >>
> > .
> >
>
