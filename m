Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E703BC680
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 23:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790553055; cv=none; b=WaodccUAImZbd0t71cEOC7xZCQgtfkUQwhRYr+Ko2MscOcMFqSxPfJYp+GgpLMe8lb5JQwIGD2FpvJ5O5/AicfH0PdmTCTliL5UtxGICPx23xRYYjUzmpxNh0h5bKeoEIJ8TVA68hm+bVnp38cID1DkeOrQDnKFDEKJnu7JA5no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790553055; c=relaxed/simple;
	bh=QExukZIjY2AejkBgnmymsglzpWFxW7LnbDXCoL9d84g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=axwl4Ys8NLrSgI6bwH0e0mdXik9l1007W5cLdEOZ0VuFjvnL2n+mPqg+d9oThPjQ2xhrnR+voK4OZsYarJH3QgpYdjKZ0nlcbTH1/z7rrMz54GV65uYJtg3m3fEvlTAbPp6pHwEtdvAccA/C8jghI/9Ik5BERd58HU4NGJYhxyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IGzlXZHz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IGzlXZHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA1C1F008A6
	for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 23:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790553053;
	bh=QExukZIjY2AejkBgnmymsglzpWFxW7LnbDXCoL9d84g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IGzlXZHzPr/8ECiAyHaT53ppe9Pa4uTrD1ifyleS430p+CIoNxFgspLA9FOAsgoDC
	 Y1V2LIBTT8FgrqI2FugbvCuJIkj4gsoUXcAtu8rVO7ZOgbj1sQNUPRR3RnLIuMpYhX
	 S9T/NVpEF/tX8lEFHOZdVDoddxYAgHUtn5lwnQ8QDRBmrzAq9iivyjVkw3DBjmOBfW
	 pFvQyFnYj3ndeu4drCcgFX4gCigXcUi4deAJQJcJ+ithjTcdzZIJ81UfavdwngKQiD
	 Tyss9VhZN9MePsdYqjBBMuGI01wvOBZ9B9NkXWGLVyWIFT8aCuACQIWAfnJJLhl4M2
	 IhhraGasAMuPA==
Received: by mail-ed2-f27.google.com with SMTP id 4fb4d7f45d1cf-6aa135d6e97so3834591a12.2
        for <cgroups@vger.kernel.org>; Sun, 27 Sep 2026 16:50:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzWBylRTlSwsmMvVEv6gqEpTUySgN58/d3sPT5a91JAY8QGjsBlCKFhyhhrKLzz03M+Kpj8Aeal@vger.kernel.org
X-Gm-Message-State: AFq9FYJlDx6j9Z7jgbhm67FR3Pi6CP3szB6Id5GsNBEb37K7XAlyB68l
	k18rYJFAE0GX4ESWVumwQ+Fsu79iklbFsuwBtN8MaH+eHdHHrXEoXt01xCWKhCowODM4dK4pF9K
	zREQForDTjz4+62nUsy/ItvorMrgibJCb/wAmVrimag==
X-Received: by 2002:a05:6402:3226:b0:6aa:e8d9:7d12 with SMTP id
 4fb4d7f45d1cf-6aae8d98044mr6856124a12.6.1790553052488; Sun, 27 Sep 2026
 16:50:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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
 <CACePvbWf8ocrfTpEpQ6==cr1=KTzo4Ar+-Zxt89=sxt02Z8uBg@mail.gmail.com> <1739d52dcdebdc589826990ef2938b58b1055e18.camel@surriel.com>
In-Reply-To: <1739d52dcdebdc589826990ef2938b58b1055e18.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 13:50:41 -1000
X-Gmail-Original-Message-ID: <CACePvbUjr2kW67r0Baz748p-WLk4rPww7V=sS2s87U=R2L7N+w@mail.gmail.com>
X-Gm-Features: AclHuK8wcEl0AbVxEBkinaGVysym0CjC226qO7EjIvxWHxxkRi6EAgi7L-b2h2U
Message-ID: <CACePvbUjr2kW67r0Baz748p-WLk4rPww7V=sS2s87U=R2L7N+w@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 27, 2026 at 8:12=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> The only real change we are looking for is
> that once zswap no longer automatically takes
> up real swap space, the zswap use is no longer
> counted under memory.swap.max
>
> Only the data written out from zswap to
> physical swap would count toward memory.swap.max.

Johannes has a nice write up in this email thread that talks about the
two usage cases:
https://lore.kernel.org/all/araWKyJ5MENBwXCL@cmpxchg.org/

I think what you describe is the usage 2)

I think we need to respect both usage cases. 1) is the established
one, which I'm more familar. Currently, zswap charges to memory.swap.
It is the status quo. Breaking this requires figuring out an
alternative and implementing it in phases.

I recall some proposal has been raise, give the usage case 2) a
different set of counters and limits. e.g. memory.pswap.max. I also
recall there were voices against it, arguing it was too complicated
etc. I haven't fully understood all the details. It would be better if
we don't have to break usage case 1) at all.

Chris

>
> That way both of the fixed size resources are
> counted according to their own limits:
> - memory.swap.max limits physical swap use
> - memory.max limits anon + file + slab + zswap
>
> --
> All Rights Reversed.
