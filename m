From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH memcg] memcg: prohibit unconditional exceeding the limit
 of dying tasks
Date: Mon, 13 Sep 2021 10:51:37 +0300
Message-ID: <8b98d44a-aeb2-5f5f-2545-ac2bd0c7049b@virtuozzo.com>
References: <5b06a490-55bc-a6a0-6c85-690254f86fad@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=U4RAeSovTvpMRoz+/O0gqhyhiu8Ap3QYy/JuIDY+LGQ=; b=PHISA81fMzX7U1PJK
        4jMERB9nGCylx9xhsenaCZO9osLoDfy+1CfYpuXrEUwCyXj1LM98p3ShFPalaRAEU0KAbdr3EP/bC
        zkLEsPyfEAV5bU5ZBlbuf35U7inCJ5yeA+aSUbManIFFNuT2ACDZhO0e9iicSOvGZT8bz6W5/BN+k
        =;
In-Reply-To: <5b06a490-55bc-a6a0-6c85-690254f86fad-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 9/10/21 3:39 PM, Vasily Averin wrote:
> The kernel currently allows dying tasks to exceed the memcg limits.
> The allocation is expected to be the last one and the occupied memory
> will be freed soon.
> This is not always true because it can be part of the huge vmalloc
> allocation. Allowed once, they will repeat over and over again.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 389b5766e74f..67195fcfbddf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2622,15 +2625,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (gfp_mask & __GFP_ATOMIC)
>  		goto force;
>  
> -	/*
> -	 * Unlike in global OOM situations, memcg is not in a physical
> -	 * memory shortage.  Allow dying and OOM-killed tasks to
> -	 * bypass the last charges so that they can exit quickly and
> -	 * free their memory.
> -	 */
> -	if (unlikely(should_force_charge()))
> -		goto force;
> -

Should we keep current behaviour for (current->flags & PF_EXITING) case perhaps?
It is set inside do_exit only and (I hope) cannot trigger huge vmalloc allocations.

Thank you,
	Vasily Averin
