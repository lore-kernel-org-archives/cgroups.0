Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EAE7260F;
	Mon, 22 Jun 2026 23:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782171995; cv=none; b=otl4XRIeal8FwsDWVGuumrKEw5tdWWnyHItQlQ9qqfkvDFr+Jp3DL637E/VtzOXp5g3W69TdBAnp7RnNIZ3I8eJtFm+ABKgcSNL726QO6dc0HeqPwPlu9RyZJQnEts7JGBdCgIiw9pwa3RELdw1KnXA9jkJH9EbE+RM9r5usREc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782171995; c=relaxed/simple;
	bh=seabZtbNOCNAPG2R67d3UdknIP2NESiGXOEo8r5SZu4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SzbyQ1DCtvQ03bGtIT4Q/DyFBoa+keDln0GOxL4am3yftPrzTPmHXj8xBZ8bCOpgwLocJ1/SvkC9R8lkfOB0HJS/5lbVGyxl+iVF2dJj/0hG8Z4Fa5/py5V7MkNQKQYUarWH/BEk7MywNUVwG1wt4JOXXX8mcn3fE1JDogoPMXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EKui55gg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EKui55gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238551F000E9;
	Mon, 22 Jun 2026 23:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782171994;
	bh=ZSHJBLoJ+dWJVwc5iapW1lVBZzDPVPjrz4FsQ/5Y1tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EKui55ggl68KS9bfibjffBO4ATEI/oVW9g/Pk10ECXU+bxP6g2lkFTMq8djcKoU90
	 VDG5MKH2LnbbMyouefWJ9gQUjJHX8x34FnrAoT23uTQLur2JLKUDEPV3q0s/sLDIbX
	 RiNeGidw/W6BATanNE+zDxALUa0711gHkM6ugW1VpZ9VrHtDJVvFj6jpnEAdIOXfJa
	 rEAbm4LwbPbTPeyXzpgSsNTIXrD/bKxPWtS/Qy73vFd5iMFMmXzFNACWfk54Gg/TtN
	 7TsitNVIHlwCMDldQcFSxmuivvqJpjdo30zwWlJtOV1xMU+SHUY2i3Vq2iBhCr5SO/
	 Oce8IZRL+oROw==
Date: Mon, 22 Jun 2026 23:46:31 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Youngjun Park <her0gyugyu@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, chrisl@kernel.org, 
	youngjun.park@lge.com, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com, 
	matia.kim@lge.com
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier
 selection
Message-ID: <ajnIasdb6j6yDUdy@google.com>
References: <CAO9r8zP6zDshSGU4chaHiPocahQZpiK5Z-eP9VKH+2_xjNM+4g@mail.gmail.com>
 <20260622231948.1002174-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622231948.1002174-1-joshua.hahnjy@gmail.com>

> > > If that is the case, I think auto-scaling makes sense but can be a bit
> > > tricky, since there is no universal tiered ratio; each workload will
> > > have different tiers it can swap to, so they will all have to calculate
> > > their own ratios. Tiered memory limits escapes this difficulty since we
> > > assume all memory can be placed on all tiers, so we have a system-wide
> > > ratio : -)
> > 
> > Hmm I don't follow. It's also possible (maybe not initially) that a
> > memcg cannot use specific memory tiers, right? I am not sure what the
> > difference is.
> 
> You're right, I was speaking more to the current state of memory tiers.
> The majority of the feedack I received was that we already have too
> many memcg knobs, so I just opted to make tiered memcg limits a
> cgroup mount, with no ability for individual memcgs to tune their
> limits or opt-in/out.

Right, I think this is similar to the approach taken here. We have a
single interface for per-tier limits. The main difference is that we're
allowing 0/max values to disable/enable different swap tiers per-memcg,
as there's a use case for that.

Seems like for memory tiering there's no use case for that yet.

> What do you think Yosry? Would it make sense for us to be able to 
> tune these values? Personally I think it makes sense but just wanted to
> make the basic features merged before I went to push for making those
> knobs tunable.

Right now we're not proposing to allow tuning swap tier limits either,
just enable or disable a tier. My main question is about the default
values.

IIUC, for memory tiering, if you set memory.max, then the limits for
tiers are auto-scaled. I think it makes sense to do the same for swap
tiers for cosnsitency. Or am I wrong about the memory tiering limits
behavior?

> If we want to make the tuning the same across swap & memory we should
> probably align on the file names and how we interact with them.

Yeah I think we should make the interfaces as consistent as possible,
within reason.
