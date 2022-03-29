From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm/memcg: set pos to prev unconditionally
Date: Tue, 29 Mar 2022 14:48:05 -0400
Message-ID: <YkNUZYrSHPjJ1XOb@cmpxchg.org>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
 <20220225003437.12620-3-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Ue720j7ugMkQUnb/lt991xjPAItzSMjnM76/9qe6aU=;
        b=m6HX8Nmsz+ICbn4fQENinggQ3NePah2mEpss7FwHfTZ8TgTA/q2tp4ZWR/xTIIBTFG
         2lPBT9Ao7i0bjlT6pVRcUsxuGI++hVnjIjc+wSd05nK4flH1vx52YMeMGifUVs4GHKBa
         u2ALEJs2/rMaS4dpk/yXsQVQR6AfguhD+rpcrxOsZKDZnovFsXauEbmFOfWOaGDbvW0R
         T7Lifas5OuwCA5raKzWXiMNQyKauI4h23+MmdmPeO20ChEq6Uhv5la9v2uD6ztvm5tLn
         HfShR2sq1TmiBfZFvvwtR5vFW0eii01viX0Zb6xemCxICMTUXTTLWLlUsG/sCOrGPxa0
         R3Jw==
Content-Disposition: inline
In-Reply-To: <20220225003437.12620-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Feb 25, 2022 at 12:34:36AM +0000, Wei Yang wrote:
> Current code set pos to prev based on condition (prev && !reclaim),
> while we can do this unconditionally.
> 
> Since:
> 
>   * If !reclaim, pos is the same as prev no matter it is NULL or not.
>   * If reclaim, pos would be set properly from iter->position.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 9464fe2aa329..03399146168f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -980,7 +980,7 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  	struct mem_cgroup_reclaim_iter *iter;
>  	struct cgroup_subsys_state *css = NULL;
>  	struct mem_cgroup *memcg = NULL;
> -	struct mem_cgroup *pos = NULL;
> +	struct mem_cgroup *pos = prev;

I don't like this so much. It suggests pos always starts with prev, no
matter what. But this isn't true for reclaim mode, which overrides the
initialized value again.

>  	if (mem_cgroup_disabled())
>  		return NULL;
> @@ -988,9 +988,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  	if (!root)
>  		root = root_mem_cgroup;
>  
> -	if (prev && !reclaim)
> -		pos = prev;

How about making the reclaim vs non-reclaim mode explicit and do:

	if (reclaim) {
		...
		pos = iter->position;
		...
	} else {
		pos = prev;
	}
