Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157A4403B0E
	for <cgroups@vger.kernel.org>; Thu,  9 Jul 2026 09:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783590962; cv=none; b=KGXgFM6sxL3YDwYHbFfGv5uVWKN4msNOERBWN4QWDkEExNtLSjFYbkaPWQm68ahSVhtkX748VvPCSRbnk++DxwiyrkfOPZByv3pTz7UWKNH+wTtF/yEkEvSZ8pP0/TX10zt8nxREY2mzcena0RPYLySTzmvu16XjmBLyQH7Sc8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783590962; c=relaxed/simple;
	bh=awVS+vQGfFNww7dDbkg0d58ZIZ/RFJpwp0CqYWFg7yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUwUlzRqsmz8uJH9ouKVznuP2JSimVTEoZqVJORhtBENdEXv6lFV+U2+Zl9s7D42i8lVdH53dVXOYMGdtdqoX7HYAVdNX1C6XLDSM10TE4fs0uOphbvc7uQK9636jZWB0vEzG+LqhmwzMf2NXRnDXUzHEI1jjPW2021lWtmbzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=yeh3j9NB; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="yeh3j9NB"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47df6a5202bso311260f8f.0
        for <cgroups@vger.kernel.org>; Thu, 09 Jul 2026 02:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1783590958; x=1784195758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F3yvdJf8rTADXlXQqLGp3uJl8dCU4opoMAKhUr4P3so=;
        b=yeh3j9NBf4Uy8nYz2Tlz2QOY4RKLaAqKG139KrLDfIv61xcfVt4SRgLF9QO+2n0IM7
         xWpvQWE+xVIBthY/C4A5fUZGVs1WwOvLjgpNxvC/RLcwK0KtRw4SVKlNY3gAAUxf0fpM
         6dMBnfrd19qHrh26U1EfBpvIeMyoijg7Ow7rFEGpI4HxyscaUULxCr7HZrAnKzAr6IFd
         mMJSC9MaHjUGRNNUVrQGP9vIxHurx6fwkS6YIgj1A+t3K7Op/nH0jIkspSRNWWey3YBf
         bS72jnvs/ZLrH9YwEEnN82thwsj8iYH0N/m/97khkjmNhS5jgdI0aGRoXIiBmRdmZNP6
         tFwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783590958; x=1784195758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F3yvdJf8rTADXlXQqLGp3uJl8dCU4opoMAKhUr4P3so=;
        b=LB2CjYx88KJ3rimdgR27IPkKkC1OAr2bRHrbS+AnW2iyyz6kh6awBFyF/GRbSehBDw
         HEUHX/UFxHD9a1KHs1sGplL1Rv0ldaWHL9JJl/zGJGczaHD5HwKPLtW0Z5xkUt1QOyRn
         +dLNZ3Wv6gxoEVerIW9URqOECDqXBCns7jW0WP1NoqA+fYMUv7JWf5uDbRecQKCruM+S
         0vdnAY6cDKFNbWO0blqEhPsgeZd/0qArAqxew1rjTsZS4ctDpgeHQl5qx7w6klLXEu9T
         8wz22LCoKmQFAPX8scB0zd1JDny/foNWwf9EqflnjJTEGiFB8B+Ihf6blq3Tko5uct12
         6l1A==
X-Gm-Message-State: AOJu0YwefcYnowwN+WFp74FgG1IQ7YTNuWGnlUU0Yy48j+yLAGKiRGYV
	4ZL99fuBpJ6rYb8zNf1sIsh+6V5bP24X7aH5FTC32E2KyTsadmyTDS1TRrlMeIxJOTk=
X-Gm-Gg: AfdE7clegZCdGx4eu5EebYMDTNH9tCVwoCHL4k9n2Hok6rk2b2PbW46H/CDfHti21qb
	QnO7NzsIm8ovbbHI0o2HegWWwCzTyHOTxzznblKG4LveGKthArOh9a0QDI8mtYyRTQ3lr8hjb95
	xd8G/os+SLHVRJpYN6gdtBtKIk9PsWHroBkHL4Afab4+Qc8e8v4juAugELYEqTXwIgmHAdre5Ld
	w9VuXtpRNjAXsuBIgkodVJ7tGk5i144QrBvOsMeEk3Ykb77S4UbAdpJfhY6xnYdc2DtD83g8e/u
	42vLHl+DKbxQ+i8C/Ax1bub4yXTJ6x1QXULIHlDIiZArw5wOnwLQUDfSvBCgXPSFDphhCrI2J+h
	ODlGh2tzdtszK9Y27y2AYv4pKrlSq99TDg8ZNmqhUW/oCdzqp4bF9ez1FtW0cwtNSYVqVU0tp3T
	XJkSyiiNlseeCpzmo6NWeE02kywz9Rnr4M
X-Received: by 2002:a05:600c:3b05:b0:493:a966:d5b5 with SMTP id 5b1f17b1804b1-493e6859787mr59433245e9.2.1783590958491;
        Thu, 09 Jul 2026 02:55:58 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d905sm52753503f8f.2.2026.07.09.02.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 02:55:58 -0700 (PDT)
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
	wenjia@linux.ibm.com
Subject: [PATCH rdma-next 07/13] RDMA/srp: Make the SRP sysfs class net namespace aware
Date: Thu,  9 Jul 2026 11:55:26 +0200
Message-ID: <20260709095532.855647-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709095532.855647-1-jiri@resnulli.us>
References: <20260709095532.855647-1-jiri@resnulli.us>
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
index acbd787de265..a070fcf86e8a 100644
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

