From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Wed, 6 Sep 2017 10:42:42 +0200
Message-ID: <20170906084242.l4rcx6n3hdzxvil6@dhcp22.suse.cz>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-6-guro@fb.com>
 <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
 <20170905143021.GA28599@castle.dhcp.TheFacebook.com>
 <20170905151251.luh4wogjd3msfqgf@dhcp22.suse.cz>
 <20170905191609.GA19687@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170905191609.GA19687-2xczL/1GIl5a1dPMsufgnw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 05-09-17 20:16:09, Roman Gushchin wrote:
> On Tue, Sep 05, 2017 at 05:12:51PM +0200, Michal Hocko wrote:
[...]
> > > Then we should probably hide corresponding
> > > cgroup interface (oom_group and oom_priority knobs) by default,
> > > and it feels as unnecessary complication and is overall against
> > > cgroup v2 interface design.
> > 
> > Why. If we care enough, we could simply return EINVAL when those knobs
> > are written while the corresponding strategy is not used.
> 
> It doesn't look as a nice default interface.

I do not have a strong opinion on this. A printk_once could explain why
the knob is ignored and instruct the admin how to enable the feature
completely.
 
> > > > I think we should instead go with
> > > > oom_strategy=[alloc_task,biggest_task,cgroup]
> > > 
> > > It would be a really nice interface; although I've no idea how to implement it:
> > > "alloc_task" is an existing sysctl, which we have to preserve;
> > 
> > I would argue that we should simply deprecate and later drop the sysctl.
> > I _strongly_ suspect anybody is using this. If yes it is not that hard
> > to change the kernel command like rather than select the sysctl.
> 
> I agree. And if so, why do we need a new interface for an useless feature?

Well, I won't be opposed just deprecating the sysfs and only add a
"real" kill-allocate strategy if somebody explicitly asks for it.
-- 
Michal Hocko
SUSE Labs
