Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E8528D831;
	Thu,  3 Sep 2026 08:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788422595; cv=none; b=kCBjoRXrQUFWtD6jMG1nYWhptbci7zoQok454rgh+XhDHcgPDqVpFBghTlYYgDmqBoIFZ/idhdu5sz7umWEgvuBjmYfUvN8dmiJ+1bXChLRIoU0n/NpbfhEPOhvWoe95HUaHudKhSGhku4a3exV5PK47pdKGOpMxTDgl2TL0mQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788422595; c=relaxed/simple;
	bh=jf3HiJp7KGXNkhMGzd9DLXSB/B6BVW/0TP1rBAu4Qt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YJ2KucQeuaz+/Aok29V33dOdiJ2uEp5BLDE7fT/7S7t0vcU43uTeTcmwXUixwVptteTuiBRwBBUlVqoA+vL6aVqB2rttWrd4RYiIUoIWuo/1nnrPjV4dOFjvSTwq3qUHYkz8UgjmgxMT4tkWzDyxSrzs4HdEcpGZwYKYfXQxu0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: e412836ea76d11f19a56ed5b684f684d-20260903
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CHARSET
	HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_TXT, HR_DATE_H, HR_DATE_WKD
	HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN
	HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE
	HR_SJ_WS, HR_TO_CHARSET, HR_TO_CHARSET_NUM, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:31a68eb5-cefe-46be-aa58-537d3a78dd8f,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.19,REQID:31a68eb5-cefe-46be-aa58-537d3a78dd8f,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:9ee2620b21c6a5122e6d77181d0f45db,BulkI
	D:260903160307BGU20KHC,BulkQuantity:0,SF:10|38|66|78|81|82|83|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:
	nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,AR
	C:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e412836ea76d11f19a56ed5b684f684d-20260903
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1395721317; Thu, 03 Sep 2026 16:03:04 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: Re: [PATCH v2 0/3] drop BUG_ON() NULL checks in namespace copy helpers
Date: Thu,  3 Sep 2026 16:02:34 +0800
Message-ID: <20260903080235.149723-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260903064828.126643-1-sunshaojie@kylinos.cn>
References: <20260903064828.126643-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Apologies, the cover letter of this series says

    "... following the discussion with Tejun."

It should read "... following the discussion with Michal Koutný".
The patches themselves are unaffected.

Thanks,
Shaojie
