Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8F547F2D1
	for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 14:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784039402; cv=none; b=MexJBr9+H861FGhzKEujBe5QmsamJp0+VKXyqBKTOMaSLwMxzsMPfSlxelXvyCb6fgJmaP+4+GrVbVkojy30lJZl3CV7ddNckms7/8lQ9ttRv6rmbLoUGtKuDSTnyiNEvulrNxw38semh/MoVKGgC3Stk341ruM1WitBpVJB+lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784039402; c=relaxed/simple;
	bh=Wqi5KzpmB6zpmbpQROgcTMyYw+gD16pJ028ef+YpomU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX+EegoZThI+py6gneCtjxT2AfkyaUhS/FbQS8nVafHOzHDLN/FTMrsPIsiEM8SQBpe0r5MfvkOE7Aa0LtssBAwdQ2eUJIL9RwtxkZxWWQTqHeMcSjZBYNjYnI6hAbVGSxbCEN6yjS9G/keZU2bSotcMbACrfGlzMv7j8+YBarE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=ROaTHZn8; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="ROaTHZn8"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493b7612475so34287245e9.3
        for <cgroups@vger.kernel.org>; Tue, 14 Jul 2026 07:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784039399; x=1784644199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BMcX0YddrsVQYToOf5sZrqslr+alhSoWvC1LhYQrOaI=;
        b=ROaTHZn8Wm29bXZ0bh7lCjmoj53KRSEY1vVFPBG+vYjkYONxB4P8G0AzO9FvDfDIly
         pB0dWkM+niVBfBSjyrtYQVQRncg1hIglMSXasgErlopNQEoF5v4ecwrMjKzvjj8olZSb
         NynmDscV1tkB+qBINXlggCeqH4fwmNNOG8iFDOUKY8DlfRz1yX90KNsH7lwjSstKLqcL
         /ajRWKRv8yChiD/rTcNGxB0q2y+MlAtQ4EEIqGOZ/RztMu67s8HHfq/aQsXgc8ltE9CN
         zMRqR+6anCgw54BVB/2GCVbW3xxcu5lSvCho2+BFVjLP66oJPYdS5c8tKXSMLMfEXGGZ
         z84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784039399; x=1784644199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BMcX0YddrsVQYToOf5sZrqslr+alhSoWvC1LhYQrOaI=;
        b=lCJ/Yt6iuAQPBLvbaciYLIZsONYsqYZdoaK2MarQ+8+LsIf6YPoQeIdHTitC0S0Q5K
         +P+AC1PNWvSwDnstVdj/An5DNlgdm/ThoHEp9pO6CD9sAaMCWogDJVmNrvzsDy1JVaAu
         2Cb7eRjPUu6snSsqQbdlkJ8sLPaLDZIdFSEj/FyHWbZe7T4HDds7vpqYVho1BoBJWl1K
         eG6vcrYWALrRcl4OIwbY7ch5P8htFmanoqjiAkJLVCk+WUOSRvBJSy/bSQ3rn9thfn0f
         i9YZhkf+HgXOghT7w2KKMnosVm2+ycJ7+QQR20tlUrFZOeFL3zCfxXJHQW2+cYeTATXg
         i5wA==
X-Gm-Message-State: AOJu0Yzw1bOvZLteMj+nd/Sx795bO/vbyd0vpTj1Fxz+kKTTttVKMl/f
	Y//iSyXWY2IU4X4z5+fZWrSsJTft07eBflBfUeYP3yfz5DLM9u3LPJ+QcjLXZjZQLLBNtgKKzIP
	Rgku8
X-Gm-Gg: AfdE7ckkeLn3C4lFp05JHvJrmVoj+dl/AOfDVaqXiqSFDHtDl37cPyxOtJtLh4Qo4cZ
	ezgSF9SVvDhvjhoIL+PvuKWvnOeWHKE2rtvZ31RpS3WLX/CD+3+CN8EQHUG5t3198Yi6eyFNZkN
	+MjjXDLUdxjzfipbFNaclv5lgduhT4+JIwO0JBGFstH9ayqrWl1Qgzr4Xh0O5guE1sHoOqqo+q0
	9QfPvP3+aKAQj2iEe1LOrM9RwhacfIfbFZ0j4zyErw+jvuh8keAjorShfVvuqdVto0/2jZHGHw5
	WZXHuFa1Pt52sbxLHbKjnn7sFlZ1ffcoD0hYt3f66cIkl/kKMwUKYHUHzPwbp17TFXEMq+H25K1
	I88UQVrcQ/Fs8OHvEkO9e27qlIDYoW7TNSmPsSoiVes30DkTzBGqifoIwL5tt++DIAU75iCBoQZ
	F+Ug/tz5bX4yP59vj8xBiIpw==
X-Received: by 2002:a05:600c:c04b:10b0:495:21e7:fd53 with SMTP id 5b1f17b1804b1-49521e7fd96mr32781175e9.18.1784039398693;
        Tue, 14 Jul 2026 07:29:58 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950871d1bdsm79306125e9.1.2026.07.14.07.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 07:29:58 -0700 (PDT)
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
Subject: [PATCH rdma-next v2 07/14] RDMA/srp: Make the SRP sysfs class net namespace aware
Date: Tue, 14 Jul 2026 16:29:20 +0200
Message-ID: <20260714142927.1298897-8-jiri@resnulli.us>
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

