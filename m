Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350EA30C179
	for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 20:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787776323; cv=none; b=Ix2wJRnVSD+B2KHqSfFVxYZyvH3ucoRhSnUmme4CV/Dl+LDZAop64yWOIdRPRnFbn03Owu71Vuj3YfXoq8C9T/bHWwcY+aIACXrhOGSFepDy79okBK9lGtHabjLTqMgWOcMnyyD+eBrUQRSrdN4deUTEWxUJdRpDLsBdK/gLk1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787776323; c=relaxed/simple;
	bh=djfsCQK+G5XbvfdJNJERVRz2CbHGho4YqI1eV0BksKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OobNjuGBeGUMVdvm2OHzQrxDETUFYWAAf3kT8OnmLXT4ju+usGstwdnGNCLZOClBbwXA2mHHx8AYmVLqd/7shq2uFU9Izq8EYFWgwFtY5IciNsDp/HhEADT82/3ZPHA8NC6+R4Ir5epv1GoZ4vndPkrZnP/mHV8EErxjdORgIRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CUekZBGu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJ5JI8Lf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CUekZBGu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJ5JI8Lf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787776321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YpcUluZmeNlEB/De7gKA8OsQpvEQvUU+qqs19ZSEzKo=;
	b=CUekZBGugW/xzLIHzYTByU9w7pos8//2S9YOMCPtpV5EPqCSwipe7CY7wREc8Q+4mHJaLq
	mCpM21zxooUFxIeI5CEuVo74PLP/6ZHK/6ZRKMhm3mXkZcabTac87pMaALS64lbrrJfcBn
	YI7hY/2BeAZejVseQKDZ2gPOvlOkNlQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-w0twyJ-PMdK8GQzbpwSgeA-1; Wed, 26 Aug 2026 16:31:59 -0400
X-MC-Unique: w0twyJ-PMdK8GQzbpwSgeA-1
X-Mimecast-MFC-AGG-ID: w0twyJ-PMdK8GQzbpwSgeA_1787776319
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90a602a4e6fso29316976d6.1
        for <cgroups@vger.kernel.org>; Wed, 26 Aug 2026 13:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787776319; x=1788381119; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YpcUluZmeNlEB/De7gKA8OsQpvEQvUU+qqs19ZSEzKo=;
        b=aJ5JI8LfOItjh8VPrWS9UKAnwSCTR919fPF6SNFviMfc7sjBMC5eo6Ym3RYldqBn4P
         C97I8afUMf4gL9NJvieaPeOsloeH3peuKsGj4ys0RFid/AhUveE4adMQ6e/w5ClNwnlO
         SB9v+u28QORPl4Ewnry7OZ3/tptDStjCUc8KSGE4UA9BgWu9kJwhaqtvcRIdCDZk4jDE
         W7WLFmaN3s+i6YWtgComnIzSr7QBS/fpPTvEgWQyYaAmlvXPXRP+x0o7E50TRDPWWGHg
         sVrgvFFL04ETwgKHeXoDGXNaDbAGDQXAzUWGaMbNhyFOCYrbK+BS0Eg4gvCipVTP0+P7
         7FOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787776319; x=1788381119;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YpcUluZmeNlEB/De7gKA8OsQpvEQvUU+qqs19ZSEzKo=;
        b=FM10lglxvYv+oOtEBL05Ly1F6CMj5EqBWhMLgYbuCmnOC6bW2DF0jSKth5XQUqXA0o
         TqJ1HXq/5pxdQj1ptaaVsoPYISCgA9WN2bvSN/VjTX0Wbw3K2jD8Zv63ve3nZ42wLtcU
         NPNWQZhWN3YzH/TFAnTmmkTuTn493eLI474JWt6bdP4dlmHkRMDPaMp3gGngmr8RBPoN
         t2YZF98EAxNDx6ZoNVsRgWybZNAFz0NNI3biHSdadOC27LVh2EIsLhAqOu3jIglDxXpJ
         L8XoPBf2DLLFVKqr4MF9mWbeZOrFG3x4ud/Pcn/h/1G/pdwyOFLOzS6bYXCeXqC4vb1h
         doRQ==
X-Forwarded-Encrypted: i=1; AHgh+RrsAjMN5JBg8JFfzx+PqI2Qv12xnhr//7GWrJynM/dtawT1nWfCKHpnUF5qRlgVfaB1vJGMq7/F@vger.kernel.org
X-Gm-Message-State: AFuF++kZXZMw3B0vYs73GGPnYq74KQAJ/z0DnWrD7feYFhBp8NHAKOKN
	oKleLOYnPKGvd6tWZ2FGpmh/+0r+Nr54TgOtkg0kvsGk7TuomXy7hGtW4/jZo38EdkDtv9ZABkb
	t6ijEE+gbAGLZK6vSAsoLzzMfunPbtTNmioy4v+dyC+SxbbJxhmJDP9nSbTE=
X-Gm-Gg: AR+sD11pSrHtoUZ5/+qiZu0+76jramAKqtsXnJhGfIqmjYoBt882uZaKODQIcPmzF+h
	/YrDanW17+jzC/gOaol9W3R5MXzf3m0xFH2g0LcXz/e8SlU/Lsm9wOz34vJT96B556MzHdNm0OE
	xmuyoSAlmUTdQ7nu3o4l9Zwehe/VCBLG0giqtJ4bEGWAPvn9RotIXii7bY210JMQl2pcRBeWDOY
	TQGVmqvOxJ5BoLu+2lWTO0vuAgk7hKluZlmx82erMBLyCxMX+DuhtU85CdNRUqGBD4RFZcPafqt
	P1ImPhaf26eMerrTXWokia8EY12FuOa/3ufUctfwSSKMN5cl07sCaknok0UNqVEJHvW5hJVboVF
	ImW40jQTkA2zADkrwPJC268JHGRgO1mFnZXMsEaRImEZT
X-Received: by 2002:a05:6214:1cc8:b0:908:a729:73bf with SMTP id 6a1803df08f44-90cc792fe20mr112761416d6.22.1787776319032;
        Wed, 26 Aug 2026 13:31:59 -0700 (PDT)
X-Received: by 2002:a05:6214:1cc8:b0:908:a729:73bf with SMTP id 6a1803df08f44-90cc792fe20mr112760516d6.22.1787776318384;
        Wed, 26 Aug 2026 13:31:58 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc63bcec2sm36143716d6.5.2026.08.26.13.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 13:31:57 -0700 (PDT)
Date: Wed, 26 Aug 2026 16:31:56 -0400
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
Message-ID: <ao8uZ0cNyqaAJuPB@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
 <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao2t6HP-Zt5KDg30@tiehlicka>
 <ao3UKM5SbxBmxuR0@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao3quaSze8YjPjxZ@tiehlicka>
 <ao3tFg4JLNlbylTR@echanude-thinkpadx1carbongen13.rmtusma.csb>
 <ao6eC2SUIGVz3Qct@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao6eC2SUIGVz3Qct@tiehlicka>

On Wed, Aug 26, 2026 at 10:04:27AM +0200, Michal Hocko wrote:
> On Tue 25-08-26 16:58:51, Eric Chanudet wrote:
> > On Tue, Aug 25, 2026 at 09:19:21PM +0200, Michal Hocko wrote:
> > > On Tue 25-08-26 14:33:48, Eric Chanudet wrote:
> > > > On Tue, Aug 25, 2026 at 04:59:52PM +0200, Michal Hocko wrote:
> > > > [...]
> > > > The administrator opts in by mounting cgroupfs with
> > > > memory_cma_accounting. At which point the cma allocator will charge CMA
> > > > allocations against memcg and manages a per area counter depending on
> > > > what area the allocation was made into.
> > > 
> > > So each CMA area will have its own counter and limits?
> > 
> > Yes, in order to enforce a limit per CMA area this series add a page
> > counter for each area. Areas are fixed and discovered early so the
> > counters are added to struct mem_cgroup and initialized when the cgroup
> > is created.
> > 
> > An admin would then use the cgroupfs entries to assign an area limit to
> > a given cgroup, something like the following, using the reserved area
> > for example:
> >   mount -o remount,memory_cma_accounting /sys/fs/cgroup
> >   echo +memory > /sys/fs/cgroup/cgroup.subtree_control
> >   mkdir /sys/fs/cgroup/mycg
> >   echo 16M > /sys/fs/cgroup/mycg/memory.cma.reserved.max
> >   echo 64M > /sys/fs/cgroup/mycg/memory.max
> 
> OK, thanks for the clarification. This confirms my initial suspicion but
> it is better to have it clearly articulated. I can see several problems
> with this approach. First and formost I do not think dealing with all
> cmas this way is manageable. This can become a mess very quickly if we
> have one limit per cma and too coarse if there is a single one. I also
> have my doubts about space allocation control through a simple limit for
> something that is effectively a reserved physical space.
> 
> I might be proven wrong but unless cma serves objects of a uniform
> size then this will simply not work in practice. Hitting ENOSPC without
> hitting limits and thus impractical for shared space management.

Isn't that an inherent limit with CMA as it is? If the area gets
fragmented, some buffers may no longer be allocated since there is no
remaining hole big enough to accommodate them? I do hear that putting
arbitrary limits would make this worse, which might breach the threshold
at which it becomes a problem.

> 
> [...]
> 
> > > > It looked consistent to use memcg since movable pages from regular
> > > > allocations may end up in available CMA regions until a CMA allocation
> > > > needs the space and has them moved. So in an extreme case, hogging the
> > > > CMA space of a large enough area could trigger system memory pressure.
> > > 
> > > I really do not understand what you mean here. 
> > 
> > Non-CMA allocations can end up in CMA physical regions when necessary
> > (ALLOC_CMA flag).
> 
> Correct. But those are a subject of migration so any such placement
> should not be blocking real CMA allocations.
> 
> > Since both CMA allocations and other system
> > allocations are represented the same way, with differences only in
> > properties, and they can live in the same regions, it sounds reasonable
> > to account for both under the same counter.
> 
> From the memcg POV we do account physically consumed memory. So yes,
> it makes no difference where the memory comes from. We only care about
> the overall capacity you can constrain or protect. Generally speaking it
> makes sense to charge heavy memory consumers directly triggerable from
> the userspace.
> 
> That is all memcg can provide you with. Specific requirements for
> specific types of memory is a different story. We currently cannot
> control per-numa node for example. There is an ongoing work to make
> memcg memory tier aware. 
> 
> > > > > > memcg looked like a good fit to achieve this, albeit
> > > > > > handling the areas, so a cgroup has a quota in a given CMA
> > > > > > resource.
> > > > > 
> > > > > Please expand more on why do you think this fits into the memcg model.
> > > > > AFAIU we are talking about a unreclaimable memory and reservations of
> > > > > CMA areas.
> > > > 
> > > > Since memcg already accounts for some unreclaimable memory (kmem,
> > > > hugetlb),
> > > 
> > > hugetlb pages have their own controller
> > > 
> > > > or induces failure if no reclamation is possible, I did not
> > > > see CMA allocations being unreclaimable to be a blocker to track what is
> > > > otherwise system memory.
> > > 
> > > yes, we can have unreclaimable memory charged to memcg, that is not a
> > > real problem. We have all sorts of memory consumers that need to be
> > > capped charged to the memcg. If dmabufs are another ones then fine, just
> > > charge allocated pages from the cma area. It is the "make all cma users
> > > memcg aware and have per cma limits" that I am really struggling with.
> > 
> > CMA is system memory independently from its usage though, and in cases
> > with shared CMA areas multiple users can allocate from them. Yet the
> > kernel cannot enforce usage limits.
> 
> Correct. Those are effectively a shared memory pools without any
> control. I do not think memcg is a good method to enfore any usage
> limits for that though for reasons mentioned above. Memcg is effective
> at capping the overall memory consumption of a workload. Not really
> great when it comes to a specific memory pool control.

Understood, that makes sense, and with the reclaim scenario mentioned
earlier, it doesn't fit.

> > > You cannot really assume usecase, requirements, lifetime etc. for an
> > > arbitrary cma area. I do not think this is a viable way forward. Focus
> > > on your real usecase, which seems to be dmabufs.
> > 
> > While dmabufs are indeed my main use case, they are quite generic and
> > may not always have system memory backing them (device memory). Working
> > at the CMA allocator alleviated these disparities.
> > 
> > > Explain what do you want to achieve and then we can think whether memcg
> > > is the right model for that usecase
> > 
> > Hopefully I expressed this in a better way by now. In short, enforce
> > usage limits for concurrent CMA users using shared CMA resources.
> 
> Thanks. Yes this is more clear now. And it resembles hugetlb situation
> more than memcg. You simply need a memory pool specific access and usage
> control. Dispersing that to a global memcg limit seems rather coarse and 
> I would say impractical. So it really calls for a per pool control with
> an understanding of how the specific pool really works.

Thank you for the feedback. It looks like this won't work. It also
excludes the attempt through double charging dmem[1] as it would have
similar issues trying to use memcg.

From your last sentence, would this rather call for a different
controller entirely that would handle CMA semantics? Referencing the
other thread[2] it would also make the charging separate from the
allocator, but simplify making it opt-in at the user's implementation,
e.g, the dmabuf heap would call some cma_cgroup_try_charge() and
cma_cgroup_uncharge() around cma_alloc()/cma_release().

[1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
[2] https://lore.kernel.org/all/7e4e9662-d876-4493-a0b3-e31640937dd1@kernel.org/

> -- 
> Michal Hocko
> SUSE Labs
> 

-- 
Eric Chanudet

