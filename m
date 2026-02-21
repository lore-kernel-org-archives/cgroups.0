Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E223F330B10
	for <cgroups@vger.kernel.org>; Sat, 21 Feb 2026 05:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771650005; cv=none; b=NTGWqomIbjfp8fvgZWrBO1z8e3Hv/6xBscbZsmqZKxD9TXrBIhrk73/1B2vgvCiDiL70vVaBtTjDK5bEZLaGFqL93s2CbH417J8hFPO4l/rodhf5M5VcdBXhosGhc0ykO0B6K7yR7FjXcslSJo4sQ9u6WiU+e5ESP1OAZ/vyOBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771650005; c=relaxed/simple;
	bh=nIHRFETa+mfqscZ+L9F7k2yrT7xUcD+4wVtBJfvxgHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKHo0oGWWKZDeVt+ooLNj2YRpAyjAhP7ZegiewJM75cLZHbrJHpYlCDqA29ZX520LAMSkncflcfoLmft84BRudDvaoinugVHz0RWHurns4XPCeaNFYha8Fkpd6PUq2HW1Xp2LiH5blkOYSPqPln8n42iZcBScP+h41KL+Mua7Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p5j6GwKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p5j6GwKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1A8C4CEF7;
	Sat, 21 Feb 2026 05:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771650004;
	bh=nIHRFETa+mfqscZ+L9F7k2yrT7xUcD+4wVtBJfvxgHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p5j6GwKRu+h0FpvrdPcjV3zN9jsa5UAmtuvY/Ycg80tolP25eb+Qh3ZWTP8kZJj5l
	 Qg3KE+Z7a+Q8Lm1nwlCajxPB/d2+48OqWMGZvb8XtjWd3wmrlaTRTKb8rQUwfAIurO
	 rr9smbDAc8lI9G6Qv8CTSVwK5N9izaqpCCWLykvXWOYa7yC2aa/2ELfH8LvhgHHv8r
	 lDVzOebSovERn+LEDIMRiI/PuFn9mzNWYMHe8p2QqZtLfLUtUPby23aNBXLN1gQg2H
	 7GDj7HP0ECO7q3ErgluTgcoB83kuUc3QkiXpRqCBrD3P2206jrr2rlqQM6KlgIfdVf
	 wsAjtjvC4gSwA==
Date: Fri, 20 Feb 2026 19:00:03 -1000
From: Tejun Heo <tj@kernel.org>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org
Subject: Re: [PATCH] cgroup: ensure stable pid sorting in cmppid()
Message-ID: <aZk707rPX4DrQIWb@slm.duckdns.org>
References: <20260221034907.2110829-1-kaushlendra.kumar@intel.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260221034907.2110829-1-kaushlendra.kumar@intel.com>

Hello,

On Sat, Feb 21, 2026 at 09:19:07AM +0530, Kaushlendra Kumar wrote:
> The subtraction-based comparator (a - b) in cmppid() can
> overflow for large pid_t differences, producing incorrect
> sign values. This breaks qsort() ordering guarantees and
> may cause unstable or wrong sort results in pidlist output.

Can you give examples of such an overflow? What values would cause that?

Thanks.

-- 
tejun
