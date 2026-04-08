Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363763358BE;
	Wed,  8 Apr 2026 03:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775620349; cv=none; b=aOSDiXwAAEEqjKwYVfNIc1xqSCWMOwjnPb8GMBp0ecR9tjJVs1hK4gtjXTorXRN38D399E9wsjr5FsdT0GtXMthplvUZBbILjM+IduhrfKUMm740C1aDkBeGKZuuUX8UjnuYuJrYd/iWRkf/+tSYiEuKQ9Fxel0c2CHXoC/26NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775620349; c=relaxed/simple;
	bh=wtmhbiDxrGbIO8cQPRouIzl/0p6VLYybidjJS0vemHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t9qGz2qG8y2wMDcdbf5LVTLZxLBvufT0g7gslEMXbiHFtVe5RUr+MpO7aXfEgx2Zspg2TFn0MvG/mgzVU8hzbHgOBUFI1j3fxP7/WIAovaxqOsdmahxsDTEIMxepMuCL1ruHRj09RjoRhKByeQ5FZrcvLgiz0cgwR9D8JEjqA2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIVenmFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIVenmFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9A9C19424;
	Wed,  8 Apr 2026 03:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775620348;
	bh=wtmhbiDxrGbIO8cQPRouIzl/0p6VLYybidjJS0vemHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gIVenmFHF231TQyCG+S1zN/DVz5Qv5vX0FXXoppNS4GbF2zCh8za2hYE7PtBg3p7n
	 zTaOWiLDpm4N/FOhfci1iJmw6yT1Uk35vaKfhcGHQNa5WQkCP2DrbVqVtMc/8V3V/A
	 hVCU9Qk9Sd7AHapaz5WD9osrVraJ3ABpnFgii4PmuG72z8zL0ayPbXNINB1loDxlLH
	 ZFV4sEYKodCdeUbcql1tp+xfp15veo0jf4/gYf64xTrIiG0AfhYZ2llALVmJkneV6s
	 1QappZXXU915bmvYx1Di/vz1QTu6zUFZn34GCBKikV6Wx7Ksyle+9C+KkOibhXe4nM
	 XB1w1508ztSmQ==
Date: Wed, 8 Apr 2026 12:52:26 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu
 accounting
Message-ID: <adXQ-uqvQtqr02pu@hyeyoo>
References: <adXAG52R6WVHd0n9@hyeyoo>
 <20260408034025.3317937-1-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408034025.3317937-1-joshua.hahnjy@gmail.com>

On Tue, Apr 07, 2026 at 08:40:24PM -0700, Joshua Hahn wrote:
> On Wed, 8 Apr 2026 11:40:27 +0900 "Harry Yoo (Oracle)" <harry@kernel.org> wrote:
> > On Fri, Apr 03, 2026 at 08:38:43PM -0700, Joshua Hahn wrote:
> > > diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> > > index 4f5937090590d..e36b639f521dd 100644
> > > --- a/mm/percpu-vm.c
> > > +++ b/mm/percpu-vm.c
> > > @@ -65,6 +66,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
> > >  				__free_page(page);
> > >  		}
> > >  	}
> > > +
> > > +	for_each_node(nid)
> > > +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> > > +				-1L * nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
> > 
> > Can this end up with mis-accounting due to CPU hotplug?
> 
> Hey Harry, thanks for giving this patch a look!

np :)

> Yes, definitely. I think the solution is just to charge based on possible
> CPUs, even if that might lead to some inaccuracy (by however many CPUs
> aren't online at that moment).

Yeah, that sounds fine to me.
Not sure if there's nr_cpus_node() equivalent for possible CPUs though.

> Seems like that's what already happens
> in memcg anyways, so I think this discrepancy is OK to tolerate.

Agreed.

> Will spin up a v3! Thanks a lot, Harry! Have a great day : -)

You too!

-- 
Cheers,
Harry / Hyeonggon
