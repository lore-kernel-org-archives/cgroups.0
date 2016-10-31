From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v7 5/6] net: ipv4, ipv6: run cgroup eBPF egress programs
Date: Mon, 31 Oct 2016 12:40:03 -0400 (EDT)
Message-ID: <20161031.124003.1361406552151798940.davem@davemloft.net>
References: <1477390454-12553-1-git-send-email-daniel@zonque.org>
        <1477390454-12553-6-git-send-email-daniel@zonque.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1477390454-12553-6-git-send-email-daniel@zonque.org>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: daniel@zonque.org
Cc: htejun@fb.com, daniel@iogearbox.net, ast@fb.com, kafai@fb.com, fw@strlen.de, pablo@netfilter.org, harald@redhat.com, netdev@vger.kernel.org, sargun@sargun.me, cgroups@vger.kernel.org

From: Daniel Mack <daniel@zonque.org>
Date: Tue, 25 Oct 2016 12:14:13 +0200

> @@ -312,6 +314,13 @@ int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  	skb->dev = dev;
>  	skb->protocol = htons(ETH_P_IP);
>  
> +	ret = cgroup_bpf_run_filter(sk_to_full_sk(sk), skb,
> +				    BPF_CGROUP_INET_EGRESS);
> +	if (ret) {
> +		kfree_skb(skb);
> +		return ret;
> +	}
> +
>  	/*
>  	 *	Multicasts are looped back for other local users
>  	 */
> @@ -364,12 +373,20 @@ int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  int ip_output(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
>  	struct net_device *dev = skb_dst(skb)->dev;
> +	int ret;
>  
>  	IP_UPD_PO_STATS(net, IPSTATS_MIB_OUT, skb->len);
>  
>  	skb->dev = dev;
>  	skb->protocol = htons(ETH_P_IP);
>  
> +	ret = cgroup_bpf_run_filter(sk_to_full_sk(sk), skb,
> +				    BPF_CGROUP_INET_EGRESS);
> +	if (ret) {
> +		kfree_skb(skb);
> +		return ret;
> +	}
> +
>  	return NF_HOOK_COND(NFPROTO_IPV4, NF_INET_POST_ROUTING,
>  			    net, sk, skb, NULL, dev,
>  			    ip_finish_output,

The "sk" here is not necessarily the application socket.  It could be
a UDP tunnel socket or similar encapsulation object.

"skb->sk" is always the application socket, so is probably what you
need to pass down into the cgroup bpf run filter hook.
