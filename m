Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EA5429027
	for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 13:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784208242; cv=none; b=MHW0B0xwa1yld64gUERlt79cmmCV8OHI2h79LMWLjA53T17z7azPxih7wBvmuR7EnJfdqfxrdx1wGKsGLrLAqsC0+/KmoZqN4Y/COx3WxbWV3UnYFVXEFMQCNxF40ehGgSH9cUSRaS4iIt1hKOqbNFbG+c7ugj4pDgfxPpd9y7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784208242; c=relaxed/simple;
	bh=2JgBpAWc31ZSpkYiSaZDvjmnHKEA4A5V63g6j0fsopU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILQhSXhhIuIQRQ0vkyjRRsRTncerThj2YWwJYIoYLdjL4cspVDXyrHbJHtP1lJKXsMvv4q4oygq24rFX/DWpAg/wsjf9qCp9722mWUlC+cQVVERkmMCsgIBEOsbNKK3DkpJdAWhiuCWPOzjEklhuCURkfDW13hVbzcHF06RjCaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=z3W7Q/Vp; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="z3W7Q/Vp"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493ba701891so27121725e9.3
        for <cgroups@vger.kernel.org>; Thu, 16 Jul 2026 06:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1784208239; x=1784813039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jsn8I3x6C8T9FLWqok7MXQBFznxd0+GMkoGzBjmbnHQ=;
        b=z3W7Q/Vp0l1NU8deNMLBoNbWyYcuLSpHkGAkibaFWx+4p5jEFFZ1wg3/PeOwjquSrJ
         sG7/2NBJZ5Nb3jRXFFnRU9GOGQb3igJw5xW32mJkvID9oA/m5S2Nqb68z9FBTAgmeHXu
         C0LIrMOGkrRSBK8h0FKbm3uBJ7+UnaKSSidEnSMUbdDE7TYfwFQFfIHVssaQMAkuzHsx
         djL8B02CPgRwTlxHvbaAlVARHmjE+8X+af8JYFk1NOPbG0Psv9FNgDpinZEKCjP06S3/
         cN5efKRCLZyH+IDqW+lkn/BoBP6otHCF7S/lk4FepSBtK4mllHKdFLEOQfAQt5TgKepd
         9aIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784208239; x=1784813039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jsn8I3x6C8T9FLWqok7MXQBFznxd0+GMkoGzBjmbnHQ=;
        b=PxdeTdtNCG255l2G0R1hIBdNBTTk+zDxads2h7NQXj+ryjiBRNEyqGBSApxIvj7Cce
         lQnIl/mvgjQ9W/WVkEqyhHnz00pF0xN8/h6nUrA3XqcYklxBUES8pu5ijmLb8pEnbQPo
         TaqP7XaGDePoT1kf31SX2qUqTTBUgey3dAnKhnTUsvU2kcDinTDnf7dwtEhMIR+dtrjf
         ZZ1Xn85x/nv4PA98rKULdTTNyPMakdoRYy8GU1/dcupxR60W6QkUZXgiVj+ZdgbTI6Gt
         R78M3o/9gGQJr4oIxM2CFtebdb949S3msbnvL7Ufc9rqjD5AKpXtx+kM9UHn/XN333L9
         o78w==
X-Gm-Message-State: AOJu0YxNBEen5lCbEAN3G+QQNOet5LAZDlXOo3LxGmOWZU55gBPkeFxK
	vIjDyE/RDfstBBfKG63KVi9GtpglzzeHin/49+49XgcigAhH8uPiJLmyFBN2D0mqbfg=
X-Gm-Gg: AfdE7cmGURcl7c4WwimeWYofFe0z3LfvqiFUUY2MWnl9J15b/66p7geS9qvMdLHxAPP
	VNgJper17EWjbDwssBjyCdxzXrOwC7yQ613zUx+rx8EB8ixGmH+SUC7e2Jdd35HhXuxZMJuw13y
	KeL7va5ZV7z8R4J4AWKTfZIOh3svOzWJ0ZBOmfCY7QEwWiGkuMhhxv0g0CG0EZw9SudfrUUoY5f
	thnnA7/aye7889aM7Lu1EdDl82oUtZSZsn7F2k8f5A/PmqybUfuhgihHMGlPTbTJU+Mz/gIboV6
	j9TxVAqTzSvrK33B3ouuUw8ZvGGDQhnhVTJx/CRcl0JTPl/CHvhzH4RDteCN0iBU0hYc/PQo0Mq
	dB1t5iJY4xRGr0zRBEhygSc/m1gbSKyIiiomGhKKYxbmQug8BA2cohUz8ZFU46F2kJKzmka5ZfK
	spgm5nTB8t9+c=
X-Received: by 2002:a05:600c:6089:b0:493:b7cb:c5f with SMTP id 5b1f17b1804b1-493fa8afbb6mr218943975e9.11.1784208239547;
        Thu, 16 Jul 2026 06:23:59 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e8c47esm60892495e9.8.2026.07.16.06.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 06:23:59 -0700 (PDT)
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
Subject: [PATCH rdma-next v3 10/14] RDMA/core: Document the SELinux ibendport net namespace limitation
Date: Thu, 16 Jul 2026 15:23:11 +0200
Message-ID: <20260716132316.1495242-11-jiri@resnulli.us>
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

Document that SELinux ibendport labels use a global (device name, port)
key, so same-named RDMA devices in different net namespaces share a label.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/security.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 9af31d1d9d70..a82c46965416 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -700,6 +700,12 @@ int ib_mad_agent_security_setup(struct ib_mad_agent *agent,
 	if (qp_type != IB_QPT_SMI)
 		return 0;
 
+	/*
+	 * SELinux labels an endport by (device name, port) from a global
+	 * policy. If devices in different net namespaces share a name, they get
+	 * the same label; distinguishing them would need net namespace support
+	 * in the policy language and tooling.
+	 */
 	spin_lock(&mad_agent_list_lock);
 	ret = security_ib_endport_manage_subnet(agent->security,
 						dev_name(&agent->device->dev),
-- 
2.54.0

