From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] net: memcg: late association of sock to memcg
Date: Fri, 21 Feb 2020 17:48:50 -0800
Message-ID: <20200222014850.GC459391@carbon.DHCP.thefacebook.com>
References: <20200222010456.40635-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qaCHoO3Hx8ii8y4696cDDAIrLmta3a/xTthGEakzKgU=;
 b=gLP3WY2v/mRB/odoRVOslO1LtjjjDpSUdkTXWn5r5JczTOpQo/sKZ9toYAZ/a1YJrg52
 J7mzsRcJnalaWqoGnK0jNC2m+SNdhNrKkHeyBi25QMoS055ns/S9mr7hyHOzbFh3T66d
 Lkbk5x4rW27PNTUJXj45KHjvzic+V4TWrHU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaCHoO3Hx8ii8y4696cDDAIrLmta3a/xTthGEakzKgU=;
 b=C6LdtplguHRegvR5PC9KeOW8c82X0uVsKxpKNx8BJcTBv9ZrdYygPC4zb8+9LBHIQCLk6IsOdUvuajMWo4Twms271Q+xKJCqcHCAN/921zthSx2MmSnwlhvoydaQoWo8Ax/IFC+IwQwxSGIeab5UVBTrXougKiDDQJfOONdXHt8=
Content-Disposition: inline
In-Reply-To: <20200222010456.40635-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Eric Dumazet <edumazet@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David S . Miller" <davem@davemloft.net>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, netdev@vger.kernel.org, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Feb 21, 2020 at 05:04:56PM -0800, Shakeel Butt wrote:
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by suck sockets will
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

Hello, Shakeel!

> ---
>  net/ipv4/inet_connection_sock.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index a4db79b1b643..df9c8ef024a2 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -482,6 +482,13 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>  		}
>  		spin_unlock_bh(&queue->fastopenq.lock);
>  	}
> +
> +	if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
> +		mem_cgroup_sk_alloc(newsk);
> +		if (newsk->sk_memcg)
> +			mem_cgroup_charge_skmem(newsk->sk_memcg,
> +					sk_mem_pages(newsk->sk_forward_alloc));
> +	}

Looks good for me from the memcg side. Let's see what networking people will say...

Btw, do you plan to make a separate patch for associating the socket with the default
cgroup on the unified hierarchy? I mean cgroup_sk_alloc().

Thank you for working on it!

Roman
