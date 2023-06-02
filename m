From: Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH net-next v5 2/3] sock: Always take memcg pressure into consideration
Date: Fri,  2 Jun 2023 16:11:34 +0800
Message-ID: <20230602081135.75424-3-wuyun.abel@bytedance.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685693522; x=1688285522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aMgEeyTxt1Bo6VDZUGwQjdkhsPRlWxhl30gajyLXBa4=;
        b=VjphZxOIejuEYZEGuPwwC4pDQ7lIV7K/XG9vcSDLCRxCWGgGi5PSze6VUYd11+IAs0
         Kuul4CNsZBFvMYso/aMxRk0DUCPanLD16zAl1A0vODdrCeOViOsELz9IBaR8oTw6UPca
         Sh5kimkJvKN5Y60CS7Fgx05CnVMkFs3LUuQK4GRlUFaU64P6G3aEXHniXJomFeuNh7RV
         2g9IxHPICSZ3vQb4CogF4QAJdPmhaXCbiWb/5M6aqzDmAghY5ZlzepkhiMb7IttTe7uY
         mULWUSkeYlsAYa+W5goQyWu6i+nF1szs/G1oDUjv5o+ae9/cGIFhbicxvEJ9GU8G5HDk
         p57A==
In-Reply-To: <20230602081135.75424-1-wuyun.abel@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
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
index 3f63253ee092..ad1895ffbc4a 100644
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

