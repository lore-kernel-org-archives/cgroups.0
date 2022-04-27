From: Vasily Averin <vvs@openvz.org>
Subject: [PATCH] memcg: enable accounting for veth queues
Date: Wed, 27 Apr 2022 13:34:29 +0300
Message-ID: <1c338b99-8133-6126-2ff2-94a4d3f26451@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=s9wfiyI3JBIiISlABF9nzSzidRhd08PN5K7/7gRJUwU=;
        b=F1CrcAo2L4t+g24hKYKTkJrAIVD+uTem+dr8Xe28yedKWFGtVI7PftZuZcQfKZcEOu
         z8H2qRwJPsk95KVz3cKAwjeZpfThWo2YICJwhmyX38kLU48FLwyTc4X1KU+Q0seSVK8o
         SIoNSv6HijNeKMGu+McRx0LPACtUYGfr9OFlNsr53DrbB25SZKsV46crOk2U2kaEeS1v
         n73RzjxPj+Dc+8m9++UWK2PmXlExBoFRwfte8OGfQKin+2u9FYxR9RdC7gS2PlqLFCVi
         1bR/qi42emMrThTa7fgOLHgL2q7KukCh3+iI19VSkvx1t6PsRjP52JxxJxIyWn6CQNYp
         HqNw==
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeelb@google.com>
Cc: kernel@openvz.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>

veth netdevice defines own rx queues and allocates array containing
up to 4095 ~750-bytes-long 'struct veth_rq' elements. Such allocation
is quite huge and should be accounted to memcg.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index d29fb9759cc9..bd67f458641a 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1310,7 +1310,7 @@ static int veth_alloc_queues(struct net_device *dev)
 	struct veth_priv *priv = netdev_priv(dev);
 	int i;
 
-	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL);
+	priv->rq = kcalloc(dev->num_rx_queues, sizeof(*priv->rq), GFP_KERNEL_ACCOUNT);
 	if (!priv->rq)
 		return -ENOMEM;
 
-- 
2.31.1

