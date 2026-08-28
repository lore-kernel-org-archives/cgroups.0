Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EF63D9556
	for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 19:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787945188; cv=none; b=PYVEy3blNs0slYqzZSp/kuDJ3Q0XPN74jNIrD84k7X3qKDP4Ca+V5NqPZmZ1yzzbM3/SPBl8qYEindDs9+tFisHQTJ+D5rS7Os6TM4fqcIM6yZTgQOx8S57DMTSpWm7DomJ/Ah9ckppNkckNh87AXBW/1eZJOidLJLue/8R4NWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787945188; c=relaxed/simple;
	bh=4Tq+3yiyziT25C2am1tdF+0Y0aNcGtVzhTMU07VRJLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9E0/H3tkEmAHg4oqVqBAQBtAYwE1/uKYgdDWtFACkKwUMBLIMsmPRf4uVqGwQyUxS5yC9UiMpNOISlls7CLjtFhHgoIHjkOs+oHeEYyeXf6tIs5LSKMpr1GHKObJvsMFlOiYr/LPexqpq61ZAaQtiZPIsUt66bmERJIiNDeD7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ninNHkWe; arc=none smtp.client-ip=91.218.175.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ninNHkWe"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4Tq+3yiyziT25C2am1tdF+0Y0aNcGtVzhTMU07VRJLo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787945180; v=1; x=1788549980;
 b=ninNHkWepWX5vcAx9rpStjUaG3oQEHdo/D7i7dDo5F7dabvldZ5DgainjEQ0nyefEnYY9Ur1
 BoVOGqRpjRwfcJU7td4uuOFFyieqXHE7zONIWdkch8K2MS2Rp+IFeeR3/D7xXkNwik5nl8zXVLt
 3AXRGElwa6kRnh4SzX866QI0=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d6f9c93dfcbab706;
	Fri, 28 Aug 2026 19:26:20 +0000
X-Mizu-Trace-ID: d6f9c93dfcbab706
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 12:26:15 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
Message-ID: <apHgs2ZAxAdy8WIH@linux.dev>
References: <20260828135036.7d44361f@fangorn>
 <20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>

On Fri, Aug 28, 2026 at 12:20:18PM -0700, Andrew Morton wrote:
> On Fri, 28 Aug 2026 13:50:36 -0400 Rik van Riel <riel@surriel.com> wrote:
> 
> > When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
> > isolation, schedule_drain_work() can drop the work in a separate RCU
> > critical section, and housekeeping_update()'s synchronize_rcu() can race
> > that second check, leaving the flag set.
> > 
> > drain_local_stock() only clears the bit for work that ran, so the flag
> > remains set and the stock is never drained again.
> > 
> > Have schedule_drain_work() return whether the work was queued, and clear
> > FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
> > isolated, so future drains can retry.
> 
> Is there some Reported-by: or reproducer for this?
> 
> Given the complexity of the reproducers which Gemini developed for me, I'm
> suspecting "nope".
> 
> > Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> > Cc: stable@vger.kernel.org
> 
> Why is a backport being proposed?  How does that benefit those we
> serve?
> 
> Sashiko suggests that we ain't done yet:
> 	https://sashiko.dev/#/patchset/20260828135036.7d44361f@fangorn

Haha we are never done. Just sent the fix for this new report:

http://lore.kernel.org/20260828192419.3057939-1-shakeel.butt@linux.dev

