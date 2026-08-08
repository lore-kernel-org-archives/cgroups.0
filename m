Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B23C1F8723
	for <cgroups@vger.kernel.org>; Sat,  8 Aug 2026 01:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786152987; cv=none; b=RPqNGK7g91n7GIfeT4/RZgv8ATOBe8OZd+0groJQGmO2CktBMIVUJbf6t4iJeKYcpRbEZQT2ZQDz4fbwOsJolrOQTunyMaPZyxt/2hbq2TrvuE4I7VQs2WXna3RWLMtgII73s+aMGi5owCC4q00qHWhbvU1gWrfYcV2NC3rNLuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786152987; c=relaxed/simple;
	bh=VqJ/5vx1+/Tgbi7U14FnSG+i7R5Bb0mRyNoBP8I9kMo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=dFjEiZpae9DYZ5AvPqiWYMT6fobgEJahWvBhqmzBQZtcIwfmFya+oIs5JDRMmQLv3QhWSVNklbfxt9b4Oumd3LJjN/H7dezXkHp8dtXnz78UjVPmI6EPu8lOgQMN5uGfcwc7t2dEVhl8IDkz12l8YpfHebys2dj44F0Dao6HAyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LI/AXB+s; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LI/AXB+s"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786152971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mBze6R+Yde21iZRthxsluHvPvQaZpfZt7IhiN6kDbGs=;
	b=LI/AXB+sl/lAsfXlZgmEG1cRftwk6gDS1C1hOcW1gnixTb7sKudbdP/f+F4XA2F7tLCXnF
	e6sGu5pPc2E6cB4241E+FS8cHpWkWeVlOdYK7nVO+Y0KFRjnp2wcHfJhfjzfj4EZURu/jw
	/XzeJHn5jY4kzwNsJMVweKHyhZ5XDBA=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v3] memcg: keep folio's objcg same as its node
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260807142406.443516-1-shakeel.butt@linux.dev>
Date: Sat, 8 Aug 2026 09:35:36 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 Karl Erik Hofseth <karl.e.hofseth@opoint.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9B30927B-4154-4FA4-B62E-425F6EC4FA89@linux.dev>
References: <20260807142406.443516-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT



> On Aug 7, 2026, at 22:24, Shakeel Butt <shakeel.butt@linux.dev> wrote:
>=20
> memcg_reparent_objcgs() has an inherent assumption that a folio's =
objcg
> is the objcg of the folio's node.  Folio migration across nodes breaks
> that assumption: the new folio simply inherits the old folio's objcg
> while living on a different node.
>=20
> Once the assumption is broken, the reparenting of the folio's objcg =
and
> the reparenting of the folio's LRU list are no longer atomic.
> memcg_reparent_objcgs() handles one node per iteration and drops all =
the
> locks in between, so the objcg gets reparented in the iteration for =
the
> objcg's node while the LRU list gets spliced in the iteration for the
> folio's node.  Any LRU operation on that folio in between resolves its
> lruvec through the objcg, and thus takes the lru_lock of the wrong
> memcg, not the lru_lock of the list the folio is actually on.
>=20
> Fix this by selecting the objcg by folio_nid() at charge time, and by
> re-deriving it for the destination node in mem_cgroup_migrate() and
> mem_cgroup_replace_folio().
>=20
> Reported-by: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
> Closes: https://lore.kernel.org/all/anMmd1ADrDVwMO6v@work/
> Fixes: f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of dying =
memory cgroup for LRU folios")
> Cc: stable@vger.kernel.org
> Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

