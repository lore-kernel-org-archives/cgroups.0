Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ECE36A008;
	Thu,  3 Sep 2026 06:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788418154; cv=none; b=AWi1vrtiPbx77gtrVCOn8vWrlkjm7ka4i51s1MPXmOCINR/rFsgBb7dc8huICk/vMEvQnBlCe+lP81hpm7vtSrPJj5U5gtu7XU+q36dvQg3TtTjmmDUWzNA+2d1HnfayRgFPcAS1E9gI6m/QmxAZmpWKwPd354iuP1UDukf6YMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788418154; c=relaxed/simple;
	bh=6xnMMLfsVxc7WnsEWz1hGVwcZmIPai/otpTglS+zVKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMsiVv9GJIoVBeEdiu/Ze+cCSpaSL1rX3qAR45v22MGbIwclsS2rsMUjWwPCc3p9lENJN1+uwaXVuZuPCs6grnXaDvoTtJq3XOIAchPBsjdg5mdVCT8neBb8HKoVzdDyeN1uSrxKHgqfCJXzGX++CQ2HHhI2Cfl/r0qiI1xTZqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 8c9f3f64a76311f19a56ed5b684f684d-20260903
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
X-CID-O-INFO: VERSION:1.3.19,REQID:1e3b3cf3-5d1a-4273-ade3-fe79fbf4ce55,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:1e3b3cf3-5d1a-4273-ade3-fe79fbf4ce55,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:f6857fe78b674252f7a60b75cd8ebc38,BulkI
	D:260903144905T21CXXHH,BulkQuantity:0,SF:10|38|66|78|81|82|102|127|865|898
	,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8c9f3f64a76311f19a56ed5b684f684d-20260903
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1319152534; Thu, 03 Sep 2026 14:49:02 +0800
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
Subject: [PATCH v2 0/3] drop BUG_ON() NULL checks in namespace copy helpers
Date: Thu,  3 Sep 2026 14:48:25 +0800
Message-ID: <20260903064828.126643-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <aphwXq5bEQwKhqx2@localhost.localdomain>
References: <aphwXq5bEQwKhqx2@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2:
- Reworked into a 3-patch series that simply drops the BUG_ON()s
  instead of replacing them with WARN_ON_ONCE() + error return,
  following the discussion with Tejun. Now also covers copy_utsname()
  and copy_mnt_ns() so that all copy_*_ns() helpers behave
  consistently.

The copy_*_ns() helpers are inconsistent in how they handle a NULL
namespace pointer. copy_mnt_ns(), copy_utsname() and copy_cgroup_ns()
have a BUG_ON() on the pointer, while copy_time_ns(), copy_pid_ns(),
copy_ipcs() and copy_net_ns() don't check it at all.

The sole caller, create_new_namespaces(), always passes the
corresponding namespace pointer from the task's nsproxy, so the checks
can never trigger and the helpers dereference the pointer right away
anyway.

Drop the BUG_ON()s so that all copy_*_ns() helpers behave consistently.
The maintainers of the respective subsystems are on Cc.

Shaojie Sun (3):
  cgroup: namespace: drop BUG_ON() in copy_cgroup_ns()
  uts: drop BUG_ON() in copy_utsname()
  fs: namespace: drop BUG_ON() in copy_mnt_ns()

 fs/namespace.c            | 2 --
 kernel/cgroup/namespace.c | 2 --
 kernel/utsname.c          | 1 -
 3 files changed, 5 deletions(-)

-- 
2.50.1

