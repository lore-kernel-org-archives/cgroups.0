From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH memcg RFC] net: set proper memcg for net_init hooks allocations
Date: Fri, 22 Apr 2022 13:22:32 -0700
Message-ID: <CALvZod7ys1SNrQhbweCoCKVyfN1itE16jhC97TqjWtHDFh1RpQ@mail.gmail.com>
References: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev>
 <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org> <CALvZod47PARcupR4P41p5XJRfCaTqSuy-cfXs7Ky9=-aJQuoFA@mail.gmail.com>
 <964ae72a-0484-67de-8143-a9a2d492a520@openvz.org> <e9cd84f2-d2e9-33a8-d74e-edcf60d35236@openvz.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2FeuhW6y4os5v9CoDi1x5cL69WTrNP7orQRjD5u2f2Q=;
        b=SWA5JCifyGGgXC8kg9oqcVEfzGpcJyubvgXISY/tkiQ4LkAnBvdJQ4x+SDJdCcN5r5
         l/D5Xwmleml/wGOTyuQey0sip6/0Tgoq+rQ7CHZro/fqIgNVa0LsvarIkgGhhvY5j1sF
         LMm1oOI3X0eDdolQ9LpFcFBcvkgDAo4IEFQp7an7GZ4F5A6E9vw8lZlu+PJZ8/F/XeaE
         2XrN/+haQevXPxaL9uHcm3fCWmwsIiDq4XpsMffkJ/1dAHzee/+nBWc5FxrRuv2Yv75v
         ot9Gi+ioqe4rUavjZ2Ml02hMsz+UFQFITKvVGI/dulXXz+ZeW0uqaldMetwuQxNGpPe6
         t/zg==
In-Reply-To: <e9cd84f2-d2e9-33a8-d74e-edcf60d35236@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@openvz.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>

On Fri, Apr 22, 2022 at 1:09 PM Vasily Averin <vvs@openvz.org> wrote:
>
> On 4/22/22 23:01, Vasily Averin wrote:
> > On 4/21/22 18:56, Shakeel Butt wrote:
> >> On Sat, Apr 16, 2022 at 11:39 PM Vasily Averin <vvs@openvz.org> wrote:
> >>> @@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
> >>>                  * setup_net() and cleanup_net() are not possible.
> >>>                  */
> >>>                 for_each_net(net) {
> >>> +                       struct mem_cgroup *old, *memcg = NULL;
> >>> +#ifdef CONFIG_MEMCG
> >>> +                       memcg = (net == &init_net) ? root_mem_cgroup : mem_cgroup_from_obj(net);
> >>
> >> memcg from obj is unstable, so you need a reference on memcg. You can
> >> introduce get_mem_cgroup_from_kmem() which works for both
> >> MEMCG_DATA_OBJCGS and MEMCG_DATA_KMEM. For uncharged objects (like
> >> init_net) it should return NULL.
> >
> > Could you please elaborate with more details?
> > It seems to me mem_cgroup_from_obj() does everything exactly as you say:
> > - for slab objects it returns memcg taken from according slab->memcg_data
> > - for ex-slab objects (i.e. page->memcg_data & MEMCG_DATA_OBJCGS)
> >     page_memcg_check() returns NULL
> > - for kmem objects (i.e. page->memcg_data & MEMCG_DATA_KMEM)
> >     page_memcg_check() returns objcg->memcg
> > - in another cases
> >     page_memcg_check() returns page->memcg_data,
> >     so for uncharged objects like init_net NULL should be returned.
> >
> > I can introduce exported get_mem_cgroup_from_kmem(), however it should only
> > call mem_cgroup_from_obj(), perhaps under read_rcu_lock/unlock.
>
> I think I finally got your point:
> Do you mean I should use css_tryget(&memcg->css) for found memcg,
> like get_mem_cgroup_from_mm() does?

Yes.
