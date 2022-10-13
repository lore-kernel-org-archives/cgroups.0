From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to
 mem_cgroup_charge_skmem()
Date: Wed, 12 Oct 2022 17:38:25 -0700
Message-ID: <20221012173825.45d6fbf2@kernel.org>
References: <20210817194003.2102381-1-weiwan@google.com>
        <20221012163300.795e7b86@kernel.org>
        <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665621507;
        bh=fIBx0fk/i8Gefd9ZrizLeDWC35/uKkbdvMp4L+ilGNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eNs9F9rFjafI66l1WW5TTwHbmhFJfSVZnqqopbkioUXtDKPK3ZXJ5vS3L3IWP7hEg
         3mpiVdYUZhVOW1o8sirKSi/2D8i355P6m6fVomdolTfp+Flio7KfrTYPtJqpGDQUtB
         y0SIq1IsGnlPN9et7Rern9nsc3exKuFw0aqCtCtPxQF5M86EPfKdeJgu78+jctC4RH
         kViRiN6Elm0D4SWR4uRwsgsX/ufs0VoLz7wF8QlKNo8ooSjpPJy4eNXoW5d3oelkpz
         v2nNtb23iJq83ftiFPOcfb/QX7ToN8YGHxfj+llW+wIaCbm8TEY8mGrSXoP6tGT3Xc
         EjpdQTw0eq/CA==
In-Reply-To: <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Wei Wang <weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

On Wed, 12 Oct 2022 17:17:38 -0700 Shakeel Butt wrote:
> Did the revert of this patch fix the issue you are seeing? The reason
> I am asking is because this patch should not change the behavior.
> Actually someone else reported the similar issue for UDP RX at [1] and
> they tested the revert as well. The revert did not fix the issue for
> them.
> 
> Wei has a better explanation at [2] why this patch is not the cause
> for these issues.

We're talking TCP here, to be clear. I haven't tested a revert, yet (not
that easy to test with a real workload) but I'm relatively confident the
change did introduce an "unforced" call, specifically this bit:

@@ -2728,10 +2728,12 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
 	struct proto *prot = sk->sk_prot;
 	long allocated = sk_memory_allocated_add(sk, amt);
+	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
 	bool charged = true;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt)))
+	if (memcg_charge &&
+	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
+						gfp_memcg_charge())))

where gfp_memcg_charge() is GFP_NOWAIT in softirq.

The above gets called from (inverted stack):
 tcp_data_queue()
 tcp_try_rmem_schedule(sk, skb, skb->truesize)
 tcp_try_rmem_schedule()
 sk_rmem_schedule()
 __sk_mem_schedule()
 __sk_mem_raise_allocated()

Is my confidence unjustified? :)
