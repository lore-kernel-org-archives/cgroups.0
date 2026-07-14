Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0381A47DF85
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784039386; cv=none; b=OQTbfP/XC9zPATSBKN0o1G9vqbbHwpktURE1YHtd/M9avHTXQZz41/EKccsJUdBkCy0mgld0rTEIFlNlsRnmRQM8MLJ2SZY0qtijuFLXGqHYsLsyT9LZ/dWJ4XbgimAzAkm+1sHq0Mjot4n9biV4uMqToxuz0JJKXhiGCdLovAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784039386; c=relaxed/simple;
	bh=wA8BNmGtATPpMY/ZSlkPeyL8zmIVQzgdWs9Vab6JUfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1bzqmXjG6IxB5TcOndKuwf93hOYT98kNxXlXNZ1pQrudFmn6KpASjyrlLLViYkCwA2cOW9qHwW6H91R5W6dnqGi12onSG1j61NV6f+pG9KBL51Fed1yvpm2HoWtCwvlour10yKWA1XKd9EP6C/D7BxMH98uJxyscm5k+eLjuKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=XpmPHl6k; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="XpmPHl6k"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-470174001a0so557853f8f.0
        for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 07:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784039382; x=1784644182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6vRi0FyHKR2HrcrI2hLHxbpKJ44GeP97d/xvetjGhOQ=;
        b=XpmPHl6ks4O77Umwor1uQQIRRhHXoTIlhBsbjyrQo2PkbikdEBYurwZsIi/cji+EFQ
         4AyP/1fI+ryXebC4jDMm2bDWtmQFJRI4s5R16swkj3glQktUeVx7MLy2943UqQM73LSr
         RbCGdYHTsl8VHUUmLRgYyEMRaK9LXgeEhvrQOSO7GdkNdo7XBgAWPeE8kXuTedEoAbai
         wdcbH7j6yydRVxMdmlXQxLc8TxK6uGr8ZbvqACDgHOulyRfZD+wrbbARwXLIgWHR1HeA
         bmSw7RpuFcfcO/QjHHYohb4nvcVUl5Lpp+3tPBBqbzOcMQVrjQ7eEgvt98LDNNE+C8Bb
         mmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784039382; x=1784644182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6vRi0FyHKR2HrcrI2hLHxbpKJ44GeP97d/xvetjGhOQ=;
        b=Js9Oh6GTzAkA/G55H/0F9/6oei4cC7agGhXlNFeSJZIstByrH+nfi3+6MQXsNJwmhX
         +IcqVKjy1DswcI7BS5IK/QerQHvd+DNAW0GL52Oaw05XPzZsYljGqJ89uhhvmZKsnpoK
         p4QuaB/g8TS2hpzxTbbKIn8b0yTVBDnG+cB2CxuSe0E+Msnzrl3KvS973XeIf+Rt9BaK
         kxMZd0cirYOexDXUcQmIeHJrhNg2NCveBruJOOwrxcvIwR1Up8OTHfp8c0ybehepmvGt
         vDSDkjw8eEW6/qnK+WmLSCSLGrW0VUTLt5ufH/1Kv8E3abBW2VXu6nnKWwKxZ9jrVO48
         u75Q==
X-Gm-Message-State: AOJu0YzBYKJm1cYQJIZ1zQzf+l2bhRlW/hASu6mi+hhXcHIHt2VDcOg1
	/wIVUcCP+7dVBk9FHPgHXlxenZKlPJRhTiCBXaYkrgvByHIi6JgKB1Rdbcb9Dv9ChfI=
X-Gm-Gg: AfdE7cmIQSk8R1fAxi6ycQd5vhODAkqZkyTs1TKj1za+ggVIqrQpRsYlQD1UtGiacmq
	cDU7D2ogbAbCgE2ItCJ898VhkSx5SGJNdnuRIPlGBhXfXN+UKAx0SKH9V3BJED2/twa6zVa/J//
	vveXoYDFr+BR9ovKHH5Yz1ewx+uGbK7DJh06cm5O5pVEv+p01g9oSCIIvyVOLKe3/FBj0zGYrwc
	gLp8Df0RNIOdLj5lVxeaTXz1muRJlaJffTzy6eq4iD1NL6WyKGKXCVNweIgK8mkQUauYQWvLTUF
	S12DxH9wVHbd815MOq9ZtbjZu2zePA2vFcqvmXT1ldil/pQevn47kFoxSypd9w3iPe5xImnMNAd
	ZPcCrHU2Mn0t4OV6MSJv3J3FbOnEii4eJdV7EkLLErLZ/Q0V0vGcpzFcQS6QAyVKkdAiP7NQXty
	CpLhNF7dxaF/wHqvrfdBz1ig==
X-Received: by 2002:a05:6000:2903:b0:46f:a93b:f404 with SMTP id ffacd0b85a97d-47f2dc9babdmr15641615f8f.19.1784039382211;
        Tue, 14 Jul 2026 07:29:42 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464a96fdsm9228379f8f.24.2026.07.14.07.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 07:29:41 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: cgroups@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	parav@nvidia.com,
	mbloch@nvidia.com,
	cmeiohas@nvidia.com,
	roman.gushchin@linux.dev,
	bvanassche@acm.org,
	zyjzyj2000@gmail.com,
	shuah@kernel.org,
	tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	yanjun.zhu@linux.dev,
	cui.tao@linux.dev
Subject: [PATCH rdma-next v2 03/14] RDMA/core: Support renaming a device when changing its net namespace
Date: Tue, 14 Jul 2026 16:29:16 +0200
Message-ID: <20260714142927.1298897-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714142927.1298897-1-jiri@resnulli.us>
References: <20260714142927.1298897-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Allow namespace moves to request a destination device name. Keep requested
names on the same literal-name path as the existing RDMA rename operation,
and keep teardown fallback naming on the trusted kernel-controlled path.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/core_priv.h |  2 +-
 drivers/infiniband/core/device.c    | 48 ++++++++++++++++++++---------
 drivers/infiniband/core/nldev.c     |  2 +-
 3 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 19104c542b27..3bd5bb7135a3 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -356,7 +356,7 @@ void ib_port_unregister_client_groups(struct ib_device *ibdev, u32 port_num,
 				     const struct attribute_group **groups);
 
 int ib_device_set_netns_put(struct sk_buff *skb,
-			    struct ib_device *dev, u32 ns_fd);
+			    struct ib_device *dev, u32 ns_fd, const char *name);
 
 int rdma_nl_net_init(struct rdma_dev_net *rnet);
 void rdma_nl_net_exit(struct rdma_dev_net *rnet);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b55fb075d0ae..c0b6613dba4c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -268,7 +268,8 @@ static struct notifier_block ibdev_lsm_nb = {
 };
 
 static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
-				 struct net *net, const char *fallback_pattern);
+				 struct net *net, const char *requested_name,
+				 const char *fallback_pattern);
 
 /* Pointer to the RCU head at the start of the ib_port_data array */
 struct ib_port_data_rcu {
@@ -1173,7 +1174,7 @@ static void rdma_dev_exit_net(struct net *net)
 		 */
 		if (net_eq(net, read_pnet(&dev->coredev.rdma_net))) {
 			ret = rdma_dev_change_netns(dev, net, &init_net,
-						    "ibdev%d");
+						    NULL, "ibdev%d");
 			if (ret && ret != -ENODEV)
 				WARN(1,
 				     "Failed to move RDMA device %s to init_net on netns exit: %d\n",
@@ -1714,12 +1715,13 @@ static bool rdma_dev_name_in_netns(struct ib_device *skip, struct net *net,
 }
 
 /*
- * Choose the name @device should use in net namespace @net: keep the current
- * name when it is free, otherwise use a trusted '%d' @fallback_pattern
- * (namespace teardown) to pick a free index. The caller must hold the write
- * side of devices_rwsem.
+ * Choose the name @device should use in net namespace @net. @requested_name
+ * is used as a literal device name when set. Otherwise keep the current name
+ * when it is free, or use a trusted '%d' @fallback_pattern for teardown. The
+ * caller must hold the write side of devices_rwsem.
  */
 static int rdma_dev_pick_netns_name(struct ib_device *device, struct net *net,
+				    const char *requested_name,
 				    const char *fallback_pattern,
 				    char *buf, size_t buf_len,
 				    const char **new_name)
@@ -1728,6 +1730,15 @@ static int rdma_dev_pick_netns_name(struct ib_device *device, struct net *net,
 
 	lockdep_assert_held_write(&devices_rwsem);
 
+	if (requested_name) {
+		if (!rdma_dev_name_in_netns(device, net, requested_name)) {
+			*new_name = requested_name;
+			return 0;
+		}
+
+		return -EEXIST;
+	}
+
 	if (!rdma_dev_name_in_netns(device, net, dev_name(&device->dev))) {
 		*new_name = dev_name(&device->dev);
 		return 0;
@@ -1758,7 +1769,8 @@ static int rdma_dev_pick_netns_name(struct ib_device *device, struct net *net,
  * Naming rules are handled by rdma_dev_pick_netns_name().
  */
 static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
-				 struct net *net, const char *fallback_pattern)
+				 struct net *net, const char *requested_name,
+				 const char *fallback_pattern)
 {
 	char buf[IB_DEVICE_NAME_MAX];
 	const char *new_name;
@@ -1784,8 +1796,9 @@ static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
 		 * down, so a doomed user move does not disable a live device.
 		 */
 		down_write(&devices_rwsem);
-		ret = rdma_dev_pick_netns_name(device, net, fallback_pattern,
-					       buf, sizeof(buf), &new_name);
+		ret = rdma_dev_pick_netns_name(device, net, requested_name,
+					       fallback_pattern, buf,
+					       sizeof(buf), &new_name);
 		up_write(&devices_rwsem);
 		if (ret)
 			goto out;
@@ -1801,8 +1814,9 @@ static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
 	 * level.
 	 */
 	down_write(&devices_rwsem);
-	ret = rdma_dev_pick_netns_name(device, net, fallback_pattern, buf,
-				       sizeof(buf), &new_name);
+	ret = rdma_dev_pick_netns_name(device, net, requested_name,
+				       fallback_pattern, buf, sizeof(buf),
+				       &new_name);
 	if (ret) {
 		if (fallback_pattern) {
 			WARN(1,
@@ -1857,7 +1871,7 @@ static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
 }
 
 int ib_device_set_netns_put(struct sk_buff *skb,
-			    struct ib_device *dev, u32 ns_fd)
+			    struct ib_device *dev, u32 ns_fd, const char *name)
 {
 	struct net *net;
 	int ret;
@@ -1873,9 +1887,12 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 		goto ns_err;
 	}
 
-	/* Moving a device to the namespace it already lives in is a no-op. */
+	/*
+	 * Moving a device to the namespace it already lives in is a no-op; a
+	 * supplied name still renames it in place.
+	 */
 	if (net_eq(net, read_pnet(&dev->coredev.rdma_net))) {
-		ret = 0;
+		ret = name ? ib_device_rename(dev, name) : 0;
 		goto ns_err;
 	}
 
@@ -1891,7 +1908,8 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 
 	get_device(&dev->dev);
 	ib_device_put(dev);
-	ret = rdma_dev_change_netns(dev, current->nsproxy->net_ns, net, NULL);
+	ret = rdma_dev_change_netns(dev, current->nsproxy->net_ns, net, name,
+				    NULL);
 	put_device(&dev->dev);
 
 	put_net(net);
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 32b6c4d68ca0..77a758080148 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1195,7 +1195,7 @@ static int nldev_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		u32 ns_fd;
 
 		ns_fd = nla_get_u32(tb[RDMA_NLDEV_NET_NS_FD]);
-		err = ib_device_set_netns_put(skb, device, ns_fd);
+		err = ib_device_set_netns_put(skb, device, ns_fd, NULL);
 		if (err == -EEXIST)
 			NL_SET_ERR_MSG(extack,
 				       "Device name already exists in the target net namespace");
-- 
2.54.0

