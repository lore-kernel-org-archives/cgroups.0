Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FC629B8DB
	for <cgroups@vger.kernel.org>; Tue, 17 Feb 2026 18:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771354376; cv=none; b=rrdywtt2Gj12+IDF3feYDAloEhiyyHqlF6+mLdVeSH9Thi7C8C43th5xj5IQCSAqN/lOkcbMY8765alHKTcTBSAnqKCeZfjG9EM8BwdiIxJTodWSUBrzv7xXSSjbnjDtD7YCDXe72A2IuyziFQi5TIoT6/9gV/o4KbG2MN3cmfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771354376; c=relaxed/simple;
	bh=3ehpeb06kDgzJNWm4laQeCVtUuswr0jIzd35eu4fzxg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9lnIji+ZNaSgOgxr9qjlIFZbhQ29ST5LR6w4dCGPmaJyVnNPBQ4tQNYvomUYItkom8eUwOGqdysbkuYi6WoPWj1hecGDB6pyIq/dPwaR8HQhlz3t5gKk/z2l7xxjSjoMbegnRi8IQFDZwqqn2Ec3Slp8qaY4Z+RWFBjOPE1y/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=USP80Ryk; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="USP80Ryk"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-4833115090dso41043025e9.3
        for <cgroups@vger.kernel.org>; Tue, 17 Feb 2026 10:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771354371; x=1771959171; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x46hiGoEyZZRfdFs36nFSz1+AdsW3p14nQ3Wm2zf6Qc=;
        b=USP80RykKT51B8nu0jWR04pW5k2RSVjQkV88pDPHd/3jSU6BT04hV1ht8fv9vvVB9t
         AgBv+rLoQPnKLD9ha6ob4u71s9BR1HSG9QJShr8JewP2P4VPKAqBJ4TX79pwguD9IU5o
         /d2z8m1y7EpEIIQRoy2hIbtdFKJP740x+7gTpZTp4lXPU1NWI/OgKu3LqcLsT32BAKLr
         Q7/u62DwaxJiMcFDPheitedzi0r9VkrRczSIloA7ZS1tfH0z2v5VX1zzHLEE/3aKcElO
         qjKpflIRXOLVSrnngU1NKinUioIzwSiZY1LbEpwfXe+HyZm/3DQaK0asCUPK2iDzi3TP
         Y9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771354371; x=1771959171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x46hiGoEyZZRfdFs36nFSz1+AdsW3p14nQ3Wm2zf6Qc=;
        b=mSY2QOz0389b4FIUAwLZvDLqXG/XpR12/ej28W5ucldlfaRcXK3IaUPaxOCyRjR40t
         IfT+ByhzFIUrv913bHvJn+M7z0Tf9PFyFksXRI7fdfGiEUA02CLnOFGPQNnsFDeT09CG
         t849GOnn4T/4D5C3jQfD1cgvD6sx1PB6bwI9NWmzLJQhfx7cH+mxHx+G3mrQE0DYtV38
         xxGegYpqgZKqmQoJeGamaiU/a9jTxmlEQ6+zzF7X3hhcoK4tGXCzJ04O3wdsarMp2gOL
         Z5923YHTXXjhF2qVkLF0xnSeG+7x1YwGT46Nn3pbKS5or1wPNDLmrtHbdm80XOO3D1zy
         q4cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXk6YNcbIQFeymzcuvC/1NeGzISPiZQ5lYQwy+l9Xds6001FmP1ehXc0LzUoHNH96nIwN7fDd00@vger.kernel.org
X-Gm-Message-State: AOJu0YwDhY8YDles5gGx9JnkzdIqVi/Ckihv9PUPqNw1P394Rvs6X9z7
	icGZpo6JQgyLXALCa12Ifel0cPuwuiK/tMZ5KpRFSvA5EXXWUAuvteCpByTpPkg8e/Q=
X-Gm-Gg: AZuq6aLUMggy/thPs/FztCgmNiFKvrnPg354T7wswbv7LbAfQ0c3qzzauKwjtTKnISv
	sbayKa4uQce9NPiDRz+6AtuhKkUjeRnlM8r3PETX8Gx/HLZjWKyh8Ami8I+w7eRria6AY6sQ4G7
	KLG2sb9U6JM8qBBXqM9KDcxUahQF5HpwbfQvvhnXxwNsMbQ7ofcT1DijRVANM4R/pUzikHWl6rQ
	o4iDVloTPGCk4AR2AdG79qqKtVlYqrJ0knP7nIEkMjWw2PHcqZyHYKu6qFGJvyLRwunegQUYoTG
	6vakq31aSjCU/eLguQu/x2i/eH3p9Ou0HoUZIYfk/o7ANHHzNKpxuba1WlEaMQDqsdnoT1bc/8x
	05gF3e5CtADRHi7wELI++2Q2k7tWpSL68lmksT8O2iGLDz9fsDLd8QqOkZ6x5tqjYw9S243nZsw
	INYQD9ZY8VuUzPu6d8tM93CiKWkBtuGGZAxvm3
X-Received: by 2002:a05:6000:1acc:b0:437:678b:83c2 with SMTP id ffacd0b85a97d-4379793eddamr28020353f8f.54.1771354371131;
        Tue, 17 Feb 2026 10:52:51 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796acf5b9sm34218187f8f.34.2026.02.17.10.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 10:52:50 -0800 (PST)
Date: Tue, 17 Feb 2026 19:52:49 +0100
From: Michal Hocko <mhocko@suse.com>
To: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aZS5AY5bnPjAmgN1@tiehlicka>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
 <aY2BcIHIARSwwQpo@tiehlicka>
 <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com>
 <aZLUm95Y-dKkdBWI@tiehlicka>
 <3fe7c5dd-b184-4421-a21c-bafce6aa7b09@gmail.com>
 <aZOHIQj3pJ-9dW_0@tiehlicka>
 <9ae80317-f005-474c-9da1-95462138f3c6@gmail.com>
 <aZRg_ZSDkbGWv7Vq@tiehlicka>
 <c71f5dc7-d337-4510-96c4-38a83fca29ef@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c71f5dc7-d337-4510-96c4-38a83fca29ef@gmail.com>

On Tue 17-02-26 10:19:08, JP Kobryn (Meta) wrote:
> On 2/17/26 4:37 AM, Michal Hocko wrote:
> > On Mon 16-02-26 23:48:42, JP Kobryn (Meta) wrote:
> > > On 2/16/26 1:07 PM, Michal Hocko wrote:
> > [...]
> > > > [*] btw. I believe you misaccount MPOL_LOCAL because you attribute the
> > > > target node even when the allocation is from a remote node from the
> > > > "local" POV.
> > > 
> > > It's a good point. The accounting as a result of fallback cases
> > > shouldn't detract from an investigation though. We're interested in the
> > > node(s) under pressure so the relatively few fallback allocations would
> > > land on nodes that are not under pressure and could be viewed as
> > > acceptable noise.
> > 
> > This is really confusing. You simply have no means to tell the
> > difference between the requested node and the real node used so you
> > cannot really say whether the memory pressure is because of fallbacks or
> > your mempolicy configurations. That means that you cannot tell the
> > difference between the source of the pressure and victim of that
> > pressure.
> 
> What if I excluded the fallback cases? I could get the actual node from
> the allocated page and compare against the requested node or node mask.

I think it would make sense to send the per-node reclaim stats
separately as there doesn't seem to be any dispute about that.

For mempolicy stats try to define semantic for each mempolicy first.
What exactly do you miss from existing numa_*?
Do you want to count number of requests/successes. Do you want to track
failures? In what kind of granularity (track fallback nodes)?

-- 
Michal Hocko
SUSE Labs
