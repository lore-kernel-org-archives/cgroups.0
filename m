Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CFD3314C4
	for <cgroups@vger.kernel.org>; Sun, 26 Jul 2026 07:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785050039; cv=pass; b=aCfxvsOxTtAsAPC198A4hyFYE24mZSHq93AmhL1hbL5em9704LRaBvWCo2SAHOzujWYbp0rhjBmpvTyIPV0iGdbm497pCFW8PGKqQHlHbKMNiTamF7ScrrLjbH90InGSVceSr2e+QSg99TR5LoENm/RmF+Cs1lYoRl0hPNrxufQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785050039; c=relaxed/simple;
	bh=PfuVKzyHkGeC7QduIvQZhEjm0ypZWONr+fuoY0lvZb0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I4ui/E/34tQSqhVS6+MhXTpKplnoO3iqQSRaAdTPr8XsQ8NXPFm8x47XE/PXxrUHlTYhKU2aEor3FVny6eHrzMDfAPGEBDEcAD+oaIIzRv1l7nBsFWCDoXro2lvyTpmnFGDx5dK7Eqr5gk5GqcqNJ+EUwDPw8yLt/XeOtIIBVqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AB88bPa7; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AB88bPa7"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-81ed000b507so12489497b3.0
        for <cgroups@vger.kernel.org>; Sun, 26 Jul 2026 00:13:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785050037; cv=none;
        d=google.com; s=arc-20260327;
        b=szUSyr35Z1RRhJpBiXJMm2uZz1gfNwTCtP+TgfFYlgBAWhd2H5ETKNzOqUKKNcDse4
         aa9tFtpO41KxVUWkNLZHCsc0/T1AMjrtwr92ct8lTONQ/VBHcx0yxNqWfvHNG16K3XqX
         vP2bEVSEz6ND1rhRfy0e/Dhzc9amsbTMpC2/xY/LzLuF8y5ZsaHQCy/hhdsMFGcT0yq3
         JNyXNglK8NxAjsbaZsFr/Xc5D68O5+Yxk8YJ9ljpPC7ENYrlHakI8pMc5k+lVlm6NhiT
         uQSgTCuLqcx4sroO8up0ixU1aqt74Ckgk/1xkGbCOo+rOFF4r6aPQYfV2hKLoVlvYXz/
         vP/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PfuVKzyHkGeC7QduIvQZhEjm0ypZWONr+fuoY0lvZb0=;
        fh=Po9xRE8HRpT6/XWw1f9NdLtBTInooxCiaBYXxGd4BpY=;
        b=e0gPT0lKZTAg9RQsujhukl4oL3gU2jjFesvQKjrUKkfsrZahRtu6DoMJcP92uHFivV
         eZiAoVRfnq9EtzmlAC/18Hpt0f01jHcslxkwlKozj8V569791wzOSFPeByvXqJBqTOmE
         m6afi1V8L4Ry8azjS5Hx3SzQoo4g+KPtrMHKo1OsnIUa/yPlpwPC5HH7uGcj2CY3Qe4b
         CtXxGAa3TgCdrABqxsl2EBral3g7zGAFsI9ugAtgsuZcDOL4N7pJEVpmF/2DoDiYa/DO
         Zu/NcHQ8iRr5srrkeovio3IiHUHWqK8wIirwZkXDavrIaYLJO65vBY+P0iBrpUkjGk1y
         DneA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785050037; x=1785654837; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PfuVKzyHkGeC7QduIvQZhEjm0ypZWONr+fuoY0lvZb0=;
        b=AB88bPa7leygl0FAZSH3dlYOFKCr7BLJaFPkgdG+KNPzVl9tL1Kf70ksgjNqvm6/Ae
         /Mlgws+tLJrjLa4gLV7ezuwfQh9+9GeYWXHWaE3pQ7dRC0ZlwsmRtfRQUHNN+nYwr43e
         fNVRm59xHTohhOhH5V+XE+JNunnDxgQ7eAjv96tfwjw6vBAGB9mpRQ0kT0NsiakVRe1R
         8QlxPcAODLSY6oaL+wMu9zCCaU9SEr3DAEjVDrnHoCyOzilaBNheuY5BaOZ78T6cbrQ3
         yMuDHNH2HXyvYhLvmdwvZt5WeAIFdx1AG1EAxwr7DfvMUH4U9lL1O3cIi9TJMkOqVpOt
         jBAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785050037; x=1785654837;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PfuVKzyHkGeC7QduIvQZhEjm0ypZWONr+fuoY0lvZb0=;
        b=CcmRhZtU8bFKrXYHxd1eikBjWcYfPoBhC7XD27fzdkjNKKPxSfRdAknnDVvqCTVNmH
         9xTg6CLz1sJ+uxQK8ArJqjSalX8Ap8WGizirrc2/QXKneURv8fuZf15bxcqcmFGGl+Df
         +O5J8oE4gG/nXDzJHmrW7RFRq6JRRsFgnWiqesM6chrSYTN0F6BYAv6U+AKYLpW1WKgP
         Ef1FfZS6ZWJuYPfhweaGHU7DYY+Q2wKxuuN/6cFDkxWUxLYA15hWnGcKyzZLqOi4hP3D
         FrfrN8t1qlrVrFANb1Ft/FOqqu5soRilbpnPJDYDxmbKcpgJoyOy4JvAgR3dj5gV9KVO
         aCAw==
X-Forwarded-Encrypted: i=1; AHgh+Ro6fJnQ4UrIpeFITW/YYIKgqn3V6hkfuhHwx7E9eS8D3MNbf40WJKkHzmboAIHoNN3hTCbskqi9@vger.kernel.org
X-Gm-Message-State: AOJu0YwMY44vJ7dF4QnkIEep/woW1wtY9dufmPs4GhKDR6T2pEIF7KJk
	vvrCXrRZbr6Tt6jJ0otGhP1jNFcZxMQNdjE+uySouWAjlcRoz18YBNBtkzAtN+inl+53kF1dkPt
	w4Mhfy/zW+GUSQpaAztC+9x0JpW0Af9k=
X-Gm-Gg: AR+sD10jOszV2yJ0DL4WBIk9OhCHQCQZ3z9jIOeFPJbgnyqmSZLhZZvztkzktVFjhjw
	1zYpeS8/EZ+HyNs4YxoucjyNzIzTbH2OdgDxuJ8c2U9kyNeVfM7sXxTsCzccD67GXotya8A2mLL
	jgm+1FJSzcfSVhabtsVgPZt3Lg61SA1DyuvCssTrJJgSC5l8IXQevioY68Za4sO1rATTEwSW4lA
	uGkRpUKB5IJk64LxP/NrMt8yQmZF8EgmcEipvgcjvU2v15FMr4972B1QHIsP6WsP3dhj3KBrW/O
	F1mXSvFFswgWiSmZXDKE51kWYFQs756ixBOY7z0Uw4RMYg0=
X-Received: by 2002:a05:690c:9a11:b0:81c:8a31:629a with SMTP id
 00721157ae682-81f69d179cbmr14420367b3.22.1785050037306; Sun, 26 Jul 2026
 00:13:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260706052330.1110909-1-airlied@gmail.com> <02ba25604e746fefa1a0ba54a76ad486154954ef.camel@linux.intel.com>
In-Reply-To: <02ba25604e746fefa1a0ba54a76ad486154954ef.camel@linux.intel.com>
From: Dave Airlie <airlied@gmail.com>
Date: Sun, 26 Jul 2026 17:13:45 +1000
X-Gm-Features: AUfX_mwIsr918oSTQyXpLA0gOrjwCmaxzhDWNrhcDPHkn6jdd0TR3NXvGpne2No
Message-ID: <CAPM=9txH=ZMJB84YJ26UqVrD8JM8foNY4qd_s-d5trigz5tDNw@mail.gmail.com>
Subject: Re: drm/ttm/memcg/lru: enable memcg tracking for ttm, xe and amdgpu
 driver (part 2) (v2).
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org, tj@kernel.org, christian.koenig@amd.com, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Waiman Long <longman@redhat.com>, simona@ffwll.ch, intel-xe@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Jul 2026 at 00:35, Thomas Hellstr=C3=B6m
<thomas.hellstrom@linux.intel.com> wrote:
>
> Hi, Dave,
>
> On Mon, 2026-07-06 at 15:22 +1000, Dave Airlie wrote:
> > This is just a repost with a number of sashiko identified problems
> > that I fixed.
> >
> > I committed the vmstat counters and list lru changes, and they are
> > now in tree.
> >
> > This is the remainder of this series. Intel have expressed interest
> > in getting
> > this landed for xe, we can drop the amdgpu changes for now if they
> > can't get
> > across the line.
> >
> > I've dropped all previous acks/reviews.
> >
> > This series adds the memcg counters for GPU active and GPU reclaim to
> > align
> > with the two global vmstats. It adds an accounting flag to TTM
> > alloc/populate,
> > and enables memcg tracking and shrinker support in TTM.
> >
> > Then it adds amdgpu and xe support.
> >
> > I think for this to land, Christian holds the main objection which I
> > still fail
> > to fully understand beyond it doesn't solve all the problems we ever
> > have had
> > with cgroups and drm, so we shouldn't even bother, and maybe we could
> > do it at
> > the object level, and integrated with dmem, and android cross process
> > accounting,
> > but I still feel this is a good baseline.
> >
> > I think this is the right layer to hook this into TTM, where we
> > allocate memory
> > and I think accounting for this memory in a proper way should be
> > done.
> >
> > Intel folks (Thomas/Maarten) please review and express concerns as
> > well.
>
> Some questions about the design that might belong in the cover-letter.
>
> - First, Since from my understanding gpu shmem allocations are charged
> against memcg, (i915 igfx and to some extent dgfx), I think this makes
> sense, although it would be good to have an outlook:
>
> 1) What about system memory allocations targeting suspend / hibernate
> evictions, will they be charged against the root cgroup?

This was a problem in my first memory tracking patchset, I didn't want
to track these allocations against the stats, but Matt Brost fixed
some problems with this idea. I think maybe charging against the root
cgroup is the proper option here.

>
> 2) Plan for limits on total gpu pages / pinned gpu pages? Is dmemcg a
> fit for such limits (coexisting with memcg) or should such limits be
> implemented in memcg?

I was just letting memcg control this, at least account first, then
work out how to limit within how things work now, I'm not sure how
dmemcg fits in here, I need to also look into the other discussions
and try and workout where dmemcg could be used.

>
> 3) IIRC I noticed a patch for dma-heaps where dmemcg was suggested for
> android, since it separates GPU memory and system memory. Do we plan
> simething similar here, based on config options?

I think that is Christian's concern, that we shouldn't do this at all
here, and we should do it with dmemcg instead, but it seemed a bit
handwavy and I'm not sure how to turn it into a concrete way forward.

Dave.
