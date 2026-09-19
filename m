Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DB035DA65;
	Sat, 19 Sep 2026 22:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789858296; cv=none; b=O53ujbJv4dYCopaTg87c6dAnfGLiH7SFvRRrHW6r1VxlGzi96YkaiL5t1yxNCjSiRBC6P80IxZdk5ySX9ku/666FC9A8NnWSxPJmwQ63g1bx/ewgFwg+pw368hsywTc+W0kxBZP/pvS+cW9ucEHtg80D//eDMUvUABXubRR6gYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789858296; c=relaxed/simple;
	bh=f8d7sITBlX746VHdplJawn77x/S/0Xqzqh3iLiQlXkA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LrQnIUbEs0amP3BrvfoGnW9T2AE/E37kTIdL+Jk3Ja+uLZDHUNQjHVDfJduedTFuVOE91T4MssaAey1YYwOa8/GpBAbYx4CYFseK0uuQ38rXDtEDORItQz8gr0pJOf7txTgBglBte0t1M3HBn3teX4NYuDEfuq3rbzqp9i+XsjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=PzXLo/Nq; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="PzXLo/Nq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=f8d7sITBlX746VHdplJawn77x/S/0Xqzqh3iLiQlXkA=; b=PzXLo/
	Nq6WzlrF+qYH+2ZM3LrsL+0tC1/ZVEXWSS6dkqg6eOpjgbjglyC4ZN+c9tf7o80oY+0IKP5G12fSB
	U2kKzzGJxDF3AYZfscMUGwRmSVrHKPwHIwgNLru6wacqk8AGgDg5YuF0BsEHElM0nsQSQh8SRosvo
	RXkaFlgBwU3Q72Zap4DnAEwOqLMd0efJuArtBecrNMzI2nF864X+XrrKFCZIa2Qlv3cwHTrDofx8V
	7k5pCylGInTLI4RvgeS6jOM9/RskcxQn/UMc2E+56DG48n4bge5648QYrpDftYLQl42k5TggJSiyq
	GhgmA9FWVd7ldDoqfhdHbX7wyYCA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x83sj-0000000CNrZ-2Nmi;
	Sat, 19 Sep 2026 22:50:05 +0000
Message-ID: <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>,  Nhat Pham <nphamcs@gmail.com>, Kairui Song
 <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed
 <yosry@kernel.org>,  David Hildenbrand	 <david@kernel.org>, Muchun Song
 <muchun.song@linux.dev>, Kemeng Shi	 <shikemeng@huaweicloud.com>, Barry
 Song <baohua@kernel.org>, YoungJun Park	 <youngjun.park@lge.com>, Chengming
 Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka
 (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	 <surenb@google.com>, Qi Zheng
 <qi.zheng@linux.dev>, Axel Rasmussen	 <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu	 <weixugc@google.com>, Gregory Price
 <gourry@gourry.net>, Wenchao Hao	 <haowenchao22@gmail.com>, Jonathan Corbet
 <corbet@lwn.net>, Hugh Dickins	 <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Tejun Heo	 <tj@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel
 team	 <kernel-team@meta.com>, Linux Memory Management List
 <linux-mm@kvack.org>,  Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Sat, 19 Sep 2026 18:50:03 -0400
In-Reply-To: <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev>
	 <aqP81aqNbwAbs2P0@fedora> <aqQrPLPXHXiuKup0@linux.dev>
	 <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
	 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
	 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
	 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
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

On Sat, 2026-09-19 at 11:21 -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 6:16=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
>=20
> > However, I believe we do need to take care that
> > whatever design we go with is actually able to
> > support the end user functionality we want.
>=20
> Agree. I want to add that we should support new functionality without
> sacrificing existing user functionality.
>=20
That means things need to work both for users
who want to configure a zswap size, and for
those who do not.

The cgroup memory.swap.max is an existing
interface that does that on a per cgroup
basis for swap, though in practice the=C2=A0
limit mostly seems to be set to 0 (no swap),
or to max (no limit).

memory.zswap.max does the same on the zswap
side, again mostly 0 or max are used.

Are you saying you rely on having something
like that at the system level, too?

--=20
All Rights Reversed.
