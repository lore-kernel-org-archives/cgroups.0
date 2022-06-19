From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v5 09/11] mm: memcontrol: use obj_cgroup APIs to charge
 the LRU pages
Date: Sun, 19 Jun 2022 13:32:18 -0700
Message-ID: <Yq+H0v0/nuxPRLX+@castle>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-10-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655670744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/iFzVnSMJWQfW6ecslMrsDUmHZ1b88XfEpJU+8AWm4I=;
        b=jdnZFEZHOLbOp782xUrFZDV9bkoz87qvOXXknUfwfEDMS6vQCKYIHqWX9FuG3L49Ub8CqO
        X2SHeiVHXr59jzxUDeShfbhkM1/S8dJKtZWUxV3s1aCoQSk3UGq8JQ4OQBiQdMsu6iT7jb
        qHFttOTcjUj8VNbKGY4/L59wUe54hKQ=
Content-Disposition: inline
In-Reply-To: <20220530074919.46352-10-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, May 30, 2022 at 03:49:17PM +0800, Muchun Song wrote:
> We will reuse the obj_cgroup APIs to charge the LRU pages. Finally,
> page->memcg_data will have 2 different meanings.
> 
>   - For the slab pages, page->memcg_data points to an object cgroups
>     vector.
> 
>   - For the kmem pages (exclude the slab pages) and the LRU pages,
>     page->memcg_data points to an object cgroup.
> 
> In this patch, we reuse obj_cgroup APIs to charge LRU pages. In the end,
> The page cache cannot prevent long-living objects from pinning the original
> memory cgroup in the memory.
> 
> At the same time we also changed the rules of page and objcg or memcg
> binding stability. The new rules are as follows.
> 
> For a page any of the following ensures page and objcg binding stability:
> 
>   - the page lock
>   - LRU isolation
>   - lock_page_memcg()
>   - exclusive reference
> 
> Based on the stable binding of page and objcg, for a page any of the
> following ensures page and memcg binding stability:
> 
>   - objcg_lock
>   - cgroup_mutex
>   - the lruvec lock
>   - the split queue lock (only THP page)
> 
> If the caller only want to ensure that the page counters of memcg are
> updated correctly, ensure that the binding stability of page and objcg
> is sufficient.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Aside from two questions, which I raised in the comments to previous patches
in the series:
1) perf impact,
2) should we open-code the reparenting procedure to show the locking in a more
explicit ways?

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!
