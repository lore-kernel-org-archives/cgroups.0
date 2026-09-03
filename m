Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510AE3F6606;
	Thu,  3 Sep 2026 06:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788418156; cv=none; b=aRztsE7XVTU0ChHqzMimeU9Zv221w/0rqB0T4qRKkjmk0wP/gcmYcrNdqbmSpsS7cOMapLh9RsjbdHNc037TeSKf38wCIJSDZ5P1a4E4f+2L5CQcEaaRCvqbrMPGrvxV+E5+5wp7LTVrh9xh2r72Mzxd2+omFJ1IV4un+tGF4xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788418156; c=relaxed/simple;
	bh=ITcyZIhg7nHCVCO4TfKxdewWsAYjllnLRwXVfU0Z6/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Np1slsiRF0gQlDt7cG3Glxrx3GvrW365JSaKi8YR25nT4g8US/rQSf+W56eidgRYRVzncxUaYE9vshe+x72o7Zu/GdzNP4RWXztOEbrpANJ8b3T6rAKtrSkstQJFC7A0KI0OtU2A+LogYIbMQdlG5YF9N6mgUHb7mLoR5yPGEg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8e8edd48a76311f19a56ed5b684f684d-20260903
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN
	HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS
	HR_TO_CHARSET, HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:5463783f-ec7f-4fdd-8e53-a063965ce591,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:5463783f-ec7f-4fdd-8e53-a063965ce591,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:7026490707da4f01151f4d5dfb7a2ff8,BulkI
	D:260903144908A8YRXFCY,BulkQuantity:0,SF:10|38|66|78|81|82|102|127|865|898
	,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8e8edd48a76311f19a56ed5b684f684d-20260903
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1126170251; Thu, 03 Sep 2026 14:49:06 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	cgroups@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH v2 1/3] cgroup: namespace: drop BUG_ON() in copy_cgroup_ns()
Date: Thu,  3 Sep 2026 14:48:26 +0800
Message-ID: <20260903064828.126643-2-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260903064828.126643-1-sunshaojie@kylinos.cn>
References: <aphwXq5bEQwKhqx2@localhost.localdomain>
 <20260903064828.126643-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sole caller, create_new_namespaces(), always passes a valid cgroup
namespace pointer from the task's nsproxy. The other copy_*_ns()
helpers, e.g. copy_time_ns() and copy_pid_ns(), don't perform such a
check either. Drop the BUG_ON() for consistency with them.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 kernel/cgroup/namespace.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
index ea4ee13936be..76660332ec64 100644
--- a/kernel/cgroup/namespace.c
+++ b/kernel/cgroup/namespace.c
@@ -53,8 +53,6 @@ struct cgroup_namespace *copy_cgroup_ns(u64 flags,
 	struct ucounts *ucounts;
 	struct css_set *cset;
 
-	BUG_ON(!old_ns);
-
 	if (!(flags & CLONE_NEWCGROUP)) {
 		get_cgroup_ns(old_ns);
 		return old_ns;
-- 
2.50.1

