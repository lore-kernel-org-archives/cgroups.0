Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=96.67.55.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793030423;
	b=jIjMCwfLHj0LKNNnWiPpn4P5FotfbqpFBE/gNMNRFniAcaIUqWYLKl+sii/sHLjZd/QW
	 cB3T9zq7dOSLfIE+l4Xsxr0IfeiHmcQRmr7/cHUa3Q6VxPFBSB0KzSlNM3l949/EPUZDV
	 t9rDcnyqe9aP4YHjHnSwk9XqsCjjqJBAnBcixCDuseUlB4ALI3Vh64VMuW1fmktu9ifbF
	 w43Vq6hl56yRvWQZ+I647KfJY2fVeUO6hEt5y2jX3Ca0yakr3cc4CAtbl2rPVtkYb0+xx
	 Tt8v9/lPcsarUeaP49bNqeuYZTD031ZtkJ31aN2WmRcYa0o8kOWMOTXoKWKg0OGr2mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793030423;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=2IYnJWIdmisQFzrKQUkCcuczzZRiHZa2yg/KvW4ePcc=;
	b=AlUPWtIsH5R7y7XA7/Fj/eZjEa+BWndL0InemMHsDVDzM0vgYMerrG8c5iPjR84vgcWo
	 LUPFIQbTaYpso09AKAf1NKkjyuestkguHzsy99DWUBW++cWz5hYzQoF3QqsWRmSzVVvyr
	 IbP4p22g6Up6zU9kNUkZfM4iNmkEc34CnodI76ia3JILtMfyn0fmLV0rGW/aKeKTtep9b
	 BM1YXUzSSjyTLeKAdtkZPLjs8dFub7aHCsrpsrlToR3aBvzUfcu5hNkNNGT5sa8RH/m7A
	 fB5yDI+1oUoEdRxiMGsHg05zeAVifW47Zo9tnftgXgL9kLcY1opM1XvEpVSrI2Ld8IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=surriel.com;
	spf=pass smtp.mailfrom=surriel.com;
	dkim=pass header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=JuAIutRo;
	arc=none smtp.remote-ip=96.67.55.147
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CEC606A31F;
	Mon, 26 Oct 2026 16:00:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35CEC606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=JuAIutRo
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=2IYnJWIdmisQFzrKQUkCcuczzZRiHZa2yg/KvW4ePcc=; b=JuAIut
	RoC4Cq2nPGXCBH+jTxgWy49Lbxu4jcgzQofxjI77DLR9MvN30SnoY5HYeRK6Z94ySxpYQrgieDz2/
	XIU9TzritE2mhW3qByP+jxwpHfp92h8gx3Af+UcJdQHQFmgN5Gobyd6Zh5EzvmfI6t271k/VWkANG
	hKrMe8WRsR5U5Y6GBfE6KXPmUhrAgC35ccFVR/CYlr/zNESwaI0r2xxVYhrGdhgoB/EmqdbfGnBbR
	CPjDB4SolTrO9Vqf6+pVjBvxHyBAYuGZ3CQBWIAI7+UCzsytes6hYSmtNsZP+PV5cqal7qzy6Eoh3
	GOoJyVMS8lYzJZshdOJM5iCpwfYw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xLN6A-0000000A1Pf-20ZE;
	Mon, 26 Oct 2026 15:58:58 +0000
Message-ID: <340025b7e3bdc6d905da2cd052ccbbda63a58ac0.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>, Chris Li
 <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Michal Hocko	
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt	 <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, Muchun Song
	 <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, Barry
 Song	 <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, Chengming
 Zhou	 <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"
 <ljs@kernel.org>,  "Liam R. Howlett"	 <liam@infradead.org>, "Vlastimil
 Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 =?UTF-8?Q?Baghdasaryan=EF=BF=BC?= <surenb@google.com>, Qi Zheng	
 <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu
 Xie	 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price	
 <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet	
 <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>, Meta
 kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn	 <joshua.hahnjy@gmail.com>
Date: Mon, 26 Oct 2026 11:58:58 -0400
In-Reply-To: <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com>
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
	 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
	 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
	 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
	 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
	 <aqgMCIOFi0dKx_6L@fedora>
	 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
	 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
	 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
	 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
	 <20261014195354.GA371161@cmpxchg.org>
	 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
	 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org>
	 <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
	 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
	 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
	 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
	 <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
	 <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com>
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
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sun, 2026-10-25 at 12:21 +0800, Kairui Song wrote:
> Rik van Riel <riel@surriel.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8825=E6=
=97=A5=E5=91=A8=E6=97=A5 02:16=E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > > On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.co=
m>
> > > wrote:
> > > >=20
> > > > In my mind, we have vswap sitting as kind
> > > > of a swap VFS between the rest of the system
> > > > and the swap devices:
> > > >=20
> > > > +-------+=C2=A0=C2=A0=C2=A0=C2=A0 +------------+
> > > > > vswap |-----| swap cache |
> > > > +---+---+=C2=A0=C2=A0=C2=A0=C2=A0 +------------+
> > > > =C2=A0=C2=A0=C2=A0 |
> > > > =C2=A0=C2=A0=C2=A0 +----------+-----------+
> > > > =C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> > > > +---+---+=C2=A0 +---+---+=C2=A0=C2=A0 +---+---+
> > > > > swap=C2=A0 |=C2=A0 | zswap |=C2=A0=C2=A0 | zram=C2=A0 |
> > > > > file=C2=A0 |=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=
=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> > > > +-------+=C2=A0 +-------+=C2=A0=C2=A0 +-------+
> > > >=20
>=20
> > However, having swapoff remove all data from the swap
> > cache, after mapping the memory back into userspace
> > page tables, seems like it would be fairly easy to do.
> >=20
> > Does that meet the needs of your use case?
>=20
> Right, it's nothing hard, as long as we don't add mandatory new
> layers. For very high bandwidth swap devices, a mandatory indirection
> layer is pure overhead.=20

Don't we need a swap cache lookup regardless, to
make sure the data we want to swap into the
process is not already present in memory?

At that point, it shouldn't matter whether we
get the backing swap location from the swap
cache lookup data structure, or from the
page tables?

We have the page table lookup, and the swap
cache lookup. That is two lookups, regardless
of whether there is indirection, or not.

Am I missing something?

--=20
All Rights Reversed.
