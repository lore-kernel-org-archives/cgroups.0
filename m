Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDC94137AD;
	Fri,  4 Sep 2026 17:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544745; cv=none; b=PjSK7kNHIJepw5OQib3Wm6SUtQ9N4unKnLWgjiRkTAPhJkDoRMGCd2fSfmbr1GoYGGfqA0pCXh947gBNzkNOnHv6RKZm4qr9f3TeGg1/YhzCrfRFEpGIfDGUDEfsWjXzVUijGEc3n/XVa6RLyWpH9PVhaGOsJ6OvKBK6FD2QQJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544745; c=relaxed/simple;
	bh=b6ArXo6WN8PvPgPtAAXF4NzFTbDGY4aiKUWgOgxvNuM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRs4kl6jlnZJzmcx4/nbcOfIXnco2ApI/pe2fyu/PGOzxgw4TFzKJwVzTQ18jCepJ4xKF2EsfDINphXv1Or+DPf38J6uKm1x7r/dyuKHR9MS8hpZR1wqiaRyTMFF1gtWpPlWmn/mKKAVHuHylvHqg0LStW3qv5dv425+5PFgcaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPOBtn1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPOBtn1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E751F00A3D;
	Fri,  4 Sep 2026 17:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788544744;
	bh=b6ArXo6WN8PvPgPtAAXF4NzFTbDGY4aiKUWgOgxvNuM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OPOBtn1cMPiS2z56TibMNLsw69HPhvNZKpRpX/c18p46ev6yMmvMxDeK0aGo21TYM
	 +C5LC6y2guL994NwehkNdcY1rYbXFFsc3uFvhcF6uO7pmCzCtRnb06ckMu8Z5hLRYP
	 872RE8xxhBipuoHPk2Tgku18MfXcULfSCU0tognVlxGR+Nmw0qQrmkB5ZoKuhIAt0Z
	 9jGI9wXnVdBcuLCzzi5zCtw/hD/8v/EhGp4uTGhYub1ePbM8NsevJhQC6+efQ939BJ
	 o9o0tt/ey5ZyfUe2lR/XG0EbU0SdQ2RRcH2lj8C2yH1hgfPVboGipf02wL7xf/mNvL
	 FIk31M4I7a7FQ==
Date: Fri, 4 Sep 2026 18:58:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <apsGuHKcdAd8QwgE@gremlin>
References: <20260831234339.280376-1-stevensd@google.com>
 <aprp6GXv8poXXad9@gremlin>
 <CAOiLmNEPw_cPE0QM1Q7CbNC8owW94PvejKo71Hb7DF=QKNN4Lg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOiLmNEPw_cPE0QM1Q7CbNC8owW94PvejKo71Hb7DF=QKNN4Lg@mail.gmail.com>

On Fri, Sep 04, 2026 at 10:33:32AM -0700, David Stevens wrote:
> On Fri, Sep 4, 2026 at 9:25 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > > Memcg charging can be done from any context, but calling schedule_work()
> > > isn't safe from an NMI. If memory.high is breached from a context where
> > > spinning isn't allowed, use irq_work to schedule the reclaim work.
> > >
> > > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > > Signed-off-by: David Stevens <stevensd@google.com>
> >
> > This is in mm-unstable and breaks the build for me :)
> >
> > In general - please don't rely on implicit header includes, if you're using
> > functions from a header that's not included, add the include because your local
> > config might happen to import it but another one might be broken.
>
> Sorry about that, I'll be sure to be more careful in the future. I've
> sent out a v2 with the missing includes.

Thanks!

The kernel headers are a real mess so it's entirely understandable :>) (I think
Matthew is doing some work to improve things on this, or at least some of them).

>
> -David

--
Cheers, Lorenzo
