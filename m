From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Wed, 27 Apr 2022 11:36:54 -0700
Message-ID: <20220427113654.ef8f543d7ba279952deff6f7@linux-foundation.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
        <20220427160016.144237-5-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651084615;
        bh=OMICTGO/WYqPH3eg8uS6ToJj8mhJ9pJAhueCepETYGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mL5WuWxE1oAHwTgDVWF/ZSPjveU0MDpd5Uvw46vXoBCYn2+/LaKGjCRkzm4GlsAIM
         7b/mKi2m9pR5S0iab7gFXcUa6WjTZ82mYZgSVkrTfOxFluiScSimCscnu58NstAxiI
         U9cw/bYMDrCdB3fqlz02HDDXeqW1WRZ9YtXIArtE=
In-Reply-To: <20220427160016.144237-5-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, 27 Apr 2022 12:00:15 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> Currently it requires poking at debugfs to figure out the size and
> population of the zswap cache on a host. There are no counters for
> reads and writes against the cache. As a result, it's difficult to
> understand zswap behavior on production systems.
> 
> Print zswap memory consumption and how many pages are zswapped out in
> /proc/meminfo. Count zswapouts and zswapins in /proc/vmstat.

/proc/meminfo is rather prime real estate.  Is this important enough to
be placed in there, or should it instead be in the more lowly
/proc/vmstat?

/proc/meminfo is documented in Documentation/filesystems/proc.rst ;)

That file appears to need a bit of updating for other things.
