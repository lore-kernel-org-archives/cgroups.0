Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBB13B1EC8;
	Fri, 11 Sep 2026 16:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789145860; cv=none; b=eSw9uH/zdq/2a/VXXYWEm5DomR6WcBimInnU0QU+vxdLIJrvNu9USs4L9dQAmdeu1X4XDw0faXeLaDBIc1F952lrRNURII5az9dkJZvC4SW0H1vYiMIw8Ia9V/ecsbyKk0MESO0KdMnlJerBAyefMCq7AtAoAvZacmAqdI2wZlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789145860; c=relaxed/simple;
	bh=Q2v3W0b61GMl7gGnUQ7c8+penetqAlw9A8ubBI1X4Hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngTpNlcuYdFfZm0Milc52WHBmaeTQQObyPCB6QDpHKsQyMw+j5Y1TmJHSNsSWdnELxf9SBglf9evap/ajn8Bf732H93lVKzUSOKT5Tv8qAl8fVRrkRAVz0e1N8lfgWXSTLEoiFCaHwNwHNyQKc1XDW8CI0wj0Ch1pOsNhP+z3uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Deku9Ls4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Deku9Ls4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780631F00893;
	Fri, 11 Sep 2026 16:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789145846;
	bh=tksrUNGbHdaSFb+5rLGabIokdhFX+wv8b1iFL7wLAA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Deku9Ls4TkXJj86McT9Ziakd7EkSopLwLX6bNCEoJSyvmPdm0sUUKMkRl50eQeq5U
	 +SWSzmSwGsxUVkjv7rolW5xYQcA8ETGAuCY465B6n2XW15Nm7hlrQ/N4wrhz8rbIgZ
	 ymTUWkp+7/rCd4SbL6vMAK0kbKpbektQFzgm+pANAOCAN+tfI23dbFMF4Jc4VBp8Sq
	 MRsVSfRyPbLHBg3r7u7acB32HtwgYDxJlliaypdqfLgBHTPJmNFGaEC4L1rI3gs1ii
	 JPahsopeOALJ/4xoIpCgg1xHZ4EEnw8AAt1HUdylBWvZp0Zby8E9nVsFsK/kReFH5P
	 FD7Fy1wGtfLHw==
Date: Fri, 11 Sep 2026 06:57:25 -1000
From: Tejun Heo <tj@kernel.org>
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Noah Feldt <noah@feldt.systems>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, N.Feldt@mittwald.de,
	carnil@debian.org, dschatzberg@meta.com, hannes@cmpxchg.org,
	peterz@infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] cgroup: Avoid iteration of dying tasks with zero
 refcount
Message-ID: <aqQy9UMKmXnKd934@slm.duckdns.org>
References: <20260907192723.72167-1-noah@feldt.systems>
 <aqAtv3WVn51LN3E8@localhost.localdomain>
 <aqQlowpkYrTaVmid@localhost.localdomain>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqQlowpkYrTaVmid@localhost.localdomain>

On Fri, Sep 11, 2026 at 06:11:42PM +0200, Michal Koutný wrote:
> On Tue, Sep 08, 2026 at 05:55:45PM +0200, Michal Koutný <mkoutny@suse.com> wrote:
> > Though, the fix loses a bit of elegance. Hm, thinking...
> 
> So, it occurs to me that the ->live based predicate from v2 might break
> CSS_TASK_ITER_WITH_DEAD callers (zombies they asked for would be
> skipped).
> We need to distinguish between (both on dying_tasks list):
> - regular zombies waiting to be reaped and
> - RCU remnant tasks that are going to be free'd.
> IIUC these two are split on the ->usage count. (Correct me if I'm
> wrong.)
> 
> I'm starting to like the tryget_task_struct() approach from v1 again.

Yeah, let's go back to v1. Sorry about the noise.

Thanks.

-- 
tejun
