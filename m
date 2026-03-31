Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BDD37997E
	for <cgroups@vger.kernel.org>; Tue, 31 Mar 2026 08:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774946553; cv=none; b=QsnTbjN4FUeV3jDxOEAWoO2rr4VCVlCs90yLGJNxXOcaAPcBvH6lMmIH3VaOUQc02Sgm1CfWHmihW3FnG4ujb/G5L/2XzLnpjyKakQ5RoDucqtA1jOje6ekjAUWbdu+XqIYBUrANTZfDmtY2aVdM9uQN3XoB1sPmiBi6wLoyrhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774946553; c=relaxed/simple;
	bh=4GNHGPFsTyz4Yf6fbZ0XPlxjPrS75oHiMuE2+vDT53c=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=niI5vRgkSPjCylyrLI5EunwVZJSnnmzjm3qeDNGzzyRZXJ+20Gql2CKuLKY6TShRy6egNGqk9P6u92OA+G8SkEAy+Ez2hNuA83c6kzbDdcRMhGAwrShvE9bNuFlTpp+o5NQKhfax1CHZdGKXknNhzgSn0mOYrG4ke7a2GjTopg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GSqaylH2; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GSqaylH2"
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774946549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/AlGD7u4tl49XCgs6NmgwiGAUkvbnIHV7Y7bhbNiB1A=;
	b=GSqaylH2c7Q8tuy66qhpuXzOfPxj6bt0rDqgVSDRk2sc1JHLvey+8enRJ/spvq4w0IXqEq
	w3SiquejJLiPKkar8ZjfkDsBIpDJAcMVLzlmmI6oL/zvxeV2JScYR1GagCek2TBIGbIhnr
	NSsmi+c5ZI4YebrcSbAzSFMmi+nZgcY=
Date: Tue, 31 Mar 2026 08:42:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "teawater" <hui.zhu@linux.dev>
Message-ID: <03690880802c3b7bd03ab93ef463f0bc739e6652@linux.dev>
TLS-Required: No
Subject: Re: [PATCH mm-unstable v2] mm/memcontrol: batch memcg charging in
 __memcg_slab_post_alloc_hook
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "teawater" <zhuhui@kylinos.cn>
In-Reply-To: <20260331011647.79bdd9b9b6efb99bcbac8d77@linux-foundation.org>
References: <20260320020745.833792-1-hui.zhu@linux.dev>
 <20260331011647.79bdd9b9b6efb99bcbac8d77@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

>=20
>=20On Fri, 20 Mar 2026 10:07:45 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>=20
>=20>=20
>=20> When kmem_cache_alloc_bulk() allocates multiple objects, the post-a=
lloc
> >  hook __memcg_slab_post_alloc_hook() previously charged memcg one obj=
ect
> >  at a time, even though consecutive objects may reside on slabs backe=
d by
> >  the same pgdat node.
> >=20=20
>=20>  Batch the memcg charging by scanning ahead from the current positi=
on to
> >  find a contiguous run of objects whose slabs share the same pgdat, t=
hen
> >  issue a single __obj_cgroup_charge() / __consume_obj_stock() call fo=
r
> >  the entire run. The per-object obj_ext assignment loop is preserved =
as-is
> >  since it cannot be further collapsed.
> >=20=20
>=20>  This implements the TODO comment left in commit bc730030f956 ("mem=
cg:
> >  combine slab obj stock charging and accounting").
> >=20=20
>=20>  The existing error-recovery contract is unchanged: if size =3D=3D =
1 then
> >  memcg_alloc_abort_single() will free the sole object, and for larger
> >  bulk allocations kmem_cache_free_bulk() will uncharge any objects th=
at
> >  were already charged before the failure.
> >=20=20
>=20>  Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
> >  (iters=3D100000):
> >=20=20
>=20>  bulk=3D32 before: 215 ns/object after: 174 ns/object (-19%)
> >  bulk=3D1 before: 344 ns/object after: 335 ns/object ( ~)
> >=20=20
>=20>  No measurable regression for bulk=3D1, as expected.
> >=20

Hi=20Andrew,

> I noticed that the AI review of your v1 patch reported a few potential
> issues:
>  https://sashiko.dev/#/patchset/20260316084839.1342163-1-hui.zhu@linux.=
dev
>=20
>=20Can you please take a look, see if any of this is valid for v2?
>=20
>=20Unfortunately the bot wasn't able to check v2 because it couldn't get
> the patch to apply. I've checked that this patch does apply cleanly to
> current mm-stable, which is on the bot's try-to-apply list. So if you
> wish to get checking of the latest patch, please send us a v3 and that
> will trigger a retry.

I will send a v3 to make sure the patch is OK.

Best,
Hui

>
