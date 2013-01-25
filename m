From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 0/6] replace cgroup_lock with memcg specific locking
Date: Fri, 25 Jan 2013 11:18:54 +0100
Message-ID: <20130125101854.GC8876@dhcp22.suse.cz>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com>
 <510258D0.6060407@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <510258D0.6060407-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lord Glauber Costa of Sealand <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On Fri 25-01-13 14:05:04, Glauber Costa wrote:
[...]
> > Glauber Costa (6):
> >   memcg: prevent changes to move_charge_at_immigrate during task attach
> >   memcg: split part of memcg creation to css_online
> >   memcg: fast hierarchy-aware child test.
> >   memcg: replace cgroup_lock with memcg specific memcg_lock
> >   memcg: increment static branch right after limit set.
> >   memcg: avoid dangling reference count in creation failure.
> > 
> 
> Tejun,
> 
> This applies ontop of your cpuset patches. Would you pick this (would be
> my choice), or would you rather have it routed through somewhere mmish ?

I would vote to -mm. Or is there any specific reason to have it in
cgroup tree? It doesn't touch any cgroup core parts, does it?

-- 
Michal Hocko
SUSE Labs
