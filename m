Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDB138B12A
	for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 21:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787608737; cv=none; b=PYhZUrnByeDWOzifPBr92inFf34NEYgRxAtJFU4Jpq1ope+cOdpbi0teTYlQSxH1lNVPhY4Qnh0kb+YaW6RVuT2YnqLql/omGrgxC+3Xm0rhz1THUil6Spr6pg77tO9TYP6gDZpEIMoH5bAGDnOYCOhGpBj3HVAT2JWOtOebbUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787608737; c=relaxed/simple;
	bh=wHIknkl3akbrXed1MMW7wu+rEQV0V9E6XtCSzIf/KQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MYZptilNmTx2xYhK72yM6BrNkZpho7NVMHfwNNiCtfKua/OTt7TaEKY+0SyVJdCsU3+lUai2oY/T3cuMl+FpecL/OGj8UJtug7kBFXx+0egQQUy8fUbwwViZEzGEVqy6kSB46bsi30U5E4o7y+mEy4Io2YPycZ3kUPMkA19Dh64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fzPMhn35; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y6enUsSg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fzPMhn35";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6enUsSg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787608734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KBpVXvNSIu/VB+Hjuc+28Xij0/FItj9lSc9IUEB2grs=;
	b=fzPMhn35I2Lpz7VWka8VgkdWcAP0BGFHDdbkZWNmUBZ4LBtsxQrDGaz8a24ZRW+bQnWkkw
	SS7xzPhSrltnGtLL4srexdOcoOuriGbjPEzg1JQlWZDDrVeLCWWXU55x8qwaB6mkwZoc6j
	2Jy8PHq6inPu9R7zpbihw65KEocvXqU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-1r2Kg74gM7uOJ7WNVl-LsQ-1; Mon, 24 Aug 2026 17:58:53 -0400
X-MC-Unique: 1r2Kg74gM7uOJ7WNVl-LsQ-1
X-Mimecast-MFC-AGG-ID: 1r2Kg74gM7uOJ7WNVl-LsQ_1787608732
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52d827597fbso42688671cf.0
        for <cgroups@vger.kernel.org>; Mon, 24 Aug 2026 14:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787608732; x=1788213532; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KBpVXvNSIu/VB+Hjuc+28Xij0/FItj9lSc9IUEB2grs=;
        b=Y6enUsSg5ZqJ2nfG48FYcL7DZ7e5ZppG4iEYZnYYQedg6maUa0kt0Gh0UNKeUA+EtT
         i6CWWwJ/bP9Q0E96IMy+v7Bkij25+gCZwASv5C/uQKYtOQMb3AcyOSkV5Hk/i/fm/orj
         VNdeSxRIaqPL0wrHw0e1Jk0ELpp6UNp+q+3M+HGWIn+7gInFJ4CAlMHvQDLjiL/hfOrR
         vJB8bhi/TKiRsi/ORp+VHvsUJBGqHKBQ+5kMThMmQAwBLQVDERROKhbYwMwhBJtB5aVU
         kBiXKXWIZh1zZ1t/KvRX79RhxNt5H4KJdrhsPEfsgpYy6oAGo3y7Sf7CiLH29F+XQ1q/
         +75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787608732; x=1788213532;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KBpVXvNSIu/VB+Hjuc+28Xij0/FItj9lSc9IUEB2grs=;
        b=UuEnXDWA4xYIYQTZekONv55ObXe/SYD4zfXVcB1C9vtc0LrELiACERU+lYvYB0bpmO
         ArGu49k9l/0EowOMck4cI5naMmbNEmn0MFUazOKkhbwDglCbfphIvJBrP2VqhgzW9Ogb
         l8lu1faQMv2XD2jyMhj7IubeAsUvRWjPHP4x6epBrbatWJIjBSQNdzsTVhTQO+llsA7y
         K0KSzAV1FdHgv0X10OTvtmpB64FIR9S4wlWO4lOnFiXSNOBEuif5e1RKV6c5B7JEQLL7
         il1aKRY7vlcLHXF2kurstzLyyDdoOmL/UtAGWW5uTH1Pe8FaMusYAzGGv8RVEvjaCltL
         H6MA==
X-Forwarded-Encrypted: i=1; AHgh+RplRO9BwSeyq5nyKzf4SXn2Ud4A39KXViBTUvT2gPjnmQhU/67taTuGo26Vr6ZQNfmKRxoOAMt3@vger.kernel.org
X-Gm-Message-State: AFuF++lMwf3ULqsDVjHFVX87AY+0prC+94sYAGuGMK9mPjw8CvRIEY81
	JtD9xAOVobg5ehLFeE7EGI5Z6uLO2JGULnbJE+gDJ9gTH62Axjuvc2ElT6yykyKNgrNgc8EAnkj
	kyiw4TvZtFc2u46bhvSiBD6gYDkjO/8JskLx0B86TH3xNrd60H2Koks+rDNM=
X-Gm-Gg: AR+sD11GAbSpC6Rdz/t5o2YmCeUqkL2oRoe7F+NABL1j3xWQye/sKC7k79aPsgYbfjw
	F3TDiVO6ep5Af6kodlsPU9RtVwMCK9vD1Uo3Q2i0bp2/Lnfl4/Rruu9GrBQ0tnEdEJGHR3Ylw2z
	sFd5cCIFTrjqeWdyXByjCrOMBwqwF9J0fG1XDmC9FeC7VSrq1W+RheyQim8npgDZ/n8OgRUGdeJ
	j1sFV4g6b1YOxsPvjJ4lxfOkaxz2DyyxrPHFEmjG5oXpYO8anC0TFICiet2bMQL48LNo2ja8E6X
	Gn4fewr0z/oecFMAaorb+iWwqghaRwFZikmJJGfNA616ZwLprW8PqoZ/WrIHyZuZibUFwuM1h1J
	eVWV62po9O5BTA4xoe0zcofzZMygqQiXzyUSckTfCKd7e
X-Received: by 2002:ac8:7f4e:0:b0:521:934c:bcf with SMTP id d75a77b69052e-52e2f17d066mr22919011cf.41.1787608732352;
        Mon, 24 Aug 2026 14:58:52 -0700 (PDT)
X-Received: by 2002:ac8:7f4e:0:b0:521:934c:bcf with SMTP id d75a77b69052e-52e2f17d066mr22918481cf.41.1787608731836;
        Mon, 24 Aug 2026 14:58:51 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e099baf17sm55607001cf.12.2026.08.24.14.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 14:58:50 -0700 (PDT)
Date: Mon, 24 Aug 2026 17:58:49 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <aoy88hVQcA6Gkfuk@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aoqbCyX-32doBJwd@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoqbCyX-32doBJwd@kernel.org>

On Sun, Aug 23, 2026 at 10:02:35AM +0300, Mike Rapoport wrote:
> Hi Eric,
> 
> On Fri, Aug 21, 2026 at 02:56:52PM -0400, Eric Chanudet wrote:
> > CMA allocations are currently unaccounted for by cgroup memory
> > controllers. As system resources, they should fall under memcg, but CMA
> > areas partition the available space for different purposes and memcg
> > doesn't have a good representation for that.
> > 
> > Add a memory_cma_accounting cgroupfs option in preparation for the
> > following new behavior. Make it disabled by default since it will
> > account for CMA allocations in memcg which may affect existing systems.
> > 
> > Provide CMA charge/uncharge functions to memcg that introduce a CMA area
> > specific counter per CMA area. Charges are issued to memcg and to a page
> > counter for the CMA area used. The allocation's folios are marked with
> > the cgroup via commit_charge() (once for large folios, per-page for
> > 0-order ones) so they can be later uncharged correctly.
> > 
> > Add the new memcg calls into the cma allocator under __cma_alloc_frozen,
> > for both cma and hugetlb_cma allocations accounting.
> > 
> > Finally register the per-area usage counters in the cgroupfs. Each CMA
> > area creates a memory.cma.<area>.{current,max} pair for reporting and
> > limitation for each area.
> > 
> > Selftests and a vmtest script are added to this series for convenience.
> > The tests are simple accounting and limit enforcement verification using
> > the default reserved CMA area (cma=) and hugetlb_cma.
> > 
> > Signed-off-by: Eric Chanudet <echanude@redhat.com>
> > ---
> > Eric Chanudet (11):
> >       mm/cma: drop const for struct page on release API
> >       mm/cma: include linux/cma.h in cma.h
> >       cgroup: add memory_cma_accounting mount option
> >       memcg: add cma charge/uncharge functions for area counters
> >       mm/cma: charge cma allocation to memcg per area counters
> >       memcg: register per-area usage counters in cgroupfs
> >       selftests: cgroup: add cma configs for cgroup selftest suite
> >       selftests: cgroup: add memcg cma tests
> >       selftests: cgroup: add a vmtest script for memcg
> >       selftests: cgroup: add memcg hugetlb_cma tests
> >       selftests: cgroup: amend vmtest-memcg to run the hugetlb cma tests
> 
> CI found issues:
>  
> https://github.com/linux-mm/linux-mm/actions/runs/32519133924

Indeed my apologies, I messed up CMA=n it needed a forward declaration
and gating for mm/cma.h content included in mm/memcontrol.c.

I queued this up for a v2, with the other issues reported by Sashiko.

> 
> >  Documentation/admin-guide/cgroup-v2.rst         |  35 +++
> >  include/linux/cgroup-defs.h                     |   5 +
> >  include/linux/cma.h                             |   4 +-
> >  include/linux/memcontrol.h                      |  19 ++
> >  kernel/cgroup/cgroup.c                          |  15 +-
> >  mm/cma.c                                        |  14 +-
> >  mm/cma.h                                        |   6 +
> >  mm/cma_debug.c                                  |   1 -
> >  mm/cma_sysfs.c                                  |   1 -
> >  mm/memcontrol.c                                 | 205 ++++++++++++
> >  tools/testing/selftests/cgroup/.gitignore       |   1 +
> >  tools/testing/selftests/cgroup/Makefile         |   2 +
> >  tools/testing/selftests/cgroup/config           |   5 +
> >  tools/testing/selftests/cgroup/test_cma_memcg.c | 402 ++++++++++++++++++++++++
> >  tools/testing/selftests/cgroup/vmtest-memcg.sh  | 197 ++++++++++++
> >  15 files changed, 903 insertions(+), 9 deletions(-)
> > ---
> > base-commit: 98f21c54f99519329c18e2625b0ea6db14524d09
> > change-id: 20260706-cma-memcg-regions-696cb5ef7998
> > 
> > Best regards,
> > -- 
> > Eric Chanudet <echanude@redhat.com>
> > 
> 
> -- 
> Sincerely yours,
> Mike.
> 

-- 
Eric Chanudet

