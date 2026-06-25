Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7993A9852;
	Thu, 25 Jun 2026 02:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782353497; cv=none; b=a0zrFzezthjHxkbf7KJgDPykCvS6BySzdrfIjwVJHHZ4PTYXnOJHldZNXy01Jed8PnQxEXfseNgaarZYjtvH4uXqyhjteESHS+IbNKSvu8zUKwXO0idg8IMuUIBrHTsIKiBBteNnsMZ6efE4l/P3ZgQPNS8lmQKaydyNTD0zx+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782353497; c=relaxed/simple;
	bh=dc6GxFOtX82fWBXyYCcZWmSGKG3m0bYG7gdRH4ekqJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UOTNILA97Z4qQZp7G6DXBLVWE/7b5oY1KcWlEZW0ajl+D13ozpZVu75Z3BW8gWnOcRQ3LXMixC/aOJ9WEXws0sORpPK9yW/1yy0G1ZWSrKObSG39e7tAwPES07RbtfB27Zd5t37Cs2lW3+T+GJgwq+h1f5cD73VY1M2X3f8iG+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2be80908703b11f1aa26b74ffac11d73-20260625
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:28c332a2-702e-448d-83d3-ba56f2aaac95,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:28c332a2-702e-448d-83d3-ba56f2aaac95,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:6bf237fb64cc35fff2084227c0961fab,BulkI
	D:260624112706YSGBNPCQ,BulkQuantity:3,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File
	:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR
	:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2be80908703b11f1aa26b74ffac11d73-20260625
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1390390969; Thu, 25 Jun 2026 10:11:26 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: tj@kernel.org
Cc: cgroups@vger.kernel.org,
	corbet@lwn.net,
	dev@lankhorst.se,
	dri-devel@lists.freedesktop.org,
	hannes@cmpxchg.org,
	lihongfu@kylinos.cn,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mkoutny@suse.com,
	mripard@kernel.org,
	natalie.vock@gmx.de,
	skhan@linuxfoundation.org,
	hongfu.li@linux.dev
Subject: Re: [PATCH 1/2] cgroup/dmem: add per-region event counters
Date: Thu, 25 Jun 2026 10:10:53 +0800
Message-Id: <20260625021053.488107-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <ajwnf0uzT4PMHYZx@slm.duckdns.org>
References: <ajwnf0uzT4PMHYZx@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi, Tejun
Thanks for the review comments.

> > Add dmem.events to report hierarchical low/max event counts per DMEM
> > region.  Increment counters on dmem.max allocation failures and
> > dmem.low protection events.  The file is available for non-root cgroups
> > only.
> 
> Please don't double space in descs or comments. Also, maybe it's obvious but
> it'd help if you list why and how this is useful. Why do we want to add
> this?

I'll fix the double spacing in the commit message and comments.

As for the motivation: dmem already exposes per-region limits and current
usage, but not how often those limits actually matter at runtime. Without
event counters, it's hard to tell whether allocation failures come from
this cgroup, a parent limit, or pressure elsewhere in the hierarchy.
dmem.events provides that visibility for tuning dmem.low/dmem.max and
diagnosing recurring device memory pressure.

I'll expand the commit message to cover this.
 
> > +  dmem.events
> > +	A read-only file that reports the number of times each cgroup
> > +	has hit its configured memory limits.  The format lists each
> > +	region on a single line, followed by the event counters::
> > +
> > +	  drm/0000:03:00.0/vram0 low 0 max 3
> > +	  drm/0000:03:00.0/stolen low 0 max 0
> 
> This isn't a supported file format. Please read the documentation on allowed
> formats.

Thanks for catching this. I'll switch dmem.events to nested-keyed format (region low=N max=M).

Thanks again for the valuable feedback.

Best regards,
Hongfu
