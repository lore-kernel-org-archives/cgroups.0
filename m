Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792781360;
	b=CfGN6AOP5tJCvs27ns6Xhf/kcD1mLGpQh2Fbdr80cfQJ8uvnpeGR6R52WmwHwdCRl0YD
	 Lc81bV4+JzyD0FhzDBkBgonCtED8K6P+PFYqnkXjYV8Vs/VJc5QItd4t6A23J/9Fmx+OM
	 qtsKC/vTHtcrJjQHuftxLXR2SL1hLBAsL6XzCB/b/nIgcSlGIxW4G63UYKV4COCocmb5T
	 sV9N+rgFypqgR7V3QdJqTO/2+9LkP2vS+nAHLh/CbsB8h7vPAkyLDpbXHLk8YRWObz2Gj
	 2FNdwCmgE20UVwxGyu2sO2Yvy/H4hyUuyDQA5bguRNOoGRTuGw6hUHn6M4T3rZaesKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792781360;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=I30wMbvFV4BnwqUrI39cfUABnvDkclC4d7g0soYkp48=;
	b=ESFo5ZWACSXczzimkHTbP6sf2TZGVDiCvlUDubuze/fZ1iXgfa7Hf0vS5Fqd2BuOtutK
	 3UK23bE6fj6qOWnU/gzcOtejBsLhxFioqUG2ahcu8ryhlbQwalKdzW3uM7E8UTH/l1O3N
	 hy7vAOD/5NuMnDy4W8qY6hb8f26LyqwKNy1EvFib3GuGAFv55hJJVgyv8fwqTe7tA429V
	 AjKmVivlBKcv7TZE8aQWKB4hBXHMhMN+isv7U21tO7wipAtmNOFHzBS6fmMDtc8PZauJH
	 BXHKemeVhOX6Q1eTAVBA3a9b4N10V6b6+GTk6hJHe13euBZ37BIbZOt/uCKx+6xgBaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZcKwms+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907B2606A31E
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 18:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZcKwms+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B00A1F031F8
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792781360;
	bh=I30wMbvFV4BnwqUrI39cfUABnvDkclC4d7g0soYkp48=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OZcKwms+f/ND/QYDagLCmBuCHt11fMNVVSy+QPwavTLKDsj/w672fgN/z8y+zXmSS
	 mKvDGtqr3lDtIo145w+h2r5eVWfuw8dR1S8Vws6C3B/3iNV/gT/RDUDcmMemsXcPpQ
	 90C0DIpc2En91RKva79xGhNHtY/XrpHApnkpr42NyCU4WZH5nR1OYjIdpDCZGUv0tt
	 Y7pTD1177XiIe3qM4tP+mJT6XmRSISIOGLXBjH1iGH/5FfqIeqodhk6sS4WWqoINgy
	 oqL0y1A/VP13l98arpQR2gVk9t0aiqjttesLuItsg71jXcEQp5jmb4o7PlYSXpUCmL
	 Jva2fSJgorRnA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c423b145922so163266466b.3
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 11:49:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwUAZ9/f7Sw/QnoiuvGOYguxZC50HcTS4wq07kZMaDRHQdsn9kI2e5aG0iLa2anN42OVQZlR2g7@vger.kernel.org
X-Gm-Message-State: AFq9FYLLw6R/L/XbzmcVEfQEUQeS06qxs3FkTTTYYLmCyN93XSBTjJg1
	TIiLfZFzlrR4UhKpTX5Ydevbj77AxabRmU3YKOyYR881F8YVBLfV4MB+3Ba1rELQaG5v5cn1vFu
	7qaL1S1aUPz/hOcM9LpPZbA8I6UP1mgk=
X-Received: by 2002:a17:907:724a:b0:c3e:d18c:1d7d with SMTP id
 a640c23a62f3a-c46a921eae0mr450266766b.22.1792781359196; Fri, 23 Oct 2026
 11:49:19 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com> <CAO9r8zOWW8+ARqvjtYYZbBCH26s0YhwrqHTaoXeW9DcFR=3BXw@mail.gmail.com>
In-Reply-To: <CAO9r8zOWW8+ARqvjtYYZbBCH26s0YhwrqHTaoXeW9DcFR=3BXw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 23 Oct 2026 11:49:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNWAC8VEfKs3VB74_WTHeN113Hi1Nvb+BxOVpc+BhptxQ@mail.gmail.com>
X-Gm-Features: AclHuK8FGyKBCpsF-5BHtbxXzqsTxw_wUf5CNlBQO39pbIL8N2kuJNTEx0AhATg
Message-ID: <CAO9r8zNWAC8VEfKs3VB74_WTHeN113Hi1Nvb+BxOVpc+BhptxQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>, Wei Xu <weixugc@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 11:48=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Fri, Oct 23, 2026 at 10:24=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> >
> > On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > > >
> > > > On 10/19/26 14:24, Nhat Pham wrote:
> > > >
> > > > I'm traveling this week, so it's a bit tricky. I cannot make Thursd=
ay morning.
> > > >
> > > > On Thursday I'll be traveling back from Cambridge. But hang on.
> > > >
> > > > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1=
.30am - 2am.
> > > >
> > > > I could just naturally join that day.
> > > >
> > > > So one day later would work for me.
> > >
> > > Would that be too rushed for you? :)
> > >
> > > For everyone's convenience, this would be the time slot:
> > >
> > > PDT: Thu Oct 22, 5:00 PM
> > > EDT: Thu Oct 22, 8:00 PM
> > > Europe: Fri Oct 23, 2:00 AM
> > > China: Fri Oct 23, 8:00 AM
> >
> > Hi folks,
> >
> > Thanks everyone for attending - I didn=E2=80=99t realize swap was so we=
ll loved :)
> >
> > I took the liberty to summarize the points being discussed - please let
> > me know if I missed anything or misunderstood any points:
> >
> > * Swapfile sizing: Kernel kept swap slots after read faults to save IOs
> > if these pages are swapped out again, and thus needed swap occupancy
> > (and hence static size) for a heuristics to trigger reclaim of these
> > swap-cache-only swap slots. However, this is not useful for fast
> > compressed backend, and zswap invalidates its compressed copy on page
> > fault anyway. Vswap does not need this heuristics because it just
> > frees up the swap slots eagerly on page fault for in-memory backends,
> > and rely on the existing slot reclaimer for physical swap backends.
> >
> > * Logical footprint limits and charging: cgroupv1 allows logical memory
> > footprint limits (unique page tables). Cgroupv2 controls physical
> > memory and swap resources separately instead. While virtual swap
> > entries continue to count towards memsw, cgroupv2 counts only the
> > actual resources they consumed - post-compression size in
> > memory.current, and nothing in memory.swap.current. While cgroupv1
> > continues to be supported in its current state, a cgroupv2 transition
> > will present a problem for memsw users that still needs to be worked
> > out in some form of overcommit control.
> >
> > * Swapoff: this was brought up as a request, but we ran out of time
> > before we could discuss the motivations and use cases behind them.
> > Folks interested, could you explain as a follow-up?
>
> Adding @Wei Xu for this.

Actually adding Wei this time :)
