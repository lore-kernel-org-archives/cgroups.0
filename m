Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218724322E8;
	Mon, 17 Aug 2026 13:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786972386; cv=none; b=Zel7jBW+65hhmzQF5SMrNp5NSKUcHCG8KFeT8rZVBlIN4L+O/HGzK8N4XZsUp5yDAKisQ4cjBEL6MvSQ0Y/8TyK6LYAglWzNkufBT3fBno6R76092RJW/9Gk+C/RfdFbEboCFqm7OVyRSatPE6bO2+Snv4jbx6kJC2hi0TXMCMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786972386; c=relaxed/simple;
	bh=rPEdvE3U0fr+3EHms1jH/x6codkckPNOcSAO1nzPnrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S1kxyirNmOlHBzzYEBmAWsZ94Ggsm8PjD0UGQehp3NKut0WjP/CNL3RE4onHDeIzRKqFwUzK2su1f7PVAytATww+4FCK3/V/0rLR8Ps5+/7fS9/Nlh6yLEuI3ukKpz5cHRlTyIfqsS/IrEe2X+gj6DIXQA3DjL9hwRGvHYGyTTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 5a3936f29a3d11f19a56ed5b684f684d-20260817
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:2059e333-ecd3-415f-8235-31db290688d2,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:21,RULE:Release_Ham,ACTI
	ON:release,TS:56
X-CID-INFO: VERSION:1.3.19,REQID:2059e333-ecd3-415f-8235-31db290688d2,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:21,RULE:Release_Ham,ACTION
	:release,TS:56
X-CID-META: VersionHash:7db8b62,CLOUDID:d0f739e605b8aecbb2a0add61b02c04b,BulkI
	D:260817111225XMIBG1F7,BulkQuantity:8,SF:17|19|66|78|81|82|83|102|127|865|
	898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40|20,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FCD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5a3936f29a3d11f19a56ed5b684f684d-20260817
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1245843252; Mon, 17 Aug 2026 21:12:52 +0800
From: Song Hu <husong@kylinos.cn>
To: mhocko@suse.com
Cc: akpm@linux-foundation.org,
	audra@redhat.com,
	bingfangguo@tencent.com,
	cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	zhuhui@kylinos.cn,
	Song Hu <husong@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg offlining
Date: Mon, 17 Aug 2026 21:12:21 +0800
Message-ID: <20260817131221.44761-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aoLGzZHS8kj53-ey@tiehlicka>
References: <aoLGzZHS8kj53-ey@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon 17-08-26, Michal Hocko wrote:
> Is there any specific reason why the memcg stays in the cache slot
> without any pages?

consume_stock() doesn't release the slot when nr_pages hits zero.  It
is kept for the next charge of the same task and only gets displaced
by a charge under a different memcg or by CPU hotplug.  The problem is
that the offlining drain skips empty slots, so the css reference they
hold is never dropped unless something unrelated displaces them.
