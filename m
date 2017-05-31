From: Yury Norov <ynorov@caviumnetworks.com>
Subject: Re: [PATCH 2/6] mm: vmstat: move slab statistics from zone to node
 counters
Date: Wed, 31 May 2017 20:11:51 +0300
Message-ID: <20170531171151.e4zh7ffzbl4w33gd@yury-thinkpad>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-3-hannes@cmpxchg.org>
 <20170531091256.GA5914@osiris>
 <20170531113900.GB5914@osiris>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=CAVIUMNETWORKS.onmicrosoft.com; s=selector1-cavium-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2D7mfEJmt7KA+rORPbsIvkb1+eFZA3NGkzGzX+BTQBU=;
 b=MQB7z9P57oN7aWjjL7VoFMFuU/sUMJ8HaqoJSGpVI5lu2p/0UWRlRDlPSzLxxW5jaIxFh/GRp8/ueM6K2gEiB3LY8LCVo7zBjFkFNHC2d/NRQkZjUo8tbkGfkv8vM/eZWt17pdKk0C6X7pZclooDHzRvK2au6zpxy8tcpLuYJrc=
Content-Disposition: inline
In-Reply-To: <20170531113900.GB5914@osiris>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-s390@vger.kernel.org

On Wed, May 31, 2017 at 01:39:00PM +0200, Heiko Carstens wrote:
> On Wed, May 31, 2017 at 11:12:56AM +0200, Heiko Carstens wrote:
> > On Tue, May 30, 2017 at 02:17:20PM -0400, Johannes Weiner wrote:
> > > To re-implement slab cache vs. page cache balancing, we'll need the
> > > slab counters at the lruvec level, which, ever since lru reclaim was
> > > moved from the zone to the node, is the intersection of the node, not
> > > the zone, and the memcg.
> > > 
> > > We could retain the per-zone counters for when the page allocator
> > > dumps its memory information on failures, and have counters on both
> > > levels - which on all but NUMA node 0 is usually redundant. But let's
> > > keep it simple for now and just move them. If anybody complains we can
> > > restore the per-zone counters.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > This patch causes an early boot crash on s390 (linux-next as of today).
> > CONFIG_NUMA on/off doesn't make any difference. I haven't looked any
> > further into this yet, maybe you have an idea?

The same on arm64.

Yury

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
