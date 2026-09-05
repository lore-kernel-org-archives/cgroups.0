Received: from mta0.migadu.com (out-129.mta0.migadu.com [91.218.175.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF58F1DB95E
	for <cgroups@vger.kernel.org>; Sat,  5 Sep 2026 12:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788610722; cv=none; b=ZoOc8PVKvczMvxeqUYH2gQGlkkXfbtiJYoPwsukrMucST71VmiSMX251HI29DgqTqltACZeswwbPVQiLrFjsFJeRaC0+W9WiDq1jxbOgU5o6QBc/lqSLTiFLalM4FJA2Y9HgONohx3nuNHgsVVR/QzJBujonmhK4RdCxTvsmC/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788610722; c=relaxed/simple;
	bh=ySkuT1pGEsfWYtaDY+C44/DFGOfxtIvjurzCYJAaaQE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=m1xJzvsBLNUi6ioZhHLIjRUUMwCt8qlQaMffH8GGYoBmSP7FIxxSYrYao+ri3FNCk3q7GPkwmQzlMXjVHHO8Ou91Pjr7YxuFGqzdFAIHt9vbABz2Wtg4nak+uM1w/0JloV23+VFIGJ6y/8kRmg4TPxJxJ598f2XC0/v6FCgZdJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mQkaeJ+R; arc=none smtp.client-ip=91.218.175.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mQkaeJ+R"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ySkuT1pGEsfWYtaDY+C44/DFGOfxtIvjurzCYJAaaQE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788610716; v=1; x=1789215516;
 b=mQkaeJ+Ru1jBnLEKNvofl9iKMEqOqeWxneOId2uofPFFUrfOziGHTNyciHTMHWWBg8A5sUfK
 0Rn0I/MZJY82eJK3JfUJPFCbecRlT3WegZdFndHolumtLnfUkxX3kCUGuwvt+EZBHVFfWt/9eb3
 bUrzcsFHHYqy/YeJRNC/wV3c=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id b1c979f2108c0cd3;
	Sat, 05 Sep 2026 12:18:26 +0000
X-Mizu-Trace-ID: b1c979f2108c0cd3
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH RFC v2 6/6] mm/memcg: filter out reparented memcgs got
 from memcgid
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-6-8edd7f7a7251@tencent.com>
Date: Sat, 5 Sep 2026 20:18:03 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Bingfang Guo <bfguo@icloud.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3F681C23-8462-4BA3-B3C6-B7A45A9341DE@linux.dev>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-6-8edd7f7a7251@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 1, 2026, at 16:58, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> mem_cgroup_from_private_id() looks up the objcg that owns the id and
> returns the objcg's current memcg.  After reparenting, that memcg can
> differ from the one the id originally belonged to.
>=20
> Callers such as the list lru and workingset refault code expect to get
> back exactly the memcg referred to by the memcgid, so check that the
> returned memcg still owns the id and return NULL otherwise. In this
> case, make list_lru just skip and workingset tests use the root (as =
the
> comments said in workingset.c:460).
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

We should move this patch earlier to avoid introducing the problem first
and then fixing it later.

Muchun,
Thanks.

