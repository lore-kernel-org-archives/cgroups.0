From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] cls_cgroup: get sk_classid only from full sockets
Date: Mon, 18 Apr 2016 14:37:10 +0300
Message-ID: <146097943086.15300.8997345346172526153.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
	t=1460979434; bh=O0xGrXyjGyMxs0V1ChO0Bv55K/JuH2UpGJHcYrd7oZY=;
	h=Subject:From:To:Cc:Date:Message-ID:User-Agent:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	b=xdSllLtyy0gSXZq+B9+zpBPPDubg0RY2jTPA732ebcQGuMO7NYFkRc/lUftvH3riR
	 lIz38KbVajtNCXNzlTF1dryVGXBke/KKHOJ2AuKsww5225bT93mcB2cfuHezLEvxV3
	 Gjevu0Nmmc90Emp7HnOSquzmGE+klItkwwXU2Dlg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

skb->sk could point to timewait or request socket which has no sk_classid.
Detected as "BUG: KASAN: slab-out-of-bounds in cls_cgroup_classify".

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 include/net/cls_cgroup.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/net/cls_cgroup.h b/include/net/cls_cgroup.h
index c0a92e2c286d..74c9693d4941 100644
--- a/include/net/cls_cgroup.h
+++ b/include/net/cls_cgroup.h
@@ -17,6 +17,7 @@
 #include <linux/hardirq.h>
 #include <linux/rcupdate.h>
 #include <net/sock.h>
+#include <net/inet_sock.h>
 
 #ifdef CONFIG_CGROUP_NET_CLASSID
 struct cgroup_cls_state {
@@ -63,11 +64,13 @@ static inline u32 task_get_classid(const struct sk_buff *skb)
 	 * softirqs always disables bh.
 	 */
 	if (in_serving_softirq()) {
+		struct sock *sk = skb_to_full_sk(skb);
+
 		/* If there is an sock_cgroup_classid we'll use that. */
-		if (!skb->sk)
+		if (!sk || !sk_fullsock(sk))
 			return 0;
 
-		classid = sock_cgroup_classid(&skb->sk->sk_cgrp_data);
+		classid = sock_cgroup_classid(&sk->sk_cgrp_data);
 	}
 
 	return classid;

