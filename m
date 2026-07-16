Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BEC42589A
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208226; cv=none; b=B1lfwdfAxsFXB4ZgsDhEnYE6R5z8HSMUl7l//F4p3OASQj92xYIXFLdoMepsdFl6x+Bz8bGtpCcSm8XvKmaehcYKcrZdqRPyBT9kuIZpOQ6o1NCwCH0IEMm6/qeOb07fkNb/vcpgosVVrS2eSuH6pQ6AJqDcxIBquLtncweSco8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208226; c=relaxed/simple;
	bh=pdMmpZJCv+StAJxQjGBnq4nulDEDCbuKp7xLyLbTHHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZH4/v6XUEQaOSUVNhoehDlgtannTalvlMUeix+3iJlL8ZzYjlMGHUndzQKMmBaQ019C67kxcf5VZrHPwgMcOjWuiw+LBMN7/vOG6xARc95WwKXlK8mnSwVE1bWXj1PtM6xTFGJ3snfeI+VjgK//geXJFjnwH/sM2WnRiI0dLvI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=Xd4sPgdG; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="Xd4sPgdG"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4758bd3731bso494244f8f.0
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208223; x=1784813023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NfMuLF2nfHbgRgmO34SL3Jj6SviYlx2uzsjm64OYl7Y=;
        b=Xd4sPgdGg6OzjN4YUnTbRDwN59GeQ52siqSP5qyS3L40sUwMWUEj6rtmn//dzLtISB
         jDhOzNMjXJWY0UzUw7c5kj2+G8b0sk9+Wz3KCPdkhVqmgmc59ZfX1YJ21AfQAvOAYGAk
         DBR/s6goyDzYVHdhg1qREYw8Gl4UHgLE+3hoPoU317CrjaMxVSN587eLctoSfjZpNMdd
         GeH/3ie21YQ6ZH0FWB7DJGajs8V5BbfIapAVco1MwXYjU/Y7Iijy7HvDG4s1GSl3E8en
         Wx8yRZ+fPVN2Gb0aVlnXJG7U4QGkA/jQSljGNom4fvLgdiVyXJSYOdxK/nV56K0xVi8J
         oQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208223; x=1784813023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NfMuLF2nfHbgRgmO34SL3Jj6SviYlx2uzsjm64OYl7Y=;
        b=iD7BlNS3/ZM0sPJ3o7kWGW3ari3vS04cOfYaAApnVoc8nDXaGvg5+VNCeYdt1mIJSH
         IRIQe3UEe6sFZ0FscUrXFJVMSrC7p+BRh8oQbB8vIjzf00bPaJlX/LGCELp5a5qnnK2R
         mLoGmcTnvq3HT6Ns/srM0X6b4NFvW5PDt57UB0CI7JNl1wsBxmkEr6fVBwhgyhvT5JZr
         8szXuOAmDHRQeHInc/jHsP7zFBSpX31cdYik+mYHDtvOl6vNdYPOZ+1ALiE/TR18Zq+J
         VBxSf1k4+p55QHlKWBO2p9muT2/OiEYg7bQ3KiFyG3TR2w4RuLwWzjooxbSp0D1kIBXa
         OrWw==
X-Gm-Message-State: AOJu0Yx5EEVbw+epHuYQ2Y9Jsy8eHT3N4mZip8tvSmrL0/R8WrqrquaT
	4Akv4BQV1l1CRI+ZpOozIfZ1h06Fr4aNGB3hcS9MiigmR7Ju+cFQoh/ivjb7D8p90vA=
X-Gm-Gg: AfdE7ck442buIUYoKPjrgjgUt0rACU65AjlTzpfaykObLaBeIo3+xb9I41j1Ncxy07A
	C5VWIEGSA/zT/l+TXicrgpuifCHamzJghTG+h+U8Nl16bVUP81Zb9Up5SE2e7C59USiCE/qV8QN
	MI2eKYEAdxkqcrFmDszbs4Bz9LxIKP6+df3RUQiB4YgztVNMOM3dm3bVZRJXY0PrPiO8bpvQB+c
	gE+b2IE3QjAV3BIXCsKF01GVoDBvVWt99YY+0juHwCX4Tesl/mRth/owTdg4Nz/SEbxbfRY9mvZ
	UHvxg2FAVb/9Adrwd5KihSByMgt6xC2VS1tUJKza2qdR1AmUG0OGWKZEs7YHe+KIIdrPUBTQ9+p
	rzbBmZAwH6gcFOyyLe8YvWEQ8rBEP9vZbgoZ0ZKkaEz06t11FFegmd/6ogYN+qdJYElxoL26Wfq
	ezztZSNWhfsOh+mlX2zSoB3Q==
X-Received: by 2002:a05:6000:26ce:b0:475:f0c2:75ad with SMTP id ffacd0b85a97d-47f5a538607mr3085824f8f.24.1784208223044;
        Thu, 16 Jul 2026 06:23:43 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4634e029sm24529624f8f.3.2026.07.16.06.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:23:42 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 06/14] net/smc: Look up the pnetid ib device within the net namespace
Date: Thu, 16 Jul 2026 15:23:07 +0200
Message-ID: <20260716132316.1495242-7-jiri@resnulli.us>
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

Scope smc_pnet_find_ib() to the caller's net namespace so pnetid setup
cannot bind to a same-named RDMA device from another namespace once names
become per-netns.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/smc/smc_pnet.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index 63e286e2dfaa..ff9c9c35cc2f 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -304,13 +304,18 @@ static bool smc_pnetid_valid(const char *pnet_name, char *pnetid)
 	return true;
 }
 
-/* Find an infiniband device by a given name. The device might not exist. */
-static struct smc_ib_device *smc_pnet_find_ib(char *ib_name)
+/*
+ * Find an infiniband device by a given name, restricted to the devices
+ * accessible from @net. The device might not exist.
+ */
+static struct smc_ib_device *smc_pnet_find_ib(struct net *net, char *ib_name)
 {
 	struct smc_ib_device *ibdev;
 
 	mutex_lock(&smc_ib_devices.mutex);
 	list_for_each_entry(ibdev, &smc_ib_devices.list, list) {
+		if (!rdma_dev_access_netns(ibdev->ibdev, net))
+			continue;
 		if (!strncmp(ibdev->ibdev->name, ib_name,
 			     sizeof(ibdev->ibdev->name)) ||
 		    (ibdev->ibdev->dev.parent &&
@@ -408,8 +413,8 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	return rc;
 }
 
-static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
-			   u8 ib_port, char *pnet_name)
+static int smc_pnet_add_ib(struct smc_pnettable *pnettable, struct net *net,
+			   char *ib_name, u8 ib_port, char *pnet_name)
 {
 	struct smc_pnetentry *tmp_pe, *new_pe;
 	struct smc_ib_device *ib_dev;
@@ -419,7 +424,7 @@ static int smc_pnet_add_ib(struct smc_pnettable *pnettable, char *ib_name,
 	bool new_ibdev;
 
 	/* try to apply the pnetid to active devices */
-	ib_dev = smc_pnet_find_ib(ib_name);
+	ib_dev = smc_pnet_find_ib(net, ib_name);
 	if (ib_dev) {
 		ibdev_applied = smc_pnet_apply_ib(ib_dev, ib_port, pnet_name);
 		if (ibdev_applied)
@@ -518,7 +523,7 @@ static int smc_pnet_enter(struct net *net, struct nlattr *tb[])
 			if (ibport < 1 || ibport > SMC_MAX_PORTS)
 				goto error;
 		}
-		rc = smc_pnet_add_ib(pnettable, string, ibport, pnet_name);
+		rc = smc_pnet_add_ib(pnettable, net, string, ibport, pnet_name);
 		if (!rc)
 			new_ibdev = true;
 		else if (rc != -EEXIST)
@@ -1170,6 +1175,9 @@ int smc_pnetid_by_table_ib(struct smc_ib_device *smcibdev, u8 ib_port)
 	struct smc_net *sn;
 	int rc = -ENOENT;
 
+	if (!rdma_dev_access_netns(smcibdev->ibdev, &init_net))
+		return -ENOENT;
+
 	/* get pnettable for init namespace */
 	sn = net_generic(&init_net, smc_net_id);
 	pnettable = &sn->pnettable;
-- 
2.54.0

