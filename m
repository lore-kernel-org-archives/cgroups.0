Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D0030B517
	for <cgroups@vger.kernel.org>; Thu, 29 Jan 2026 18:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769712924; cv=none; b=KW5ookHwv82sN8iT6+YuTzebFzAHc5VubVv2xpUj9/G0P9q5EBSTzgnO/Y9dT0xumbDd6+QGBYTy6VMaEcLWDSD25I0rIpxkt2zpXTXCWV2UHvYCkqP1ypbg1CyNLaXn1HMMLosJap3vZaSdbPTnqPr4xd1cp3y//YyHOFNkpnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769712924; c=relaxed/simple;
	bh=rqQloEMCEHW5Wvp0Zhu0ghl0Z42M+PmL1CkG22sba0c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vntx67A8FpwSPBJbdH7bxPh6lz4wEgbsKB5r9w157y2FV2QfBI12HbPbnSorSdvXT4a3bk06r+ekuV/e81RLPQdbEpgfBhIdzUm/FzezWc1yf1m32eE0V2+OTRW+sqlYpt3xXF5BDE2aQ7iglE/kMv9iUI/b2xM75DcvjWHGt+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ep3PjCt6; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ep3PjCt6"
Date: Thu, 29 Jan 2026 10:55:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769712920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9dbFuRTaIYbJLep7CcjvLi/9Eze7IQbnKopNMEF6Mkc=;
	b=ep3PjCt6tHF0G2BvZiSi9+KqefVTxDYuLYGFClkmmcCPMAWX1fwDB2xgdE/CsCIM/QeSaF
	i0c5+0vxFYFdcETp13cZbicrbzpGENLnoEXgrA3ePMfvb2LNwWpNiqAxRZFSmUonPFLO+o
	mCa2ELM+utaM7jdEwRZVzquQIOhbbx4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>, 
	Song Liu <songliubraving@fb.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: khugepaged: fix NR_FILE_PAGES accounting in
 collapse_file()
Message-ID: <aXusxKTW5Y6-0qKO@linux.dev>
References: <20260129184054.910897-1-shakeel.butt@linux.dev>
 <20260129105015.0ed043764a4ad220334b7ae1@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129105015.0ed043764a4ad220334b7ae1@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 29, 2026 at 10:50:15AM -0800, Andrew Morton wrote:
> On Thu, 29 Jan 2026 10:40:54 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > In META's fleet, we are seeing high level cgroups with zero file memcg
> > stat but their descendants have non-zero file stat. This should not be
> > possible. On further inspection by looking at kernel data structures
> > though drgn, it was revealed that the high level cgroups have negative
> > file stat which was aggregated from their children.
> > 
> > Another interesting point was that this specific issue start happening
> > more often as we started deploying thp-always more widely which
> > indicates some correlation between file memory and THPs and indeed it
> > was found that file memcg stat accounting is buggy in the collapse code
> > path from the start.
> 
> So this has no known runtime effect apart from incorrect accounting?

Yes just an accounting bug.

> 
> > Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> 
> Should we cc:stable?

I think so.
