Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8952C11D9
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 07:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789974037; cv=none; b=byV0K3K88k4EoJ0Wci3PzBWqyi1CyPtRGih51mLZLgGs3NC3mShuVJhHobecO4xyBUH2ingUwyEzZaX6Fncj9nRI7pc7V+8XMltZdNaayDVUsrL6T3F2wRxeTTjPbXJfFrRNWuXakp5V0wWSUBAe8ozvgrtNQGa9AoNTIlLHo3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789974037; c=relaxed/simple;
	bh=Vbt4/5LAV2w0dL6pb/t0et3MVMocHRdRtbThpOXu98I=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=jeUoyn6TOPEBE+i6Ar5M4NSruVXWgPmhVsBcIb/0boxU+mXvU7W3SHJUWBzwPI44M065LFWvJbD5LCKtvzK3+9tLgQG2OhWKtyYdI2IxxTXS85WInvsfzeTA/InKTao9+Fe+CDQK0EMqkvAKLJw3Z4uuQlcsQvmZpdHNliSlMf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OTzlQF8x; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OTzlQF8x"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Vbt4/5LAV2w0dL6pb/t0et3MVMocHRdRtbThpOXu98I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789974032; v=1; x=1790578832;
 b=OTzlQF8x8c7RFKdIVcny1Yxlog8DnBk5TbMGtkcqgY2gJaRa5rRJdoj6aQi25QdyCHVt6DJv
 jq29wmrPJfp9t8oB2gIMD/34/SwjxTo40bMWkc6oTaQwAMI6xleqmA4OFA8GWomU+uwKq29V8py
 6F/1xK9046/Tgs52AeyiLFrE=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id acb919ec4e2ec370;
	Mon, 21 Sep 2026 07:00:24 +0000
X-Mizu-Trace-ID: acb919ec4e2ec370
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH v2 4/4] memcg: move memcg private ID refcount to objcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260921-bingfangguo-memcgid-rework-v2-4-6c0637dc0edb@tencent.com>
Date: Mon, 21 Sep 2026 14:59:58 +0800
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
Message-Id: <59BF36D0-0328-4CFF-8DD6-DF73AF209118@linux.dev>
References: <20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com>
 <20260921-bingfangguo-memcgid-rework-v2-4-6c0637dc0edb@tencent.com>
To: bingfangguo@tencent.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 21, 2026, at 14:16, Bingfang Guo via B4 Relay =
<devnull+bingfangguo.tencent.com@kernel.org> wrote:
>=20
> From: Bingfang Guo <bingfangguo@tencent.com>
>=20
> The memcg private ID is used by objects that can't afford storing a
> whole pointer and can outlive memcgs to track the memcg (notably swap
> entries). The current design holds a refcount to the css, preventing =
the
> memcg from being freed.
>=20
> This patch unbinds the lifetime of memcgid from the memcg so it can be
> freed.  The idea is to move the refcount of memcgid to one of the
> memcg's objcg. The objcg is stored in the global memcgid xarray =
instead
> and used for retrieving the online memcg from it.  So swapped out =
pages
> no longer pin the dying memcg.
>=20
> After the change, a memcgid can refer to a non present memcg. To =
handle
> this situation, when trying to get the original memcg from the id,
> compare the memcgid passed in with that of the memcg, and return NULL =
to
> indicate its death if they differ. NULL checks are added for
> list_lru_walk_node(), workingset_test_recent() to skip dead memcgs. =
For
> MGLRU recency test, mem_cgroup_lruvec() will substitute NULL with
> root_mem_cgroup.
>=20
> In the earlier patch, an extra xarray lookup was introduced in swap
> uncharging path.  Now that we have the objcg pointer in the function,
> the extra overhead can be removed by using it for putting directly.
>=20
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

