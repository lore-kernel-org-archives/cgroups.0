Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F9139EF12
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785353794; cv=none; b=umR81noYO6Kxn0VSDkQh2u5GA/iRjzZcA+z1ywY+3XxVAn1OPiVei9QptU8HIkesy6U2uq7lWyv7OJgozRRcN2xHxqUwLDMaPkXkwTCTNCdLvtQ9iyp83DXbmg7W1MbJvqYx6hxhT2FEXerIVpd5hLLPX2cgJZzr3r+qfKxAQ5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785353794; c=relaxed/simple;
	bh=QhXxzcZQQJSceml1UPzDn3CIyRDudke50j/KDUb9bgs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRGjZQCwCcR7z60a1Pd2fU+mTSTIrifTz6W1sW4vtCkEnXSRXZBL/23wgEBWKTliOm84bJFdSLsmrPvnvJhQxfeVRyNHfjSCPrfWyLijHx/i2CLLJQsZlST1g5GEvoyX64pUAQRGrM3mafZ7eJTkR+kNusspzLaRjG5x5oqLoO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=Sei55sEf; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="Sei55sEf"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c2808dbc3so8936181cf.1
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 12:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785353790; x=1785958590; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YFlfsyL868lT/j3agJwNORpNx5tokno15i4G5m1Hupc=;
        b=Sei55sEfJ4MBMjvAjR0CD/ghrZG6hKIPAwn+uXJA/q6lrbBFOH/aK5yNX53wFr26W+
         ATXBTBFvZghntXcKWyYS3YGv4v9BvSf+v/CDU1hQqEEFkCABw/5TVo6WkvhhAOEGNaxw
         m5oq9ai9smgvlzzkMM/GhdObu06WOYcqoenQnPArfYrcyVpH2qtSgS3KgxgjIouAaBSz
         XAxNZfiPdvV9c25pDRKEXRnDJQq7dupSw7BJlEipgmmvkGXbBo2FQnVWn1+s1olz275P
         az3LpkcE9Ed3mb8trDMTYZQNwOQLPrdo62mJT+eRHAMqetw9p6ZaWlVAifFrJ7GUfIUX
         xwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353790; x=1785958590;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YFlfsyL868lT/j3agJwNORpNx5tokno15i4G5m1Hupc=;
        b=WPbOGvcrH3VyO4AjnW7lHrV3zwMcYKrQWt7aY2JY+AVk/9IT22VBTE/j6OcuaYwZmB
         A/UaLw/UybesO3xCBOsGB52z/txDsDuyzxvJ+PQody/YBHSCVRRqjnrhhdVVx+kts3Dz
         5R0IzaWTgM4hYLFAD7PjzSdE4RnNzyG2lwFrJS4GX6l5SCSm+9YOU/SH6lwV1SIEaXQ8
         cmNZKPCgYUxQcuLZGj1B0kMrFL8bZnpdIMRgmeYbpIuTxPNq9vZK+OOrP04sJzfx2Of4
         tf6XQXp1RtLo+z1J84OKiGgyrgcRuqy7aLhVPc8k4Cxzv2igkNC3sKO4WFyHBNP1lHDu
         Su/w==
X-Forwarded-Encrypted: i=1; AHgh+Rpz8PosoOKPTZBWtRjDgZqKy+b8TG+tHCm+YKEq3UKh5iPxrSu9MjdoEBb2UGMDbRVbD0scj1i/@vger.kernel.org
X-Gm-Message-State: AOJu0YyR2pN5XDFrDSj/sQdn6mCsLtTXwEFmrWjx/vnIrZnFHTzQvBJO
	BbCSwvzqYBNcydzKhRn5VmAxgMSAmAWBXPUiXI6Tyg//HcAxULnZSTbPwP8WvVSYRUKm6NmYiOu
	2NZ4e
X-Gm-Gg: AR+sD13/Ee6RFMnFCPVtr8RkPi7htSiHNbRgzf5qIB6nV1X92lSi17ROAAaS1jWnaib
	0krkNC+RjscAJY2zEN8n1r4J2AvV9Z7HMkp15CuvbrrQxKQW4X2r3HlOR75JCIRPMMNQVLFzsEz
	iaAAJfxbfdyitRr50vE/nbn07Wxqb/WDapSioLsN6UOjBSLm5FXT98GZQ5H7sFx8DrSU2hAE4ra
	kQQa2a/QIZbExiynEJRIdZGGFBSYOfb1yZ9Bhq3iIl+Y8GNXMKQUF7um/14HDajJ4pn1GdkmMtK
	ryeqX8+LF3/AeyHIuPwZJf2+mLiRN4mG9xJXXoXRXFRSVbO8LAKrvSszC+wV5KWup7LBVSOTqJS
	b6rkFRs9Zzy9sKfpgxNcWj3EyIiEBmMYBO5QEBPL37qTMTAj1SPB1M/14a7TfbsKGj2H0Y5w31S
	VpRQaPZ33rhGXCWw+VkenfijH0qpfRxhgfhdUM49qLV1EfSFQd0NzoAIIrgYg=
X-Received: by 2002:a05:622a:1ba2:b0:528:15e:d1d4 with SMTP id d75a77b69052e-529d709c7bdmr77022001cf.4.1785353790549;
        Wed, 29 Jul 2026 12:36:30 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529e2b1a1ddsm25903541cf.5.2026.07.29.12.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:36:29 -0700 (PDT)
Date: Wed, 29 Jul 2026 15:36:28 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Guopeng Zhang <guopeng.zhang@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
Message-ID: <ampWPFfbz5zvmFys@cmpxchg.org>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <amcT75pLmA0hRUm1@tiehlicka>
 <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
 <amdkHvSMj95DUri5@tiehlicka>
 <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
 <ammzjkUIADCxO2mP@tiehlicka>
 <20260729121137.7b451d2d00ca5a389ebeb848@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729121137.7b451d2d00ca5a389ebeb848@linux-foundation.org>

On Wed, Jul 29, 2026 at 12:11:37PM -0700, Andrew Morton wrote:
> On Wed, 29 Jul 2026 10:02:22 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > > Is this trying to replicate any real workload? One would expect that
> > > > writers to limit do some sort of coordination otherwise the exact
> > > > behavior is not really well defined.
> > > > 
> > > 
> > > No, this was not motivated by a reported production workload. We found
> > > it through automated randomized testing for our cgroup observability
> > > work and reduced it to the reproducer above.
> > 
> > This is an important detail to be mentioned in the changelog. Describing
> > motivation for a change is really important, especially if it has direct
> > impact in user interface behavior.
> 
> I've been adding details to the changelog as they are revealed to us. 
> Below is the state of play.
> 
> I await maintainer guidance on how to proceed with this!
> 
> The worst-case effects look pretty bad actually.  Should I add cc:stable?
> 
> 
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Subject: mm: memcg: stop reclaim when a limit update is superseded
> Date: Fri, 24 Jul 2026 10:18:05 +0800
> 
> kernfs serializes file operations only per open file, so separate open
> files can update the same memory.high or memory.max file concurrently. 
> Both handlers store the new limit before synchronous reclaim, but continue
> to use the writer's local target in the reclaim loop.  If another writer
> raises or removes the limit, the first writer can continue reclaiming
> toward a stale target.
> 
> For memory.max, this can leave the writer looping indefinitely once
> reclaim retries are exhausted.  The OOM path sees sufficient margin under
> the current limit and returns true without killing, while the writer still
> compares usage against its stale target and records another OOM event.
> 
> Check the current limit at the start of each reclaim iteration and stop if
> it no longer matches the writer's target.
> 
> Reproducer:
> 
> Populate a cgroup with anonymous memory and disable swapping.  Lower
> memory.max from one open file, then restore it to "max" through another
> open file after the new limit becomes visible.
> 
> Without the patch, the first writer remains blocked and repeatedly
> increments the OOM event counter.  With the patch, it returns normally.
> 
> This was not motivated by a reported production workload.  We found it
> through automated randomized testing for our cgroup observability work
> and reduced it to the reproducer above.
> 
> Link: https://lore.kernel.org/20260724021805.1234583-1-guopeng.zhang@linux.dev
> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Acked-by: Tao Cui <cuitao@kylinos.cn>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This looks good to me. If the culprits had been more recent, it might
have made sense to split this in two, one for each Fixes. But it's 4.6
and 5.5, so I'd assume any still alive backport target would want them
both at this point anyway.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
