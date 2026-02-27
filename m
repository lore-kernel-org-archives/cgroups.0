Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD0C45349F;
	Fri, 27 Feb 2026 20:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772222647; cv=none; b=CYz1Jup4wNbNQHdpxdKj3britEkejwf2RZnNMS/E9B56xFjZVwcSPhmUo6C+QO7xJnDw7GWsskwwFJufJ68ddRcD0LIlIDU9C4a9P6M8zsGKQIq32e7VBK7lY1aw6FLtWpSUoLz8Y3mpIdn/51gt5q7/7RWr63HsvkrgfErWoFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772222647; c=relaxed/simple;
	bh=+h5obQ6GPJfnRrz+vn8A0ie+I5jQdqRdluIK/Y8j2A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=py8zm+D99FBItmF8LkFvKgac4vBCI6NHFG4vBB2z+KZyvlELYleAZj/LfZgUQtICvYmb+UEcM/5jcIQ/GutqwqaPpfn9oYpWVzsB45GdUx9v9NZxpyA9euUi978kwH0ThRfOOj/8CDKudq15f0jYWYNZ6q3h56kbN7dSc3sh3QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRDcIrb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRDcIrb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F2BC116C6;
	Fri, 27 Feb 2026 20:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772222647;
	bh=+h5obQ6GPJfnRrz+vn8A0ie+I5jQdqRdluIK/Y8j2A8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LRDcIrb2K/gbknMbAOwEO8mfSsjl405hatftdipzrRCYFxcvWxPs4+PLEnTEQpk6e
	 pNaetSlHcOnXhspqMDiXL1vlWDJUo0e9S84xiWgSvAlZLPbQhBLIz0CjMH1bJLnNPb
	 19lHB40yr34fCG5S75lKOL5r+uHa5Fcs8gP68hEIN+/9GlYtoFsSscury3R3uJnO43
	 zE6hTW7qTjD0PceiF5vwSzZQd4c0cK1p/ktpp8XiQ/9cnxjvCN7bhlnaGj/sdycypc
	 jt/elI9vwHFW7mMvdUtdvAGDvrfbV3b4XQX4+hIdGCYEXv0JPk4QOUvrExRSs3hDTy
	 jquDywY+OeQOg==
Date: Fri, 27 Feb 2026 10:04:06 -1000
From: Tejun Heo <tj@kernel.org>
To: Andrea Righi <arighi@nvidia.com>
Cc: linux-kernel@vger.kernel.org, sched-ext@lists.linux.dev,
	void@manifault.com, changwoo@igalia.com, emil@etsalapatis.com,
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org
Subject: Re: [PATCH 07/34] sched_ext: Introduce cgroup sub-sched support
Message-ID: <aaH4ttpN5u4rFv3Z@slm.duckdns.org>
References: <20260225050109.1070059-1-tj@kernel.org>
 <20260225050109.1070059-8-tj@kernel.org>
 <aaBsRu4_4OXv4d7-@gpd4>
 <aaH1y7ZXepwjL58X@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaH1y7ZXepwjL58X@slm.duckdns.org>

On Fri, Feb 27, 2026 at 09:51:39AM -1000, Tejun Heo wrote:
> On Thu, Feb 26, 2026 at 04:52:38PM +0100, Andrea Righi wrote:
> > On Tue, Feb 24, 2026 at 07:00:42PM -1000, Tejun Heo wrote:
> > ...
> > > +/**
> > > + * scx_is_descendant - Test whether sched is a descendant
> > > + * @sch: sched to test
> > > + * @ancestor: ancestor sched to test against
> > > + *
> > > + * Test whether @sch is a descendant of @ancestor.
> > > + */
> > > +static bool scx_is_descendant(struct scx_sched *sch, struct scx_sched *ancestor)
> > > +{
> > > +	if (sch->level < ancestor->level)
> > > +		return false;
> > > +	return sch->ancestors[ancestor->level] == ancestor;
> > > +}
> > 
> > This seems to be used only later (patch 31/34), so it's an unused function
> > for now and may break git bisect. Maybe we should introduce this later?
> 
> It's kinda nice to introduce the basic organizational things together but
> yeah the warnings are annoying. I'll move it to the first user.

So, I tried and hate it. The placement is not logical. The bypass being the
first user is incidental and reordering now needs to move independent helper
function together. Unused warnings don't break bisects. I'm just going to
note that the function is used by a later patch in the series.

Thanks.

-- 
tejun
