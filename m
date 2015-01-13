From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 1/3] mm: memcontrol: remove unnecessary soft limit tree
 node test
Date: Tue, 13 Jan 2015 15:50:53 +0100
Message-ID: <20150113145053.GG25318@dhcp22.suse.cz>
References: <1420856041-27647-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vLeZsX0FR81QM84PvATym1gs+5Ny4jZc7MRRG0jeicA=;
        b=R0z++1KTJosqCVgIkzzAdq4BurwR1ye0vxOyAEx4e/saBCGphUVCRsCLpKn3IPoyiJ
         3jiMk5NgLmmYLFK4o6zarC4MUxLASeWakFD/NuIMKejBmXKYiDND7UKPjetlY8Fu3fJJ
         TknfDwlKyvdcnzbVzX095eGEkE19/d6xz47DUMa2hiFbU6GWjwpIc7DA68TUGKCPV8Jj
         HNCvbOUZ+za3hH0ydLUejZG1GULGSTjGKfaoNASq6CQIQZDtszqtqvpxIiW+biHxDIvD
         aQw9IUWdn+jBZJff5FcRzZwb95YHK66DYqYpkJyEZRj6zzU+Wy4eKxZHGzbQkeK/UnmI
         7AVw==
Content-Disposition: inline
In-Reply-To: <1420856041-27647-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri 09-01-15 21:13:59, Johannes Weiner wrote:
> kzalloc_node() automatically falls back to nodes with suitable memory.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index fd9e542fc26f..aad254b30708 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4520,13 +4520,10 @@ static void __init mem_cgroup_soft_limit_tree_init(void)
>  {
>  	struct mem_cgroup_tree_per_node *rtpn;
>  	struct mem_cgroup_tree_per_zone *rtpz;
> -	int tmp, node, zone;
> +	int node, zone;
>  
>  	for_each_node(node) {
> -		tmp = node;
> -		if (!node_state(node, N_NORMAL_MEMORY))
> -			tmp = -1;
> -		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, tmp);
> +		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
>  		BUG_ON(!rtpn);
>  
>  		soft_limit_tree.rb_tree_per_node[node] = rtpn;
> -- 
> 2.2.0
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
