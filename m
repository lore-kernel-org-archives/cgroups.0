Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792568517;
	b=boupQVxLU1Wqp9CsdAmcXnWV2Tjr7c+ikurhZjMVGV3qeDlrn64QSnHOQUBGv6MJJpig
	 WUNuSLCSJUD0AtWJ1dgTTgYGKA2VSbLeDLG4/OOPfDjrQ3hQMoOZ2uDvuZgFOnS5ykZaR
	 ZtkYHlSc2wiwnly1iGgaMnaUiezXO7tJ/BH0iBz5amg0TVpaP2S8CuQIyB8NJ2UI4sqM2
	 TjY9Vne66/ZELf0PSvAx056sFmyU4qxRa9iWl/wPvgKMzejCKZ/8JVMW6pHlcCwb5LMoy
	 j4946OiFOS5cQ3rCtyK7Lyhqhj7hSI+hvlWmU6riYko7PXbg9pBsiBawqm8p8w7p5cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792568517;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Q2W6HW6t4FD7GiH02r1fl3fKehEEk60q+ai1/oJoOqY=;
	b=cIQHZIrmKnbGZIwxQwWQ5Zw6APCk192o9UXYPgjhz5UZQ1oY10mPr4TkrBXVwp0ZMVp9
	 JQX73tD4JG+n43a4aYmqG5DgjoOhVi+2qzR95bOx3rcokk1xIp1trr75fpkJhHxqUIye3
	 0Nup8aJuBZkYG3fiByuk/f5BDKMqzpo1jbNuUUvDOe7owmJ3Ra20DB0Z+QCuNyunYNna2
	 YHAK44rsCaxzButt45BqxFNuwwH3vLthrSYrcMpjvJwPzHNrDWfH21u+ZluKdFClReDDU
	 H1yQLIrY2ox4mulk7Oxl127JitwnhiPnd4oKcB57La1uvQ09NDrnrUbd6ZwrjcaP1jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Qvd/yrlh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0CA606A31B
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 07:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qvd/yrlh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1BC1F000D1
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 07:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792568517;
	bh=Q2W6HW6t4FD7GiH02r1fl3fKehEEk60q+ai1/oJoOqY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Qvd/yrlh1PLhc1/2gXQqnk86EYYr9xscm0ZRiFB+pYPkP171xwBa5qs8KA0J4GdPF
	 EaysR9xgCRhsZ+CmxlNq/eJC7Mz/tCuBS/VXHQsJP/PHwTBLjH8Chb89QAboeRvmeK
	 64KfykPHw9QlqgQ1aFR7DlrRdjNLZIDBCtW0p5JIFEOaD3VtFljva5ulMn9X+6C6Cl
	 shw3sIEgkmw2c9qyHF8NKywGG5S9P/X11QBGVPWMNGacDVNzrlCIZLb4Bsa9o70akQ
	 ve9545LYU1TrY/LAyu97+QlshXiZFgvUphPwMYO7R/NrK5ysOWprNTvO86AvFUu//3
	 6K7AJBaQu9hNw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c43373ae89aso49403966b.3
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 00:41:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzAaHHk+pPZq3Gj/tdKx4SfCpG6ByEj4s8NNldx5rehW3pUpN88kSJqP5TxrPlgbere6ny6RdKi@vger.kernel.org
X-Gm-Message-State: AFq9FYLILldmYo/+uaWCckqExEInkWqSTanecWE/BMTSsGB4gtYDaHGd
	4+qfasAMlPuFP2qyFqH3bWIVwYwKYoqL/FY00704cQ3PXppXDbaK8Y1mOqO+rDL2NaJ+/s+bXpR
	4PC6tryXVb0wwnc16vokZkVXBc2SLqEEWc6Q4by2Yxw==
X-Received: by 2002:a17:906:dc93:b0:c46:645f:cedc with SMTP id
 a640c23a62f3a-c46799d0f16mr92139766b.46.1792568515652; Wed, 21 Oct 2026
 00:41:55 -0700 (PDT)
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
In-Reply-To: <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 21 Oct 2026 00:41:43 -0700
X-Gmail-Original-Message-ID: <CACePvbVbMPZTrD5y=--XgBS+sa4CHb7e4RFTYCbWfzHzVc3vXA@mail.gmail.com>
X-Gm-Features: AclHuK86lyz-XbdDB6Y-j0ii2s8PEPiP-QfZRMCvGYvdiUTKkHpNlLS-aItO5FE
Message-ID: <CACePvbVbMPZTrD5y=--XgBS+sa4CHb7e4RFTYCbWfzHzVc3vXA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
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

On Mon, Oct 19, 2026 at 5:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Oct 19, 2026 at 5:28=E2=80=AFAM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/19/26 14:24, Nhat Pham wrote:
> >
> > I'm traveling this week, so it's a bit tricky. I cannot make Thursday m=
orning.
> >
> > On Thursday I'll be traveling back from Cambridge. But hang on.
> >
> > My plan lands on Oct 22, 11:10 PM. I should be home around Friday 1.30a=
m - 2am.
> >
> > I could just naturally join that day.
> >
> > So one day later would work for me.
>
> Would that be too rushed for you? :)
>
> For everyone's convenience, this would be the time slot:
>
> PDT: Thu Oct 22, 5:00 PM

Works for me :-)

> EDT: Thu Oct 22, 8:00 PM
> Europe: Fri Oct 23, 2:00 AM

Ouch, David. If you commit to that, I understand it is very
challenging. Thank you for taking one for the team.

> China: Fri Oct 23, 8:00 AM

Other swap developers: Kairui, Baoquan, YoungJun and Barry, when you
have time, please comment on whether you can make the meeting as well.

I want to clarify one thing: Swap is my hobby not my job. My opinion
represents my personal view as a maintainer, not my employer's. I
consider different users of swap to be my customers. I really wish
some of those impacted customers could join the meeting and speak up
for themselves as well.

Chris
