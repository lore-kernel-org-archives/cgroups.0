From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] memcg: don't do cleanup manually if
 mem_cgroup_css_online() fails
Date: Tue, 2 Apr 2013 14:16:00 +0200
Message-ID: <20130402121600.GK24345@dhcp22.suse.cz>
References: <515A8A40.6020406@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <515A8A40.6020406-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 02-04-13 15:35:28, Li Zefan wrote:
[...]
> @@ -6247,16 +6247,7 @@ mem_cgroup_css_online(struct cgroup *cont)
>  
>  	error = memcg_init_kmem(memcg, &mem_cgroup_subsys);
>  	mutex_unlock(&memcg_create_mutex);
> -	if (error) {
> -		/*
> -		 * We call put now because our (and parent's) refcnts
> -		 * are already in place. mem_cgroup_put() will internally
> -		 * call __mem_cgroup_free, so return directly
> -		 */
> -		mem_cgroup_put(memcg);
> -		if (parent->use_hierarchy)
> -			mem_cgroup_put(parent);
> -	}
> +
>  	return error;
>  }

The mem_cgroup_put(parent) part is incorrect because mem_cgroup_put goes
up the hierarchy already but I do not think mem_cgroup_put(memcg) should
go away as well. Who is going to free the last reference then?

Maybe I am missing something but we have:
cgroup_create
  css = ss->css_alloc(cgrp)
    mem_cgroup_css_alloc
      atomic_set(&memcg->refcnt, 1)
  online_css(ss, cgrp)
    mem_cgroup_css_online
      error = memcg_init_kmem		# fails
  goto err_destroy
err_destroy:
  cgroup_destroy_locked(cgrp)
    offline_css
      mem_cgroup_css_offline

no mem_cgroup_put on the way.

-- 
Michal Hocko
SUSE Labs
