Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792641384;
	b=qENCLQKhoCSzqoMM6q5Il20wL+nU5wInXsHSwwFLFWZS8EWQcgskucAsZ8W64z6eKgPy
	 TYjamBuutC2Ha0ucEzgJFu8ivIw7/X+VsiIFuFw8W/fei3hcBGH9gNwUNwFfmPuuCAxsM
	 Xv4wL8hXnarUFJCuF5SfPsUe3huCVY/bVwQ4DgOy2JpLCnxM947tr5MVlrTNUCqzkPibg
	 L8EhR1mfWNDeHkSrgfs6iWr+cuA489ypVrsO3dCub05Yj/AUwJ8l6BVrA00Ow6ZqessYJ
	 Ic4EeooBHom9OgFte30pVqCG+SbD2Uo7BQA7NsRvjJRra2L2bcLamWqcyBb5K46z6MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792641384;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=nBJVMizSkP5mIMubRGP9eWHn8SLS+RX8waQiqIH32K4=;
	b=IA1t2OU6KnEKgZOFCSBtXo3E8tb81pesdibmT4j95XP+rJnYyzBw2C85/N2d9VJLjJ5P
	 7oURM9nA1GgIsLHcIlA45XsOSzSO//IIWaTtO5CnCkNYvjvDCZtycgSOF/J1eibB7WHTW
	 Oz1EXF6SHiVS3Wrgb7J1CYaNC0u2DT1/1sk9yhFYHmAlYTvPPUonYsew5fSKK2mVXdLJU
	 8WO0LR79H0HzvGNSrNF54kxQ051u+2OuUJJnE1RE6fJDGDC7fytRVnHkrs2zv66oOevvD
	 Bxumii5x5iYi01bdiMVj2p/kkrHsac+XFDIFMFx8BqkKnkQJottav3hnT9WZyleAVNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gourry.net;
	spf=pass smtp.mailfrom=gourry.net;
	dkim=pass header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=onuWEefU;
	arc=none smtp.remote-ip=209.85.222.179
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0C0606A31A
	for <cgroups@vger.kernel.org>; Thu, 22 Oct 2026 03:56:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BF0C0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=onuWEefU
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93f3c89594cso102948585a.2
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 20:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792641383; x=1793246183; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nBJVMizSkP5mIMubRGP9eWHn8SLS+RX8waQiqIH32K4=;
        b=onuWEefU2jjcs+hCjUkLSfdNl69v6fK0TFmwOd7kcR12a6A+gkQYVGBnE9SCneJp34
         OD+o0tgqfx5K/2B1MsiIpnBswsXjL4yIHRvlekKvfiFnHRLApQH4xtEDYw8LDmJNew2T
         MftfIYBedbPSORbGkJ/2pJPSY8a3Af/n0E1eGUYdHjRdxQmVGOdVm0vrum0O64RQoLoD
         6BlwrjGgv2AcZSJTbuS5sjccrjvqZKoxiiL+GlPoe8HGjldsmgPnfYfZTjU3s7zYycXG
         bXsyPwQlkIvXfryr1Qr2xs28H2bZf1hRDGT0Py1cdiMvHU7Q7MrZpNA2eRb5bPFibZE2
         05wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792641383; x=1793246183;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nBJVMizSkP5mIMubRGP9eWHn8SLS+RX8waQiqIH32K4=;
        b=zKyXgcMXR8W5bC37+P2PQ65bOzBpll/PlEiZCCpWgVZ0nlU81HVZNpXfG9skFlwknL
         p8UNRShtLJw1kiyPHswLR55Z5kaYIYkacfVW4TZoHl8pAhnYuQSm4xFcOYKELbPaxppc
         iy1uzGgGMgE2+NPJAG6fZ5fZ7fgpmMWUattwJIPtc5hTzzBZLGdn6Oidpa+k1eIPQRqq
         lVRZoL5Q61dzW3Dmbvxqsug1kenRnJvN1g+WrOSjiC+V3vI3hPbj/tsv48mOw1Ww5xcZ
         Eh1fU1MRwkQy/YOXmIjOIrywiS8TiFv67Hf9f4gyren6QjbiSuaI3IGvwjPcWjR4WrEp
         xLYQ==
X-Forwarded-Encrypted: i=1; AKwUvBxOGNggbcd7njk+/hs51b3KMIx0YLvcXUrEScoNZGDeMsgkAlpNNef858RVGNsRo3ndiLtufFQT@vger.kernel.org
X-Gm-Message-State: AFq9FYIe/dcp+zxGfIqbleBsh7R0EkQxbyxahKzSkrAs4pjPdIQTgXTD
	NizcYVA/PAXDVVN7HHFy5IaSx0LSQ8dhTzdM6dTw9KsTJuboXa8sx4qBfp1mS5sCjrM=
X-Gm-Gg: AYBFou2DHeLEY0d8PyDt870QVMK4RKgSOvLc2V0Gl8jtd8JORdY5onz94FNoebpv7Na
	ocHTdbn1HMWFUDIE/fCrZzJGUCsC95tSVIE5Tmq2a1zmjxOA4AOTg1eksza41Rk3FGEalinpY2a
	wxH5OQ8EFeCvHUmys+XoWXPoSy9x16X7n2Y5MTQItF1hQsR8w+T7C8EdJhLqpKGW3jGQHvIlPKt
	avu+kkAt+2plF12s1+QV6tVU63+oyyT8CKy64+FzNTqqUEcxsOtC5F0rDmMId8XuDB9/n+igGCE
	8r08LAXPAg1FrrFUEJCvp7xQPZywEdPWugEhad927zQ7F5hmaEMLgK/tvE6YaJ7UX8CzMVyJr6G
	UoBhRsEox8S4lcJBFP8NXmPQNrfD3kkgKclG4HB7SRSudgvOL6FIa/pPKG0Y3H+6i1Nabk2JaR3
	IjzHHRcxehEWg5zSCtju3A0BUobIy7xCzUMxwI8AgEC5UgTyOhxIlpRDie/r4r+kCbCdd8BUsnf
	2/4djs49OoELm3nQfqppKvhofkphM8tHTqDiHLntSBLrLO2GFqvn56Q/j6rIDDsftHMcV5hcO/v
	lRvRXUKsQzNTqiYIFIILSyp8W20=
X-Received: by 2002:a05:620a:6f9a:20b0:93f:6182:53d with SMTP id af79cd13be357-93f618206b2mr208635085a.3.1792641382767;
        Wed, 21 Oct 2026 20:56:22 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56d9a495sm423380985a.13.2026.10.21.20.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 20:56:22 -0700 (PDT)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: Gregory Price <gourry@gourry.net>, akpm@linux-foundation.org, 
 david@kernel.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
 ying.huang@linux.alibaba.com, ljs@kernel.org, mhocko@suse.com, 
 muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
 weixugc@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com>
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
 <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
 <30457046-a662-4ff7-a6a8-100398d7a806@bytedance.com>
Date: Wed, 21 Oct 2026 23:56:20 -0400
Message-Id: <179264138036.2549665.17429111144570830454.b4-reply@b4>
X-Mailer: b4 0.17-dev

On 2026-10-20 21:01 +0800, Li Zhe wrote:
> On 10/20/26 12:10 AM, Gregory Price wrote:
> 
> I agree that the kernel reclaim and demotion behavior still has room for
> improvement, and the watermark changes and the bottom-up proactive/async
> reclaim idea you mentioned may be useful to explore for some tiering
> scenarios. But I think there is also an unavoidable userspace policy
> component here. The kernel can improve whole-cgroup reclaim, but it
> cannot know every controller's placement goal.
> 
> For example, one controller may want to keep a specific per-tier
> resident ratio for a cgroup. Another use case, as Joshua pointed out in
> another reply, is reclaiming from a lower tier first so that later
> top-tier reclaim has room for demotion. A single default memory.reclaim
> algorithm cannot express these per-cgroup policy choices.
> 

The latter of these should probably be some level of the system default,
that's why I brought it up as well.  (proactive reclaim should prefer to
make progress from the coldest tier first, then work its way up).

I'm not convinced a reclaim interface is the right way to affect a
per-tier resident ratio policy.  That feels like a hack to get around
solving the harder problem of something like tiered memcg counters
(which would otherwise drive reclaim to work exactly the way you
describe for resident ratios).

> I am not sure whether changing the default whole-cgroup reclaim behavior
> in this direction could affect existing userspace dependencies. In the
> old nodes= discussion, Mina mentioned that Meta's reclaim stack relied on
> memory.reclaim triggering demotion [1].
>

Yes and on its surface this is something I could see Meta using, however
I question whether we're simply trying to find a convenient way around
fixing reclaim to do the right thing (not invert the LRU, apply per-tier
memcg limits, etc).

> I also do not intend source= to lock in current reclaim implementation
> details. It should stay consistent with the current design: source= only
> selects the resident source to which reclaim pressure is applied, while
> the kernel remains free to change the reclaim policy.
>

Well, sort of, you get exposed to the implementation details by having
to negotiate what is considered progress under different scenarios.

Lets take one example - what should happen when:
 - 2 node system, node0=DRAM, node1=CXL
 - zswap is configured
 - echo 1G source=nodelist:1 > memory.reclaim
 - node 1 is pressured, zsmalloc falls back to node0 to allocate

Should that be considered progress? We reclaimed from node1, but
increased pressure on node0 - which might have kicked kswapd or memcg
accounting to demote memory from node0 to node1.

Should zswap also take that nodelist as a constraint?

At the very least i think you need to add details in your cover that
demonstrates the process of doing something like per-node resident
ratios, and show that it works as you intend.

-- 
~Gregory

