From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: use root_mem_cgroup as css when current is
 not enabled
Date: Sun, 14 Aug 2022 14:40:27 +0800
Message-ID: <CAGWkznG6n=+v7hUKR8Rmg8VEF=BTDegk8bh6aHfvOU5TbmeXDw@mail.gmail.com>
References: <1660298966-11493-1-git-send-email-zhaoyang.huang@unisoc.com> <YvakpukeF9d35Bc8@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=CyJTphL+dowqwNK5AT5s9+PYVQShCGuXR38KvvcrDos=;
        b=hZuibKQ9GQ9lGafTbNrZ/rqY5/f4iR4IcFkTOOnLVcHcUj20yfLbNJHsYggQvhj7lN
         AN8BEd6N+U5YgKf6cFdJ97dpd24jyuDjA5kE3StIoK31ylf8x2kd9H6I9qC0gGk/3D9G
         M20ziGdUbisOzqTRF6AQZ7p+eBB3URegkCa7JH9/dJhIZgWfW9kcdYE21Hd3jxJ8iecH
         VIYzpBpecpV8cxDGrOjhuBcMS35KOhfAsuWqVoeUvdJMGKDNihimNHyjHAcEbgy0apXM
         Xx+nPGAZaepLiZPx23NIZa+eIvjQ/zst9wK+hYTMwqNAFZxAmkH6WjLKU3oDB+aTpgKE
         xU0A==
In-Reply-To: <YvakpukeF9d35Bc8-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On Sat, Aug 13, 2022 at 3:06 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Fri, Aug 12, 2022 at 06:09:26PM +0800, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> >
> > Memory charged on group B abserved on belowing v2 hierarchy where we just would
> > like to only have group E's memory be controlled and B's descendants compete freely
> > for memory. This should be the consequences of unified hierarchy. Solve this by
> > have the cgroup without valid memory css alloced use root_mem_cgroup instead of
> > its ancestor's.
> >
> >  A(subtree_control = memory) - B(subtree_control = NULL) - C()
> >                                                          \ D()
> >                            - E(subtree_control = memory) - F()
> >                                                          \ G()
> >
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> > ---
> >  kernel/cgroup/cgroup.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > index 1779ccd..b29b3f6 100644
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -533,6 +533,14 @@ static struct cgroup_subsys_state *cgroup_e_css_by_mask(struct cgroup *cgrp,
> >        * can't test the csses directly.  Test ss_mask.
> >        */
> >       while (!(cgroup_ss_mask(cgrp) & (1 << ss->id))) {
> > +             /*
> > +              * charging to the parent cgroup which hasn't distribute
> > +              * memory control to its descendants doesn't make sense
> > +              * especially on cgroup v2, where the parent could be configured
> > +              * to use memory controller as its sibling want to use it
> > +              */
> > +             if (memory_cgrp_id == ss->id)
> > +                     return &root_mem_cgroup->css;
>
> This is gonna be a hard nack. A given cgroup always encompasses all the
> resources consumed in its self-including subtree.
>
> Thanks.
IMHO, I would like to say if it makes more sense as "A given cgroup
always encompasses all the resources consumed in its ENABLED
self-including subtree." Otherwise, how should I couple with the
scenarios I raised in the commit message which I prefer parts of the
subtrees compete for "memory" while others are free for it. The free
here is not only without "min/low/high watermarks" but also not
charged to their own LRU.
>
> --
> tejun
