Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAE147F2E8
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 14:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784039390; cv=none; b=ThwkfqbbDp2Gm2NGoJt0UCnJYrxCl5U7MnY+iAb3QDvtwKk0YiyMfR9anCqOMsaFGDZJjMfISywGupcjn+o/pUJj3pM3k5b8dFi073gSQwTM6c/dzUQeGHy14BYNXocfO2MViEVRhUVP47CUC9VW/IZ7dTEmYEH9mpYNLcmNLbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784039390; c=relaxed/simple;
	bh=DZOG7H+X305alvcfYyKRY+OmEfAdQKwMydMDvfsKbqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk9m6kHQIe45VYqLLnH4TGMV6xxZidp2J0ToUf4M/+TfbmsNj65JygchOjMrVGiKWDdsW8+YDzH9yDHqfu8BbNHgQxbu3v/BHsO9wsx0N9AIBCWRSWfzha+eSWBnE4T3yQB6k/svRH0JfRhzRWYrvf9yMEjJEK3UGSjQIUGa7Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=l4XP7SF0; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="l4XP7SF0"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4720d22c94aso1030110f8f.1
        for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 07:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784039386; x=1784644186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3hvdgg/J5f+MIG37tkYT96k3bKW9qtjOneXBYLVa18U=;
        b=l4XP7SF0IByEVKhGr7Vf7Y1yShSB4+Rs/MFo7ues8QMwl7+WB+50t8kXlqdJq7xZpU
         bEt85JrI/XVLxozq0aUkX/M38HpMMwjMag2E5PA/VmhebAXIaSTohdjPF+Os71Jfa53y
         knbZyRJQxmPfR1FQH9+VmjZTRVj1aULztk+OWV/BkaHEvnfVv66vA9HF7/fexINQuvXH
         Pc5wHQRwsQMduR9cUkKX/XXk+B/IVOt32EIP58t4kVQqHWH9IYQURJ0qhDmxS+Rr7K90
         IFHfGe+EvrjW5MoP84+0y9IBwXt41jRuIHe620DsnY8tAdr8nQg08gVAD6fsDx/alodF
         8+bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784039386; x=1784644186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3hvdgg/J5f+MIG37tkYT96k3bKW9qtjOneXBYLVa18U=;
        b=dstJ7kxksEiqlqRZKa1zYOI27JRybQKPlga9fZdca5Z1xKgJOYOT8n7ZV34Qj09Xl1
         NjVwSj/Kaxg5KQZPX7ZAVudedxJNYhBBbamZTUTXecSLrcIq3Dgt3bpjNN/kN7A6V5EB
         b/fnHWMEr2wOltLIKMNhFc9WjdgMTYoQGaXA6uIO++b6XFC+Cri7x+lhsGwWTsnJ1z3R
         A8g7bVN5TYX0O/1PfM9meRQPtm7I95GBN+innDoITPiGuTKPoY2x9dbt8MXAiHpiejwU
         nqSQZTHsjggAsK8rbsKfu3U+lbN6b4iyup/dD4AiFThmlZNqRa6QK/L9ePKJ9rWFSsKZ
         iM/w==
X-Gm-Message-State: AOJu0Yw4U3siVVOlQ92Fuq6SbwdSgeIYunF7j45q2OEXDxQ6jMrBsGf4
	D6eAwIizIP8JfRUkgKupHmhq46iWKdUz8Ybm2sWAJcCfrfSfOJSD3KyRKWkvrAtKao8=
X-Gm-Gg: AfdE7cnv3Pll6XbGpJ4zov70+e6Tgp4AAOIgAo3T3iWcrSDhQESVvEDGUI1VQbjc8Ek
	4ffgHBlDz0hS4VBKdxFl80eHJmENb6R3Xz/xlBNfGRnSSjMPkqRMG1ZCiUlzim8VPCpsofyRIgC
	dyQq/5wxrnOxDCbWMr4kamwvJfuRtJj/u8hWwK8pUqnCrxWN2ZWHKJ3SoBSBrPX9/OY+NdSwJFE
	nAO3tKSxlzhfxfRIN0qB0vRj+6zJvNyZpT2vQ+FqjhuNeediw00yycK5RHqkdVoVLiKMtUxHWzg
	EBaZwmfgPvMJGQinwhFInVQhj+bkbMXKygOVobXHJCWCkspTAaveWyEwOs/RN1nuFJ5w8vjBTUB
	b9ET5dpB/zZeM3lnlnryvWb+RYV4q1W9uPm+A6N23CF6qPRmrMn73q9Xwrg79SQUlQcZmpZb7UA
	VhhnguK+ylqzPSl6QDsN6rpA==
X-Received: by 2002:a5d:5d12:0:b0:472:4861:5d4d with SMTP id ffacd0b85a97d-47f2dcc35e6mr14880023f8f.23.1784039385694;
        Tue, 14 Jul 2026 07:29:45 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4634e0e4sm9076863f8f.4.2026.07.14.07.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 07:29:45 -0700 (PDT)
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
Subject: [PATCH rdma-next v2 04/14] RDMA/nldev: Report net namespace move errors through extack
Date: Tue, 14 Jul 2026 16:29:17 +0200
Message-ID: <20260714142927.1298897-5-jiri@resnulli.us>
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

Thread extack through the existing net namespace move helper and report the
main failure reasons from the core path. Keep the existing move UAPI shape
unchanged.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/core_priv.h |  3 ++-
 drivers/infiniband/core/device.c    | 24 ++++++++++++++++++++++--
 drivers/infiniband/core/nldev.c     |  6 ++----
 3 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 3bd5bb7135a3..aaf330b0d333 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -356,7 +356,8 @@ void ib_port_unregister_client_groups(struct ib_device *ibdev, u32 port_num,
 				     const struct attribute_group **groups);
 
 int ib_device_set_netns_put(struct sk_buff *skb,
-			    struct ib_device *dev, u32 ns_fd, const char *name);
+			    struct ib_device *dev, u32 ns_fd, const char *name,
+			    struct netlink_ext_ack *extack);
 
 int rdma_nl_net_init(struct rdma_dev_net *rnet);
 void rdma_nl_net_exit(struct rdma_dev_net *rnet);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index c0b6613dba4c..366bd8463c07 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1871,18 +1871,22 @@ static int rdma_dev_change_netns(struct ib_device *device, struct net *cur_net,
 }
 
 int ib_device_set_netns_put(struct sk_buff *skb,
-			    struct ib_device *dev, u32 ns_fd, const char *name)
+			    struct ib_device *dev, u32 ns_fd, const char *name,
+			    struct netlink_ext_ack *extack)
 {
 	struct net *net;
 	int ret;
 
 	net = get_net_ns_by_fd(ns_fd);
 	if (IS_ERR(net)) {
+		NL_SET_ERR_MSG(extack, "Invalid target net namespace fd");
 		ret = PTR_ERR(net);
 		goto net_err;
 	}
 
 	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+		NL_SET_ERR_MSG(extack,
+			       "Missing CAP_NET_ADMIN in the target net namespace");
 		ret = -EPERM;
 		goto ns_err;
 	}
@@ -1893,6 +1897,10 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 	 */
 	if (net_eq(net, read_pnet(&dev->coredev.rdma_net))) {
 		ret = name ? ib_device_rename(dev, name) : 0;
+
+		if (ret == -EEXIST)
+			NL_SET_ERR_MSG(extack,
+				       "Device name already exists in the target net namespace");
 		goto ns_err;
 	}
 
@@ -1901,7 +1909,16 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 	 * changed and this cannot be blocked waiting for userspace to do
 	 * something, so disassociation is mandatory.
 	 */
-	if (!dev->ops.disassociate_ucontext || ib_devices_shared_netns) {
+	if (ib_devices_shared_netns) {
+		NL_SET_ERR_MSG(extack,
+			       "Cannot change net namespace of RDMA device in shared netns mode");
+		ret = -EOPNOTSUPP;
+		goto ns_err;
+	}
+
+	if (!dev->ops.disassociate_ucontext) {
+		NL_SET_ERR_MSG(extack,
+			       "Device does not support namespace changes (no disassociate support)");
 		ret = -EOPNOTSUPP;
 		goto ns_err;
 	}
@@ -1911,6 +1928,9 @@ int ib_device_set_netns_put(struct sk_buff *skb,
 	ret = rdma_dev_change_netns(dev, current->nsproxy->net_ns, net, name,
 				    NULL);
 	put_device(&dev->dev);
+	if (ret == -EEXIST)
+		NL_SET_ERR_MSG(extack,
+			       "Device name already exists in the target net namespace");
 
 	put_net(net);
 	return ret;
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 77a758080148..8648e95700bf 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1195,10 +1195,8 @@ static int nldev_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		u32 ns_fd;
 
 		ns_fd = nla_get_u32(tb[RDMA_NLDEV_NET_NS_FD]);
-		err = ib_device_set_netns_put(skb, device, ns_fd, NULL);
-		if (err == -EEXIST)
-			NL_SET_ERR_MSG(extack,
-				       "Device name already exists in the target net namespace");
+		err = ib_device_set_netns_put(skb, device, ns_fd, NULL,
+					      extack);
 		goto put_done;
 	}
 
-- 
2.54.0

