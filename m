Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA844246762;
	Mon, 12 Oct 2026 13:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811363; cv=none; b=hgC4LFhSVBXpuUvjDCYH+1aCup8/VhUfXVKP4a6QjYRULNxw7akmX8uABZhtb4JkPZnfJdROsmi3Q/W/vv+aeKLr0kGjrgHMquqU8NKjQyJRP0f5WKr4qfvfkpkjy6DbvcgI6lusMmOzsViaZSCeVBPYZZh5gkeNGLDCYwMmaU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811363; c=relaxed/simple;
	bh=4/e18N9+Fr54fAXZF7l0uS4NMCXHLiC248+an3n7aHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2LDy0tkT2jak6y09+PYTnZO3SGeUQhhMpbLnM36du8FTqsB3YcyiHFZAZBi+IsdQAtpa5r3vktHyCcbxJkhlo5dZTPNQ3SUFE9vs1EpMemzkN/pvpd46hq/yKuOBsd1Dlzar3V3V+024LKIpck87hzYcICWbuxfBHmj3CqUnUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btTTHYYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btTTHYYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0730A1F0089B;
	Mon, 12 Oct 2026 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811362;
	bh=SA1zA/aAvAwyDwvxG0nvSn2x6K8KbSluBej6fUI3IPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=btTTHYYFNly5SSsCMvsGH+d2DrUwpVRzNThCqYYA7da83/hK0I4xv54N7bhfBlcC+
	 9wHdVxn7bjee/ausHuG0D9lonsegBCHePgk3udpGdMhjvHv6RYs/3PSGu4lXzCFD05
	 0eYpIMrru2GleSTWPxb6OigdQ+OGtu6uFFt1Z5oBs2pAH3i6MRlDLBsou9BN3qmKMr
	 Y85nU1bkSAhdJB5VP7l+Z6HFp6Aq+Wst4jlfv2fgY+l03w0BWK6wP5Pz/eMsI+qF5C
	 zBdReAzEVgi6xoo5eqDXJ1qShfTCbWayz2+RjZ8thRf2SS1C2YPyR8xNdzc4+89TTb
	 i02u5pPh1E7Dw==
Date: Mon, 12 Oct 2026 14:22:40 +0100
From: Harry Yoo <harry@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 1/5] memcg: move memory.high enforcement out of
 try_charge_memcg()
Message-ID: <aszdXDpqLUX1S4Qq@thinkstation>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-2-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010210957.1350874-2-shakeel.butt@linux.dev>

On Sat, Oct 10, 2026 at 02:09:53PM -0700, Shakeel Butt wrote:
> try_charge_memcg() does a lot. It charges the page counters, reclaims
> when a limit is hit, may call the OOM killer, and at the end it checks
> and enforces memory.high. Move the memory.high part into a new function,
> memcg_enforce_high(), so that try_charge_memcg() is shorter and the
> memory.high code is easier to read and change.
> 
> The code and its comments move as they are. The only difference is that
> the new function gets allow_spinning from gfp_mask itself.
> 
> No functional change.
> ---

Missing Signed-off-by: ?

Otherwise LGTM.
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon
