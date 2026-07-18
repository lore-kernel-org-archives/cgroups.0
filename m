Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C603DDAEE
	for <cgroups@vger.kernel.org>; Sat, 18 Jul 2026 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784392356; cv=none; b=sqLT2eS+/tUjqRjIF4yTgmgDVP0oJbp9mLC2PvwOIx8GULRHGswMj1U6Uzy6mcIj4nEZBcAJE739Dv51kBLCGmDQTqKw0wzwPnQ6phsQaB3vnt3aMgQHvne0KXGyz72+IU6uP0ljCJj3euw+Aq7ylpJoFJx9w4qvV/A2/4t3gFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784392356; c=relaxed/simple;
	bh=orQ4gkpUpgH4yLgeSYDeWnaLDA5nr0OSJw7uzkaspKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBKrUURH5l8dESc+dMp0UDDaBbJsAAaqMqfCHFKW6A3BAELOKLQtUN75p337uiP+CkY63JBYWedywOlKVIFwM/SUquGI07dEg0mQIpwlaiNu5aUo9EfGoeWm8DHkCRUnZeP7vYQp9ouB66dKrtArv2h3XqbsT+N8p2vJkBJkGT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wyuan.org; spf=pass smtp.mailfrom=wyuan.org; dkim=pass (2048-bit key) header.d=wyuan.org header.i=@wyuan.org header.b=UVOFHNh8; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wyuan.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wyuan.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wyuan.org header.i=@wyuan.org header.b="UVOFHNh8"
Date: Sun, 19 Jul 2026 00:32:21 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wyuan.org; s=key1;
	t=1784392350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KCrVkDfbNLsq1LVbRwXuJqedq/SFg8TyF55LP0pm1Ac=;
	b=UVOFHNh8Qx3XgItfJLkqcqk08lnM1e1nfQW/UYFVbx+C4rzJ1zuGOhHOn9gMmf0azPb6Ye
	4Ybxe4jGOiZ+QUdQGsD4jQHRyAVBCa6H9FpSbMpdh3ikugmybH3dkx8lE0hFCxwono5Kt4
	iCNRwpuI5pmCmMePpg/q84YUhW6/8+sVoCKFZYllhbF1pQ/sHWrsHf1wzJQEMrKnTTEn7s
	352K0Tr+wmVNpoed02I5tTfQ36kLL4GYljbEtL76LbdRQajPUNPp3j3Pq7dxYGcKNDmFbQ
	WnCY7mYJrNvpadwHx5T/ECNfyBGUJ1nGGf0YuXjYpS6Qh86R6h5Yfj/NKb+Szg==
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Weijie Yuan <wy@wyuan.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Yahya Toubali <yahya@yahyatoubali.me>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] Documentation: admin-guide: fix trailing whitespace
 in cgroup-v2.rst
Message-ID: <aluqleITl23HConW@wyuan.org>
References: <20260718151913.1892547-1-yahya@yahyatoubali.me>
 <20260718151913.1892547-2-yahya@yahyatoubali.me>
 <alumXzlDApA_iMbY@wyuan.org>
 <c8ef86b1-3ed9-47f7-9c1d-f9a0b0676bc0@infradead.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8ef86b1-3ed9-47f7-9c1d-f9a0b0676bc0@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Jul 18, 2026 at 09:16:29AM -0700, Randy Dunlap wrote:
> 
> 
> On 7/18/26 9:14 AM, Weijie Yuan wrote:
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
> I wouldn't include the line numbers...

Alright, it seems that Yahya needs to refine his commit message.

Thanks.
