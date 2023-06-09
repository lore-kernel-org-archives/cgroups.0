From: Abel Wu <wuyun.abel@bytedance.com>
Subject: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem isolation
Date: Fri,  9 Jun 2023 16:27:03 +0800
Message-ID: <20230609082712.34889-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev+bounces-9453-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686299290; x=1688891290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3Mnn0NJnMdo5oou5LijiWQTnrZb/85o7p3nvJNaAHoM=;
        b=jsw3R6na+7LqrydPc0FvDpVQhH7T6IEkvxDv7igYNc4VoPgzY5x138m6Ufz7zAWNyh
         ka3dcEilI6dmem3GetyUB7wv/wXMY57kojWZ9cxIb5EnhQmcOOsuWZxBdMsPaoh99AqB
         B6XUvC6+N8caa3EoRa7tgVqcb9x+qj5WLqDC4KkAXMDsH/Newo4Z4/LuOJsgQBye6Ocs
         EnU3Cp3MVnMyFXpLqMsh77rVJmlIsEdTIQxqr+tJ3JQITj8H3Z4jcCqQoao5hD162/rM
         XKHOW/Glgi2xoYiE19QmBByld9VX0RLsq/IHjNR1Q+uXH+CvZE03RlvQAkruEzxL6kzf
         oC5A==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Christian Warloe <cwarloe@google.com>, Wei Wang <weiwan@google.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Vasily Averin <vasily.averin@linux.dev>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Abel Wu <wuyun.abel@bytedance.com>, Xin Long <lucien.xin@gmail.com>, Jason Xing <kernelxing@tencent.com>
Cc: Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <ast@kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER MEMCG" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER MEMCG" <linux-mm@kvack.org>

This is just a PoC patch intended to resume the discussion about
tcpmem isolation opened by Google in LPC'22 [1].

We are facing the same problem that the global shared threshold can
cause isolation issues. Low priority jobs can hog TCP memory and
adversely impact higher priority jobs. What's worse is that these
low priority jobs usually have smaller cpu weights leading to poor
ability to consume rx data.

To tackle this problem, an interface for non-root cgroup memory
controller named 'socket.urgent' is proposed. It determines whether
the sockets of this cgroup and its descendants can escape from the
constrains or not under global socket memory pressure.

The 'urgent' semantics will not take effect under memcg pressure in
order to protect against worse memstalls, thus will be the same as
before without this patch.

This proposal doesn't remove protocal's threshold as we found it
useful in restraining memory defragment. As aforementioned the low
priority jobs can hog lots of memory, which is unreclaimable and
unmovable, for some time due to small cpu weight.

So in practice we allow high priority jobs with net-memcg accounting
enabled to escape the global constrains if the net-memcg itselt is
not under pressure. While for lower priority jobs, the budget will
be tightened as the memory usage of 'urgent' jobs increases. In this
way we can finally achieve:

  - Important jobs won't be priority inversed by the background
    jobs in terms of socket memory pressure/limit.

  - Global constrains are still effective, but only on non-urgent
    jobs, useful for admins on policy decision on defrag.

Comments/Ideas are welcomed, thanks!

[1] https://lpc.events/event/16/contributions/1212/

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/linux/memcontrol.h | 15 +++++++++++++--
 include/net/sock.h         | 11 ++++++++---
 include/net/tcp.h          | 26 ++++++++++++++++++++------
 mm/memcontrol.c            | 35 +++++++++++++++++++++++++++++++++++
 net/core/sock.c            | 22 ++++++++++++++++++----
 net/ipv4/tcp_input.c       | 10 +++++++---
 6 files changed, 101 insertions(+), 18 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 222d7370134c..f8c1c108aa28 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -284,7 +284,13 @@ struct mem_cgroup {
 	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
 	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
 
+	/*
+	 * Urgent sockets can escape from the contrains under global memory
+	 * pressure/limit iff !socket_pressure. So this two variables are
+	 * always used together, make sure they are in same cacheline.
+	 */
 	unsigned long		socket_pressure;
+	bool			socket_urgent;
 
 	/* Legacy tcp memory accounting */
 	bool			tcpmem_active;
@@ -1741,13 +1747,17 @@ extern struct static_key_false memcg_sockets_enabled_key;
 #define mem_cgroup_sockets_enabled static_branch_unlikely(&memcg_sockets_enabled_key)
 void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
-static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
+
+static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg,
+						    bool *is_urgent)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
 		return true;
 	do {
 		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
 			return true;
+		if (is_urgent && !*is_urgent && READ_ONCE(memcg->socket_urgent))
+			*is_urgent = true;
 	} while ((memcg = parent_mem_cgroup(memcg)));
 	return false;
 }
@@ -1760,7 +1770,8 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 #define mem_cgroup_sockets_enabled 0
 static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
 static inline void mem_cgroup_sk_free(struct sock *sk) { };
-static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
+static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg,
+						    bool *is_urgent)
 {
 	return false;
 }
diff --git a/include/net/sock.h b/include/net/sock.h
index 656ea89f60ff..80e1240ffc35 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1414,9 +1414,14 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	if (!sk->sk_prot->memory_pressure)
 		return false;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
-		return true;
+	if (mem_cgroup_sockets_enabled && sk->sk_memcg) {
+		bool urgent;
+
+		if (mem_cgroup_under_socket_pressure(sk->sk_memcg, &urgent))
+			return true;
+		if (urgent)
+			return false;
+	}
 
 	return !!*sk->sk_prot->memory_pressure;
 }
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 14fa716cac50..9fa8d8fcb992 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -259,9 +259,14 @@ extern unsigned long tcp_memory_pressure;
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
-		return true;
+	if (mem_cgroup_sockets_enabled && sk->sk_memcg) {
+		bool urgent;
+
+		if (mem_cgroup_under_socket_pressure(sk->sk_memcg, &urgent))
+			return true;
+		if (urgent)
+			return false;
+	}
 
 	return READ_ONCE(tcp_memory_pressure);
 }
@@ -284,9 +289,18 @@ static inline bool between(__u32 seq1, __u32 seq2, __u32 seq3)
 
 static inline bool tcp_out_of_memory(struct sock *sk)
 {
-	if (sk->sk_wmem_queued > SOCK_MIN_SNDBUF &&
-	    sk_memory_allocated(sk) > sk_prot_mem_limits(sk, 2))
-		return true;
+	if (sk->sk_wmem_queued > SOCK_MIN_SNDBUF) {
+		bool urgent = false;
+
+		if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
+		    !mem_cgroup_under_socket_pressure(sk->sk_memcg, &urgent) &&
+		    urgent)
+			return false;
+
+		if (sk_memory_allocated(sk) > sk_prot_mem_limits(sk, 2))
+			return true;
+	}
+
 	return false;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4b27e245a055..d620c4d9b2cc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6753,6 +6753,35 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
 	return nbytes;
 }
 
+static int memory_sock_urgent_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
+
+	seq_printf(m, "%d\n", READ_ONCE(memcg->socket_urgent));
+
+	return 0;
+}
+
+static ssize_t memory_sock_urgent_write(struct kernfs_open_file *of,
+					char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	bool socket_urgent;
+	int ret;
+
+	buf = strstrip(buf);
+	if (!buf)
+		return -EINVAL;
+
+	ret = kstrtobool(buf, &socket_urgent);
+	if (ret)
+		return ret;
+
+	WRITE_ONCE(memcg->socket_urgent, socket_urgent);
+
+	return nbytes;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6821,6 +6850,12 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NS_DELEGATABLE,
 		.write = memory_reclaim,
 	},
+	{
+		.name = "socket.urgent",
+		.flags = CFTYPE_NOT_ON_ROOT | CFTYPE_NS_DELEGATABLE,
+		.seq_show = memory_sock_urgent_show,
+		.write = memory_sock_urgent_write,
+	},
 	{ }	/* terminate */
 };
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 5440e67bcfe3..29d2b03595cf 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2982,10 +2982,24 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
-	if (memcg_charge &&
-	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
-						gfp_memcg_charge())))
-		goto suppress_allocation;
+
+	if (memcg_charge) {
+		bool urgent;
+
+		charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
+						  gfp_memcg_charge());
+		if (!charged)
+			goto suppress_allocation;
+
+		if (!mem_cgroup_under_socket_pressure(sk->sk_memcg, &urgent)) {
+			/* Urgent sockets by design escape from the constrains
+			 * under global memory pressure/limit iff there is no
+			 * pressure in the net-memcg to avoid priority inversion.
+			 */
+			if (urgent)
+				return 1;
+		}
+	}
 
 	/* Under limit. */
 	if (allocated <= sk_prot_mem_limits(sk, 0)) {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 61b6710f337a..7d5d4b4e17b4 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5439,6 +5439,7 @@ static int tcp_prune_queue(struct sock *sk, const struct sk_buff *in_skb)
 static bool tcp_should_expand_sndbuf(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
+	bool under_pressure, urgent = false;
 
 	/* If the user specified a specific send buffer setting, do
 	 * not modify it.
@@ -5446,8 +5447,11 @@ static bool tcp_should_expand_sndbuf(struct sock *sk)
 	if (sk->sk_userlocks & SOCK_SNDBUF_LOCK)
 		return false;
 
-	/* If we are under global TCP memory pressure, do not expand.  */
-	if (tcp_under_memory_pressure(sk)) {
+	under_pressure = mem_cgroup_sockets_enabled && sk->sk_memcg &&
+			 mem_cgroup_under_socket_pressure(sk->sk_memcg, &urgent);
+
+	/* If we are under net-memcg/TCP memory pressure, do not expand.  */
+	if (under_pressure || (!urgent && READ_ONCE(tcp_memory_pressure))) {
 		int unused_mem = sk_unused_reserved_mem(sk);
 
 		/* Adjust sndbuf according to reserved mem. But make sure
@@ -5461,7 +5465,7 @@ static bool tcp_should_expand_sndbuf(struct sock *sk)
 	}
 
 	/* If we are under soft global TCP memory pressure, do not expand.  */
-	if (sk_memory_allocated(sk) >= sk_prot_mem_limits(sk, 0))
+	if (!urgent && sk_memory_allocated(sk) >= sk_prot_mem_limits(sk, 0))
 		return false;
 
 	/* If we filled the congestion window, do not expand.  */
-- 
2.37.3


