Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A43443C3F
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790149082; cv=none; b=QnX5ngBAs/mlQHm3INFfUhNQ+r79B8FL/BcCwTtGNzQIIDSaiRsMF+61lGji+Db/EBrdgl31n8rtZq7xHMuhkJ/UVxmjiAM/DhLXC9n8Ki6IjlXQJQ7eT/R66YuFuRgOMnw9kP26XctMSpxOXFfXpNJPnEEX6EVfjE0875vBZns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790149082; c=relaxed/simple;
	bh=t+JD/7Tcgy/5lybTqPMDYJ6GPVVkUaRj+hbtOcdXe80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p3pe2DMTtSUYOBduHshBQ2hi1RqsrgMSmXDJBV4ChFrYiQiNjFsYzLpWqT0EjDWYKKY1jVfLqoxeOEYQ6ZIGv69KCWvQAMlaXzHYhrY9RXwZHCvSJTSI99pPNfuuNC5YkC8MrrMDqVg3y/lRDgrPOWkj7vMiLyt8XLY+OMsMWt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQoQ2QbP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQoQ2QbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DAA1F008BE
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790149081;
	bh=t+JD/7Tcgy/5lybTqPMDYJ6GPVVkUaRj+hbtOcdXe80=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WQoQ2QbPoqGGLb0jX9Z7J1mDTu8MsvOh/Ibh7LcqJkke//dYJpmH6tdDcgX/eFknC
	 T00oeG+czRPKBl97PDh4H8ZHcAtFbyS9yImIzOh5KLiBVQy3uapLFhxwpP5ixQGDda
	 QsqckjOhvusczlD2A6sFr+EPdkSRFVikbaw3XmcPa+JOvsrpcsUIStYIlZcsqioa77
	 V1SEXPDfsnUq1jRfkYV1GaMrc0Ncqh540aCMK+l3SP7Oi4eQWrTqXq03rnUDD02r8G
	 3VnbxAw22uDzFQ+enwXaCU3ShJJ2D8ZUu54gCQeOFQSoaCqzIVhRgzGeVx0zI0eLwh
	 f0GnC82BIPHaA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab222dfso535669d50.0
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 00:38:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxtf92cycy+sSGi7hFv0zGtoLlRwVlhF0VTW4RBe2ddlWxykY3WHOQTjvaMwAkuzYaDHfxuCcQA@vger.kernel.org
X-Gm-Message-State: AFuF++n59B2sc/15ZP19HXxsPkHTlj54BMaEmT7hvehlnX4rBntdNJ/e
	E+Ah+Fc2MpUNMdjtIuwgBPggQ7kClxIJy/mAo+YR1gnTfhfyREjq/tvzWXEzXu+GhzqjbCtvdmU
	dLuuiCBByxhR9LL7IakmjYWY6Q0cyL5nmOnigJh9knA==
X-Received: by 2002:a53:ee08:0:b0:672:bbc4:2b97 with SMTP id
 956f58d0204a3-672d57e7a7emr628072d50.11.1790149080540; Wed, 23 Sep 2026
 00:38:00 -0700 (PDT)
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
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com> <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com>
In-Reply-To: <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:37:48 -1000
X-Gmail-Original-Message-ID: <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
X-Gm-Features: AcwNN1V1Nf19r8H9CLvnn_CymxrAvElR4yk3NvHm23MKZiCoXBt2sr9xUuj-IWI
Message-ID: <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
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

On Tue, Sep 22, 2026 at 7:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Sep 22, 2026 at 8:23=E2=80=AFAM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Tue, Sep 22, 2026 at 4:59=E2=80=AFAM Rik van Riel <riel@surriel.com>=
 wrote:
> >
> > Yes, I can agree on what you observed. You are using anon + zswap on
> > that app alone. That is not what I originally asked.
> >
> > My original request was for the whole system: what percentage of the
> > total system RAM size has been swapped out to zswap.
> >
> > Because when you have 100% of zswap out, it will likely trigger
> > different kernel code path on allocating memory. You might suffer
> > global memory pressure you did not observe in the single app memory
> > pressure case.
>
> What does this 100% figure refer to? Pre- or post- compression size? I
> legitimately cannot tell.

The 100% I mentioned above refers to the pre-compression size. See my
previous email in this thread for details. I have been asking for a
max(%) number in your fleet for more than six emails now. My point is
that 100% is not a usable metric. I suspect your deployment doesn't
have machine zswap even close to that amount. Glad to be proven wrong
with some real data points.

>
> "Trigger different kernel code path on allocating memory" what do you
> mean by this? This reads like you're referring to post-compression
> size, where one cgroup eats up the RAM of the host, affecting other
> tenants in that host. But putting a limit on the virtual device
> capacity limits the PRE-compression footprint. It is a very
> unpredictable way to prevent the effect you're referring to above,
> because compression ratio is unpredictable ahead of time.

I mean triggering the direct reclaim path because zswap itself can't
allocate memory for the swap cache to serve the page fault.

Chris

> For post-compression size, I can make arguments on why we should not
> also gate it, but regardless we already have zswap.max and the global
> zswap pool limit.
