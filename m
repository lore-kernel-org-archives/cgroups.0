Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792781325;
	b=05f/GKVFf/oc//QWVU53BWLENVCtbTMLk9gFJTx5YZHIPQPbplYiqiqoov8iu173rWBk
	 aZkLLAL3emVek2jhe2ljZFYfr/LfQEVETIGcYwAF5mOmieW0Y7YaCv5iGSpAao2NEfW2E
	 vJj6OLySW1ubJ6m8KJj57nwPZn7F0kPI9mCw0+5OVyuKjjKb4eklAySM+0DPs9Y10o9Ta
	 6PgbUio5V079L3rbK5+B/Cu8M+K4ZAV5OCX35mMr/KeFTTFvJ+pePT/mGQoHiq8aQODzU
	 0hA89nzHf00Zwkm92CFY6HYq/WDtNXQ7ulrHFKgJ5VULA5+oKQ3sSJ9eOCp/xFvpgBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792781325;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=E2FdSZgW1ETVNdAfDb/5mKk/9Ymglr13dfhYqNbiU0s=;
	b=Vc2YdSneIs4QLBw9TTmFemLAU3X6OQ0kaiOpffo57b/0Td9bTcrfVY9YQRFXjhn6yZbJ
	 vlZ/9tntfKG90skx+TMbqRJ/H9cEVzETemjNRvZIKW58SErPxMnm8XITRXF+Mpsik2+mQ
	 t2gzyYksxnIg01fHmBFA3Ysj9IDSybSrdqLSwtJaLCXodYNpX5Cfw8DQAbpt2wrbyzmVZ
	 pMIkmkmGzV8j4L68ZYgP61wbspZkgsLLKyH6VzR5tWljb3WDz0DyVVv+O0ENod41TQlI+
	 6UkHr4rtaUDUS2RYYxCsJtIWLUMz39PJucioZ4YefoOyH37F8DJHuubz1Oewdbj6Fgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mJ62D+sH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D761E606A31A
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mJ62D+sH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595191F031E5
	for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792781319;
	bh=E2FdSZgW1ETVNdAfDb/5mKk/9Ymglr13dfhYqNbiU0s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mJ62D+sH0WW6xEP+v8vbFt48woN5lul0pgNr07iTBBAgUoh+wbpKB7TwGb/SrOhfV
	 cSnm0pCHFZSN/YYlqTy+159i5VENlSenT7ywmZnkFbWsyzLJ8iHuaGrM6Pn9g+2DdS
	 zmrTKvHzqsBa9w3adygfvKcksiAt+4R2TayGY6JWxGLY/46eweV8QUlESTKL4T1JV3
	 L74m1a677qqTjvHEH7vAGWlr46ZZibA5Q3kUuEHgG24N+I6wgBRsLC7yzXLMPkPVag
	 msxfoztMcaxY1gOPzps6rdMdmd+VY2X1a40sMNLRenovvHxd8i/KRhw4Op3jwIa5XI
	 6kHceWodhIQoA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c263415982eso158851366b.0
        for <cgroups@vger.kernel.org>; Fri, 23 Oct 2026 11:48:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzoRTBIKU+zvz21PdqcATrpSTgEDEFk4Ms0lINf42E1VFtK8KoQ3IZkq6mTTw6EVbS0NCYu19hL@vger.kernel.org
X-Gm-Message-State: AFq9FYILBt/o5vL14qWAjz04YqziwDAm8LDXqdqZzKJDdzAyw3xUfv4E
	0/3Y77IPOMwFjl9UhYNpzyI+1plWA8poIbfgdpEJg8FLZfC93vq8lGN7geCsVJ1P36u49XVxtXf
	69w8VI/N7hVYqie3ewy13NkT6YhmimlU=
X-Received: by 2002:a17:906:c10c:b0:c40:38b5:d784 with SMTP id
 a640c23a62f3a-c46a91fa71emr509539566b.22.1792781318187; Fri, 23 Oct 2026
 11:48:38 -0700 (PDT)
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
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
In-Reply-To: <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 23 Oct 2026 11:48:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOWW8+ARqvjtYYZbBCH26s0YhwrqHTaoXeW9DcFR=3BXw@mail.gmail.com>
X-Gm-Features: AclHuK8Vn1TWyOOSO3vLHubmDo3arJfqe6mLfCmYzhDd5kWYgbQ2Cbog3YjV-tU
Message-ID: <CAO9r8zOWW8+ARqvjtYYZbBCH26s0YhwrqHTaoXeW9DcFR=3BXw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
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

On Fri, Oct 23, 2026 at 10:24=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 10/19/26 14:24, Nhat Pham wrote:
> > >
> > > I'm traveling this week, so it's a bit tricky. I cannot make Thursday=
 morning.
> > >
> > > On Thursday I'll be traveling back from Cambridge. But hang on.
> > >
> > > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.3=
0am - 2am.
> > >
> > > I could just naturally join that day.
> > >
> > > So one day later would work for me.
> >
> > Would that be too rushed for you? :)
> >
> > For everyone's convenience, this would be the time slot:
> >
> > PDT: Thu Oct 22, 5:00 PM
> > EDT: Thu Oct 22, 8:00 PM
> > Europe: Fri Oct 23, 2:00 AM
> > China: Fri Oct 23, 8:00 AM
>
> Hi folks,
>
> Thanks everyone for attending - I didn=E2=80=99t realize swap was so well=
 loved :)
>
> I took the liberty to summarize the points being discussed - please let
> me know if I missed anything or misunderstood any points:
>
> * Swapfile sizing: Kernel kept swap slots after read faults to save IOs
> if these pages are swapped out again, and thus needed swap occupancy
> (and hence static size) for a heuristics to trigger reclaim of these
> swap-cache-only swap slots. However, this is not useful for fast
> compressed backend, and zswap invalidates its compressed copy on page
> fault anyway. Vswap does not need this heuristics because it just
> frees up the swap slots eagerly on page fault for in-memory backends,
> and rely on the existing slot reclaimer for physical swap backends.
>
> * Logical footprint limits and charging: cgroupv1 allows logical memory
> footprint limits (unique page tables). Cgroupv2 controls physical
> memory and swap resources separately instead. While virtual swap
> entries continue to count towards memsw, cgroupv2 counts only the
> actual resources they consumed - post-compression size in
> memory.current, and nothing in memory.swap.current. While cgroupv1
> continues to be supported in its current state, a cgroupv2 transition
> will present a problem for memsw users that still needs to be worked
> out in some form of overcommit control.
>
> * Swapoff: this was brought up as a request, but we ran out of time
> before we could discuss the motivations and use cases behind them.
> Folks interested, could you explain as a follow-up?

Adding @Wei Xu for this.

>
> * VM_SPARSE v.s xarray: no performance difference between vswap v.s
> part 1 of the xswap=E2=80=99s patch series. With all 3 parts, there is a =
win
> for xswap, according to Baoquan=E2=80=99s testing.
>
> Let us keep the communication line open and coordinate on the next
> steps.
