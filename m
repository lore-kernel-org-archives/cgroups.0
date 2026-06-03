Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F5D48BD21
	for <cgroups@vger.kernel.org>; Wed,  3 Jun 2026 19:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780515340; cv=none; b=m52XrayU8/yOvgyLZK4MIy7qgjoEip6kgGID55TEEnr/7ZwWTxkR0aTXZb9tXJyoT3A/2SJ8noHOGOqXQNlnZtgkM0KCWOmWMDoZxe9BauACGo7G0Q7kh6BFsvp/1A07zUamxpQkeeh+M/8h54H0Xd1dMgTkHDiLpkP2Cm8Kr/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780515340; c=relaxed/simple;
	bh=u07LQCZrZCzeOi68gImmUZITUxsNpQXTkBl3ocL8ckA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jKtzkQGkArtI1WxPasDiM52Z2YmEdNP+sTV5mz3GYHEm4eEf+5jnWu7Bplhu8xVKiuRb68LyMAur+F6mX36uJKHNp/vdtTUQIBfFMxRU+ul/PdYXu6mMyjva+PhIGOSzw5yE+u7/abccuvKQqCSzblol3n4bjs0eWrvfUgcEkck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgFHQ493; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgFHQ493"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312171F008A2
	for <cgroups@vger.kernel.org>; Wed,  3 Jun 2026 19:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780515339;
	bh=u07LQCZrZCzeOi68gImmUZITUxsNpQXTkBl3ocL8ckA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OgFHQ493hTJ63/qV3zKt0iFy8gG6gnwdqpUoqFL/HL8Ocgwi+S9/T1lbbDR8GnBnw
	 A7r0O+1PebrP/DXacX+3BZugw8Q29FvXNApWlxLHOWPCpspM5IvbGcS+6kpq+r1WGM
	 UqZ5lbK4mMRvmVmaBEplCrwgyEq8ZASi94zgXTCBl8VlW3xh0ZGGAiwtUBNVM03qiP
	 7xBkH4K4jY+nOqf9V8cw8uHmxhKKrINKUvkVaLEScqd0gTyr9PyhGwAW8oBqdI+b0p
	 jx7yh7GmV1LtqAMma4Jr1ObhZP2xLUH/C5yY+fVzZn/0VRdaY3pIS/Jeomvjl5JWKx
	 pwv9+JcPBrz+w==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bebbc325000so565173066b.0
        for <cgroups@vger.kernel.org>; Wed, 03 Jun 2026 12:35:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/aXheOLZFgMMUKhivwRHexELSWLh4rTOSBEOBrwZ8m/F5ODBR1VIY4dLuH8fljqPbEEy71avLy@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0cZnVns6QrvB5kOc3jPxdFpkYBTLUxJ14Q8nTHBgQ+S7AFJn3
	SLwiFYht+zAVvJCsCEqX9SgsUUNUxzl8B6M+RvGZZXKc1Ej4dUx7I4k6rxjM8Ias0dJSL5mT3VG
	0iDUOp0lg++krIV1Zl612Cbq/paTo37A=
X-Received: by 2002:a17:907:1de8:b0:bee:bcf6:6a22 with SMTP id
 a640c23a62f3a-bf0b3ab6000mr194330866b.44.1780515337855; Wed, 03 Jun 2026
 12:35:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ah-A2gQ0GPgerXop@google.com>
 <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
 <aiB2sHqxcBAJrTkP@google.com> <CAKEwX=P95D7wNpWhEAXQpeNPM6eQa2mEZE8Srzfpct=-=Q40tg@mail.gmail.com>
In-Reply-To: <CAKEwX=P95D7wNpWhEAXQpeNPM6eQa2mEZE8Srzfpct=-=Q40tg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 12:35:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP+PkgRzXJcFv+3i2pKFQdLt78Ax1s1DY0qNaiUo7ySqA@mail.gmail.com>
X-Gm-Features: AVHnY4L0m0RhGOnZt-UIR2Jm32pDGFi3b0zgu6vy44XckaL7GIMQMtilhMhRPjY
Message-ID: <CAO9r8zP+PkgRzXJcFv+3i2pKFQdLt78Ax1s1DY0qNaiUo7ySqA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 12:26=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Wed, Jun 3, 2026 at 11:58=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > > > I assume the main reason here is to avoid the extra overhead if
> > > > everything uses vswap, which would mainly be the reverse mapping
> > > > overhead? I guess there's also some simplicity that comes from reus=
ing
> > > > the swap info infra as a whole, including the swap table.
> > >
> > > Yeah it helps a lot that we don't have to rewrite the whole allocator
> > > and swap entry reference counting logic again :)
> >
> > I specifically meant using a full swap info thing for the physical swap
> > device even when it's behind vswap. That seems like an overkill, and we
> > don't need things like the swap entry reference coutning. We probably
> > just need a bitmap and a reverse mapping.
> >
> > So I am assuming the main reason why we are not doing that (at least fo=
r
> > now) is simplicity?
>
> Mostly.
>
> FWIW, we're pretty close to full deduplication. Right now, physical
> swap clusters have a couple of fields that are not needed when they're
> backing a vswap cluster:
>
> 1. The main swap table (which houses swap cache, swap shadow, and
> reference counting): I repurpose it for the rmap :) It's an array of
> unsigned long, which works for rmap.
>
> 2. memcg_table: still duplicated, but I think I can make sure this is
> not allocated if physical swap clusters only back vswap entries. I
> have a prototype that I'm testing for this.
>
> 3. The zeromap field: this is actually not allocated in 64 bit
> architecture, IIUC, which is what I'm gating CONFIG_VSWAP on. If we
> extend vswap to supporting 32 bits, this can also be dynamically
> allocated.
>
> 4. Extend table - this is for the swap count overfills, and already
> dynamically allocated.

I see.

> > > > All that being said, perhaps I am too out of touch with the code to
> > > > realize it's simply not possible.
> > > >
> > > > Honestly, if the main reason we can't have a single swap table for =
vswap
> > > > is saving 8 bytes on the reverse mapping, it sounds like a weak-ish
> > > > argument, even if we can't optimize the reverse mapping away. But m=
aybe
> > > > I am also out of touch with RAM prices :)
> > >
> > > In terms of the space overhead I do agree, FWIW :)
> > >
> > > I think the other concern is the indirection overhead with going
> > > through the xarray for every swap operation, hence the per-CPU vswap
> > > cluster lookup caching idea:
> > >
> > > https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail.c=
om/
> >
> > Right, but we should already avoid the xarray with the swap table
> > design, right? We just have one swap table pointing to another
> > essentially?
>
> Hmmm, I don't quite follow your suggestion here.
>
> For normal swap devices, we organize the space into clusters, and
> maintain them in various lists (free, nonfull, full etc.). The only
> difference with a vswap device is we do not have a free list, and have
> the clusters themselves dynamically allocated.
>
> If we're using vswap, we will incur the xarray overhead. There's no
> avoiding that if we want a dynamic indirection layer. We can of course
> revisit this data structure design later.
>
> So yes, it will be one swap table (vswap cluster) pointing to another
> swap table (pswap cluster). But to get to the first swap table, you
> will have to go through xarray still.

Why the xarray? Don't page tables (and shmem page cache) just point
directly to the vswap entry the same way they point to swap entries
today?

*looks at the code*

Oh, it's to find the actual cluster because the vswap file can be
sparse? Hmm yeah I guess we can revisit the data structure here later,
but IIRC xarrays aren't particularly good for sparse data. Maybe it's
usually not sprase in practice.

Maybe a maple tree? :)

> > > If folks like it, what I can do is have CONFIG_ZSWAP depends on
> > > CONFIG_VSWAP, removes all the non-vswap logic, and call it a day? :)
> > > Then, on the swap allocation side, if vswap allocation fail and zswap
> > > writeback is disabled, we can error out early.
> >
> > Hmm maybe we can keep it around for now and do that after vswap
> > stabilizes? It ultimately depend on how much complexity we maintain by
> > allowing both.
> >
> > I think another problem is 32-bit, technically zswap can be used on
> > 32-bit now, right? So vswap not supporitng 32-bit is a problem.
>
> Ah shoot I forgot about that. Hmmm.
>
> It's not impossible to make vswap support 32-bit. I did that for v6
> after all. It just needs extra fields because we have fewer bits to
> leverage in pointers etc., complicating the logic a bit. Follow-up
> work? :)

Yeah we can do that, but it's a blocker for zswap only using vswap.

> > General question (for both zswap and general swap code), would a boot
> > param make implementation simpler? Right now we seem to key off the swa=
p
> > device having the "vswap" flag, would it help if it was a runtime
> > constant?
>
> Hmmm, even if it's a runtime constant, both branches still have to be
> there, no? Does the boot param simplify it somehow?

Maybe it doesn't simplify the code, but if the branching causes
performance overhead we can use static keys. I guess we can still use
static keys per-swapfile, but it would be more complicated.

Anyway, not super important now.
