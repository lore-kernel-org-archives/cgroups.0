From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC][PATCH 0/7] memcg: make memcg's life cycle the same as
 cgroup
Date: Thu, 4 Apr 2013 14:00:49 +0200
Message-ID: <20130404120049.GI29911@dhcp22.suse.cz>
References: <515BF233.6070308@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515BF233.6070308-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed 03-04-13 17:11:15, Li Zefan wrote:
> (I'll be off from my office soon, and I won't be responsive in the following
> 3 days.)
> 
> I'm working on converting memcg to use cgroup->id, and then we can kill css_id.
> 
> Now memcg has its own refcnt, so when a cgroup is destroyed, the memcg can
> still be alive. This patchset converts memcg to always use css_get/put, so
> memcg will have the same life cycle as its corresponding cgroup, and then
> it's always safe for memcg to use cgroup->id.
> 
> The historical reason that memcg didn't use css_get in some cases, is that
> cgroup couldn't be removed if there're still css refs. The situation has
> changed so that rmdir a cgroup will succeed regardless css refs, but won't
> be freed until css refs goes down to 0.
> 
> This is an early post, and it's NOT TESTED. I just want to see if the changes
> are fine in general.

yes, I like the approach and it looks correct as well (some minor things
mentioned in the patches). Thanks a lot Li! This will make our lifes much
easier. The separate ref counting was PITA especially after
introduction of kmem accounting which made its usage even more trickier.

> btw, after this patchset I think we don't need to free memcg via RCU, because
> cgroup is already freed in RCU callback.

But this depends on changes waiting in for-3.10 branch, right?
Anyway, I think we should be safe with the workqueue based releasing as
well once mem_cgroup_{get,put} are gone, right?

> Note this patchset is based on a few memcg fixes I sent (but hasn't been
> accepted)
> 
> --
>  kernel/cgroup.c |  10 ++++++++
>  mm/memcontrol.c | 129 ++++++++++++++++++++++++++++++++++++++-------------------------------------------------------
>  2 files changed, 62 insertions(+), 77 deletions(-)

-- 
Michal Hocko
SUSE Labs
