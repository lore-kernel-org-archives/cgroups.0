Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C75318ED6;
	Thu, 20 Aug 2026 22:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787266558; cv=none; b=Hkrz2PQY0GaYHW9ltZAh5Zp2qm2dEVzbFz/RonLQjsFYdjnHz/HVOSv/+k4Apx4C0CnHO1NQM9zOOpxpkTc4G3I/J0QZ8B48Ev2NHM3oB6B4F8Grk6kKm+yiLFFg9c/cChrb3d9GHPca0AlXQ3GmOeMRiLUsphxT7VAxVw6aUfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787266558; c=relaxed/simple;
	bh=x2tT4BtfMNQmLIwPodIAGkZrpNJc674VnikSkJcw1Kg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Z8tpZsCcyfjZfwbmqJleiCW8OrDtSIvdxhW8ZmlgE5BZcLRUqaoE7UQCKXQqbuufDlOGgzKdv7z0+znj6GLBMxEn7Y2CkUqDu2Gs9sqkYqeUd15Mqu80NmZkGh9+rQ5js1OuEpQ/rP3O3OH1g/ZfoIYxC41JDqD7XKrqH9k/tqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KagyFWw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KagyFWw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30651F000E9;
	Thu, 20 Aug 2026 22:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787266557;
	bh=kZunpZo4Ob7dnPPiEiET46yjsPwCJrXBRNVqc/tVrdQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KagyFWw9ORjX2tEGt6I0GhwPXz7Faeh+XtuJ2G6+yrCkLoiI8DD7BLwGrFSunUGRI
	 0/gv1sXhQgT/wnF8PVsfDocPpDMvsS67TGwyZmGiB0tGJpu9czF9bTTguU9uyV5Lc/
	 /eAbqtVGTdJs0lc/dSCbyLDtxGZJ8zov53EVfH2w=
Date: Thu, 20 Aug 2026 15:55:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David Finkel
 <davidf@vimeo.com>, Tejun Heo <tj@kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, Tao Cui
 <cuitao@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v4 0/2] mm, memcg: fix memory.peak reset clobbering
 other fds' watermark
Message-Id: <20260820155556.8e95067fe0402cd83ed48dab@linux-foundation.org>
In-Reply-To: <ee4cd3ab-0708-4c37-b597-703a7d7547e2@linux.dev>
References: <20260814033005.2481920-1-ridong.chen@linux.dev>
	<ee4cd3ab-0708-4c37-b597-703a7d7547e2@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Aug 2026 16:43:23 +0800 Ridong Chen <ridong.chen@linux.dev> wrote:

> 
> 
> > 
> > Ridong Chen (2):
> >    memcg: acquire peaks_lock when reading memory.peak
> >    mm, memcg: fix memory.peak reset clobbering other fds' watermark
> > 
> >   mm/memcontrol.c | 9 ++++++---
> >   1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> 
> Hi all,
> 
> Just a quick reminder on this series, could it be applied?
> Sending this note in case it got buried.

New material doesn't get a lot of attention during late -rc and during
the merge window.  I've set this series aside for consideration late in the
merge window, but a resend at that time (or shortly after -rc1) would
be helpful.

