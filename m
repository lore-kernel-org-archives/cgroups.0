From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: page_counter: remove unneeded atomic ops for low/min
Date: Mon, 22 Aug 2022 09:06:17 -0700
Message-ID: <CALvZod7iuuwfSq18kyNSo4DXGjfVm3FWS77DtoSeP2jrz5gpDA@mail.gmail.com>
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-2-shakeelb@google.com>
 <YwNSlZFPMgclrSCz@dhcp22.suse.cz> <YwNX+vq9svMynVgW@dhcp22.suse.cz>
 <CALvZod720nwfP68OM2QtyyWJpOV5aO8xF6iuN0U2hpX9Pzj8PA@mail.gmail.com> <YwOeocdkF/lacpKn@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Hzk+uAP2EkRL9Sia/SFiFvZ5KFrXcliMp2X+SwbXgJE=;
        b=FE+FMGBU8Io/f8ZTnMHGJbZ5+wKLBIfpgdiJ6n9Ye3xjsJwJiWRthFQZesalJXxr6v
         asH26nv62+9fFdn9DJY/PQ1wPTtD6mMrkdyqnfgjWtwbLUQNbfsJW7Z+/hWmDC3TbCia
         2FYtPJmqybTobZ3vBqr+CuVzk+yEwkmsH9R0W5mALHZIucQJPqWPJCmrJrzIS1ROB3sd
         6xEvpo7fvLpHxrjZZw/rZL5CitN6yBN20KzM1+O9ofyu/Fq8+Fm97MZib4/BNUa3yJIN
         hdYuobZLS7CYbd0581wdytZboHm0+/k0dtsJtGtlEMvmaubqnB7a7hY+Xz9Gr4zduXKf
         Y4pg==
In-Reply-To: <YwOeocdkF/lacpKn-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Soheil Hassas Yeganeh <soheil-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Oliver Sang <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, lkp-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Aug 22, 2022 at 8:20 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 22-08-22 07:55:58, Shakeel Butt wrote:
> > On Mon, Aug 22, 2022 at 3:18 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Mon 22-08-22 11:55:33, Michal Hocko wrote:
> > > > On Mon 22-08-22 00:17:35, Shakeel Butt wrote:
> > > [...]
> > > > > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > > > > index eb156ff5d603..47711aa28161 100644
> > > > > --- a/mm/page_counter.c
> > > > > +++ b/mm/page_counter.c
> > > > > @@ -17,24 +17,23 @@ static void propagate_protected_usage(struct page_counter *c,
> > > > >                                   unsigned long usage)
> > > > >  {
> > > > >     unsigned long protected, old_protected;
> > > > > -   unsigned long low, min;
> > > > >     long delta;
> > > > >
> > > > >     if (!c->parent)
> > > > >             return;
> > > > >
> > > > > -   min = READ_ONCE(c->min);
> > > > > -   if (min || atomic_long_read(&c->min_usage)) {
> > > > > -           protected = min(usage, min);
> > > > > +   protected = min(usage, READ_ONCE(c->min));
> > > > > +   old_protected = atomic_long_read(&c->min_usage);
> > > > > +   if (protected != old_protected) {
> > > >
> > > > I have to cache that code back into brain. It is really subtle thing and
> > > > it is not really obvious why this is still correct. I will think about
> > > > that some more but the changelog could help with that a lot.
> > >
> > > OK, so the this patch will be most useful when the min > 0 && min <
> > > usage because then the protection doesn't really change since the last
> > > call. In other words when the usage grows above the protection and your
> > > workload benefits from this change because that happens a lot as only a
> > > part of the workload is protected. Correct?
> >
> > Yes, that is correct. I hope the experiment setup is clear now.
>
> Maybe it is just me that it took a bit to grasp but maybe we want to
> save our future selfs from going through that mental process again. So
> please just be explicit about that in the changelog. It is really the
> part that workloads excessing the protection will benefit the most that
> would help to understand this patch.
>

I will add more detail in the commit message in the next version.

> > > Unless I have missed anything this shouldn't break the correctness but I
> > > still have to think about the proportional distribution of the
> > > protection because that adds to the complexity here.
> >
> > The patch is not changing any semantics. It is just removing an
> > unnecessary atomic xchg() for a specific scenario (min > 0 && min <
> > usage). I don't think there will be any change related to proportional
> > distribution of the protection.
>
> Yes, I suspect you are right. I just remembered previous fixes
> like 503970e42325 ("mm: memcontrol: fix memory.low proportional
> distribution") which just made me nervous that this is a tricky area.
>
> I will have another look tomorrow with a fresh brain and send an ack.

I will wait for your ack before sending the next version.
