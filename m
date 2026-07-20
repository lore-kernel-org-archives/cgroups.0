Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0A0395D8F;
	Mon, 20 Jul 2026 10:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784542219; cv=none; b=Hubs+j/rtmpxUkPFKLMFdzd1Yfi1449bP3DrujnMVVc6jPWvXiE5XTjI2MieJ4X1xXRc/pu2Z6CoVVavt7sKE+snGZJLAq2SLfvsvZEtCLZs0XhwruK+filFQwmvc5cXc+w7fFapDrzya95WItzK4KlyLCgNdlO+UkHdEYPgVcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784542219; c=relaxed/simple;
	bh=DRj2G/kbtaZiqs9i9n3rMUK/sdBIEHLYGfYyAeqfuNw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A4/QdCiYJZunlLUdnQx1hmRknXD1GjWjx9LU3o3UAzs9jTmdlRVjzVuQ2I3vW4lcADAuq0oO+6nQqqZk/goVwsnMhHZ3gvFgeSzCVYmcXJF3v1XmbC7Kh+kv62uomPT1Si66qT44SL8qxTiVTlyx4YV1DG6PBa5dgG6bbXdKs7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2abcec3c842311f1aa26b74ffac11d73-20260720
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_UNTRUSTED, SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:182cd7fc-fe70-4aa6-97c5-debc970f7cc5,IP:10,
	URL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.3.12,REQID:182cd7fc-fe70-4aa6-97c5-debc970f7cc5,IP:10,UR
	L:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:e7bac3a,CLOUDID:e53962dc0d1edb83f10b468efd64c11a,BulkI
	D:260720181002TLASDCJ1,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	136|850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2abcec3c842311f1aa26b74ffac11d73-20260720
X-User: sunshaojie@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1496401420; Mon, 20 Jul 2026 18:10:00 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: tj@kernel.org
Cc: mkoutny@suse.com,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	cui.tao@linux.dev,
	hannes@cmpxchg.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	sunshaojie@kylinos.cn
Subject: PING [PATCH v3] cgroup/cpu: document cpu.stat.local and clarify cpu.stat behavior
Date: Mon, 20 Jul 2026 18:09:41 +0800
Message-Id: <20260720100941.230825-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260629060636.200118-1-sunshaojie@kylinos.cn>
References: <20260629060636.200118-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Tejun and Michal,

Just a gentle ping on this documentation patch. It received an Acked-by from Michal about
three weeks ago. Any chance this could be picked up for the next merge window, or is there
anything else needed from my side?

The commit in linux-next is: 171569f8ee6724a4113a0100fea6ff83d9b70c6a

Thanks,
Shaojie Sun
