From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH] Revert "memcg: cleanup racy sum avoidance code"
Date: Thu, 18 Aug 2022 12:04:46 +0200
Message-ID: <20220818100446.GA789@blackbody.suse.cz>
References: <20220817172139.3141101-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660817088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yGB57PLr3/XCzM4eFzUWiwdrtPGGJcwk3YhcDibPx8M=;
        b=gvEy9i+g+y8d7rIZ0U0o86DQsVZwmbcNxlRYSpGPZr0T18g6ijVFRl1wyUxyWXaJJFfxPx
        9qoD12WHed4RQwOShceW3e3jpd7+bBtOWgXhiU9NWNAk7soVGUTTfqS40al6REZE5TWySi
        1MximM3wxgOE7vjWSPav2gtm55geZkg=
Content-Disposition: inline
In-Reply-To: <20220817172139.3141101-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

On Wed, Aug 17, 2022 at 05:21:39PM +0000, Shakeel Butt <shakeelb@google.com> wrote:
> $ grep "sock " /mnt/memory/job/memory.stat
> sock 253952
> total_sock 18446744073708724224
> 
> Re-run after couple of seconds
> 
> $ grep "sock " /mnt/memory/job/memory.stat
> sock 253952
> total_sock 53248
> 
> For now we are only seeing this issue on large machines (256 CPUs) and
> only with 'sock' stat. I think the networking stack increase the stat on
> one cpu and decrease it on another cpu much more often. So, this
> negative sock is due to rstat flusher flushing the stats on the CPU that
> has seen the decrement of sock but missed the CPU that has increments. A
> typical race condition.

This theory adds up :-) (Provided the numbers.)

> For easy stable backport, revert is the most simple solution.

Sounds reasonable.

> For long term solution, I am thinking of two directions. First is just
> reduce the race window by optimizing the rstat flusher. Second is if
> the reader sees a negative stat value, force flush and restart the
> stat collection.  Basically retry but limited.

Or just stick with the revert since it already reduces the observed
error by rounding to zero in simple way.

(Or if the imprecision was worth extra storage, use two-stage flushing
to accumulate (cpus x cgroups) and assign in two steps.)

Thanks,
Michal
