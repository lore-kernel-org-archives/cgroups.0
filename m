Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB69425CF5;
	Thu, 24 Sep 2026 07:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790235371; cv=none; b=C0e7g/wGP4WGWloylKJcFmXwjUMXcJwNTXh/5cx6Fb/Rgg+SVnO/tN0S3OI1dCwpkbsVruT2ryuOEeg3BB7bjMG4gftPMHiJE4BeuPl2MrNRq15zUtGjgamxa/yXTGQLgsDfbufcOlgBwIN3yujxYKsS06oJpx+MNkL0N3d3NGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790235371; c=relaxed/simple;
	bh=qLMuBNDv/svf+MiW5d7OvRC3JAJu/KsobwYEPuU9GKw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EMIudCESPAAhJvI0Ll7aXIEpuoEKMK4/JCQ31tcoFBs7/J8+3uOTNUW65WAmrI/bDOu2S9AjkH80Ek+wGI5WYKIvqzW7uXUDfRVoojKR3s+9yu+DxacU+BZwiWVST2tXfGIZBUNgxQAu8ZdygH9m8joV33BxS7OnGU7WCpvlumc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=3MHOaEjX; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="3MHOaEjX"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=u7DT9d0o2PJbDVblTMIhdGCmIjcogXOH+bce+7uHYoc=;
	b=3MHOaEjXwApnCXjTQr9sd8oV7q4dPnaLTKAG1dKNGeDzIrP7QU8pLU8EqMrs+h1YjDn1SpsFA
	RDi+6jdV0+D/zGnTOnRZzqyHEA7PlvzBzbH1/9ja/bIVpF+budAQZVoJlq7YqTecWc83PMEuUf9
	hmBZhFs60IVxgSBJI/iy+Zg=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hr5193ZJ3z12LHt;
	Thu, 24 Sep 2026 15:23:57 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C6204057D;
	Thu, 24 Sep 2026 15:36:03 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 15:36:00 +0800
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
Subject: [PATCH RFC -next 1/5] net: charge socket memory budget to memcg upfront
Date: Thu, 24 Sep 2026 16:02:15 +0800
Message-ID: <20260924080219.1036588-2-caixinchen1@huawei.com>
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

Socket memory is currently charged to the memory cgroup per grant:
__sk_mem_schedule() charges pages when it publishes forward allocation
and the matching refunds are issued later from skb destructors via
sk_mem_reclaim()/udp_rmem_release().  The refund side has to fold
per-skb "was this charged to the memcg" snapshots back into the socket
balance under concurrent lockless RMW, and races there can drive the
memcg socket balance negative, ending with:

    page_counter underflow
    WARNING: ... mm/page_counter.c ... page_counter_cancel()

Rebalance the model: charge the socket's whole memory budget
(sk_sndbuf + sk_rcvbuf + sk_reserved_mem, i.e. everything
sk_forward_alloc can possibly hand out) to the socket's memcg when the
budget is established or grows, and refund it when the budget shrinks
or the socket is destroyed.  Grants and per-skb charge/uncharge no
longer touch the memcg at all, so the racy refund pairing simply has
no code left to go wrong.  Global protocol accounting
(memory_allocated, tcp_mem pressure) is untouched.

A new sock field, sk_memcg_budget, tracks the amount currently
charged and upholds the invariant "every charged page is accounted in
the tracker exactly once, and every tracker page is refundable exactly
once":

  - growth charges first and only publishes after the charge succeeded
    (a failed charge merely under-accounts; the socket operation still
    succeeds and a later budget event retries the full delta),
  - shrink claims the excess under sk_memcg_budget_lock and refunds
    only the confirmed excess,
  - sk_memcg_budget_release() zeroes the tracker under the lock for
    the final refund in __sk_destruct(), and
  - sk_mem_reclaim() runs a lazy shrink-only sync (via
    sk_memcg_budget_shrink(), which claims the excess under the lock)
    so budget shrinks performed by writers
    without an explicit hook are still refunded; unhooked growth
    merely under-accounts.

sk_memcg_budget_lock is a leaf lock taken with _bh (the release runs
from RCU callbacks); the memcg charge and uncharge run outside of it
because they may sleep (memcg reclaim). Concurrent growths can
transiently over-count (the next shrink refunds the excess) but
refunds can never exceed charges, so the memcg balance cannot
underflow.

Budget charge points hooked here: sock_init_data(),
SO_SNDBUF/SO_SNDBUFFORCE and SO_RCVBUF/SO_RCVBUFFORCE, SO_RESERVE_MEM
(the reservation now folds into the budget tracker), sk_clone()
(children start with a zero tracker), __sk_charge() (accepted sockets
charge their full budget instead of the pre-accept queue pages) and
__sk_destruct().  The memcg charge in sk_forced_mem_schedule() is
dropped accordingly, and sk_stream_moderate_sndbuf() propagates its
pressure shrink to the tracker.

Charging the budget instead of in-flight pages is also the more
accurate accounting: once sk_sndbuf/sk_rcvbuf/sk_reserved_mem are
established, that memory is effectively allocated to the socket.
The protocol fills the buffers on demand without asking again, and
no other socket in the cgroup can spend that capacity, so the
memcg "sock" counter now reports memory the sockets already own
rather than memory that happens to be in flight at the sampling
instant.  This is the same model vm_committed_as uses for the
address space a process claims at mmap() time and hugetlb uses for
reservations, which are charged at creation rather than at first
touch; the visible consequence is that an idle socket holds its
full budget charged for its lifetime.

Assisted-by: opencode:glm-5.3
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 include/net/sock.h |  21 ++++
 net/core/sock.c    | 237 ++++++++++++++++++++++++++++++++++++---------
 net/ipv4/tcp.c     |   6 +-
 3 files changed, 215 insertions(+), 49 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 51185222aac2..c6c6294817d1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -458,6 +458,15 @@ struct sock {
 	__cacheline_group_begin(sock_read_rxtx);
 	int			sk_err;
 	struct socket		*sk_socket;
+	/* Pages of the socket's memory budget (sndbuf + rcvbuf +
+	 * SO_RESERVE_MEM) currently charged to the memcg. Paired with
+	 * every mem_cgroup_sk_charge()/mem_cgroup_sk_uncharge() done on
+	 * behalf of this socket, so it can be refunded exactly once.
+	 * Guarded by sk_memcg_budget_lock; the charge/uncharge run
+	 * outside the lock (they may sleep/reclaim).
+	 */
+	int			sk_memcg_budget;
+	spinlock_t		sk_memcg_budget_lock;
 #ifdef CONFIG_MEMCG
 	struct mem_cgroup	*sk_memcg;
 #endif
@@ -1553,6 +1562,9 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind);
 int __sk_mem_schedule(struct sock *sk, int size, int kind);
 void __sk_mem_reduce_allocated(struct sock *sk, int amount);
 void __sk_mem_reclaim(struct sock *sk, int amount);
+bool sk_memcg_budget_sync(struct sock *sk, gfp_t gfp);
+void sk_memcg_budget_shrink(struct sock *sk);
+void sk_memcg_budget_release(struct sock *sk);
 
 #define SK_MEM_SEND	0
 #define SK_MEM_RECV	1
@@ -1622,6 +1634,12 @@ static inline void sk_mem_reclaim(struct sock *sk)
 	if (!sk_has_account(sk))
 		return;
 
+	/* Return the part of the memcg budget charge that a budget
+	 * shrink (by any writer) no longer backs. Never charges, so
+	 * it is safe to call locklessly from skb destructors.
+	 */
+	sk_memcg_budget_shrink(sk);
+
 	reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
 
 	if (reclaimable >= (int)PAGE_SIZE)
@@ -2638,6 +2656,9 @@ static inline void sk_stream_moderate_sndbuf(struct sock *sk)
 	val = max_t(u32, val, sk_unused_reserved_mem(sk));
 
 	WRITE_ONCE(sk->sk_sndbuf, max_t(u32, val, SOCK_MIN_SNDBUF));
+
+	/* The sndbuf shrink released part of the memcg budget charge. */
+	sk_memcg_budget_shrink(sk);
 }
 
 /**
diff --git a/net/core/sock.c b/net/core/sock.c
index 1d5927cd49a1..d7bdb8bae3ad 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -985,6 +985,9 @@ static void __sock_set_rcvbuf(struct sock *sk, int val)
 	 */
 	WRITE_ONCE(sk->sk_rcvbuf, max_t(int, val * 2, SOCK_MIN_RCVBUF));
 
+	/* Charge the new budget to the memcg (or refund the released one). */
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
+
 	if (sock) {
 		const struct proto_ops *ops = READ_ONCE(sock->ops);
 
@@ -1025,12 +1028,13 @@ static void sock_release_reserved_memory(struct sock *sk, int bytes)
 	WARN_ON(bytes > sk->sk_reserved_mem);
 	WRITE_ONCE(sk->sk_reserved_mem, sk->sk_reserved_mem - bytes);
 	sk_mem_reclaim(sk);
+	/* The released reservation shrank the memcg budget charge. */
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 }
 
 static int sock_reserve_memory(struct sock *sk, int bytes)
 {
 	long allocated;
-	bool charged;
 	int pages;
 
 	if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
@@ -1041,12 +1045,6 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 
 	pages = sk_mem_pages(bytes);
 
-	/* pre-charge to memcg */
-	charged = mem_cgroup_sk_charge(sk, pages,
-				       GFP_KERNEL | __GFP_RETRY_MAYFAIL);
-	if (!charged)
-		return -ENOMEM;
-
 	if (sk->sk_bypass_prot_mem)
 		goto success;
 
@@ -1059,16 +1057,29 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 	 */
 	if (allocated > sk_prot_mem_limits(sk, 1)) {
 		sk_memory_allocated_sub(sk, pages);
-		mem_cgroup_sk_uncharge(sk, pages);
 		return -ENOMEM;
 	}
 
 success:
-	sk_forward_alloc_add(sk, pages << PAGE_SHIFT);
-
+	/* The reservation joins the socket budget, so publish it before
+	 * syncing the memcg charge and roll it back if the sync fails.
+	 * The forward_alloc credit is committed last, after all fallible
+	 * steps: softirq reclaim may fold it back into the protocol
+	 * counter, and that cannot be rolled back.
+	 */
 	WRITE_ONCE(sk->sk_reserved_mem,
 		   sk->sk_reserved_mem + (pages << PAGE_SHIFT));
 
+	if (!sk_memcg_budget_sync(sk, GFP_KERNEL | __GFP_RETRY_MAYFAIL)) {
+		WRITE_ONCE(sk->sk_reserved_mem,
+			   sk->sk_reserved_mem - (pages << PAGE_SHIFT));
+		if (!sk->sk_bypass_prot_mem)
+			sk_memory_allocated_sub(sk, pages);
+		return -ENOMEM;
+	}
+
+	sk_forward_alloc_add(sk, pages << PAGE_SHIFT);
+
 	return 0;
 }
 
@@ -1348,6 +1359,10 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 		WRITE_ONCE(sk->sk_sndbuf,
 			   max_t(int, val * 2, SOCK_MIN_SNDBUF));
+		/* Charge the new budget to the memcg (or refund the
+		 * released one).
+		 */
+		sk_memcg_budget_sync(sk, gfp_memcg_charge());
 		/* Wake up sending tasks if we upped the value. */
 		sk->sk_write_space(sk);
 		break;
@@ -2318,6 +2333,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 
 		sk->sk_kern_sock = kern;
 		sock_lock_init(sk);
+		spin_lock_init(&sk->sk_memcg_budget_lock);
 
 		sk->sk_net_refcnt = kern ? 0 : 1;
 		if (likely(sk->sk_net_refcnt)) {
@@ -2355,6 +2371,12 @@ static void __sk_destruct(struct rcu_head *head)
 	if (sk->sk_destruct)
 		sk->sk_destruct(sk);
 
+	/* All queues are purged and no reference is left: return the
+	 * remaining memcg budget charge exactly once, before the memcg
+	 * association is dropped by sk_prot_free() below.
+	 */
+	sk_memcg_budget_release(sk);
+
 	filter = rcu_dereference_check(sk->sk_filter,
 				       refcount_read(&sk->sk_wmem_alloc) == 0);
 	if (filter) {
@@ -2534,6 +2556,12 @@ struct sock *sk_clone(const struct sock *sk, const gfp_t priority,
 	newsk->sk_wmem_queued	= 0;
 	newsk->sk_forward_alloc = 0;
 	newsk->sk_reserved_mem  = 0;
+	/* The child has not charged anything to the memcg yet: it will be
+	 * charged for its budget at accept() time (__sk_charge()).
+	 * sock_copy() copied the parent's lock bytes: re-init the lock.
+	 */
+	newsk->sk_memcg_budget = 0;
+	spin_lock_init(&newsk->sk_memcg_budget_lock);
 	DEBUG_NET_WARN_ON_ONCE(newsk->sk_drop_counters);
 	sk_drops_reset(newsk);
 	newsk->sk_send_head	= NULL;
@@ -3327,15 +3355,12 @@ EXPORT_SYMBOL(sk_wait_data);
  *
  *	Similar to __sk_mem_schedule(), but does not update sk_forward_alloc.
  *
- *	Unlike the globally shared limits among the sockets under same protocol,
- *	consuming the budget of a memcg won't have direct effect on other ones.
- *	So be optimistic about memcg's tolerance, and leave the callers to decide
- *	whether or not to raise allocated through sk_under_memory_pressure() or
- *	its variants.
+ *	Charges the global protocol counter only. The memcg is charged for
+ *	the socket's full memory budget when that budget is established or
+ *	resized (see sk_memcg_budget_sync()), not per allocation.
  */
 int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
-	bool memcg_enabled = false, charged = false;
 	struct proto *prot = sk->sk_prot;
 	long allocated = 0;
 
@@ -3344,13 +3369,6 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		allocated = sk_memory_allocated(sk);
 	}
 
-	if (mem_cgroup_sk_enabled(sk)) {
-		memcg_enabled = true;
-		charged = mem_cgroup_sk_charge(sk, amt, gfp_memcg_charge());
-		if (!charged)
-			goto suppress_allocation;
-	}
-
 	if (!allocated)
 		return 1;
 
@@ -3421,13 +3439,8 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		/* Fail only if socket is _under_ its sndbuf.
 		 * In this case we cannot block, so that we have to fail.
 		 */
-		if (sk->sk_wmem_queued + size >= sk->sk_sndbuf) {
-			/* Force charge with __GFP_NOFAIL */
-			if (memcg_enabled && !charged)
-				mem_cgroup_sk_charge(sk, amt,
-						     gfp_memcg_charge() | __GFP_NOFAIL);
+		if (sk->sk_wmem_queued + size >= sk->sk_sndbuf)
 			return 1;
-		}
 	}
 
 	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
@@ -3435,9 +3448,6 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	if (allocated)
 		sk_memory_allocated_sub(sk, amt);
 
-	if (charged)
-		mem_cgroup_sk_uncharge(sk, amt);
-
 	return 0;
 }
 
@@ -3468,13 +3478,12 @@ EXPORT_SYMBOL(__sk_mem_schedule);
  *	@sk: socket
  *	@amount: number of quanta
  *
- *	Similar to __sk_mem_reclaim(), but does not update sk_forward_alloc
+ *	Similar to __sk_mem_reclaim(), but does not update sk_forward_alloc.
+ *	Only returns pages to the global protocol counter; the memcg charge
+ *	follows the socket budget, see sk_memcg_budget_sync().
  */
 void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 {
-	if (mem_cgroup_sk_enabled(sk))
-		mem_cgroup_sk_uncharge(sk, amount);
-
 	if (sk->sk_bypass_prot_mem)
 		return;
 
@@ -3498,20 +3507,150 @@ void __sk_mem_reclaim(struct sock *sk, int amount)
 }
 EXPORT_SYMBOL(__sk_mem_reclaim);
 
-void __sk_charge(struct sock *sk, gfp_t gfp)
+/* Pages of the socket's currently established memory budget: the send
+ * and receive buffers plus the SO_RESERVE_MEM reservation.
+ */
+static int sk_memcg_budget_pages(const struct sock *sk)
 {
-	int amt;
+	long budget = READ_ONCE(sk->sk_sndbuf) + READ_ONCE(sk->sk_rcvbuf) +
+		      READ_ONCE(sk->sk_reserved_mem);
 
-	gfp |= __GFP_NOFAIL;
-	if (mem_cgroup_from_sk(sk)) {
-		/* The socket has not been accepted yet, no need
-		 * to look at newsk->sk_wmem_queued.
+	return (int)DIV_ROUND_UP(budget, PAGE_SIZE);
+}
+
+/**
+ *	sk_memcg_budget_sync - charge the socket budget to the memcg
+ *	@sk: socket
+ *	@gfp: reclaim mode for the memcg charge
+ *
+ *	Make the memcg charge match the socket's current budget: charge the
+ *	difference when the budget grew, refund it when the budget shrank.
+ *
+ *	Growth: the memcg is charged first and only a successful charge is
+ *	accounted in sk->sk_memcg_budget. A failed charge leaves the tracker
+ *	unchanged: the new budget is used uncharged (the safe direction) and
+ *	a later call retries the whole difference.
+ *
+ *	Concurrency: budget growth usually runs under the socket lock, but
+ *	some setsockopt(2) paths run without it, and shrinks may run
+ *	locklessly (sk_mem_reclaim() from skb destructors), so the tracker
+ *	is a plain int guarded by sk_memcg_budget_lock. The lock is a leaf
+ *	lock taken with _bh (sk_memcg_budget_release() runs from RCU
+ * callbacks); the memcg charge and uncharge run outside of it because
+ *	they may sleep (memcg reclaim). Charging before publishing the
+ *	tracker, and refunding only the excess claimed under the lock, keep
+ *	every charged page accounted in the tracker exactly once and every
+ *	tracker page refundable exactly once: concurrent growths can
+ *	transiently over-count (the next shrink refunds the excess), while
+ *	cumulative refunds can never exceed cumulative charges, so the
+ *	memcg balance can not underflow.
+ *
+ *	Returns false when a growth charge failed.
+ */
+bool sk_memcg_budget_sync(struct sock *sk, gfp_t gfp)
+{
+	int want, have, delta;
+
+	if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
+		return true;
+
+	/* The snapshot is unlocked on purpose: the memcg charge below
+	 * may sleep, so the lock cannot be held across it, and a
+	 * lock-coherent snapshot would go stale the same way.
+	 */
+	want = sk_memcg_budget_pages(sk);
+	have = READ_ONCE(sk->sk_memcg_budget);
+
+	if (want > have) {
+		delta = want - have;
+		if (!mem_cgroup_sk_charge(sk, delta, gfp))
+			return false;
+
+		/* Add the full @delta unconditionally: every charged page
+		 * must land in the tracker exactly once, so the release
+		 * can refund it exactly once. @have may be stale, the
+		 * resulting over-count is refunded by the next shrink.
 		 */
-		amt = sk_mem_pages(sk->sk_forward_alloc +
-				   atomic_read(&sk->sk_rmem_alloc));
-		if (amt)
-			mem_cgroup_sk_charge(sk, amt, gfp);
+		spin_lock_bh(&sk->sk_memcg_budget_lock);
+		WRITE_ONCE(sk->sk_memcg_budget, sk->sk_memcg_budget + delta);
+		spin_unlock_bh(&sk->sk_memcg_budget_lock);
+	} else if (want < have) {
+		sk_memcg_budget_shrink(sk);
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(sk_memcg_budget_sync);
+
+/**
+ *	sk_memcg_budget_shrink - refund budget shrinks to the memcg
+ *	@sk: socket
+ *
+ *	Return the part of the memcg charge that is no longer backed by the
+ *	socket's budget. Never charges and never fails, so it is safe to
+ *	call from arbitrary (including lockless softirq) contexts, e.g.
+ *	from sk_mem_reclaim() to catch budget shrinks done by writers the
+ *	budget sync is not hooked into.
+ */
+void sk_memcg_budget_shrink(struct sock *sk)
+{
+	int want, refund = 0;
+
+	if (!mem_cgroup_sk_enabled(sk) || !sk_has_account(sk))
+		return;
+
+	/* Claim the excess under the lock, then refund it outside:
+	 * the memcg uncharge may sleep, and the claim guarantees each
+	 * tracker page is refunded exactly once. @want follows the
+	 * socket buffers, which are protected by the socket lock, not
+	 * the budget lock; a claim made stale by a concurrent budget
+	 * update is corrected by the next sync.
+	 */
+	spin_lock_bh(&sk->sk_memcg_budget_lock);
+	want = sk_memcg_budget_pages(sk);
+	if (want < sk->sk_memcg_budget) {
+		refund = sk->sk_memcg_budget - want;
+		WRITE_ONCE(sk->sk_memcg_budget, want);
 	}
+	spin_unlock_bh(&sk->sk_memcg_budget_lock);
+
+	if (refund)
+		mem_cgroup_sk_uncharge(sk, refund);
+}
+EXPORT_SYMBOL(sk_memcg_budget_shrink);
+
+/**
+ *	sk_memcg_budget_release - return the socket's memcg budget charge
+ *	@sk: socket
+ *
+ *	Return the whole remaining budget charge of the socket to its memcg
+ *	and reset the tracker. Used when the socket dies (__sk_destruct(),
+ *	no budget change can happen anymore, the refund is exactly the
+ * amount that was charged) and when the memcg association of the
+ *	socket moves (the charge is re-established against the new memcg).
+ */
+void sk_memcg_budget_release(struct sock *sk)
+{
+	int refund;
+
+	spin_lock_bh(&sk->sk_memcg_budget_lock);
+	refund = sk->sk_memcg_budget;
+	WRITE_ONCE(sk->sk_memcg_budget, 0);
+	spin_unlock_bh(&sk->sk_memcg_budget_lock);
+
+	if (refund)
+		mem_cgroup_sk_uncharge(sk, refund);
+}
+EXPORT_SYMBOL(sk_memcg_budget_release);
+
+void __sk_charge(struct sock *sk, gfp_t gfp)
+{
+	gfp |= __GFP_NOFAIL;
+
+	/* Charge the child's full memory budget to its memcg: the budget
+	 * covers whatever the child queued before being accepted.
+	 */
+	sk_memcg_budget_sync(sk, gfp);
 
 	kmem_cache_charge(sk, gfp);
 }
@@ -3753,6 +3892,10 @@ void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid)
 	sk->sk_allocation	=	GFP_KERNEL;
 	sk->sk_rcvbuf		=	READ_ONCE(sysctl_rmem_default);
 	sk->sk_sndbuf		=	READ_ONCE(sysctl_wmem_default);
+	/* The socket's memory budget starts here: charge it to the memcg
+	 * upfront. Protocols raising the default buffers later re-sync.
+	 */
+	sk_memcg_budget_sync(sk, gfp_memcg_charge());
 	sk->sk_state		=	TCP_CLOSE;
 	sk->sk_use_task_frag	=	true;
 	sk_set_socket(sk, sock);
@@ -4567,6 +4710,8 @@ static int __init sock_struct_check(void)
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_err);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_socket);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_memcg_budget);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_memcg_budget_lock);
 #ifdef CONFIG_MEMCG
 	CACHELINE_ASSERT_GROUP_MEMBER(struct sock, sock_read_rxtx, sk_memcg);
 #endif
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5588310bc648..3c9e1a88a6bd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -914,9 +914,9 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	amt = sk_mem_pages(delta);
 	sk_forward_alloc_add(sk, amt << PAGE_SHIFT);
 
-	if (mem_cgroup_sk_enabled(sk))
-		mem_cgroup_sk_charge(sk, amt, gfp_memcg_charge() | __GFP_NOFAIL);
-
+	/* Only the global protocol counter: the memcg side follows the
+	 * socket budget (sk_memcg_budget_sync()).
+	 */
 	if (sk->sk_bypass_prot_mem)
 		return;
 
-- 
2.18.0.huawei.25

