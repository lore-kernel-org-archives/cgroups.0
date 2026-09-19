Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DE81C5D59
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 03:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789787236; cv=none; b=nUyV3jnq3u8NHEhPquL8euL/qRWdToT5Q9DMTXgtowYKA6UjlwEejv/GyQhO1kvxuiuWcbfMCMlhTYD5zsY6K69rJQzikXGuQNEv5gMu1qgCtPKpVArplsz1mVLzqpLHLU6DJQmPeWVJAaQl/DJjRtoxcsARn1GbuOX9VNqMMQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789787236; c=relaxed/simple;
	bh=mEv5lyTLXjPbg50EKTMVu3qs0TVt6kgprNwgFGaHm1A=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kmRoIupo6ZRjCbwYWIQrWBF99+SO6z/+E/FhVguN/s+HbajSHoJc/lKoAN8T5BHZ0wKvZD+6stYrqlRclKLjQzhFgTxFSwLjxy3q7dIQ627OxZ9P7f0G9xEbqLAoiI9FRulrB0RZATXI+4OqMhwR6wMxosBhwKZN27WWqj5TiwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ifvYuX75; arc=none smtp.client-ip=91.218.175.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ifvYuX75"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mEv5lyTLXjPbg50EKTMVu3qs0TVt6kgprNwgFGaHm1A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789787232; v=1; x=1790392032;
 b=ifvYuX75R8iXE4R5+yLfLclZ9qZ+bvjVAIHDAeAnKmQ23BbiUsuQntm9tt7kYASOT7HVGnDG
 BbpUX2Jgu5DHYaDau3GiQaR/Srz7I3rgl8+s9Oj1CzXMN5HLcfEFXUysvrs3ZN3RTxSvpeCRccG
 +5cJFT+QgO9/+mX+Lh5r+mOo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 17c77f7b96f6f559;
	Sat, 19 Sep 2026 03:07:12 +0000
X-Mizu-Trace-ID: 17c77f7b96f6f559
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
Date: Sat, 19 Sep 2026 11:06:49 +0800
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
Message-Id: <90F1D900-0756-4A33-AEB9-5554D646DA57@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 18, 2026, at 17:18, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> This is a preparatory work for moving memcgid from memcg to objcg.
>=20
> Swap entries retain a private ID rather than a memcg pointer. Once
> private ID references are moved to objcgs, the ID can also outlive the
> memcg to which it was originally assigned.  So it's better to make the
> get and put functions accept the ID itself instead of the memcg.
>=20
> Rename mem_cgroup_private_id_get_online() to
> mem_cgroup_private_id_get(), and make it return the ID only.  If the
> memcg is already dying, the dying memcg will still be used for =
charging
> and stats accounting in v2 swap charging path. But they are =
hierarchical
> and will be reparented after offlining so it doesn't matter.
>=20
> Make mem_cgroup_private_id_put() take the ID and resolve the reference
> holder internally. Convert swap uncharge and charge rollback to =
release
> the reference using that ID.  This introduces an extra xarray lookup =
for
> now, which will be removed in the final patch.
>=20
> Separate the online-state reference release into
> mem_cgroup_private_id_kill(). The offline path already has the memcg
> pointer and can call the underlying put helper directly.
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

With Shakeel's suggestion.

Acked-by: Muchun Song <muchun.song@linux.dev>


