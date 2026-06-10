Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EA120C029
	for <cgroups@vger.kernel.org>; Wed, 10 Jun 2026 22:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781129895; cv=none; b=TYXvl0noQKMySn7MZG+hbOwYSG1abj8CnLONHdUIm2p36hNTQALqRc7zHsmCIfXd68J8xgIkgk1z3gEPFwo8pgjtD+sIH4A/vSOdXRgKtQDffaKp+dQsJDMr7HOEs8ZW+NZ1U15ibLljhitCWfdB0nGZ9GMZw5YhBNhNIWC/cAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781129895; c=relaxed/simple;
	bh=n6qQe/H8M9f/HunhZcM7AZ4l6+kkk/hPRfn60YC5VlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sBs+vqv5gvvlA6khURbomlTYry1NAnAdZLSTOCPOgC5ULE8L1UNP8sssd39DVhJkOjdV2jNv75vpv7K37TC2u7R503qISj4n+Dx7H0xY350w10RjXQCManwGUyGzGCZODiWtcM5QvzzsTO7v4fImi/BDWTgAGBxTqSe+6QvWcb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=V3vKIxUP; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="V3vKIxUP"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9159da9bba5so529597685a.1
        for <cgroups@vger.kernel.org>; Wed, 10 Jun 2026 15:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781129892; x=1781734692; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j1PbvrJxmu0Zl4ziOeo1RdvYlevUlgdJVEfHD2noTRQ=;
        b=V3vKIxUP2xQMBPVbbKnJ/vNJOjqfa2Eji6/VFzoKcer3eo+JRBwicBO8NaCpEb08y2
         RAW7SmKqHygNl72UBObn4fn/nuHkqdvWW1dKPuzdEEcSWboJZ5JOS9WVn/D9sNIg/tOf
         2MvqrjyXRommi696jqaFRJYj57UZOi+5XcribHaAg/43qvEuApqTYAAiwTwkZOBPC6dn
         azP5IvkGkft42VwkW5Ue835DqIj+UpvZhdoEWGrva6lq7YNvgd1YOkj7nqGrhJD/RDQz
         ywkCPP7sMepNhKf6jDO9ZFAb4HbaENWNB7AynuXgZJKT350BEJFmUbrNeKR/o2IAMVh4
         Xwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781129892; x=1781734692;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j1PbvrJxmu0Zl4ziOeo1RdvYlevUlgdJVEfHD2noTRQ=;
        b=kHyDqVmY7kkqe2X8xx8qN8nr6/Ncew7mZyRbCOroYI5jetAqVuO4vfocPdoqSYO+IC
         W2FoTJWBALJXaEIc3U6fXq/jItRjKN+pSw2slLUGuMfFDKBVf2jRMX6Qw3BQzKsiJG5M
         CR9RuIFBcdAy7I9a5zCtYB3H9yUA+sQ2Ess0Om6+smLNasZ8gIIMqBNtSqbcKfDZdpzD
         yzi2OYRIr2qvAs64tcldOYLfjzQGeXg9X5+/xRsgk8GsYw4jjINb1sG4MxaSjIwClUPA
         JnlExaIvJ2D5fDam+GKPfgxJ442rmuEPeS93YwhKXniUYMTgJKkJGmAIcV4h097mxKtK
         m2cQ==
X-Forwarded-Encrypted: i=1; AFNElJ8CMfq2AxeKHw/2g/4yxrHQo7UndjeBSfxSCr7FfOrXsx4IqzCuUy9Oou9VujONih6fFHKHvIVC@vger.kernel.org
X-Gm-Message-State: AOJu0YwWnWPagxCK2DS83bAEnwq9QYkz6TLIzL/Zdyxd9zZj44EE9BaL
	GKqPqY0BEo4Ur2uRtgL465tBMx3zqQYhqwpyBK46XmWUPhKx0rkWgU8tnPkilo4w3q8=
X-Gm-Gg: Acq92OFtWdeTV+Ki6aWThMszdFXFzufIFxYOU7vG41zV/uYXRR5WIHzaeHEnVor2CCT
	d0pasg8qAQEcEgAxKaJmQxE1vGWo0I9ogsrc7vFtFLZOeGTd+GtQ1BNmC830tTWGO9l2VPqXbB1
	rwpDZK/7kct5AJVEj2E3qPLs3VWvtYt326Xd8Srd4VtiPmFCnq5QsfcF8WQHpfPrpI/Yp5giBcC
	vel3h7EpGTUcP600JEG8t4UFkOaMSYXvdlfyQSbEW/uyzv/KOcOWuA2vkARqln4Q0oddLur4XAk
	COrea9zWUlm59GyjMId9UN5ThJ/7luktqY6DOEhRLQQ2KlvWY3bRMBFx8PyElDgl8G0uHBIBig8
	QDu4TxigaoBQ8GeOIGOU9ypJJBKmGRCWQzvmHPstf3IBK2gw7OAhFSV2g4QnaFBDPAWWvxU9h1w
	h1i07DogIniiEjhx5KK/rZvwkEPqU0l7xrrm29QOvXeaD6BRvnN30tER3z8FFks9ViexXwUl6vY
	BZ1kBVRbiGz6luipA==
X-Received: by 2002:a05:620a:2993:b0:8f1:5e8f:fff3 with SMTP id af79cd13be357-915a9cc266bmr4381110385a.26.1781129892358;
        Wed, 10 Jun 2026 15:18:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a243041sm2641676685a.18.2026.06.10.15.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 15:18:11 -0700 (PDT)
Date: Wed, 10 Jun 2026 18:18:08 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <ainioCiFo0vI9ohY@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>

On Wed, Jun 10, 2026 at 08:59:59PM +0200, David Hildenbrand (Arm) wrote:
> 
> At LSF/MM we talked about how GFP flags are bad and how deriving stuff from the
> context might be better. I think there was also talk about how the memalloc_*
> interface might be a better way forward. Maybe we would start giving the
> allocator more context ("we are allocating a folio").
> 
> The following is incomplete (esp. hugetlb stuff I assume), just as some idea:
> 

Ok, this was easier to test than I expected, and hugetlb is indeed a
stickler.  We can't get there 100% with just MEMALLOC_FOLIO, we still
need a MEMALLOC_PRIVATE - specifically because of users like hugetlb.

hugetlb uses __GFP_THISNODE to do its allocations, and all hugetlb
allocations are folio allocations - so the code you shared by itself
does not gate hugetlb from spilling into private nodes.

That means we still need something like this in hugetlb:

  if (node_is_private(nid))
      /* fail allocation */

HOWEVER... if you have MEMALLOC_PRIVATE - you make the allocation
failure a *page allocator* problem, and it serves exactly the same
purpose that __GFP_PRIVATE did.

the resulting code is two lines in my anondax driver:

    unsigned int priv_flags = memalloc_private_save();
    ret = do_anonymous_page_node(vmf, dev_dax->target_node);
    memalloc_private_restore(priv_flags);

No special hugetlb, slab, arch code handling - they all just fail
to allocate / fall back.  If they fail - it means that code is using
a bad nodemask and we need to go fix it (exactly what we want!)

I think additionally, we might be able to repurpose MEMALLOC_PRIVATE
flag for Brendan's needs as well [1].

Their goal (IIRC) was to have a pile of unmapped blocks that could
be opportunistically converted to normal memory, but otherwise left
unmapped and sitting in the buddy.

Same thing - different filter point (blocks vs nodes).

If you set MEMALLOC_PRIVATE - it makes private node allocations
possible, and "private block" access (without conversion) possible.

Otherwise private nodes are unreachable, and private blocks would be
treated like CMA (last-resort stealing, lazy-direct-mapping).

And they stack (private blocks on private nodes :V).

I don't have enough time looking at his proposal, but it seems like we
can kill two birds with one stone on this.

[1] https://lore.kernel.org/linux-mm/agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F/

~Gregory
