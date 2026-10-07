Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132C1287247
	for <cgroups@vger.kernel.org>; Wed,  7 Oct 2026 16:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791392102; cv=none; b=gZeeSw3r/OewmI8VDA5GAfU0fRp7hVffZwG/2RPv/9vOOn9KhqZlaeE8xV+EodvNeAmuYh+Y59jcfFe5cdLxgPPKbM+thUEMDspsAe/m0uXbwz/v+lKntAUhoV0mIsljMR3HdFvPYkey9xZPAfTHXqfJuOs1/KssNZOJXTzRNRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791392102; c=relaxed/simple;
	bh=feQbNDosn/G0wuU19MK7YPSXaXPT3Dkc2lbt5afIcIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ePaEJthrpPivhFgyzpoFN83pMJFYjGEcKtrkc+xUSbpgsZ+YdwywiqNLwjDCGVBVApDEofoM/Qnlr5KABD6opqOlUA1IFotx5nKzy8t7kbAdUthdJ1QkUXuQA61AH8b6wquv1kaVTtITQqRKfOh3JPwgzOYkUr+iV0izUU4Roe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RdT7kkLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RdT7kkLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DAA1F0089B
	for <cgroups@vger.kernel.org>; Wed,  7 Oct 2026 16:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791392100;
	bh=feQbNDosn/G0wuU19MK7YPSXaXPT3Dkc2lbt5afIcIw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RdT7kkLTKLh46STd7Tze+uwzyqDjA1CazbqmouoRjpFiy9XQofCGJ7jiyRaDwVzYC
	 Q1RNwhx8aUQTQ/E3E0zQS4XSpILTt9/6wy51cFWBee8kGtBQg3RfAQeTIF+5gF1Zgp
	 ckZLmM3ihCgK99joCouCGo2v48oFBSVitdnr3hg8g+qrEzt8r7qtV+jw8bsJfrgDLW
	 b9XKiC86+V4dJOYd8Vw4wG/P+qsp567H1oN0rSJ1jWRbhkm1JPTvo7qooAMkoXpy6e
	 iGhMyaPykmP+Xg7RnXiBHXthhHHR9Z71q7YN0iqenRkpEpxvZ/ZjtBdM42vqWVE3Vp
	 z/Mf4DenhMa5g==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2e7496f947so320311866b.1
        for <cgroups@vger.kernel.org>; Wed, 07 Oct 2026 09:55:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz4wQ3C9PdYntBCJa7IaH87OOjvGuYYG2g3aHxp551NW4hpd7NT7q6I61X+fazt33yziIs1N4gS@vger.kernel.org
X-Gm-Message-State: AFq9FYLVqdbfqlVmVKXE75fvRtr0jFGUzYWJAZf5l0A4qs81sL5naQbS
	6nXZafsaiXbpfoyR0ISSYKI5Um+7Mr5tUrxi5xiKJ6ZF5x65R6tXmn8l8ea9gMTNqtppKtpBkMP
	0ZE8UVT9YTXETocfnijV3iItNnNOPQA8=
X-Received: by 2002:a17:907:c604:10b0:c31:82aa:dd60 with SMTP id
 a640c23a62f3a-c3182aae430mr164122266b.15.1791392099666; Wed, 07 Oct 2026
 09:54:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org> <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <CAKEwX=N28g4T8mqniB-e+e57ie9D3Koaeq-EmV-TEk-u41FBPA@mail.gmail.com>
In-Reply-To: <CAKEwX=N28g4T8mqniB-e+e57ie9D3Koaeq-EmV-TEk-u41FBPA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 7 Oct 2026 09:54:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMCp2wsePz0DLs0B3X=urXmE2tD9P8mm3r8omgRhAL9Ag@mail.gmail.com>
X-Gm-Features: AclHuK98dP9awLd-NBKuJA3ihGk1PaIzKHPWkhcUxdhHKgbZN_qVBJw0GCQiETI
Message-ID: <CAO9r8zMCp2wsePz0DLs0B3X=urXmE2tD9P8mm3r8omgRhAL9Ag@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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

On Wed, Oct 7, 2026 at 9:47=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Mon, Oct 5, 2026 at 2:19=E2=80=AFPM David Hildenbrand (Arm) <david@ker=
nel.org> wrote:
> >
> > On 9/22/26 15:38, Chris Li wrote:
> > > On Mon, Sep 21, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com>=
 wrote:
> > >>
> > >> On Fri, Sep 18, 2026 at 11:50=E2=80=AFPM Chris Li <chrisl@kernel.org=
> wrote:
> > >>> No that time slot is too late for Asia developers. I don't think we
> > >>> should use that time slot for swap alignment.
> > >>>
> > >>> We should find a time slot more friendly to Asia.
> > >>
> > >> Any time slot would have that kind of problem. We're spread out acro=
ss
> > >> the globe.
> > >>
> > >> Let's just use a standardized time slot we have for MM alignment ses=
sions.
> > >
> > > There are more swap maintainers in Asia than in the US + Europe, at
> > > least based on the maintainer file. Please be more inclusive. If the
> > > alignment is done without key stakeholders, it miss the point.
> > >
> > > Sigh, we can't even align on a time slot.
> > >
> > > In that case, let's keep discussing on the mailing list. At least it
> > > is accessible to every one.
> >
> > Looking at the mailing list, that approach doesn't seem to work.
> >
> > Finding a time slot that makes US, Europe and Asia happy is ... tricky.
> >
> > 1 AM is certainly unpleasant.
> >
> > US vs. Asia is also tricky, but doable.
> >
> > China 8AM vs. US West Coast 5PM?
> >
> > China 9AM vs. US West Coast 6PM?
> >
> > (Europe is 2AM vs. 3AM, who besides me from Europe would join?)
>
> Thanks for suggesting the time slots, and for offering to stay up for it =
:)
>
> Either one is good for me. But there are folks in east coast who might
> wanna join (Johannes).
>
> Johannes, do you have a preference? How about the first one?
>
> And would next week work for everyone? Say on Wednesday?

I know I have been quiet, but please count me in. Next week works for
me, most days should be fine, and both time slots (although I
naturally prefer the former, and I believe others in the east coast
might do as well).
