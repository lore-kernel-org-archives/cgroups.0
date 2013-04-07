From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 0/7] memcg: make memcg's life cycle the same as cgroup
Date: Sun, 7 Apr 2013 16:44:07 +0800
Message-ID: <516131D7.8030004@huawei.com>
References: <515BF233.6070308@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515BF233.6070308-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hi,

I'm rebasing this patchset against latest linux-next, and it conflicts with
"[PATCH v2] memcg: debugging facility to access dangling memcgs." slightly.

That is a debugging patch and will never be pushed into mainline, so should I
still base this patchset on that debugging patch?

Also that patch needs update (and can be simplified) after this patchset:
- move memcg_dangling_add() to mem_cgroup_css_offline()
- remove memcg->memcg_name, and use cgroup_path() in mem_cgroup_dangling_read()?

On 2013/4/3 17:11, Li Zefan wrote:
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
> 
> btw, after this patchset I think we don't need to free memcg via RCU, because
> cgroup is already freed in RCU callback.
> 
> Note this patchset is based on a few memcg fixes I sent (but hasn't been
> accepted)
> 
> --
>  kernel/cgroup.c |  10 ++++++++
>  mm/memcontrol.c | 129 ++++++++++++++++++++++++++++++++++++++-------------------------------------------------------
>  2 files changed, 62 insertions(+), 77 deletions(-)
> 
