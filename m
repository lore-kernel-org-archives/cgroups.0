Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BD74F393D
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 12:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792412657; cv=pass; b=fvdCAfILKr/ZIT7olQAAE8PJ4rZjKlqph5K7nJXX+aD7IWd4X9kLCHUW4ClyWUfCxoomK5lAXT0HVRZvyi0H3k3PCrQ7Szkab5rY3HnwUjU2Brw34adOpDgxEs/dqRX/zWSwgKRSwlSrynJ7VccJ3htdaIAMZta4pT618baob24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792412657; c=relaxed/simple;
	bh=zIl3797HKzBaRekdH/RX1kheOlY2s6cxDUnXXsRaPAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IMrnV9V7VmHE7hLwIVUe87wUPqEjE8J5as+qIRM9AObjKUdggULklgAsrkV5Yv/2xY/9HLLce/xhh9Y5BAEGwezo9rCGdz86w2BmTm2MYUMbdK5dzjqtpDRO0/ppcbcfnBiIekPlEoI4nYvrN+ziarnzvDuYCUvKoodZ+n2o9Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cBUhGN+b; arc=pass smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cBUhGN+b"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48afbd2c386so991309f8f.3
        for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 05:24:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792412652; cv=none;
        d=google.com; s=arc-20260327;
        b=F4OcSdNkNfzsikd528HxJ8DgN9nPIe+o3uBLvq0cQkMtFIqhOEQ/ff/9Kutw1HKiQH
         XK6cORPXvdZDTt1iCqtxIj1gqAIRZTju3oFAGwvHX5njqounhw3TUBIPvWpdGV52KdJ2
         A7d/UAq03U3YN7cJ0lkC7Bu8+A7QlUPxNb9PAipYt3x7nP8clxxD+bnl3Iuo5SID8ZG7
         Yur1ezKJUZgka/LfzDJVDa3tfUwLfUNcwZ5ShZBmJHmbU7xm8OQYU+Wqn0TVBdjtJt8o
         cZxjKFtHQGX9BGIbvJNpYplp4T5XnYWoYag4LIdSKCqJ9imSR0f/cw/+k+ofUDCZBRe3
         1YKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zIl3797HKzBaRekdH/RX1kheOlY2s6cxDUnXXsRaPAI=;
        fh=uoRlURVQxQUd0au+L5KjXZBB/u5bo8cTguKaatAeXpo=;
        b=lVnhiyqqObenSrDpj7A3y0aYLR7ykfE6boE47k/asu9FNhVZ0drT2DDWfjjT0ZN61M
         IsF0b/4ssgSpPg78HE5pGRQkrtJ6DLfMQlmGl5Zp0fxqUtxz4egrJk8exketKJJXP2TG
         aq10LrrDMI92RBPSyQEoF0ssT061YJ3dKkc5UvrksaLgR6MUhUSV3FWTjAgTbIs0jdQx
         4cuoNzsiA0uZuYN7jN+ry/0IhnC8Z5ibD7RwsfQMIw7/ys2d3NeEuWaByuufoPizzeZJ
         2VkDPrhOck5BgTU124D/hdU8el4Gq2KUuy+5jjILNWO2xJSU86lsJqcqzl+Q8IHUsT7M
         Ub4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792412652; x=1793017452; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zIl3797HKzBaRekdH/RX1kheOlY2s6cxDUnXXsRaPAI=;
        b=cBUhGN+bc6z4JOwb7GD65Mmty/kREQqoFp2h2ZssoAZ1K+cLzitmjC0S+VszKct80p
         Ts8Q8YVt8uIa44putvYIauY70Q9ldU9C70Zax7r+mcfj2rn8OjomUqTUW3ybzpq1Z1mi
         hDX9HVmL1gXta3qnuImS7OheEaOUBKNZAQaGNdPmrsz0pVTt5mPxlXSse8zrPT0XBwm4
         cveqrWZ/wnGL0KjaZFDUeer8oxH4G8VZPb0AtN1DKLUACTKC8DflIm2u2G6SaBol9+Rm
         Boz1mww+EwtDAXJEjL23vlCWmbhqe2OndJzRCgqxBLSOX4SqkcYCOrqBIE31TpzUfy4U
         agHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792412652; x=1793017452;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zIl3797HKzBaRekdH/RX1kheOlY2s6cxDUnXXsRaPAI=;
        b=nbtJu3bwwxPufeZo94q/aL3Tw94s/Cr+vTLpOsdkCNf/HNDZY4IQV4jiXOhL5BJX7Q
         2d0esW7PRw7NKfAUyeTiLN0qXDNZPnt8QsLTUoq0osFdZ72A0BCDghFNjD3WVlVKLVWI
         DHJ2AJo+eJo9KmkQgTIxlp3h0zh9Q6bKfREp+PrK6rQpdQUh2LOGE4YTJDdq1OQfQc6r
         Re9wZJ1yet8MIju0zOYPjzDpYixo3ZRdpQRNu8MDTwJkll5oydqMfLCjHtM0Cvr9RSx6
         kaaKvDWujQ8UIuG2vKm7np5xyG2cx71IP2eMHUvcbxOoBpBUu9icwwTtBo5fZ7OeV+Gs
         MYRg==
X-Forwarded-Encrypted: i=1; AKwUvBxb4FGjLkCobQZraPk8/+Nh+yJiVzbBo161BW5kxm0T999UQUYThysEvRLvSXvIvzkgm13hf4bx@vger.kernel.org
X-Gm-Message-State: AFq9FYKjOf7tDa3E+dvdBAEFJPf1HUyeE9Iswt5s/L/EVGNXosBEKo8W
	dfXorFk+gkIpJCc9hoZDDY2tsCIEkrTf25+jokQRrUQLAsBY5ifotiIYwApGLBYOiabsEXDfWLQ
	loOTdqI1dxU5qiS4Yn7SDxrpwzdOjOSM=
X-Gm-Gg: AYBFou2SMYr5/A0faMU2qb3welWRuleDrceSVcS1ZDmg7XCyC4VxAItUqOPkPjN22/9
	7bPvxhFRgdegLcIdCBNvbsKmXmIHxxKmdtK+dL4HYE6x7sQodGGlpLxUOcWJgLzRVx/Ek0nt7lU
	ha6MRPG9RDSW06jz/QHAI/M3d+txrSKoo31BpbzF8h1+vGKxLAGqHIhTyLBQe/iWwtG8+DxsLU5
	s+fC+HFMtl0Vlv+nXkMpKP/bwfH1MhmxI7VukfkIRNQzmhswptPyX5et4y6Frrr7iML3KgguBlz
	YociSVou9I5mmRg1jczlKBq3G7ros4Gqt9g7MOZiSXcgURZuAXWYmL9X384Gu0+HIuOakgitzVG
	VHUdPgdGNe9eWG63M9i1/+dWTNN3gT/yBiPr8w1lTKiUZk11LINoXxZum34yivpAejwixGnA=
X-Received: by 2002:a5d:584b:0:b0:48d:f831:2688 with SMTP id
 ffacd0b85a97d-48e079767e7mr16787506f8f.3.1792412651411; Mon, 19 Oct 2026
 05:24:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
In-Reply-To: <20261014195354.GA371161@cmpxchg.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 19 Oct 2026 05:24:00 -0700
X-Gm-Features: AclHuK9g4IT-C2lPq_2bwXW7AKF8KuPzBZKFA4kZoiUqrTyhjKQMGSX85iLRdLw
Message-ID: <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Chris Li <chrisl@kernel.org>, 
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

On Wed, Oct 14, 2026 at 12:53=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.or=
g> wrote:
>
> On Mon, Oct 05, 2026 at 01:06:28PM +0200, David Hildenbrand (Arm) wrote:
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
> Either slot works for me. 8pm/9pm on US Eastern.
>
> Apologize as well for the late response. Travel week followed by
> post-travel sick week...

I hope you're feeling better, Johannes!

Folks, I just realized we never really clarified the exact date, and
since we are in different timezones it can be ambiguous. How about
this:

PDT: Wed Oct 21, 5:00 PM
EDT: Wed Oct 21, 8:00 PM
Europe: Thu Oct 22, 2:00 AM
China: Thu Oct 22, 2:00 AM

Please let me know if folks are busy, sick etc. I'm flexible myself,
unless my flu shot fails me again :)

(Also starting from November, Vancouver, where I live, will have their
own timezone. We'd have to add another row to this).
