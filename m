Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35FE285CBA
	for <cgroups@vger.kernel.org>; Fri, 22 May 2026 06:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779431294; cv=none; b=SvwoaibcdXImJN6ISNPFKKD8Sr/wRQpajeM8Sp7WzlfEv8QSBANWeOlDy/jkJqvyuFCepQynLwBMWwC3Q3iNTyxP+DG53V9q5XTBLAwTbc7/fXAiW1FvSlEI29eIdLKVteZzXEyWilOTdaFnuEbu3SO9ohm5BSv4scu8zbvwbuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779431294; c=relaxed/simple;
	bh=zttAzZFpb/rKwt2oY4sDdSbhgKaoVXl86Zh+IIWqhto=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=j5Y3029zzK3sVe1+6cfzDxiBvdqSQHzKcozsODHUp7VQi0sNy3S68K0nrGPy1hZUh/r5Mi5Ae9KRAgLpQ2V2ZKeIEsgzKzIHjG5ZfZckLDg0V/KGWv6T708NT+nhZnWSmy9aY5qTWUQPYH9G4I67p9TFLlNbQp2kX+bpcr86Cv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cItYrSPg; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cItYrSPg"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779431288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zttAzZFpb/rKwt2oY4sDdSbhgKaoVXl86Zh+IIWqhto=;
	b=cItYrSPgRfneBTRSimVdj84tcSYtIdaa/RSrXXrLHb2568Hv8ALnbX7lnsOH39up2ldJzm
	q5g4TntcMStGhHSSdbkGE7OgiQG5qjr6oTjCPMP7mC3FX7trLP5s4ot645kaqaoWV0pJUr
	MBn4S4Ptzuaynj9wVu3ePAtfOwp2Y2A=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 3/4] memcg: int16_t for cached slab stats
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260522011908.1669332-4-shakeel.butt@linux.dev>
Date: Fri, 22 May 2026 14:27:23 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7706EBA4-B9A1-4E33-AE96-9D351D91EBE2@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-4-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT



> On May 22, 2026, at 09:19, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> Currently struct obj_stock_pcp stores cached slab stats in 'int' which
> is 4 bytes per counter on 64-bit machines. Switch them to int16_t to
> shrink the cached metadata.
>=20
> The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
> PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t. On 64KiB
> pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
> sufficiently long run of accumulations would overflow the cache. Add
> an explicit S16_MAX guard before each add: when the next add would
> push abs(*bytes) past S16_MAX, fold the cached value into @nr and
> flush directly via mod_objcg_mlstate() before the accumulation.
>=20
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg =
per-node type")
> Tested-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.=
