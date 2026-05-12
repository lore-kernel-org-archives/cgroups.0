Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9021FC8;
	Tue, 12 May 2026 03:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778555160; cv=none; b=gTVxKJU06sgrWd+fUtaNHIU+VGSUvliWkQvVaLINu8jSZ08WmYYmU491Uk+nJe4fSb0QtC+wblY9wg+Qhj3brLlPXg8dvIWB0b+QyuKpGhJybTR8fXX23IWwLcrOWDZBD/OjnwZUNhGVVJKsTV2HWVwL9xVXZDpPFehzZt6jj5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778555160; c=relaxed/simple;
	bh=aPFi2WgApGsqhMDAR6VCAxZmMEWbKO4oOpSg8XCVytw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gUzb5G2ClsY4rLaKCHmb6DJIdcH2jMrIuFhS0Uvmn8rFfdRiAfoqEAQVN2nan7AOFPn1KD0Sv4yYEXnzdTQQ9JqJm+ShcwoFiOXuBlUIvNUb4YrseN7g3HanU1koBOY8V4r94WltfZ72h2XXOInR9TBqKOhl65LM0EWo+XYiryI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 77da728c4daf11f1aa26b74ffac11d73-20260512
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:36e1e69e-1b14-460a-9a29-b149158999a8,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:5
X-CID-INFO: VERSION:1.3.12,REQID:36e1e69e-1b14-460a-9a29-b149158999a8,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:5
X-CID-META: VersionHash:e7bac3a,CLOUDID:9664b41425725c4b0711df2f1f0134f6,BulkI
	D:260511104727UACKCMR1,BulkQuantity:4,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|850|898,TC:nil,Content:-10|0|15|50,EDM:-3,IP:-2,URL:0,File
	:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR
	:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 77da728c4daf11f1aa26b74ffac11d73-20260512
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1377102052; Tue, 12 May 2026 11:05:45 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: vishal.moola@gmail.com
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	shuah@kernel.org,
	tj@kernel.org
Subject: Re: [PATCH] selftests/cgroup: check malloc return value in alloc_anon functions
Date: Tue, 12 May 2026 11:06:04 +0800
Message-Id: <20260512030604.2392932-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <agHEjG7_fHMAnQrw@fedora>
References: <agHEjG7_fHMAnQrw@fedora>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Vishal,

> > diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> > index b43da9bc20c4..8ef9c99a82eb 100644
> > --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> > +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> > @@ -61,6 +61,11 @@ int alloc_anon(const char *cgroup, void *arg)
> >  	char *buf, *ptr;
> >  
> >  	buf = malloc(size);
> > +	if (buf == NULL) {
> > +		fprintf(stderr, "malloc() failed\n");
> > +		return -1;
> > +	}
> > +
> >  	for (ptr = buf; ptr < buf + size; ptr += PAGE_SIZE)
> >  		*ptr = 0;
> 
> Every malloc() call in this file has this same pattern. Maybe we'd be
> better off making it a helper function?
> 
> Either way:
> Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

Thanks for your review and valuable suggestion.
I agree with you, will refactor all malloc() checks into a common helper
function, and send out a v2 patch soon.

Best regards,
Hongfu Li
