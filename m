From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: memcg/slab: Fix root memcg vmstats
Date: Tue, 27 Oct 2020 11:48:35 -0700
Message-ID: <20201027184835.GB827280@carbon.dhcp.thefacebook.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
 <20201027080256.76497-5-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=YYIDm6vBky5b+eR+z0XP0sxL+m0uO6A3tNoGMTT1CtU=;
 b=QJu+uFzi2/eCW+w1xci9H8MxDFqBLAuAb8ww+S4MVcRG0NGjwCR3ndTCzCej7ugbJ032
 LCk8qKomLUwNiz1fYKnAMOTCXLUouLLlJRVu9ipQbpyy6uGyhXB9nho/6MJ5zkYjSmwq
 pDZj/2yTOsMuGcX8FJNoGciP/UjObPagdos= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YYIDm6vBky5b+eR+z0XP0sxL+m0uO6A3tNoGMTT1CtU=;
 b=aMocAEx+niVj5PB+ozZM6l0WeJSAzmfS1J4ZaunRT7bniKnoY9EHhIoxINfidWlUygLULUqaTvAuVtonM7wSpqWpLajb1uy/5+C8Bq+qH49vRcmDZ5luNJLuSB1WxQT+TqbhjGUW8MLpMpEQwAb1swKzXRVLvJtzA4K9V2oedlo=
Content-Disposition: inline
In-Reply-To: <20201027080256.76497-5-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Oct 27, 2020 at 04:02:55PM +0800, Muchun Song wrote:
> If we reparent the slab objects to the root memcg, when we free
> the slab object, we need to update the per-memcg vmstats to keep
> it correct for the root memcg. Now this at least affects the vmstat
> of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
> size is smaller than the PAGE_SIZE.
> 
> Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Can you, please, drop this patch for now?

I'm working on a bigger cleanup related to the handling of the root memory
cgroup (I sent a link earlier in this thread), which already does a similar change.
There are several issues like this one, so it will be nice to fix them all at once.

Thank you!

> ---
>  mm/memcontrol.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22b4fb941b54..70345b15b150 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -875,8 +875,13 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
>  	rcu_read_lock();
>  	memcg = mem_cgroup_from_obj(p);
>  
> -	/* Untracked pages have no memcg, no lruvec. Update only the node */
> -	if (!memcg || memcg == root_mem_cgroup) {
> +	/*
> +	 * Untracked pages have no memcg, no lruvec. Update only the
> +	 * node. If we reparent the slab objects to the root memcg,
> +	 * when we free the slab object, we need to update the per-memcg
> +	 * vmstats to keep it correct for the root memcg.
> +	 */
> +	if (!memcg) {
>  		__mod_node_page_state(pgdat, idx, val);
>  	} else {
>  		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> -- 
> 2.20.1
> 
