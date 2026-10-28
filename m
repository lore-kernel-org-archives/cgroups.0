Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793160263;
	b=hOjzA6+rSdvKkoEYs7/B50+OEQE500KiiE9iGPUqo2sKk24NipRRZ6IIj+ZUG04Q+LG+
	 MxRndqbwvs970Nd0A8CMN4U4N+1rzthQCBhFlY7Oz7AJfainpl0U+Jln59LmCGIz3ZKZZ
	 FXnYvCYXevIxB6mSvafOOQ84aPvsTAytSHXAyPDw40SptKHP02RR5cQMavHWu24mBQt/6
	 Uf5alqX5eEeNhd+VNU6Tq5buNKtOSjgtaBYoBLQ8qdf52mR8J++SyTXJ6H+olYXg/zBDY
	 hH9qFfW5C5BosfoUhaf2JLghY7LMTTLUP1p1TRpGLwbEZRXQEx5aBjwpOQBgFTlDf+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793160263;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:X-CPGS-Detection:X-Drm-Type:X-Msg-Generator:
	 X-Msg-Type:X-Reply-Demand:Message-ID:Date:X-CMS-MailID:
	 Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:CMS-TYPE:
	 X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:X-CMS-RootMailID:
	 References;
	bh=s+iZWCpgO+SWu6sydNQvWF6mQUcVR5AF+EnQF8o0seY=;
	b=E5cpT0ZE9nhJkvPOj7svbqil/XL2u8dfytXzW9CB0T+ogTWIQSTIMsbLSbFerE9XFbTz
	 6QRXS8f6Yl8PcBWdsZ1MgjE9NJZ1Xw/aZUkSkcBoEg3F7RnATjYPusGvb5gLsllZdMjNW
	 DN+eIB8bszDxkI/4srswt6bm05D6jBDaqzK4IaNeVELR58D41jzG3YKo20DcC/TLD9AAu
	 4FO1j7CT8Rz6m6ljeSutFBpChyCj6kmY5NfSMSUOcAuvfHTK6RsP5MlU1Igmp7wAxoWCK
	 cL5gqXw+9i6i/c4PAaf5IP9ouakJ7IMcgeELNNLzeMkLcDIAIK/Ic/EfO+G9G2vlV1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nurJA4ZA;
	arc=none smtp.remote-ip=203.254.224.24
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF725606A31A
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 04:04:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF725606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=nurJA4ZA
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20261028040419epoutp0116651aac4d214df758142cb9e4bf95e5~ilcFzL_eH2536425364epoutp01h
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 04:04:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20261028040419epoutp0116651aac4d214df758142cb9e4bf95e5~ilcFzL_eH2536425364epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793160259;
	bh=s+iZWCpgO+SWu6sydNQvWF6mQUcVR5AF+EnQF8o0seY=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=nurJA4ZA1svBQxeg9XDU2IjpzLe/OalE7Z2Om7r0tfgeGF8IRySYIMCeweNm84ZX3
	 WikvIHfv5/BWLvSZPnZbjZwgD969WHf6t9Y+DGXIV20FWKKW0Fvkj6T6fah7I32jen
	 p4W23Z87fCyWV4H4cPl+wSzYJhsB3cfDFdmbACgI=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261028040419epcas2p1f7fc59ba2429938da022a301f337fd64~ilcFQaNwF2264722647epcas2p1i;
	Wed, 28 Oct 2026 04:04:19 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.211]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jDtz66Scqz6B9m4; Wed, 28 Oct
	2026 04:04:18 +0000 (GMT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: Re: [RFC PATCH v1] mm: memcg: skip frozen folios in
 page_cgroup_ino()
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: "escape@deepseek.com" <escape@deepseek.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "mhocko@kernel.org"
	<mhocko@kernel.org>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "muchun.song@linux.dev"
	<muchun.song@linux.dev>, "david@kernel.org" <david@kernel.org>,
	"ziy@nvidia.com" <ziy@nvidia.com>, "willy@infradead.org"
	<willy@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d@epcms2p7>
Date: Wed, 28 Oct 2026 13:04:18 +0900
X-CMS-MailID: 20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d
References: <CGME20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d@epcms2p7>

Sorry for the new thread, I was not on Cc of the original mail:
https://lore.kernel.org/all/20260907124001.1544655-1-escape@deepseek.com/

On Mon, Sep 07, 2026 at 12:40:00PM +0000, Tao Yi wrote:
> When a large folio is split, __split_folio_to_order() clears PageTail
> before copying the original folio's memcg_data to the new folio.

Thanks for tracking this down. The oops reproduces on 7.3-rc7 here.

I wonder if the fix belongs on the split side instead:

- The window exists because the split makes page 1 a folio before its
  memcg_data is set. Before commit fa23a338de93 ("mm: separate
  folio_split_memcg_refs() from split_page_memcg()"), memcg_data was
  set first.
- A zero refcount does not always mean a split. Large kmalloc pages are
  frozen but charged, so /proc/kpagecgroup would report them as
  uncharged.
- print_page_owner_memcg() reads memcg_data in the same window, and the
  refcount check does not cover it.

Copying memcg_data before the smp_wmb() in __split_folio_to_order(),
with a paired smp_rmb() on the reader side, closes the window for both
readers. The same reproducer ran 300 s without an oops with that change.

Would you consider a v2 along these lines? I am happy to test it.

Daejun
