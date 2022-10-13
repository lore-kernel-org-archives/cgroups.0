From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
Date: Thu, 13 Oct 2022 00:54:31 +0000
Message-ID: <20221013005431.wzjurocrdoozykl7@google.com>
References: <20210817194003.2102381-1-weiwan@google.com> <20221012163300.795e7b86@kernel.org>
 <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com> <20221012173825.45d6fbf2@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2tlT0sKryIjjlYcEvRxXBonCj9sjgTZRO4xGVKaegZc=;
        b=aCC+5QU5Q6ql86BpxO4LEXx32nPTesKN2ifqvcP4ePLuU4LSDEC9aC5PcOyvEq0Tio
         lT95CTcSyY026VFVEPc6wa5F7zF2cYv2M5AG9//2M0Jv5R1mSTFLzZd3QK5pWtPWjvTQ
         7QdVXzB93hHMtr7jFlS7ez4Ze2Me5JUuBRa69ctkMF1i478rc2j4UC7ms1mvWEBNs3pT
         PgKUPt8lLz2rUP4Zf688haPjC7tU0IPluU6wxir/wOA2bL6EJo0hXIA49VJMvK3Q5WiC
         DkXwUroV44w0bjwTtglFGghxbDo7MVzZouxftAmhHGb/0j79QDmmff0E+hnfPrMPoZ40
         UAFQ==
In-Reply-To: <20221012173825.45d6fbf2-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Wed, Oct 12, 2022 at 05:38:25PM -0700, Jakub Kicinski wrote:
> On Wed, 12 Oct 2022 17:17:38 -0700 Shakeel Butt wrote:
> > Did the revert of this patch fix the issue you are seeing? The reason
> > I am asking is because this patch should not change the behavior.
> > Actually someone else reported the similar issue for UDP RX at [1] and
> > they tested the revert as well. The revert did not fix the issue for
> > them.
> > 
> > Wei has a better explanation at [2] why this patch is not the cause
> > for these issues.
> 
> We're talking TCP here, to be clear. I haven't tested a revert, yet (not
> that easy to test with a real workload) but I'm relatively confident the
> change did introduce an "unforced" call, specifically this bit:
> 
> @@ -2728,10 +2728,12 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>  {
>  	struct proto *prot = sk->sk_prot;
>  	long allocated = sk_memory_allocated_add(sk, amt);
> +	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
>  	bool charged = true;
>  
> -	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
> -	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt)))
> +	if (memcg_charge &&
> +	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
> +						gfp_memcg_charge())))
> 
> where gfp_memcg_charge() is GFP_NOWAIT in softirq.
> 
> The above gets called from (inverted stack):
>  tcp_data_queue()
>  tcp_try_rmem_schedule(sk, skb, skb->truesize)
>  tcp_try_rmem_schedule()
>  sk_rmem_schedule()
>  __sk_mem_schedule()
>  __sk_mem_raise_allocated()
> 
> Is my confidence unjustified? :)
> 

Let me add Wei's explanation inline which is protocol independent:

	__sk_mem_raise_allocated() BEFORE the above patch is:
	- mem_cgroup_charge_skmem() gets called:
	    - try_charge() with GFP_NOWAIT gets called and  failed
	    - try_charge() with __GFP_NOFAIL
	    - return false
	- goto suppress_allocation:
	    - mem_cgroup_uncharge_skmem() gets called
	- return 0 (which means failure)

	AFTER the above patch, what happens in __sk_mem_raise_allocated() is:
	- mem_cgroup_charge_skmem() gets called:
	    - try_charge() with GFP_NOWAIT gets called and failed
	    - return false
	- goto suppress_allocation:
	    - We no longer calls mem_cgroup_uncharge_skmem()
	- return 0

So, before the patch, the memcg code may force charges but it will
return false and make the networking code to uncharge memcg for
SK_MEM_RECV.
