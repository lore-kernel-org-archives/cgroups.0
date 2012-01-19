From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [BUG] kernel BUG at mm/memcontrol.c:1074!
Date: Thu, 19 Jan 2012 16:49:19 +0000
Message-ID: <20120119164919.GE3143@suse.de>
References: <1326949826.5016.5.camel@lappy>
 <20120119122354.66eb9820.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LSU.2.00.1201181932040.2287@eggly.anvils>
 <20120119130353.0ca97435.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.LSU.2.00.1201182100010.2830@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1201182100010.2830-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Jan 18, 2012 at 09:16:09PM -0800, Hugh Dickins wrote:
> > 
> > Another question is who pushes pages to LRU before setting pc->mem_cgroup..
> > Anyway, I think we need to fix memcg to be LRU_IMMEDIATE aware.
> 
> I don't think so: Mel agreed that the patch could not go forward as is,
> without an additional pageflag, and asked Andrew to drop it from mmotm
> in mail on 29th December (I didn't notice an mm-commits message to say
> akpm did drop it, and marc is blacked out in protest for today, so I
> cannot check: but certainly akpm left it out of his push to Linus).
> 
> Oh, and Mel noticed another bug in it on the 30th, that the PageLRU
> check in the function you quote above is wrong: see PATCH 11/11 thread.
> 

Yes, that patch is broken. According to the mm-commits list, it was
"withdrawn" on December 30th. I do not know why it is still in
linux-next but AFAIK, it is not expected to end up in mainline. I do not
have a fixed version of the patch at the moment.

-- 
Mel Gorman
SUSE Labs
