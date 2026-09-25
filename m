Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90433939B1
	for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 18:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790359485; cv=pass; b=eBlAxxzZKg+pPD8sP1/AKxIeG0Aysz9wZh2QvFDlAVgMSkgLat6V2YT2NUaRmYMIjPStkwULxiEdwSQ2ACTnwCp8x8rovBeoEzIMRhWiA7BoZFZ9A8Oa2MT+z8UqST1BlUUjHf+9xCP6U3KmVPg/5RI5V55hJQagiDFEI2KWUZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790359485; c=relaxed/simple;
	bh=QEH8L5cDVVxNiTq6xVhREUG3v4qVPQmEXXMWF/9zco8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oulKMhzEFciKeeJtJ+Y63Ztpusas6j9cfj37NNLpMbV9vhouybdz9R7FY+X40f71+WNomJd887Rgsqhyghn/AdearkIh8M5plByUzx6S9dyODmUHBP9Kl+AO7ZVvEuys904BALT+lwFNs71cxvgGfhpryxOrXUtzqH20f80rPDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MPkuGcz0; arc=pass smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MPkuGcz0"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f635552aso909804f8f.2
        for <cgroups@vger.kernel.org>; Fri, 25 Sep 2026 11:04:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790359482; cv=none;
        d=google.com; s=arc-20260327;
        b=E6hICALQ1y7Mtj5GVBWKnp+ArxcrXiuVoga/+y8z+PgKqQwGBFaXPCFcnChdHn4qmp
         mI1v4V5WpqdkFfl0ZKnv5hEtIe1cQKPJRiFN4uCr75aXvmxK1iGLfo1PjlpH8jlHvCeT
         a2WqTyMM/B/v2hIDaoLC7FE5eA6SoWdPTxoCB9usqxoRdeQsXMQI1glikRA8nh/SQAwf
         rr1FRoKYyZ9oQrYdkCJb/Z4iGztMBJOUqZAbuS/dp3J3QIaxR4gwjYi80QGWyUabRB9g
         zMRmSAdBDjCq7DNaObbODMUVYLlFt0IItA87im9qIGJmUwm4xxzfZ1yf8H8S4rdyuVvI
         YLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vBI+n6R1FCbaNpcY2beRWPIJrzbCO758rgC3BSuPO/g=;
        fh=Y7FN1ewIacT91CtEIgt1GXIw94yz15RVT5rE5roElaM=;
        b=KzebvWhmHXtkUziHS8yz0kMHIuuWCcZW3FkGSn5JqNW+/bKLg2jErafE8NgZ/WVx3F
         Q3CZ1/CyZa94XObzgrpxTQ9b/gcvb6yZ6SJQQ2p1+PbFudCknhctEbJrpJVrxVao3iB+
         p43Q7VS019VYRtnmoz1309SlZ3BJt7NWU/Yb3IQSQB5VgVmeknL01k7POOuBUD+gtTi3
         7/OcOjQxi3lHjMpk+BOHaRMDcMh3VphqzPfgU4eLFk+BkXcZDDQ1jnSgF8drsGVlE5I7
         IQT768goqlqDIJTtSEdzYUX011qkFVhZLknFTJL57JZP13LBqfaIU4tm2ePP9Rm+/IPo
         7nPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790359482; x=1790964282; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vBI+n6R1FCbaNpcY2beRWPIJrzbCO758rgC3BSuPO/g=;
        b=MPkuGcz0vLDQc2fb6kFEdZF9hKQ173BCZpK7mgdUD5eloYUxfn4x3O8v1Xz71sqFy3
         pvulI2vzB57DaN43okv/1HzCeVRC5xq4Jp2Fc6BkqkHKt5dVIyt/8akpDmBDvbwq2K7j
         IOBb3s7aHYI6pWt6Pv4UlwAYgPnmSz7Zm+VXp+BSK9G8aKyL5wnT2KgKbmgsXfKnP402
         koWgmc284r6Vx719JWO+mUkHAIlq/PGdowxYFcDc5PGq6w6WsUmH1HlCIlFn7DS3XnYq
         /uLfJugGMp+1jCMM7/tirzzFmi/Nc3N1A6anuAXXFt9swRUn1pZFHpkMjjAjN6NfkHkg
         96Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790359482; x=1790964282;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vBI+n6R1FCbaNpcY2beRWPIJrzbCO758rgC3BSuPO/g=;
        b=YhfIMJhcpgSsolSDIY9vtQd59t8RiN4BUE6wRRB5Fhh4gbJvRIi1FOrZbBkKnGbSAV
         tiYcPBt9Ap4E8V13its0hn8Gh6tch67FYPGqbIgNctIgl3gdnOcquTFJM+SpS4pc2Skp
         nSSmAUu0n7aYS+8WkZmvbT/0m4gbjx6yxhyJNrHxNnVBj1z/KULwx6KmVCXA/N6G5zSe
         Gm4Hk4is+jf81O22lM3y3e9S3DT4zRvMQgfTDIJwcHMQMN905UpIObqI6LubL987rl7V
         nPODvSh7tzFiMEG7SWO5Zyko57QKErB/j0z2iaspoNF1iI9Cd3+XgIOiifX2p4ANQRj1
         gOgQ==
X-Forwarded-Encrypted: i=1; AKwUvBzJfacvd9YijroaYhyPa1UdzzNPJYY4OsWb/KVNGz1TivIt/z5LS1ncZJOECIzn4SMgtPpu4tI1@vger.kernel.org
X-Gm-Message-State: AFuF++mrAGWk9BYbmpHukNGcncAic7Mopw/SoT/9dR1KPj8zBkWHCjti
	3i01wsW5mcT3ZDQmUvSXUefUzX/dNHDZg9/w99SV68WPLLx7LQ+MnJJvkIaBVb/kQEX0DZOJcel
	M7SDR+KEY5Hp6FTjr1PnKnKT23++Yvus=
X-Gm-Gg: AYBFou1zHmb4alfF0V8t9ugx7C3Rf5nThPIuQ01GJNU3tkjB2tKllmg+RHUN8zkyeZM
	uE1JqS25kU3+EBmx5Og5KCBoRZZMTtP4dSdLKn7YctcGzxAVFddH5NZ7DByzg/C/r8mtsGNEdwa
	RMF45l3oXpH1PbmrLtoeuX4gtQU12fxgd7cO0nV5Uno2UVlm0w2deoO8JAcpwNdxH/KYvaL3Fit
	oOz8/01BS4CJGJR4Nc2/zu14NSbB/Eg+j5hTTK9l1R7wf0qdDAaFiKmlCwq+/EVNuxM8td2NdDI
	eI6fXRjgX6aHg2RpaAjSBSGJkZtbUeTKV27SgOF/X8zfd7zUzlzdhf3QRjBLmIz7Tq9FLl39ILI
	xfox7cfarrQ==
X-Received: by 2002:adf:e188:0:b0:486:f980:2361 with SMTP id
 ffacd0b85a97d-48872ac750cmr11089879f8f.45.1790359481944; Fri, 25 Sep 2026
 11:04:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com> <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
In-Reply-To: <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 25 Sep 2026 11:04:30 -0700
X-Gm-Features: AclHuK9M6sByraBalcuxusp1b55zwq77trojcuE4-O8KiH1MjzZCIBnwjTVVWQA
Message-ID: <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
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

On Thu, Sep 24, 2026 at 5:44=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Thu, Sep 24, 2026 at 6:20=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Wed, Sep 23, 2026 at 2:18=E2=80=AFAM Chris Li <chrisl@kernel.org> wr=
ote:
> > >
> > >
> > > There are too many swap_is_vswap() in this series. It fragments the
> > > code path, making things harder to reason about. Esepcially around
> > > locks. I count 22 in this patch alone.
> > >
> > > I consider this the biggest drawback of this series. This
> > > fragmentation of the code path.
> >
> > This will mirror my response at [1], but I'm responding here for the
> > record and for your convenience.
>
> Thank you. Really appriciate that.
>
> > It is needed because vswap *is* a special device, with its own
> > requirements. If you don't special case-it, you'd get undesirable
> > behaviors.
>
> Ack, that is why I am against making it a special device. That is the
> whole idea behind xswap. It is just normal swap device implemented via
> swap_ops just like ext4 is a file system implemnet on top of VFS.
>
> > Let's take Baoquan's patch series as an example.  It treats the xswap
> > device as just another swap device, without any special consideration
> > for it. Which creates several problem:
>
> That is a careful design choice. Keep in mind that design choice
> usually has pros and cons.
>
> I will follow your feedback here.
>
> > 1. At allocation time, cgroups that disable zswap might get an xswap
> > slot, because you don't do any check that the device you allocating
> > the swap slots for is xswap. At swap_writeout() time, it is *stuck* -
> > we already do the unmapping step, so we cannot reclaim the page.
> >
> > Ironically a physical swapfile backend could have bailed us out here,
> > but it's not in that patch series yet :)
>
> I am not sure I follow. Are you referring to the uncompressible pages
> that xswap would have to reject?
>
> One way to address that is for xswap to just bite the bullet and store
> the uncompressible pages within xswap. That way it will stay out of
> the reclaim LRU. Zswap also stores some uncompressible pages. The last
> time I checked, it was unfortunately not able to serve my case but
> perfect for yours.

Not even that. Say you have two kind of workloads in the same host:
workload enables disk swap but disable zswap (zswap.max =3D 0), and
workload that wants zswap. Let's even ignore writeback for now.

You add 2 "swap devices" to the system: xswap and NVME swapfile.

At swap allocation time, xswap patch series does not check carefully
which swap device is being used, so you might get an xswap slot for
the cgroup that disables zswap. You're stuck at swap_writeout() time.
You can't undo it anymore, and you don't even support the physical
swapfile backend to fallback.


>
> > Vswap both has swapfile backend, AND allows you to bypass it if the
> > cgroup disables zswap. Both involves a bit of swap_is_vswap() check,
> > but I think it's worth it :)
>
> If xswap needs the lower tier it can allocate for one. I don't think
> xswap should need to have swap_is_xswap() there. Also xswap does not
> have all the baggage of zswap.writeback enable interface.

But that's my point. As of now, it does not. Unless you merge the
other RFC series, which brings it to roughly the same size as what I'm
doing here.

>
>
> >
> > 2. Per-CPU allocation caching: since all devices share the same cache,
> > xswap will invalidate the caching of other devices, and vice versa. It
> > would be fine if the these devices are interchangeable, but as noted
> > above, it's not, especially without physical swapfile as the backend
> > option. So you're forced to taken the slow path more often.
>
> This will be addressed by the swap tiers series if it is not delayed.
> This should be addressed in the core swap layer not vswap. Kairui also
> has some ideas to improve that. Yes, it is a problem area, but it is
> not specific to xswap. We are well aware of it and have plans to
> improve it.


Which is 2 massive patch series away. Also, I don't know how close we
are to reaching a consensus on swap.tier. I defer that to memcg
maintainers.

>
> >
> > Vswap gets around this by adding its own per-cpu allocation caching,
> >
> > So by being too lazy and not carefully distinguish the swap devices,
> > not only does xswap not work for the writeback use case, it cannot
> > even work in deployments where some workloads (cgroup) select zswap,
> > whereas others select disk swap. It can only work if you intend to
> > have a single class of device - either virtual/xswap or disk swap -
> > but not both.
>
> Baoquan's writeback series is out. It is by no means perfect. But it
> is much closer to what I have in mind. That is a much better base to
> work on.

It's *literally* the same design as me, from a metadata design. The
only difference is:

1. It moves the metadata from a new dynamic cluster struct and shoves
it into the existing physical struct.

Like, you can check patch 11 of this series. It's practically the same
thing, with the only difference being ou

> >
> > Maybe instead of just grepping for swap_is_vswap() and throw your hand
> > at the complexity, read the code and try to understand why it's
> > necessary first, then propose simplifications if you have good ideas
> > in minds.
>
> Yes, I already read your code I decide that most of the
> swap_is_vswap() should not be needed if taking a proper swap_ops
> approach. I wanted to offer you the chance to work closely with me to
> achieve that, but you did not follow that suggestion.
>
> Quote from my old email:
> https://lore.kernel.org/all/CACePvbX+3tO91BmRwaLqf3Xia32GCemt3W8tayErG81B=
YLgrzA@mail.gmail.com/
>
> "I am happy to spend some time working with you to discuss the generic
> adopted version of vswap, if you are open to it. Or if you don't want
> to waste time on it. I can have someone else or myself come up with
> the generic adopted version of vswap for you to review, which I prefer
> less."
>
> Anyway, Baoquan's xswap writeback patch series is out. I suggest
> following and improving that series instead.
>
> > > This is questionable. A vswap device does not go through swap on.
> > >
> > > This changes the behavior where swap devices always go through swap o=
n/off.
> > >
> > > I wish the swap device went through swap on to be able to start swapp=
ing.
> > >
>
> >
> > What usecase would necessitate the need for swapon/swapoff interface?
> > Other than just trying to shoehorn it to an existing interface?
>
> I like universal interfaces. Your vswap will break the /etc/fstab. The
> current suggestion for xswap using sysfs will break that as well.
> I would like to keep the /etc/fstab interface working, including
> support for UUIDs for swap devices, etc.

"Universal interfaces" is not a use case. None of the thing you list
out here is a use case. It's an interface, but you have not
constructed a single use case to justify all of that.

> I am very concerned that vswap will start kicking in without me
> explicitly enabling it. That changes the previous user-visible
> behavior. It breaks my mental model. Please take this feedback
> seriously.

I mean, there's a knob for it. How can it start kicking in without
your enablement?


>
> > I've expressed why I dislike the interface in [1]. Other than the
> > sizing aspect, which we are already discussing in another thread,
> > priority also makes zero sense. You are literally exposing an
> > interface with only one correct answer - what's the point?
> >
> > Justify your interface choice with real userspace use case, not just by
> > conforming to the status quo.
>
> That is why I feel your patch series are really unclean. I dislike
> special cases, I try to avoid them as much as possible.

Again, your disliking something is not a use case.
