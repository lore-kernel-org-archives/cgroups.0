From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm/memcontrol:rewrite mem_cgroup_page_lruvec()
Date: Wed, 4 Nov 2020 14:38:00 -0800
Message-ID: <20201104223800.GD1938922@carbon.dhcp.thefacebook.com>
References: <20201104142516.GA106571@rlk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=SaXYkKIlRUoE2k29DxM72HhU3WLstM7GE8lDlgF29S8=;
 b=jJOWNDX3uFjBKHQP197Ajf+iOzNFtbD7H/mju691sv6If979RmQpjJ10ahihL9UOjPFC
 E+AJtQQAAs0tPBH8EfhZJ2iNjYw1C8nrorQGy37aKa8bYeZ/QBaXrVpHaYd0fkE7s7dH
 rqSMC+wCFnVFXGeUhgctA9co+cINrLiW/9g= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SaXYkKIlRUoE2k29DxM72HhU3WLstM7GE8lDlgF29S8=;
 b=TDENzwI3mNN8drG9OZM+Lc3CC5ZefjbWaxNbV8DQ1leGm+t2RMiNLMqPBR5RpI14dR2X41ip54+nWHau1/92s5OH762Hi9WiADFRBI+8DX7QSehMgk8rp6d5xk6GuNi6NojCG32CVGwPuUwyS8X/tEsjOkHkQC2SFaLdMwztEIc=
Content-Disposition: inline
In-Reply-To: <20201104142516.GA106571@rlk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hui Su <sh_def@163.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, laoar.shao@gmail.com, chris@chrisdown.name, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed, Nov 04, 2020 at 10:25:16PM +0800, Hui Su wrote:
> mem_cgroup_page_lruvec() in memcontrol.c and
> mem_cgroup_lruvec() in memcontrol.h is very similar
> except for the param(page and memcg) which also can be
> convert to each other.
> 
> So rewrite mem_cgroup_page_lruvec() with mem_cgroup_lruvec().
> 
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
>  include/linux/memcontrol.h | 18 +++++++++++++++--
>  mm/memcontrol.c            | 40 --------------------------------------
>  2 files changed, 16 insertions(+), 42 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e391e3c56de5..a586363fb766 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -457,9 +457,10 @@ mem_cgroup_nodeinfo(struct mem_cgroup *memcg, int nid)
>  /**
>   * mem_cgroup_lruvec - get the lru list vector for a memcg & node
>   * @memcg: memcg of the wanted lruvec
> + * @pgdat: pglist_data
>   *
>   * Returns the lru list vector holding pages for a given @memcg &
> - * @node combination. This can be the node lruvec, if the memory
> + * @pgdat combination. This can be the node lruvec, if the memory
>   * controller is disabled.
>   */
>  static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
> @@ -489,7 +490,20 @@ static inline struct lruvec *mem_cgroup_lruvec(struct mem_cgroup *memcg,
>  	return lruvec;
>  }

Hi Hui,

>  
> -struct lruvec *mem_cgroup_page_lruvec(struct page *, struct pglist_data *);
> +/**
> + * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
> + * @page: the page
> + * @pgdat: pgdat of the page
> + *
> + * This function relies on page->mem_cgroup being stable.
> + */
> +static inline struct lruvec *mem_cgroup_page_lruvec(struct page *page,
> +						struct pglist_data *pgdat)

Hm, do we need to pass page and pgdat?

> +{
> +	struct mem_cgroup *memcg = page->mem_cgroup;

It seems like you need to rebase the patch against the latest mm snapshot.

> +
> +	return mem_cgroup_lruvec(memcg, pgdat);

Thanks!
