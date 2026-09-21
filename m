Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EBF1FC0;
	Mon, 21 Sep 2026 00:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789951043; cv=none; b=FNJyeHJR4KJK0YkJAq20a1Wnz/kE7qIqftKPYwy3729b2f/uZKgsBrscJG3K3ijZKX3Tgpw32C/Hf1PcZLG/sjIoRpPsNW20Bz0qxZOhoMSi/IUd3/MTLNGrJuJUkpiuAVDjPot8r+h4SmE0c4FLBC4o3S0owGm96eiiYeWjlOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789951043; c=relaxed/simple;
	bh=jUSdsryHLUcbcflpvGA1b+Rdye8ulVCq+UtIvIPiFvY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VucZjk4KUZzLcYIHzOnDqKVwbD0e6Ni3PjXmojvpDnUN35ioAaQnBM34WU2j0oCU/oV6czWPiS1yJNVDGSrZLNEpSxNCkezhCtiMTE1zbPMconbPLL3BUvR+v8lv+GEqbSRBY8Bv5OUOPHs1Vhdkrf1vRsvkngmdcY70wItpJd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=R7ImQD2/; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="R7ImQD2/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=jUSdsryHLUcbcflpvGA1b+Rdye8ulVCq+UtIvIPiFvY=; b=R7ImQD
	2/EHjNxEdtg4pd3vjaPfRh/m/a15X13i17xBqOkSfDP9p9pneJaTIM6Xp6GaZOYqW1+V5AyST+DF+
	q/bM/BU2+dJKginoE6zAuF1w23S9m8LU9ZHn0lBYekN/qL016QZY362rW0Ka9etYntRx8mAYFINYt
	Z4NNoYQ/bCmXdnnlp27InzAXbgGoER9co/65F8Rgynhim/ysBHbW7O6s4rJcKKUh2n9e9JwAKilUY
	fQz7VdZyNIemn1Z9mhtM6PeSlGvmduF/R3Wtv3n+7nG14vNPachv2SRbdSpjb0yANRZz7vAmkP1Oo
	biL6r86xHXNitbpCJNhH1vKfEZcw==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x8S0h-0000000CnAC-3ZS3;
	Mon, 21 Sep 2026 00:35:55 +0000
Message-ID: <da13e0e48568da3ccccc304aeb449ababf085e14.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, Roman
 Gushchin	 <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Yosry Ahmed	 <yosry@kernel.org>, David
 Hildenbrand <david@kernel.org>, Muchun Song	 <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He	 <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, YoungJun Park	 <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)"	
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
 Joshua Hahn	 <joshua.hahnjy@gmail.com>
Date: Sun, 20 Sep 2026 20:35:55 -0400
In-Reply-To: <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com>
References: 
	<CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
	 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
	 <aqBT_35E-eSoN_zj@cmpxchg.org>
	 <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
	 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
	 <aqU81l1oqGItb-0C@cmpxchg.org>
	 <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
	 <e42d8bb0bb13067609e8ff8c858a26ca056368bd.camel@surriel.com>
	 <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com>
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

On Sun, 2026-09-20 at 14:18 -1000, Chris Li wrote:
> On Sat, Sep 19, 2026 at 3:07=E2=80=AFPM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > >=20
> > > For our deployment, we only compress about 7-10% of the system
> > > memory
> > > before performance starts to suffer. The feedback loop will scale
> > > it
> > > back. I am very curious do you have actual work load to swap out
> > > 100%
> > > of the RAM.
> >=20
> > One common workload is a web browser with idle tabs.
> >=20
> > Those often compress pretty well, a ratio of 4:1 is
> > not unheard of, which makes it easy to fill up
> > 1/3 of memory with 133% of memory's worth of compressed
> > memory.
>=20
> You did not answer my question. You are talking about user-space
> processes (browsers). Do you run your browser in the data center, or
> is that a laptop workload?

The browser runs on the desktop, but the same
kernel runs on both.

The things we build here cannot be optimized for
just one single workload. They have to work
everywhere.


--=20
All Rights Reversed.
