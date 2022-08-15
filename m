From: Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup: use root_mem_cgroup as css when current is
 not enabled
Date: Mon, 15 Aug 2022 17:17:03 +0800
Message-ID: <CAGWkznEQ_njmNt8usr-DyaiYDAHJE-niC2QxoXPQkDqY7v_Mqg@mail.gmail.com>
References: <1660298966-11493-1-git-send-email-zhaoyang.huang@unisoc.com>
 <YvakpukeF9d35Bc8@slm.duckdns.org> <CAGWkznG6n=+v7hUKR8Rmg8VEF=BTDegk8bh6aHfvOU5TbmeXDw@mail.gmail.com>
 <CAGWkznHa9WTV2oK=HB1OVEdKeMZ1V2omDDiNrRdyBdyYd=q5Fg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=eiqkvF+xYiNF2DpRXQeLPgqIYFAmFLS0V8w6NeOkAps=;
        b=nLzwUzH1mFhYYOp7STOZsHfn7f2SW3Gl6xJ8vP+9vPX2YAZB2C6OlzaSKAeYnmAQv1
         1PdjeD/WpfSf7CrTfALpgrSOS4Z5IcOcuc/ZJTLrj+ypqyWlP8AusY08hpNwC6czmjy0
         zc3VJeNGhdWq/xRoIuGB7Kygb2vskfasVGLXx0rbvEwJgKMLskTKjBNlQ388bRI6Mpcf
         RvjU2kUboC2pvVZnkXL00TmNZnpEmLvxb59g9DI9T5v/teeX3DQaOM+ybyPGLI1qOL7l
         Ys5Ddw4/L4rYxBm9Vvmxcq23T86HxaW/lYWcHNVjV0cjAhfpCGgmjCbWXyayuOFE9Om/
         oqWw==
In-Reply-To: <CAGWkznHa9WTV2oK=HB1OVEdKeMZ1V2omDDiNrRdyBdyYd=q5Fg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ke Wang <ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Aug 15, 2022 at 9:38 AM Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On Sun, Aug 14, 2022 at 2:40 PM Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Sat, Aug 13, 2022 at 3:06 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Fri, Aug 12, 2022 at 06:09:26PM +0800, zhaoyang.huang wrote:
> > > > From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> > > >
> > > > Memory charged on group B abserved on belowing v2 hierarchy where we just would
> > > > like to only have group E's memory be controlled and B's descendants compete freely
> > > > for memory. This should be the consequences of unified hierarchy. Solve this by
> > > > have the cgroup without valid memory css alloced use root_mem_cgroup instead of
> > > > its ancestor's.
> > > >
> > > >  A(subtree_control = memory) - B(subtree_control = NULL) - C()
> > > >                                                          \ D()
> > > >                            - E(subtree_control = memory) - F()
> > > >                                                          \ G()
> > > >
> > > > Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> > > > ---
> > > >  kernel/cgroup/cgroup.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> > > > index 1779ccd..b29b3f6 100644
> > > > --- a/kernel/cgroup/cgroup.c
> > > > +++ b/kernel/cgroup/cgroup.c
> > > > @@ -533,6 +533,14 @@ static struct cgroup_subsys_state *cgroup_e_css_by_mask(struct cgroup *cgrp,
> > > >        * can't test the csses directly.  Test ss_mask.
> > > >        */
> > > >       while (!(cgroup_ss_mask(cgrp) & (1 << ss->id))) {
> > > > +             /*
> > > > +              * charging to the parent cgroup which hasn't distribute
> > > > +              * memory control to its descendants doesn't make sense
> > > > +              * especially on cgroup v2, where the parent could be configured
> > > > +              * to use memory controller as its sibling want to use it
> > > > +              */
> > > > +             if (memory_cgrp_id == ss->id)
> > > > +                     return &root_mem_cgroup->css;
> > >
> > > This is gonna be a hard nack. A given cgroup always encompasses all the
> > > resources consumed in its self-including subtree.
> > >
> > > Thanks.
> > IMHO, I would like to say if it makes more sense as "A given cgroup
> > always encompasses all the resources consumed in its ENABLED
> > self-including subtree." Otherwise, how should I couple with the
> > scenarios I raised in the commit message which I prefer parts of the
> > subtrees compete for "memory" while others are free for it. The free
> > here is not only without "min/low/high watermarks" but also not
> > charged to their own LRU.
> I would like to state more why these make sense. Memory cgroup is a
> little bit different to other cgroups, that is, memcg will have real
> physical resources attached, say pages. From perspective of memory
> reclaiming, it is odd to find that pages under free memcgs are charged
> to separate LRUs but without any management(no watermark control) and
> perhaps affect workingset mechanism by LRU reason. Furthermore, v2
> should grant the groups with the right to reject the subsys which
> introduced by sibling enable, which could be deemed as v2's
> inconvenient. The memcg could also apply subtree_control to enroll all
> memory back whenever it want.
As suggested by zefan, raise the practical scenario here to make more
sense. The issue is observed in android system where per-app cgroup is
demanded by freezer subsys and part of them require memory control.
Under this scenario, less efficient memory reclaim is observed when
comparing with no memory control. It is believed that multi LRU
scanning introduces some of the overhead. Furthermore, page thrashing
is also heavier than global LRU which could be the consequences of
partial failure of WORKINGSET mechanism as LRU is too short to protect
the active pages.
> > >
> > > --
> > > tejun
