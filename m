From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH net] net: enable memcg accounting for veth queues
Date: Fri, 29 Apr 2022 08:17:35 +0300
Message-ID: <0b28d49b-605c-ac1a-df85-643164e69039@openvz.org>
References: <1c338b99-8133-6126-2ff2-94a4d3f26451@openvz.org>
 <20220427095854.79554fab@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s9wfiyI3JBIiISlABF9nzSzidRhd08PN5K7/7gRJUwU=;
        b=zgh0lqmxqjAmYpfMJeInqwyar5RpKgn6nKPhjU0zE/mRkRAEOsvk01q11mzTkDptGi
         TwBcOx3EARcSI0hAy15m/EW2/0NDVnNDO95agwC6gbWdQLW4BjUE7CMli5n1iR5y8wOa
         g2LGTfB+wEs9BisfMzb6MrrgDQhrA5OanuAZ+TT5md3h2aag3jDAPyzctlDCCG97MKPQ
         e06ZJtfPG7utnP0hWSxpaUVfENEu7U2BcFuBCJbGdkJRiMjrPXJVr2P3nK0MraYFi6sz
         dmNYSv5MxKsD7AUI5Bf0T5Y0G9OWIbekQq8sNqNLeTRfjuqk1lZZeNVGgx24s+tILIfP
         7Q2A==
Content-Language: en-US
In-Reply-To: <20220427095854.79554fab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

veth netdevice defines own rx queues and allocates array containing
up to 4095 ~750-bytes-long 'struct veth_rq' elements. Such allocation
is quite huge and should be accounted to memcg.

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
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
