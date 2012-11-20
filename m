From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/7] netprio_cgroup: simplify write_priomap()
Date: Mon, 19 Nov 2012 23:06:25 -0800
Message-ID: <1353395190-4530-3-git-send-email-tj@kernel.org>
References: <1353395190-4530-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=AV8tNgfgjBr2S/QpcGJqhF61RUJU8JC10tg3t/oRW7Y=;
        b=s+AhvJI4wqQPK7hU/6SjgtoTDfKrHRpiXvpJ9Y7JkRI4MM1GumqzlNBJn0Px0pSSWG
         scNGSBb0aamcs4CuxKbo+wMQp8hAD0vI4rbBEswh6SWIzVSQQoGPlc7LUa2xwVehaK0J
         bZv20LtDe4X7OS7XUxXOAsFNFprS5HwBtwXD24dOYen11vHiG7fb5tGQTLigoxuhEJje
         iS0fqOrq1jxVHilwHW3mQfqRz8oUUcg1qJ3bT+5/pJsq+vUE4/7pLMIaE8QZ3JokiVLv
         DR8xYd7YscynWmdaJUpu0WWrAdAJFzClVQf0gX9G6m3kWAVzvORAxyfhj4AeuJSe9Bc7
         x8Iw==
In-Reply-To: <1353395190-4530-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: daniel.wagner@bmw-carit.de, serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com, tgraf@suug.ch
Cc: davem@davemloft.net, lizefan@huawei.com, cgroups@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

sscanf() doesn't bite.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 net/core/netprio_cgroup.c | 56 ++++++++++-------------------------------------
 1 file changed, 11 insertions(+), 45 deletions(-)

diff --git a/net/core/netprio_cgroup.c b/net/core/netprio_cgroup.c
index f0b6b0d..66d98da 100644
--- a/net/core/netprio_cgroup.c
+++ b/net/core/netprio_cgroup.c
@@ -176,66 +176,32 @@ static int read_priomap(struct cgroup *cont, struct cftype *cft,
 static int write_priomap(struct cgroup *cgrp, struct cftype *cft,
 			 const char *buffer)
 {
-	char *devname = kstrdup(buffer, GFP_KERNEL);
-	int ret = -EINVAL;
 	u32 prioidx = cgrp_netprio_state(cgrp)->prioidx;
-	unsigned long priority;
-	char *priostr;
+	char devname[IFNAMSIZ + 1];
 	struct net_device *dev;
 	struct netprio_map *map;
+	u32 prio;
+	int ret;
 
-	if (!devname)
-		return -ENOMEM;
-
-	/*
-	 * Minimally sized valid priomap string
-	 */
-	if (strlen(devname) < 3)
-		goto out_free_devname;
-
-	priostr = strstr(devname, " ");
-	if (!priostr)
-		goto out_free_devname;
-
-	/*
-	 *Separate the devname from the associated priority
-	 *and advance the priostr pointer to the priority value
-	 */
-	*priostr = '\0';
-	priostr++;
-
-	/*
-	 * If the priostr points to NULL, we're at the end of the passed
-	 * in string, and its not a valid write
-	 */
-	if (*priostr == '\0')
-		goto out_free_devname;
-
-	ret = kstrtoul(priostr, 10, &priority);
-	if (ret < 0)
-		goto out_free_devname;
-
-	ret = -ENODEV;
+	if (sscanf(buffer, "%"__stringify(IFNAMSIZ)"s %u", devname, &prio) != 2)
+		return -EINVAL;
 
 	dev = dev_get_by_name(&init_net, devname);
 	if (!dev)
-		goto out_free_devname;
+		return -ENODEV;
 
 	rtnl_lock();
+
 	ret = write_update_netdev_table(dev);
-	if (ret < 0)
-		goto out_put_dev;
+	if (ret)
+		goto out_unlock;
 
 	map = rtnl_dereference(dev->priomap);
 	if (map)
-		map->priomap[prioidx] = priority;
-
-out_put_dev:
+		map->priomap[prioidx] = prio;
+out_unlock:
 	rtnl_unlock();
 	dev_put(dev);
-
-out_free_devname:
-	kfree(devname);
 	return ret;
 }
 
-- 
1.7.11.7
