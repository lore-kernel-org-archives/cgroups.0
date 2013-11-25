From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v11 00/15] kmemcg shrinkers
Date: Mon, 25 Nov 2013 12:41:35 -0500
Message-ID: <20131125174135.GE22729@cmpxchg.org>
References: <cover.1385377616.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=MFFm9bGwQpgLYpjU880uRrOlk1U8mdG6l99wxjTofMk=;
	b=Jxzzldl+pM6faCFHHEQPYBUv8gte5pX35G0+GHSAsT4XusT+Uu487HSmlBwIEQLwYcRjBqHfm7RuzJPah4Sfhnvf7xSBYrP9Tv87iekVQ4UeajzQ5py0S6bcV3jfmHt7XL1Y6ufc97t/5u2blGLeO872ohRIwRfjXMHP57ewnBE=;
Content-Disposition: inline
In-Reply-To: <cover.1385377616.git.vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

I ran out of steam reviewing these because there were too many things
that should be changed in the first couple patches.

I realize this is frustrating to see these type of complaints in v11
of a patch series, but the review bandwidth was simply exceeded back
when Glauber submitted this along with the kmem accounting patches.  A
lot of the kmemcg commits themselves don't even have review tags or
acks, but it all got merged anyway, and the author has moved on to
different projects...

Too much stuff slips past the only two people that have more than one
usecase on their agenda and are willing to maintain this code base -
which is in desparate need of rework and pushback against even more
drive-by feature dumps.  I have repeatedly asked to split the memcg
tree out of the memory tree to better deal with the vastly different
developmental stages of memcg and the rest of the mm code, to no
avail.  So I don't know what to do anymore, but this is not working.

Thoughts?
