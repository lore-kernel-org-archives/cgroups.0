Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794982744;
	b=3piD/V9r3LIftCFfeGpDGmL85l608Xj34YdwSzsrLNtd3aQ6mi/qwNLRlB6wlrGFcbrH
	 /ZZAB2dCDeely9uCyx/YHHGLmg6vhxmtKPLc8y/dPbY5rpAgBNIyksI0vTOtnzIrxmb1G
	 0p9h9dY0WBXmynZJj+CoCS0N/ZMoQaNM+bv4EIrwVRWfX/CceA7uviaprb/E1mENLYoPD
	 5XR9ADxYplfaESyovyVXD0oxvBWGNpjYDgWeVs193eZiy/NfuNgbfaBX7PJoImAvLvY/Z
	 dVs+h2ELTULrJA+YGG6Y0dqG6NSmotF3cXoPNdjtlVLV69kPFbLDvFaG5YhbCfwsfcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794982744;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=ytZr4giVmUwDVQwf7pQ4PjUJk/AgiGIqWa27GNbLrRQ=;
	b=jJi6wMEG5GK6JPmM1aBfEdqwK4lA4ypyulHqVACLnmKeug4nr0CaMyYy2DEcxs9/Dt/r
	 rxBoiiKwvn8234zSvZk3nyUZ/VDZTCTIM+YGE/l4uzEdlINF18Xn/wb1ijDuX/odBht8L
	 FSmAQzACklM25JdqMEFOwBxmW0xRncT+un9VXbkQZ/Gj9VsGzibtnRS+SKo7cbY2wdCRb
	 MkprUvswRemCIg1wTFa/eWeV7gIu/FCsDsMzUlJN4zYkuU/PpN8HN3PiHKMeY1N9G/9DO
	 k2+Ous5HA8YlFkw8lsBQJ++Z4JaA82QaR4B5zq7CdgJ3Z8L/wIog2AE/cNN+eXqLbxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8945E606A31C;
	Wed, 18 Nov 2026 06:19:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8945E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ea16d9e6e31711f19a56ed5b684f684d-20261118
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:89038ce9-32b1-43b5-8458-64b25057a19d,IP:10,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.19,REQID:89038ce9-32b1-43b5-8458-64b25057a19d,IP:10,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:bba54efc50fc7d3f375c66ed782fe959,BulkI
	D:261111000658N3C0QPTK,BulkQuantity:1,SF:17|19|66|78|81|82|83|101|102|127|
	136|153|850|865|898,TC:nil,Content:0|15|50|99,EDM:-3|-100,IP:-2,URL:0,File
	:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR
	:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ea16d9e6e31711f19a56ed5b684f684d-20261118
X-User: liuzhe1@kylinos.cn
Received: from localhost.localdomain [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <liuzhe1@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 219582194; Wed, 18 Nov 2026 14:18:47 +0800
From: Zhe Liu <liuzhe1@kylinos.cn>
To: tj@kernel.org
Cc: axboe@kernel.dk,
	cgroups@vger.kernel.org,
	josef@toxicpanda.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuzhe1@kylinos.cn,
	yukuai@fygo.io
Subject: Re: [PATCH 0/3] blkcg: decouple cgroup v1 I/O accounting from throttling
Date: Wed, 18 Nov 2026 14:18:42 +0800
Message-Id: <20261118061842.525120-1-liuzhe1@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <avNBFpWArSrjv6Qv@slm.duckdns.org>
References: <avNBFpWArSrjv6Qv@slm.duckdns.org>
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

Hi Tejun,

On Tue, Nov 10, 2026 at 06:06:46AM -1000, Tejun Heo wrote:
> Maybe just add a module option or sth to blk-throtl to initialize eagerly?
> I don't think it makes sense to update cgroup1 significnatly at this point.

Thanks for the suggestion. I'm reworking the approach along these lines and
will send an updated patch after testing.

Thanks,
Zhe
