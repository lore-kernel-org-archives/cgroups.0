Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B93A3A71AD
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 02:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789786600; cv=none; b=UwLP1E/q+G3jr0XVruv0lUAKcoXe92E/bcT5RQe7TbyTQ9xtAd8oEMWcehdFGElQsO9en9ZWxFoNVmMFXuQVuamu31DGLRwWNZWe3wYOuM3XLSqxRpk4peV069LF9VJni6LNEi49ZjGB03trzr6s2v7aYRp9b6EfVzKSI86K6t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789786600; c=relaxed/simple;
	bh=yW5QWWhUZOq7BqV6E9+8epbPkMvdcw1AQwYZWc1Wphg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=l5RBW++ZsXOpA8goJW092h01TyuZSzMHSq319ySFstFap0hhv17HBeV5JdnOhhRs/061ahsu3HIO+Vd7oRtKjZqs3t1d4rQNABv5sh0wV+RWAZNZJ9UJn91G5Zev9EnW61dUqlb5hEeKwMzIcHyp2/caGCo8ihan5bC9Y3aKZiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hh06aIAM; arc=none smtp.client-ip=91.218.175.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hh06aIAM"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=yW5QWWhUZOq7BqV6E9+8epbPkMvdcw1AQwYZWc1Wphg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789786594; v=1; x=1790391394;
 b=Hh06aIAM7INTTm2SAQkKnoi0XXEorzfU2t6eDKFA6Ea+Gb6D40MbaKp0PXPoY+rjSEsJ+K2T
 9B4dLTNaaO8VAZbXMk7DPL3iPFOs5ofEkQke9K7peBwxYRj3G4/X4LSiM3jjAviKWV9Y5WXx41L
 +SvYDz26aaZqTT0rVVe0+J0w=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 1f3e88304aab8456;
	Sat, 19 Sep 2026 02:56:34 +0000
X-Mizu-Trace-ID: 1f3e88304aab8456
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/4] memcg: base swap charge accounting on memcgid root
 status
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-2-5bbf3220d88f@tencent.com>
Date: Sat, 19 Sep 2026 10:56:15 +0800
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
Message-Id: <BACBDEEA-F7FD-4EC3-81E8-7806289E8762@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-2-5bbf3220d88f@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 18, 2026, at 17:18, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> A private ID currently pins its original memcg, so testing whether the
> ID belongs to root is equivalent to testing whether the resolved memcg
> is root.
>=20
> That equivalence will no longer hold when IDs refer to objcgs. A
> non-root ID may resolve to root after reparenting, but its swap =
entries
> still carry counter charges inherited by root. Skipping their uncharge
> based on the resolved memcg would leave those charges behind.
>=20
> Use the private ID's root status to decide whether a swap entry =
carries
> a counter charge. A root-ID entry carries none, while a non-root-ID
> entry must release its charge even if its current accounting memcg has
> become root.
>=20
> This patch adds a new helper to check if the memcgid equals to that of
> the root memcg.  For swap uncharging and v2 swap charging, simply =
decide
> whether to charge/uncharge memsw or swap counter based on the swap
> memcgid is root or not. For v1 swapout, don't recharge the memsw
> counter, just cancel the charge if the swap memcg ID refers to the =
root
> memcg.
>=20
> This makes memory and swap charging have similar semantics: one relys =
on
> the objcg's root status, and the other relys on the memcgid's root
> status.
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

Acked-by: Muchun Song <muchun.song@linux.dev>


