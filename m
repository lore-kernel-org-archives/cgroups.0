From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Bypass high reclaim iteration for cgroup
 hierarchy root
Date: Wed, 1 Apr 2020 18:23:06 -0700
Message-ID: <20200401182306.724698b74692b5d31f66ad10@linux-foundation.org>
References: <20200312164137.GA1753625@chrisdown.name>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585790587;
        bh=/XWfr8B2+Gdq9aBiaTze7oFSffBCOQXALgeP7OSUoQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=M+kfbZ9UrQu3G+ELPmQ1UpQH6jzItlc6P2SWjstji9UaUSHoI42uhLz0GCrHwnyx/
         ZwI8RIGgcPMexnOXuBDWj4+S+SxyZPVlNjjQ0mkCAeQ4t7v7YUjvLhrUdv5sSQOl4I
         vy4yB6xaC3seVhG8xKwbIV0+jkhCZBTUuL4EW8tc=
In-Reply-To: <20200312164137.GA1753625-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, 12 Mar 2020 16:41:37 +0000 Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:

> The root of the hierarchy cannot have high set, so we will never reclaim
> based on it. This makes that clearer and avoids another entry.
> 
> ...
>
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2232,7 +2232,8 @@ static void reclaim_high(struct mem_cgroup *memcg,
>  			continue;
>  		memcg_memory_event(memcg, MEMCG_HIGH);
>  		try_to_free_mem_cgroup_pages(memcg, nr_pages, gfp_mask, true);
> -	} while ((memcg = parent_mem_cgroup(memcg)));
> +	} while ((memcg = parent_mem_cgroup(memcg)) &&
> +		 !mem_cgroup_is_root(memcg));
>  }
>  
>  static void high_work_func(struct work_struct *work)

Does someone have time to review this one?

Thanks.
