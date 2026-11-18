Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795009124;
	b=eBxGQdnPlzyPul/VoZ0B3GXuvqzEo/E1WbQ0XNn0XfhoPEyfq6wkEHdZOVYZrTr0EfPt
	 b1vO7+4TRSTWR02zEg9wGkVJBVjvnVIcIEZsDDjq3q2OeGVkoTHhl/22fGiHZWI03Hk6d
	 7WPQmyvCbpPBbe0WbDt9mMnjzOvwHT+1/8a2mUZPxQ6NCMpfsRoTE6gyUmY3sN2IetS3J
	 Jz+JiqeP99MGQTPizxy+AwTiExCDfbrJZEqhpc1Bbcmuh52iGtRVYibKy9EaH5ilgfMWH
	 wH/GGprsKwc0sN4ppNxaEDddCnHCrBiFMqs6ag0KVzzBElWtVEQ7wIyCyr8ByZ/vSeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009124;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=h50xYCZDbBstrT/18dKKndyJ3XtJH6sY5/J/QnXGpDQ=;
	b=h4Ap1VDeNxjKYZ3V92f22J7MV8RRRjyWRPwY5x6GJnKzsRJagas7+AoMHBgeImTY/vkt
	 uNbY3vBCWCqH1sfmFwaDHrzvHynqRqHameFDVYyb4y9QDfzVCBt+EU6E1aOLfG6ZrsjYv
	 Xk9p0t8A5Kr2/bzQ9KPD2ecCHP4DeoYZcvX/c6k0UyHtYgZuBq1m1BZ3ouFKaUT5we37P
	 eRK+in7KWwJ/3r704gRCdHZLRulDdZfcH5Bz3O0E6WkUdThZU+WCsJuTi8mG3SRdNEEJI
	 YH9jGOQumYwoklLODGtJAEZgAqQFJZEycr1k1sR43Y1v4fdvtMgMS4q8990D8NpNi5g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DGPTWsj1;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b="m1U/f12J";
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0CAC60A2607
	for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 13:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0CAC60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DGPTWsj1;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=m1U/f12J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795009123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h50xYCZDbBstrT/18dKKndyJ3XtJH6sY5/J/QnXGpDQ=;
	b=DGPTWsj1tcK7BHakniQKRg5wXJb+lKnVxEXj7BGYIhDdMMYbwh2Wr4/0Q49v/m3qW/dsds
	PXzd7CI8GoGaxh0JFgxa6zOio0f0IZ5MVYE9tBbnaiArvxV89Y8rW+ZKtFnlw/19nIqn4Z
	OXySadyFXfPUeMnq2XHkraGwVLEvGSw=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-a0NmMH94MueFAJrtnqPgZg-1; Wed, 18 Nov 2026 08:38:41 -0500
X-MC-Unique: a0NmMH94MueFAJrtnqPgZg-1
X-Mimecast-MFC-AGG-ID: a0NmMH94MueFAJrtnqPgZg_1795009121
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-8b3ad09ad82so13425297b3.3
        for <cgroups@vger.kernel.org>; Wed, 18 Nov 2026 05:38:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795009121; cv=none;
        d=google.com; s=arc-20260327;
        b=PmKDhW3lPEsaCUVgylrhDy6SUYuMZFEFWVbgCaMhfItaEJQa/7Zv2pUjUezwZYwGYu
         eN6MgZzHK6kbbHHTggVk1dMwTHYhU2F28+jfbKk9ybzuNBuzcLdPQDfkAFYIZMT9HWUr
         3iPtI2tzzOmMeVvgnpoO7EYLFV8yym7PPwkyQcDzJxWYFcC3appV4fKd5JWPpeg4OAWu
         00yKU60caGAGPIfgyhUR2cm0E90GrMSFlhzA6E5e5twlAO5Y5znWosjJQwQE/dpIxWDz
         4VL6LFAZaWMC9/TqYy06ybB0nvaW8IBDkIXTaIeysaaWcIH4fhvEEa8yES6DK6hlGbe3
         kI1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h50xYCZDbBstrT/18dKKndyJ3XtJH6sY5/J/QnXGpDQ=;
        fh=bafV7QYVG+yaT+ueTiG2ySeKmn8uKAFymBs3yLxgn6Q=;
        b=iK7A6pK6ZgnzlhlKqRKvi+SXaoqSluj9bIzc2rsoXU0GBAnElaDU60Gxrgpu+rfKlN
         00oyBj3ynZul4sL9u2ReL3H1dxnShnEFt31819U2rbxh/CjvRpx86lotCacjDnmK0jEY
         ujqYA3Pnub02y7b14PE/e2JctFQfUPtSkp5UtAF80D+AFDmj9giy7x9MskKXgRKGMQqy
         l4U8U0prwcc3BM2ZhoiNeYQV5gyMH8huSmUliBGNtSBBEHgg35vGko0MPqEG0kRP10pb
         JS7f/owcwaw4n5M5rVD5M8ODPqa6Ascp3OdQmarAXPaTWqyAym5zl56TsKMMXuWdhVqY
         rYYQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1795009121; x=1795613921; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h50xYCZDbBstrT/18dKKndyJ3XtJH6sY5/J/QnXGpDQ=;
        b=m1U/f12J+ShUTGTGggJRi8KWH5geQbIoUtFMFOrndyGwP0Lkjvyue4j595npuKQp7v
         UynlTtWXc/N0WgxJO1Eh9B0rgmNUcUCd/fe2y2aqqhwEQc5sz7XB3d3BF8blaFQQsm6l
         BIFKk/wJx3tUMG+ZzqdOa04aWuQnHC9c3eHjYq77Zs5R6PpyZS6fg5pUCCDzRlxbuqeL
         6TWfG8AGCYSHLpH+pLf9WpAQ9HEa4rOwR2cAEOBu/tri1gSzxl1aXRj3xSBR9pXZKIMm
         9sqYw0Eu6CMouTg16/H3YR/idZKQXNHpJbp9J077XuX6pp7ekW4DOfM8so6CkAaAAyiW
         esFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795009121; x=1795613921;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h50xYCZDbBstrT/18dKKndyJ3XtJH6sY5/J/QnXGpDQ=;
        b=zakleXpCCVlr4NM/XcMCbHkqIYC3bQCWN7DCQ9o+WTIgbLrk8nHXFXjaLDtBBZvo6j
         1/ZEURbzmr9oPYLEaFdE+bK78RNuciu3yxtShxkqmgFbxq1vBl/vq+cfB0m1aewFRaIZ
         0mUdy5uX4RKDN6VHgqQH4y7JedHTW0ZOLN8fHWo5M1nOg2K5VdYZOlWzLRdunsdm7LbL
         URdzw12Y/YXB4kP+kpXq8s5NFMPF3A/n5gKolcTbAKieoCJ0cQzr/0zfPLYLN3v6ti4I
         XL8nwE8o4R7B57COWEwD1nBdX456IXsalRpoDMzzma6LN3qQOgSVaqom5ptGCyyC4cgM
         kLuA==
X-Forwarded-Encrypted: i=1; AL+hErHvMaBnMjNqBQbp4LK9Rgl2vTtWKBFGi/J4nCtl5fDRmY44/75p/zXzliGDeDMu2ZIXNcv4wOLq@vger.kernel.org
X-Gm-Message-State: APuU4Z/nQHhj9Mh1kLsSDfdNjxQOVMM0Joz4PRGufJH0hvZoS/DpUbaZ
	KRqx0F0VcIehDleh5q80hppVNk7zdKCbPuyKInypTl6yYmv2mqXj4IkAqAMzgHIVdObtKGoQuMR
	M9LB+xnv5UGeD9g9dHofQ+HFZVWKI/Q0rfrOe3vhlgqLqb2OX5AoAIkQ7DJMvlQwezfISxyopne
	sFa6VL0WgUSM9IZrOBQGDtZY+Q1vSmXpmbTA==
X-Gm-Gg: AZFdTZdtFxWrR5BgZCAkozYFQXdbRcFILeXslr/EgG0mXpkK0J3flqRKjugXnNgGNce
	DK2N9bcPEr/o+lkANE0g1nookXLBDLrb1703TeR68zy8JP6fgx+zEn77gkhMlCp9fwmZkOcxXYq
	1NiEskpn4sAvGqjOOVhoqd6RshSbBB/LpvyIzXg80Wp7Z8EErZxi1ifwtW
X-Received: by 2002:a05:690c:368a:b0:873:5bb2:6bfd with SMTP id 00721157ae682-8b4fed83351mr10018237b3.39.1795009120757;
        Wed, 18 Nov 2026 05:38:40 -0800 (PST)
X-Received: by 2002:a05:690c:368a:b0:873:5bb2:6bfd with SMTP id
 00721157ae682-8b4fed83351mr10017817b3.39.1795009119849; Wed, 18 Nov 2026
 05:38:39 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117-v2_20230123_tjmercier_google_com-v5-0-1ce975f2a9ad@redhat.com>
 <4356992ac4fb7876fb5759189ba4b492@paul-moore.com>
In-Reply-To: <4356992ac4fb7876fb5759189ba4b492@paul-moore.com>
From: Albert Esteve <aesteve@redhat.com>
Date: Wed, 18 Nov 2026 14:38:28 +0100
X-Gm-Features: Aa3M54php6hihR6Ihi3l34Ri9nQdKaLYB3Ss2kJeRmi5f3v9ab0vBjDa0q2nnvI
Message-ID: <CADSE00JyTwrbNh4r8PZWLqOHWpepyHkaL+9fkc+AbVRmCc-f-g@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] memcg: dma-buf cgroup accounting and charge transfer
To: Paul Moore <paul@paul-moore.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Shuah Khan <shuah@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	Philipp Stanner <phasta@kernel.org>, airlied@gmail.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	echanude@redhat.com, mripard@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 11:54=E2=80=AFPM Paul Moore <paul@paul-moore.com> w=
rote:
>
> On Nov 17, 2026 Albert Esteve <aesteve@redhat.com> wrote:
> >
> > Shared-memory allocator services (e.g., Android's gralloc)
> > allocate dma-bufs on behalf of client processes in different
> > cgroups. Today those allocations are charged to the allocator's
> > own cgroup, leaving client cgroups with no visibility into their
> > actual memory consumption and defeating resource limits.
> >
> > This series adds memory cgroup accounting for dma-buf allocations,
> > building on T.J. Mercier's earlier series [1] and incorporating
> > feedback from previous versions and LPC discussions [2].
> >
> > Patch 1 introduces the MEMCG_DMABUF stat and the
> > obj_cgroup_reserve_dmabuf()/obj_cgroup_cancel_dmabuf() and
> > mem_cgroup_commit_dmabuf()/mem_cgroup_uncharge_dmabuf() helpers
> > in mm/memcontrol.c
> >
> > Patch 2 wires up the charging policy: dma_buf_export() stores
> > exp_info.objcg and updates the stat, a new charge_fd field in
> > DMA_HEAP_IOCTL_ALLOC accepts a pidfd or cgroupfd to identify
> > the target cgroup, and __GFP_ACCOUNT is removed from system-heap
> > allocations to avoid double counting.
> >
> > Patch 3 adds DMA_BUF_IOCTL_XFER_CHARGE, a general ioctl on any
> > dma-buf fd to transfer charges post-allocation. This covers the
> > double-hop allocator case (SurfaceFlinger -> gralloc -> kernel)
> > and works for buffers from any exporter that opts in. Charging
> > is gated by dmabuf->objcg being set at export time, ensuring that
> > transfer is only applied for buffers backed by system memory where
> > size reflects actual bytes. If the receiving cgroup lacks capacity
> > for the charge, the ioctl returns -ENOMEM and the original charge
> > is preserved.
> >
> > Patches 4-7 add access control for cross-cgroup charging. Letting
> > userspace decide who to charge needs to be a privileged operation
> > because it has material impact on OOM decision and resource limits.
> > Charging outside the caller's own memcg subtree requires
> > CAP_SYS_RESOURCE. On top of that, LSM hooks gate the two charge_fd
> > flavours: security_memcg_charge_task() gates the pidfd path (target
> > identified by task credentials) and security_memcg_charge_cgroup()
> > gates the cgroupfd path (target identified by cgroup directory label),
> > with SELinux implementations using process2:charge_to and
> > cgroup:charge_to permissions.
>
> I'm probably misunderstanding the description here, but in both cases
> (the pidfd or cgroupfd case), ultimately the cgroup is charged, yes?  In
> the cgroupfd case it is more direct, but in the pidfd case it is still
> the cgroup associated with the process identified by pidfd, yes?

Your understanding is correct here.

>
> If that's the case - and it very well may not be (!) - it probably makes
> more sense to combine the two SELinux access controls into one.  Yes, the
> LSM hooks and callbacks would likely need to be different due to the
> mechanics of it, but the permission check "cgroup/charge" could be the
> same.

Combining SELinux access controls makes sense to me. I kept them split
because I wanted to preserve granularity between the two flavours, and
process2 seemed like a natural fit for the pidfd path, but I guess it
can still be achieved with a single permission through the target
types.

I'll rework for v6. So, in the pidfd case the check target would
remain the process's domain:

   allow allocator_t client_t:cgroup charge_to;

where allocator_t is the domain requesting the charge (i.e., the
central allocator), and client_t is the domain of the process the
pidfd refers to. The groupfd path would check the cgroup directory
label like so:

  allow allocator_t cgroup_t:cgroup charge_to;

Would that be ok?

>
> > Patch 8 adds selftests. The tests and vmtest script were mostly
> > written by an LLM, closely following the style of the surrounding
> > tests and the virtme-ng setup. All code has been reviewed and tested.
>
> I think we need to have selinux-testsuite tests to go along with
> this, especially as this would be the first patchset to add cgroup
> controls.  Historically I've pushed back on piecemeal cgroup additions,
> pushing for some basic design of how to manage access controls for
> resource management first, but since evidently no one wants to do that,
> we really do need tests.
>
> https://github.com/SELinuxProject/selinux-testsuite

Agreed! I was already playing with it between the last version and
this one. I have some tests drafted, more or less. I was unfamiliar
with the testsuite, so instead of offloading the work to an LLM, I
tried to follow along and proceeded too slowly.

I will link a PR when sending the next version.

>
> > Known limitations:
> >
> > - Single-owner model: a dma-buf carries one memcg charge regardless
> >   of how many processes share it.
>
> Once again, I'm sure I'm misunderstanding things, but are you saying
> that multiple cgroups can end up sharing the same dma-buf despite
> only one of the cgroups taking the accounting hit?

Yes, you are correct. A dma-buf (its fd) can be shared by multiple
processes from multiple cgroups, but only one holds the charge. With
this series it can be transferred, but never shared.

Sharing could be a follow-up series. Perhaps splitting the charge
equally? But sharing is a big problem on its own, so I preferred to
keep it out of this series.

>
> Hopefully the charged cgroup is deterministic?

Yes, the charged cgroup is deterministic: it is set at allocation, and
only moves via an explicit ioctl.

>
> > - Only memcg accounting. CMA heaps would additionally need dmem
> >   controller integration.
>
> Do you have a rough idea of how that would work?  I ask only because I'm
> interested in seeing if that would require an additional LSM hook or if
> there is some way we could leverage the same hook(s) used here.

Rough idea, yes. Today, no dma-buf allocation charges dmem at all, and
of course no target charging either. The first goal for CMA is simply
getting those heaps accounted. In that regard, Eric Chanudet has a
series making CMA allocations memcg-accountable with per-area counter
[1], and is working on extending that approach to dmem. It's a bit on
hold waiting for the feedback on this series.

But afaik the cross-cgroup charging and central allocator problem is
mainly a system-memory one. Whether dmem ever needs the same
cross-cgroup attribution (e.g., DRM central allocator wanting to
charge clients' dmem budgets) is not clear to me.

Nonetheless, if it does, the internals should be mostly the same;
everything, including the permission checks is controller-agnostic.
Only the controller performing the charge changes. I expect no
additional hook is required.

[1] https://lore.kernel.org/all/20260821-cma-memcg-regions-v1-0-d21b165b844=
0@redhat.com/

>
> > - If a transfer of an uncharged buffer fails, the buffer remains
> >   charged to the original cgroup. The allocator (userspace) is
> >   expected to handle this (retry, free, ...).
> > - The LSM hooks are intentionally narrow. Broader cgroup access control=
s
> >   (e.g. for the memfd/kexec handover case [2]) could be a separate effo=
rt
> >   reusing the same pattern.
> > - Only system heap sets exp_info.objcg today. Other exporters
> >   (DRM, V4L2, etc.) can opt in by setting it, but are not
> >   covered by this series.
> > - Related to the above: lazy backing-store allocation is not supported.
> >   This can be extended later, e.g., by adding a flag on the dma-buf
> >   struct for explicitly marking when memory is committed.
>
> Similar to the CMA case, any rough ideas on what this would look like?

Yes, again I have a rough idea. We already separate reserve and commit
operations, so the idea is to delay when a charge is committed. For
that we can use a flag in the dma-buf struct to mark when the memory
is committed. The limit is still enforced up front (so a lazy exporter
cannot overcommit), and the stat reflects the actual allocation.

The permission model is also unchanged for this case. The flag only
affects when the stat will reflect the charge.

Thanks!
Albert.

>
> > Note on TTM/GPU accounting [3]: that effort charges system memory
> > allocated for GPU buffers per page, with its own stats (gpu_active
> > and gpu_reclaim). This series charges at the dma-buf level, for
> > memory with no memory.stat category of its own; exporters whose
> > memory is already charged by their allocator must not opt in, so
> > the two do not overlap.
> >
> > [1] https://lore.kernel.org/cgroups/20230109213809.418135-1-tjmercier@g=
oogle.com/
> > [2] https://lpc.events/event/20/contributions/2416/
> > [3] https://lore.kernel.org/all/20260706052330.1110909-1-airlied@gmail.=
com/
> >
> > Signed-off-by: Albert Esteve <aesteve@redhat.com>
>
> --
> paul-moore.com
>

