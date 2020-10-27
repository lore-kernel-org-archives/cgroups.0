From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 5/5] mm: memcontrol: Simplify the mem_cgroup_page_lruvec
Date: Tue, 27 Oct 2020 14:36:39 +0100
Message-ID: <20201027133639.GT20500@dhcp22.suse.cz>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-6-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1603805811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vVfsint97M+naTXXxHG4OXnQeWqqb/vQC4U46ftK8Ro=;
        b=ZOf89cP7tkb4NTIdZZR2NsUHBbPHti3VCEVDz7sHKYwFFlg+572/0TcwmJQL2wSN9l1bqg
        ry53bKL9p748UXGDWGHYu695j2Q393Aj863UtWvB99OIxR8DCXMcXG+WFsOET6susjdi7N
        FQtmPeB0VLsWf/hrCYgXnKHvYqSBwKQ=
Content-Disposition: inline
In-Reply-To: <20201027080256.76497-6-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 27-10-20 16:02:56, Muchun Song wrote:
> We can reuse the code of mem_cgroup_lruvec() to simplify the code
> of the mem_cgroup_page_lruvec().

yes, removing the code duplication is reasonable. But ...

> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  include/linux/memcontrol.h | 44 +++++++++++++++++++++++++++-----------
>  mm/memcontrol.c            | 40 ----------------------------------
>  2 files changed, 32 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 95807bf6be64..5e8480e54cd8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -451,16 +451,9 @@ mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
>  	return memcg->nodeinfo[nid];
>  }
>  
> -/**
> - * mem_cgroup_lruvec - get the lru list vector for a memcg & node
> - * @memcg: memcg of the wanted lruvec
> - *
> - * Returns the lru list vector holding pages for a given @memcg &
> - * @node combination. This can be the node lruvec, if the memory
> - * controller is disabled.
> - */
> -static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
> -					       struct pglist_data *pgdat)
> +static inline struct lruvec *mem_cgroup_node_lruvec(struct mem_cgroup *memcg,
> +						    struct pglist_data *pgdat,
> +						    int nid)

This is just wrong interface. Either take nid or pgdat. You do not want
both because that just begs for wrong usage.
-- 
Michal Hocko
SUSE Labs
