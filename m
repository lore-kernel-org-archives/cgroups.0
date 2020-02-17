From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Mon, 17 Feb 2020 09:41:00 +0100
Message-ID: <20200217084100.GE31531@dhcp22.suse.cz>
References: <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213135348.GF88887@mtj.thefacebook.com>
 <20200213154731.GE31689@dhcp22.suse.cz>
 <20200213155249.GI88887@mtj.thefacebook.com>
 <20200213163636.GH31689@dhcp22.suse.cz>
 <20200213165711.GJ88887@mtj.thefacebook.com>
 <20200214071537.GL31689@dhcp22.suse.cz>
 <20200214135728.GK88887@mtj.thefacebook.com>
 <20200214151318.GC31689@dhcp22.suse.cz>
 <20200214165311.GA253674@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200214165311.GA253674-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri 14-02-20 11:53:11, Johannes Weiner wrote:
[...]
> The proper solution to implement the kind of resource hierarchy you
> want to express in cgroup2 is to reflect it in the cgroup tree. Yes,
> the_workload might have been started by user 100 in session c2, but in
> terms of resources, it's prioritized over system.slice and user.slice,
> and so that's the level where it needs to sit:
> 
>                                root
>                        /        |                 \
>                system.slice  user.slice       the_workload
>                /    |           |
>            cron  journal     user-100.slice
>                                 |
>                              session-c2.scope
>                                 |
>                              misc
> 
> Then you can configure not just memory.low, but also a proper io
> weight and a cpu weight. And the tree correctly reflects where the
> workload is in the pecking order of who gets access to resources.

I have already mentioned that this would be the only solution when the
protection would work, right. But I am also saying that this a trivial
example where you simply _can_ move your workload to the 1st level. What
about those that need to reflect organization into the hierarchy. Please
have a look at http://lkml.kernel.org/r/20200214075916.GM31689-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org
Are you saying they are just not supported? Are they supposed to use
cgroup v1 for the organization and v2 for the resource control?
-- 
Michal Hocko
SUSE Labs
