From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] net: memcg: late association of sock to memcg
Date: Wed,  4 Mar 2020 15:38:56 -0800
Message-ID: <20200304233856.257891-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=a2ls/0+XhOrLTmzZ82TksSq7Jty/zbg+jikoqthrwds=;
        b=Wh+3HRWnRFld+I3x/Iifo4+Qouth/uqsuqouyd2n/JVRzs9fT4wd7TvoPNIYriz/Kp
         q/ZzDURRIGkj4pUguk91KE/6rt+WdnjL0J5r6Qz0wKMf4mZmTjGIBYrLk+a9icvBsfWy
         PzVErlzx+MQRl34XA1leAHz1Ui4XPsgnEjvPb6bFxpbQ8c0zsORYd/0t1HdfNr7eUipJ
         UYaLKuTFBQU3V4w48Zs6JfULm4w7tz/MYUXXUZGzPjsKpKo2/vhRg0oXzHVj9LREpp7Q
         eaLrpnMd04umIx9Pfv/QovyVUcvq4z5TO9ANWCic7ekQ/kF+iashcbQirvtdtNHDBSkw
         gmpw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

If a TCP socket is allocated in IRQ context or cloned from unassociated
(i.e. not associated to a memcg) in IRQ context then it will remain
unassociated for its whole life. Almost half of the TCPs created on the
system are created in IRQ context, so, memory used by such sockets will
not be accounted by the memcg.

This issue is more widespread in cgroup v1 where network memory
accounting is opt-in but it can happen in cgroup v2 if the source socket
for the cloning was created in root memcg.

To fix the issue, just do the late association of the unassociated
sockets at accept() time in the process context and then force charge
the memory buffer already reserved by the socket.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
Changes since v1:
- added sk->sk_rmem_alloc to initial charging.
- added synchronization to get memory usage and set sk_memcg race-free.

 net/ipv4/inet_connection_sock.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a4db79b1b643..7bcd657cd45e 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -482,6 +482,25 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
 		}
 		spin_unlock_bh(&queue->fastopenq.lock);
 	}
+
+	if (mem_cgroup_sockets_enabled && !newsk->sk_memcg) {
+		int amt;
+
+		/* atomically get the memory usage and set sk->sk_memcg. */
+		lock_sock(newsk);
+
+		/* The sk has not been accepted yet, no need to look at
+		 * sk->sk_wmem_queued.
+		 */
+		amt = sk_mem_pages(newsk->sk_forward_alloc +
+				   atomic_read(&sk->sk_rmem_alloc));
+		mem_cgroup_sk_alloc(newsk);
+
+		release_sock(newsk);
+
+		if (newsk->sk_memcg)
+			mem_cgroup_charge_skmem(newsk->sk_memcg, amt);
+	}
 out:
 	release_sock(sk);
 	if (req)
-- 
2.25.0.265.gbab2e86ba0-goog

