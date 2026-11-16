Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.193
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819940;
	b=4qvFKRPXOv5A6dI2tUQtJOHGU9BFIJSphKxsda5jC2DbWKzEfxP56cGtJe5X4zCF4m1K
	 iM6vaeragQl5gmAgUSAxaQq5LOd04Y0xREsIB4zn+MAqlQd6qTuAJRicMWnwUa7VbNvLt
	 5fLEglOdhvAOMOTwmo0ep6iGLIoMIYQoZiXiLUbqLzPjkYV2lXVL2CvsV4r4Re1KgcXbj
	 /Euga1pfkdEKyk7oHWNpeG3Kf+GpximGpug53TWy7VaHsQredzPKLNEHHlV6Cb326PTDm
	 mK5Aqol5+FmpPTFAK7Gn/RsCXeICZqxfVKqAwFkiOFm4h4cNNC4hpQp5TQJn48MBesw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819940;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1zvuDxYaIx+wRq51z8Ba2c/DCwXwLVuqXqRa+7I8efo=;
	b=y1lKZ3YVY6jMSJNewTy68q63+ajVYvPKg4DM/rdXlc1XyZwjEhiU7nCsN4GEbKIb73Cm
	 +8RQiiYsTAoKqh4+uJzBSZtFqzjyn4GWQQkWELkR0xMa60tK1eFxybcPhilv4TNkyG82i
	 JOdsxHzibCCwHq42TwJROpPKtWYkBMQJAeb7CT9zzHYmw7rJFql4XxHtbtbkrHloPQ8Uz
	 gNSDJCdIOfhsDn9E8k6/xe9okVQ2EM/rzSNqaaZ6k8tij/l+ousXo0I+mkouJ8eNMzVKb
	 I010Nopd9QywfHt27O+7PLRjcIjBsxjk0/+hYfAEM26oeypajzvy4KQqMeKStWzsPDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Matny45j;
	arc=none smtp.remote-ip=74.125.82.193
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF37606A31C
	for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 09:05:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEF37606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Matny45j
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-37198ed3727so4759747eec.0
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 01:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794819939; x=1795424739; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1zvuDxYaIx+wRq51z8Ba2c/DCwXwLVuqXqRa+7I8efo=;
        b=Matny45jJHPjIWXkekS7kOaHLqe+34gj0u7udcwy8lDdIpS68CDXZP5LGnCpltTdf+
         dzp/fnKOEMmaGI2fJlFpKanKtIdr7KPLjdLdrRYri4pE25TITMaUdT3FOmIATtX5fB2W
         nBBvWs1vdMfQTQ3F33nHPrTeDv2CfPsMiyqE88TtvyG0ze6XcceBvRd7KNPsvwIRkFip
         MpbN2yeEb0EOPLH8gMB2g2syFrjEUZigMpOrWF69szbJKNM04yRNSM47T9TsibtwPqcz
         sIXARK5Wf4QMMZrTGsCbgtNASTFpP02dceQrq9eYFBaw70YmcwWo8ApNHcYS0cBj4uVU
         y0Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794819939; x=1795424739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1zvuDxYaIx+wRq51z8Ba2c/DCwXwLVuqXqRa+7I8efo=;
        b=Gf3VSt3d2xWaz5a5Mg9CH8GcHnSpWj2XSe8dNFpWdP7UnPuq1ClXcpna0VlmM/c769
         3/PT4oH+ZkCAvIso9SoN5NmQWj6W2bg3MhaHP+ZU+NWo7yw6iryPSkIxChXgEFNg9n5n
         zOYAVpCqKho+jMaqj5drQTqLkucCd/gYX/K+6a+YCKZYDb9MaAMKr3G3BTBYitELVG5f
         1VDC7GfcTnek1rxeIYROxrsxmxIFucBEVzZ4psrK+E8AjLtoflvNqFpTGI+PYyEHGO+2
         WzXnmRi8B7FeiY5lNaye2ritiJGdscX9TqSItZOYzeTzgWWG5SvzRzCpEH/xO3yjpwl8
         Z1gQ==
X-Forwarded-Encrypted: i=1; AL+hErFswklF+7E5Z6DZ1RLFCDti9Im9OsRASZYeDe7DX+ttrHleMFhnpL1Olw/Hj/dAw36v6eXbM4o2@vger.kernel.org
X-Gm-Message-State: APuU4Z/J7xWZEP3osvIGGeWQbK9Q4e2aSss6JSvxHPRSaYIjhhrCTYH/
	LdvnGO4GOgpumj9tecG4asRzGTIG3nwEIFd1H9g4GeglsZ4U3yCqBMuM
X-Gm-Gg: AZFdTZddy2Cmrs/5Helr6+RsOeP4Df4jyNXOpTrzZ6MS4kl79FvThtx/UVzzWvJKiTU
	viiCCpqCOTyCI1yOoEslKRZ570IXBPlxRUTX+xBMLYZk8cLt9si5y6GRuwVTrplnszryS04g6cX
	23g0wq46S3PaXNJA3Qk3bb0YhCbKcNcCp9xZhmxpR2KJ7nZHcfkRJDnTWHjr9pIgGKOBb5k4/7U
	bDOw/ne8GRNCbLhS/Xvu+/C4A+WWri1y7MCUKXTfsd5hlHltMHkb65VP62DJw2iLjl40GwY4gCn
	72+GfX69m5o8FHxZU/qkzUKpWdmuIhBuzzsjMHp8AOr6ScfiNVWU08IKRUQ87lc91i7q7PMIr0Q
	micIrJIqOCpxMJ0aZxTHQmnrzK9yHh2mR+FSxvifONwTrqfDPooW24sB5PiEF1PHvFjxcNuWucd
	FaUVCsQVYMNqG9LFgq22bh1goTnFjEExdUiaj3GWC6VFShl4JPGq9m9mXZ6uG2hIcrynPrlpFMI
	iWMK2ZYeb7vwWaARrifUcVX9zOIay6zsFiByPM/PMHWstEFE2VofK89sbf++B44LbV16fLaVerY
	iSQbWsh3w+62hcN8INiCiHP6CvGr3B2xJP1q2nuFELMZDfTcR6I3CO5Jlo7JWThpKRxTx/HL9WI
	Op4sXw6/J20ymvh23MOoCYvcjylHLg5qhYSUXxQ==
X-Received: by 2002:a05:693c:60d2:b0:362:2e2f:c261 with SMTP id 5a478bee46e88-377e1cebaffmr13409680eec.27.1794819938661;
        Mon, 16 Nov 2026 01:05:38 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795378d7e5sm32581548eec.3.2026.11.16.01.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 01:05:38 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: axboe@kernel.dk
Cc: tj@kernel.org,
	josef@toxicpanda.com,
	bvanassche@acm.org,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] blk-ioprio: check capabilities before promoting a cgroup to RT
Date: Mon, 16 Nov 2026 09:05:29 +0000
Message-ID: <20261116090529.69650-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ioprio_set() and the per-request I/O priority of aio and io_uring only
hand out IOPRIO_CLASS_RT to tasks that have CAP_SYS_ADMIN or
CAP_SYS_NICE. The io.prio.class cgroup attribute has no such check.
Writing "promote-to-rt", or its alias "none-to-rt", to it changes the
requests of the cgroup to the RT class.

The attribute exists in every cgroup that has the io controller enabled
and it is not hierarchical. A user that got a cgroup delegated owns the
files of the child cgroups it creates there, so it can create a child
cgroup, move into it and write "promote-to-rt" to its io.prio.class.
Its requests are then issued with IOPRIO_CLASS_RT although ioprio_set()
fails with -EPERM for the same task, and mq-deadline dispatches them
before the best-effort requests of everybody else.

The delegation model in Documentation/admin-guide/cgroup-v2.rst expects
the settings of all resource controllers to be hierarchical, so that a
delegatee can only distribute further what it received from its parent.
This attribute lets it raise the priority class of its own requests
instead.

Require CAP_SYS_ADMIN or CAP_SYS_NICE for the two policies that raise
the priority class, like ioprio_check_cap() does. The other policies are
left alone.

Fixes: 556910e39249 ("block: Introduce the ioprio rq-qos policy")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 block/blk-ioprio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-ioprio.c b/block/blk-ioprio.c
index 8fa8bca35062..ea32db727b16 100644
--- a/block/blk-ioprio.c
+++ b/block/blk-ioprio.c
@@ -14,6 +14,7 @@
 
 #include <linux/blk-mq.h>
 #include <linux/blk_types.h>
+#include <linux/capability.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include "blk-cgroup.h"
@@ -91,6 +92,9 @@ static ssize_t ioprio_set_prio_policy(struct kernfs_open_file *of, char *buf,
 	ret = sysfs_match_string(policy_name, buf);
 	if (ret < 0)
 		return ret;
+	if ((ret == POLICY_PROMOTE_TO_RT || ret == POLICY_NONE_TO_RT) &&
+	    !capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_NICE))
+		return -EPERM;
 	blkcg->prio_policy = ret;
 	return nbytes;
 }
-- 
2.43.0

