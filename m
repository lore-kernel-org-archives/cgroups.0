Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C114E424663
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208212; cv=none; b=UfPpmoXAIcvTpt5Zy8gEiLnDYJZjkIzPA6mmeCTloTzomKd752+RfxTqtcR9YZsOc6XedLNWANyRNaYYSUPIzxCzFTX/S/aTrw/8929PITCr03RG9W9HfvUpgNgeR7Pg32kpw9pwt21Zf/SJEpEwifIScztRi7mAZoxzjm7CzOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208212; c=relaxed/simple;
	bh=xYIlox2SQ+4UB1RFtEe4FSeCAxKFSI3cv55PHK+xnzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIR087EeCZZzPmFXmm80aUje0eMqz55+ScU2/vkR5Y4YR9B5lz6yZ5mYEyXRntyLhQLPeDuCk480o5cp2yUUp1qWIFr4UYpWvpKjb6uoU8MhbAoOVHG6YUfQzqh/isPXz7qb8ReQaaIvpO5ievA/PhLLp2kMlRZlaLxTp57lKhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=DfYB4IfB; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="DfYB4IfB"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4799b3f7c83so4853500f8f.2
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208208; x=1784813008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Egg9UqRa3VYtmMuxvoK7cdAlsyCKR7YQS9Zx9k/wtMM=;
        b=DfYB4IfB9uCXo+xkMPE/Yjwja5stajOy6bNHw1WqxtBpkw2E2AenO6/YC3+DeMlIEP
         hZjy0HBjB/4l8wYGfj05EBEtBwv58qWAdQJ3pOHwchtNLXWTQGA3d4xVhUkCFDNFEb7u
         Lyxcx85FuqVsw3KJ64a/rDnsIcwH0FGr/P9GnHdx2HV2nkeXbqa6DgbfxCi3caoOz+Qu
         YyiM7o8bSHpe2BdPpAW2+hiSaFqltWO0zz7qYjdijAIAJgPLU7Opk05ktdCiiINNJkDC
         k1Oeqzs8UO2dCQXXfsAmi8SIdiYnoYdUZy/USvYwMN2vSS6gJr+JagQDVns8mSh/263s
         m4Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208208; x=1784813008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Egg9UqRa3VYtmMuxvoK7cdAlsyCKR7YQS9Zx9k/wtMM=;
        b=gXNGoiCcE+Z99sfPfZfbxYGe451SOvG6XelJ3oXe9GJeWQi108A7FpadtTlFGKf8fj
         GZ2Jph68rcO+QZCjYHBefAKOz6y+JJzg5BDUkHWCopWws8wxA5axOI4OTiaYxydk68Om
         7iA/6U1zpCzFeHMv6lUxbw86C1lOQSXnH0z1U/Firtq6iDlbmAffz42CmzP5H8OGDTet
         WbJA0ybfx/riehr9ze1J7tqM1fGX1A70BegHuaFCK+nfSPWZFgxQg0K36uu2B3eVF60q
         sMhID9BeW/9sBBiZQE84zo8RMJcCUH3g/o82VYa9TnXn5OgSRNT6aAfCQp1kr4MKkBqz
         xNpA==
X-Gm-Message-State: AOJu0Yx4mqdXZ/Jm8NqU59HOwIo/qEApFBYveJ4682u0swEPDTdRCrFk
	0/3KVT/rnrEjLzhqKzyMqmldGky89LEhez4vLrSkYAgkC58lNYHy+0t+cXIwW5w5nfs=
X-Gm-Gg: AfdE7clK/5ai90SKyoGQS9lY8ibAt3gBNQTpZr4XkeAxsOjYsQen/eaMDjyT6t99O2D
	1RitiH5BFi0dJ/t0MKENrToCG6L+Oi3fiaotqfnDUzbedTA04nTDBcHoVP9SdkHJVhkZN67hxXt
	mz+mxYEN7dzZaJSzZhUOZW4DVEUdNkyOImPt+GXQmhp627Ax4zblJkY3BqpZJ27o2pMI+UpyqZO
	27gxz3kh1jngsQjLRtkRSoJQpmGk1SJj9tqO+PWRrVNp6kPgVqrS7WFKGUVXQ/w+j0N82EpLSvg
	wtT45iwN3l2kCUxghENlGXVU4Mi2Ok+nriuhq0g4h3bebEwD++VDorsZ8YWb05G9Z4PhMjWdHgZ
	3+b9T+B7dvh3lekHblgCfpVQBy1aIRTtYGCE2ieuFFxclDWP13evMf1O1aTE291TqTH9+ZoEFTl
	HJzrS96Bp2O4G4R72DSSV0jA==
X-Received: by 2002:a5d:5d0e:0:b0:474:13ac:a91b with SMTP id ffacd0b85a97d-47f4fd11302mr9361545f8f.32.1784208207637;
        Thu, 16 Jul 2026 06:23:27 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4634e5b8sm22569199f8f.6.2026.07.16.06.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:23:26 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 02/14] RDMA/core: Handle device name conflicts when changing net namespace
Date: Thu, 16 Jul 2026 15:23:03 +0200
Message-ID: <20260716132316.1495242-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716132316.1495242-1-jiri@resnulli.us>
References: <20260716132316.1495242-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Prepare namespace moves for per-netns names. Check user-initiated moves for
destination-name conflicts before disabling the device, keep same-netns
moves as no-ops, and make teardown moves detach from the exiting namespace
even if fallback naming fails.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
v1->v2:
- fixed possible bogus race-triggered-WARN in rdma_dev_exit_net()
---
 drivers/infiniband/core/device.c | 155 ++++++++++++++++++++++++++-----
 drivers/infiniband/core/nldev.c  |   3 +
 2 files changed, 137 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index de610f52c9b2..b55fb075d0ae 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -268,7 +268,7 @@ static struct notifier_block ibdev_lsm_nb = {
 };
 
 static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
-				 struct net *net);
+				 struct net *net, const char *fallback_pattern);
 
 /* Pointer to the RCU head at the start of the ib_port_data array */
 struct ib_port_data_rcu {
@@ -437,7 +437,8 @@ int ib_device_set_dim(struct ib_device *ibdev, u8 use_dim)
 }
 
 /* Pick a free index for the '%d' style @name pattern. */
-static int alloc_name_id(struct net *net, const char *name)
+static int __alloc_name_id(struct net *net, const char *name,
+			   const struct ib_device *skip)
 {
 	struct ib_device *device;
 	unsigned long index;
@@ -450,6 +451,8 @@ static int alloc_name_id(struct net *net, const char *name)
 	xa_for_each (&devices, index, device) {
 		char buf[IB_DEVICE_NAME_MAX];
 
+		if (device == skip)
+			continue;
 		if (sscanf(dev_name(&device->dev), name, &i) != 1)
 			continue;
 		if (i < 0 || i >= INT_MAX)
@@ -469,6 +472,11 @@ static int alloc_name_id(struct net *net, const char *name)
 	return rc;
 }
 
+static int alloc_name_id(struct net *net, const char *name)
+{
+	return __alloc_name_id(net, name, NULL);
+}
+
 static int alloc_name(struct ib_device *ibdev, const char *name)
 {
 	int id;
@@ -1160,8 +1168,17 @@ static void rdma_dev_exit_net(struct net *net)
 
 		/*
 		 * If the real device is in the NS then move it back to init.
+		 * Provide a fallback pattern so a name conflict in init_net
+		 * cannot make the teardown move fail.
 		 */
-		rdma_dev_change_netns(dev, net, &init_net);
+		if (net_eq(net, read_pnet(&dev->coredev.rdma_net))) {
+			ret = rdma_dev_change_netns(dev, net, &init_net,
+						    "ibdev%d");
+			if (ret && ret != -ENODEV)
+				WARN(1,
+				     "Failed to move RDMA device %s to init_net on netns exit: %d\n",
+				     dev_name(&dev->dev), ret);
+		}
 
 		put_device(&dev->dev);
 		down_read(&devices_rwsem);
@@ -1680,14 +1697,71 @@ void ib_unregister_device_queued(struct ib_device *ib_dev)
 }
 EXPORT_SYMBOL(ib_unregister_device_queued);
 
+static bool rdma_dev_name_in_netns(struct ib_device *skip, struct net *net,
+				   const char *name)
+{
+	struct ib_device *device;
+	unsigned long index;
+
+	lockdep_assert_held_write(&devices_rwsem);
+
+	xa_for_each(&devices, index, device)
+		if (device != skip &&
+		    !strcmp(name, dev_name(&device->dev)))
+			return true;
+
+	return false;
+}
+
+/*
+ * Choose the name @device should use in net namespace @net: keep the current
+ * name when it is free, otherwise use a trusted '%d' @fallback_pattern
+ * (namespace teardown) to pick a free index. The caller must hold the write
+ * side of devices_rwsem.
+ */
+static int rdma_dev_pick_netns_name(struct ib_device *device, struct net *net,
+				    const char *fallback_pattern,
+				    char *buf, size_t buf_len,
+				    const char **new_name)
+{
+	int id;
+
+	lockdep_assert_held_write(&devices_rwsem);
+
+	if (!rdma_dev_name_in_netns(device, net, dev_name(&device->dev))) {
+		*new_name = dev_name(&device->dev);
+		return 0;
+	}
+
+	if (!fallback_pattern)
+		return -EEXIST;
+
+	snprintf(buf, buf_len, "ibdev%u", device->index);
+	if (!rdma_dev_name_in_netns(device, net, buf)) {
+		*new_name = buf;
+		return 0;
+	}
+
+	id = __alloc_name_id(net, fallback_pattern, device);
+	if (id < 0)
+		return id;
+	snprintf(buf, buf_len, fallback_pattern, id);
+	*new_name = buf;
+	return 0;
+}
+
 /*
  * The caller must pass in a device that has the kref held and the refcount
  * released. If the device is in cur_net and still registered then it is moved
  * into net.
+ *
+ * Naming rules are handled by rdma_dev_pick_netns_name().
  */
 static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
-				 struct net *net)
+				 struct net *net, const char *fallback_pattern)
 {
+	char buf[IB_DEVICE_NAME_MAX];
+	const char *new_name;
 	int ret2 = -EINVAL;
 	int ret;
 
@@ -1704,30 +1778,63 @@ static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
 		goto out;
 	}
 
+	if (!fallback_pattern) {
+		/*
+		 * Reject a predictable name conflict before tearing anything
+		 * down, so a doomed user move does not disable a live device.
+		 */
+		down_write(&devices_rwsem);
+		ret = rdma_dev_pick_netns_name(device, net, fallback_pattern,
+					       buf, sizeof(buf), &new_name);
+		up_write(&devices_rwsem);
+		if (ret)
+			goto out;
+	}
+
 	kobject_uevent(&device->dev.kobj, KOBJ_REMOVE);
 	disable_device(device);
 
 	/*
-	 * At this point no one can be using the device, so it is safe to
-	 * change the namespace.
+	 * Recompute the destination name under the write side of devices_rwsem
+	 * now that the device is disabled, closing races with a concurrent
+	 * registration or rename, then publish the new namespace at the sysfs
+	 * level.
 	 */
-	write_pnet(&device->coredev.rdma_net, net);
+	down_write(&devices_rwsem);
+	ret = rdma_dev_pick_netns_name(device, net, fallback_pattern, buf,
+				       sizeof(buf), &new_name);
+	if (ret) {
+		if (fallback_pattern) {
+			WARN(1,
+			     "%s: failed to pick device name during namespace teardown: %d\n",
+			     __func__, ret);
+			write_pnet(&device->coredev.rdma_net, net);
+			ret = 0;
+		}
+		goto rename_done;
+	}
 
-	down_read(&devices_rwsem);
-	/*
-	 * Currently rdma devices are system wide unique. So the device name
-	 * is guaranteed free in the new namespace. Publish the new namespace
-	 * at the sysfs level.
-	 */
-	ret = device_rename(&device->dev, dev_name(&device->dev));
-	up_read(&devices_rwsem);
+	write_pnet(&device->coredev.rdma_net, net);
+	ret = device_rename(&device->dev, new_name);
 	if (ret) {
-		dev_warn(&device->dev,
-			 "%s: Couldn't rename device after namespace change\n",
-			 __func__);
-		/* Try and put things back and re-enable the device */
-		write_pnet(&device->coredev.rdma_net, cur_net);
+		if (fallback_pattern) {
+			WARN(1,
+			     "%s: failed to rename device during namespace teardown: %d\n",
+			     __func__, ret);
+			ret = 0;
+		} else {
+			dev_warn(&device->dev,
+				 "%s: Couldn't rename device after namespace change\n",
+				 __func__);
+			/* Try and put things back and re-enable the device */
+			write_pnet(&device->coredev.rdma_net, cur_net);
+		}
+	} else {
+		strscpy(device->name, dev_name(&device->dev),
+			IB_DEVICE_NAME_MAX);
 	}
+rename_done:
+	up_write(&devices_rwsem);
 
 	ret2 = enable_device_and_get(device);
 	if (ret2) {
@@ -1766,6 +1873,12 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 		goto ns_err;
 	}
 
+	/* Moving a device to the namespace it already lives in is a no-op. */
+	if (net_eq(net, read_pnet(&dev->coredev.rdma_net))) {
+		ret = 0;
+		goto ns_err;
+	}
+
 	/*
 	 * All the ib_clients, including uverbs, are reset when the namespace is
 	 * changed and this cannot be blocked waiting for userspace to do
@@ -1778,7 +1891,7 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 
 	get_device(&dev->dev);
 	ib_device_put(dev);
-	ret = rdma_dev_change_netns(dev, current->nsproxy->net_ns, net);
+	ret = rdma_dev_change_netns(dev, current->nsproxy->net_ns, net, NULL);
 	put_device(&dev->dev);
 
 	put_net(net);
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index aae4f3f6bcba..32b6c4d68ca0 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1196,6 +1196,9 @@ static int nldev_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		ns_fd = nla_get_u32(tb[RDMA_NLDEV_NET_NS_FD]);
 		err = ib_device_set_netns_put(skb, device, ns_fd);
+		if (err == -EEXIST)
+			NL_SET_ERR_MSG(extack,
+				       "Device name already exists in the target net namespace");
 		goto put_done;
 	}
 
-- 
2.54.0

