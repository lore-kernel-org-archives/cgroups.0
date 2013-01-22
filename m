From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 6/6] memcg: avoid dangling reference count in creation
 failure.
Date: Tue, 22 Jan 2013 15:00:58 +0100
Message-ID: <20130122140058.GF28525@dhcp22.suse.cz>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com>
 <1358862461-18046-7-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1358862461-18046-7-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On Tue 22-01-13 17:47:41, Glauber Costa wrote:
> When use_hierarchy is enabled, we acquire an extra reference count
> in our parent during cgroup creation. We don't release it, though,
> if any failure exist in the creation process.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Reported-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 357324c..72a008e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6166,6 +6166,8 @@ mem_cgroup_css_online(struct cgroup *cont)
>  		 * call __mem_cgroup_free, so return directly
>  		 */
>  		mem_cgroup_put(memcg);
> +		if (parent->use_hierarchy)
> +			mem_cgroup_put(parent);
>  	}
>  	return error;
>  }
> -- 
> 1.8.1
> 

-- 
Michal Hocko
SUSE Labs
