From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: fold mem_cgroup_stolen
Date: Wed, 7 May 2014 11:17:55 +0200
Message-ID: <20140507091755.GA9489@dhcp22.suse.cz>
References: <5369EE5E.50202@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5369EE5E.50202-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rt-users <linux-rt-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed 07-05-14 16:27:10, Qiang Huang wrote:
> It is only used in __mem_cgroup_begin_update_page_stat(), the
> name is confusing and 2 routines for one thing also confuse people,
> so fold this function seems more clear.

Yes, the name was everything but self-explanatory.
 
The patch looks good to me. One nit below.

> Signed-off-by: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 25 +++++++------------------
>  1 file changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4f97662..5804d71 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1568,23 +1568,12 @@ static void mem_cgroup_end_move(struct mem_cgroup *memcg)
>  }
> 
>  /*
> - * 2 routines for checking "mem" is under move_account() or not.
> + * A routine for checking "mem" is under move_account() or not.
>   *
> - * mem_cgroup_stolen() -  checking whether a cgroup is mc.from or not. This
> - *			  is used for avoiding races in accounting.  If true,
> - *			  pc->mem_cgroup may be overwritten.
> - *
> - * mem_cgroup_under_move() - checking a cgroup is mc.from or mc.to or
> - *			  under hierarchy of moving cgroups. This is for
> - *			  waiting at hith-memory prressure caused by "move".
> + * Checking a cgroup is mc.from or mc.to or under hierarchy of
> + * moving cgroups.

> This is for waiting at hith-memory pressure

s/hith/high/

but I guess that part can go away

[...]
-- 
Michal Hocko
SUSE Labs
