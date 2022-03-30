From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm/memcg: set pos to prev unconditionally
Date: Wed, 30 Mar 2022 08:08:49 -0400
Message-ID: <YkRIUbEGHVIbVRNO@cmpxchg.org>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
 <20220225003437.12620-3-richard.weiyang@gmail.com>
 <YkNUZYrSHPjJ1XOb@cmpxchg.org>
 <20220330004750.fx4jr4bnehz4ynpf@master>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3I4Wbaw8kW2EJmKRBW9VuujWkyfUQDWPpToJHWZ1Qxw=;
        b=kJ787gVx9QHZo7fifirsTebaVbsgM8uMPI7864OsHOZ3EgMFvXCs3vCmHRRw3xcQBH
         Wcl5CxrShaHSDA7OgMLJTtUwQ3CyvHjey7usvwz80QYsP82N3F9hQ2yg+qwJnmRIV/+i
         83uwETu83rMHK6xuRJWxOtHE8OwXGCpMp8iKb9EDLjwvlJrBxhPVfHZ2u6dr/vPs6KgY
         KUbLkeFACeDgEZuSdhxqxJiMwoEUuW94gtay9eXCBTPgUOrs86Ii6/oFZuzfJWHYxYcx
         HpjqHXQUK7V9lmwpZd32YuBkVIRpuvfVpQNnNBgWNQiE5p8TXRvyN+SPZ4DA+iYSXq/F
         R6dg==
Content-Disposition: inline
In-Reply-To: <20220330004750.fx4jr4bnehz4ynpf@master>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Mar 30, 2022 at 12:47:50AM +0000, Wei Yang wrote:
> Something like this?
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index eed9916cdce5..5d433b79ba47 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1005,9 +1005,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  	if (!root)
>  		root = root_mem_cgroup;
>  
> -	if (prev && !reclaim)
> -		pos = prev;
> -
>  	rcu_read_lock();
>  
>  	if (reclaim) {
> @@ -1033,6 +1030,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  			 */
>  			(void)cmpxchg(&iter->position, pos, NULL);
>  		}
> +	} else if (prev) {
> +		pos = prev;
>  	}
>  
>  	if (pos)

Yep!
