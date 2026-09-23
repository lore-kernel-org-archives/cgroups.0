Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039A3E559B
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790146850; cv=none; b=oEjrlrHGtibVW6uPwDH4uaQQOrN8tEOLYqBCwPAAI+L/VgFmRsDIz5TN0aehwHZxCgD7fZ6c7g/3y12Y2YKAJhyikuEyRrVmZHH7YR39T/mownj0qcjWrcOzL77nXUxIOXjbS816s0fl13/6sBN9/IY6tzlTo6Xx8SVPObqjSNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790146850; c=relaxed/simple;
	bh=tOOWxH0rTYxDZW690RqxdjqKKIjuxjpw0Q6B63WeCCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tIn3j/EOiNAGcdUdPiFKw2x7UggurQAyCZeDzwyw3GlmygcBcwLiR5YJ//jS2C3U6/yKpR1H+C2rc75CoiOicPxIZD8fAe8mL0BRuudVs3y84Tt9KwnYYp++scgU7fziZ9IshM/eWNCVbS3z3808Z2Np0xb/8RtBSa8dzDEN9V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5A2YrDB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5A2YrDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36851F008A4
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 07:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790146848;
	bh=lCQN40gpWl4KlONMsfIv5Q1s2Cplx4oRk8E/qqjTVqg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=k5A2YrDBMABRQn1F4ykIFGTjSDE+U4dHHt0If+F4DZGTPOF8lfHbMM52lW3NknbvB
	 Zeic+KMp3VvPD8DtGdC1hJM4EPRDbvd5Ao4S2Fg81ig5kSTPwkCYZ22qzhWBLURXBz
	 sD/M6EO6TSDer3LntdujrNOLhRh9QCv31qpSRuQ2ospghS/LOZb8FkTYZz5SdKkkwn
	 WwYmZgSJrSoEqhVyUnRaH9IjkRvoKJi8AKcPXy6bTFA8kSDWnG1BZDC468UbMt2x8s
	 66Fy9KW/Ks49YzKzdB5fgYG8KuljFvC4giqW0PkwVW7s6ik8yoB4WpcO3GXSOj0fNn
	 06wr9oUBBOlkA==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab20f4bso662568d50.0
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 00:00:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw/Kize8nQOwT90FgcT790SjcK516mrDYeUI/DVD78+sBe4L5iC0IXIRh/7K8CUv6I18GwMy1Hz@vger.kernel.org
X-Gm-Message-State: AFuF++mfVC6LqTq1iC/s6hm0R2nClvXlEdd2joKZ1R6G3Z2M4qXFsMMc
	UyRJjZG1ewZiX+Bekbym98Vx1XYTIv3mTzb9YCKrp5vdLGEGgcbkW5pVwihTKozptDpB7Un0Lhh
	cy70wWHdKmd46eyfg2QqVD+fx7rkVFz47KnIyUIDZhA==
X-Received: by 2002:a05:690e:1343:b0:66c:c7f5:df48 with SMTP id
 956f58d0204a3-672d5737312mr802920d50.1.1790146848099; Wed, 23 Sep 2026
 00:00:48 -0700 (PDT)
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
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com> <02616d611c9e862afc6c8c3118b6be096756b3bb.camel@surriel.com>
In-Reply-To: <02616d611c9e862afc6c8c3118b6be096756b3bb.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 21:00:36 -1000
X-Gmail-Original-Message-ID: <CACePvbUHoJ7bBn_iKrMyducFzKkHpfe8htZZYW=b8v+EGRF2jQ@mail.gmail.com>
X-Gm-Features: AcwNN1XT6dea5Ukn40MXBsRA9i8L-35_Qe0P1p4ktS2PPdbOhpSXJI25FuwqsFY
Message-ID: <CACePvbUHoJ7bBn_iKrMyducFzKkHpfe8htZZYW=b8v+EGRF2jQ@mail.gmail.com>
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

On Tue, Sep 22, 2026 at 5:49=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2026-09-22 at 05:23 -1000, Chris Li wrote:
> >
> > > > > > > Zswap:           8812236 kB
> > > > > > > Zswapped:       24927876 kB
> >
>
> > My original request was for the whole system: what percentage of the
> > total system RAM size has been swapped out to zswap.
> >
> 24.9 GB out of 64 GB is 28%
>
> That is how much application memory was swapped out to zswap.
>
> 12% is how much system memory is used by zswap.
>
> Those are two very different things, and it really is not
> clear to me which of the two you are talking about at what
> point in time.

Let me clarify: I want the ratio of memory swapped out to zswap
(before compression) compared to the total system memory.
Give me the max of your fleet is fine. I have been asking this number
for your usage case for over 6 different email now.

>
> >  My observation is that, even with zswap, when 100% of
> > system RAM is swapped out, the application suffers greatly. There is
> > a
> > reason why we only have 7-10% system RAM swapped out.
>
> You mean for your specific workload, you do not
> want more than 5-8 GB out of 64GB to be swapped
> out?
>
> That is perfectly acceptable. You should be able
> to configure that.
>
> However, your configuration values are not a good
> default for my setup.
>
> I believe we need to set the default to something
> that accommodates a diverse range of desktop and
> mobile users.

Act. That is why I am asking for the maximum percentage that
represents the upper bound for an actual usage case.

>
> Most of those users do not know what they will need,
> but they will know to close a few browser tabs when
> things get slow.

They don't need to know. Such a bound exists naturally. We just want a
safe margin. You say such a boundary doesn't exist. I say that
boundary exists; that is the main contention.


> The companies running thousands of servers that
> are carefully managed, and which overwhelmingly
> have the same configuration values deployed to
> them are more than capable of setting the dozen
> or so config values their entire fleet might
> need.

I agree; I wouldn't want to configure each machine differently all the
time. In my mind, swapping out that much system RAM to zswap already
results in a very unusable system. If you haven't try that, I suggest
you try it before suggesting a number > 100%. At 100%, it is not a
usable system, so we don't need to make a default for that. Defaulting
to 8PB or 8TB is way too much.

Chris

>
> --
> All Rights Reversed.
