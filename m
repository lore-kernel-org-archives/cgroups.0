From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/5] mm: zswap: add basic meminfo and vmstat coverage
Date: Wed, 27 Apr 2022 14:53:08 -0400
Message-ID: <YmmRFOXJsjLj4a7T@cmpxchg.org>
References: <20220427160016.144237-1-hannes@cmpxchg.org>
 <20220427160016.144237-5-hannes@cmpxchg.org>
 <20220427113654.ef8f543d7ba279952deff6f7@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5Bxi6KofN0Ih5O2P5EXy7XNcKRJLdVQH6xt19JcR/Cc=;
        b=65NapwWd4Bu52BgiMzSrFcem1E52ZJnpS0GWN6sZuF8lZ5D+NZ9Ww0Anh9KupdJguI
         UzAS0QkUzTyoa4mXefmL3ncFHMeJEYGiv8Y4ZWUY5GqWqlu6l8H3TeskMI6hQscaCpfY
         xFTNfO8WOciEzvX0JjGttg51D/9bWg1IxH7Q9heQTyN0Ax1r1H6fpSgxb1qUOYSOt4/b
         VLQI177Dk/OGl9IygOnXPdYVJLVXXFN59R2Qt3TQ2OMHxqMptwsfkrNXKPx5A6KaTz0c
         ZfjzEibO+5o5S6D/+WwZ8cM2fs2lXZy9mXt7BWxQ6A3lY0GIvJq4h5tUVYWmcEZW3FdV
         8Jzw==
Content-Disposition: inline
In-Reply-To: <20220427113654.ef8f543d7ba279952deff6f7@linux-foundation.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Seth Jennings <sjenning@redhat.com>, Dan Streetman <ddstreet@ieee.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Apr 27, 2022 at 11:36:54AM -0700, Andrew Morton wrote:
> On Wed, 27 Apr 2022 12:00:15 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > Currently it requires poking at debugfs to figure out the size and
> > population of the zswap cache on a host. There are no counters for
> > reads and writes against the cache. As a result, it's difficult to
> > understand zswap behavior on production systems.
> > 
> > Print zswap memory consumption and how many pages are zswapped out in
> > /proc/meminfo. Count zswapouts and zswapins in /proc/vmstat.
> 
> /proc/meminfo is rather prime real estate.  Is this important enough to
> be placed in there, or should it instead be in the more lowly
> /proc/vmstat?

The zswap pool size is capped to 20% of available RAM, and we usually
have a utilization of tens of gigabytes. I think it's fair to say it's
a first class memory consumer when enabled, and actually a huge hole
in /proc/meminfo coverage right now.

> /proc/meminfo is documented in Documentation/filesystems/proc.rst ;)
> 
> That file appears to need a bit of updating for other things.

"The following is from a 16GB PIII, which has highmem enabled."

lmao.

I'll send a general update for that, and a delta fixlet for 4/5.

Thanks!
