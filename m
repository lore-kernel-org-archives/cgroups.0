From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Tue, 5 Sep 2017 20:16:09 +0100
Message-ID: <20170905191609.GA19687@castle.dhcp.TheFacebook.com>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-6-guro@fb.com>
 <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
 <20170905143021.GA28599@castle.dhcp.TheFacebook.com>
 <20170905151251.luh4wogjd3msfqgf@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=OVM08nfJCpqjEvuSqzyeqsVzrT45OugSlm+8FNUo/HY=;
 b=pMU+jFdnIGeulW/QKK62uhEgT6CLAoZnvN/syW9q1EKhKWXNN8NQDIjtOOocL+qDkBVA
 BKEnKX6GbPXKreHQ2797MU/p+8Yi0h2gjcTcIaxlY2mHGcTkRq1Uo0T9zKCzZiMRD+QU
 AfoiqxPhaD5+VSdvWtzMGMw3YmiDpDtRrwY= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OVM08nfJCpqjEvuSqzyeqsVzrT45OugSlm+8FNUo/HY=;
 b=ZHVEmqO96/jguBdCGDlI+ysoU8bgvz+ffeXYKDGKwSbW57CYeTa6Bmi3v+htbQsbj8cHcjINwuzpaCnVDn3mN+MfBMz83w7dF13w2JrPXorC4vg3ImE9uk/RcqzMQb9p2nV4Jq7247vXtYzUnIKng7gBU3CFwamsv/X7wqdd378=
Content-Disposition: inline
In-Reply-To: <20170905151251.luh4wogjd3msfqgf-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 05, 2017 at 05:12:51PM +0200, Michal Hocko wrote:
> On Tue 05-09-17 15:30:21, Roman Gushchin wrote:
> > On Tue, Sep 05, 2017 at 03:44:12PM +0200, Michal Hocko wrote:
> [...]
> > > Why is this an opt out rather than opt-in? IMHO the original oom logic
> > > should be preserved by default and specific workloads should opt in for
> > > the cgroup aware logic. Changing the global behavior depending on
> > > whether cgroup v2 interface is in use is more than unexpected and IMHO
> > > wrong approach to take. I think we should instead go with 
> > > oom_strategy=[alloc_task,biggest_task,cgroup]
> > > 
> > > we currently have alloc_task (via sysctl_oom_kill_allocating_task) and
> > > biggest_task which is the default. You are adding cgroup and the more I
> > > think about the more I agree that it doesn't really make sense to try to
> > > fit thew new semantic into the existing one (compare tasks to kill-all
> > > memcgs). Just introduce a new strategy and define a new semantic from
> > > scratch. Memcg priority and kill-all are a natural extension of this new
> > > strategy. This will make the life easier and easier to understand by
> > > users.
> > > 
> > > Does that make sense to you?
> > 
> > Absolutely.
> > 
> > The only thing: I'm not sure that we have to preserve the existing logic
> > as default option. For most users (except few very specific usecases),
> > it should be at least as good, as the existing one.
> 
> But this is really an unexpected change. Users even might not know that
> they are using cgroup v2 and memcg is in use.
> 
> > Making it opt-in means that corresponding code will be executed only
> > by few users, who cares.
> 
> Yeah, which is the way we should introduce new features no?
> 
> > Then we should probably hide corresponding
> > cgroup interface (oom_group and oom_priority knobs) by default,
> > and it feels as unnecessary complication and is overall against
> > cgroup v2 interface design.
> 
> Why. If we care enough, we could simply return EINVAL when those knobs
> are written while the corresponding strategy is not used.

It doesn't look as a nice default interface.

> 
> > > I think we should instead go with
> > > oom_strategy=[alloc_task,biggest_task,cgroup]
> > 
> > It would be a really nice interface; although I've no idea how to implement it:
> > "alloc_task" is an existing sysctl, which we have to preserve;
> 
> I would argue that we should simply deprecate and later drop the sysctl.
> I _strongly_ suspect anybody is using this. If yes it is not that hard
> to change the kernel command like rather than select the sysctl.

I agree. And if so, why do we need a new interface for an useless feature?

> 
> > while "cgroup" depends on cgroup v2.
> 
> Which is not a big deal either. Simply fall back to default if there are
> no cgroup v2. The implementation would have essentially the same effect
> because there won't be any kill-all cgroups and so we will select the
> largest task.

I'd agree with you, if there are use cases (excluding pure legacy),
when the per-process algorithm is preferable over the cgroup-aware OOM.
I really doubt, and hope, that with oom_priorities the suggested algorithm
should cover almost all reasonable use cases.

Thanks!
