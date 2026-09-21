Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AC33AC0C7
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 09:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983853; cv=none; b=TJzBfpzEnU2Eew+5DR9S47cUU5u1xZ328xnnlvMMGG3a2pqeBKhtM3YF1PF9dLpkJydtfzEWF400rLEcB6Ze/igMFIZAChUpUcY+wgYFAQvn0SFi5rlIDBzMj8RcYgV8GuRFy6YEFBDRgKRkS+dRhNfipafCgWvUsi6GodRkmLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983853; c=relaxed/simple;
	bh=e8UbLM76z0pEEVd3kFwvexh1litq+aFnA/e+aZEDGOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lKa6tL1GLptT+yDRPwwP3ymjDrxAD2AMwG1YtFhY3+52fkF94b7wng1p0Qo0c5V9jp6wr5XezvUofTY3xjJQjZBT53/tvdVG4UTi1tZphpNtkmoaCN14cFjPAsderGWmi5CM+r2fBuW3nL8uVCr1EfHnRsLv4QtXb1J/d6GaRA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l0WzrlNe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l0WzrlNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECDE1F0089D
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 09:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789983851;
	bh=iT8if2mD/aPImn8Sm68Z/gW49Co1dlEv8RYUDg0WoK4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=l0WzrlNeFwS35n4gD5mWRMLGPAYWMSYHLNUgBqszppDslumljtwnzJCATFfAxhlTv
	 3vP8gEA4yIAFU4MKa9qwitfabtnstPyXxfTTCTZcxlqaXxwij/lrm+rq4W9nxqB7B1
	 5QOSXr7J6whdBgyS8PgRyKnVveY41m8wF4eO4f4D+sWe3UbmLEnlEORhFqt1TbAvMQ
	 b0vsWPUQbVdydRtevpYz45puCriu7BKH6N5iMC5nZt6iC26FE9VSmadsIl6kfTY1Pl
	 5KTu037fLirhUYa9/ZvahySuWL/y9Bv1j+UgbkQwJcSHS/0ASPeUDTzGeJZHzdYtgf
	 icnBxmjjxFXKQ==
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-6729c4030f0so1169434d50.2
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 02:44:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxJzmmOUv4+KzkXskoQz5AFxzrurt7yXpW3P3TbmWf0ZuTdB6TKa+CBDLdmE4JXI2K697juIW5u@vger.kernel.org
X-Gm-Message-State: AFuF++nzyrDg5oAqCtlF6ukreT8ICnEP2BTUHHIMWLm1Bjf2mjSJfhV7
	M3x5Uh6/9akD21CpWBhNb6VSrjzo7nTBAVTfDnczc17JGN+sDezG2Db0EyFABg0dNAEOODbeUSU
	XXFLaE2tc7X04clzOVJpYh9mGxO4IOTLh3sR+BJXnTg==
X-Received: by 2002:a05:690e:1206:b0:672:aad4:3ff5 with SMTP id
 956f58d0204a3-672aad4408amr1095386d50.62.1789983850636; Mon, 21 Sep 2026
 02:44:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
In-Reply-To: <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 23:43:59 -1000
X-Gmail-Original-Message-ID: <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
X-Gm-Features: AcwNN1UvMXXPXLi0GhVBjP_wTYqT1-_o3r1PAGjjggfPSSuKF_y4-p-b05lQBwE
Message-ID: <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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

On Sat, Sep 19, 2026 at 3:53=E2=80=AFPM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Sat, Sep 19, 2026 at 09:02:28AM -1000, Chris Li wrote:
> > On Sat, Sep 19, 2026 at 6:08=E2=80=AFAM Gregory Price <gourry@gourry.ne=
t> wrote:
> > >
> > >                         Memory Post-Compression
> > >  |[CD][CD][CD][CD][CD][CD][CD][CD]-------- free space ------------|
> > >    ^----------------------------^
> > >          Compression Space
> >
> > Thanks for the explanation. So the compression space is just the
> > actual data store backing the zswap/xswap/zram.
>
> No.  That is not what I said.
>
> I said
>
>    It's the *amount* of memory consumed by compressed data,
>          including the metadata associated with it.
>
> I do not know how to be clearer than this. It is an amount of memory.

Sure the amount, that is what I have in mind as well. That is why I
said swap counter.
>
> It is not the memory itself or an abstraction to describe how much
> memory, it is literally the active amount of consumption - a number.

Yes, compress zswap counter.
>
> > Maybe we need a separate counter to track actual memory usage,
> > regardless of compression status.
>
> the separate counter is... the existing memory and zswap counters.

Exactly. So, did that solve your problem? If not, why not?

>
> > I want to add support for your usage case as well. Please clearly
> > specify what user usage you want, what the expected outcome
> > is, and why you want that.
> >
>
> I want:

I am sorry, that is not actual user usage. You need to start from an
actual usage case: I have a workload X, only want to give limit Y for
the cgroup jobs but with Z SLO requirement. That kind of actual usage
requirement.

You are basically saying you want a pony. I also want an antimatter
pony. Let's battle with our ponies.

>
>   1) zswap on machines with no swapfile
>
>   2) without being asked "how big?" - there is no number I can give
>      that stays correct, and

Because you can't answer a question, we have to bend over backwards
for you? That does not make sense. There are a lot of questions I
can't answer either; that does not make my pony request more legit.
Apparently, you can't even answer what max(%) of RAM you swap out to
zswap in your fleet. One way to get that answer is to find out what
that % number in the fleet across different years, then you can pick
up the trend and leave a safe margin. FYI, in our case, that number
has been stable for our deployment over many years.

>   3) the bound should be the memory limit that already exists,
>      not a number guessed at boot that hotplug invalidates or
>      guessed at swapon time that different workloads invalidate.

I am sorry, that feels like a rule you invented.

Let's start with the real question: on your fleet what is the max % of
zswap memory compared to total RAM?

I am not designing the swap system for hypothetical situations. I
design it for actual usage. Hypothetical solutions suffice for
hypothetical usage. No patches needed.

As you can tell, I am less interested in the hypothetical solutions
discussion. It is not the best use of my time.

>
> This requires decoupling swap *file* accounting from zswap accounting.

What are your thoughts on current deployment usage depending on the
zswap charge to the swap counters? Changing that will be a
user-visible behavior change and could break other existing
deployments.

Chris
