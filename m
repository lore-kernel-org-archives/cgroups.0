From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v3 6/6] memcg: avoid dangling reference count in creation
 failure.
Date: Mon, 21 Jan 2013 13:30:57 +0100
Message-ID: <20130121123057.GH7798@dhcp22.suse.cz>
References: <1358766813-15095-1-git-send-email-glommer@parallels.com>
 <1358766813-15095-7-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1358766813-15095-7-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org

On Mon 21-01-13 15:13:33, Glauber Costa wrote:
> When use_hierarchy is enabled, we acquire an extra reference count
> in our parent during cgroup creation. We don't release it, though,
> if any failure exist in the creation process.
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> Reported-by: Michal Hocko <mhocko@suse>

If you put this one to the head of the series we can backport it to
stable which is preferred, although nobody have seen this as a problem.

> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5a247de..3949123 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6167,6 +6167,8 @@ mem_cgroup_css_online(struct cgroup *cont)
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
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
