Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795451048;
	b=3HIEPmZ08aFoBNAQpA+N2TpU3D3cmAaK3mQKlR84C6XN4aeZ8otQByUIIquLYVw7ECFB
	 +3jcAODQvy/ti/HPUd6S4/L5Uk/qt9qOUVOKXZOvHlP3mFhaUfwKx94Rwb6pqrV5hFlZN
	 AmZOmABJfkx/ObDoedfw3sCllMIE7fr0pu/wkyA1ObM5xxtRxSivpr4VGcKqZ1OZNL9+K
	 wMg8ttTXXluPfr91BC+yh/zuZ5vkHotweJnHC4uD3qcH0Vms86H8D3KcIqOqr3hl2Bcy9
	 HoBUNSDtqeOWxdGTJ+3ct3WhSo0b4tzFQcOTo/pJWs0pvf8iJg0kOM53Vx9tNYB3nMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795451048;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=QZXIFYILtCNn6BOcPijM59Qx4+riXxSWUomOV63QZGA=;
	b=dUT50/IhdrpV61+mfp6tQn9M/0qkVPsb5j7FfJ1ZHA6J5XztIqsXWwk94+OrpjZQB8/f
	 S4rW9/5i9J/gEtdjddO5J2l0FgOmb9jPOzZ1Fkai35Ba33T1tWC2Fqt2qVMNr8irKxbhl
	 olaeV5FjVFkwMN6f0IBM12kNsOfBBwQNBeY1YjVrojwIITKUk+A5oo+sRIJrEQBBqO4X8
	 S0PWP6hLN1QmkOzgljAJJV1CQNtyU4Ki8WPqhhGR40ht4p7r/n4ELWNDn9BnU0vLM13l4
	 LoqRaxanKoPl/cRG01vWgxlRmlcLLtnhHS96oq52D7tEP/yhqHV4Pa0hwfnvKC0OVWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XGRrDED2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8897C606A332;
	Mon, 23 Nov 2026 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XGRrDED2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C8E1F0089E;
	Mon, 23 Nov 2026 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795451048;
	bh=QZXIFYILtCNn6BOcPijM59Qx4+riXxSWUomOV63QZGA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XGRrDED2jEpYvgE50oiY8fPCgtnMvmLiEjkzS9FnyjwWlK9puHJ6oI7nelee/TFeD
	 lS1P04iIZVUe4XuZ6aRXAsvEiMnq4K4BOVyDge/J9mFHykpnlc6oIgtBnDp/j/fiZh
	 quzGh29ASYGTa7s1f3UQwns13EGVLZ4dveF31N4N07R3HzQjlxL2KuI+vVfxJ9VJ/+
	 1dPbAxOVEL9ztnZEgWbcj5zeFbf7zg5vZVytEaiT4OAqAu5/YHjMMhuHwykzZb+22g
	 H6OMZuUYsYWivzO6wTf7DtreT/FA6O83v58iowhWEzhtkThRU8EzfIcAF7d9G01N67
	 rySgow1eEa+KQ==
Subject: Re: [PATCH net 3/3] net: multicast: account group and source
 allocations to memcg
From: netdev-bot+sashiko@kernel.org
To: x-professor@outlook.com
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Nov 2026 16:24:06 +0000
Message-ID: <179545104659.3135.11573235607470978138@kernel.org>
In-Reply-To: <eabf67fe94dc239f6cc59720e8468f2bf9b4cd62.1795102467.git.x-professor@outlook.com>
References: <eabf67fe94dc239f6cc59720e8468f2bf9b4cd62.1795102467.git.x-professor@outlook.com>
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The fix leaves the IPv4 device group records uncharged, even
  though their IPv6 counterparts are now charged.
- [Medium] Several IPv6 allocations whose failure is always silently
  ignored now use GFP_KERNEL_ACCOUNT, so they can fail on memcg charge…

--

net: multicast: account group and source allocations to memcg

This commit adds memcg accounting to the IPv4 and IPv6 multicast source
filter entries and their tomb records. It also accounts the IPv6 live and
deleted device group records. IPv4 keeps GFP_ATOMIC and adds __GFP_ACCOUNT,
IPv6 switches to GFP_KERNEL_ACCOUNT, and a gfp parameter is passed through
__ipv6_dev_mc_inc() and mca_alloc() so that only socket joins charge the
live IPv6 group.

> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index ede1f0825bad5..e7afe61871132 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c

[ ... ]

> @@ -232,7 +233,7 @@ static int __ipv6_sock_mc_join(struct sock *sk, int ifindex,
>  	RCU_INIT_POINTER(mc_lst->sflist, NULL);
>  
>  	/* now add/increase the group membership on the device */
> -	err = __ipv6_dev_mc_inc(dev, addr, mode);
> +	err = __ipv6_dev_mc_inc(dev, addr, mode, GFP_KERNEL_ACCOUNT);
>  
>  	dev_put(dev);
>  

[Severity: High]
The IPv6 socket join now charges the live ifmcaddr6 group record. What
about the IPv4 equivalents?

__ip_mc_join_group() in net/ipv4/igmp.c still creates the live ip_mc_list
without accounting:

net/ipv4/igmp.c:__ip_mc_join_group() {
    ...
	rcu_assign_pointer(inet->mc_list, iml);
	____ip_mc_inc_group(in_dev, addr, mode, GFP_KERNEL);
    ...
}

____ip_mc_inc_group() then allocates the record with
kzalloc_obj(*im, gfp).

The IPv4 deleted group record is also left uncharged. On leave or close
the chain is:

ip_mc_leave_group() / ip_mc_drop_socket()
  ip_mc_dec_group()
    igmp_group_dropped()
      __igmp_group_dropped(im, GFP_KERNEL)
        igmpv3_add_delrec(in_dev, im, gfp)
          pmc = kzalloc_obj(*pmc, gfp);

Its IPv6 counterpart, mld_add_delrec(), is switched to GFP_KERNEL_ACCOUNT
by this patch.

These tomb records stay on in_dev->mc_tomb until crcount counts down
through IGMPv3 interface-change reports. crcount comes from in_dev->mr_qrv
or the per-netns igmp_qrv sysctl. igmp_max_memberships does not limit
these records.

Could a user namespace root in its own netns raise igmp_qrv and the report
interval, and then join and leave distinct groups in a loop? That would
pile up uncharged ip_mc_list records in the same way as the delayed MLD
join/leave reproducer in the commit message, which this patch fixes only
for IPv6.

The commit message gives this reason for charging the IPv6 join:

  "socket joins already propagate allocation failure to the caller"

That is not true for IPv4, since ____ip_mc_inc_group() returns void. It
might explain leaving out the IPv4 live group. It does not explain leaving
out the deleted record, because igmpv3_add_delrec() already ignores
allocation failure the same way mld_add_delrec() does.

Should the IPv4 group records be charged too? For example, an accounted
gfp could be passed to igmpv3_add_delrec() on socket paths, and the IPv4
join could either propagate the failure or force the charge. If they are
left out on purpose, could the commit message say why?

> @@ -770,7 +771,7 @@ static void mld_add_delrec(struct inet6_dev *idev, struct ifmcaddr6 *im)
>  	 * for deleted items allows change reports to use common code with
>  	 * non-deleted or query-response MCA's.
>  	 */
> -	pmc = kzalloc_obj(*pmc);
> +	pmc = kzalloc_obj(*pmc, GFP_KERNEL_ACCOUNT);
>  	if (!pmc)
>  		return;
>  

[Severity: Medium]
With GFP_KERNEL_ACCOUNT, can this allocation now fail when the memcg
charge fails?

For requests without __GFP_HIGH or __GFP_NOFAIL, try_charge_memcg()
returns -ENOMEM in several cases:

  - the current task is an OOM victim with MMF_OOM_SKIP
  - passed_oom && task_is_dying()
  - mem_cgroup_oom() makes no progress

The relevant check is:

mm/memcontrol.c:try_charge_memcg() {
    ...
	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
		ret = -ENOMEM;
		goto out;
	}
    ...
}

mld_add_delrec() returns void and just returns when the allocation fails.
In that case no deleted group record is created, and the MLDv2 leave
state-change report is never sent.

A typical case is an OOM-killed task in a memcg that exits and closes its
multicast sockets:

ipv6_sock_mc_close() / __ipv6_sock_mc_drop()
  __ipv6_dev_mc_dec()
    igmp6_group_dropped()
      igmp6_leave_group()
        mld_add_delrec()
          kzalloc_obj(*pmc, GFP_KERNEL_ACCOUNT) returns NULL

The tomb allocations this patch changes in ip6_mc_del1_src() and
sf_setstate() look similar.

In ip6_mc_del1_src(), when dpsf is NULL, psf is still unlinked and freed
with rv = 0, so the source removal is never announced.

In sf_setstate(), this check drops the record:

	if (!dpsf)
		continue;

The IPv4 tomb conversions avoid this, because GFP_ATOMIC includes
__GFP_HIGH and the charge is forced.

mld_add_delrec() also hardcodes GFP_KERNEL_ACCOUNT, but non-socket callers
reach it through igmp6_group_dropped(). Examples are __ipv6_dev_mc_dec()
called from addrconf, ndisc and the bridge, as well as ipv6_mc_down() and
ipv6_mc_unmap(). On those paths, isn't the deleted record charged to
whichever task happens to trigger the operation?

That seems to conflict with the commit message, which keeps GFP_KERNEL
for:

  "ipv6_dev_mc_inc() callers such as address configuration, which may
  ignore allocation failure"

It also says:

  "A group created by address configuration stays uncharged"

Would it make sense for callers to pass a gfp into mld_add_delrec(), as
igmpv3_add_delrec() already takes one on the IPv4 side?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795102467.git.x-professor%40outlook.com
