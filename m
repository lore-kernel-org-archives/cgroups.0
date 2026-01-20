Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB963A4F5B
	for <cgroups@vger.kernel.org>; Tue, 20 Jan 2026 21:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768944069; cv=none; b=M0iIp957XI4DwFF3jwVUBwfgRkGElrBSQtvTJqFJZKGdWrManGNlAmksGEWMvNHDRy//ers0TZc6vlMrqPdqi7/KCDSN/pLnJKAo5Zu/CCkJemlgb32ZbTBtlwfHYQ0KclZx07+2yZA7BehaE74sApygmSgeNgr6l/Wgu5LwKzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768944069; c=relaxed/simple;
	bh=e6W4BifA5HvGHrDS6Cz6FjIkz1q7lelYIgz6NgrsTCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXPuRPVQPu87nRFvz2W+zEC93YRUFH4NqBpxXBdhjN4Yn0KhdMaMlhYQxKr34lHgL+pb8P4JOAzhhZqu9XOlEsr+GEP1QmPtCNUSJbRrm6s7LVRf0jEuZ8e40p88cLwqPrMpgReGcBvvSYAvJTmAqpc4JM2aB1wKs805DjHg9FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c85e1UcQ; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c85e1UcQ"
Date: Tue, 20 Jan 2026 13:20:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768944052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yb9J55L/oOgj+YxKZBhjF2oPSx3+TwVoTURevVUwM98=;
	b=c85e1UcQiD93oYWn8CGxFNRUdeC/dijRaVuPuqh/n1pqqs4pLlBB5oXTGsSy1VX4rPt/KA
	cY+uAKK3+ANKyfSoJK1d4RoG9OsWJHnDimqQ9lNQPiGBfCATF9PvPZvDhq6jTMC6/FOTId
	jf4QJhRkdiOL28wH4NTZ8E988vqbaAk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, 
	syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Minchan Kim <minchan@kernel.org>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
Message-ID: <aW_xUoiCM6Po1Pm0@linux.dev>
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
 <20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
 <CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
 <CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
 <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 18, 2026 at 12:53:11PM -0800, Andrew Morton wrote:
> On Sun, 18 Jan 2026 12:31:43 +0530 Deepanshu Kartikey <kartikey406@gmail.com> wrote:
> 
> > > >
> > > > That's
> > > >
> > > >         VM_WARN_ON_ONCE(oldid != 0);
> > > >
> > > > which was added by Deepanshu's "mm/swap_cgroup: fix kernel BUG in
> > > > swap_cgroup_record".
> > > >
> > > > This patch has Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT"),
> > > > which is six years old.  For some reason it has no cc:stable.
> > > >
> > > > Deepanshu's patch has no reviews.
> > > >
> > > > So can I please do the memcg maintainer summoning dance here?  We have a
> > > > repeatable BUG happening in mainline Linux.
> > > >
> > >
> > > Hi Andrew,
> > >
> > > I checked the git blame output for commit 0f853ca2a798:
> > >
> > > Line 763: memcg1_swapout(folio, swap);
> > > Line 764: __swap_cache_del_folio(ci, folio, swap, shadow);
> > >                     (d7a7b2f91f36b - Kairui Song, 2026-01-13 02:33:36 +0800)
> > >
> > > Kairui's reordering patch appears to have been merged on Jan 13.
> 
> Eek, there are many patches, it helps to identify them carefully.
> 
> I think you're referring to
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch
> 
> > > The syzbot report is also from Jan 13, likely from earlier in the
> > > day before the reordering patch was merged.
> > >
> > > So this report is from before the fix. The warning should not appear
> > > in linux-next builds after Jan 13.
> > >
> > > Thanks,
> > >
> > > Deepanshu
> > 
> > Hi Andrew,
> > 
> > I tested with the latest linux-next in sysbot. It is working fine
> 
> Great, thanks.  But we still don't have review for this one.
> 
> For some reason I don't have cc:stable on this - could people
> make a recommendation?
> 

I will get to this in couple of days (hopefully sooner). I think
Johannes was looking into this as well.

