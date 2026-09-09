Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D3039B497;
	Wed,  9 Sep 2026 18:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788980400; cv=none; b=H/j4RXMhK1rGSHteGrA+Lh2ur6Hl8dRPyXLyyVXj+f0uN824sBxJ9bzabvNPjQWrPvPptg9tthB/CGoqOXhBuXIW34TiVc9ViAL73oAZQlptIMhbTrNApqAOLXLt3d9cunWDw0Ki95xS0qrvnXCNb5mkffyz+450XfIvnLq7brA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788980400; c=relaxed/simple;
	bh=XJKJ7anL7hXoTXFizwsDHiJ3oit7/vRl3YUppSqzpB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YwTHijIzp/g6pUEXZlMOyiSFHt8/EtKa63xigxi5oz/t719dnMOs9IRbMlUTdS1fB7KSn+VdNoOmwPZ7YzRty9gA944xBOv+sNsB/nmNO0uVrXyIb9b1V+WbRQXJGFiGSLUO3XY6xNvm9PWoAOCnWiiIsT/WL5rSVjY9kK4GrnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M1Q+eEm/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M1Q+eEm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A59211F000FF;
	Wed,  9 Sep 2026 18:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788980398;
	bh=FUYw9ieBaMi9B5CXc3nNfGkqutWFJDcR4LezWBU8ycc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M1Q+eEm/pjRG9p35tZ2tq7sBCyQ7YjpNO0MNx3uV5+xK8ugC2Vjj1A7/gdJtdv5iT
	 gCyuHYYLuttZv8t0oUi5lzZi8SDVrn6BBjnLycPCL20X/3kCdNS4rW5zRTBkExKKfI
	 yeClu/L6NNoswf+Im2oOinEWfvFuOtXnqrAgaNC6NH3XPKG71KaKTCa6/S6S4iPTEK
	 Q9+h77zkGBXiA1BYxFGPpCBcz9GJNyLD1WAWqYmSp1Z0THX+cJr40XifoGRFqOKTFr
	 Li3VyrooVn/0XoBd31V1CqSzGkknLmVIqO36kzgOkjWj72QdJ40VItqyewg4rw1ijf
	 QASdi5vXKxwwQ==
Date: Wed, 9 Sep 2026 08:59:57 -1000
From: Tejun Heo <tj@kernel.org>
To: Junnan Zhang <zhangjn_dev@163.com>
Cc: Michal Koutny <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Shouxin Sun <sunshx@chinatelecom.cn>
Subject: Re: [PATCH v3] cgroup: avoid flushing global workqueue in
 cgroup1_pidlist_destroy_all
Message-ID: <aqGsrY9Vj57CsVeb@slm.duckdns.org>
References: <aqA6x_8E3Xiewoso@slm.duckdns.org>
 <20260909084619.91579-1-zhangjn_dev@163.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909084619.91579-1-zhangjn_dev@163.com>

Hello,

On Wed, Sep 09, 2026 at 04:46:19PM +0800, Junnan Zhang wrote:
> Would you consider taking it as a minimal fix? Or, if the consensus
> is to leave v1 completely untouched, what would be the recommended
> course for production systems that keep hitting this?

The problem is that the root cause isn't sufficiently established. It's just
difficult to believe cleaning up these lists would take longer than 120s in
itself. Maybe there were other contributing factors - e.g. another
saturating per-cpu work item that was preventing the execution of the
pidlist work item, high memory pressure stalling worker creation, or just
severe CPU contention from bw control or whatnot.

Without the root cause convincingly established, this can't be a "minimal
fix". This can be a proactive behavior improvement, but that's not something
we want to do for cgroup1 code base at this point. Not because we hate
people on cgroup1 but because they're the legacy users on legacy code base.
Nobody is actively working on it and no leading edge testing and adoption
covers it. Any change carries risk of breakage and a change like this can
lead to really subtle problems that can take a long time to diagnose
especially with slow-moving long-tail userbase.

So, yes, I'll take minimal fixes that address real problems (subject to risk
vs. benefit balance of course), but you haven't established that yet.

Thanks.

-- 
tejun
