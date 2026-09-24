Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A761C30C606;
	Thu, 24 Sep 2026 07:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235373; cv=none; b=CtWX7GN4MTfzXA6KZdI9CWaiH9HStcqt65dA4jPAwPOfagtb1jeIXFnxfZYMaTIG8CKTPizvukoaGGFhy0cuU/Cw2kfx3JfrX1ZNdZVjCzkM/D4FaLWzswQBPyPqJmiA4dGh4a27L6RqJZcUlYzart+ppYd8nJageXBnwnB22pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235373; c=relaxed/simple;
	bh=QvBZ+KNbf1Sv2iCZKL5yKE7kDkDxi2J2crQOn0o0ii0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nl1UT6O7upSKXcdXn7xJRE/1bis/xrN9JvWrpKGBA83LTusdDG9iHgEcriV4C7hJ9Khpoy1tqdVNtD7DV0Vt4GCf7oIuH7MXIzGCN7wjvc3vkWfEubZIXArfCqzoiLM8Oxmvn/WQ3xXCjq1rJoI8EpgIRpi2epZhWKxffBPHYxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ONhULbsY; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ONhULbsY"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Eix0EmnHlcKPpRL88blWx7dbbcEZ9zSeXbIyhIkBRCg=;
	b=ONhULbsYqqPaOUYOa3JDqZ/SY1mBLmqXQhAASrJE77l3Rsek/yi+TtxaDEQcSnH8v8qzMV3RR
	ot0cD71MFbm5YZfOYMq7Hm3xIOlH1n4V9bMqj5y7GskAeWnQjBrUKzqiAW2EYw+HcTkR06rPwku
	Fdz82nUPyla8BslzzZM10rQ=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hr51V4K6kz1T4Km;
	Thu, 24 Sep 2026 15:24:14 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 60CFB4058C;
	Thu, 24 Sep 2026 15:36:07 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:36:05 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<edumazet@google.com>, <kuniyu@google.com>, <pabeni@redhat.com>,
	<willemb@google.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<horms@kernel.org>, <ncardwell@google.com>, <matttbe@kernel.org>,
	<martineau@kernel.org>, <geliang@kernel.org>, <mhocko@kernel.org>,
	<roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, <muchun.song@linux.dev>
CC: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<mptcp@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <caixinchen1@huawei.com>,
	<lujialin4@huawei.com>
Subject: [PATCH RFC -next 2/5] tcp: sync memcg budget on protocol buffer updates
Date: Thu, 24 Sep 2026 16:02:16 +0800
Message-ID: <20260924080219.1036588-3-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20260924080219.1036588-1-caixinchen1@huawei.com>
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100010.china.huawei.com (7.152.184.41)

TCP rewrites the socket buffers after sock_init_data() already charged
the generic defaults, and keeps rewriting them during autotuning:

  - tcp_init_sock() overrides sk_sndbuf/sk_rcvbuf with the per-net
    tcp_wmem/tcp_rmem sysctl defaults,
  - tcp_set_rcvlowat() raises sk_rcvbuf from the requested rcv window,
  - tcp_sndbuf_expand(), tcp_clamp_window() and tcp_rcvbuf_grow()
    grow the buffers during autotuning, and
  - tcp_should_expand_sndbuf() caps sk_sndbuf under memory pressure.

Sync the memcg budget tracker with sk_memcg_budget_sync() at each of
these writes so the charged amount follows the actual budget: growth
is charged to the memcg, shrink is refunded.

Assisted-by: opencode:glm-5.3
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 net/ipv4/tcp.c       |  5 +++++
 net/ipv4/tcp_input.c | 10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 3c9e1a88a6bd..0d2a39672aa0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -471,6 +471,10 @@ void tcp_init_sock(struct sock *sk)
 
 	WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[1]));
 	WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_rmem[1]));
+	/* The default buffers grew from the generic sock_init_data()
+	 * values: charge the difference to the memcg.
+	 */
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	tcp_scaling_ratio_init(sk);
 
 	set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
@@ -1847,6 +1851,7 @@ int tcp_set_rcvlowat(struct sock *sk, int val)
 	space = tcp_space_from_win(sk, val);
 	if (space > sk->sk_rcvbuf) {
 		WRITE_ONCE(sk->sk_rcvbuf, space);
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
 
 		if (tp->window_clamp && tp->window_clamp < val)
 			WRITE_ONCE(tp->window_clamp, val);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0f60a1dbf927..8abec8ebf916 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -629,9 +629,11 @@ static void tcp_sndbuf_expand(struct sock *sk)
 	sndmem = ca_ops->sndbuf_expand ? ca_ops->sndbuf_expand(sk) : 2;
 	sndmem *= nr_segs * per_mss;
 
-	if (sk->sk_sndbuf < sndmem)
+	if (sk->sk_sndbuf < sndmem) {
 		WRITE_ONCE(sk->sk_sndbuf,
 			   min(sndmem, READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_wmem[2])));
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
+	}
 }
 
 /* 2. Tuning advertised window (window_clamp, rcv_ssthresh)
@@ -791,6 +793,7 @@ static void tcp_clamp_window(struct sock *sk)
 	    sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)) {
 		WRITE_ONCE(sk->sk_rcvbuf,
 			   min(atomic_read(&sk->sk_rmem_alloc), rmem2));
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	}
 	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
 		tp->rcv_ssthresh = min(tp->window_clamp, 2U * tp->advmss);
@@ -948,6 +951,7 @@ void tcp_rcvbuf_grow(struct sock *sk, u32 newval)
 	rcvbuf = min_t(u32, tcp_space_from_win(sk, rcvwin), cap);
 	if (rcvbuf > sk->sk_rcvbuf) {
 		WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
 		/* Make the window clamp follow along.  */
 		WRITE_ONCE(tp->window_clamp,
 			   tcp_win_from_space(sk, rcvbuf));
@@ -6055,8 +6059,10 @@ static bool tcp_should_expand_sndbuf(struct sock *sk)
 		 * it never goes below SOCK_MIN_SNDBUF.
 		 * See sk_stream_moderate_sndbuf() for more details.
 		 */
-		if (unused_mem > SOCK_MIN_SNDBUF)
+		if (unused_mem > SOCK_MIN_SNDBUF) {
 			WRITE_ONCE(sk->sk_sndbuf, unused_mem);
+			sk_memcg_budget_sync(sk, gfp_memcg_charge());
+		}
 
 		return false;
 	}
-- 
2.18.0.huawei.25

