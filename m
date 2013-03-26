From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
Date: Tue, 26 Mar 2013 15:52:32 +0800
Message-ID: <515153C0.5070908@huawei.com>
References: <514A60CD.60208@huawei.com> <20130321090849.GF6094@dhcp22.suse.cz> <20130321102257.GH6094@dhcp22.suse.cz> <514BB23E.70908@huawei.com> <20130322080749.GB31457@dhcp22.suse.cz> <514C1388.6090909@huawei.com> <514C14BF.3050009@parallels.com> <20130322093141.GE31457@dhcp22.suse.cz> <514EAC41.5050700@huawei.com> <20130325090629.GN2154@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130325090629.GN2154-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

>>> >From 7ed7f53bb597e8cb40d9ac91ce16142fb60f1e93 Mon Sep 17 00:00:00 2001
>>> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
>>> Date: Fri, 22 Mar 2013 10:22:54 +0100
>>> Subject: [PATCH] memcg: fix memcg_cache_name() to use cgroup_name()
>>>
>>> As cgroup supports rename, it's unsafe to dereference dentry->d_name
>>> without proper vfs locks. Fix this by using cgroup_name() rather than
>>> dentry directly.
>>>
>>> Also open code memcg_cache_name because it is called only from
>>> kmem_cache_dup which frees the returned name right after
>>> kmem_cache_create_memcg makes a copy of it. Such a short-lived
>>> allocation doesn't make too much sense. So replace it by a static
>>> buffer as kmem_cache_dup is called with memcg_cache_mutex.
>>>
>>
>> I doubt it's a win to add 4K to kernel text size instead of adding
>> a few extra lines of code... but it's up to you.
> 
> I will leave the decision to Glauber. The updated version which uses
> kmalloc for the static buffer is bellow.
> 

I don't have strong preference. Glauber, what's your opinion?

...
>  static struct kmem_cache *kmem_cache_dup(struct mem_cgroup *memcg,
>  					 struct kmem_cache *s)
>  {
> -	char *name;
>  	struct kmem_cache *new;
> +	static char *tmp_name = NULL;

(minor nitpick) why not preserve the name "name"
