Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A6538D6A2;
	Wed, 23 Sep 2026 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173351; cv=none; b=oYbvAcwtybNQmOP+ZQTCVLuNPXRj5xgjy8XZaWteCkjNQ4nSoNvh+YPLXVwWQyGGZO8IE8B1ZjnMI/6Hf6EYVbOqBCsLF5nJTRvUREw4zu2Qv0ELnuYpIRqrgkV/Ie39SgK6U0s89ZFie3TCtRu5eS5C+mgUy7DJy+gT8++VJnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173351; c=relaxed/simple;
	bh=W89cXpAHB1FMGHDJbriYSGL15CQFOTzD4nfyYDTgBjA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rtv35e2IO6CoI+h5fLESZeYJC23NzoK5A1vBOTKl21/pYBQaHYIG+ZAMXp9Eb2QHbP3xgw0wgh2wxNFgKogpKip6u1UTCGiLzLS2ymdkk3msgGZI0MeUda5n6layomzVPfi9dzgLhSvmGddQuD86L0W2r9kS1kDqncMoRvGHxxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=Um3FXi8K; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="Um3FXi8K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=W89cXpAHB1FMGHDJbriYSGL15CQFOTzD4nfyYDTgBjA=; b=Um3FXi
	8KUrGFrmUZp/b8RXs+vnR7SswoKSQrK47ivQYukgP3XMcRTyYr4DQhXBrLW5nKV9HfguhjILmFVyr
	/aUV0VDgTbYImCBSzqOf5hFCdkzn2jemMn9+NL/YKgVjeZxQdidHi6qtIf9LbeCTqjbfLRV4P80O1
	gxxn1uhuRfrHSCqGvH4qQuDUzElVdiajpR/Ue9Ay4nUL1LX87FeE+kRihRl/ntoZ9h9/X+xSZXGll
	JxydMp000KAp4JaG2hX8ja20Dlcp+VmkgInSAQjtINg797z+I8E/W/MG6zUmvF59ZkmM46TdixHAM
	nvZp+DOjLKT4AVvyCtpdcaLSM/Wg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x9NqS-00000002OE6-2Sw2;
	Wed, 23 Sep 2026 14:21:12 +0000
Message-ID: <013e65703413af4ce94cdd2b110763cc3efc460b.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>,
  Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Kairui
 Song <kasong@tencent.com>,  Michal Hocko <mhocko@kernel.org>, Roman
 Gushchin <roman.gushchin@linux.dev>, Shakeel Butt	
 <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, David Hildenbrand
	 <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, Kemeng Shi	
 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, YoungJun Park	
 <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen	
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu	
 <weixugc@google.com>, Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet
	 <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, Baolin Wang	
 <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, Michal
 =?ISO-8859-1?Q?Koutn=FD?=	 <mkoutny@suse.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Kunwu Chan	 <kunwu.chan@linux.dev>, Meta
 kernel team <kernel-team@meta.com>, Linux Memory Management List	
 <linux-mm@kvack.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, 	linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <ryncsn@gmail.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Wed, 23 Sep 2026 10:21:10 -0400
In-Reply-To: <CACePvbUHoJ7bBn_iKrMyducFzKkHpfe8htZZYW=b8v+EGRF2jQ@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org>
	 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
	 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
	 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
	 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
	 <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
	 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
	 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
	 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
	 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
	 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
	 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
	 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
	 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
	 <02616d611c9e862afc6c8c3118b6be096756b3bb.camel@surriel.com>
	 <CACePvbUHoJ7bBn_iKrMyducFzKkHpfe8htZZYW=b8v+EGRF2jQ@mail.gmail.com>
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

On Tue, 2026-09-22 at 21:00 -1000, Chris Li wrote:
> On Tue, Sep 22, 2026 at 5:49=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
>=20
> >=20
> > However, your configuration values are not a good
> > default for my setup.
> >=20
> > I believe we need to set the default to something
> > that accommodates a diverse range of desktop and
> > mobile users.
>=20
> Act. That is why I am asking for the maximum percentage that
> represents the upper bound for an actual usage case.
>=20
I think the workload that can use the most zswap
is probably a build system that places its temporary
files in tmpfs, in order to cut down on SSD wear.

Those files are just sitting there most of the time,
and are not part of the working set.

I suspect for such a workload we could get away
with maybe 30-40% of memory taken by the zswap
pool, which with a 4:1 compression ratio would
correspond to 120-160% of memory zswapped.

At a more pessimistic 3:1 compression ratio,
which seems to be fairly typical, it would
be 90-120%.

> >=20
> > Most of those users do not know what they will need,
> > but they will know to close a few browser tabs when
> > things get slow.
>=20
> They don't need to know. Such a bound exists naturally. We just want
> a
> safe margin. You say such a boundary doesn't exist. I say that
> boundary exists; that is the main contention.
>=20
The current default in Linux is to allow the
zswap pool to take up to 20% of memory.

That results in 60-80% of memory swapped out
to zswap at most, at typical compression ratios=C2=A0
of between 3:1 to 4:1.

I suspect a few workloads would benefit from
having a larger zswap pool.

> I agree; I wouldn't want to configure each machine differently all
> the
> time. In my mind, swapping out that much system RAM to zswap already
> results in a very unusable system. If you haven't try that, I suggest
> you try it before suggesting a number > 100%. At 100%, it is not a
> usable system, so we don't need to make a default for that.
> Defaulting
> to 8PB or 8TB is way too much.

But we don't have a default size.

Zswap starts at size 0. The memory is only allocated
when it is needed.

The vswap data structures are the same. They get
allocated when they are needed, and freed when
they are no longer needed.

It isn't like we need to pre-allocate anything.

--=20
All Rights Reversed.
