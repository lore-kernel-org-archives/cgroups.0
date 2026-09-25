Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFE528B7D3;
	Fri, 25 Sep 2026 01:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790299494; cv=none; b=ZavufOLXVbOln5wyBScChLzvUhxPoyFSYB3Cn3yKBpZcLrmzmVaDNgJQ+TpRiUpitFX27Hex72Q10XZl4JS27boeFGCv3xMUBjPONsvYYYoHpVzXH+kOTpE5YBjabXhWGTSsI+PL2leuSsd50w6ygQitcRKtgTIkWrMKIIAVT/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790299494; c=relaxed/simple;
	bh=+QJhA9zddl3SAwvYptEXzT6UeU8NIqwXH98v6Wc6pJI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=msecI0RG/Q+8/nGUO0V8+1Oej+r+kBBGknso97mxzttHb/iaQJlSa/+eV0naGd+p+D29BvU7eHttQuYGjUgHKCbWbnf1GDtCbga+IE8u35r8QUFGa84wwqeCrRqSN+m1k6sZPlhvEraUfkcXqGCEvO9EacUFVeg7yfrQUsA8rQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=KQV7Ee7t; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="KQV7Ee7t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=+QJhA9zddl3SAwvYptEXzT6UeU8NIqwXH98v6Wc6pJI=; b=KQV7Ee
	7t4+XAuk0sJ44jy3lpdCzNfmWKKj0qS8voqY66n2cj9tDXdlyk4eF0mrKIjaQmaDqpo5tLMXwIz62
	u12mbSS5h3qOLLW4uIu9214aO4z5bG+WkrVpolUmyxWBphu7M79V7g5dYGuLNxuCg4gPTgxEUpJnX
	Uri96RESR3bCk0lHHC6dGT0n9Ay3RvoY4b6BuAOroOUZDwbb0hoDiA2O3kXwXz5aEq/6aQqSdpSiW
	hPP52M7cfnDYfrBpPMjf6D9f0BG3nH16V9MU5AXzGIw9cf0ec6caCiZahPN20Q/Ud71BPecafCSPv
	gDVWxEp0O/Tu+GzkRerK10oswhUg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x9ufC-0000000577C-3RjT;
	Fri, 25 Sep 2026 01:23:46 +0000
Message-ID: <a30eb60221cda2fe726a86c2c6f859f71fc7a46d.camel@surriel.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device
 infrastructure
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, 
	david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, 	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev,
 axelrasmussen@google.com, 	yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, haowenchao22@gmail.com, 	corbet@lwn.net,
 hughd@google.com, baolin.wang@linux.alibaba.com, tj@kernel.org, 
	mkoutny@suse.com, skhan@linuxfoundation.org, kunwu.chan@linux.dev, 
	kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Date: Thu, 24 Sep 2026 21:23:46 -0400
In-Reply-To: <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
	 <20260918180241.3424851-2-nphamcs@gmail.com>
	 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
	 <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com>
	 <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-09-24 at 15:17 -1000, Chris Li wrote:
> On Thu, Sep 24, 2026 at 8:13=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Tue, 2026-09-22 at 23:18 -1000, Chris Li wrote:
> > > On Fri, Sep 18, 2026 at 1:03=E2=80=AFPM Nhat Pham <nphamcs@gmail.com>
> > > wrote:
> > > >=20
> > > >=20
> > > > @@ -482,6 +491,11 @@ void swap_read_folio(struct swap_io_ctx
> > > > *ctx,
> > > > struct folio *folio)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (zswap_load(folio) !=
=3D -ENOENT)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto finish;
> > > >=20
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(swap_is_vswap(si=
s))) {
> > >=20
> > > There are too many swap_is_vswap() in this series. It fragments
> > > the
> > > code path, making things harder to reason about. Esepcially
> > > around
> > > locks. I count 22 in this patch alone.
> > >=20
> > > I consider this the biggest drawback of this series. This
> > > fragmentation of the code path.
> >=20
> > Could we avoid that by simply always having everything
> > go through the vswap abstraction layer?
>=20
> Yes, but it will pay the price for going through the unnecessary
> redirection layer always. It incurs performance and meta data
> overhead. That was one of my previous objections to the earlier vswap
> version. Sorry I enjoy micro optimization too much, that is both my
> strength and weakness.

We really only have two cases here, don't we?

Either the data is in the swap cache, and
the vswap layer can directly look up the
swap cache page.

Or the data is in some slower back-end,
and doing a second lookup is not going to
introduce noticeable overhead.

If the micro optimization come at the cost
of less flexibility, and harder to maintain
code, are they really worth it?

>=20
> > Handling the details of what's behind the vswap would
> > be handled one layer down.
> >=20
> > Chris, do you think that would be cleaner?
>=20
> If it can wrap below the swap_ops, it is just priviate inernal dedail
> of implementing its own indirections. That would be much cleaner.
> That
> is what I am trying to pitch to Nhat in prevoius email but does not
> have following actions.
>=20
Can you sketch out the details of what you
think that should look like?

What would the data structures look like?

What operations should there be at the
abstraction layer, and at the swap layers
below?

How should migration of data from one swap
backend to another be handled?

At this point the best way to make progress
would be to hash out those details.

If you are unhappy with what you have seen
from others, what does your ideal design
look like?

--=20
All Rights Reversed.
