From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v5 01/11] mm: memcontrol: remove dead code and comments
Date: Fri, 10 Jun 2022 16:01:49 -0700
Message-ID: <YqPNXb8k3xFdfKVj@carbon>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-2-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654902115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o/6mUBgZNpbkGWs/QZgEhqh7EhqSsLFJVzEHebhLLQ4=;
        b=PnfPfdpvq7qb1g0zYrY/UVmlMtf6qD7NeI5CnBHO8P6J9B3BR5z5axnlGN+hN5BUmBlis9
        sI0zeOhSZqywW1ercqgEpcbAcoVS+g9Wqz8CJ4R5pLQI4UG5qqMMwzXBV049TfrMJAY14K
        rBUevuGY7TKG/zIg0hHGKtU5Lr7f9G4=
Content-Disposition: inline
In-Reply-To: <20220530074919.46352-2-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, May 30, 2022 at 03:49:09PM +0800, Muchun Song wrote:
> Since no-hierarchy mode is deprecated after
> 
>   commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical mode")
> 
> so parent_mem_cgroup() cannot return a NULL except root memcg, however, root
> memcg cannot be offline, so it is safe to drop the check of returned value
> of parent_mem_cgroup().  Remove those dead code.
> 
> The comments in memcg_offline_kmem() above memcg_reparent_list_lrus() are
> out of date since
> 
>   commit 5abc1e37afa0 ("mm: list_lru: allocate list_lru_one only when needed")
> 
> There is no ordering requirement between memcg_reparent_list_lrus() and
> memcg_reparent_objcgs(), so remove those outdated comments.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Nice cleanup!
