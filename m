Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.254.224.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793840778;
	b=17+Eun5zygFS2TJWTjryQXTKrGCX2CpdOZCOKFlDp7bX+VfiH6bOwkjrM+PMUvVtMPzr
	 dfiAEYtkZvj4xRVhzU6hOFPgF0fAglexw578hvNdtXRJxBWPmmDf9RZc3YqbvxUxvYVLE
	 aAT24s3Qj35FBx4W41f8tGBvWTo+rgByjtU4b8zKbvi7lic7yHfqCa1TTY2tMEtij8XIT
	 68Z+7q/h8vDKtZrNVIuuyBTEhGb/xQHwDkRaHryPQXzuwn8QneQYTW0lHkGF1fJO3E9D3
	 7PcMNjMx2pj5mIm5S1r356Qr9qBDoomJr2zXmxwgXi22yw5J+u3rtQy2l1E/r6CqpNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793840778;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Mime-Version:Subject:Reply-To:Sender:From:To:CC:X-Priority:
	 X-Content-Kind-Code:In-Reply-To:X-CPGS-Detection:X-Drm-Type:
	 X-Msg-Generator:X-Msg-Type:X-Reply-Demand:Message-ID:Date:
	 X-CMS-MailID:Content-Transfer-Encoding:Content-Type:X-Sendblock-Type:
	 CMS-TYPE:X-CPGSPASS:X-CPGSPASS:cpgsPolicy:X-CFilter-Loop:
	 X-CMS-RootMailID:References;
	bh=7oacRK3Pt7sPDmCYh3oGr8HRMGBnelioWyFlTRnDaT4=;
	b=1RPqLM97j3IgHOcbThF/z1u2vwZpDRfPHq7131lI1P9e6w5XSVnzGSQLly0uzjZWjmuK
	 biF3m9p/q3evklQnxCkaxeulXDQlZfwtQ6N3T60dv5MEBy8eHP4r7tNjDKIYijoY/8EeX
	 De04qA6SdF7jrFQqdNreFupSpC27lsCNvIWgB5l3B2ftzL2e5R8Of7Kxkli1q9LvhNRY8
	 +W3pr1Uw/GSjhduiXN7D1irDLzu8XxUjifoJrTEmcXmo0tGg7TJfsPIY73wbAJr19Nq09
	 WuIDctjS9Ml24VfWVUc61LJhoqWstj074Nbm0jzddMqL1vUmKujxmQS8uHeQmqHmbTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samsung.com;
	spf=pass smtp.mailfrom=samsung.com;
	dkim=pass header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=RA3zsBB6;
	arc=none smtp.remote-ip=203.254.224.25
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0E4606A328
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 01:06:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D0E4606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=RA3zsBB6
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20261105010614epoutp025ee0ebb14cf93a6cfac24eb874b2beb8~lAK44IQmZ2382523825epoutp02P
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 01:06:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20261105010614epoutp025ee0ebb14cf93a6cfac24eb874b2beb8~lAK44IQmZ2382523825epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1793840774;
	bh=7oacRK3Pt7sPDmCYh3oGr8HRMGBnelioWyFlTRnDaT4=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=RA3zsBB6URHMzGwoGYVTZtDnG4Z/RSmoifO152SpBUu+BE87rLi3SQfpeaFgcWXKA
	 E+4yTCLFFv47LIa+83OerP4m0YunVhraHGUkgn7/KS74QvP4afwSZiLvwjZk0B7/2N
	 WJFaNH6P/Rtf+gXJ4fF4CmO1KriIpBYMuSjlBT9c=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPS id
	20261105010613epcas2p104a21c4f3ac935d60d726cc0c56fbdee~lAK4A-fKR0052700527epcas2p1G;
	Thu,  5 Nov 2026 01:06:13 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.212]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4jKkdx2v9gz6B9m7; Thu,  5 Nov
	2026 01:06:13 +0000 (GMT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Subject: RE:(2) [PATCH 1/2] mm/huge_memory: set memcg_data before a split
 page leaves the folio
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From: Daejun Park <daejun7.park@samsung.com>
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Tao Yi <escape@deepseek.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
	<liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Brendan Jackman
	<brendan.jackman@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, Daejun Park
	<daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DMMKKOIGA9UJ.353PCUUMFLCCJ@nvidia.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20261105010612epcms2p60abe5ce24c4ca7d61236b613a517fe2a@epcms2p6>
Date: Thu, 05 Nov 2026 10:06:12 +0900
X-CMS-MailID: 20261105010612epcms2p60abe5ce24c4ca7d61236b613a517fe2a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261104163327epcas2p1f056cd220dc0d3e40e6fcea082f01b74
References: <DMMKKOIGA9UJ.353PCUUMFLCCJ@nvidia.com>
	<20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
	<20261104-kpagecgroup-split-v1-1-f70e947fec85@samsung.com>
	<CGME20261104163327epcas2p1f056cd220dc0d3e40e6fcea082f01b74@epcms2p6>

On Wed Nov 4, 2026 at 11:33 AM EST, Zi Yan wrote:
> Assign memcg data before clear_compound_head(), so lockless,
> reference-free readers get the right value instead of bogus data from
> the overlaid ->_nr_pages in the first tail page.

Thanks, agreed. Your wording says why the assignment has to come before
clear_compound_head(), which my comment left implicit.

Thanks,
Daejun
