Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=96.67.55.147
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792865870;
	b=P4BZWA8CdHp/DKdZu4NozP0DmB9Fh0nvbVRa/Yd90xdF6udRATve54qPu8qhueT3bNND
	 fMJJHIK9CtZ6C6p6SJ+NysqzWtmo1lgTv1dEeILS5sG0zqZPML7EXPo83A9WD8YYvZ/Ba
	 lsSlSqI3bq5dAHdicexFeybB0/bIyh3kw0ooj0lAVhcZjRJOPEl1SQXaKdl5SAK/55AR0
	 dUvZrtw5+L0mq1HxmEQMGdSyrAalLeJKH40jtmkUTAgEU5Loieg19Sj1V/vjedzdEdB0P
	 FiRddKttoRUBN0LvUOCAcGTV0K05SQ9zcLSg7qwQaG/1xN5cqQIjCRNBw0B9qsPW7Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792865870;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Autocrypt:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=0jMdLT1l8NorjwtJyBZp0a/DpvOIqtUImmcgSCvCgG0=;
	b=fjsV8MajqCRVQ63Em7UY9q6IuFq4ZD3sVMbkWqDoHEVT+1cwxgVz3PrJVaKHkIs7SVPD
	 f/8rBkRKXq9xdQGSe+yBk+SawPn2PSQYLJVzFF8TnBfs1tXg6tLitsEzS4IrQgUubMnl/
	 sf3JAeCeAi5sAaqYuv40YeUd/OJ3idjTGhPXkNdlomELvONkRhagfn0vz7Ci45gvvVlBI
	 wGn6XgpQomujOdX/j9g9vH27UZUz2WVX96i7fXGzFc1J6JC7MVvu+7xVJJQhP2WI7MJQ9
	 rNK9EnocSb7Z8qqrmWP5I64xkaSsBDpgT+bc/xoOLRLsP4nxOF2OzX6X2YvPTMiP6zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=surriel.com;
	spf=pass smtp.mailfrom=surriel.com;
	dkim=pass header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=VPZqxrFN;
	arc=none smtp.remote-ip=96.67.55.147
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4B7606A31A;
	Sat, 24 Oct 2026 18:17:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC4B7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=VPZqxrFN
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=0jMdLT1l8NorjwtJyBZp0a/DpvOIqtUImmcgSCvCgG0=; b=VPZqxr
	FN0MWEdmme3mXeJb8f87B7L94FRIu0VffH3tEQTevshBuQpaapaEIL3YGatd4lApwMK3mcac9DaOD
	QjuqmEUNHKaP421OfKpkO22PE9jOPjAm/65ODyU1Ce36EsVzXGSuALnymSSYjE/x42BFyT0C8bgpp
	00pOy69z7gtYpr93/5HxeCd5d3OwF2YjZ8VD+pQAPU20v2bqvNXa3qAGtnxycW5kXAM+Pxfqjburm
	fIMT/5hb0Eno9/tztvlCrwJ2RoGVWHor74UGI0Us6y1Kfs/hn6MoL0wbAIuHMf+8Z4SEEv3E7ef1Z
	jDAxujKIRhOHgRcOO/2ONCES4MFQ==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xKgIM-00000008cYE-1icT;
	Sat, 24 Oct 2026 18:16:42 +0000
Message-ID: <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
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
Date: Sat, 24 Oct 2026 14:16:41 -0400
In-Reply-To: <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
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

On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
> > >=20
> > > * Swapoff: this was brought up as a request, but we ran out of
> > > time
> > > before we could discuss the motivations and use cases behind
> > > them.
> > > Folks interested, could you explain as a follow-up?
> >=20
> > This is one that I really don't understand.
> >=20
> > In my mind, we have vswap sitting as kind
> > of a swap VFS between the rest of the system
> > and the swap devices:
> >=20
> > +-------+=C2=A0=C2=A0=C2=A0=C2=A0 +------------+
> > > vswap |-----| swap cache |
> > +---+---+=C2=A0=C2=A0=C2=A0=C2=A0 +------------+
> > =C2=A0=C2=A0=C2=A0 |
> > =C2=A0=C2=A0=C2=A0 +----------+-----------+
> > =C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> > +---+---+=C2=A0 +---+---+=C2=A0=C2=A0 +---+---+
> > > swap=C2=A0 |=C2=A0 | zswap |=C2=A0=C2=A0 | zram=C2=A0 |
> > > file=C2=A0 |=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=
=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
> > +-------+=C2=A0 +-------+=C2=A0=C2=A0 +-------+
> >=20
> > When a page is unmapped from userspace by the
> > reclaim code, it goes into the swap cache.
> >=20
> > The vswap layer then decides where to store it
> > at eviction time. This is configurable by userspace.
> >=20
> > If the zswap pool is shrunk, the vswap layer knows
> > where to put the data next. There is no need to
> > change page table entries to indicate that the
> > data was moved from zswap to a swap file.
> >=20
> > If we decide to disable one of the backing swap
> > devices, the vswap layer can just move the data
> > into the swap cache, and the page reclaim code
> > can evict it into a different backing store, if
> > needed.
>=20
> And in this case we want to disable vswap itself.

OK, so you are looking for a way to totally depopulate
the swap cache, in addition to swap files, zswap, etc?

I think we can accomplish that by simply keeping the
current swapoff code around, which scans through the
virtual memory of all processes and brings the memory
out of swap.

>=20
> I also hope there is a way to release swap metadata completely too.
> e.g. for fs, you at least have umount, and can rmmod the fs itself
> afterwards. We also have many ways to bypass the page cache. In cases
> where a virtual layer is just a burden, we want raw physical swap,
> and
> the ability to swap off that too.

The VM cannot operate without the swap cache, though.

That is very much built into core parts of the VM.

However, having swapoff remove all data from the swap
cache, after mapping the memory back into userspace
page tables, seems like it would be fairly easy to do.

Does that meet the needs of your use case?

--=20
All Rights Reversed.
