Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72931327BFB
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 17:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783962190; cv=none; b=VyzmreFEV97ng9E2BGoWhU9bokpiwpituMUJg50JVTSFBGit2rgb6eMZpz88qYYfMosDB11CVNyDd6ezChrs03AtPICWEU6+g+oKaJnQyUBHWhgUXp6maTNKVTRuGoHU3WnJ3tyQnwe5WVwsBybz5g1K/RfVEvEYeIzF9E7WiJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783962190; c=relaxed/simple;
	bh=b1Fet5nEZQV4MMt5es7fTqGCTp56uk9Hiy8cY68X9Rw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dIPYw7VQF+HqDOirYyL8I6VIBBjHQlzeEwFj+IfPdnn9CtFsbb5OTy9W/to7rLvgoO7IETfQVxIeHOwJu5FaCyg5QNS4Cb/WinjKcV2HFg7eTrq/iiXf85wOawg8ry8g+fNbz0/bEhd1HIgD/1OVhzU+XBcx6hHW0pHKJ9iONJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AYCp8QaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AYCp8QaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F571F0155D
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783962189;
	bh=b1Fet5nEZQV4MMt5es7fTqGCTp56uk9Hiy8cY68X9Rw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AYCp8QaHGQp4HpDW9tcdGQ/O2AXHYUzGChVx26and5GjAlRRHJZcg7TKm912W7Hwg
	 XNEOhE7YKIq39WGfj2kauuHEKY/8b4XAPz/otPi6rhDCYYzp43BvMArpN1gZUdvhyK
	 xxaktNKL04Do4l4dFitcSfmnHigokjgJ9PO7o1A4piIBMJxUDQ8CDOXcLnbMblBeDS
	 yColU5Sk31bHrN5ewUCpyq43OyEjB9ZP24GONX/q2KXGwO6tqW8LUoSKWUyDnJLm/c
	 zhlRFbm4E2DLmJa39omopyFjhvOEGwQG9qo+zpQr993guhbZiVZifl7e/9P8cuje/u
	 Vu/Ppdyg9ryWw==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-667f1390f58so1224108d50.1
        for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 10:03:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpthL5LOSCa9i17pdOSt+NFhcEgyX6Y/9hglEVOo9wpaST32VoQyZAvUwHzNgmG0OKL0FELMi0+@vger.kernel.org
X-Gm-Message-State: AOJu0YxE5eoPAh2iJAEkELyJmQZNjGiRnPBkkEnk54rEgaPnt2oICpY5
	jcQSn0ppS1k0JmV79czLlLtV/LVe9fSkPeKdaI/2hVJWStaxubFGQ+b4QqxhS3uuYFuetV43lFv
	wzD1frNZN/OcKbWutRxfhJwDJjQgm4H3YHPA5NqZTPg==
X-Received: by 2002:a05:690e:d48:b0:660:db62:a47e with SMTP id
 956f58d0204a3-667d7c541f7mr6018869d50.65.1783962188491; Mon, 13 Jul 2026
 10:03:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
In-Reply-To: <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 13 Jul 2026 10:02:56 -0700
X-Gmail-Original-Message-ID: <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
X-Gm-Features: AVVi8Ccfpc_dSAJTfLvWvMA3EJHfo11-b7EEEJwmjvmTr2Ua17H4FE4meVFn4TE
Message-ID: <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 9:01=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
> > My plan is to land the swap tier infrastructure together with the
> > first use case (cgroup-based swap control) first, and then follow
> > up with zswap tier support in a subsequent series, continuing the
> > discussions we've had above.
> > (I mentioned on cover letter, right above the overview section)
> >
> > Does that approach sound reasonable to you?
>
> How does swap tiering work with zswap in the current series? I assume
> zswap is just enabled for all devices in all tiers? I wonder if

Zswap is not part of the tiers exactly because it sits in front of all
swap devices (tiers) and uses a different control to enable or disable
it.
Let's not combine these two; let zswap use its own existing cgroup
control interface.

> introducing zswap as a tier after the fact changes user-visible
> behavior. I guess if zswap will be introduced with a default "max"
> value it will more-or-less be the same behavior, but I would check all
> user-visible behaviors related to zswap (e.g. interaction with other
> zswap interfaces) to make sure nothing breaks or changes in a
> meaningful way when zswap is introduced as a tier later.

Zswap will not be introduced as a tier. The existing user interface
makes zswap not exactly compatible with the tier ordering because it
sits in front of every swapfile. If we change that, we break the user
interface. I suggest we keep zswap working as it is now.

Chris
