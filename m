Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F1A3CBE6C
	for <cgroups@vger.kernel.org>; Tue, 10 Mar 2026 16:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773160924; cv=none; b=LrWT3zF2gIDBlQFbmbPeDo010jeXLHLODnQ4Ingu4MGjEWccNeaiuWRK3uVGEq/Y0gsEXE9qAuzOPFdCnBzCDcOPoHKZTJVJpn/V4ujM+HNcScFJLGjrc2Y8WoiBt+etT96LuZDj1xHYF8yzdEiqE/GwtShFIf5eROr2tWxSz84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773160924; c=relaxed/simple;
	bh=/aLplYdePr8Ibvpfq3IUfZZ2Ey+9ddHImBavjZCWj3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZ71wPj9KPx/ZBMDIhpCHp28AZ4n6wAbxETLEsf6p1/WRJx+wQ5SUD3hsEMgrc1IemRqXBp49xiAfHSRMgo+isVCGlshX+1ydAcFBp492qGet22WE8OK5j6cYBvOBmO6RJUUxHTq7xCGK0TieYaUriM/XFwzwiRbtI+T2rxGBRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gps2BGTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gps2BGTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9A0C19423;
	Tue, 10 Mar 2026 16:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773160923;
	bh=/aLplYdePr8Ibvpfq3IUfZZ2Ey+9ddHImBavjZCWj3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gps2BGTSmCynBiQ+dgImMDvQL9YRUcjDXD5KJ8P7sbjkbOr7BmBwkNvuTrNx6B0ot
	 fdpvasDLA3VHFiTR3MUFg9xNe7GJL5dNp+0yNBldzugOUaOND6+ODExNbLeIDHaJgy
	 ogwbgoTGQy4c4ZiOo1+9Y7jLzxG3wqWFYV6fBfg6xBXu/HEnKAeNRH6JNpxuwTlMh/
	 TvVQmHO6ov19f0/nx/K+y71xw1iXX/5qizSmCg1Q8RDKs8MSMVcnJT+66FkaQYC8Gi
	 EdFpSDpYMCwPvH2Vttmr+8qv+q2cusBxvmXWjA1BERcYlshFWf+Gpwx8aNFaSTQ/GR
	 6sFkxT5tqUNvA==
Date: Tue, 10 Mar 2026 06:42:02 -1000
From: Tejun Heo <tj@kernel.org>
To: Natalie Vock <natalie.vock@gmx.de>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Tvrtko Ursulin <tursulin@ursulin.net>, cgroups@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v5 2/6] cgroup,cgroup/dmem: Add
 (dmem_)cgroup_common_ancestor helper
Message-ID: <abBJ2ozm3QS2ozki@slm.duckdns.org>
References: <20260302-dmemcg-aggressive-protect-v5-0-ffd3a2602309@gmx.de>
 <20260302-dmemcg-aggressive-protect-v5-2-ffd3a2602309@gmx.de>
 <c87a99bc-5481-444e-8841-b09d20016cfd@linux.intel.com>
 <893f4113-bbc9-4947-8bb2-a4d02d9714fb@gmx.de>
 <5b8f3944-edb3-4b14-85a6-060295e0237a@gmx.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b8f3944-edb3-4b14-85a6-060295e0237a@gmx.de>

On Tue, Mar 10, 2026 at 01:48:47PM +0100, Natalie Vock wrote:
> Hi,
> 
> On 3/5/26 21:02, Natalie Vock wrote:
> > On 3/2/26 15:38, Maarten Lankhorst wrote:
> > > Hey,
> > > 
> > > This should probably have a Co-developed-by: Tejun Heo <tj@kernel.org>
> > 
> > Oh, that's a good point, sorry!
> > 
> > Although, I think I also need to add a S-o-b tag, then, don't I?
> > 
> > Tejun, just to confirm, would you be fine with that? Wouldn't want to
> > claim people certify something without talking to them first :P
> 
> Friendly ping on this :)
> 
> I intend to send out a new version with the outstanding feedback addressed,
> although I'd like to resolve this before I do that.

Sorry about the delay. It doesn't really matter. No need to attribute
anything.

Thanks.

-- 
tejun
