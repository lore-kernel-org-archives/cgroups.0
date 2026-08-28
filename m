Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D213346AC5;
	Fri, 28 Aug 2026 19:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787946911; cv=none; b=L3lCZQJFTqKTK+wVYZfMO3PTQC0ig3oVyozTCr1rbODg8lXZWfXAEkeMTIbtNUENwddoGqELRJKm1UQu8hYlvIflPPgazV0HQhnKxkCTOVsSSMVVOBE5qa9Ac/6IsWiq80Lz9ZMK/Dbn8NODFC9nvtc7yqzG4zPm7wJGlW3Gl88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787946911; c=relaxed/simple;
	bh=/AovzA25bDI/y80mKNvB9fWMZSq96m267AZyVQkd1I4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=KbQZVstHUcOg9RhsE6lJ4DtiZL3pETk/ThFhyUAF/D7jVQDf1iG5J8qiAaCwy9x0F9nBhgl1y8b0OCfeUAJS/SNgzTRqtcdfz7Gk1CR8JSGP8VN4dlO4PGzQHM4JWkSDyUwTMYdUGC36jo5lTgnkXCfV9zcSmD1SO6v2uIfTVNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0mAyBXDC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0mAyBXDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A951F000E9;
	Fri, 28 Aug 2026 19:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787946910;
	bh=RxINNOOACjMYXoYatrs0c86mnfYNcZa83lnprus68gY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=0mAyBXDCnNaw5HLncu9rKGdX9UpyZ+k1g/LvILACWZs2IKSyNRxxNjw6X5jUh9cDn
	 ZoJYwVqp74Dx8dniGuBKTe3SXugx9wK7K2Ilkq/uvFfwM/JGiiTrLdu1kU8xef+l0C
	 ASoR6UIQen/UL8X/ITMZ12tA3xD2zYqbddoZresU=
Date: Fri, 28 Aug 2026 12:55:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org, Johannes
 Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman
 Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
Message-Id: <20260828125509.83d2e242534c2209ca253504@linux-foundation.org>
In-Reply-To: <apHgs2ZAxAdy8WIH@linux.dev>
References: <20260828135036.7d44361f@fangorn>
	<20260828122018.1a3b3be204212837fcda8e50@linux-foundation.org>
	<apHgs2ZAxAdy8WIH@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 28 Aug 2026 12:26:15 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> On Fri, Aug 28, 2026 at 12:20:18PM -0700, Andrew Morton wrote:
> > On Fri, 28 Aug 2026 13:50:36 -0400 Rik van Riel <riel@surriel.com> wrote:
> > 
> > > When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
> > > isolation, schedule_drain_work() can drop the work in a separate RCU
> > > critical section, and housekeeping_update()'s synchronize_rcu() can race
> > > that second check, leaving the flag set.
> > > 
> > > drain_local_stock() only clears the bit for work that ran, so the flag
> > > remains set and the stock is never drained again.
> > > 
> > > Have schedule_drain_work() return whether the work was queued, and clear
> > > FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
> > > isolated, so future drains can retry.
> > 
> > Is there some Reported-by: or reproducer for this?
> > 
> > Given the complexity of the reproducers which Gemini developed for me, I'm
> > suspecting "nope".
> > 
> > > Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> > > Cc: stable@vger.kernel.org
> > 
> > Why is a backport being proposed?  How does that benefit those we
> > serve?
> > 
> > Sashiko suggests that we ain't done yet:
> > 	https://sashiko.dev/#/patchset/20260828135036.7d44361f@fangorn
> 
> Haha we are never done. Just sent the fix for this new report:
> 
> http://lore.kernel.org/20260828192419.3057939-1-shakeel.butt@linux.dev

Cool.

And... guess what?
	https://sashiko.dev/#/patchset/20260828192419.3057939-1-shakeel.butt@linux.dev
