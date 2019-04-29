From: Michal Hocko <mhocko@kernel.org>
Subject: Re: memcg causes crashes in list_lru_add
Date: Mon, 29 Apr 2019 12:40:51 +0200
Message-ID: <20190429104051.GF21837@dhcp22.suse.cz>
References: <f0cfcfa7-74d0-8738-1061-05d778155462@suse.cz>
 <2cbfb8dc-31f0-7b95-8a93-954edb859cd8@suse.cz>
 <359d98e6-044a-7686-8522-bdd2489e9456@suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <359d98e6-044a-7686-8522-bdd2489e9456@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Slaby <jslaby@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, mm <linux-mm@kvack.org>, Linux kernel mailing list <linux-kernel@vger.kernel.org>

On Mon 29-04-19 12:09:53, Jiri Slaby wrote:
> On 29. 04. 19, 11:25, Jiri Slaby wrote:> memcg_update_all_list_lrus
> should take care about resizing the array.
> 
> It should, but:
> [    0.058362] Number of physical nodes 2
> [    0.058366] Skipping disabled node 0
> 
> So this should be the real fix:
> --- linux-5.0-stable1.orig/mm/list_lru.c
> +++ linux-5.0-stable1/mm/list_lru.c
> @@ -37,11 +37,12 @@ static int lru_shrinker_id(struct list_l
> 
>  static inline bool list_lru_memcg_aware(struct list_lru *lru)
>  {
> -       /*
> -        * This needs node 0 to be always present, even
> -        * in the systems supporting sparse numa ids.
> -        */
> -       return !!lru->node[0].memcg_lrus;
> +       int i;
> +
> +       for_each_online_node(i)
> +               return !!lru->node[i].memcg_lrus;
> +
> +       return false;
>  }
> 
>  static inline struct list_lru_one *
> 
> 
> 
> 
> 
> Opinions?

Please report upstream. This code here is there for quite some time.
I do not really remember why we do have an assumption about node 0
and why it hasn't been problem until now.

Thanks!
-- 
Michal Hocko
SUSE Labs
