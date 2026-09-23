Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3AF3803DB
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 06:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790145902; cv=none; b=CDWZgKQtnK7CO+lIGiuar9DzTROnQ8n+a/ZG9hxZY6tTjOgegztU3IrAtlxmBzbNzqAOxgZhIr8X7/65WbD98kygRKNxOMInbgzD/DvTygfkv6aS8UbYFqLpObq/WX1eBzipZp8+ihJS8ajqbQPErHktTG9ovU81FZBexiQZkbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790145902; c=relaxed/simple;
	bh=U3Fe3GZkBaknJJQrEX2RpwW4P0WOBIbz21H+JhSeOuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nw6gYD4b8R91bimX7aiiRAF0DL+1NJOfogAPiaFZ+kxz6nFPcBmmUP08nBhvI2aWuIf9PpoVGMG/l2EtcgXkz26oSOSw0WWv9XKeIXQBvPzzREDb3rjjn6OFefsGgbzm7r/rXJoumKKV8WXoKpf6P/9z2ELUc/W1VxPHHsWXB6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KH+6SRSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KH+6SRSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BFA1F0089D
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 06:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790145895;
	bh=U3Fe3GZkBaknJJQrEX2RpwW4P0WOBIbz21H+JhSeOuc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KH+6SRSNEvqMduDQyrAk1/m5V6SS0ddO7ePNHzpfLJs8HzeRvVSi0MYcTbY4ASQYX
	 wpbI2WceWE2GFNraMR5MG8cOZPwg3dsaUpf2jzzvfRnW8RbzTJliBFcwM7aakKm/pa
	 rDVBbrblG0sQAVQ1/QB1x7vYTpcyBqdPmO2tkufLwdnZkekzWJLQArwe3c8Z+LIlaR
	 J3Au44TJJMbFiRsw9v00qM2/UtbkbXUriIjohRWxBxd24lKUprGOM5ozhLJh+z41WA
	 auoSIMkEGV/BhM69FLPP/47DiQMJi5PEEqK+oNovw6q/Scd9wIfxSEegEY2whp0+wM
	 8/5+3fw+fxJuw==
Received: by mail-yx2-f36.google.com with SMTP id 956f58d0204a3-66e4aaf2ecfso476499d50.1
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 23:44:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxljUcLBBv7jWSa5W6MkkoAZLfqLMjKH0IsszFL4amkUBzpZnkDHzZ6Uj4226PZVJ4gn9z7g44w@vger.kernel.org
X-Gm-Message-State: AFuF++mRk0sf/PU5O3TmjsjrnzYBVhj/MNez8y12otLLrWyjQGqSXX1F
	KAkd6pqhr4dcA4sK45P+HN4d+Sq6uGFSQNewS9jjS5R75oBCwcnEMvJ5x8/vCrCLUctAbwCPOcr
	FfcTxJab37krBFF6ex4TGpqXbvsJzLsD2uD+PmOAx1w==
X-Received: by 2002:a05:690e:1909:b0:672:c9eb:4755 with SMTP id
 956f58d0204a3-672d5765c2bmr1091423d50.23.1790145894673; Tue, 22 Sep 2026
 23:44:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <arKRdaNEaKvFOtMg@linux.dev> <CACePvbX7aM45SE9H0hg1_uXBt1i4W7Pgk+d33Z2sG5bj8cHudA@mail.gmail.com>
 <arKZpJDpsavixjPx@cmpxchg.org> <CACePvbUmVLVk=w1sJinBfKVYoXcO57A163RrXv7C_QLzM4yQZQ@mail.gmail.com>
 <arKgladcnmeTWUKb@linux.dev>
In-Reply-To: <arKgladcnmeTWUKb@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 22 Sep 2026 20:44:40 -1000
X-Gmail-Original-Message-ID: <CACePvbUYhwSjOEXCM08Na_5bccOo6Oz-9BatRSPDO7R310YjaA@mail.gmail.com>
X-Gm-Features: AcwNN1U76kw9ArcfhXgJlon_Ze0jFZEqulu20gcTSrQsz-WCh9osS09uot1Y_ic
Message-ID: <CACePvbUYhwSjOEXCM08Na_5bccOo6Oz-9BatRSPDO7R310YjaA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
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

On Tue, Sep 22, 2026 at 5:46=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Sep 22, 2026 at 05:30:44AM -1000, Chris Li wrote:
> > On Tue, Sep 22, 2026 at 5:07=E2=80=AFAM Johannes Weiner <hannes@cmpxchg=
.org> wrote:
> > >
> > > On Tue, Sep 22, 2026 at 04:56:48AM -1000, Chris Li wrote:
> > > > On Tue, Sep 22, 2026 at 4:43=E2=80=AFAM Shakeel Butt <shakeel.butt@=
linux.dev> wrote:
> > > > >
> > > > > People can speak for themselves and suggest other time slots. You=
 do not speak
> > > > > for anyone but yourself here. At this point this is derailing the=
 conversation.
> > > > >
> > > >
> > > > I am expressing my opinion, freedom of speech. As you can see in th=
e
> > > > previous discussion, Baoquan wasn't able to join that time slot. He=
 is
> > > > a major shareholder in XSwap. I worry that alignment vswap vs xswap
> > > > without Baoquan is ineffective. That is my opinion.
> > >
> > > Actually, he said he is not sure if he can make it, and before Nhat
> > > could respond to that soft push you drew a hard line without actually
> > > proposing a workable alternative that made Nhat give up instead.
> >
> > Please consider that it is 1AM in Beijing if I remember correctly. I
> > don't consider that is a workable and reasonable ask.
> >
> > > So my free speech opinion is the same as Shakeel's: you're speaking
> > > for others and thereby derailing efforts to align on something.
> >
> > I sympathize with asking Baoquan to join a meeting at midnight.
> >
> > >
> > > We all want Baoquan in the room.
> >
> > In Chinese we have this saying: don't apply things to others that you
> > wouldn't want applied to yourself. Do you want to participate in a
> > technical meeting at 1 AM?
>
> Three emails in, you have rejected the proposed slot and proposed
> none, and your own conclusion was to drop the meeting and keep this on
> the list. That is not inclusiveness, it is a veto, and the outcome

You skip an important step. I raised the concern that the time zone
does not work for Asian developers; we should find a time zone
friendly to Asia.

Nhat still suggested the original time slot, disregarding my concern.
Which implicitly exclude Baoquan from the discussion. That is the fact
that you missed.

Then I suggested using email discussion instead, because the key
shareholder couldn't attend. There is no veto. I suggested the same
approach Nhat suggested. If you call my suggestion a veto, Nhat veto
first. Nhat issued the first veto. Mine was only a response to Nhat's
insistence.

> serves Baoquan and xswap worse than any hour of the day would have.

Baoquan can't make it at 1AM. It is not a reasonable ask.

> Baoquan said he was not sure he could make it. He is perfectly capable
> of declining himself, or of sending alternative timeslots to the list.

In Baoquan's own words:
"About the meeting time. I am in UTC+8. If the meeting is before 23:00
my time, I can join. If it is later than that, it is too late for me,
and I can only discuss in the mailing list."

He already made it very clear he will not be able to join that time
slot. It is not a maybe. It is a 'can't'. His reply was very clear
before you sent yours. I don't know what part of "not sure" you read
from his email. What is your motivation for twisting this?

Suggesting a 1 AM meeting without considering the time zone difference
is an understandable mistake. Insisting on that time, as Nhat and you
do, reveals more about you. Attacking me for point it out?

> You turned his "not sure" into a hard no on his behalf, then argued
> with everyone who pointed that out.

It is a hard no. 1AM is not a reasonable ask in the first place. Even
after I pointed out it is not Asia friendly, Nhat is still insisting
on it. That was before I suggested we discuss it via email instead.
Get your facts straight.

Chris

> Please reply with two or three specific windows in UTC that work for
> people not in US timezone. If they overlap with the other participants,
> we use one of them.
