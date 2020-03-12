From: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Subject: Re: [PATCH v4 2/2] net: memcg: late association of sock to memcg
Date: Thu, 12 Mar 2020 10:03:31 -0400
Message-ID: <1584021811.7365.180.camel@lca.pw>
References: <20200310051606.33121-1-shakeelb@google.com>
         <20200310051606.33121-2-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=llnqGMEP0WhestZ7Ck/j/TXED0wzZ+R7hJNKQAMFwSw=;
        b=ID3zIu4I4SYuh3dOvdboHzfUp3zrBkMZ78ALde5G9suHbGgxzk14dfh6HX6hcn9Wna
         R4ATKeTZ0UR88ii+B9cp/1mPaYzSAC5G9EeUbljITfIR+vL15CV2FxSBDzHfsJsOf/K/
         8II7onlt8fLcH04pHDA7OfApc7ziQMikZIPDK1Eh2hhcP5cZ2Ltqn5W7guqO0bcw92Dy
         UoJ8pBBedDvQJJp7uMwIBFXs1WdRqOHXknP4GZvozHABqttvVfrD9XUwXuTWJWsMqmP9
         X5y4lDZKcLxXW/j7o/6fhQOpzl03B5NLKJ+fTJBx7IBEqQerGIPB0/9zM36V2y5Yqgo3
         cweQ==
In-Reply-To: <20200310051606.33121-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, 2020-03-09 at 22:16 -0700, Shakeel Butt wrote:
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a4db79b1b643..65a3b2565102 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -482,6 +482,26 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>  		}
>  		spin_unlock_bh(&queue->fastopenq.lock);
>  	}
> +
> +	if (mem_cgroup_sockets_enabled) {
> +		int amt;
> +
> +		/* atomically get the memory usage, set and charge the
> +		 * sk->sk_memcg.
> +		 */
> +		lock_sock(newsk);

Here we have a deadlock,

[  362.620977][ T4106] WARNING: possible recursive locking detected
[  362.626983][ T4106] 5.6.0-rc5-next-20200312+ #5 Tainted: G             L   
[  362.633941][ T4106] --------------------------------------------
[  362.639944][ T4106] sshd/4106 is trying to acquire lock:
[  362.645251][ T4106] 7bff008a2eae6330 (sk_lock-AF_INET){+.+.}, at:
inet_csk_accept+0x370/0x45c
inet_csk_accept at net/ipv4/inet_connection_sock.c:497
[  362.653791][ T4106] 
[  362.653791][ T4106] but task is already holding lock:
[  362.661007][ T4106] c0ff008a2eae9430 (sk_lock-AF_INET){+.+.}, at:
inet_csk_accept+0x48/0x45c
inet_csk_accept at net/ipv4/inet_connection_sock.c:451
[  362.669452][ T4106] 
[  362.669452][ T4106] other info that might help us debug this:
[  362.677364][ T4106]  Possible unsafe locking scenario:
[  362.677364][ T4106] 
[  362.684666][ T4106]        CPU0
[  362.687801][ T4106]        ----
[  362.690937][ T4106]   lock(sk_lock-AF_INET);
[  362.695204][ T4106]   lock(sk_lock-AF_INET);
[  362.699472][ T4106] 
[  362.699472][ T4106]  *** DEADLOCK ***
[  362.699472][ T4106] 
[  362.707469][ T4106]  May be due to missing lock nesting notation
[  362.707469][ T4106] 
[  362.715643][ T4106] 1 lock held by sshd/4106:
[  362.719993][ T4106]  #0: c0ff008a2eae9430 (sk_lock-AF_INET){+.+.}, at:
inet_csk_accept+0x48/0x45c
[  362.728874][ T4106] 
[  362.728874][ T4106] stack backtrace:
[  362.734622][ T4106] CPU: 22 PID: 4106 Comm: sshd Tainted:
G             L    5.6.0-rc5-next-20200312+ #5
[  362.744096][ T4106] Hardware name: HPE Apollo
70             /C01_APACHE_MB         , BIOS L50_5.13_1.11 06/18/2019
[  362.754525][ T4106] Call trace:
[  362.757667][ T4106]  dump_backtrace+0x0/0x2c8
[  362.762022][ T4106]  show_stack+0x20/0x2c
[  362.766032][ T4106]  dump_stack+0xe8/0x150
[  362.770128][ T4106]  validate_chain+0x2f08/0x35e0
[  362.774830][ T4106]  __lock_acquire+0x868/0xc2c
[  362.779358][ T4106]  lock_acquire+0x320/0x360
[  362.783715][ T4106]  lock_sock_nested+0x9c/0xd8
[  362.788243][ T4106]  inet_csk_accept+0x370/0x45c
[  362.792861][ T4106]  inet_accept+0x80/0x1cc
[  362.797045][ T4106]  __sys_accept4_file+0x1b0/0x2bc
[  362.801921][ T4106]  __arm64_sys_accept+0x74/0xc8
[  362.806625][ T4106]  do_el0_svc+0x170/0x240
[  362.810807][ T4106]  el0_sync_handler+0x150/0x250
[  362.815509][ T4106]  el0_sync+0x164/0x180


> +
> +		/* The sk has not been accepted yet, no need to look at
> +		 * sk->sk_wmem_queued.
> +		 */
> +		amt = sk_mem_pages(newsk->sk_forward_alloc +
> +				   atomic_read(&sk->sk_rmem_alloc));
> +		mem_cgroup_sk_alloc(newsk);
> +		if (newsk->sk_memcg && amt)
> +			mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
> +
> +		release_sock(newsk);
> +	}
>  out:
>  	release_sock(sk);
>  	if (req)
