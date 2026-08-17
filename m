Received: from mta0.migadu.com (out-89.mta0.migadu.com [91.218.175.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A1744A3EC
	for <cgroups@vger.kernel.org>; Mon, 17 Aug 2026 16:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786983104; cv=none; b=Rhze9GTF5ESxClLtPkqoafJfzjd0f4f/kkoce8sw1Gqlyh/c2EgXPo6okVZdVwgf+JYVnJMxOXTW98E7WfKizovLt1U66UFcqNrNkKh9aL1aBVwbSg/f7oYxHDBxF/K0V9DsSF2L9PNYCCYngAVSgdAO6ps6ZPJM1KQE4HsA3Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786983104; c=relaxed/simple;
	bh=nJBhheWJDTvysjCU7dK7qU5OWfmrA02NtKHvbmLvCZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRwILs/mZFqzynzlxjpnhob8M8XVZlyCUPFN2qmf+OcOZ5exDPgNoHn/d2SKw/17DJtqzlI5KYQr5nqbTEw5cwRxkxF2hnM5JCxcCnxrH87ShBt4CjpxTTPxCWwBzox5uvbmkhVtq8uZZ+GJe7O05FenJzTGN6e9XJ/t2aDBjmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SCS2Ilz/; arc=none smtp.client-ip=91.218.175.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SCS2Ilz/"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=nJBhheWJDTvysjCU7dK7qU5OWfmrA02NtKHvbmLvCZU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786983099; v=1; x=1787587899;
 b=SCS2Ilz/ELUk1LkJ+3hzOJb3wH4n7pWX9AQzeF+fllFAku+J5Q7r6AfIVlAdCcuHexeDGZDn
 9bxuvljSe38/A22OiRXPUIb+Y0Fcdq0AXcrnJ02d9kdTNZSFTtrIUphUh/H5CLvQ26MfepSOtKA
 orih1CfY1x4QcH5HizsXkt8E=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:16::)
	by smtp.migadu.com with ESMTPS id 266e50a251363352;
	Mon, 17 Aug 2026 16:11:39 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 09:11:38 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Song Hu <husong@kylinos.cn>
Cc: Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, 
	audra@redhat.com, bingfangguo@tencent.com, cgroups@vger.kernel.org, 
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	zhuhui@kylinos.cn
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoMyk4JvnSPeVz8b@linux.dev>
References: <aoLGzZHS8kj53-ey@tiehlicka>
 <20260817131221.44761-1-husong@kylinos.cn>
 <aoMMr6kEX7pW1dSF@tiehlicka>
 <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eef3b61a-a8c2-4b2e-b560-c2dae129bb7a@kylinos.cn>

On Mon, Aug 17, 2026 at 09:58:39PM +0800, Song Hu wrote:
> Hi,Michal
> 
> 在 2026/8/17 21:29, Michal Hocko 写道:
> > On Mon 17-08-26 21:12:21, Song Hu wrote:
> >> On Mon 17-08-26, Michal Hocko wrote:
> >>> Is there any specific reason why the memcg stays in the cache slot
> >>> without any pages?
> >>
> >> consume_stock() doesn't release the slot when nr_pages hits zero.  It
> >> is kept for the next charge of the same task and only gets displaced
> >> by a charge under a different memcg or by CPU hotplug.  The problem is
> >> that the offlining drain skips empty slots, so the css reference they
> >> hold is never dropped unless something unrelated displaces them.
> > 
> > This doesn't answer my question, really, does it? Is there any good
> > reason for this implementation? Why do we need to drop references
> > remotely when we can do so when the last cached charge is consumed?
> > 
> 
> Fair enough.  There is no strong reason.  Keeping the slot
> populated after the last page is consumed only saves a
> css_get()/css_put() pair when the same memcg charges again on that
> CPU - a micro-optimization from the original single-slot
> implementation.
> 
> Dropping the reference in consume_stock() when the slot empties is
> the better place.  Empty slots stop existing, so the offlining drain
> has nothing left to miss and is_memcg_drain_needed() stays as it
> is.  This also makes Joshua's concern about the full-stock drain go
> away entirely.  The cost is one refcount pair per emptied slot, at
> most once per MEMCG_CHARGE_BATCH pages.
> 
> Joshua, this supersedes the css_is_dying gating you suggested and
> that I said I would do - with no empty slots left, the check would
> never fire, and the kill_css_sync() ordering argument becomes moot
> as well.  Since you are reworking this code, I'd appreciate a
> sanity check on releasing from consume_stock().
> 
> If this direction works for you both, I'll rework the patch
> accordingly.

Yes, this seems reasonable. Go ahead with the rework.

