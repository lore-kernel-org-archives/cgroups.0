Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6651A378824
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 07:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643623; cv=none; b=B4oW85BTdFAkwIYg1u6d5GRaF/buKDs7XN/qu7KXmA2zto98Q18mNjQLYizBqEJQWVVDLlGp5BrB/94BIg/Qkg0ZSmz4VXdVTCU8iDfU0F5wjXv9Yt+aVIivqkIfWPA30bVZLWVqm8sk0ulGuARnzjm5vN3wuDUy/y33RSHsoIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643623; c=relaxed/simple;
	bh=tZJHSLhita37GZE4qEiliq716XxjbQZxZLfaHUeBxsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=je5riKG1212+aOPaP/hi5nMPhii9IaPkhzAQbKZwncGo+jSBgo4J/mZvDdeheA30kfGauZffmU0NIwL2btqjZL6E3gUC3XXi8Q3NCWJU2bGnI/JLzJJTFRu+JveWVAkM4AWBlJfji5jKCZXtbNwUawqGm4ahenLsZDhy3bfvzqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EUYlOulW; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EUYlOulW"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a1a546a6bbso7713675a12.1
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 00:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787643620; x=1788248420; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HvIHRFnGldbLfSeUQWu0/lotI0W1auWfZBfJjbwacgc=;
        b=EUYlOulWc6m7/itZjtlAZdJVn+dL8xlUxJTLw7r3HYQtKBe/qoCwuVfzCUfAJJyYE+
         QoTK0OVCeHeepfYwKBYhoskukutgnL6jEf5+VvYjHWwIlt/7yx01uowAws5OH0iOmg2Z
         FHZdUBD5LqCZ9uYnZEdTRz57vIURCexBIk+mGyZfJlKwl2OnlJ+xbWZX8K5ST/Q73Gk1
         p57rt4BKJ663n/nykOGUC1QDRI+eouMZF0JljR6ZrATFfJ/UaE//8TMayDqtyx4/wJCf
         Z3L5o21Ap+4XkltYyBKmVDS6AlqfGSEXSUpPwYJJDyYHnY6qzp7sVvlQjs0tE992lzqf
         XbWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787643620; x=1788248420;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HvIHRFnGldbLfSeUQWu0/lotI0W1auWfZBfJjbwacgc=;
        b=g1SO8EIned+pYRdnRloIf1M0CG+nRypcjjkEBqtG24E6jokDGSV+iMwcimbgNs9HQN
         sgbQzMJ4W2fszhJIsBH2OrqiU4ao1aTZtG1nuO8SC3Ey4hoDBBkdaEOuR88Bz629U9nz
         hybNp0ft5TMHYxe5Nj+C7d+9/aCe4m2sGa7AnnJdkWrOzRTXabw5VzMccS7exyswScOD
         yEydtrCJWtRTxEO+a9UPVZdhO1mdfuzeEVdOw8Lmx2GemPPZfAZof1YiMGWKccvUEvmw
         fGShOSaeOWetyOhKZBZzdwHNZN0PUW9rbAugA3NaZHy5MsfSVCVgaKFrrgKAaZqua0li
         j5Jg==
X-Forwarded-Encrypted: i=1; AHgh+Rryt2XXy84Dy54J9lUrZzwxVlRha+QSgimAbairMqQuMHXErD8dz40TnPqi9PgAO2qecbOFAxV2@vger.kernel.org
X-Gm-Message-State: AFuF++nv4DXn33FszhGIVUupwIb3KXE7+N4Q5xV8rvYRKIGvjQmJ68Gv
	wt6tsF3iTkk45woWd/hr9IRIBUsEj0WfI9u8NZdHsPXvviWfhalDGm5F+UqwiKR9qDQ=
X-Gm-Gg: AR+sD13BoNJ9JA6pi4nh1ovA8LisaVG7hYJjGNs7X9HI7SjDrpVZOAVFZsaoSLL4NuI
	IKaq5STr7MR2zrMCCNiID8x+T7XeFncs11pgqFQA1YP0ur+9hb/E0ubvrFP9TbJEIgpfHY6MWxr
	Qvb9nkYz906Gtl74zn6VkZjlHTWOuK8y43jvVHXqxn+s4V2Qto0WoFMnpiXKUo5Zr1s6MTYbZ/z
	Zq1OtY09Tb5DrJcVUMtbK3tYvuymHchb3+b3nR5U/uJ0Du8G3969dcvnh7kDbO01nRSJPwDiK4M
	fwmuB0cVVua0U+9j7KEZhMLMUUkskL+Rpj0//K02YpIlMQ6psoHtCuxq7syw8rWv4IWW+6o7lpF
	nK09+PKmDh3/Ch4d9Rq8xebJsFq6gsT2qPyRKGDIRjKcIEakmMqnh76zGUvlAisaGtYdDW8szyN
	cCgiN5A1BMg87Un5+y0h9I2AwwbZ5o6t7jvljO+9UkUMk+iYgY0RduFXaE705DIOc5FwOWLdmXx
	g==
X-Received: by 2002:a17:906:9f8e:b0:c24:b11a:46fc with SMTP id a640c23a62f3a-c24e5be5ae6mr443422266b.22.1787643619483;
        Tue, 25 Aug 2026 00:40:19 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24966f6b48sm1685768466b.33.2026.08.25.00.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 00:40:18 -0700 (PDT)
Date: Tue, 25 Aug 2026 09:40:17 +0200
From: Michal Hocko <mhocko@suse.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao1G4V-MhsjL5Bms@tiehlicka>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aoqbCyX-32doBJwd@kernel.org>
 <aoy88hVQcA6Gkfuk@echanude-thinkpadx1carbongen13.rmtusma.csb>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoy88hVQcA6Gkfuk@echanude-thinkpadx1carbongen13.rmtusma.csb>

On Mon 24-08-26 17:58:49, Eric Chanudet wrote:
> On Sun, Aug 23, 2026 at 10:02:35AM +0300, Mike Rapoport wrote:
[...]
> > CI found issues:
> >  
> > https://github.com/linux-mm/linux-mm/actions/runs/32519133924
> 
> Indeed my apologies, I messed up CMA=n it needed a forward declaration
> and gating for mm/cma.h content included in mm/memcontrol.c.
> 
> I queued this up for a v2, with the other issues reported by Sashiko.

Let's focus on the highlevel design and usecase disussion first before
you start chasing specific implementation details.

-- 
Michal Hocko
SUSE Labs
