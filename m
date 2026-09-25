Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E7F41754
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 00:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790297051; cv=none; b=Rehlywv9BJUwtKuuqXijYOGNOvvT2i3V8XHdX1cTZAnD0T69ZdW9qTiGgq3wWgg63xDDmiwrabjv2UliHUGqzimjEER64qNPtclkxBfRPEORFZO5tiLA2QlbiA5PBfvlRgLkJoH4RZzFlODfpv4Oxpc5WeAt8wkoHz/lDfV97C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790297051; c=relaxed/simple;
	bh=iTp7mHFpYtjPJ0TFHzNBVGHwA7eK5o58yIHHx9Ka7V0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HKL+Sw2KJdw7HRdErhfoRk5NvnIyjKNT9R3flHbSe3djsSg2t5oZi/WxMBi3YoJdpMoONRUu5qXDThDq8DpBkkqOuvNPHUxXQ4MI2X6lnSdn7F0s4S4aH7V4o991X/Cs3a338VafIjzsYGoVyZdE6qIQ3p4LYCvLz6IHPLi2jRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PCZ5P9IN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PCZ5P9IN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF07F1F00899
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 00:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790297049;
	bh=7CueezjDbKGuBoVz0Yahi05qKiOZJU4eRx078XbgJlA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PCZ5P9INMjfI7FCDypHYmurFwpp30ik6/LHAhsTmOOA/5ysBL+fo5hGigkS5zx/jq
	 NKAgtJNLa3WA/W3bbfAMP30OBYYn0UNvQ6R8i+VN0uebrPRB/VlM1ZNziLfxpbxzrk
	 kIjPDQ3scd3bDdZLNz1gj+baxpf1k8ES9ulX8qpNBfBQCCMjLc9EpL0DFPT0nPtLmL
	 zkQCNRJo7yb0bMLG4/VF5D46O6RaY9xtTQz3j3UXS3sIRayaWllhPz/pX6K/r7RmsB
	 69nXWOQ0qFJc1VZMXJxEino2aBhb5SJXZ45Nrc4i1+8Nv4zEXpW+NPiire7UJSvA8d
	 U2r6OTHpx/Iwg==
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-67375a844dfso446969d50.2
        for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 17:44:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByeZ8TS2YRW9qe8iebb2F6icyG5Hw37cMFONQ67N1MTMtzbLPNBRGh1GQ2yh4O8sOj6qP9RXC2w@vger.kernel.org
X-Gm-Message-State: AFuF++l/VFfhNOZpv1KMFCED/XD+Mt/0fPfAlAhQMvdggZv/NKBNBkFy
	4lwoIXLDXZi6OuYFwlinvTzhamtE5dDsqgLLS6z/By36XhUsNQNYycmxNzK4XqmOfpgZoi45Q6V
	Y5Jp47GKL4YBHJo80TuULZi9D7j2R0f8R7UsDTMQlKQ==
X-Received: by 2002:a05:690e:14c3:b0:672:f5f5:49e5 with SMTP id
 956f58d0204a3-672f5f549fdmr2112852d50.58.1790297049175; Thu, 24 Sep 2026
 17:44:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com> <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
In-Reply-To: <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 14:43:57 -1000
X-Gmail-Original-Message-ID: <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
X-Gm-Features: AclHuK8hG4dvBqcdqpHs3htOH0tZw8UjHorplhBJiHcYxmcYx2dg2FX15nlFTP4
Message-ID: <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 24, 2026 at 6:20=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Sep 23, 2026 at 2:18=E2=80=AFAM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> >
> > There are too many swap_is_vswap() in this series. It fragments the
> > code path, making things harder to reason about. Esepcially around
> > locks. I count 22 in this patch alone.
> >
> > I consider this the biggest drawback of this series. This
> > fragmentation of the code path.
>
> This will mirror my response at [1], but I'm responding here for the
> record and for your convenience.

Thank you. Really appriciate that.

> It is needed because vswap *is* a special device, with its own
> requirements. If you don't special case-it, you'd get undesirable
> behaviors.

Ack, that is why I am against making it a special device. That is the
whole idea behind xswap. It is just normal swap device implemented via
swap_ops just like ext4 is a file system implemnet on top of VFS.

> Let's take Baoquan's patch series as an example.  It treats the xswap
> device as just another swap device, without any special consideration
> for it. Which creates several problem:

That is a careful design choice. Keep in mind that design choice
usually has pros and cons.

I will follow your feedback here.

> 1. At allocation time, cgroups that disable zswap might get an xswap
> slot, because you don't do any check that the device you allocating
> the swap slots for is xswap. At swap_writeout() time, it is *stuck* -
> we already do the unmapping step, so we cannot reclaim the page.
>
> Ironically a physical swapfile backend could have bailed us out here,
> but it's not in that patch series yet :)

I am not sure I follow. Are you referring to the uncompressible pages
that xswap would have to reject?

One way to address that is for xswap to just bite the bullet and store
the uncompressible pages within xswap. That way it will stay out of
the reclaim LRU. Zswap also stores some uncompressible pages. The last
time I checked, it was unfortunately not able to serve my case but
perfect for yours.

> Vswap both has swapfile backend, AND allows you to bypass it if the
> cgroup disables zswap. Both involves a bit of swap_is_vswap() check,
> but I think it's worth it :)

If xswap needs the lower tier it can allocate for one. I don't think
xswap should need to have swap_is_xswap() there. Also xswap does not
have all the baggage of zswap.writeback enable interface.


>
> 2. Per-CPU allocation caching: since all devices share the same cache,
> xswap will invalidate the caching of other devices, and vice versa. It
> would be fine if the these devices are interchangeable, but as noted
> above, it's not, especially without physical swapfile as the backend
> option. So you're forced to taken the slow path more often.

This will be addressed by the swap tiers series if it is not delayed.
This should be addressed in the core swap layer not vswap. Kairui also
has some ideas to improve that. Yes, it is a problem area, but it is
not specific to xswap. We are well aware of it and have plans to
improve it.

>
> Vswap gets around this by adding its own per-cpu allocation caching,
>
> So by being too lazy and not carefully distinguish the swap devices,
> not only does xswap not work for the writeback use case, it cannot
> even work in deployments where some workloads (cgroup) select zswap,
> whereas others select disk swap. It can only work if you intend to
> have a single class of device - either virtual/xswap or disk swap -
> but not both.

Baoquan's writeback series is out. It is by no means perfect. But it
is much closer to what I have in mind. That is a much better base to
work on.
>
> Maybe instead of just grepping for swap_is_vswap() and throw your hand
> at the complexity, read the code and try to understand why it's
> necessary first, then propose simplifications if you have good ideas
> in minds.

Yes, I already read your code I decide that most of the
swap_is_vswap() should not be needed if taking a proper swap_ops
approach. I wanted to offer you the chance to work closely with me to
achieve that, but you did not follow that suggestion.

Quote from my old email:
https://lore.kernel.org/all/CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81BYL=
grzA@mail.gmail.com/

"I am happy to spend some time working with you to discuss the generic
adopted version of vswap, if you are open to it. Or if you don't want
to waste time on it. I can have someone else or myself come up with
the generic adopted version of vswap for you to review, which I prefer
less."

Anyway, Baoquan's xswap writeback patch series is out. I suggest
following and improving that series instead.

> > This is questionable. A vswap device does not go through swap on.
> >
> > This changes the behavior where swap devices always go through swap on/=
off.
> >
> > I wish the swap device went through swap on to be able to start swappin=
g.
> >

>
> What usecase would necessitate the need for swapon/swapoff interface?
> Other than just trying to shoehorn it to an existing interface?

I like universal interfaces. Your vswap will break the /etc/fstab. The
current suggestion for xswap using sysfs will break that as well.
I would like to keep the /etc/fstab interface working, including
support for UUIDs for swap devices, etc.
I am very concerned that vswap will start kicking in without me
explicitly enabling it. That changes the previous user-visible
behavior. It breaks my mental model. Please take this feedback
seriously.

It is a different design philosophy to adopt a swap device to
implement VFS-like file systems for swap, making them swap file
systems.
Just like all file systems have a superblock so you can probe what
file system it is. You don't get a special sysfs interface for each
different file system to create them.
This aligns neatly with swap ops and makes room for future
flash-friendly swap file systems for example.

> I've expressed why I dislike the interface in [1]. Other than the
> sizing aspect, which we are already discussing in another thread,
> priority also makes zero sense. You are literally exposing an
> interface with only one correct answer - what's the point?
>
> Justify your interface choice with real userspace use case, not just by
> conforming to the status quo.

That is why I feel your patch series are really unclean. I dislike
special cases, I try to avoid them as much as possible.

Chris

>
> [1]: https://lore.kernel.org/all/CAKEwX=3DPEEkYiNRaVhCuM4E6mxB9huPKfkDa4m=
62VMTzedg1oYw@mail.gmail.com/
