Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795451046;
	b=cIMyrwO16xVhcpEZ2SUp4J4mMrkaEay3ap123rqrhpdmrs68/8LFhUCnIEE6nwug/ZH7
	 Te6e0P4uvJLZ8O+mXw4EVs/2QaeHSsloqGd6LYPlB7JS7+IQma0Pq+1kfpWaC5yyqnovm
	 PudfkESGoKLt8U5W2IFTME6/zMhhyYnwWw/dVIPL5B0LuY+ZHakyuweCxWWYLLEKMMM9A
	 qSPKI2r+GpT7mDIDTpIWI/6H0sa/tzb7pxNc5TarOJqQM2qoGANJvyDXyVaUtQdF6zyQ5
	 shl+JGccFF8lq5OoAflxcFZXeTi+kPUo4UKNekq1FcZhbs5E6QBciEhn/vz2umfArYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795451046;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ME4azgngOCTJNfnpv6QdSj8+9zz0mmaxRAUYJ+dI6fs=;
	b=V5ggBzkb7wfFCYzoWvifeTY7gz7aQcDUPVth0zRXxRls2WJ4WTpzmC8nN8GmGgUb3Ywv
	 B2t/5e9GkSTJPmJaF0WISKUKsQHy8oLuS/cJbw8CiupfJW+uTUAJQ0qj7lSJuPNC/QiPP
	 cssxYcoPy0WlBY8MUGAqquhbKXrKZC0simMdmmlZv+cXj15weiYbrpzbIFzbw3zQR6u9I
	 OKsn70HcTsNTxZmh+D6/xTor7cSPTeBLGTj/uWzhlBz67LF1Um11jqre/rM0wMK3AEO0U
	 caEzGzCJKJ/9cqYuEmIoQijLDvsgY4e7o0s7K7g9+e6KodC+6RcV4H//5Mhz/bB10EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0RRJX22;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C440606A685;
	Mon, 23 Nov 2026 16:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0RRJX22
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092631F0093E;
	Mon, 23 Nov 2026 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451046;
	bh=ME4azgngOCTJNfnpv6QdSj8+9zz0mmaxRAUYJ+dI6fs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=N0RRJX22wIA9TkrEx1tjIGlt3lmxaaFzDw/lSUKyIMt7cEWat0bGVFjYgbHgQQIQ2
	 wOvA3XXlvtWO1f1JVBiDYbwdK/x8ko0nO7axlVj9H/10hDnuJzbI+fzgQBsZyd3iyf
	 DS2Cs0ZpiH8PGSjjJTIpPYHpJZwlhtk8WwUWxLJNrRKOvTCggl7YAdMYYNw46WiL/+
	 xfoCRKY9H1WBegipnLGbXBdh9JpuvtHGFvbLnktk5J4XqkQsAnQ+Eka++pDNeJD5Ez
	 7/bHrIW1JP4ekQL+qhotAKmiHj52y+Nvpmvdrgob7idGvYtJhV2BwZlSKp22CWiTiw
	 RJVWToXrKWUFw==
Subject: Re: [PATCH net 2/3] net: account IPV6_2292PKTOPTIONS and multicast
 socket state to memcg
From: netdev-bot+sashiko@kernel.org
To: x-professor@outlook.com
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Nov 2026 16:24:04 +0000
Message-ID: <179545104461.3135.5611486557181472051@kernel.org>
In-Reply-To: <5f2e25611e300561db512cd3ad3190f4d782484a.1795102467.git.x-professor@outlook.com>
References: <5f2e25611e300561db512cd3ad3190f4d782484a.1795102467.git.x-professor@outlook.com>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 (1) · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The patch charges the IPV6_2292PKTOPTIONS buffer to memcg only
  where setsockopt() first allocates it (do_ipv6_setsockopt(),…
- [Medium] This patch charges the per-socket multicast records but not
  the per-device objects that the same join and source operations create.
- [Low] In the source-removal (!add) branch of ip6_mc_source()
  (net/ipv6/mcast.c:437 in this commit), the code allocates a smaller…

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the commit
  message describes it as a general sock_kmalloc() issue: 'Allocations…

--

net: account IPV6_2292PKTOPTIONS and multicast socket state to memcg

This commit changes several long-lived socket allocations to
GFP_KERNEL_ACCOUNT so they are charged to the memory cgroup. The affected
allocations are the IPV6_2292PKTOPTIONS cmsg buffer, the IPv4 and IPv6
multicast source lists, and the IPv4 and IPv6 multicast membership
records. sock_kmalloc() itself is left unchanged because some of its
callers run in softirq context.

> sock_kmalloc() limits allocations using sk_omem_alloc and optmem_max,
> but does not request kernel memory cgroup accounting.  Allocations retained
> by a socket can therefore consume kernel memory without contributing to
> memory.current.

[ ... ]

> sock_kmalloc() itself is left unchanged: some callers run in softirq
> context, where current_obj_cgroup() uses an explicitly active memcg or
> the root memcg, so those allocations have different charge-attribution
> semantics.

[Severity: High]
This is a pre-existing issue and was not introduced by this patch. The
commit message describes this as a general sock_kmalloc() problem, but the
reason given for leaving sock_kmalloc() alone only covers softirq callers.

Several process-context sock_kmalloc() sites also keep allocations for the
life of the socket. They are uncharged and limited only by optmem_max:

net/ipv4/tcp_ipv4.c:__tcp_md5_do_add() (TCP_MD5SIG, no capability check):

	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);

net/ipv4/tcp_ao.c:tcp_ao_key_alloc() (called from tcp_ao_add_cmd()):

	key = sock_kmalloc(sk, size, GFP_KERNEL);

net/ipv6/anycast.c:ipv6_sock_ac_join() (needs ns_capable(CAP_NET_ADMIN),
which a user namespace provides):

	pac = sock_kmalloc(sk, sizeof(struct ipv6_ac_socklist), GFP_KERNEL);

net/ipv6/exthdrs.c:ipv6_renew_options() (unprivileged via IPV6_RTHDR, also
HOPOPTS/DSTOPTS; smaller, since each header is at most 8*255 bytes):

	opt2 = sk ? sock_kmalloc(sk, tot_len, GFP_ATOMIC) :
		    kmalloc(tot_len, GFP_ATOMIC);

The anycast record is the twin of the IPv6 multicast membership record that
this patch converts in __ipv6_sock_mc_join().

The TCP_MD5SIG keys alone let an unprivileged TCP socket hold close to
optmem_max (128 KiB by default). That is the same per-socket size as the
IPV6_2292PKTOPTIONS reproducer.

Should these sites be converted too? If not, could the commit message say
why they stay uncharged?

> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index bfa448028f8a1..5fe8736c7b472 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -2381,7 +2381,7 @@ static int __ip_mc_join_group(struct sock *sk, struct ip_mreqn *imr,
>  	err = -ENOBUFS;
>  	if (count >= READ_ONCE(net->ipv4.sysctl_igmp_max_memberships))
>  		goto done;
> -	iml = sock_kmalloc(sk, sizeof(*iml), GFP_KERNEL);
> +	iml = sock_kmalloc(sk, sizeof(*iml), GFP_KERNEL_ACCOUNT);
>  	if (!iml)
>  		goto done;
>  

[Severity: Medium]
The socket record is charged here. What about the per-device group record
that __ip_mc_join_group() creates a few lines later?

	rcu_assign_pointer(inet->mc_list, iml);
	____ip_mc_inc_group(in_dev, addr, mode, GFP_KERNEL);

____ip_mc_inc_group() allocates struct ip_mc_list with:

	im = kzalloc_obj(*im, gfp);

On leave, __ip_mc_dec_group()->igmpv3_add_delrec() creates an IGMPv3 tomb
with:

	pmc = kzalloc_obj(*pmc, gfp);

Neither allocation uses __GFP_ACCOUNT.

The caller picks the group address, so each charged ip_mc_socklist can pin
a separate, larger, uncharged ip_mc_list (timer, lock, refcounts).

In a user+net namespace with igmp_max_memberships raised, a socket could
hold its optmem_max budget in charged records plus several times that in
uncharged ip_mc_list objects. Join/leave churn on an IGMPv3 device also
builds up uncharged tombs.

A later patch in this series, "net: multicast: account group and source
allocations to memcg", charges the IPv6 versions: mca_alloc() for
ifmcaddr6, plus the ip6_sf_list entries and tombs. It also charges the IPv4
ip_sf_list entries and tombs. At the end of the series, though, the IPv4
ip_mc_list and its igmpv3_add_delrec() tombs still seem to be uncharged.

____ip_mc_inc_group() returns void, and __ip_mc_join_group() ignores its
allocation failure, which may be why it was left out. Could one of the
commit messages say so, or should these allocations be charged as well?

[ ... ]

> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index 82573260b7409..89394f8d963f6 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -748,7 +748,7 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>  		if (optlen > 64*1024)
>  			break;
>  
> -		opt = sock_kmalloc(sk, sizeof(*opt) + optlen, GFP_KERNEL);
> +		opt = sock_kmalloc(sk, sizeof(*opt) + optlen, GFP_KERNEL_ACCOUNT);

[Severity: High]
This charges the buffer where setsockopt() first allocates it. Can the same
payload still be copied without any charge?

IPV6_2292PKTOPTIONS can be set on an IPv6 TCP listener; the getsockopt()
side is even limited to SOCK_STREAM. Each child that completes the
handshake then copies the listener's options:

net/ipv6/tcp_ipv6.c:tcp_v6_syn_recv_sock() {
    ...
	opt = ireq->ipv6_opt;
	if (!opt)
		opt = rcu_dereference(np->opt);
	if (opt) {
		opt = ipv6_dup_options(newsk, opt);
		RCU_INIT_POINTER(newnp->opt, opt);
    ...
}

ipv6_dup_options() copies the full tot_len:

net/ipv6/exthdrs.c:ipv6_dup_options() {
    ...
	opt2 = sock_kmemdup(sk, opt, opt->tot_len, GFP_ATOMIC);
    ...
}

That copy uses GFP_ATOMIC with no __GFP_ACCOUNT. It also runs in softirq,
where current_obj_cgroup() would not pick the user's memcg anyway.

sk_clone_lock() also resets the child's budget:

	atomic_set(&newsk->sk_omem_alloc, 0);

so every child passes its own optmem_max check.

With one charged listener and N connections, does this still keep N copies
of up to ~64 KiB each (in ~128 KiB kmalloc_large allocations) outside
memory.max? The copies are held whether the children sit in the accept
queue (up to the backlog) or have been accepted.

MPTCP (net/mptcp/protocol.c) and SCTP (net/sctp/ipv6.c) make the same
uncharged copy.

The copy runs in softirq, so __GFP_ACCOUNT at that call would not charge
the right memcg. Would closing this need a charge against the listener's
memcg instead?

>  		retv = -ENOBUFS;
>  		if (!opt)
>  			break;
> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index 0d982f7d29cda..ede1f0825bad5 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c

[ ... ]

> @@ -435,7 +436,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk,
>  		} else {
>  			newpsl = sock_kmalloc(sk, struct_size(newpsl, sl_addr,
>  							      psl->sl_count - 1),
> -					      GFP_KERNEL);
> +					      GFP_KERNEL_ACCOUNT);
>  			if (!newpsl) {
>  				atomic_add(struct_size(psl, sl_addr, psl->sl_max),
>  					   &sk->sk_omem_alloc);

[Severity: Low]
This is the source-removal (!add) branch of ip6_mc_source(). It is reached
through MCAST_LEAVE_SOURCE_GROUP or MCAST_UNBLOCK_SOURCE when sl_count > 1.
With the charge added here, can an operation that shrinks the socket's
memory now fail?

If the cgroup is at memory.max, the charge can enter memcg reclaim or the
memcg OOM killer. If that cannot make progress, or the task is dying or is
already the OOM victim, sock_kmalloc() returns NULL. The source then stays
in the filter and setsockopt() returns -ENOBUFS. The error path does keep
the filter state consistent.

The IPv4 counterpart, ip_mc_source(), removes the source in place without
allocating:

	for (j = i+1; j < psl->sl_count; j++)
		psl->sl_addr[j-1] = psl->sl_addr[j];
	psl->sl_count--;

Could this allocation stay uncharged? Alternatively, psl could be shrunk in
place the way IPv4 does it.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795102467.git.x-professor%40outlook.com
