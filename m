Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795117477;
	b=Oeg588gl010H/y6A2n6rde6mu79Fk5oIVz4HleXD16GQicsHfy/OmOz+okXlz6zVo6Q0
	 60v0PNTNPHMsfh/NJ6gysnTmj+FmA5hUcTWZNAULLmJGq2IlJo4CsamrBLfVrHYtC1tq8
	 vPtt7jdubaO+7kqNvs29B4b+R3h7ZAkX/lpHM2E7fT/OzaE7G2TsUwe+5f9a9iefYxYu3
	 YL7v0ESdRz0G/i6C3gpLcavPO7GJYLdAyaunwwpFN90kXTDQ62F2sW1JuPQflue8Ju7Za
	 LXx18HV0nuTbR05WQWWk24a5l4MjHLfsQZWGTie07WIg9AuEW3a5SGfFu4HCR/xDtoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795117477;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YKyrivJzo+Mben9cmzx8JhnXyAay12IuEg5j9gR3E6E=;
	b=EovtJLn3WMwpnRgCN/y5pSAgzyDm0HYMHWbNL/6+0Rd/hclTfKT2Uzo6nw+qPmmbHf0O
	 SXW9nghwPXlduGDhnRaD1+oWWl1Ao7vIwjEahdcq+GWYar1f0iAGJpqJK+n+SoIVJwLsm
	 de4gqHIPgC0QMxr/OKBXqix+LKbrcNe/ROiLNRW++Z8GGh13u93ug9q34JTAC2tPGs067
	 Tws6wipGzSvhYOPl/WeE9QLtJTe9WjvcdHoBlrUk6f/HxyOQ6BXqY06XYsK8fAto7y75a
	 9fJT3bH/Ve583+nBWge6qvoALx/05ewXcfBZSsWuQCqiv6TV/8fCDCgVRSMIqLgdCdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OaoXci3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE73606A32C
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OaoXci3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FE31F0092A
	for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 19:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795117477;
	bh=YKyrivJzo+Mben9cmzx8JhnXyAay12IuEg5j9gR3E6E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OaoXci3lHVzfeCba3lln8uF7Qn9l96givMQbGbGKWNk7T3kABm78qlP4MdS4F2Fqu
	 /Y4lzfYPSQbPYX8HLaFPQqkRqRinSsLy7Vpz45XPcYOzATFoPJpOHNHjfGpSDDYrjj
	 TffPUltbSp9ZowtNe2jRuvCW2Qz4JzGn+hjouog7Cs7/mbtsW70Jxv9+lU57+sQkzd
	 CZ46yF4bryVojOPkVGe4AUHNOQlOW3G6NZ+jU3PO+JE90rMbrSU1GNBfzixhvtYMey
	 mfzINn1iW9Q9zHeH7kun39HuPeDfujI6kZnHIzb3UjSnlox3D4jA+qKJJQt7/nWmzG
	 KSVcUcLVqnyGw==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93a40a9a01aso166891885a.0
        for <cgroups@vger.kernel.org>; Thu, 19 Nov 2026 11:44:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHfPoLU1yJdWeQmGu6v+A53BQjXBRWxykpxDk3pbnEIQuantuXx3ZjjmjP4kEz1KzSQrWiuz602@vger.kernel.org
X-Gm-Message-State: APuU4Z+dF5h+eEd8NmZJgeRKJ4AOzNG7THnTB2NxGWgemQCRalC1PxRu
	B97fqgVBj1VyvbWe8VG/5P6PFXCUHVR2L/2l5T4dZ3x2TUSc/9elQvH4e2fNCexO41qClxYQ8Hv
	YAdMpHDh9lpMHaACULFiqiMuLRJtPIMw=
X-Received: by 2002:a05:620a:261d:b0:93e:c12d:4ec7 with SMTP id
 af79cd13be357-949b3841debmr323824085a.39.1795117477060; Thu, 19 Nov 2026
 11:44:37 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 20 Nov 2026 03:44:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xXdPsnHFX6SUff_1vbsEmGCHdZcXAmOumiN8EMar+KAA@mail.gmail.com>
X-Gm-Features: AclHuK_KKF5P4wFEq4Ot8gOVbDoJlPrF_Qs2r1floMy82S2ahYTVnc8-alAnTWA
Message-ID: <CAGsJ_4xXdPsnHFX6SUff_1vbsEmGCHdZcXAmOumiN8EMar+KAA@mail.gmail.com>
Subject: Re: [PATCH v5 03/17] mm/mglru: make generation page counters atomic
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  include/linux/mm_inline.h |  6 ++----
>  include/linux/mmzone.h    |  2 +-
>  mm/vmscan.c               | 26 +++++++++++++-------------
>  mm/vmscan.h               |  2 +-
>  4 files changed, 17 insertions(+), 19 deletions(-)
