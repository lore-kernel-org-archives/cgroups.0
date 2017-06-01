From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [PATCH 2/6] mm: vmstat: move slab statistics from zone to node counters
Date: Thu, 01 Jun 2017 20:07:28 +1000
Message-ID: <87mv9s2f8f.fsf@concordia.ellerman.id.au>
References: <20170530181724.27197-1-hannes@cmpxchg.org> <20170530181724.27197-3-hannes@cmpxchg.org> <20170531091256.GA5914@osiris> <20170531113900.GB5914@osiris> <20170531171151.e4zh7ffzbl4w33gd@yury-thinkpad>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170531171151.e4zh7ffzbl4w33gd@yury-thinkpad>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yury Norov <ynorov-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Yury Norov <ynorov-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org> writes:

> On Wed, May 31, 2017 at 01:39:00PM +0200, Heiko Carstens wrote:
>> On Wed, May 31, 2017 at 11:12:56AM +0200, Heiko Carstens wrote:
>> > On Tue, May 30, 2017 at 02:17:20PM -0400, Johannes Weiner wrote:
>> > > To re-implement slab cache vs. page cache balancing, we'll need the
>> > > slab counters at the lruvec level, which, ever since lru reclaim was
>> > > moved from the zone to the node, is the intersection of the node, not
>> > > the zone, and the memcg.
>> > > 
>> > > We could retain the per-zone counters for when the page allocator
>> > > dumps its memory information on failures, and have counters on both
>> > > levels - which on all but NUMA node 0 is usually redundant. But let's
>> > > keep it simple for now and just move them. If anybody complains we can
>> > > restore the per-zone counters.
>> > > 
>> > > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
>> > 
>> > This patch causes an early boot crash on s390 (linux-next as of today).
>> > CONFIG_NUMA on/off doesn't make any difference. I haven't looked any
>> > further into this yet, maybe you have an idea?
>
> The same on arm64.

And powerpc.

cheers
