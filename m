Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5C312AAF1
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 00:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789949932; cv=none; b=at7yNSm8qG0aPM44iCDB00swrEfGK3OtCN1Ys3/vFI9sPqbz7ndNhBnj7q91iwZmKcxr8YiBuIR9Jqr4o2GIavuSV18YY0/oorI+9DIIthTAmGsFx7ilye7cgE2s/LXKaWa9Km8aTBYlYubAMjixefPwJma0lcW0IglTpL7RyCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789949932; c=relaxed/simple;
	bh=yQLJwaBM1jNrWhBXChoiLFbCA/v9mJP+hXZ5bDTH3cA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=drmLykardvEKxWjD84Py3G5PBlC+Q2docZ4aLQ/R+uglJPed6zLspBoa+hcTAI44kYGzfLi1GOagoRXKqwQREB1vrxFjMkWhavphwzTpykrS8GBR4oXrFxHy4FM8zXD5FPohHpe61EoRA5rNfmCsGw9MFVN/XvLqKw/w/p38tLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aIEj4iaB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aIEj4iaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504571F008A1
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 00:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789949931;
	bh=yQLJwaBM1jNrWhBXChoiLFbCA/v9mJP+hXZ5bDTH3cA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aIEj4iaBhshktxUJ9NxtHfVL6ULOcPlzBZ+8JZnTwJNm0vxSPb3Tj+kbQCbxteszO
	 QAnXO6g4HbazET/Ga/0jEGHY9wLEdkEp2XLCw3GjOLtXoEGXsxT86NukCsaUn7g99h
	 DWgqIj8LdB52MhSQlPEBJXOU4SgzIBGzg0YppLv5Gzo9RN9HlDiBuLIi4xSPRJv5xz
	 nf9PHnhgqW1fR7L23E/E9OfCSv6kFY/JokoUj7nuOkoe6YVnyLhe6uYdrJm36h6x81
	 WcH9mHLOp6DpEwMeTAWYCV1RzL0rd7TjVt/se2qLf/3gpxRAaNDat6YlTSk7udgvBX
	 haoUyoBJIR/vw==
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66fb93aee5eso2246432d50.1
        for <cgroups@vger.kernel.org>; Sun, 20 Sep 2026 17:18:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwdxW15zHqclEVd2SFepS7zKFTPFpC/cElFH9t0KmaVGinGyQT05UxSeFm4oHvKWbA9QLQ3jEPr@vger.kernel.org
X-Gm-Message-State: AFuF++nDcJ8QumWLGSAeee6pucw0+Rc/u4eLSxU3XbDG2NsIAaxpzCHX
	rhLxL/eDa7o3FwndsGy+xQvML5xeXRt9CwdqrvrWUxKhLUPswy3o1n/ZVm9amTxAJKxZTIFM2PP
	d2sAZps8D6xum+qXcZw0NYrDyt0jEDcqCgvMXN50jNw==
X-Received: by 2002:a05:690e:144e:b0:672:b10e:c5e8 with SMTP id
 956f58d0204a3-672b11e0a0dmr330726d50.28.1789949930653; Sun, 20 Sep 2026
 17:18:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <aqBT_35E-eSoN_zj@cmpxchg.org> <CAKEwX=N4aaq_oD2agTUNrUNXhaYGeQ9vxu+dywFvEFgWFi4uQg@mail.gmail.com>
 <CAMgjq7AfNBUpMamcv29JFzpX=7ApNYVLtPjWT4Sm8cXjSLYL9g@mail.gmail.com>
 <aqU81l1oqGItb-0C@cmpxchg.org> <CACePvbWLHAT5DjC=HidzN10XF5_cnkpxXXDR_yfEJjTY_uDvDQ@mail.gmail.com>
 <e42d8bb0bb13067609e8ff8c858a26ca056368bd.camel@surriel.com>
In-Reply-To: <e42d8bb0bb13067609e8ff8c858a26ca056368bd.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 20 Sep 2026 14:18:37 -1000
X-Gmail-Original-Message-ID: <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com>
X-Gm-Features: AcwNN1V4Qm3_GmZRa8eeaDfHd6BdloTCfV1sTma9X2uAKhaJOLZlQ8rz9IjN_3c
Message-ID: <CACePvbXDDDHo0rwkR3Ln4==teQugYP2=5y87J+A48Lagk1X_zg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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

On Sat, Sep 19, 2026 at 3:07=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> >
> > For our deployment, we only compress about 7-10% of the system memory
> > before performance starts to suffer. The feedback loop will scale it
> > back. I am very curious do you have actual work load to swap out 100%
> > of the RAM.
>
> One common workload is a web browser with idle tabs.
>
> Those often compress pretty well, a ratio of 4:1 is
> not unheard of, which makes it easy to fill up
> 1/3 of memory with 133% of memory's worth of compressed
> memory.

You did not answer my question. You are talking about user-space
processes (browsers). Do you run your browser in the data center, or
is that a laptop workload?

Anyway, what is the total amount of memory swapped out to zswap
(before compression), and what is the ratio to the total memory? I
can't imagine your big server can reach 100% swap out to zswap while
maintaining a reasonable SLO. So educate me.

Chris
