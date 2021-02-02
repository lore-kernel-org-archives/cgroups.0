From: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: remove redundant NULL check
Date: Tue, 2 Feb 2021 11:12:05 +0100
Message-ID: <187faa43-dc1c-d0a9-769c-b8d99b954c32@redhat.com>
References: <1611216029-34397-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612260733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OsWwN1vmOUR/or+/6FTZ3nC/QP7/0ejkOvTfj5/Q2X8=;
        b=bWg6uFp2BsSH3lgy/WA7A0Ys4rIQlNf9p4yD4cCHqzMMG6Btg48J3VwhWvVfBvrc4RKrBP
        geLx3tXiUkBYbYxAzLc5c9DfvHVqMVTrC6xw3joYsfUAcTpV2z4vSr4mD906+tkcP1HC/d
        9L70KLtHz1MQHpRYjSTiCBaYxstsYE4=
In-Reply-To: <1611216029-34397-1-git-send-email-abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yang Li <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 21.01.21 09:00, Yang Li wrote:
> Fix below warnings reported by coccicheck:
> ./mm/memcontrol.c:451:3-9: WARNING: NULL check before some freeing
> functions is not needed.
> 
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Yang Li <abaci-bugfix-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>   mm/memcontrol.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 605f671..f6a561b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -447,8 +447,7 @@ static void memcg_free_shrinker_maps(struct mem_cgroup *memcg)
>   	for_each_node(nid) {
>   		pn = mem_cgroup_nodeinfo(memcg, nid);
>   		map = rcu_dereference_protected(pn->shrinker_map, true);
> -		if (map)
> -			kvfree(map);
> +		kvfree(map);
>   		rcu_assign_pointer(pn->shrinker_map, NULL);
>   	}
>   }
> 

Reviewed-by: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
Thanks,

David / dhildenb

