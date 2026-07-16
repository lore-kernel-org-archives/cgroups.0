Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C85241A79A;
	Thu, 16 Jul 2026 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209239; cv=none; b=skskKHaZ2tbgtlr6HgWZARc6Um5nqCsmw/i11SVlWa6lgzHOBbN/jVO0T+scENxVS9shHekHRBzUeaAxZOxByXpUQcVz0QHdDGbeeyJ6eIVHVS4pOJ/1dHwyUIfxPth2+jXvInVSlirXnjK37JZol3YrFJUfK6QaYdrZHHf6pUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209239; c=relaxed/simple;
	bh=5vRyDDN9o33vCzXREfskTdWxCISaSTHgmensnkLeAJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I4Vh3tQb1hCSTT/1UsFx7K9f1yoLsDmTruqaM2AbRfT64t2eXBzkYutaCgnUqZxYxjotjBcuR+u3LELN46fCmxv87IkBlBUH1f6GAwuInO20CY2EX/d//utaFv7Vm2ycvT4s8YcvAGEhh86niVCP6If9qbFsEIn3R31t6VW8BqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=E6B3VSnt; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="E6B3VSnt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IiOLFpPJEdQPABwKQzXpqhuXuZFKPhpE3SVrXAZwnww=; b=E6B3VSntferwOj4Y/u0/R1ul4o
	s2+zT+XIM/AN42GVotThn8bT3SAqwB9SmyUPiELBf6B3fk2hbWTyJ7E+FrSieAG9Lt1fue+pP1AnT
	6ajgcIuiQGEC4lapgOlCAGqXBe/7fUW5QbnBf6G78c4adF4+w2aY/1oeRQ4Ynk69R2IjPkEQPN0eh
	Ob65/3dSeyeRxgR0cq+swhl3Wa1KAPJnXGtxBfkwdv5CCD9rJql3isgh3UqpawCBzVEUfaZVV5Ysg
	hZko1teGmVlDAX7gjuBfo4slKYxygBOZjsPw+UYF0ZWanEEYLtrvP6n4DH/KpPQSl+pk9Km3kT8qW
	r4Q1CMGg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wkMKC-003rU3-0F;
	Thu, 16 Jul 2026 13:40:28 +0000
Date: Thu, 16 Jul 2026 06:40:23 -0700
From: Breno Leitao <leitao@debian.org>
To: SeongJae Park <sj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
Message-ID: <alje3jH32jS6D4H-@gmail.com>
References: <aj7KoDXJv3NByGUm@cmpxchg.org>
 <20260627000445.85650-1-sj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627000445.85650-1-sj@kernel.org>
X-Debian-User: leitao

On Fri, Jun 26, 2026 at 05:04:45PM -0700, SeongJae Park wrote:
> On Fri, 26 Jun 2026 14:53:20 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > I prefer this way over the idea to initialize in the caller. For the
> > actual implementation, the protocol is that the thing is initialized
> > when the function returns true. This version of the fix maintains that
> > for the dummy as well:
> 
> I agree.  I also feel the caller code is _slightly_ easier to read as is, than
> adding the initialization there.  If it is initialized there, I would assume it
> will be used somewhere.  But after finding out it is not used for early return
> cases including memcg1_oom_prepare() reuturning false case, I would be confused
> about the inefficiency.  Using a variable after passing its pointer to a
> function depending on the function's return value makes me assume the variable
> will be set inside the function.
> 
> The code is simple enough to read in any way, and my taste is sometimes just
> weird, though.
> 
> Anyway nice fix, thank you!
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>

Thanks! I'll respin with the Reviewed-by tags to reflect that these
points have been addressed.
