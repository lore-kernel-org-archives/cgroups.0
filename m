Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CDD3D5657
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790007357; cv=none; b=U9GH1J0/f/qbW/w9yjOyhWIMgXRb99+XzyGZPNas9HYkW9sWcJZC/RyrlU5DLyC0BD53j9lya8IxcJAJhPlob3VldCKXVxogrtIS9oHlBwQBOimDMy58Sd0yYzw6DKZm64GCreomgIHQ4q9g+6UHnkAak3bhPLBNy3/AhQqnpmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790007357; c=relaxed/simple;
	bh=RnjPwsEVrL0EEWBJRE+0kD8MJrEzZaGBETohThm6qHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NUunqOaDiRNrYkAmjmRLeaRuIqUr+q8Xol/JZlE1VEoU8baKthjfBzXNB5DwD9kwOLBT+LJrm8kihVgRYeliMId5ZJ52r90w3ZmsPDVtW0ELqbwEO59Q7OyHOPEnOJ1DkgJTpI1o0JtAW56fV2RQOHyXkSjrP3O5mzwxftM4hVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dufKpdJ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dufKpdJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA85F1F0089C
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 16:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790007355;
	bh=25PUFMzN+ZwMXSXb/vhne9pPnPAWuE3XEt3wmLQ38d8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dufKpdJ/rQ4gKIXM/G3xCw5pwf4pfFQnAtEJliObPYwFM/9DjNoosgdCSY9gorEA5
	 vcItnrzgE7+MDpjixc0o3V0VONjTsm1duPbSyUiSMmwcvRQ2sOKHkYFkxC4JNkzg9r
	 Os5+enVYwDusZ1qWs+FinAKKM/oGHJr6bb5rx7e81JYBzS6pso8PEf7yQIKuSWOgpp
	 ID4JwCnlnp1wTsy6aIwqexqglsixOS6t/weUAdiKKQaqHtYT2JfDNpfQUK1SLM/ufl
	 1pG4Anz1GHBB/Q1SDidJRen5R1lMYQNjp668uwriJBYafUfoj1Q6L/t6DgHt4GJcmb
	 3hr+kWdpgcWvw==
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcbe20aso37507586d6.2
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 09:15:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBycZ/9tT+ectH7Tt2Wrm1n7Uaw/7t3Dah22eqBJW2ehk3FtJBnA8UsYqs3PxIx79TMVTND6n8NN@vger.kernel.org
X-Gm-Message-State: AFuF++lSxT4ixxLw2NDhqwt9a3lPXMmR23aobQO8gp045c9TJoHkWV5S
	dHoyPAkYqa/F0YBKjF4v2nv1qYVVRKbNziPr70g6sYGWy75eG5Z8PwvM90/hD5Xx9gpNv+45ucc
	KqLAGehWp4HR20PWHA6kWeHCIHjHxwgHupYkUt2K+5A==
X-Received: by 2002:a05:6214:5703:b0:912:590b:a49f with SMTP id
 6a1803df08f44-913fc8991c5mr12910046d6.5.1790007354933; Mon, 21 Sep 2026
 09:15:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <8aaf1f8101c9e45514af442aaf1969e3aafec4d0.camel@surriel.com>
In-Reply-To: <8aaf1f8101c9e45514af442aaf1969e3aafec4d0.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 06:15:42 -1000
X-Gmail-Original-Message-ID: <CACePvbU0OabajPHyxnzBK_bApdg-dLt7PLwg6T_MgTK2Nk-aZQ@mail.gmail.com>
X-Gm-Features: AcwNN1X6zO48QTCAvGgUYKcds-r_VPR1bmrKxceiJWPap4v_TAW9E70LnkZ53qg
Message-ID: <CACePvbU0OabajPHyxnzBK_bApdg-dLt7PLwg6T_MgTK2Nk-aZQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 4:07=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sun, 2026-09-20 at 23:43 -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 3:53=E2=80=AFPM Gregory Price <gourry@gourry.ne=
t>
> > wrote:
> >
> > >
> > > I want:
> >
> > >
> > >   1) zswap on machines with no swapfile
> > >
> > >   2) without being asked "how big?" - there is no number I can give
> > >      that stays correct, and
> >
> > Because you can't answer a question, we have to bend over backwards
> > for you? That does not make sense.
>
> There are millions of users for who the system
> should just work, without having to first answer
> your questions.
>
> Their use case is legitimate.

That is why I want you to provide an example where people zswap 200%
of the RAM and still get reasonale SLO.

I question how you back up your claim that this is true?


Chris
