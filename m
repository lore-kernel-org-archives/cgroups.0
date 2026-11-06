Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793958206;
	b=RjNjCX19Knhgz1+wCIjhXHTYFVdHiJCNcusXYo3Tx6NYpiMg8XnBUS/ThNnFlQhZf/vC
	 0wNOmqzuHjnG//JJ3YQIlF6UtGAUG0OZXQN4dFc/t/hojjuyL0YYdRN1dgk/myhu+XpXT
	 GZ4cpy+PBbzQy5OKKyyatiU3q+UlfRj3kQ3Zk+IOookMcdUltVnIBoHDI6AB7V6w/Hft9
	 RLgj0tZynikEEGI6hBoH/4+lJTGTpCZRupoWCzRCMALCjQdOLOrYop3dsiirGZaOkPcwP
	 YuLIp7s1c1p/Ao2V3M0ceM25hkXhAqCXrNdWtJ4utPF3bI/rB/hiD7toqfQGR2uiRNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793958206;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=H3fWSYpBrRNGL9jY1TKYKIUAFKC7Gm37XmKPIvJymqA=;
	b=ORifI8N7gFzD5/SviHLY0EDd9FEX07tMKGEuGfjBhi9ujgOc+y0LNboPubt3qQRyl9Vp
	 2pdfRIs014awjqSvnaIJ6cDJ6/NqYIpXKfaIk2H/RtYAtTvyFxTMEYyOJqC4EkX+OmmKf
	 oJR16hFHENX1eSOjZIvpkdAl5HjX7F0QCHL+PEKv9j442EI2GZaL00JLK213AtiOPjUBh
	 aAp8S3h1Aj5cOeEclT5rIRV+unpDdq1XWaD2xDwOT9czRCW+uHZUGWqMzUNuvayJfngNd
	 ll+XcIbhzNyb7h2dSpuexuPXQuGJQ62NSaijzscxbJi3JmJ2fRgUxGxaJaJghanwRlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E5F606A920;
	Fri,  6 Nov 2026 09:43:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09E5F606A920
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7b5d52d2d9c611f19a56ed5b684f684d-20261106
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_PRE_RE, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:4775f0a9-c2a7-4aaf-a34a-45783e1de2cc,IP:10,
	URL:0,TC:0,Content:20,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:55
X-CID-INFO: VERSION:1.3.19,REQID:4775f0a9-c2a7-4aaf-a34a-45783e1de2cc,IP:10,UR
	L:0,TC:0,Content:20,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:55
X-CID-META: VersionHash:7db8b62,CLOUDID:7bed247e6b3f11f2520c928d0fcff23c,BulkI
	D:261105235241HZP5CT0K,BulkQuantity:1,SF:10|66|78|81|82|83|102|127|153|865
	|898,TC:nil,Content:4|15|50|99,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,Q
	S:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,
	ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7b5d52d2d9c611f19a56ed5b684f684d-20261106
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1669217258; Fri, 06 Nov 2026 17:43:12 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: tj@kernel.org
Cc: cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	mkoutny@suse.com,
	sunshaojie@kylinos.cn
Subject: Re: [PATCH] cgroup: replace BUG_ON()s in compare_css_sets() with WARN_ON_ONCE()
Date: Fri,  6 Nov 2026 17:43:05 +0800
Message-ID: <20261106094305.1103123-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <auymPbeInX5BsUMT@slm.duckdns.org>
References: <auymPbeInX5BsUMT@slm.duckdns.org>
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

On Thu, Nov 05, 2026 at 05:52:29AM -1000, Tejun Heo wrote:
> Why are we changing this now? These never fired, and if they ever fire,
> we're in a very deep doodoo.

Agreed -- these checks never fire in practice, and if they ever do the
css_set bookkeeping is already inconsistent, so stopping right there is
better than limping on with a broken css_set.  The BUG_ON()s are the
right thing here.

I'm withdrawing the patch.  Thanks for taking a look.

-- 
Shaojie
