Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB08424643
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208207; cv=none; b=WobAIIoZN3CZT1UZb3qiZfU0yHYqbbA+Tf8Dxw+mrd+7ptU7AZ7LPrIlq2p9M5EtbfrjzS4BoPGJXKhttooN3N8cpTwGnO2kQbsK6OJS9/6AhIWxGkG4YZGPKB1brN7UZRAwfvvJp4CnNqa+NOKP0V2/vCkH6uwkdBRmcl1cLKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208207; c=relaxed/simple;
	bh=fj0Q6ihUmYqKUkY8KaHXFWF5Aioa8BtTYy9MtuieBMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZadmCssyneqGlE9xbO6OUfDf/H0VBv5NqdpyLekyrQk2dIOLAu+tj2A9Q+lMNdxlJbLjpsP0NiyJ1S2FlOCV9obetcIQs/seEO+aFwe9PXMbZRZLwx8EaIfHLec2ddhlEiGaMm1sQ+wteLc8+hi8aaq3U8vSuYkaQkt+0wHhXlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=qox0pSLi; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="qox0pSLi"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49544a80b9dso2840975e9.1
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208203; x=1784813003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q+RolV7SjzshTN5zqSzxTVIaSTGOodHrW0P7odUB/p4=;
        b=qox0pSLiefj3H3b5yXgGce7hMBs+nGwFP0fXP8ildlEPyWKU71V/Mc/7tx2RbhA+k0
         phHG0aca3QdBs7SYgG+hnJwQVpwpKX39JOPQpMtME1P6gikJBkk0v5PX5CZlwRz1WZsJ
         8iCVsVxGrqxkRJBp9caqDo1ON5i09Nws0QKBJNaH8PgPpF2hgkLHHGTI45Yu/yqnyQkD
         Mf22PCSNPxX8QTqLcud/saM45nIDPtMLogkkSNDbON9i4WaLfYpdh6p8K3xao0rASsE1
         jyt3mjXWyyRPovgPNYlD68FzrJJluk9vjuSiWT3d6O3RQPLuwZvlFCgAcW8WFC0ZQClO
         aavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208203; x=1784813003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q+RolV7SjzshTN5zqSzxTVIaSTGOodHrW0P7odUB/p4=;
        b=coZG2Vln69n5jMt5bnK8U0NRU7hwyoXoavMbR1nwge9RUelvsaUm25LT3u0UYip0wj
         N+ucbZzn0yVPy3YX+ksx5FUvwBeKsonZl+QdsVXD0gKhtF2yTIAr50QyfD265scv1sdr
         FZKsuxIjbndvnY3BUgPCE1wa+PzXDQTVhmHBG3nuLyipEQCIBuqu7bxx1aU6jWsZpjUs
         FqZ64tQc6MsU1GvjQlR28YAsk9kD0xzWzcsILgoobuRGPJKLLik+hhdZl6BJIEyurJ6k
         XbMEy1DPo+nen5RjKr5mCWxAto8xf6+UJCLw6jaKGHq6XyZmWxstip8ZfJehSO1ZLGs6
         htXg==
X-Gm-Message-State: AOJu0YzWrm1lgMmJnlD/SslST0+asK8yw7Kq5k3epTKLjTeU9z1lRDyL
	VP6qlu71WHbe9ec+dPe13pnftLZ8QFAj7If1laFgf+TmuY31oDSyjmkNoMzUcNoayG0=
X-Gm-Gg: AfdE7cmIHjwpHtzmHYX/0X3W7x3hXpJVKnongWd4jQuoBzVKwgRlAij6m0nAFj6Nivr
	T2vt2vLHNkliPwHwkBOpamkC1WOxZH8xWmEWXeur2hntt6i6Aa3AY2T8Eamru9XJuVvlNGOA04B
	elPPFLbGBrOTH8rF6mWySoDF1bRGwZGwrzsegUvcx4z0CRbxBZa6Lx/a/zo+gHAaG4mUNJW4tEC
	xgYIFAVwlk5b9ysxJUVoT8b8SDwRxeHDMbmaYfUhaL1FKaN3syv7kzNjzdgAijT4c/tW8mU+Pve
	8TpRoHvCsaUUo8OiHY9h/nt5w7SrJZNBm6YlqHpmybMLpJfK27aSoHT11PadvK5pQGD+oxpbAZv
	6IYMo3lEm4c5EoGlkpNNK3tIqEKY+RefT074lc4IIBYAC++24QdlsCVoKM7hmTZmhTsNQCZspPH
	gVB7m1Rq1zhmlp/GyevMYScQ==
X-Received: by 2002:a05:600c:a00b:b0:493:f261:d295 with SMTP id 5b1f17b1804b1-4953f1552bfmr62260225e9.4.1784208203243;
        Thu, 16 Jul 2026 06:23:23 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541eb02b9sm55456605e9.11.2026.07.16.06.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:23:22 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 01/14] RDMA/core: Pass the net namespace to the device name lookups
Date: Thu, 16 Jul 2026 15:23:02 +0200
Message-ID: <20260716132316.1495242-2-jiri@resnulli.us>
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

Prepare for per-netns RDMA device names by passing the target net
namespace through the name lookup and allocation helpers. Keep current
global uniqueness behaviour.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/device.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b8193e077a74..de610f52c9b2 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -351,7 +351,8 @@ void ib_device_put(struct ib_device *device)
 }
 EXPORT_SYMBOL(ib_device_put);
 
-static struct ib_device *__ib_device_get_by_name(const char *name)
+static struct ib_device *__ib_device_get_by_name(const char *name,
+						 const struct net *net)
 {
 	struct ib_device *device;
 	unsigned long index;
@@ -395,7 +396,7 @@ int ib_device_rename(struct ib_device *ibdev, const char *name)
 		return 0;
 	}
 
-	if (__ib_device_get_by_name(name)) {
+	if (__ib_device_get_by_name(name, rdma_dev_net(ibdev))) {
 		up_write(&devices_rwsem);
 		return -EEXIST;
 	}
@@ -435,7 +436,8 @@ int ib_device_set_dim(struct ib_device *ibdev, u8 use_dim)
 	return 0;
 }
 
-static int alloc_name(struct ib_device *ibdev, const char *name)
+/* Pick a free index for the '%d' style @name pattern. */
+static int alloc_name_id(struct net *net, const char *name)
 {
 	struct ib_device *device;
 	unsigned long index;
@@ -462,15 +464,22 @@ static int alloc_name(struct ib_device *ibdev, const char *name)
 	}
 
 	rc = ida_alloc(&inuse, GFP_KERNEL);
-	if (rc < 0)
-		goto out;
-
-	rc = dev_set_name(&ibdev->dev, name, rc);
 out:
 	ida_destroy(&inuse);
 	return rc;
 }
 
+static int alloc_name(struct ib_device *ibdev, const char *name)
+{
+	int id;
+
+	id = alloc_name_id(rdma_dev_net(ibdev), name);
+	if (id < 0)
+		return id;
+
+	return dev_set_name(&ibdev->dev, name, id);
+}
+
 static void ib_device_release(struct device *device)
 {
 	struct ib_device *dev = container_of(device, struct ib_device, dev);
@@ -1223,7 +1232,8 @@ static int assign_name(struct ib_device *device, const char *name)
 	if (ret)
 		goto out;
 
-	if (__ib_device_get_by_name(dev_name(&device->dev))) {
+	if (__ib_device_get_by_name(dev_name(&device->dev),
+				    rdma_dev_net(device))) {
 		ret = -ENFILE;
 		goto out;
 	}
-- 
2.54.0

