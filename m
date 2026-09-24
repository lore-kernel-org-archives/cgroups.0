Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1B3476CF5
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 11:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249275; cv=none; b=brxDrFxxGrFCGqmfHzpqHVTrkYVcsi9qK1cVYMW0vy4wo6EKQCVE2W9A4lIYsMmiy9ijyYb7CmkPhtQzAMKuwrWyhY5yR217EO1DPx0sgKQ+ysaLa2+xa7kvcRPaCbNGFda3a3+GOF3Uw9q1PApsRHjwH82C/1zsvwqnGcyckYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249275; c=relaxed/simple;
	bh=Lq8RP+ZiPKQYeDKKN+eGZA0tMf6NU2q7olqQBx5raOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ipcnlkV4knm5jpbHU2kSlre4R3ZbciNHcchesSsyz+Am82kQiNmK8EhKdp5XmANYdzDXdYTnjtdWT7YIwqm/ZPxSyRCHyOAKLqjQmYWIyvZySghC4t/5cWhJgTDxBavI3XXeIZNJ8SSo0m6kMARM/3cDkpAp7UFsEI+96gh0bV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cKphEnv7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cKphEnv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C579F1F008A1
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 11:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790249273;
	bh=Lq8RP+ZiPKQYeDKKN+eGZA0tMf6NU2q7olqQBx5raOs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cKphEnv7gLnjtnE9ZZoSpyqOTowuPK6l8IJ7TaHRqq0UpXO6CSrpeXAnEJIbFYocy
	 5xqgVNB8AOaGwIXTqNqr9nv91gWdTk1rTg1yswAzFxINOrkprrO/JC06glkNDTpz7d
	 Ary/a8VLiBXZT/cMF3JbBEhSpH8iOfKKEvHjRi+gZuIt3JBAX+smfzgb+astXCUzva
	 2VaX1nZkoLc1Dz+LANQZCmT9wo2wDe7yE4IrqOTWy10jpf9ZExTZSRli3sZ41fAk1K
	 xZ2A701TKcDhvAsSTx0NIgSfBGq0yPa++CReLfV+TvORg6SCm2Z2DHaDtf0Vw/YIP8
	 oCTQjENl0fZVg==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66fb93aee5eso1953955d50.1
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 04:27:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzXQoSXeMdwCkFETrGU2BZHHiCSXCkgyHoNRrVXkkPWTte8vpLr7KHvF961J0f/+pisEbs0XdA5@vger.kernel.org
X-Gm-Message-State: AFuF++mATHAoHisFIPWeoxidMKdYpTVdE8u7T4bw7pomvrpLddenJtb6
	aWe/l1dMXmnCuwSCSkjRakkWEXOr03k38Ctua5/T8qbSgEqNtfTFMxarl2hlXuwMqpVUennm2pk
	/jx/VR26yGwWZAgsRhb0TpEWd0kcG1Smk3LxhPShoUA==
X-Received: by 2002:a05:690e:bc9:b0:66f:c1be:315c with SMTP id
 956f58d0204a3-672ed3b658cmr873163d50.51.1790249272919; Thu, 24 Sep 2026
 04:27:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora>
 <aqjpYHbZ14A8xRtK@fedora> <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com> <arP8vXdJAL6ZJ1Os@linux.dev>
In-Reply-To: <arP8vXdJAL6ZJ1Os@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 01:27:41 -1000
X-Gmail-Original-Message-ID: <CACePvbV8zprLuiWMdYAOLRy=TwRx9WjSahCWySf53o0d_myJ8A@mail.gmail.com>
X-Gm-Features: AclHuK9Zwq15Jwnk2fvcbfDpfS5y4r-YUwb8vz6DhJu53fLXl4OUnGVnT2WT3Ug
Message-ID: <CACePvbV8zprLuiWMdYAOLRy=TwRx9WjSahCWySf53o0d_myJ8A@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
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
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 6:30=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>

> > BTW, I already shared that changing swap counter charging will break
> > our and others' existing deployments.
>
> What do you mean here by "break our deployment"? We are talking about
> memory.swap usage and limits here. Google is still on v1 and using memsw
> usage and limit and I don't see how vswap is breaking memsw?

Your information is no longer accurate. I got this from our internal
AI: "While Google's internal production fleet has historically relied
on cgroup v1, there is an active migration to cgroup v2 to align with
the upstream Linux community. Meanwhile, in Google Cloud (especially
Google Kubernetes Engine - GKE), cgroup v2 is already widely deployed
and is the default for newer node pools."

About the V1 to V2 migration, it uses the memory.current and
memory.swap.* counter to simulate the memsw counter for providing the
metrics singal.

> Are you making these false claims just to derail the conversation?

You should apologize for your accusation.

Chris
