From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3] net: memcg: late association of sock to memcg
Date: Thu, 5 Mar 2020 13:17:09 -0800
Message-ID: <9505d35b-f9fc-149b-6df5-e65ad95acabb@gmail.com>
References: <20200305205525.245058-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sMCdEJuXdOhoW7m3gO5zM39AjW+YF/Rrads4zZrd1kg=;
        b=QLDq4YaDIhaMBuukLE9flkTFbc+QtHMA/oiSdyTDoEucukwkh/qEIOtiLrIaSPrTK6
         IbBwi9DE4rWJY/cRk6jqyRNQWADhqF4G3vuMdui0IZQ7kCZlXSJ6hvraMZnX89JIvTfq
         BHstEMkSF+S53O+U2m43bKmbZaKOP7JCwhNQoCViZCDX8rGi8rzzaJV2caPcb181w2cV
         5Ih7zwO2yZySaFOkknNUNLu46EQk/KI0nqyA5a2gSpyIvBCNIcrXNyv4auEuOR6S6rYO
         wM8iKHLjtq8nNk20lh0Jm32XL9MiJhdHR8jU/J+3piz5zb/m8XsTiWgpo/DSCYRlR3js
         37Gw==
In-Reply-To: <20200305205525.245058-1-shakeelb@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>, Eric Dumazet <edumazet@google.com>, Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org



On 3/5/20 12:55 PM, Shakeel Butt wrote:
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by such sockets will
> not be accounted by the memcg.
> 
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
> 
> To fix the issue, just do the late association of the unassociated
> sockets at accept() time in the process context and then force charge
> the memory buffer already reserved by the socket.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
> Changes since v2:
> - Additional check for charging.
> - Release the sock after charging.
> 
> Changes since v1:
> - added sk->sk_rmem_alloc to initial charging.
> - added synchronization to get memory usage and set sk_memcg race-free.
> 
>  net/ipv4/inet_connection_sock.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a4db79b1b643..5face55cf818 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -482,6 +482,26 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>  		}
>  		spin_unlock_bh(&queue->fastopenq.lock);
>  	}
> +
> +	if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> +		int amt;
> +
> +		/* atomically get the memory usage, set and charge the
> +		 * sk->sk_memcg.
> +		 */
> +		lock_sock(newsk);
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
> 

This patch looks fine, but why keeping the mem_cgroup_sk_alloc(newsk);
in sk_clone_lock() ?

Note that all TCP sk_clone_lock() calls happen in softirq context.
