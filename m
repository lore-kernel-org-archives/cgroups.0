Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B38559C82
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790091064; cv=none; b=Y0wWhejVJ1Vp+xvexsY7mc2W3IlAKkpKZDZs8m/8XKgbjB68DvBZiDhfHpkyqGbUElB1GtMRUd1tMQmyk228eybYvtgAi5QdWq+lRaPq5b3wXNovCHaelQ0a/h8SS5QU8TOwqNfOm9oJ3kb9/m4Y0Hy+J+6IBF+2J5Pri4jyx1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790091064; c=relaxed/simple;
	bh=WjK1rso8gurasV2KREJhuQVyxlazrxmPZ7mJelduaeY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IeKhxEyu+ydAb2KXekmD52x2vc9zHfIiSjQaAKjGchkZdOeVQ2MdSVgk2pDy1Dl6qhsa0besuwsOdbnBsfzDNwVor+iVMLauvzbqGGpXvU8aASLCQbOD21h4ftPwMsL1e9vq40PHT+3CWX5mybxou3kyzLqy7VaYz1Gybz7FW4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cxoYO/hf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cxoYO/hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74341F008A5
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091062;
	bh=WjK1rso8gurasV2KREJhuQVyxlazrxmPZ7mJelduaeY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cxoYO/hfDuXSHTQ5Dxnl6SmOSX9U+dJ8slNR5avEpnawT5V6HZgPy75HhzBKpPA3y
	 sEnpDu9LA3p1Y5Fo70ao5AblIJ3yeM0YOpwYLJfabK2kx3pyyE3yWKywSroUWJAxKO
	 pcv+htWoFQfi3RRwddJtUZzvx0Z5hBps2kELz5DJxflcrmDkffWZbe0SkJGAY8Z3Vv
	 RUvt0WHXx2juTBnv70nRp375ScuCb8+zFLghqhZkQ09fYjfG5I9pIbrVKFwXH3hjxJ
	 zs0YIGJt3oA7eaBNknm1vmxsJX6mdqU/LNIbNPfN7jsmvY0vdh9G7RNqIowWJgGEwc
	 QOKGOa9WUsTlQ==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4aa8d881so4563694d50.1
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 08:31:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy6kP6cH/r36sIIR/JusQU4hrelGRovKAFZTw4B+DM5Gis/xk5HPRQjn0ioXCophGJ12kq2r+1d@vger.kernel.org
X-Gm-Message-State: AFuF++nG9A5Fr1RwmRVbBWingE5e5EwLnOZElg7w2gba8xvxFU1LKiTG
	y7R6sPoNR1vV2/dKuRM9I3IcB1Mg9LuUsY5xjv9yMTd9LGnpoLPLl/SBg7UPZXdWvg42ayhzftq
	P0CB3eVIost6LE00jigRIifU/YEFMVcJmx/IInfEeJQ==
X-Received: by 2002:a05:690e:191b:b0:66f:c1bc:4036 with SMTP id
 956f58d0204a3-6717fe635efmr5296462d50.99.1790091061887; Tue, 22 Sep 2026
 08:31:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev> <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
 <arKZpJDpsavixjPx@cmpxchg.org>
In-Reply-To: <arKZpJDpsavixjPx@cmpxchg.org>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 05:30:44 -1000
X-Gmail-Original-Message-ID: <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>
X-Gm-Features: AcwNN1UR9s99Z2X-MSlUitUJloq4Rfa7jHbZFSt53b5lYV5PDEZumwr42GjBDY0
Message-ID: <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <ryncsn@gmail.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
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

On Tue, Sep 22, 2026 at 5:07=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Tue, Sep 22, 2026 at 04:56:48AM -1000, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 4:43=E2=80=AFAM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > People can speak for themselves and suggest other time slots. You do =
not speak
> > > for anyone but yourself here. At this point this is derailing the con=
versation.
> > >
> >
> > I am expressing my opinion, freedom of speech. As you can see in the
> > previous discussion, Baoquan wasn't able to join that time slot. He is
> > a major shareholder in XSwap. I worry that alignment vswap vs xswap
> > without Baoquan is ineffective. That is my opinion.
>
> Actually, he said he is not sure if he can make it, and before Nhat
> could respond to that soft push you drew a hard line without actually
> proposing a workable alternative that made Nhat give up instead.

Please consider that it is 1AM in Beijing if I remember correctly. I
don't consider that is a workable and reasonable ask.

> So my free speech opinion is the same as Shakeel's: you're speaking
> for others and thereby derailing efforts to align on something.

I sympathize with asking Baoquan to join a meeting at midnight.

>
> We all want Baoquan in the room.

In Chinese we have this saying: don't apply things to others that you
wouldn't want applied to yourself. Do you want to participate in a
technical meeting at 1 AM?

Chris
