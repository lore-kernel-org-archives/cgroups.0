Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6A33BADA5
	for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787153458; cv=none; b=qFNmCRndHjtzCLcwGwRgFvebIVSPmVrb/id4nqbZo9ET4xUyz5VLMypfL1I2dyzXR0jz4/U4VgP0NElaVQ5f2YynSKMbVRXIqwxdUqDIqoMGdWGh5hXa5f6/aY7sCKPV+rVcWhA0Cf2DrIe+01QTOhZ6WXiKsNrJFjDQqtSOR2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787153458; c=relaxed/simple;
	bh=CdEet1rWwmQcFrN0OVffIqtncv13ORRiSKE+nSWH8+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tY+o0lAOvCWrXVeLH4Zhhc27BR4MMHg+LWzgK+dk+uEdzkx8KneM73d5aGZFESo09zClSUB4hv4rE0oR/mXV1h62hC4N+R9wLNXSRI6c2C0QRjzuOdWUxnqFmLlUoVvCtG+Z376u81raJnpdITXHHlx8QZNfcMYfiBG6YnmsC3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=N5x0E+Wd; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="N5x0E+Wd"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8efb708b1a0so8884036d6.3
        for <cgroups@vger.kernel.org>; Wed, 19 Aug 2026 08:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787153455; x=1787758255; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=73Guz/TIbEzOujSIckuYru9856ZGn+H/xGETeqkPBLw=;
        b=N5x0E+WdIwP234nRafLOCEjHvcOZ7kdf6ab/0WBkhDcaJdd2KTtMvCbeV/0f5Y6z8i
         6QziCmC8/8cnebn7MV/y2JD2bFaSKwAEuT9gJuJ+rqWL5O51yi250ENCrxzod5vF6vyC
         57sdYJUC/eksGf1tgiJlsszyItIF4w0TemtvwNyLhpxno+QlmuQxcre+lVEpLemO1T2S
         FIav9rB/rQRpC8ptXCMY62iEvKfeevNnnTT1UrJcjul5toiHXKunJZ//1adqeduB/AnD
         8ydIt2s9e+7q4BsejlMu3jP+Xnk/rsjEQn9733eIijhGjMk9pDWpxBYt2Ii1G+asGEf8
         9PiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787153455; x=1787758255;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=73Guz/TIbEzOujSIckuYru9856ZGn+H/xGETeqkPBLw=;
        b=Gjpsba6oLt6f75knXDznb6AvV32h5EFYUMKhIruYIdVqAeOrNMhWV0ZedwLtkBjp7F
         CJ8snIicEx5lwWP7u/BflrS3cKaPIAqNsNFDbO1FpEg/gW4M2W1qS3dWSYEyUHUX7uPu
         QY7fHg1EmeLPP0xMKawMe6GKaionUn176w7UbwYKrLarUnxv2OOIOt6IVaEBxlPudQS7
         F+p5uwsOowARo+yCSO6LYKXvE6/w7HjLDCR+ThHcSLL9wbcosGRRPbT0RXAvgX9SCbVf
         5fp1fRVgOq3N4IiEkSNRncXgfOTRK7pmnw75fYAQI7v+hHpXLZV7YglamUOcB45sfgr/
         3o3g==
X-Forwarded-Encrypted: i=1; AHgh+Ro7djKXcSxiFBlPjk0RNa/w/MOB6o+E5onaZCyu7L9oKHbrNnKzjLMJOVOyVxuIo1JHEdEVbmPw@vger.kernel.org
X-Gm-Message-State: AFuF++kAzc4lbvLR0bOvrlkIUmkbtFuuRBTCZP0LLyHiZ3zL2Aue505I
	oMzZmCNgWJqXv0WnLi3D/FiWjg9WXSgVyT5NQpohSWaZLPhgQLL+xMzaRJSKjnIDpdM=
X-Gm-Gg: AR+sD13FW5Hz3yu+4fRFxXZLq4coZK5SO1RKohBz4nuvDWGufU3yu613xrY0iUmH+P5
	Dv4+d2g9rDzXR7FpKyMcoTa7Qqs1J2zcNYdk+ijouIbaMJHPzGbETG6VHPZ6V2plIAviF8q0p8e
	hi3YzcQ/dyqP2Q5KsN4Jg3pAOYZ6fjW5aEpxOe9o+EsLSl8gR3exh8EK9RVv8uvBpD1lh2bMaJ7
	btZ4Byn0hk8lFbIEoJkR4zfedUbm75IspD4SNzc5veuCWSiwZ6g87SF5sE0L5Y2iEOIU4xlg487
	yM3m8mjVdfX31jD4V1cG/ERVznJJFKJfHXQLMAnPOYyC7sgEC5JXVQNffMERpSPkJ4oVDuClWe8
	h3tYiaAk4bhU3Sc4wuM/tv7Y6pTTrJHWIg7AVStm6nC1hPhraW3wo+XvYcDS9sodug2KrSz+7k9
	hm3sfpY8/2ocvfjvMnEJw9pxnD59Oc2iZ4/4Izo02+bIOPAPa6h58mQQRSCM/zy6tRJ6QndSyIL
	zgVypyQam/M4ia5/BNP1iBJK+0WezgB/gmQmn7H8lnRbmuqjBmhKmyQ
X-Received: by 2002:a05:6214:3217:b0:908:9045:217a with SMTP id 6a1803df08f44-90c5eaec0d3mr57812636d6.29.1787153455181;
        Wed, 19 Aug 2026 08:30:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2905d6sm16697626d6.29.2026.08.19.08.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 08:30:54 -0700 (PDT)
Date: Wed, 19 Aug 2026 11:30:53 -0400
From: Gregory Price <gourry@gourry.net>
To: liuqiqi@kylinos.cn
Cc: joshua.hahnjy@gmail.com, mhocko@suse.com, shakeel.butt@linux.dev, 
	linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory
 accounting and control
Message-ID: <aoW9roOicxJoCKCP@gourry-fedora-PF4VCD3F>
References: <20260818154954.805958-1-joshua.hahnjy@gmail.com>
 <20260819132211.366064-1-liuqiqi@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819132211.366064-1-liuqiqi@kylinos.cn>

On Wed, Aug 19, 2026 at 09:22:11PM +0800, liuqiqi@kylinos.cn wrote:
> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> Hi all,

Hi! Thank you for following up.  A few things.

> 
> Thank you all for your replies. I am not very familiar with the
> community's workflow and should have reviewed the mailing list
> archives and existing implementations more carefully. I sincerely
> apologize for any inconvenience this may have caused.
> 

Less of an inconvience, we want to save you time as much as we want to
save the larger community's time.  Having multiple interested parties
vet common work - rather than propose differing solutions - does that.

Welcome to the discussion, glad to have more eyes on the problem!

Hopefully I can provide some context on the history here, since I've
been working with Joshua for a while on this in the background.

> My work is based on
> https://lore.kernel.org/all/20260528134212.240492-1-liuqiqi@kylinos.cn/

On this patch, It's not clear why an RCU-protected pointer is
unsuitable.  RCU is hot-path safe, it's just not stable nor
sleep-safe, which should be sufficient for any operation which
may be looking up this particular mapping.

These values are not expected to be aggressively written to, so RCU
essentially becomes a NOP on the reader side - it's extremely cheap.

More ideologically - adding a cached value of an RCU protected value
is somewhat anti-thetical to the entire purpose of using RCU in the
first place - it creates more footguns than it solves.

That aside, getting to the tier-aware memcg limits...

> aiming to develop memory tiering limits for cgroups. During
> development, I referenced Joshua's v2, but failed to notice that
> v3 had already been posted when I submitted my series.
> 
> I have studied Joshua's v3, and our core mechanisms are largely
> consistent. However, there are two differences:
> 
> 1. Read/write per-tier interface (memory.tier): each cgroup
>    tracks its memory usage by tier (e.g., DRAM, CXL), exposed
>    via a new memory.tier control file. This file reports
>    per-tier usage and accepts per-tier high (soft limit) and
>    max (hard limit) settings. By default, these limits are
>    automatically derived from memory.high/max based on each
>    tier's capacity ratio, but manual overrides are supported,
>    allowing administrators to constrain specific tiers on a
>    per-cgroup basis.
> 

There's two levels of operation we need to think about here:

1) What the kernel does by default without tuning
2) What the kernel enables admins to tune

If we don't have a cogent story around how #1 should occur for
this feature - then every knob you expose for #2 is just creating
a mess of tunables no one can possibly understand (let alone maintain).

That's why Joshua's series has no tunable knobs - any such knob is
simply unwarranted at this point.  (This decision was born from both
on-list and in-person feedback).

>    Its advantages are:
>    - It can express allocations that fixed capacity ratios
>      cannot.

Which should come from a use case born out of demonstrating fixed ratios
are actually insufficient and cannot be made to self-tune.

But we don't even have those yet.

>    - Latency-sensitive tenants can be given a larger share of
>      the fast tier.
>    - High-capacity tenants can have their soft limits removed
>      for the slow tier.
> 

These are the same issue as the first bullet, just differently shaped.

>    Whether or not to constrain a specific tier should be a
>    decision made by the administrator on a per-cgroup basis.

This is an opinion, not a fact, and should be based on data that
demonstrates the kernel is incapable of making the (or a) "right"
decision in a sufficiently common scenario.

> When the fast tier cannot accommodate the working sets of all
> workloads, it should be the administrator's scheduling decision to
> determine fast-tier allocations.

There's basically 3 use-cases that have been collected that I've seen
which tier-aware memcg looks to address:


1) Self-policed fairness

   Stiff per-tier limits that cgroups impose on themselves.
   i.e. proactively applying tier(memory.high/max) to ensure no
   container's tier(memory.min) is ever violated.

   This creates reduced variance in exchange for lower throughput.

   This is paradigm essentially does not exist today except via
   cpuset.mems (e.g. putting everything for a task on CXL). This
   is intended for things that want stronger QoS controls.

2) Opportunistic fairness

   While there is sufficient space on a higher tier, cgroups should
   be allowed to "over-use" the upper tier opportunistically to maximize
   thoughput - but when someone's tier(memory.min) is violated because
   another container is over-using, we nudge everyone toward fairness.

   This creates higher throughput in exchange for increase variance.

   This is milder modification to the existing global opportunistic
   behavior.  Think of it like trying to apply a soft memory QoS.

   It's unclear whether this actually has value, but can probably
   be accomplished via existing min/high/max, rather than needing new
   sysfs toggles.

3) Per-cgroup adjustable tier limits.

   A scheduler knows something about the workloads it wants to
   have custom tier limits per-workload.

   This should be seen as an evolution born out of finding where
   1 and 2 are insufficient.  It's putting the cart before the horse
   to go directly to this point.

   Very few of us are convinced such complexity is actually warranted,
   especially because the simpler (and less ABI-permanent) #1 and #2
   haven't even been fully explored.

> As Shakeel suggested, and given that Joshua's v3 already
> contains the core mechanism, I am dropping my current
> standalone patchset. I would like to ask if Joshua would be
> willing to collaborate with me on this, treating memory.tier
> as an extension to the patch series and proposing it as
> follow-up patches based on v3.
> 

Joshua can speak for himself, but more eyes and testing and data is
always welcome.

~Gregory
