Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795436341;
	b=LvqWVt4tvEjmfOSRJYzVtH9x5rb8hXUkKRyzTPqCpE2vNtFDFoN38lCPaIebl3XoGSrF
	 TVYfM3CSvp2yLnSCiIoJlgGRmDhcU9aFpgPXBWCxTnsTzimKBvgPdO9sj9fOetLnNb8+a
	 HNqXkl921S4h/fn5wpkJdj1fyXeO2eMEGyyxdbYjRZrss5JccmFGMGgtrYSzkEPnF1+cr
	 teToeIxMhqbs5rMGAURLv6mXEh21NiOpFXT9opBTUfc4nw5bxDTg5Mc7S9BCtX2f69DYD
	 UGX1SeQVZ40pY0gtQYgiQsCnPMqHWnuDcVQ7nvCi+K6qi1JWmD1pEwPrWK8B2S5AcUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795436341;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=Umx7MqyJTMzSudUEtA+X42/QrmhwHdMbkOzHYe3yn10=;
	b=JAGtuAcaL/eaJanoYbsDoEFHr5rUiVT1eNyRD8HYRdUaC2tYPrWPSOJZNFa8I2XcZj8p
	 z6Fmw+ns0D/cK7dnJVNljZQbUOtQmHspP7tG3dhSumT3Ax2YRAXpLZ/fapjSF8gg93v5Q
	 zvyDyffgms2u7SQIXpSHPiI5P/zPA7d2O9kOtUZ1Wu3s9QpPHUZcewCU1s9R0zSy53Aap
	 n29hmJaxOu86t6Qt8ctQ4XetHHNGaeSogeccwAuEwIiQWsj3p3G7mMlRifUkVlUFiZLpT
	 3HvrIl+xLzpSEtGONeI3gN+qpTwJ3tEbdD4hJTXlZYkdbmupN3lksJ5Wv1+l/4jfUfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aqwbha+h;
	arc=none smtp.remote-ip=95.215.58.232
Received: from mta1.migadu.com (out-232.mta1.migadu.com [95.215.58.232])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938CA606A32E
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 12:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 938CA606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aqwbha+h
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=44aP29+UWm9Uwp23yiAW0fp/EtdX6KADHVMxQNJBNNk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795436337; v=1; x=1796041137;
 b=aqwbha+hyfBDZhWUNqz4ZzFxa1xELUJbuhAClHTwlggj7XUGATKcJT2xL9PdrVKmHMbDMfyt
 rAoFc52clIj5jZAEG+cCKA1mF7jcQu1j7vQw6pSA2DR8M0zPS+Ulbq8FQG2iNXd5lPTJVkEUcDW
 U+bt/BXUV7L233IDPzaKJDEg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id b23c8eacef55c129;
	Mon, 23 Nov 2026 12:18:57 +0000
X-Mizu-Trace-ID: b23c8eacef55c129
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 4/4] mm: zswap: mark the zswap shrinker
 SHRINKER_NONSLAB
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261123105334.2524066-5-qinyuntan@linux.alibaba.com>
Date: Mon, 23 Nov 2026 20:18:41 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 akpm@linux-foundation.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 mhocko@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 mkoutny@suse.com,
 David Hildenbrand <david@kernel.org>,
 ziy@nvidia.com,
 baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev,
 david@fromorbit.com,
 Qi Zheng <qi.zheng@linux.dev>,
 yosry@kernel.org,
 nphamcs@gmail.com,
 chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com,
 Kairui Song <ryncsn@gmail.com>,
 gourry@gourry.net,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <89133112-E096-48ED-A4B0-E64EE319B53A@linux.dev>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
 <20261123105334.2524066-5-qinyuntan@linux.alibaba.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)



> On Nov 23, 2026, at 18:53, Qinyun Tan <qinyuntan@linux.alibaba.com> =
wrote:
>=20
> With kmem accounting disabled (cgroup.memory=3Dnokmem), memcg reclaim
> never invokes the zswap shrinker: a cgroup under memory pressure does
> not write back its own zswapped pages to make room; they are only
> written back by global reclaim or once the global pool limit kicks in.
>=20
> The zswap shrinker is registered memcg-aware but without
> SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
> before commit 03375203e1da ("mm: do not allocate shrinker info with
> cgroup.memory=3Dnokmem") it was skipped by the !memcg_kmem_online()
> check in shrink_slab_memcg(); since that commit it is demoted to
> non-memcg-aware at registration.  But the zswap shrinker is not a slab
> shrinker: it tracks zswap entries and resolves the owning memcg from
> the folio's objcg, independent of kmem accounting.
>=20
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers".
>=20
> Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
> under memcg reclaim with nokmem.
>=20
> Link: =
https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.al=
ibaba.com/
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory =
pressure")
> Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Acked-by: Yosry Ahmed <yosry@kernel.org>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>


