Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43694556B89
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790090627; cv=none; b=edZIlXd5ojYUm2qJ4bdCmD7q737DdKWUTStvIrVT9oayk/l3ZVOXM6YM92SUUdHvGhPPuUjFKIfzLwZoSTEmj2DdI66n1cXeTLOWJbE5Zrn/I/Y90l/tjR0vcbO3+8cMqxPn/SzV8zP5cz0gEa3OCiIka4sVNmVh3cKVOFfrtTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790090627; c=relaxed/simple;
	bh=xoDh0r7//01rAPLh77iu0xIHd3jbw+Zhv4FLE61Vkg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DGHnhz7jNYcDLZe/pk+wYonzGfj8g5HFuJH9RBIpvB5OcSItwDot4zoZL/M5EYUEIQecEvTV4VHVqruX8mgkcQUYPMcn597PrC5xTZBg0c79vXqPf55L8TgV98ZaAc4FF/3V/bUdU+8K6lfpjPg3tp0GjeTUqMaHJXEMlVia0a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0KIDibg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0KIDibg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05161F00921
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790090624;
	bh=HSxYC9PBu6O3qFc8TB9GBt3gfPrtp72o3ge0jqAtRpI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=f0KIDibghpuCfT//z5YJBWxvFz2V4tCU0i0WBKMDTdWD3n5JHLjhSrXi7M+Bd6uwu
	 SBIuxdzV+3PvsWQEaBXEy8KygyslWiTn8kWjWDXqKj+RXo9C2Y1LRLL1Satgc5EbFW
	 db1vY9ShYPHMRn0Vj93U0YTgPQNAUGft8b+7dIiqSQmuzVu6zN1veFE6dDKOaenJ1A
	 6EBYqwuvfhDpg9jM/74fZQO3Igiz3EIBGcOksIoBtD0qgD9zlt75DYlQK5XlWhH52q
	 1+Y4YgLmeDGFvrzmwe9SUnziWvrJnNXc4M7qrT8oqlCbOyG3eTF/R9PeQpQB+R55A0
	 ymDtoW6bFe+/w==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-6713d20d375so3848492d50.0
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 08:23:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxtWfao8lHSAwIZmDtWdvWQrVulbH1+IfSegGi9/0MKrTLOiBRj5+yhTwXo3VWwkoMs9B0gd3Jj@vger.kernel.org
X-Gm-Message-State: AFuF++lDv/WW/BVqmEyYCyZToJxzoT3RNLPiqZJuFLR3NF/LqaCORSV8
	Nh2cqSOwMGP/3ScKkYnW1AO+Jd/lQcWFa5hDGPfVLoaMJM9rGLnEEDxJRv3LbpvZ1AMGQ6DYG+K
	QzmqGTDd5Z9EQttO3ObGBTPe+IB2W8S8VBaFSRJ+ZeA==
X-Received: by 2002:a05:690e:488d:10b0:671:2bb8:ceb0 with SMTP id
 956f58d0204a3-672c54637fdmr881282d50.65.1790090623628; Tue, 22 Sep 2026
 08:23:43 -0700 (PDT)
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
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com> <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
In-Reply-To: <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 05:23:31 -1000
X-Gmail-Original-Message-ID: <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
X-Gm-Features: AcwNN1UFfFWGyxcUua8pbkXO0R-XB3znLXKYfEROGrlAbT6An5bo9JO7s142iI4
Message-ID: <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
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

On Tue, Sep 22, 2026 at 4:59=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2026-09-22 at 03:32 -1000, Chris Li wrote:
> > On Mon, Sep 21, 2026 at 8:53=E2=80=AFAM Rik van Riel <riel@surriel.com>
> > wrote:
> > >
> > > On Mon, 2026-09-21 at 08:10 -1000, Chris Li wrote:
> > > > On Mon, Sep 21, 2026 at 6:40=E2=80=AFAM Rik van Riel <riel@surriel.=
com>
> > > > wrote:
> > > > >
> > > > > On Mon, 2026-09-21 at 06:31 -1000, Chris Li wrote:
> > > > > >
> > > > > > Give me some real-world examples of people hitting this kind
> > > > > > of
> > > > > > limit.
> > > > > > e.g. MAX(%)  > 100% and still have a usesable system. I
> > > > > > suspect
> > > > > > that
> > > > > > with 100% zswap usage, the system becomes unusable. Please
> > > > > > show
> > > > > > me a
> > > > > > real world case that proves me wrong.
> > > > > >
> > > > >
> > > > > Here's my desktop system right now. The amount
> > > > > of Zswapped is more than twice AnonPages, and
> > > > > the system stays perfectly usable.
> > > > >
> > > > > $ grep -E '(Anon|Zswap|GPU|Swap)' /proc/meminfo
> > > > > SwapCached:       252340 kB
> > > > > SwapTotal:      41523604 kB
> > > > > SwapFree:        9802088 kB
> > > > > Zswap:           8812236 kB
> > > > > Zswapped:       24927876 kB
> > > > > AnonPages:      11615760 kB
> > > > > AnonHugePages:   1402880 kB
> > > > > GPUActive:      13112428 kB
> > > > > GPUReclaim:        95980 kB
> > > > >
> > > > > This is also an example where I cannot really
> > > > > predict how much zswap space I need, because
> > > > > that depends on what AI model is loaded,
> > > > > which drives the GPUActive number, as well
> > > > > as the number of browser tabs.
> > > > >
> > > > > The system is perfectly responsive.
> > > >
> > > > Great, that is getting somewhere. We are talking about actual
> > > > usage.
> > > > I
> > > > really appreciate that.
> > > >
> > > > May I ask what the total amount of memory (RAM) in your system
> > > > is?
> > > >
> > > > I am not asking zswap compare to ANA memory. I want to get the %
> > > > of
> > > > the total RAM.
> > > > I assume your desktop has more than 8G of RAM, right?
> > >
> > > Right now it has 64GB of memory.
> >
> > That is exactly my point. You are running 1/8 =3D 12.5% system ram.
> >
>
> > My point is that, I haven't seen a case where the application is
> > still
> > usable with a reasonable SLO when 100% of RAM is zswapped out.
>
> In my numbers above, the applications have 11.6GB
> AnonPages, and 25GB Zswap.
>
> That is about 68% of anon memory stored in zswap. Not 8%.
>
> Out of (anon + zswap), zswap takes up 43%
>
> Can we at least agree on the observed numbers?

Yes, I can agree on what you observed. You are using anon + zswap on
that app alone. That is not what I originally asked.

My original request was for the whole system: what percentage of the
total system RAM size has been swapped out to zswap.

Because when you have 100% of zswap out, it will likely trigger
different kernel code path on allocating memory. You might suffer
global memory pressure you did not observe in the single app memory
pressure case.


> > >
>
> > > hen the amount needed to fit a workload
> > > does not have a positive correlation with
> > > the amount of system memory?
> >
> > It absolutely has a positive correlation with % of the system memory
> > based on my experience. The % of memory swap out has a very positive
> > correlation with the thrashing on the application.
>
> The applications thrash much harder once zswap flows
> over onto disk! Out of all the swap options available,
> zswap is the fastest, lowest latency one.

I agree zswap is the fastest one, no question about it. In our
deployment, we have only used zswap for a very long time. Things might
change now. My observation is that, even with zswap, when 100% of
system RAM is swapped out, the application suffers greatly. There is a
reason why we only have 7-10% system RAM swapped out. There were many
OMG in the past that established this boundary for us. We did not make
up that number; it came from the real data feedback from the fleet.

So again I question the real data point for the 100% RAM swap out
case. Do we even know what the system looks like at that point?

>
> Forcing things out to disk "because too much zswap
> is slow" could just slow things down further.

I did not think zswap was slow. I assumed the swap was only zswap, and
that even 100% usage was too much.

> Now, there is probably some upper bound where
> the zswap pool itself starts to hurt performance
> because it's crowding the applications out of
> memory, but that could be quite large.

In my experiment, 100% is already way above that bound, which is why
I'm curious about your data point. How do you run and test your system
at 100%? Please correct me if I am wrong, but it looks like you
haven't.

Chris
