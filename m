Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.118.77.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793877585;
	b=QoOfvMc7OTcGE1UUQdDwg/aSUBXBS2tDxHnJ70OycupClMBEnris03Nr5Rxpf1nSDnGT
	 KqpXtwai2sootkmH9Lf5fryCJtTrvu2oOfWeeZA62M43hwjyFECIbvijRnDkYA33csyn0
	 xVNUmmTxUOIsPM3Mc6aGXizKDenO5wqJlR+0PICvO0ERW6HvAu/5z0HdrE1UTCIsX4C46
	 BnpBffQY1OhTHD+vAlpilTa1MfNCWkfa9TYjAXlyt6zDUJuYJAdPh9Qo0xKPjr+Qz3ctG
	 Y/SPNGEW7a65bGnJKykGhc0j//JiEEua3+4KeLKPiwpXNCJXuFLgCi0Ycw+3TmfGj/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793877585;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 Content-Language:From:In-Reply-To:Content-Transfer-Encoding:
	 X-CMS-MailID:X-Msg-Generator:Content-Type:X-RootMTR:X-EPHeader:
	 X-CMS-RootMailID:References;
	bh=5KCq4gQ0WNVD0CqxQ8CxcPGzA4UUhnIjbCTZQCNWRwc=;
	b=F93coZ7S2b11caZTzeXZHmbh/1aciQanDQNkFe9NaaSImfBVARkI+gJ8q2tPMjTrMFhT
	 haLjBDYnx4jaaNXE8QL9XVND99xkDHdxZI6js095KO/QqE4bKwuztEaNzFedHS/gCOhxX
	 jd1WfGDH34dDjGnmmLKM5U8eFkY+REhXpDbm6r06KiHRkm1g5ge/BELWWTWUAaKe/GHO7
	 UeBncBCXdL0Jaw0fqxuiRKfpmL9vov3Ho3Ck8U6GBJ4JOGv5bSCSJwSfNvONS6Nd46VyW
	 4SLSMo9KHman6mfQ0QfbHkxTEArfYGLbBUcQhaHgJkJo5XkpYbdMNq6es0EfmnTUxRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=ZbSaaOZt;
	arc=none smtp.remote-ip=210.118.77.11
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DB3606A329
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 11:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0DB3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=ZbSaaOZt
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261105111941euoutp01650a2a7500053ee29abb4ffac671aa11~lIigDPwTF0398803988euoutp01D
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 11:19:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261105111941euoutp01650a2a7500053ee29abb4ffac671aa11~lIigDPwTF0398803988euoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793877581;
	bh=5KCq4gQ0WNVD0CqxQ8CxcPGzA4UUhnIjbCTZQCNWRwc=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=ZbSaaOZtnIcQ6jpB98Pw0e7JLMrXzEGjrBUvYkjtNGjAmtvpMM3+MChct2OBBDnXM
	 IRtBHby3gELo75BlecREVtA/faZUoCS9ixmOHBoaJwD/Ih0PVCeNmDq7BX8FR1DiAb
	 ulIDA1/QXr1iefk2JCiZrWX3xb8fzovyWdG65G5I=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261105111941eucas1p1b50e9720b000ca86204aff3977c9fcbb~lIifqwzIu2986129861eucas1p1H;
	Thu,  5 Nov 2026 11:19:41 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261105111940eusmtip2cf2351317b5795365f7fc41b37abb32d~lIiebY-_T1929119291eusmtip2O;
	Thu,  5 Nov 2026 11:19:40 +0000 (GMT)
Message-ID: <92fd6097-6094-400c-b08e-c13b5d6f5cfb@samsung.com>
Date: Thu, 5 Nov 2026 12:19:39 +0100
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 00/21] sched/deadline: bandwidth accounting fixes and
 selftests
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Juri Lelli
	<juri.lelli@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar
	<mingo@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, Dietmar Eggemann
	<dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall
	<bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin Schneider
	<vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, Luca Abeni
	<luca.abeni@santannapisa.it>, Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, Tejun
	Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan
	<shuah@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark
	Williams <clrkwllms@kernel.org>, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261105111941eucas1p1b50e9720b000ca86204aff3977c9fcbb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261105111941eucas1p1b50e9720b000ca86204aff3977c9fcbb
X-EPHeader: CA
X-CMS-RootMailID: 20261105111941eucas1p1b50e9720b000ca86204aff3977c9fcbb
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
	<CGME20261105111941eucas1p1b50e9720b000ca86204aff3977c9fcbb@eucas1p1.samsung.com>

On 04.11.2026 22:11, Mathieu Desnoyers wrote:
> Please find in this series seventeen fixes to SCHED_DEADLINE bandwidth
> accounting, on top of your four in sched/urgent. Twenty-one patches:
> the seventeen fixes, three that add the selftests catching them, and
> one that shows a runqueue's deadline bandwidth in sched_debug. Nine of
> the seventeen are new in v2, from the reviews of v1 and of the patches
> those reviews brought; the changes are listed at the end.
> ...

Thanks! This fixes the issue I've reported in:

https://lore.kernel.org/all/eb0e386b-da07-4a2b-bff3-79441fd6be1f@samsung.com/

Feel free to add:

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

