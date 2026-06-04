Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416953BF698
	for <cgroups@vger.kernel.org>; Thu,  4 Jun 2026 05:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780551381; cv=none; b=T24BbU179UaLcDPcsiGKZ/Oh50pVN8+3FdwP4r5qNdA+C3XpxeU0UREw60ddFMMrLrX6DelmFO1r/Ljoda83NmDpDw7OqRVUhHmtRPdzya9UkNTBTMKqIlrCM1xwyg9vOYyPOF9sZvuOPtGvg2ndSWERUerGSXob91d7ENDeLGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780551381; c=relaxed/simple;
	bh=hlf6gZ7zE0nZZVqddnEN3mtWYxn26ImLM+nzUagCUEc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=on8usKlQr7Q0R+gOXMtPQJ/X0MI6YIJJEFyk1bYAN1NYOhNH3Jj44imsQvChg5+/3KUZpiRE6Or584aS0yna7ccE1LHp/CktXlHTtb4Dz9fPQDrHUM4FwHv5844vqnEI/VhptJ0DHGj2jzBywehCQBRcp9aVxFx0maalY0C0Cuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gdMDMi4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdMDMi4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38E11F008A3
	for <cgroups@vger.kernel.org>; Thu,  4 Jun 2026 05:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780551380;
	bh=hlf6gZ7zE0nZZVqddnEN3mtWYxn26ImLM+nzUagCUEc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gdMDMi4YgBtoGh5YNLNCJyqy+lw64oERWsV7XQCyiUTXkrrJiCIzII6H7jD86aDKa
	 nkGhZQOUi5Gracb+Ixl5YFl85bXK+VEHccERo8LNO68+HU95F5hNUk5JJt+qjcBJQ5
	 LOMEPWl+JBreT6xT9hYuJUV20lbdw9i/mUyYNFNRjWowAKFCIIIScDqYgqeRKJVAEU
	 G4cpJlcSjqOMZaCJGNNezf9ZbDwFxGyM/YJd+0J7STxFEd70Aq9EJ8Sd/SiviBfrin
	 iWdT0TLA76pTpFttQXX2Phlb8rpUK3yGE5kESs+Wl6ihHGDHfBTWgR8ask9PmFhiBP
	 buW08RWhnj3AA==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bec354815b9so22758666b.3
        for <cgroups@vger.kernel.org>; Wed, 03 Jun 2026 22:36:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+OOQeGtNg0Y8GSz21OtNn2g+4Mqc4xO9gLJ0ZsHAHvv/WNUGLk31usQuXK0rOLZOLQZevhHrr3@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8md861/T7gWEh2M2ZfsXaR4qTzqDsuY6ZyaWhHNYrUmW8+lbs
	c40so2y+fC9V1I2IQ4mj1aY/DjMxl46ztciRQMTbk3l4FOJLDRPHZi2NN1LGTl8nuKqOQ8Ul8Vk
	hki1Tf3SqOj3A8ZoivEPbeqZL2BylhCA=
X-Received: by 2002:a17:907:c289:b0:bef:87ca:aec5 with SMTP id
 a640c23a62f3a-bf0afaf5209mr309828866b.47.1780551378864; Wed, 03 Jun 2026
 22:36:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com> <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com> <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
In-Reply-To: <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 22:36:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
X-Gm-Features: AVHnY4IE7N3d59FLndV-s7gDFevntutRjRoeBw3qu7WJHZARyl3yLsqSevGQ5pQ
Message-ID: <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, shakeel.butt@linux.dev, 
	mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"

> >> But doesn't it make more sense to specify the compressed size, which is
> >> ultimately the amount of memory you actually want to reclaim.
> >>
> >
> > I personally prefer compressed size to pre-compressed size. That's
> > kinda what user cares about, no?
> >
> > One thing we can do is let users prescribe a compressed size, but
> > internally, we can multiply that by the average compression ratio.
> > That gives us a guesstimate of how many pages we need to reclaim, and
> > you can follow the rest of your implementation as is (perhaps with
> > short-circuit when we reach the goal with fewer pages reclaimed).
>
> Got it. I will change it to use the compressed size in the next version.
>
> Yosry, Nhat, should we continue using the zswap_writeback_only key to
> trigger proactive writeback?

I *really* want the memcg maintainers to chime in here, it's
ultimately their call.

Michal? Johannes? Shakeel? Roman? Anyone? :D
