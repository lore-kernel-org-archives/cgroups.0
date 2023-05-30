From: Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH v4 4/4] sock: Remove redundant cond of memcg pressure
Date: Tue, 30 May 2023 19:40:11 +0800
Message-ID: <20230530114011.13368-5-wuyun.abel@bytedance.com>
References: <20230530114011.13368-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev+bounces-6348-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685446851; x=1688038851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RnVh2joarXNT9aj52CHZE7i4DFTKtYVUHBE2hndAHFM=;
        b=btr0FoS+C6fgN8Erg41EU1t5DJZD+PGpyR8bakM6GW+5ICYCzcrthDnH/6xVPa+R/Q
         wG33TV1SZXTSdoEBPSuVByreJr8Gqe+O51Rrgz9Y73Q9ejyvJRjXK5eIT9djyPPlFgvb
         7yjesf0wmL+VpcChkGgR+xTrD7A7FInxqIyHcX7V0kBikEvD+Gcmwvvj1tjFmu6SjTWU
         1mtHFPzNab3djs/NQuIwpZKWzAqcOIj7G4B3U0h+DRCca2OlBrJX+tqBNTydDQfcbJO7
         DKVs5NHggfUWPYEokBru5ocQ0Gp4jvD47OV3sXrkPMdZtcuktJf9yWqNjhJ2I4I7b8BW
         09mg==
In-Reply-To: <20230530114011.13368-1-wuyun.abel@bytedance.com>
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>
Cc: Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Abel Wu <wuyun.abel@bytedance.com>

Now with the previous patch, __sk_mem_raise_allocated() considers
the memory pressure of both global and the socket's memcg on a func-
wide level, making the condition of memcg's pressure in question
redundant.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 net/core/sock.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 801df091e37a..86735ad2f903 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3020,9 +3020,15 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 	if (sk_has_memory_pressure(sk)) {
 		u64 alloc;
 
-		if (!sk_under_memory_pressure(sk))
+		if (!sk_under_global_memory_pressure(sk))
 			return 1;
+
 		alloc = sk_sockets_allocated_read_positive(sk);
+
+		/* If under global pressure, allow the sockets that are below
+		 * average memory usage to raise, trying to be fair among all
+		 * the sockets under global constrains.
+		 */
 		if (sk_prot_mem_limits(sk, 2) > alloc *
 		    sk_mem_pages(sk->sk_wmem_queued +
 				 atomic_read(&sk->sk_rmem_alloc) +
-- 
2.37.3


