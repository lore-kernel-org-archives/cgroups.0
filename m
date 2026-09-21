Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30224A3F3E;
	Mon, 21 Sep 2026 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999690; cv=none; b=FqkZRU1vzvXswmqPihtXKza4+ZasL8aqekwAoCsgsTwEOxtlPiE6NrqNGXkx5VZpGFtpMNusv+IjTwfBgNcU8uRV9CzviI2JHVWhd+4mtoTdw5ba1ngHGxy9TZMapmMP85U0KLzNhSlii8y/ZH2gp3tEjM978S1r9/KYHpiUmCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999690; c=relaxed/simple;
	bh=dQKhyetorp3O0zMecw8HeSSyTSsG1o6Nduy8reJfJA0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SX5DydgRaErPzcAoqPtpHKhTU5OyI8iD51T4s9cdCKalZeLpX9l4tp66V5ve8gMIz3TJE4DRhx/Xgkq57OPBYrb50petT8OTeNqUeIVjotDEOU0+eTcAixHDiZivdlrflnfqIaAwS3DVi2kebWZ1nfvW4hdsXTFl7FfesWiJeoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=YfKsUvZ7; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="YfKsUvZ7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=dQKhyetorp3O0zMecw8HeSSyTSsG1o6Nduy8reJfJA0=; b=YfKsUv
	Z7vQOifpSbfpVDG6WmMIRNoZUDazqcEysy5ysSFw2WzPKzd7IIL8e9EnVtfxT7wrOQ7+8pSoFvTdp
	1GWhwdGFlHRhTyr0q1n7ut3Jx+hEUpFpUOmOd3mQsyX/OSFWyJMgd7ps5SyZ/ddFmr/nF8BAxCjcP
	/6Cvc/ffdCjnl1VvJJJSjm9VBnQcOX0YFerpWPn9YI1ByLcCEm3NvsuYYdbP0IpW2Y3NcbKqIa9yG
	bDF6DaUNWWeUCQwS4Reukr2+F8+KXqbr0tOtlzuxPbznOFeIwT0FFi/zW6HBnhYA02DERg67u47g8
	/Xua+T4Tt3SZ42W2rsiXfhzsM56A==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x8efN-0000000D2M9-0cKp;
	Mon, 21 Sep 2026 14:06:45 +0000
Message-ID: <8aaf1f8101c9e45514af442aaf1969e3aafec4d0.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>,
  Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, Michal
 Hocko <mhocko@kernel.org>,  Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
 David Hildenbrand	 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi	 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>,
 YoungJun Park	 <youngjun.park@lge.com>, Chengming Zhou
 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	 <surenb@google.com>, Qi Zheng
 <qi.zheng@linux.dev>, Axel Rasmussen	 <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu	 <weixugc@google.com>, Wenchao Hao
 <haowenchao22@gmail.com>, Jonathan Corbet	 <corbet@lwn.net>, Hugh Dickins
 <hughd@google.com>, Baolin Wang	 <baolin.wang@linux.alibaba.com>, Tejun Heo
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>,
 Meta kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Mon, 21 Sep 2026 10:06:44 -0400
In-Reply-To: <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
	 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
	 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
	 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
	 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
	 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
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

On Sun, 2026-09-20 at 23:43 -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 3:53=E2=80=AFPM Gregory Price <gourry@gourry.net>
> wrote:
>=20
> >=20
> > I want:
>=20
> >=20
> > =C2=A0 1) zswap on machines with no swapfile
> >=20
> > =C2=A0 2) without being asked "how big?" - there is no number I can giv=
e
> > =C2=A0=C2=A0=C2=A0=C2=A0 that stays correct, and
>=20
> Because you can't answer a question, we have to bend over backwards
> for you? That does not make sense.

There are millions of users for who the system
should just work, without having to first answer
your questions.

Their use case is legitimate.

--=20
All Rights Reversed.
