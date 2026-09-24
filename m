Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A5C438029;
	Thu, 24 Sep 2026 07:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235376; cv=none; b=UEG5i+ebLAhn+lztNGkmjpOiCROAfhNtfN/jjISh4qEQh/160waiRs5vfJ46O8C7Tm3Uawby4n7xDxUxjbKW5TQqMlZ7FM8dEcg05n3A+msi27GDNNcdii3Y/wqUV6OJ/vGKPApH4t/pQukASZqGtbdx67P07Sl7h9sm5qYDyc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235376; c=relaxed/simple;
	bh=WcUZT6MJnXXh5Y8059u0tZ20ti7YIPoWbnJdF3kDNpA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARZAtfjU0Fx0XVRhMT3PdU9h8HQMM2tV/uOSx6PBi8GRMwpB9kSzMamJ3pPBZaOcu6/EC16kU+XlJFWqFHf3DvcYB2o5Zh8aGDoPZqCJUxgQ21jcOpZuL7cEujg1KpndK6tLpxQGJRvmuylHMOIQLWhlNZX5bB3AdsrixCVh+3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=LY0tlaSG; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="LY0tlaSG"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Qi10NZuM2ME+TiMv17luLNhhaTKggBnB0E+h6d1MjY0=;
	b=LY0tlaSGYXvws1q0otD8BVANdrb8tYDMX5CLx6AqJzXm845gKIzsFfieImadi4CdDjFO18Go7
	DCieD1D2RCvirKiWZnjxc/3oLLajb5rQ8SgoVhxn7JBdI1kR+pbNEJHsnopJCvqlyzuDvDQi49d
	s8fZ/UlG0tfCUIN3hsVZVfw=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hr51J460DzLlX8;
	Thu, 24 Sep 2026 15:24:04 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 83D4940565;
	Thu, 24 Sep 2026 15:36:10 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:36:08 +0800
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
Subject: [PATCH RFC -next 3/5] mptcp: sync memcg budget and drop backlog page compensation
Date: Thu, 24 Sep 2026 16:02:17 +0800
Message-ID: <20260924080219.1036588-4-caixinchen1@huawei.com>
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

Sync the memcg budget tracker at the MPTCP budget writes:
mptcp_init_sock() (per-net rcvbuf default), mptcp_rcvbuf_grow(),
__mptcp_sync_sndbuf(), __mptcp_subflow_set_rcvbuf() and
mptcp_set_rcvlowat() (both on the msk and on each subflow).

__mptcp_inherit_memcg() moves a subflow to the msk's memcg: refund the
budget the subflow still holds in the old memcg with
sk_memcg_budget_release() before the switch; the new memcg side
re-charges it through __sk_charge().

With budgets charged upfront, the pages an MPTCP socket spooled into
its backlog before being accepted are covered by the full budget that
__sk_charge() charges at accept time, so the old per-page compensation
in mptcp_graft_subflows() (fed by mptcp_sock->backlog_unaccounted)
would now double-charge.  Remove the counter, its accumulation in
__mptcp_add_backlog() and the compensation charge.

Assisted-by: opencode:glm-5.3
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 net/mptcp/protocol.c | 42 ++++++------------------------------------
 net/mptcp/protocol.h |  2 +-
 net/mptcp/sockopt.c  |  3 +++
 net/mptcp/subflow.c  |  5 +++++
 4 files changed, 15 insertions(+), 37 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0098e2830931..3c8b885d8298 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -238,6 +238,7 @@ static bool mptcp_rcvbuf_grow(struct sock *sk, u32 newval)
 	rcvbuf = min_t(u32, mptcp_space_from_win(sk, rcvwin), cap);
 	if (rcvbuf > sk->sk_rcvbuf) {
 		WRITE_ONCE(sk->sk_rcvbuf, rcvbuf);
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
 		return true;
 	}
 	return false;
@@ -791,12 +792,6 @@ static void __mptcp_add_backlog(struct sock *sk,
 
 account:
 	WRITE_ONCE(msk->backlog_len, msk->backlog_len + delta);
-
-	/* Possibly not accept()ed yet, keep track of memory not CG
-	 * accounted, mptcp_graft_subflows() will handle it.
-	 */
-	if (!mem_cgroup_from_sk(ssk))
-		msk->backlog_unaccounted += delta;
 }
 
 static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
@@ -2315,12 +2310,6 @@ static bool mptcp_can_spool_backlog(struct sock *sk, struct list_head *skbs)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	/* After CG initialization, subflows should never add skb before
-	 * gaining the CG themself.
-	 */
-	DEBUG_NET_WARN_ON_ONCE(msk->backlog_unaccounted && sk->sk_socket &&
-			       mem_cgroup_from_sk(sk));
-
 	if (list_empty(&msk->backlog_list))
 		return false;
 
@@ -3252,6 +3241,10 @@ static int mptcp_init_sock(struct sock *sk)
 	sk_sockets_allocated_inc(sk);
 	sk->sk_rcvbuf = READ_ONCE(net->ipv4.sysctl_tcp_rmem[1]);
 	sk->sk_sndbuf = READ_ONCE(net->ipv4.sysctl_tcp_wmem[1]);
+	/* The default buffers grew from the generic sock_init_data()
+	 * values: charge the difference to the memcg.
+	 */
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	sk->sk_write_space = sk_stream_write_space;
 
 	return 0;
@@ -4329,10 +4322,7 @@ static void mptcp_graft_subflows(struct sock *sk)
 		LIST_HEAD(join_list);
 
 		/* Subflows joining after __inet_accept() will get the
-		 * mem CG properly initialized at mptcp_finish_join() time,
-		 * but subflows pending in join_list need explicit
-		 * initialization before flushing `backlog_unaccounted`
-		 * or MPTCP can later unexpectedly observe unaccounted memory.
+		 * mem CG properly initialized at mptcp_finish_join() time.
 		 */
 		mptcp_data_lock(sk);
 		list_splice_init(&msk->join_list, &join_list);
@@ -4361,26 +4351,6 @@ static void mptcp_graft_subflows(struct sock *sk)
 unlock:
 		release_sock(ssk);
 	}
-
-	if (mem_cgroup_sk_enabled(sk)) {
-		gfp_t gfp = GFP_KERNEL | __GFP_NOFAIL;
-		int amt;
-
-		/* Account the backlog memory; prior accept() is aware of
-		 * fwd and rmem only.
-		 */
-		mptcp_data_lock(sk);
-		amt = sk_mem_pages(sk->sk_forward_alloc +
-				   msk->backlog_unaccounted +
-				   atomic_read(&sk->sk_rmem_alloc)) -
-		      sk_mem_pages(sk->sk_forward_alloc +
-				   atomic_read(&sk->sk_rmem_alloc));
-		msk->backlog_unaccounted = 0;
-		mptcp_data_unlock(sk);
-
-		if (amt)
-			mem_cgroup_sk_charge(sk, amt, gfp);
-	}
 }
 
 static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2b4c27426477..aa34be38cf14 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -377,7 +377,6 @@ struct mptcp_sock {
 
 	struct list_head backlog_list;	/* protected by the data lock */
 	u32		backlog_len;
-	u32		backlog_unaccounted;
 };
 
 #define mptcp_data_lock(sk) spin_lock_bh(&(sk)->sk_lock.slock)
@@ -1040,6 +1039,7 @@ static inline void __mptcp_sync_sndbuf(struct sock *sk)
 
 	/* the msk max wmem limit is <nr_subflows> * tcp wmem[2] */
 	WRITE_ONCE(sk->sk_sndbuf, new_sndbuf);
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	mptcp_write_space(sk);
 }
 
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index fcf6feb2a9eb..05d9dafa8c07 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -70,6 +70,7 @@ static int mptcp_get_int_option(struct mptcp_sock *msk, sockptr_t optval,
 static void __mptcp_subflow_set_rcvbuf(struct sock *ssk, int val)
 {
 	WRITE_ONCE(ssk->sk_rcvbuf, val);
+	sk_memcg_budget_sync(ssk, gfp_memcg_charge());
 	tcp_set_rcvbuf(ssk, val);
 }
 
@@ -1656,12 +1657,14 @@ int mptcp_set_rcvlowat(struct sock *sk, int val)
 
 	/* propagate the rcvbuf changes to all the subflows */
 	WRITE_ONCE(sk->sk_rcvbuf, space);
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	mptcp_for_each_subflow(mptcp_sk(sk), subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 		bool slow;
 
 		slow = lock_sock_fast(ssk);
 		WRITE_ONCE(ssk->sk_rcvbuf, space);
+		sk_memcg_budget_sync(ssk, gfp_memcg_charge());
 		WRITE_ONCE(tcp_sk(ssk)->window_clamp, val);
 		unlock_sock_fast(ssk, slow);
 	}
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 01db7edce18a..817a98b5f40f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1731,6 +1731,11 @@ void __mptcp_inherit_memcg(struct sock *sk, struct sock *ssk, gfp_t gfp)
 	if (!mem_cgroup_sockets_enabled || !sk->sk_socket)
 		return;
 
+	/* The subflow's budget charge went to its previous memcg: return
+	 * it before the memcg association moves to the msk's one, the
+	 * __sk_charge() below re-charges the budget there.
+	 */
+	sk_memcg_budget_release(ssk);
 	mem_cgroup_sk_inherit(sk, ssk);
 	__sk_charge(ssk, gfp);
 }
-- 
2.18.0.huawei.25

