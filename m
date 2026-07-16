Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2A5477E;
	Thu, 16 Jul 2026 06:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.70.206.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784183898; cv=none; b=UAB2zTdAnCf/3TkpGmLh6iUMPGKqdFZlxqqs8nkFQzuR2lksDYqAGbpdZIm9ecGNxC/TS4BFQ6iLciLvNdophA70dTkRgerXRfxTkdgPGQCH96dwMCZSvhjkeG5YXiTKUIfG23Srj+q/46VGbnpldky8lS3e4yCZenI9d+e/6Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784183898; c=relaxed/simple;
	bh=VN2l4+L3cGzSMhgeLm2beoEljEgiLAJEQyRe6n/nqWg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tfyNeIOC4vHnECZyhKuf/vwvzNtvwQXyDG1nt402xREAqHey7WkRxg+sBKPzkflRkxRdso+/WZVe7YFxc/rtX7KubxGVGq/eu/zPJXrgdVth6p0LRV1uWZlEjISv2DWP6ZoP33SE3J8B0Voc8IVrZiTZdFQviW/QHL/6uj72iDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=honor.com; spf=pass smtp.mailfrom=honor.com; arc=none smtp.client-ip=81.70.206.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=honor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=honor.com
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4h13Jb3SLDzYxkj2;
	Thu, 16 Jul 2026 14:38:07 +0800 (CST)
Received: from TA009-1.hihonor.com (10.77.226.44) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 16 Jul
 2026 14:38:07 +0800
Received: from TA012-1.hihonor.com (10.77.199.132) by TA009-1.hihonor.com
 (10.77.226.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 16 Jul
 2026 14:38:01 +0800
Received: from TA012-1.hihonor.com ([fe80::6668:8cd2:ec5c:99b2]) by
 TA012-1.hihonor.com ([fe80::6668:8cd2:ec5c:99b2%13]) with mapi id
 15.02.2562.017; Thu, 16 Jul 2026 14:37:50 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"yuanchu@google.com" <yuanchu@google.com>, "tj@kernel.org" <tj@kernel.org>,
	"mkoutny@suse.com" <mkoutny@suse.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"kasong@tencent.com" <kasong@tencent.com>, "qi.zheng@linux.dev"
	<qi.zheng@linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"baohua@kernel.org" <baohua@kernel.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "weixugc@google.com" <weixugc@google.com>,
	"david@kernel.org" <david@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>,
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"roman.gushchin@linux.dev" <roman.gushchin@linux.dev>,
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "cgroups@vger.kernel.org"
	<cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"willy@infradead.org" <willy@infradead.org>, denghaojie
	<denghaojie@honor.com>, "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
	"kaleshsingh@google.com" <kaleshsingh@google.com>, "tjmercier@google.com"
	<tjmercier@google.com>, wangtao <tao.wangtao@honor.com>, zhangji
	<zhangji1@honor.com>, wangzhen <wangzhen5@honor.com>
Subject: RE: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
Thread-Topic: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
Thread-Index: AQHdE4pwfI2vhxgx7kyzLikejPZWhrZuF3kAgAGbAtA=
Date: Thu, 16 Jul 2026 06:37:50 +0000
Message-ID: <0a218053083e41c8bc7aacc552c7f38c@honor.com>
References: <20260714121529.2237261-1-wangzicheng@honor.com>
 <20260715140046.GO276793@cmpxchg.org>
In-Reply-To: <20260715140046.GO276793@cmpxchg.org>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

> Subject: Re: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
>=20
> On Tue, Jul 14, 2026 at 08:15:26PM +0800, Zicheng Wang wrote:
> > MGLRU inverts the reclaim order when anonymous memory is faulted in
> > bulk: anonymous pages sit in the young generations while file pages
> > sit in the oldest two, so reclaim evicts hot file pages before cold
> > anonymous pages.
>=20
> An aging inversion in the reclaim algorithm seems like an exceedingly
> poor justification for a userspace interface to work around them.

Hi Johannes,

Thanks for the reply.

I agree the aging inversion is a real defect, and I have no good fix
for it. But aging is not a workaround for it. Aging is a `MGLRU feature':
rebalancing the generations lets MGLRU's swappiness work as designed,
and we measure gains on both Android and file-cache-bound server
workloads.

The capability already exists in debugfs (the lru_gen "+" command), but
production systems like Android cannot mount debugfs. memory.aging is a
feasible path to that existing primitive. We ship it as a GKI module
across kernels 6.6, 6.12 and 6.18 (Qcom and MTK), with stable
gains on both Android and server workloads. Having it in-tree would be
very helpful.

Best,
Zicheng
