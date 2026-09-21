Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859C84F7CC4;
	Mon, 21 Sep 2026 18:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790016849; cv=none; b=cTz48aB3UziOZHEet/4+br7yB4/TV6FbNMWOmru9hcUfG9/ZuW062Pash5zCcNTRWmJGAPj3vVtPmh81B18iCVST33BnDEKXOEBaOI7RUkHgAEN8ErgR0HMD+YNB4NlsQpdYV4gcu8XsNacpEK++q416V/l8YQxunbiIdaGz7po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790016849; c=relaxed/simple;
	bh=ZGqSTSyyF/esv6R1Ph1sURB78E4XrVY0xJqmDif7g9U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MjjzU7wrjLanEVXNfK2qxsZtTniieQp9FcxseS6FpBTjNRqGLK15Wq5d7YC/yRO7tADdz/JPOSDG+peQdLytHE6TnsgXxevefZuGvalOJP9Dlg08aXNfFYd5mDMSNuY9CJqhsNXzPofug/JoZIDJxgtn4vWdVeXD4zh0XrXoZ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=KodpkJSy; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="KodpkJSy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=ZGqSTSyyF/esv6R1Ph1sURB78E4XrVY0xJqmDif7g9U=; b=KodpkJ
	SyxcwQTBCoNJd8jU7Csq/+xxRTSyQ+WaFjm6KeqIdypMNO0GoLn0kUaKBp6djAqguW0m5QqzbYwZF
	kbGbDuKkR+t2Ge7NK5gAWq/9TFvvKmgNO3OT4+y46Cj7kzRVnNcGZQJ4aSZGu0gznSnhPUFUGiVEW
	4OglxRiBHKq81KszPWMD33u6zSKAb/arxxlmn4SRGf+6mu6LLIuXdA7nUqhbCteLqYh80d2RlZKxC
	8oWDo2k3VgkUv93/gw2vBtZ05p98YqAIUdjotA4pclAIv5T8KWydV+3kpCJ/uwITnt3bpBQiGXUnj
	Kx/4G61Qf2o2QMeEzZKnEBW2HZ5w==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x8j8B-0000000D6Yo-3euh;
	Mon, 21 Sep 2026 18:52:47 +0000
Message-ID: <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
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
Date: Mon, 21 Sep 2026 14:52:45 -0400
In-Reply-To: <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
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

On Mon, 2026-09-21 at 08:10 -1000, Chris Li wrote:
> On Mon, Sep 21, 2026 at 6:40=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Mon, 2026-09-21 at 06:31 -1000, Chris Li wrote:
> > >=20
> > > Give me some real-world examples of people hitting this kind of
> > > limit.
> > > e.g. MAX(%)=C2=A0 > 100% and still have a usesable system. I suspect
> > > that
> > > with 100% zswap usage, the system becomes unusable. Please show
> > > me a
> > > real world case that proves me wrong.
> > >=20
> >=20
> > Here's my desktop system right now. The amount
> > of Zswapped is more than twice AnonPages, and
> > the system stays perfectly usable.
> >=20
> > $ grep -E '(Anon|Zswap|GPU|Swap)' /proc/meminfo
> > SwapCached:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 252340 kB
> > SwapTotal:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 41523604 kB
> > SwapFree:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 9802088 kB
> > Zswap:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8812=
236 kB
> > Zswapped:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 24927876 kB
> > AnonPages:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 11615760 kB
> > AnonHugePages:=C2=A0=C2=A0 1402880 kB
> > GPUActive:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 13112428 kB
> > GPUReclaim:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 95980 kB
> >=20
> > This is also an example where I cannot really
> > predict how much zswap space I need, because
> > that depends on what AI model is loaded,
> > which drives the GPUActive number, as well
> > as the number of browser tabs.
> >=20
> > The system is perfectly responsive.
>=20
> Great, that is getting somewhere. We are talking about actual usage.
> I
> really appreciate that.
>=20
> May I ask what the total amount of memory (RAM) in your system is?
>=20
> I am not asking zswap compare to ANA memory. I want to get the % of
> the total RAM.
> I assume your desktop has more than 8G of RAM, right?

Right now it has 64GB of memory.

However, if I were running with 48GB, I would
need MORE zswap space, while if I were running
with 96GB, I would need less zswap space.

How can people be expected to figure out how
much zswap space their system will need,
when the amount needed to fit a workload
does not have a positive correlation with
the amount of system memory?

--=20
All Rights Reversed.
