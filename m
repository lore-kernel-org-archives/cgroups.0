Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D3345CBC;
	Sun, 27 Sep 2026 18:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790532821; cv=none; b=fZJCBtWMnvQhLmRUB6sUFzmycJ/XwabjeTscrIf4n9RGUoI37A5BoadYEDpWqKHXu36Q54I5ePk2vYb3ES3NmdMdzAPFGs/GpUWLRAAjR913m4KXqe3CYyvFK0PFHLDVcDTT/zG/Dl/Bq2MupX9aaVDXBJZdoV3Xb0yBgnmKuzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790532821; c=relaxed/simple;
	bh=0P7tqyZTwzBwbJvaiPJZX0pDFmwUCv9lhS7oxqr+H94=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WOrIGpWqnRt1RMVuMpPI4ACBe44eR7m217Oh1ziR4k9yNZ8COEeGWnkeCb2V7EZzhl1VD6w2jkHwj9L2rR0T3MaugjBnBkeI1PUVKDo4ACR1CMrTsCEyYgItvB4OKhWTAxYd5UgGX0V9dep/FBSipu8fjefTi9JmspRciai36M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=PdcFTXwt; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="PdcFTXwt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=0P7tqyZTwzBwbJvaiPJZX0pDFmwUCv9lhS7oxqr+H94=; b=PdcFTX
	wtM8Csj5/XVIZsrFPtA4zd1u+xYyJHfmIQC/uIRk6E0k0jIBe6GvUDGczEER32hmLzbPxNu3jnzgh
	lET5XamdnQ2iNW1x32dwQKM3W1G419i/YjEy17UQ7/VhUmRlxn3mGUUQu5MrvQM1mJzyo0EewUfFo
	AvzDic+FDT22YdHnN2iy7rhbE7TeSJ2x0DilMe9DDOSrEEqISYiuje9ZgS8MmXwJ9dWpayLgIP/qb
	nd17GKQbn2xQVNwLFhmmtPY6L+gUh94Qe654vFjeBreAnefoqaC+8r+2UeLDsYLbBukf/Y016IQHP
	f1jBwy1IlQVgGqzs+OMu1vr4pBmQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xAtMD-00000009nLA-2XiP;
	Sun, 27 Sep 2026 18:12:13 +0000
Message-ID: <1739d52dcdebdc589826990ef2938b58b1055e18.camel@surriel.com>
Subject: Re: Path forward for Virtualized Swap?
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>,  Kairui Song <kasong@tencent.com>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin	 <roman.gushchin@linux.dev>,
 Yosry Ahmed <yosry@kernel.org>, David Hildenbrand	 <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Kemeng Shi	
 <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, YoungJun Park	
 <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 "Lorenzo Stoakes (Oracle)"	 <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren =?UTF-8?Q?Baghdasaryan=EF=BF=BC?=	
 <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen	
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu	
 <weixugc@google.com>, Gregory Price <gourry@gourry.net>, Wenchao Hao	
 <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins	
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo	
 <tj@kernel.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Shuah
 Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, Meta
 kernel team	 <kernel-team@meta.com>, Linux Memory Management List
 <linux-mm@kvack.org>,  Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, "open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Joshua Hahn	 <joshua.hahnjy@gmail.com>
Date: Sun, 27 Sep 2026 14:12:13 -0400
In-Reply-To: <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com>
References: <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
	 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
	 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
	 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
	 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
	 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
	 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
	 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
	 <arUcil9kxUPiymXI@KASONG-MC4> <araWKyJ5MENBwXCL@cmpxchg.org>
	 <CACePvbV0Z3OhxkEn-MiMrxpSmtbt1YwCt2N2_ZW3jbdh87jgFA@mail.gmail.com>
	 <9499bc084e30df4d10bc069ed26d576e4dd3de80.camel@surriel.com>
	 <CACePvbWdJSUDuEbR2FXczbeWwvxP86WDGHTL-eO0A8WwMDoNRQ@mail.gmail.com>
	 <b792823cce613ce756227a3b60cc245b0316a800.camel@surriel.com>
	 <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com>
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

On Sun, 2026-09-27 at 06:17 -1000, Chris Li wrote:
> On Sun, Sep 27, 2026 at 2:29=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Sat, 2026-09-26 at 20:23 -1000, Chris Li wrote:
> > >=20
> > > That is the part I am not sure I understand correctly. Fair in
> > > what
> > > sense? Using the swap file proportional to the memory limit of
> > > the
> > > cgroup? Do you have an example of perfectly fair swap file usage
> > > for
> > > a
> > > cgroup with an 8G memory limit versus one with a 1G limit?
> > >=20
> > > Sorry I am a bit slow grasping what exactly the fair behavior is.
> >=20
> > Say we have a 64GB swap file, and several
> > cgroups on the system, applications A & B,
> > and system.slice.
> >=20
> > We might give system.slice a 10GB memory.swap.max,
> > and each application a 25GB memory.swap.max.
> >=20
> > This way a memory leak in application B
> > does not result in application A being
> > unable to run.
>=20
> Thanks for the explanation. To me, this is just standard
> memory.swap.max limit behavior. I was thinking there was some new
> concept of the fairness I haven't grasp..Thanks for the=C2=A0
> clarification
> anyway.
>=20
The only real change we are looking for is
that once zswap no longer automatically takes
up real swap space, the zswap use is no longer
counted under memory.swap.max

Only the data written out from zswap to
physical swap would count toward memory.swap.max.

That way both of the fixed size resources are
counted according to their own limits:
- memory.swap.max limits physical swap use
- memory.max limits anon + file + slab + zswap

--=20
All Rights Reversed.
