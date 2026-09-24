Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076F1400E11
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 09:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790243777; cv=pass; b=L1f0mKJWBtRf2jzL/F3taYQqZdiHoTjxknYCVreIavgFyIdG3zKnuVFmpUVSNLLtW0wf3B5Q7k7lncN3Btm+OPn4kZrYWOPd3ydzSc/tKqJUD0E14kRx0akrhJR2WWWO2jnM/3OhHpm9K5/Gu7lC62I4PlyHUDUeNUyVzSG4ShI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790243777; c=relaxed/simple;
	bh=LBZZcNSVeHHRIpD1xuzWESX6CCgFGvOZ+4ZFnY2ewKU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HnqX1OA+dFKNVGeIt7tf6e3EuX9H2kTDejkXtrjAH6uAkcB8leQC5auJDJm5D20AKgK1kr6XNKidSY5T8KdQ3Fw2GsqV8cKmxd8aPQKJOH/S9aEWsEI65yWJNAjUPBTEx02p3f5yJDVyW5DpR27jRAxuPiVuZYCutt0EqfzSiCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JODW4//u; arc=pass smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JODW4//u"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb769ca02so18538891cf.0
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 02:56:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790243763; cv=none;
        d=google.com; s=arc-20260327;
        b=kZthszNEdDiedDrGZhWy3c5NMcwhHEO9Vf+LuE++qbNY8GIzvj7UOG9ZV5R4nfGCFf
         BjWWx/VP3Uaq4NbH9F4RYRX77qVnL6y+qVrp3+haPmIS1e4/dRqipo5vkLXMA12/pfSQ
         oXCRE2QjbeL3iqG+bKE5N8lXvCw1rsBS6L1NCOCQtXkF7WOcU/OLXb2D3je0EXx/TJIX
         IcbhXfhtKEurj8Ij+n2dDG0GQ/oeKk7JQZnRED1iDXlXeckM+0bkrJ6lCMKL2K1HGzjh
         qn2tUMD42d07Q+ORb8mBsThf4dOVqZD+hMD941rjyqAZy6tRAK9sAVxTooaieSzY/Xsb
         OYUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rM8Pnb3OaTJqlPgDl5Nu230H8PB3TRPyBVd+A2AcpH4=;
        fh=BZmn1h9Tan9vuwAf9BClELEJwOC/2TltKzN/7lvr7V0=;
        b=UJ+3t0yW2PVjYV3d+NhcwjAl0ZMHUH7UiCwFaTz9Ib1M87spSfvcVjw8jj2iABJAzr
         iQBf6B8lZB5ueu9g9sdUr90F7g892RCXVHGhJCvNTpnHOCR2CQ9HGMd+/m0W9zQN6Z6y
         2E7Kx4JZ1Y6S26CDApbB5jghEntPJHIbBmSnWfTzK62omZ7Y3KyGYm3oWai9EcBxoRgk
         Ouk/AFDWanSq8ava851VYP1F9MX05ee6aDqDtxFQt02kX22NrO23P9uI37f56nYpgiFm
         wA3HCgWNHavE7JSFaZip/jT1at8K59Kj0lBBBegGGiwxytljEVDlrXxwrAdEHILwOwum
         vfsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790243763; x=1790848563; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rM8Pnb3OaTJqlPgDl5Nu230H8PB3TRPyBVd+A2AcpH4=;
        b=JODW4//u3KjtFnoafHckYjbn/WXha6Zo9QUiqtgARpc7DjBG0mhE0WWH+hSp6QxsNm
         RfYVeBrlMNaoigggDW6bLYZkB/uWJilNXDFvbdrL36dL+fm5HmpCEUZ60jPpRQYZCPAw
         C/PM4Ypr9TRp0aRT/iAXkY+ck9MM5VKEqtGOKkZwp7Pe0cuc2nCPFuoFVFFfi7IGy3Kt
         k5Fv+L7nfpY1z6MkPu1vtql9PBXlqQ8A130evougp8/k8OVH0GzSToEOXITzEzSv0+0O
         hCpLEC4ltGH4PCVCEyb0S5OvP3NAzgIqZsERBJifrjKchVfuLn2YBZKdazPT5ztVnquF
         CRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790243763; x=1790848563;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rM8Pnb3OaTJqlPgDl5Nu230H8PB3TRPyBVd+A2AcpH4=;
        b=FYzqfcsWgQ6vLMpCKouL+hb7hRmvzsmdlOv4lNu5Esak2xXrDJXY9k+uCFjZEALKmp
         3YrTJ7I0tqhbK7/KbqnNKYzUd8vv76XfPZp697PGV4wrdAthvgKRgGYqBnXJsbNAbAC0
         eI4HqJAmUZuivoxQ/h+HM/0EuGfoTjDBFbIPYQyIdoU2St0BEA9+GePFzx60IceyLc8W
         iAHVQ/10atZOoWCyLb0bNW7syAsamyDUDkMk0liEJbHGBwP1T643hn4PGdCr2D+9xMTF
         o4IJqzHXTCh1tmcOvpGY/Tj1vXOxLDAPlGKZpq83lTMY9+bZpOKK6ehw+XsDduF3MLtt
         sWuw==
X-Forwarded-Encrypted: i=1; AKwUvByW6DAoaXeOlwUBkHuuaF/SfSqRRMFGXoayHsnUV25ES4upkl3bIp/7ItBCqXBEZ+iDPPD2/P/7@vger.kernel.org
X-Gm-Message-State: AFuF++mjVWCt3SDPH+nrIdXdlHgL4UnUbZlJ47IoPDZ5JJ4sr/rdmFwb
	T59x8fbTMWu2q8nC+BoyfidE+APhXOl9pmArL4WwrNinOSOgaKkP58w54EO4+Ft/rQqlXA4keg3
	CIMAg36gOog8QtkP7WY3ZDYRcTWsx597uKxRORyTv
X-Gm-Gg: AYBFou073eb4xBQ2GK97v4u2c8PIglw29Aexi5jpmNawROetvWMIJbE7Vy5n8/Qj/S6
	Llkcf1bWz2OKzkKna477zA30+isNMlBGi21gZitHG1uFR0h2sOf2VUGn+y4P6f+/jxUJ+hnzLpy
	tsiUYJB8pBeO0ne6YSBeduStnBGZqk11oK/SCOU4GgDInx2tWAOWC8E5k7wqIQkPdMdXJrfE/V5
	1Susx+TaVuAk1Q4S6/d0oW9gj6V2uIo4ZenATnpp2IjdOcdPUilq6jvG5IG8ShmXdYyGSErxy69
	QCpq9R5Llmw41nEFTwwWumr5hWm8fwcsy4yCY88Aw8SFJkpoqvY1kQA7OUOOqCGGqbRAOKKhsvd
	jxPK1Gvz2j+M7wC88dpRr+V3lyLPlomBQHcbz1abzVAam8276aE3FwYOcVpmUQQIiHBCK
X-Received: by 2002:a05:622a:5a0f:b0:532:8f15:2744 with SMTP id
 d75a77b69052e-532fea4d150mr14339051cf.20.1790243762050; Thu, 24 Sep 2026
 02:56:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
 <CANn89iJVGmYwQerOixGurH6vw-GtvSAQq6u6zSNZoyZrcEx6Jw@mail.gmail.com> <d8c12b4e-4ff2-4c62-a40d-d67bb4680a0d@huawei.com>
In-Reply-To: <d8c12b4e-4ff2-4c62-a40d-d67bb4680a0d@huawei.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 24 Sep 2026 11:55:50 +0200
X-Gm-Features: AclHuK_LOWvzBhJczhAfbtW30YiVgV1gD1vN5_bi3qPOiAKB6UaaHqyDAfOb9kg
Message-ID: <CANn89iLA55e6evpx__7AUQF45uYAbUHxRtz4rVT=vsKpqBRWkA@mail.gmail.com>
Subject: Re: [PATCH RFC -next 0/5] net: charge socket memory budget to memcg upfront
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, kuniyu@google.com, 
	pabeni@redhat.com, willemb@google.com, davem@davemloft.net, kuba@kernel.org, 
	horms@kernel.org, ncardwell@google.com, matttbe@kernel.org, 
	martineau@kernel.org, geliang@kernel.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 11:25=E2=80=AFAM Cai Xinchen <caixinchen1@huawei.co=
m> wrote:
>
> Hi,
>
> Thank you for the review.
>
> We found that sk_forward_alloc is a plain int updated by a non-atomic
> RMW (sk_forward_alloc_add(), where even the read side is not
> READ_ONCE), and its writers span three unrelated lock domains:
>
>    - socket lock, process context: SO_RESERVE_MEM and TX grants
>       (__sk_mem_schedule(), sk_forced_mem_schedule());
>
>    - receive-queue lock, softirq: UDP RX charges and the
>       udp_rmem_release() fold;
>
>    - no lock at all: sk_mem_charge()/sk_mem_uncharge() from
>       skb_set_owner_r() and skb destructors, and the sk_mem_reclaim()
>       fold itself.
>
> Any cross-domain pair loses an update.  A lost charge is still
> returned in full by the matching skb free, so it resurfaces as a
> phantom surplus in sk_forward_alloc, and the next fold hands it back
> to the memcg via __sk_mem_reduce_allocated() ->
> mem_cgroup_sk_uncharge() - an uncharge with no matching charge.
>
> We first tried to fix it with locks, and hit three walls:
>
>    - the socket lock cannot be used: its holders free skbs (e.g.
>       tcp_recvmsg()), and the destructor's sk_mem_uncharge() would
>       need to re-acquire it - recursion.  That is why these helpers
>       are lockless in the first place;
>
>    - a new per-socket spinlock serializes the RMWs but not the bug:
>       __sk_mem_schedule() publishes the grant before the memcg charge,
>       and the charge may sleep (GFP_KERNEL, memcg reclaim/OOM), so no
>       spinlock can cover both steps; a fold in that window can still
>       refund pages whose charge afterwards fails;
>
>    - such a lock would also sit on the per-packet charge/uncharge
>       paths, exactly the hot path the cacheline layout around
>       sk_forward_alloc was tuned to keep cheap.
>
> Are there any good solutions to solve this problem?

Perfect, you now gave us what we need.

UDP is broken, it should be easy to fix without breaking TCP.

I am surprised your LLM went to a completelly broken path.

sk_forward_alloc is never supposed to be updated locklessly across
multiple lock domains:

- For TCP, sk_forward_alloc is strictly serialized by the socket lock
  (lock_sock / bh_lock_sock). TCP does not use sock_rfree() as an skb
  destructor (sk_mem_uncharge() is called under the socket lock in
  tcp_eat_recv_skb() and sk_wmem_free_skb(), while TX destructors
  sock_wfree() / tcp_wfree() only touch sk_wmem_alloc).

- For UDP, sk_forward_alloc is serialized by sk->sk_receive_queue.lock
  (in __udp_enqueue_schedule_skb() and udp_rmem_release()).

Your reproducer and analysis point to two specific places that violate
these locking rules:

1. SO_RESERVE_MEM on UDP sockets:
   SO_RESERVE_MEM (commit 2bb2f5fb21b0, "net: add new socket option
   SO_RESERVE_MEM") was designed for TCP, where sk_forward_alloc is
   protected by lock_sock(sk) and sk_mem_reclaim() checks
   sk_unused_reserved_mem(sk).

   However, sock_reserve_memory() only checks sk_has_account(sk), which
   also matches UDP. UDP does not support SO_RESERVE_MEM:
   udp_rmem_release() does not check sk_unused_reserved_mem(sk) (so the
   first recv() reclaims the reserved pages from sk_forward_alloc), and
   setsockopt(SO_RESERVE_MEM) only holds lock_sock(sk) instead of
   sk->sk_receive_queue.lock, racing with __udp_enqueue_schedule_skb()
   and udp_rmem_release().

   We can fix this directly in sock_reserve_memory():
diff --git a/net/core/sock.c b/net/core/sock.c
index 1d5927cd49a1..763c2017d9ef 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1034,7 +1034,7 @@ static int sock_reserve_memory(struct sock *sk, int b=
ytes)
  bool charged;
  int pages;

- if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
+ if (!mem_cgroup_sk_enabled(sk) || !sk_is_tcp(sk))
  return -EOPNOTSUPP;

2. BPF sockmap (net/core/skmsg.c):
   As you noted in the reproducer comments, sk_psock_skb_ingress() and
   sk_psock_skb_ingress_self() call sk_rmem_schedule() and
   skb_set_owner_r() (which installs sock_rfree() as skb->destructor)
   from sk_psock_backlog() or after dropping sk_receive_queue.lock in
   udp_read_skb(). Calling skb_set_owner_r() / sock_rfree() without the
   socket lock (or sk_receive_queue.lock for UDP) on protocols with
   sk_has_account(sk) is a bug in net/core/skmsg.c and should be fixed
   there.
