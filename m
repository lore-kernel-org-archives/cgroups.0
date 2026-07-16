Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5343342089D
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208255; cv=none; b=YZZ/i0i5QhMUs4JUcSM6jy8jcPGt6hDej5OH2RbEPnvwkZQ/tGBCyQ2d22edlmfw+CKZDsp13KYP7B+CtJN8QRZCUPGupQdHEoxdVFubOm+udCRIXlN0hTGkUGN7KUCopSZCp/1/szlCxtey3dpj49U8MizZyZ9InzQjmJ6D9W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208255; c=relaxed/simple;
	bh=AlWKq+WCpJ6jqrd7bHxM+xUmQDKopJjD0aSNOnzQ77Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWyoxt1QnMYOXNlhqTm7H7V8px87KJwzVqz8tTpCeSp2x5bmJ0pnQC4kH5YLaN1slJBKuy5Wvr/BZOZ39dtQk1caC4sBOU53+ryYCkccvulVSXWcm/y8e/F/52tidsDMx4dedflpnkHeBvotwgOQ4QYSJ+8PrZp1t9j7RimWlVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=aK/xlwyR; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="aK/xlwyR"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4720d22c94aso3620211f8f.1
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208252; x=1784813052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1DAcALuj6CLiGGxg2YU+zPjUKqyxKHB8HUr7MGOtyF0=;
        b=aK/xlwyRcYirN7ICoBf0lJ027CM8hLttQV81AjLGsIcIvSiFSbxiuSeEibSuobxumW
         /wviY8uNpD24UvLTiblcGrn8+4Lptnn87Ed4oze9bPV5/ICJPRu5sbdk3OiBPuiaspjU
         B7UcJm+YR1hwsooB3YAzdEgrNEVuh9AS3EVMCT4BuEhGrzfwMhov7uD/A26NC/R4xLii
         v8BHPbIwt+ZkO9QTlwOrd7UWxlBrj5QOJAMxOIqz+JHEzSZHloswLzzKpzkieZY9cprx
         xtHwp7KgSnWLJcOnu7Q8ZfA7sCuR1b/8bqYwsMQFwgdDbAUMIm3WT0lwl8RGcX5X213E
         XqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208252; x=1784813052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1DAcALuj6CLiGGxg2YU+zPjUKqyxKHB8HUr7MGOtyF0=;
        b=kqn+HlDBzy9SJ5J/IG4keR6JBqevArwsWxzyIADRNL4kahlcil8dYfi3m1bSVn20Sj
         TVJNZlBnGQ7udbpu8ZHnXEl3vkyWuPFiuiekc8HshpHN1GoMyL9/4NTWQxxW08hPt5kh
         ujPwqgyPkdGe2U4YJ99GSyCP+/clbwhhk7wbOfXsDRTSSiUZ5PKas4jGfUPL9rOqz5bd
         H0OJGPUsjPPqRlw8AOE7TST5/3N/wh0ydYxKTHOHr5+eHq8EDgLD29lwdSg3Jz1w8qw+
         qC02V6MqqJb/8AqiPtsv7Fh7l8JARvf23prF19B6TibuqAUJCzNnO5esj3+fPupdAdJL
         qQcA==
X-Gm-Message-State: AOJu0YymGwP0SMM4nowHPnwNdOEEgHZCCG1ndQ1Me2jbnrwtJA1gUO/v
	kBk8PH1amEDM6wLrgX9ZSVBfm0ZtO/fZ2yiJlYcCCJN9Q9ku+5NlVPHDuMjWmoNZ280=
X-Gm-Gg: AfdE7ckVRR7IxnHLwLkSFon2UkELTmQ2fnTwJ9tpjwKNqhafjIQmuAPAx+P3mT+fJGy
	ll4Z4hB/gwZFiVPr+BKLoMCpVfRjlUiY5Q/IXJlSRjV67kxGfWPHsbaXJG7fMvHpBBhhXAxk+/g
	uc4h2SPWHs6Rh0/9iPIy5PXPKqgQV0bKapNZoD16ZxU8U1biEsxDrH4gj3AAL17m3rwssWI8xwP
	eFx7MuMu9KvJtgV9spFYnbs/AndxI+I1FUbpdq8UTjpbaYKKiIA5gBA0QUHpHMgcNiuHD/5ET+G
	vJmcLUoZp9/BMhG3PtsSzd+PjNHOGx/k9GENLq9QNggsAdb+l21Jp1Q/0VlLUuZeCRSm16NCoUE
	H/2JD9HwKkKat3tuDfkyImsNucuherCAg5mdzcvvkiE6wlYjxU8G8KjJQ1e6UZrwce67YAESUgg
	7HyDeJjlY26I+RRqc+laN1ng==
X-Received: by 2002:a05:600c:6287:b0:495:4749:16a7 with SMTP id 5b1f17b1804b1-495474916eemr1028195e9.14.1784208252423;
        Thu, 16 Jul 2026 06:24:12 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a5d7sm23813896f8f.10.2026.07.16.06.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:24:11 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 13/14] RDMA/rxe: Implement disassociate_ucontext callback
Date: Thu, 16 Jul 2026 15:23:14 +0200
Message-ID: <20260716132316.1495242-14-jiri@resnulli.us>
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

Implement an empty disassociate_ucontext() callback so the RDMA core
can move rxe devices between net namespaces. The core requires this
callback to reset user contexts without waiting for userspace.

rxe needs no teardown here: its user-mapped queues live in
reference-counted vmalloc memory (see rxe_mmap.c) that stays valid
while userspace holds the mappings.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 1ec130fee8ea..6eb10d2f0653 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -240,6 +240,10 @@ static void rxe_dealloc_ucontext(struct ib_ucontext *ibuc)
 		rxe_err_uc(uc, "cleanup failed, err = %d\n", err);
 }
 
+static void rxe_disassociate_ucontext(struct ib_ucontext *ibuc)
+{
+}
+
 /* pd */
 static int rxe_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 {
@@ -1478,6 +1482,7 @@ static const struct ib_device_ops rxe_dev_ops = {
 	.destroy_srq = rxe_destroy_srq,
 	.detach_mcast = rxe_detach_mcast,
 	.device_group = &rxe_attr_group,
+	.disassociate_ucontext = rxe_disassociate_ucontext,
 	.enable_driver = rxe_enable_driver,
 	.get_dma_mr = rxe_get_dma_mr,
 	.get_hw_stats = rxe_ib_get_hw_stats,
-- 
2.54.0

