From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 5/9] memcg: use css_get/put when charging/uncharging
 kmem
Date: Thu, 13 Jun 2013 17:53:19 +0200
Message-ID: <20130613155319.GJ23070@dhcp22.suse.cz>
References: <51B98D17.2050902@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51B98D17.2050902-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Thu 13-06-13 17:12:55, Li Zefan wrote:
> Sorry for updating the patchset so late.
> 
> I've made some changes for the memory barrier thing, and I agree with
> Michal that there can be improvement but can be a separate patch.
> 
> If this version is ok for everyone, I'll send the whole patchset out
> to Andrew.
> 
> =========================
> 
> Use css_get/put instead of mem_cgroup_get/put.
> 
> We can't do a simple replacement, because here mem_cgroup_put()
> is called during mem_cgroup_css_free(), while mem_cgroup_css_free()
> won't be called until css refcnt goes down to 0.
> 
> Instead we increment css refcnt in mem_cgroup_css_offline(), and
> then check if there's still kmem charges. If not, css refcnt will
> be decremented immediately, 

> otherwise the refcnt won't be decremented when kmem charges goes down
> to 0.

This is a bit confusing. What about "otherwise the css refcount will be
released after the last kmem allocation is uncharged."

> 
> v3:
> - changed wmb() to smp_smb(), and moved it to memcg_kmem_mark_dead(),
>   and added comment.
> 
> v2:
> - added wmb() in kmem_cgroup_css_offline(), pointed out by Michal
> - revised comments as suggested by Michal
> - fixed to check if kmem is activated in kmem_cgroup_css_offline()
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> ---
>  mm/memcontrol.c | 70 ++++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 45 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 466c595..76dcd0e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -416,6 +416,11 @@ static void memcg_kmem_clear_activated(struct mem_cgroup *memcg)
>  
>  static void memcg_kmem_mark_dead(struct mem_cgroup *memcg)
>  {
> +	/*
> +	 * We need to call css_get() first, because memcg_uncharge_kmem()
> +	 * will call css_put() if it sees the memcg is dead.
> +	 */
> +	smb_wmb();
>  	if (test_bit(KMEM_ACCOUNTED_ACTIVE, &memcg->kmem_account_flags))
>  		set_bit(KMEM_ACCOUNTED_DEAD, &memcg->kmem_account_flags);

I do not feel strongly about that but maybe open coding this in
mem_cgroup_css_offline would be even better. There is only single caller
and there is smaller chance somebody will use the function incorrectly
later on.

So I leave the decision on you because this doesn't matter much.

[...]
-- 
Michal Hocko
SUSE Labs
