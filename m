From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Thu, 5 Oct 2017 11:27:07 +0100
Message-ID: <20171005102707.GA12982@castle.dhcp.TheFacebook.com>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
 <CALvZod6bwyoSWTv139y0wMidpZm5HcDu8RzVjF8U7GHxAzxSQw@mail.gmail.com>
 <20171004201524.GA4174@castle>
 <CALvZod45ObeQwq-pKeqyLe2bNwfKAr0majCbNfqPOEJL+AeiNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=zesj9feZXq4myDzbj9dlKOjk5FYPCNKNAKwDCk5Ur5k=;
 b=HZ51lytsWfyNb18GClrp2FqcT4iorGc5nBxf9PNP7ZGtnbpCVmbyVBBAMLT2sDZsrW1P
 pBHHKqdrqu/Q83Zyall1YjHSPcZwluGkhbZ8xS9YbNduI0EZr0BzbecnQaSwVdD4Ywcz
 5bXkMOVIxg8nhW1a/fq0Ex2W6doXOjYUHWo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zesj9feZXq4myDzbj9dlKOjk5FYPCNKNAKwDCk5Ur5k=;
 b=ZnYQ1QpxEcdietMs0Wk17IV3egZ4E2bO2jTxfQ5pZr9G1eCeAcOc/bmr5imq/DNc+b1WDspmtpMtf0S4vL3ApeVnKkeVTeAEDOPfteEAtnLTk6mcr54uGFQHk9bY0LhnPSEI42oxjVJIt5uiOglrh/GjSkyZ2OquvRhpwIOVWoI=
Content-Disposition: inline
In-Reply-To: <CALvZod45ObeQwq-pKeqyLe2bNwfKAr0majCbNfqPOEJL+AeiNw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Oct 04, 2017 at 02:24:26PM -0700, Shakeel Butt wrote:
> >> > +               if (memcg_has_children(iter))
> >> > +                       continue;
> >>
> >> && iter != root_mem_cgroup ?
> >
> > Oh, sure. I had a stupid bug in my test script, which prevented me from
> > catching this. Thanks!
> >
> > This should fix the problem.
> > --
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 2e82625bd354..b3848bce4c86 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2807,7 +2807,8 @@ static void select_victim_memcg(struct mem_cgroup *root, struct oom_control *oc)
> >                  * We don't consider non-leaf non-oom_group memory cgroups
> >                  * as OOM victims.
> >                  */
> > -               if (memcg_has_children(iter) && !mem_cgroup_oom_group(iter))
> > +               if (memcg_has_children(iter) && iter != root_mem_cgroup &&
> > +                   !mem_cgroup_oom_group(iter))
> >                         continue;
> 
> I think you are mixing the 3rd and 4th patch. The root_mem_cgroup
> check should be in 3rd while oom_group stuff should be in 4th.
>

Right. This "patch" should fix them both, it was just confusing to
send two patches. I'll split it before final landing.

> 
> >>
> >> Shouldn't there be a CSS_ONLINE check? Also instead of css_get at the
> >> end why not css_tryget_online() here and css_put for the previous
> >> selected one.
> >
> > Hm, why do we need to check this? I do not see, how we can choose
> > an OFFLINE memcg as a victim, tbh. Please, explain the problem.
> >
> 
> Sorry about the confusion. There are two things. First, should we do a
> css_get on the newly selected memcg within the for loop when we still
> have a reference to it?

We're holding rcu_read_lock, it should be enough. We're bumping css counter
just before releasing rcu lock.

> 
> Second, for the OFFLINE memcg, you are right oom_evaluate_memcg() will
> return 0 for offlined memcgs. Maybe no need to call
> oom_evaluate_memcg() for offlined memcgs.

Sounds like a good optimization, which can be done on top of the current
patchset.

Thank you!
