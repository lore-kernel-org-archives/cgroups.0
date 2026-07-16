Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9ED426405
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208230; cv=none; b=uSvTkcOSo/2f1d8WZMrUUO3UZAjG3ytIkMe+i7gnwjHM/4moSCCnTX3i1+4C1DnlNrb9xvDcJcMLD8/AiAGx2T+vgMuycha53TRugx1BUVNcx0TQvHKsezDRuZZvm45OITZOgJXHJ3MujnldLxaoPxSoiywlbHtsasJEMQneO08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208230; c=relaxed/simple;
	bh=Wqi5KzpmB6zpmbpQROgcTMyYw+gD16pJ028ef+YpomU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyRJrbrFmzmC34maZBvZd5Dr1H8QO4kG392+x3jZcANSTyjkUDq1YxLiPfuQAIspV+gOocYQ/6uhh6+r5MFbLgqL4dRTNq4peij213qgEvnRxxmx6Uce4/bclzlPcafaelh1hNh/QxrcWbsivYVVQzVH6YaIXkCrOf9bp8oHX90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=po53amPU; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="po53amPU"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-495441b72ecso3053705e9.2
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208227; x=1784813027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BMcX0YddrsVQYToOf5sZrqslr+alhSoWvC1LhYQrOaI=;
        b=po53amPUM725dcb24/q8qw2miCPBVvTMo9cJ919gRo0m8SpPTdBrQUHhKZCVlqyM/r
         7kPymwIQBe0np1JSaapBk25psoqy7t1ILnICgcUmVFQZzce4h9ZYQfkxDiYIBgnNF/Th
         o9K7FZ8knAihJ3KJnSsE6l5uqUOMOGwhfKt49Q12ehNnvks34Ztl4niyD+fWqZXzKz02
         EhIpagrBcpY8eDuhemvnwmQ1XBxgOxJhk0Cv+R3HHx4kHolYKxRSPepuR5mBpX7lNWMl
         H5FTTmqC3e2zBzFlX3gAK5e++PCAew9gN4GZiIoTshuJPDf9WUh3GT/QTjm2tZkySVXG
         ARJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208227; x=1784813027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BMcX0YddrsVQYToOf5sZrqslr+alhSoWvC1LhYQrOaI=;
        b=N4kf2TYr5UmHZnxGC+7AJ96QjFMMhbbtiRBqVO6vS8b2+jtuUyCRuyF/5W7NXLgq1r
         6VoW4sdDxoH/Fa6yMPzk9+m3tUsoSiUivaVptzcCIl42JtaU/q1TznhDlEYYMehj05wN
         E3HioSjBPlqEGgBbMStnrlCnY6JFtx6GYq2MZor0pt1aIgc+d0+5b6dRnOrOqFe7y8o5
         67qpOPqkC99PE+uR5LLf1VhWEhxwe7Qh63pXBzsotZ+e+peD2Pa4s3rd9javm+M+O9py
         xRiOkAsObbGMH94kd3LFWgzp0jHfX/n06uK50Bi8xdROgpHYmpzXkl0aHCaMZ2BdOC+j
         tnXQ==
X-Gm-Message-State: AOJu0YylGYIjhaIPTqef0vewZ+4kNt298gUAudaUvxPqdicC89E+jEQy
	UrwOoQPKM1vIuYO1WDMWQIIUWIi5B7aEylH4nFuHHEzo3UkxZbD2mnvM7pz2Sn0XiB8=
X-Gm-Gg: AfdE7ckRAI7zWxMxGrgrrkry9DxK96JwI+c428U1opapCeBU8U6sj2OlIYF2siIA4+V
	+vhobHElFkHGRtxlkWW5OzYEppeYVPssk7QGsGZ4BM5KKv6ZI0H22XfCf65FuGVyq87dlDE43W3
	mj+gzrM52QZit1buWC1cjg9i2NEpMTdKmURtrhSXWsUX5pJH2Px4RVXzMODOqXJnxB82qaZlSB6
	XIbUd8QEB+5mnCiyagoVqpj4MoY20DVxmLFCaiLAn8XeshcYNRggT+Eg2+qRLazEXv5JoQFt7Qe
	6Z8UvO1IebD1LBOw09GipvP/Bm5KD132z64WBa6VETxcaQzmySIYoZ1Fr0L0XKLC8tR9e8kzkip
	KiWvsTMUwpuji/qqvjFxXWI0mTttteT6siJO7Z/Z70qlrjclxzQAMT2BjfJzox4+focj0Rl8jq9
	50zTJreiCjGgGlsyo4erhLJA==
X-Received: by 2002:a05:600c:a47:b0:495:4126:1edb with SMTP id 5b1f17b1804b1-495413566ebmr37543415e9.29.1784208226946;
        Thu, 16 Jul 2026 06:23:46 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f464caeffsm23108105f8f.36.2026.07.16.06.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:23:46 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 07/14] RDMA/srp: Make the SRP sysfs class net namespace aware
Date: Thu, 16 Jul 2026 15:23:08 +0200
Message-ID: <20260716132316.1495242-8-jiri@resnulli.us>
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

Tag srp_class by the RDMA device's net namespace so SRP hosts derived from
same-named RDMA devices can coexist across namespaces.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0caebbc2810f..2fc8e133c70f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3189,10 +3189,24 @@ static struct attribute *srp_class_attrs[];
 
 ATTRIBUTE_GROUPS(srp_class);
 
+/*
+ * SRP hosts are named after their ib device, so tag the class by the ib
+ * device's net namespace.
+ */
+static const struct ns_common *srp_net_namespace(const struct device *dev)
+{
+	struct srp_host *host = container_of(dev, struct srp_host, dev);
+	struct net *net = rdma_dev_net(host->srp_dev->dev);
+
+	return net ? to_ns_common(net) : NULL;
+}
+
 static struct class srp_class = {
 	.name    = "infiniband_srp",
 	.dev_groups = srp_class_groups,
-	.dev_release = srp_release_dev
+	.dev_release = srp_release_dev,
+	.ns_type = &net_ns_type_operations,
+	.namespace = srp_net_namespace,
 };
 
 /**
-- 
2.54.0

