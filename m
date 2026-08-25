Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A77C35E1A2
	for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 18:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787682835; cv=none; b=C2+bi7BCtod4MYD/6Ae+WmF1X2vBn5O7yKJ8DXYnWhajgokM1/18D8RWcSxEVV38XMAWM9rmxKMn8LfDPgyTaKSGxOyYSvXDFIcClC8kUTUh0IWPMVJXe0h7jTTlQg1XjbElTw3xzCNV1Lz3cJlwfIeq4b0CCwSixXm8OCtFtmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787682835; c=relaxed/simple;
	bh=oz1vsSfhnzHKzMyvIU1457fQ+VKFGoaSC1MKlUjtQH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lSeND3PCXn2UIvzvN1QJ9QKeq6OEWivnN3jRviJQwyCUt5pt1BtSb+0u0bY0o5UTh8rTRma17gIEbJMIy5t8yutEGvhIpawDkIv4zsOEavZL/l8pVjUJa37BbUbfuKR80zlm3oGna5dPeqqkiuCAwmtVfz9TvRyNmr65cDgisKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W/8SbrF7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jzRQFdKS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W/8SbrF7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jzRQFdKS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787682833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ezRFPRBsxOpDYy/LiqFi78+AQBRMUReYJkZLlaNR3K4=;
	b=W/8SbrF75mz/Zn8oWiVac3ovOvThYS7LcQubf1KhZG0A30B9KAJFWsL88sXa8nm27Dnh4J
	wtFz4ORgbPryd7MPozFPaY1ggjlUgt5Z7fGWDI7pGPf80DSeT1qXHO4n03ByTWdR2SpR5x
	Z6aGrhXJxyl8+rqRR2eqJk12Ye49lyE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-vnqEqZs2NCKTOk4FCsfaUA-1; Tue, 25 Aug 2026 14:33:51 -0400
X-MC-Unique: vnqEqZs2NCKTOk4FCsfaUA-1
X-Mimecast-MFC-AGG-ID: vnqEqZs2NCKTOk4FCsfaUA_1787682831
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-907c59bd73bso2243276d6.3
        for <cgroups@vger.kernel.org>; Tue, 25 Aug 2026 11:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787682831; x=1788287631; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ezRFPRBsxOpDYy/LiqFi78+AQBRMUReYJkZLlaNR3K4=;
        b=jzRQFdKSWJtzGdyzwv0exG9iaPgnI2K8a/EAGci9as+f6G19LBrW5M7APdAFNEeXcV
         rlEJjhQZRH9s/5Pk/pfggSnebigCMW952giqJy7uj80ouy7dxDf3WuFjj7RuHzDjR5Xy
         Svncfo4f6Z77AeBkNsWFkZIQyDMruBFb3Ogw4/XS9nyEjXVgRWdj8/vArFsXn/OtYATU
         nAPsqsT22BOiiy9MQdrrwOySX+SCxSkoJWyVBiHplTZL3ayRwBlfj06m3rFhgv2TDC0a
         hcnanWYaH3vrZjyEejpPuIfKJmGjocLmSZke7Qpy2TeQX9YisjxeAi69VFld64dG5FVF
         I5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787682831; x=1788287631;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ezRFPRBsxOpDYy/LiqFi78+AQBRMUReYJkZLlaNR3K4=;
        b=BrUD95t5vLyPP1W5laCiVI+tkOzehktqRGSGd6De0fe/1rYcOr0xStmrSw1Xe5qvR6
         w+3vA/mAt80N3tpREDqQXrbgaStyyhyLhQMx6za7C0+QQNzrdZuKcxWYY03hSUBeaEXn
         ydkggd3+unultPwpaeisTAII1BdEPf43R8J8udQQ5A9QlFTNqewX5RTQRkXCwKd2WJ/I
         yz4JxUUB6MCBZI3cznKJsrScefcNnLEJmd8ePEsGQb7FIaRvL53aX8dFoYP5cQpGG0/U
         CQad9OZIPTsQQhExM4Vsfvcf46jS69RfVlm+tbEIyhtI9S5/9qEiYY6uluvKuAUn901e
         oeGw==
X-Forwarded-Encrypted: i=1; AHgh+Ro9YZlpIv2H17r84DbMRu0iKofyEzmd6eIOon3Hkb9A0Tt0FgeWacd0EisaZ1u5+4DMzP+sm6R7@vger.kernel.org
X-Gm-Message-State: AFuF++kP4uGcUXUsBThDKetYphqXi5vzO+ElhhleGAx3YfFnwgtMecfJ
	zmpGr8bmSY6Bvil669oaFOFZktBhH6IMTN32KDKUHLKSN5D02CaqeqN4n17wpijV/+gAj8VMlty
	3Vhz89UWpTK/JsV7STxXHUqdySr8x2lqkmLlfggx3Iw604ivnZfZ9pZ5tAhI=
X-Gm-Gg: AR+sD12cOz5HMZyeduWXE76yUvvNDr0HyTlLidljC/ScTqOytnejmDyGNaE6sqgbNhC
	QMoalv8jn954ls4fNAwoJkZp1zbeULtLEV+rDNGgpN1jT4ACuSdyi3PiD5tbTGGQAwiKOfV00Mm
	ZJ1BjSxkh4nm8nno2r0lFud90e7fR8eLVQJCQhTDQblXCLN3O860xAd1YX6063axZKsBca8JEdK
	8SBQiNrmwEx9kk4+PM7Afz8sXw7SYyPoxR+WtF1XV08iHdWftZi+jbvMwJlSBO1JNvigxKdhiks
	i+Kvaup1vD5Fm1hK6u/fIRvs7KqP7bez/CHWRTDHLZBDn1QyMUI9T3Rn8tRJUNBOuNnoqaBMdTs
	yXRhXfLnktetY6UDtesBGzRpZ3AGfbeNMCY3fzdiVnUN8
X-Received: by 2002:a05:6214:469d:b0:90a:4361:9c4f with SMTP id 6a1803df08f44-90cc790aa6cmr10048476d6.1.1787682831095;
        Tue, 25 Aug 2026 11:33:51 -0700 (PDT)
X-Received: by 2002:a05:6214:469d:b0:90a:4361:9c4f with SMTP id 6a1803df08f44-90cc790aa6cmr10046546d6.1.1787682830292;
        Tue, 25 Aug 2026 11:33:50 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc65093d5sm4901706d6.26.2026.08.25.11.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 11:33:49 -0700 (PDT)
Date: Tue, 25 Aug 2026 14:33:48 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao2t6HP-Zt5KDg30@tiehlicka>

On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> On Tue 25-08-26 10:47:53, Eric Chanudet wrote:
> > On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> > > On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > > > CMA allocations are currently unaccounted for by cgroup memory
> > > > controllers. As system resources, they should fall under memcg, but CMA
> > > > areas partition the available space for different purposes and memcg
> > > > doesn't have a good representation for that.
> > > 
> > > Which CMA usecases are covered by this work? It would be also great to
> > > spend more time describing usecases.
> > 
> > We would like to offer some usage guaranties to userspace processes
> > ending up doing allocations in CMA.
> > 
> > For example, a shared CMA area is described in device-tree for an ARM64
> > platforms. Userspace components could then, for example, allocate from
> > it through the dmabuf heap, or a device or framework-specific ioctl for
> > that matter, to use the buffer with sensors. The dtb may have other CMA
> > areas described additionally that may or may not be used by that
> > component. In this context, we would like the ability to limit one of
> > the userspace component to over-allocate and choke the other(s).
> 
> How exactly is this supposed to work? How is the CMA access controled
> and opted in for accounting. What happens when memcg limits are hit. And
> many more details, please.
> 

The administrator opts in by mounting cgroupfs with
memory_cma_accounting. At which point the cma allocator will charge CMA
allocations against memcg and manages a per area counter depending on
what area the allocation was made into.

Assuming memory_cma_accounting is set, if a non-root cgroup makes a CMA
allocation over either memcg's max limit or the per-area limit set by
the admin, the allocation fails with ENOMEM.

If memory_cma_accounting is dynamically unset, no the CMA allocator no
longer issues charges. Whatever was already charged can be uncharged
when it gets released.

It looked consistent to use memcg since movable pages from regular
allocations may end up in available CMA regions until a CMA allocation
needs the space and has them moved. So in an extreme case, hogging the
CMA space of a large enough area could trigger system memory pressure.

> > memcg
> > looked like a good fit to achieve this, albeit handling the areas, so a
> > cgroup has a quota in a given CMA resource.
> 
> Please expand more on why do you think this fits into the memcg model.
> AFAIU we are talking about a unreclaimable memory and reservations of
> CMA areas.

Since memcg already accounts for some unreclaimable memory (kmem,
hugetlb), or induces failure if no reclamation is possible, I did not
see CMA allocations being unreclaimable to be a blocker to track what is
otherwise system memory.

I viewed pages allocated in CMA as guarantying special properties while
being otherwise similar to pages already accounted in memcg to the point
that charging them against memcg made more sense than having an entirely
different pool. I can see how that could be the other way around though,
especially with the per area counters, like how hugetlb have their own
controller.

> > This trails from an earlier post where we tried doing this using
> > dmem[1], but I was unable to reconcile the requirement for memcg
> > accounting[2] since from dmem I didn't have memory objects to charge nor
> > the guaranty there was one. Given CMA is always system memory, it looked
> > like a better fit to try something without dmem.
> > 
> > Best,
> > 
> > [1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
> > [2] https://lore.kernel.org/all/ahB7pCu_G4vuswc0@linux.dev/
> > 
> > > -- 
> > > Michal Hocko
> > > SUSE Labs
> > > 
> > 
> > -- 
> > Eric Chanudet
> 
> -- 
> Michal Hocko
> SUSE Labs
> 

-- 
Eric Chanudet

