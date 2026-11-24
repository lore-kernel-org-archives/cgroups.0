Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795510986;
	b=es9LXXVDnSJvg59tM160np3yvPb+CCh86WPIWCuW3lntKSHQ915M+5heSic+Hxn+O2nm
	 A5mS8fV5OBtH4poP0uumqrt3K6AfZmcOK4lXq4+Z9j8t/qDatc1//48nyoYx6I20EIndq
	 xZ4r2rtfbskGgjq6xpxrRD6ntRoL+gsc1tt5IR5bzO0xEtcQ8uzu5xicmfV+g+aCxNcuK
	 Qa0tjqDpF79F/BPWNpCzva75z9rB9a3QbkJXxq6zXCmYucRbGIzXEufrLyyIme2akEDS6
	 dmUqxIxaEKFgdq/3ljWMcAdnFhZScKKu1uexnNBM8iroDbq9dmil70w6XgucfD9zRQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795510986;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=OeIpI24/F3WB52LFABE1SqnVRMCOX+nmt79ZJQb7pzk=;
	b=Yxo085jK3quJXSYobUVCYPSri0bXCRtzDUsDySSGY0v9kljQxN0PuRa44tofZm+ZYaC1
	 SmxCg9qaQEHq5dU+xr9nllB3m/tIKlTXNUgkG7gxXgzIMnHOt6ZHQoTZFkUZSQ6d97ZWj
	 AYqMf+by5EXzav2NNngEXRx5F9Pf0jFTmBfR2F0SjQWtQrJVVT5ZU0agRMGHN1NIaZjTY
	 vB0uCd3GVfc+p+x1fFZD6GkUSi3hN7OJXLCAXTZMMTNv0h1CtKMK5Fnd5XE5XM7p74MZW
	 VuULdwzAsnJquCXK2FoYmgjABuZfY/gpja/BZecDDJcEyEKVbRG2q1BrA1+tNRWneig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=PrOCn4Ey;
	arc=none smtp.remote-ip=203.254.224.33
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA28606A31E
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 09:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EA28606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=PrOCn4Ey
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20261124090303epoutp0369ae2aa41199e637e874200dc004a2bc~q77nlIroj3191431914epoutp03i
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 09:03:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20261124090303epoutp0369ae2aa41199e637e874200dc004a2bc~q77nlIroj3191431914epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795510983;
	bh=OeIpI24/F3WB52LFABE1SqnVRMCOX+nmt79ZJQb7pzk=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=PrOCn4EyHRBzCb07htG/ZubDvLHcbN2eCWr/kQVTcyg0mRdH5vjL4j+N9sIcXtod7
	 WAd2LsOlpCNgeRq41bHohcadgNII1Y80xe0ROxcZIF6LrExTig9B/5yljgPHpjdGCr
	 bht1RAWMdGNSVvyi6B9kj5epBWp246IoCXrdEmts=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261124090302epcas2p1699090c5343d3ab887ece39e23e0758e~q77m87Ro92037020370epcas2p1f;
	Tue, 24 Nov 2026 09:03:02 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.202]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4jYcKL0xxwz6B9mK; Tue, 24 Nov
	2026 09:03:02 +0000 (GMT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE: [RFC PATCH RESEND 0/3] block: cgroup-based and explicit write
 stream placement for NVMe FDP
Reply-To: suho.son@samsung.com
Sender: Suho Son <suho.son@samsung.com>
From: Suho Son <suho.son@samsung.com>
To: Tejun Heo <tj@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "mkoutny@suse.com"
	<mkoutny@suse.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	"rdunlap@infradead.org" <rdunlap@infradead.org>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>, "io-uring@vger.kernel.org"
	<io-uring@vger.kernel.org>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>,
	"kbusch@kernel.org" <kbusch@kernel.org>, "asml.silence@gmail.com"
	<asml.silence@gmail.com>, KiYoung Lee <kiyoung77.lee@samsung.com>, JinHeon
	Kim <jinheon09.kim@samsung.com>, "ngeol564@gmail.com" <ngeol564@gmail.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <03f83d9625a179d35d7e4a5c2ad0e09e@kernel.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261124090301epcms2p1d0a27ea82ad2689fc0091c97450a86cd@epcms2p1>
Date: Tue, 24 Nov 2026 18:03:01 +0900
X-CMS-MailID: 20261124090301epcms2p1d0a27ea82ad2689fc0091c97450a86cd
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261123095752epcas2p421880961d49868158deabb5ba9fd6e67
References: <03f83d9625a179d35d7e4a5c2ad0e09e@kernel.org>
	<20261123051521epcms2p2445107f926f3acaa2d51c5e12abea90e@epcms2p2>
	<CGME20261123095752epcas2p421880961d49868158deabb5ba9fd6e67@epcms2p1>

Hi Tejun,

Tejun Heo wrote:
> On Mon, Nov 23, 2026 at 02:15:21PM +0900, Suho Son wrote:
> >   - whether io.stream belongs in io.* under cgroup v2, and its
> >     interaction with the existing io controller file hierarchy
>
> It doesn't. cgroup controllers and their interface files are for
> hierarchical resource control and this isn't that.
[...]
> Nacked-by: Tejun Heo <tj@kernel.org>

Understood. I'll drop the cgroupfs interface.

Jens, would a minimal BPF hook for selecting the write stream in the
submit path, with target cgroups identified by cgroup ID as Tejun
suggested, be acceptable for the block layer, or would you prefer a
different approach? This is for unmodified workloads, including their
buffered writeback.

Adding Christoph, Keith and Pavel.

Thanks,
Suho
