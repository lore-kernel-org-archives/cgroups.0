Received: from mta0.migadu.com (out-209.mta0.migadu.com [91.218.175.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0B9469821
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 17:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791825192; cv=none; b=K1DF94mpVgsYdP/V/BJDiMONpVHZ5a91p0BJlf5oyD6VimBQrNWYwvsJq8fqwYYFHWEcIqHyqcEQD1EbtbcgjHu0vK26doJz+zCB897PccXrxFvQMDiulnz+Rl7nESUMj1RVzNh/yNeAaquK8HPK8r58m52sBoJHwwsfu+5jzKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791825192; c=relaxed/simple;
	bh=ic4+7nPuzg/HmHoJ2BxucAspSzm/umEUsEWucPmNFHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2KiGs5h6nN1A8aK197K1+98T/e71No3+N74VrsQDmieklDdk9Wt+jR9DZ0RCT+AFy9cc2/iLQTyJbA9xAadBm+9Q4Im8DyX/acDGr/WMA7RDsIkXRo9i68RjYe2bRebUJ6cSDJTcqE4xIuanEhoKY+ljJu0iUuzYj2xjlDsaaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cyB8tXet; arc=none smtp.client-ip=91.218.175.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cyB8tXet"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ic4+7nPuzg/HmHoJ2BxucAspSzm/umEUsEWucPmNFHQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791825188; v=1; x=1792429988;
 b=cyB8tXet0S4df4apJMch8hp4ChFn3KtFj33KQZLWux3HkLcdfrTHxP2jAKNmMKEHshUCv8w8
 6eggwE1VOvCPdgqwcFuwB/zyr6glmCRymX86tL0r2VEi81dBQE6qIxYVWqLhBfWWx4ydyxevu/p
 yzBoemKjX5Lrov3ycJXm/XnQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5adfa5a0e15eca74;
	Mon, 12 Oct 2026 17:13:08 +0000
X-Mizu-Trace-ID: 5adfa5a0e15eca74
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 10:13:06 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 1/5] memcg: move memory.high enforcement out of
 try_charge_memcg()
Message-ID: <as0U-erMrDTG9fkt@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-2-shakeel.butt@linux.dev>
 <aszdXDpqLUX1S4Qq@thinkstation>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszdXDpqLUX1S4Qq@thinkstation>

On Mon, Oct 12, 2026 at 02:22:40PM +0100, Harry Yoo wrote:
> On Sat, Oct 10, 2026 at 02:09:53PM -0700, Shakeel Butt wrote:
> > try_charge_memcg() does a lot. It charges the page counters, reclaims
> > when a limit is hit, may call the OOM killer, and at the end it checks
> > and enforces memory.high. Move the memory.high part into a new function,
> > memcg_enforce_high(), so that try_charge_memcg() is shorter and the
> > memory.high code is easier to read and change.
> > 
> > The code and its comments move as they are. The only difference is that
> > the new function gets allow_spinning from gfp_mask itself.
> > 
> > No functional change.
> > ---
> 
> Missing Signed-off-by: ?

Oh I don't know how I missed this.

> 
> Otherwise LGTM.
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

Thanks for the review.
