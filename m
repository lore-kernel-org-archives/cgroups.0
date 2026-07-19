Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC31C84BB
	for <cgroups@vger.kernel.org>; Sun, 19 Jul 2026 17:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784481733; cv=none; b=B4Dwa/xMU+Dp2VoAzgkq7qYJRSoniswseZQP5yhcj0P7cR8mDpwRuiizFKRtCF6qF34nMAY2irR1SjBq5jEPZyatDwPMFhwnCG+Zr2EZFvIAiOG42O1WdTUgEEf0tmhYK1J22YCNzJbovlBn1O8ctyRG3XWM8OOhgUtyQuiBt5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784481733; c=relaxed/simple;
	bh=Qh65/P+drbvzizLTnz4BI5xiHwxDiApTgpDECHy00jQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ad7p5cJsFeucJl9bXX4CA/OqVSF+XDk4u2BA/8I9egebDV1BCgw3S9W3lslits0akEzjrh5INlvYsOwJEb1XsNcH4RVDFHXnWpXfEaf+oN24c3/0g6UU7fBdmnxIg8LbZYAzUzXldb3aNYTT3wFCfY2V7KL0i6X6i+6jF75qcKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wyuan.org; spf=pass smtp.mailfrom=wyuan.org; dkim=pass (2048-bit key) header.d=wyuan.org header.i=@wyuan.org header.b=riTtRL75; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wyuan.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wyuan.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wyuan.org header.i=@wyuan.org header.b="riTtRL75"
Date: Mon, 20 Jul 2026 01:21:31 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wyuan.org; s=key1;
	t=1784481717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3/aEcHJy+vhFwCKQgce71i46wVlKKtSMPyNlSml70Is=;
	b=riTtRL75sh9OVLetYtHSpnbzRZv4kvk1rGKhcfxLshZhEjInnqbgAXp47VRJ3psII+AzNS
	lZZkeEXVW5KU3YmvsgXNtFy0nUxIB/Vrlc3zwYSCCeY6gbzPb1/z+9b7Txy77Rz/kX6UsN
	coyZXXqnwp/ugnWKIU1EyKthFPiOhL5YHec9d4NLTsPyKpWNXwmxllUHTFM+koefpAQhKM
	igNn11eWkkv25mfTh2wzmcKloP9sNIcLYggItZAFqJzqMafw8NXjLrMhs+yJRZzuR2/Gwc
	Ib9v0aWDl+lTsp2nlOqDEBoVu1QLJWrqfb9LARkKG2XiLGkRtiaaEK5611wSBw==
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Weijie Yuan <wy@wyuan.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Yahya Toubali <yahya@yahyatoubali.me>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] Documentation: admin-guide: fix trailing whitespace
 in cgroup-v2.rst
Message-ID: <al0Hm-K2qj5KsOWS@wyuan.org>
References: <20260718151913.1892547-1-yahya@yahyatoubali.me>
 <20260718151913.1892547-2-yahya@yahyatoubali.me>
 <alumXzlDApA_iMbY@wyuan.org>
 <87zezn3p4r.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zezn3p4r.fsf@trenco.lwn.net>
X-Migadu-Flow: FLOW_OUT

On Sun, Jul 19, 2026 at 10:44:52AM -0600, Jonathan Corbet wrote:
> Weijie Yuan <wy@wyuan.org> writes:
> 
> > On Sat, Jul 18, 2026 at 04:19:08PM +0100, Yahya Toubali wrote:
> >> Remove trailing spaces on lines 1335 and 2197.
> >> 
> >> Signed-off-by: Yahya Toubali <yahya@yahyatoubali.me>
> >
> > Hmmm, for a file that might be modified, I wonder if it makes sense to
> > include fixed line numbers in the commit message. i.e. When the line
> > number changes, your commit message will become meaningless.
> >
> > I'd love to hear others' comments.
> 
> Honestly, I question the value of churning the files for a couple of
> trailing blanks in the first place.  There are *so many* ways in which
> our documentation can be improved, and this doesn't approach any of
> them.

Yeah, exactly. I even spent some time comparing letter by letter to
figure out exactly where the changes were made, because I didn't
initially read the commit message. ;-)

But I recalled Greg KH's classic email as I've checked this is Yahya's
first contribution known on the list.

  https://lwn.net/Articles/658231/

So I was like, okay, first time, let's understand and be inclusive. And
apparently he (or any other pronouns if you prefer) was trying to figure
out how to send his patches out correctly. (I noticed that before this,
his first version of the patches did not even form a series.)

So hopefully Yahya could get familiar with the process soon and start to
make more useful contributions as Jon expected.

But as for whether to accept this or not, I'm afraid I have no answers
or suggestions. (Naturally, there is no authority either.) While
objectively speaking, this patch is indeed rather embarrassing. It's up
to you Jon ;-)

Thanks,
Weijie
