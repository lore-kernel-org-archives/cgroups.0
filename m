From: Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v4 2/4] sock: Always take memcg pressure into consideration
Date: Tue, 30 May 2023 19:40:09 +0800
Message-ID: <20230530114011.13368-3-wuyun.abel@bytedance.com>
References: <20230530114011.13368-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev+bounces-6346-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685446839; x=1688038839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7JbrrHsu8KzXBp8abtNpZsLO9DbdsQWsXzCPkkoYMdc=;
        b=XUY6RCnc6d+7un5QD7wAiC5Pb7wzmwMI4vRo1wJc4PF0bSz7lhpfuw5w2hLGZ7RA/3
         n332Bt+Pe4lAngq6WuKUDTougZGEtz32pIJU7zKJ8QTXJ5ViSZGmOERloMz4QRJYUPXH
         hsv0l3Khpa0C5xc3NS3GzMJDoOmmkOVJ01kqthm/kqhC6JK6gClKXL3r+jLADDxhzx9e
         f8NGSVpHLSwGsRh54M1XlrCzSrhEhoysZtz/ipf9w+BGN8Jbp6s9IBTI7fqTjtdWxouD
         Z3Xw+ieXdkIIETN2bAKZUVTNN+xCGvn93OegJEeKCcXmPMVmn2p4opliPA/APLsYLQee
         burg==
In-Reply-To: <20230530114011.13368-1-wuyun.abel@bytedance.com>
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Abel Wu <wuyun.abel@bytedance.com>

The sk_under_memory_pressure() is called to check whether there is
memory pressure related to this socket. But now it ignores the net-
memcg's pressure if the proto of the socket doesn't care about the
global pressure, which may put burden on its memcg compaction or
reclaim path (also remember that socket memory is un-reclaimable).

So always check the memcg's vm status to alleviate memstalls when
it's in pressure.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/net/sock.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 641c9373b44b..b0e5533e5909 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1411,13 +1411,11 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
 
 static inline bool sk_under_memory_pressure(const struct sock *sk)
 {
-	if (!sk->sk_prot->memory_pressure)
-		return false;
-
 	if (mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
-	return !!*sk->sk_prot->memory_pressure;
+	return sk->sk_prot->memory_pressure &&
+		*sk->sk_prot->memory_pressure;
 }
 
 static inline long
-- 
2.37.3


