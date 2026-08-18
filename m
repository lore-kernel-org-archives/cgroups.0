Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEAB332EC8
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787065599; cv=none; b=DbsbXr4tbeZc25D4KD1M6mHI4TWHmtIetdu8KHFeQXJPvWXIbhbGOfhEzMy2jDiE46UxfxFOmnCvfuEkMbsYqP14RZbxVkNT4QFDz22qOU0zduP93lJR5zp5QOFB2JhHBAO2K05tOKG+Tkyfq9azYslC70Dt7S2s6UjWHZVH6Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787065599; c=relaxed/simple;
	bh=cPHeBY5KTM96nrxv4hgyFw1PuHSjJCWzO7Hqsh/Ysd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rIMISh3ayRWa49DlDmYXOhApmHOwOIyGCBHKhfftLPpLsucNwugm+U/xWJEgAtkzRtO6zPPK01Q8mz8zUYJemonhFirdRQDsJo7goNl+YEEVlbHXWUvuTQgk18JqAZGw0/ogL3iccQK6zGUKyxuk5Rjph06mXnMiI3PRB01wPpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RDFrwmnC; arc=none smtp.client-ip=91.218.175.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RDFrwmnC"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cPHeBY5KTM96nrxv4hgyFw1PuHSjJCWzO7Hqsh/Ysd0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787065593; v=1; x=1787670393;
 b=RDFrwmnC4ZcelxCWWFpLf+K1TP6VLaNw/HWd6Lo9F4HSqcntST6xDw/IBr5jRgBuM3epJNll
 +CZyQO8aIS7Xo7qtFUY0iWdC4bQqrg9KuIqyeQcNwQHXDhEwDr+FlugwQwCMNoRqY7xfR2qVsbU
 jv7YRb7iLq+ZmKonJ9vegl34=
X-Envelope-To: cgroups@vger.kernel.org
Received: from localhost (2a03:2880:10ff:17::)
	by smtp.migadu.com with ESMTPS id 5b5f1f43086e936f;
	Tue, 18 Aug 2026 15:06:23 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 08:06:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoRz72_zdMai_RNV@linux.dev>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
 <aoQNtIRvqXRh-x4u@tiehlicka>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoQNtIRvqXRh-x4u@tiehlicka>

On Tue, Aug 18, 2026 at 09:45:56AM +0200, Michal Hocko wrote:
> On Mon 17-08-26 09:16:40, Shakeel Butt wrote:
> > On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> > > From: Tao Cui <cuitao@kylinos.cn>
> > > 
> > > memparse() consumes no characters on an empty input and leaves the
> > > end pointer at the terminating NUL.  The only validation in
> > > page_counter_memparse() checks for trailing characters, so an empty
> > > input slips through and the limit becomes 0.
> > > 
> > > All limit write callbacks of the memory controller strstrip() the
> > > input before calling this helper, so a script that writes an unset
> > > variable hits this path:
> > > 
> > >   LIMIT=
> > >   echo "$LIMIT" > $CG/memory.max
> > >   echo $?
> > >   0
> > >   cat $CG/memory.max
> > >   0
> > > 
> > > Nothing reports the mistake: the limit is now 0 and the OOM killer
> > > goes after every task in the cgroup.  The same happens for
> > > memory.min, memory.low, memory.high, memory.swap.high,
> > > memory.swap.max and memory.zswap.max, where 0 silently removes the
> > > protection or disables swap and zswap.
> > > 
> > > Reject the input when no characters were consumed, which is the one
> > > case the trailing-character check cannot catch.
> > > 
> > > Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> > > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > > ---
> > >  mm/page_counter.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > > index 661e0f2a5127..d14db705b04f 100644
> > > --- a/mm/page_counter.c
> > > +++ b/mm/page_counter.c
> > > @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
> > >  	}
> > >  
> > >  	bytes = memparse(buf, &end);
> > > -	if (*end != '\0')
> > > +	if (*end != '\0' || end == buf)
> > >  		return -EINVAL;
> > 
> > I wonder if someone started depending on this behavior. In that case it is
> > better to return error instead of silently ignore, so we will hear complains
> > loudly. This looks good to me.
> 
> This is backward incompatible change and I am wondering why should we
> even risk regression.

Mainly I was wondering if this is intentional or unintentional. If this us
unintentional, can we fix it without anyone noticing?

However if we are ok with this then let's make is formal and make this a
documented behavior. I don't have any strong opinion either way but I think you
are saying it safer to just assume this is intentional. Fine with me.

Tao, can you send a patch to Documentation/admin-guide/cgroup-v2.rst which
explicitly mention this behavior?
