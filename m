From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: add group_oom_kill memory.event fix
Date: Tue, 14 Dec 2021 10:38:47 +0100
Message-ID: <YbhmJ63KXGLDpQo7@dhcp22.suse.cz>
References: <20211213162511.2492267-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639474729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DZOd/YlnoT6tjCOMidF4fHVU5QDgu/mXU178ktIvi5s=;
        b=kuEtYIU7reYiVep3MAXrOtg9r/HPOo3becXk8V6gOocQyNceBmW9ZvQ7CnlAkD7kC4cmOK
        GJTjoFlDbqJGuc3/oBRu3gf1HFGFEpzUgDQMDv858fev78o1v1fGcun5kHpqo+4T2K2fs0
        xeRmqbHfcE8mmD7Xx4OCuWMl+JXehhA=
Content-Disposition: inline
In-Reply-To: <20211213162511.2492267-1-schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Mon 13-12-21 08:25:10, Dan Schatzberg wrote:
> Andrew, could you please amend the prior patch "mm: add group_oom_kill
> memory.event" with these changes from Johannes and Chris?
> 
> Also - small nit: it makes better sense to
> s/group_oom_kill/oom_group_kill/g in the patch title.

Agreed. This is more in line with the oom.group knob we export.
> 
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

With these changes feel free to add
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 3 +--
>  mm/memcontrol.c                         | 3 ---
>  2 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index eec830ce2068..8269bfa240f4 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1269,8 +1269,7 @@ PAGE_SIZE multiple when read back.
>  		killed by any kind of OOM killer.
>  
>            oom_group_kill
> -                The number of times all tasks in the cgroup were killed
> -                due to memory.oom.group.
> +                The number of times a group OOM has occurred.
>  
>    memory.events.local
>  	Similar to memory.events but the fields in the file are local
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5ab3b9ce90de..b5454d8fc344 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4390,9 +4390,6 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
>  	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
>  	seq_printf(sf, "oom_kill %lu\n",
>  		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
> -	seq_printf(sf, "oom_group_kill %lu\n",
> -		   atomic_long_read(
> -			&memcg->memory_events[MEMCG_OOM_GROUP_KILL]));
>  	return 0;
>  }
>  
> -- 
> 2.30.2

-- 
Michal Hocko
SUSE Labs
