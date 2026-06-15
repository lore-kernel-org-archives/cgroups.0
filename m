Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B10823C4E9
	for <cgroups@vger.kernel.org>; Mon, 15 Jun 2026 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781536865; cv=none; b=d5LmBFVDAqBjnIpM/Qn1cHu6vmvNPbQiAWyrDNISiwuEy1FpAnczGrEdpZjt2dxjVoEdS5xeWav7OEfdZlILWxcdmeWT5W0UdxyFNYCPfUeX5GklxFs5N3GRXeMTf6XtCEr9LKW6Gmv3ZyUUtWnjTMN/KUHjTMD015h1iO73dts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781536865; c=relaxed/simple;
	bh=0p9DGgyaA0KehTdZH8Yw95MJofARANGeM8XYLbTYGJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PuC4tb7jdLCF3ysqwPbu3XkRej2lS09dsK4bQkh2zYXUFjCTYLgo6lLUNVOawzcoGdmLF1lErUl2PNpSKNSDj31Sdxo/8K/Zr1VP4vmBKCbOZ2OJhw0OWpShQdot/10f39HbgmCxMycDZVo9nfb9lEdbkQyIlNlCHxiBPjNAjXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ut4ljfDL; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ut4ljfDL"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ce9de10985so45321026d6.0
        for <cgroups@vger.kernel.org>; Mon, 15 Jun 2026 08:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781536862; x=1782141662; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KchXyzZXU4hh7Rwh6HI+6Qg0C71AldRRnKn7P/ysMLw=;
        b=ut4ljfDLAWbstC+JxKLmzssrd76deect/p5RkzpLJUPB/zHEgBud1CcwscrKfyizFT
         p1+RlxSk0PZGrhBWaNbF/RpV4ZyoS0E/bUdf57fQ/LNVrgPe2JJVta9jbCjYTA86U9xB
         48UgBKQv0fiYIxlybKCrPsluuD6/645xKyhiiVPw6G7zYgMHejDFpllu977P75LFhz/V
         vaIoI9x6DwaGir4JeC//xxCBYmRe0Bk8bpJWZ77vcea8eO3MXB0mYCYnPpBsWwHaBHJY
         Q/a8TdKzlLBSi87Hf/e/SQY+bybrM3xx8qc3ceqcFbDeCaiV5Oh5o1hEmyBVDjU9CW0z
         tZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781536862; x=1782141662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KchXyzZXU4hh7Rwh6HI+6Qg0C71AldRRnKn7P/ysMLw=;
        b=Z1nn2bQTHxi400AB52HK1YxZSNz64aqyQvMqQKiMotxFbEb2b2uSeAL80DpjgrzPNM
         BY40lUbI4xlDPpL0b9yudUEkcNT6vvrC49WoA1BRR8ilZo7M42bdY52o0eVcjiIj0Bxj
         tEWss//9w2iohex+hOoLBi0wGUIVs89XIgyCWh8nVtDa3ONZRwFFZmioStoSALXywp+V
         5cffS43zBpzNXtCcbObHmQp+gn7uel8Sa6Qkgp9SqZ2pUz7eQ9PvVRPn2NP/7KhW+jQk
         cdq9PKl+aPvVtS8pqCqfZDpiTLPCigvKOz9cSCa7O/DNI+6DDN9FfPC54xBJ8/n7qTqL
         3o5g==
X-Forwarded-Encrypted: i=1; AFNElJ+81KtglhdLR/AdTEBTvX+06lyhaV6v854QPT8BdfjweYAFji30JAx9FT1pgYUMsNsOjizt1S+p@vger.kernel.org
X-Gm-Message-State: AOJu0YwMMmLDfjbkmAptJvJzDjS7SUpjD0G6uLakIg+pVQOn52dGHQIb
	e7ti0FIAqbm+Zkhr0gmwT2izlMWpEdii/DweRVEnJMbCLxExBt7vzVClqScPlp1PHbM=
X-Gm-Gg: Acq92OGz5uL4L1QUEFkJx1U/Vx4UyRAlfCnSUa6zujYSmdlizjGDYPCn3+8UEm3v9JZ
	QowNKZo/1sx3cbBJsX4j736GVCG7HdPZQH8UwGwx4G0MOGu3s7gM8/pc2FF/PNSyvArgiHyHg6O
	hFYuhPZpSr5NY6E9ckStgLq7j27foLkHGQB7scHnwazHNT+WjHNIEPZ+QmyWgfrJj+tRhJ0OXsL
	MprzZWIU4/MlTjnKgaiQc3OU8Xg04aD5cHkdZ/ukbrD0yrdLKtty9jE7VzR9PXFY5AFKOkB2iym
	CBU6omSprF8qILxAH1XQEO/Wj7Yls8NDdt/jYGpT3kWgEkSPTsXknENjEXcAbAcpBurZXhiIfz5
	KarRFR8AJz3WR/wt5DvKxzEO/cmYDi9yekcuJopNIxCGP6ibsruK4Mejv+d1pZupiUJilvthDqh
	+pg6w0X6l1S7F4QxedTQ==
X-Received: by 2002:a05:6214:5f85:b0:8ca:1706:f416 with SMTP id 6a1803df08f44-8d31718548fmr176666086d6.26.1781536862518;
        Mon, 15 Jun 2026 08:21:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::5f73])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8d9f122d2e4sm1454566d6.8.2026.06.15.08.21.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 08:21:01 -0700 (PDT)
Date: Mon, 15 Jun 2026 11:20:58 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
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
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory
 Nodes (w/ Compressed RAM)
Message-ID: <ajAYWur_4J3yhNs4@gourry-fedora-PF4VCD3F>
References: <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
 <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
 <aiwl4kCG814dpX7L@gourry-fedora-PF4VCD3F>
 <9f1815b0-896b-44ab-9e6d-9316d8f11033@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f1815b0-896b-44ab-9e6d-9316d8f11033@kernel.org>

On Mon, Jun 15, 2026 at 04:38:43PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/12/26 17:29, Gregory Price wrote:
> > 
> > 1) memalloc_folio is required to ensure non-folio allocations don't land
> >    on the private node, even if it happens within a memalloc_private
> >    context.  Since memalloc_folio may be useful in contexts outside of
> >    private nodes, I kept this as a separate flag.
> > 
> >    If we think there will *never* be additional users of memalloc_folio,
> >    then we could fold _folio into _private to save the flag for now and
> >    add it back when we actually need it.
> > 
> > 2) memalloc_private is needed to unlock private nodes, but in the
> >    original NOFALLBACK-only design, you also needed __GFP_THISNODE.
> > 
> >    This is *highly* restrictive.  I found when playing with mbind that
> >    MPOL_BIND + __GFP_THISNODE generates a WARN (valid WARN, it normally
> >    implies a bug). 
> > 
> >    That leads me to #3
> 
> I think the memalloc approach is dangerous due to unexpected nesting. There
> might be nested page allocations in page allocation itself (due to some
> debugging option). But also interrupts do not change what "current" points
> to. Suddenly those could start requesting folios and/or private nodes and be
> surprised, I'm afraid.
> 
> The memalloc scopes only work well when they restrict the context wrt
> reclaim, and allocations in IRQ have to be already restricted heavily
> (atomic) so further memalloc restrictions don't do anything in practice. But
> to make them change other aspects of the allocations like this won't work.
>

Reduced to practice I have found success, however what you are
describing could probably be resolved by re-introducing fallback list
isolation.  If private nodes are not in fallback lists, and they're not
N_MEMORY, then they're unreachable via nodemask-fallbacks, and a
specific node has to be requested.  For everything else memalloc locks
them out regardless.

In v5 I actually stripped this all the way back to just memalloc flags
and implemented a bunch of pressure tests to try to detect leakage - and
I was not able to do so - even with all nodes in each other's fallback
lists.

We can tack on both fallback list isolation and __GFP_THISNODE
requirements on top without ABI implications if we find that is
insufficient.

The only place I think this will matter is in the reclaim / demotion
code, would need to rework the allocation code to handle private nodes
more explicitly.  This has no ABI implications AND the entire demotion
logic in vmscan.c is utterly broken anyway and needs a rewrite.

I'm running a mass build test at the moment, and it's looking clean, I'm
expecting to be able to test the new code today or tomorrow.

~Gregory
