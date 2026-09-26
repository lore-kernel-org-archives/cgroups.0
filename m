Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F624052C4
	for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790437271; cv=none; b=YfiI8Ea9YIEuiNFDj1dXm6xqv0/z5ofobkEQGNsWYGbuSqTeUHhtv2+wM9imOcTgueo/kT5qtzC3SmFRlJJdcs8wNzRMYxXdk0wcfXU17vtGI1fesI5TWk+Mp5f4149ZO7QoklspDA+RCokE8jbO1CQ1RDLr38Kitq4XkXB3stk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790437271; c=relaxed/simple;
	bh=nQWv5Uv6nSig9+JUMd7g2HmoHP+cptytoedxN5Hm80M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqA+s4y/6UhS1noUpMgMkD9kweVnHCz6xOvJx5Y1WnDdZ4/aWuAcHpnqj8HxbE63ok9mI5uXBy+t3qdk6BUkI6RDGZBWuuMceux816hbiiiEQ1Z+dfxcrwC85Sdfgvg+BcTUbIUOocNfKewOsxnGllUgbA9fJv9mMvD0wI+/Kf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kwPZ6TLS; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kwPZ6TLS"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843c3ee4cfso829837f8f.2
        for <cgroups@vger.kernel.org>; Sat, 26 Sep 2026 08:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790437268; x=1791042068; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7iYAmkmIlPG9rrJ0GDs88tEbSInUH1AqiZDcZFT6as8=;
        b=kwPZ6TLSHV/bHYaaSPd3lHJQX4l/vgJy1Aq5YjsR68FP1O3/ifHyzw1Wob/ELdrosi
         CmjQ26SLUsJeEMtlA416T2jX2F+SwKlPMluKA6UeZVagMVfDNIX1LZO3cjCyF4IcCz9r
         ahAWaMUFAJb2EEbXXEFFztYv/PN3R/ntvxutQq1ImLqenW9EcpkRIpeuyzBlMzp1q5pO
         aPo9Jx0diUGPvwE0OQJHZbN1fwEQyplM87kzlrt4WEKcnbDTjqXFOxWTd83bPSpKg83K
         J5r9haFV0qCltGWf/kkqf6UOHYDzZIawoQF5A1Szev2Lb9lB+1hlOTPHYJJJ0LqIEEFg
         eCxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790437268; x=1791042068;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7iYAmkmIlPG9rrJ0GDs88tEbSInUH1AqiZDcZFT6as8=;
        b=oRx9vHeaoDmvJsei7Tg8RR/jqiBKrGhwJD/h+IHL2+R70XXtZoVEXbBbWmnx3iE8dQ
         X//l6R4Cl8vGBDFUsdTy241EGRUia/SNQWJmS/jeOivefTElHcBPLb6IJxTD06akZ6bK
         IppidSALzOCVSO1cHIMGiDdbmS7oWQ6g27F+L4rks4Ce/xYa6fwc404GLOau3gb4CjGN
         /NkbKmFS3RjcuLvm0JVeIT19n06NnYYpR4iSrQil50c4TkAN3kRLx7pf3GXzPXx+58QI
         nfXXLmOEG/9G7HBaUSI8Mvb1a4AkNNo/JF6xkIq5YIGuAufwXHvH/uSTFmzznBUnuPuH
         UbUg==
X-Forwarded-Encrypted: i=1; AKwUvByeB23dDAu+GlB+hTdQe3oD2/JO/Qo+w1G8yEyGBmP9J0+F4oqmoEzaPG39YL5Tk+6I2Biuzhod@vger.kernel.org
X-Gm-Message-State: AFq9FYLn6GikpSWQZmri0fqN04q4ZF/e/mrutXMQF/MX/WZHPz4tWFOV
	OTZ6ftUuy3L3/yrJMxpbGmpnuQyJx4bMJqGi3N1Zi5PMP8uNrDpcGYI+
X-Gm-Gg: AYBFou3Xn4uBuLlDviiIFQSWjJt4QR78OXG7aYR3jX3gfFqIWGheGCorJLznEuuX2U8
	7S2lng4NszuyNUYZWcgSNIgg3JA1OEZymZbtFX0wWbjRDGdOZMI9iVyLjife1JZ0c2FNMV37YTp
	hEiLKa2SOTcg5R2NFdGJQae5hgs4d9zM09Ye9fzJb+ufKETDEsdSwl34J+ZFQt9NjLGkkg+d/FU
	2vFI+NpqbrRHfiOd4naQKa+E1y5OK9lzs94YETGdPBAwNY7j9Md5RdUodMBpn46tzBU3OcK+z1u
	wpHOs352CvlDnAdMyx+DfHNbXvI7EW7gXk0d/kCcBr6uXwVc+ewx6YodOF8RzusGYXD0UMtXCWs
	ymBV/y+wibZH5OBj67lyHwCo5f8hvaMecsbCph3L3sSIYtFpD1/POZ/gELAUvtZGOYgTACK4oAI
	tTiUFUJntuXFTAmACDVR+ZK1axC/FZtxChaAi15lwfYfS8TJBsUWuWOPqCE+a9hM0BWG2+x+vY2
	mS7lCtsVBPYAZO4c3xWvO4lyTtaldoHIfNNQHfLRcOS
X-Received: by 2002:a05:6000:288e:b0:488:820b:7e24 with SMTP id ffacd0b85a97d-488820b7fedmr8759522f8f.28.1790437268482;
        Sat, 26 Sep 2026 08:41:08 -0700 (PDT)
Received: from gmail.com ([188.250.243.225])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a34a638sm14236008f8f.9.2026.09.26.08.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 08:41:07 -0700 (PDT)
Date: Sun, 27 Sep 2026 00:41:04 +0900
From: Youngjun Park <her0gyugyu@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	yosry@kernel.org, joshua.hahnjy@gmail.com, taejoon.song@lge.com,
	lianux.mm@gmail.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with
 per-cgroup selection
Message-ID: <arfnkNBANl0fwrKb@gmail.com>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
 <20260916200434.GA5784@cmpxchg.org>
 <arAHu_BD5oqpZJER@gmail.com>
 <arQJIjzE0BlUg0CV@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arQJIjzE0BlUg0CV@cmpxchg.org>

On 2026-09-23 13:15, Johannes Weiner wrote:
> On Mon, Sep 21, 2026 at 01:20:11AM +0900, Youngjun Park wrote:
> > On 2026-09-16 16:04, Johannes Weiner wrote:
> > > On Thu, Sep 17, 2026 at 03:34:33AM +0900, Youngjun Park wrote:
> > > > Per-cgroup swap in debugfs
> > > > ==========================
> > > > 
> > > > Patches 3 and 4 let a memory cgroup choose its tiers through debugfs.
> > > > 
> > > >   # swapon -p 100 /dev/nvme0n1p2
> > > >   # swapon -p 50 /dev/sdb2
> > > >   # cat /sys/kernel/debug/swap/tiers
> > > >   Idx   Prio
> > > >   0     100
> > > >   1     50
> > > >   # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers
> > > > 
> > > > Bit i of the mask is tier i, so /batch swaps only to sdb2. A tier keeps
> > > > its index for its lifetime, so the mask keeps selecting the same tier
> > > > across swapon and swapoff.
> > >
> > 
> > Hello Johannes,
> > 
> > Sorry for the late reply on a good suggestion :)
> 
> No worries, and same ^_^
> 
> > > Can the cgroup be given a priority limit? That would have pretty
> > > obvious inheritance semantics:
> > > root
> > > `- batch (memory.swap.prio.max = 20)
> > >    `- task (memory.swap.prio.max = max)
> > >    `- logs (memory.swap.prio.max = 10)
> > > `- interactive (memory.swap.prio.max = max)
> > >    `- task (memory.swap.prio.max)
> > 
> > Right, the inheritance is clear and easy to understand, and with this I
> > can pre-define the limit without knowing the mask value.
> >
> > But first, let me check the intent. Is the point that capping batch keeps
> > it from taking the faster tiers, so they are left for interactive?
> 
> Yes, basically, that's what I tried to express. Interactive has access
> to all available capacity. Batch only has access to lower tiers.
> 
> > If so, that matches our use case. Latency sensitive workloads get the
> > fast tiers, non-latency sensitive ones get the slow tiers. But...
> > 
> > Even then, the reverse cannot be expressed. A cap only cuts from the top,
> > so a latency sensitive workload given max can still fall back to the slow
> > tiers once the fast ones fill up. For example,
> > 
> >   tier0  tier1  tier2  tier3
> >     0     10     20     30
> > 
> > there is no way to say "use tier0 and tier1, but never fall back to tier2
> > or tier3". To cover that, the interface would also need a min value, or
> > some way to express a range.
> 
> Correct, this isn't covered by the above.
> > And even a range is not enough. Excluding only tier2 leaves a hole in the
> > middle, which no min/max pair can express. That needs per-tier selection,
> > which is what the mask,  and what I'd carry over to the memcg
> > interface later (Currently memcg.swap.tiers.max).
> > 
> > How do you think?
> 
> I think it could help to aggregate the usecases in the cover
> letter. Your cover letter describes how it works, which is great, but
> it would be good to understand better what the constraints are, how it
> fits in with other existing control surface and broader usage models.
> 
> With the above, yes, you can restrict who gets access to the
> privileged tiers top down, but not bottom up. Is that an issue? Keep
> in mind the alternative is cutting privileged groups OFF from certain
> available capacity. This seems somewhat counter-intuitive to me, and
> doesn't reflect a clean privilege hierarchy anymore.

Thanks for the explanation.

I thought about it many times and concluded you are right.
The reason is simple. the two cases the mask can express but prio.max
cannot (holes and bottom-up restriction) are possible with the mask,
but there is no real use case that needs them.

Therefore I see no reason to keep the
mask interface I proposed. prio.max can be extended naturally when needed.

For the record, the interface semantics have evolved as below, and
this discussion changes them once more.

  1. Per-cgroup swap priority for our usecase (initial proposal)
  2. Fixed ordering across cgroups (swap tier concept introduced)
  3. Child tiers as a subset of the parent's (after LPC)
  4. Switch to the memory.swap.tier.max interface
  5. Agreement to add the memcg interface after virtual swap lands
  6. Express tiers by swap priority, proposed as a debugfs interface
     until the memcg interface is added
  7. memory.swap.prio.max: cap the fastest tier a cgroup may use,
     i.e. top-down restriction (this discussion)

I agree with this direction. I'll describe the discussion history and
the resulting constraints more clearly in the cover letter.

Here are the next steps.

  - Change the debugfs interface to take a maximum priority instead
    of a tier mask.
  - Introduce memory.swap.prio.max after virtual swap lands.

Please let me know if you have further comments.

Thanks,
Youngjun
