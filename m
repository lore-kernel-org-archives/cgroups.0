From: Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v4 1/4] net-memcg: Fold dependency into memcg pressure cond
Date: Tue, 30 May 2023 19:40:08 +0800
Message-ID: <20230530114011.13368-2-wuyun.abel@bytedance.com>
References: <20230530114011.13368-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev+bounces-6345-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685446833; x=1688038833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zSeZy3dBgM/hAvW1l4S3j81M4ry+F3vLfbl4Wg72DeY=;
        b=hhLQ3LoKBaJEJ5y7uGQ1a6tBrIrMZV+1pnIfqUg+3PPYZLcdnc+7VDqo7mmHd61hrj
         Sd4swO79Q16159eQDWb/4DVkqYPSM/uwLu9+nrIMavuQvSS0iMMA2tKxbWYOLOTyMNNW
         8Q9YqbEBpn+Nx2pNK4smxSztJf5X5kZARTJKBTBELw90yTB1VKCkqnwAR8Px/p/KKR7V
         fOhc0w5nYnh7RRxeDgcc3lEBrXih07VolZo5Ebp7QGT1yNFQEfcQDeiZsXJhF9CLMeJk
         SavXV7b4KyPrvCtY6W/D4aQTnvHV5HjuN8C1ttrCgPPMzrSoHBP01IYNksy9EhRLI1EZ
         mTeQ==
In-Reply-To: <20230530114011.13368-1-wuyun.abel@bytedance.com>
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Abel Wu <wuyun.abel@bytedance.com>

The callers of mem_cgroup_under_socket_pressure() should always make
sure that (mem_cgroup_sockets_enabled && sk->sk_memcg) is true. So
instead of coding around all the callsites, put the dependencies into
mem_cgroup_under_socket_pressure() to avoid redundancy and possibly
bugs.

This change might also introduce slight function call overhead *iff*
the function gets expanded in the future. But for now this change
doesn't make binaries different (checked by vimdiff) except the one
net/ipv4/tcp_input.o (by scripts/bloat-o-meter), which is probably
negligible to performance:

add/remove: 0/0 grow/shrink: 1/2 up/down: 5/-5 (0)
Function                                     old     new   delta
tcp_grow_window                              573     578      +5
tcp_try_rmem_schedule                       1083    1081      -2
tcp_check_space                              324     321      -3
Total: Before=44647, After=44647, chg +0.00%

So folding the dependencies into mem_cgroup_under_socket_pressure()
is generally a good thing and provides better readablility.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/linux/memcontrol.h | 2 ++
 include/net/sock.h         | 3 +--
 include/net/tcp.h          | 3 +--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 222d7370134c..a1aead140ff8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1743,6 +1743,8 @@ void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
+	if (!mem_cgroup_sockets_enabled || !memcg)
+		return false;
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
 		return true;
 	do {
diff --git a/include/net/sock.h b/include/net/sock.h
index 8b7ed7167243..641c9373b44b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1414,8 +1414,7 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	if (!sk->sk_prot->memory_pressure)
 		return false;
 
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
+	if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
 	return !!*sk->sk_prot->memory_pressure;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 04a31643cda3..3c5e3718b454 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -261,8 +261,7 @@ extern unsigned long tcp_memory_pressure;
 /* optimized version of sk_under_memory_pressure() for TCP sockets */
 static inline bool tcp_under_memory_pressure(const struct sock *sk)
 {
-	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
-	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
+	if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
 	return READ_ONCE(tcp_memory_pressure);
-- 
2.37.3


