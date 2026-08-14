Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333821A23A6
	for <cgroups@vger.kernel.org>; Fri, 14 Aug 2026 03:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786678946; cv=none; b=W+P8TmLsbLmFPLnylEiAIJaQePwbdUrrdPYKB4ain/kEV3wRIOFY7JHwUhtPCQv04wmsrEvdsV84wzyVoJ3X1fd5cLb9a0K1OmJuV5UKVykrZBNa1ZAvHVQE/Tjc5sYXaXqvbbeh7UOTE8D88ZPxSPN+1GIQK/RoRvzAt4HSR8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786678946; c=relaxed/simple;
	bh=SEkZgSN+NXcDybe67t2nMJKIlyyWBLCG1dqID552C8M=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=JQDFctUmIXp3quDdhgTe1D2wx57NH48gLucJgsmLyr8V37wR41DaK5oShMhGrEuqMV93Htz/5QZ1DKUERMcKu/H69PFor1OCwa9iI6i2g7D05L/Kb/iBhjuLD1abOEdN4FCZmhYGdNHRKQQKRo9Bnq6kk0Wpszz/w1MMvb9s0RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sSfvSPgA; arc=none smtp.client-ip=91.218.175.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sSfvSPgA"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=SEkZgSN+NXcDybe67t2nMJKIlyyWBLCG1dqID552C8M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786678942; v=1; x=1787283742;
 b=sSfvSPgAIlegcteFvyTTCEhNa5dtpER5JoZBySjm9A8v+sA9otQPvs8+4kPu9KyL/kmtbmus
 NSzbAEbEcCoPnugZOnZzbasFC4BPLmLaUZLxkg4afKMIcD+BliHJAFcUQE6rKZtBA7GyxHv7vNd
 UvlJ9fIPqPwVw42sp+BD6uLc=
X-Envelope-To: cgroups@vger.kernel.org
Received: from smtpclient.apple (114.251.196.97)
	by mta10.migadu.com with ESMTPS id e9ad8cb527641a7c;
	Fri, 14 Aug 2026 03:42:22 +0000
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v4 1/2] memcg: acquire peaks_lock when reading memory.peak
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260814033005.2481920-2-ridong.chen@linux.dev>
Date: Fri, 14 Aug 2026 11:42:02 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Finkel <davidf@vimeo.com>,
 Tejun Heo <tj@kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>,
 Ridong Chen <chenridong@xiaomi.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5511E37E-62E7-43E5-8A0D-BE95CC88359C@linux.dev>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
 <20260814033005.2481920-2-ridong.chen@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3864.600.51.1.1)



> On Aug 14, 2026, at 11:30, Ridong Chen <ridong.chen@linux.dev> wrote:
>=20
> From: Ridong Chen <chenridong@xiaomi.com>
>=20
> Sashiko reported that a reader can transiently observe a lower peak
> within a race window [1]. peak_show() returns
> max(local_watermark, ofp->value), but peak_write() updates those two
> under peaks_lock while the reader takes no lock. The interleaving is:
>=20
>  writer (reset on fd A)                 reader (fd B)
>  ----------------------                 -------------
>  usage =3D page_counter_read(pc)
>  WRITE_ONCE(local_watermark, usage)
>  // watermark lowered to usage
>                                         lw  =3D =
READ_ONCE(local_watermark)
>                                         // sees the lowered usage
>                                         val =3D READ_ONCE(ofp->value)
>                                         // B's value not updated yet
>                                         return max(lw, val)
>                                         // both low -> low peak
>  WRITE_ONCE(peer_ctx->value, usage)
>  // B updated, but too late
>=20
> Fix it by acquiring peaks_lock when reading the peak, so the reader =
sees
> a consistent snapshot of local_watermark and the per-fd values. The =
same
> race applies to memory.swap.peak, which shares peaks_lock and the
> peak_write() path, so take the lock there as well.
>=20
> [1] =
https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.=
dev?part=3D1
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write =
handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks

