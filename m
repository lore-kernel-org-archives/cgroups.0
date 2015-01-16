From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCHSET RFC 0/6] memcg: inode-based dirty-set controller
Date: Fri, 16 Jan 2015 10:37:34 +0100
Message-ID: <20150116093734.GD25884@quack.suse.cz>
References: <20150115180242.10450.92.stgit@buzz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150115180242.10450.92.stgit@buzz>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

  Hello,

On Thu 15-01-15 21:49:10, Konstantin Khebnikov wrote:
> This is ressurection of my old RFC patch for dirty-set accounting cgroup [1]
> Now it's merged into memory cgroup and got bandwidth controller as a bonus.
> 
> That shows alternative solution: less accurate but much less monstrous than
> accurate page-based dirty-set controller from Tejun Heo.
> 
> Memory overhead: +1 pointer into struct address_space.
> Perfomance overhead is almost zero, no new locks added.
> 
> Idea is stright forward: link each inode to some cgroup when first dirty
> page appers and account all dirty pages to it. Writeback is implemented
> as single per-bdi writeback work which writes only inodes which belong
> to memory cgroups where amount of dirty memory is beyond thresholds.
> 
> Third patch adds trick for handling shared inodes which have dirty pages
> from several cgroups: it marks whole inode as shared and alters writeback
> filter for it.
> 
> The rest is an example of bandwith and iops controller build on top of that.
> Design is completely original, I bet nobody ever used task-works for that =)
  So I like the simplicity of your code but there are a few downsides too
(please correct me if I've got something wrong - btw the documentation of
high-level design would be welcome so that one doesn't have to understand
that from the patches):
1) The bandwidth controller simply accounts number of bytes submitted for
IO in submit_bio().  This doesn't reflect HW capabilities in any way. There
a huge difference between a process submitting single block random IO and a
process doing the same amount of sequential IO. This could be somewhat
dealt with by not accounting number of bytes but rather time it took to
complete a bio (but that somewhat complicates the code and block layer
already does similar counting so it would be good you used that).

2) The controller accounts bio to current task - that makes the limiting
useless for background writeback. You need to somehow propagate i_memcg
into submit_bio() so that IO is properly accounted.

3) The controller doesn't seem to guarantee any quality of service at the
IO level like blkcg does. The controller limits amount of IO userspace is
able to submit to kernel but only after we decide to submit the IO to disk.
So at that time cgroup may have generated lots of IO - e.g. by dirtying lots
of pages - and there's nothing to protect other cgroups from starvation
because of writeback of these pages.

Especially the last point seems to be essential to your approach (although
you could somewhat mitigate the issue by accounting the IO already when
it is entering the kernel) and I'm not sure whether that's really
acceptable for potential users of this feature.

								Honza
> [1] [PATCH RFC] fsio: filesystem io accounting cgroup
> http://marc.info/?l=linux-kernel&m=137331569501655&w=2
> 
> Patches also available here:
> https://github.com/koct9i/linux.git branch memcg_dirty_control
> 
> ---
> 
> Konstantin Khebnikov (6):
>       memcg: inode-based dirty and writeback pages accounting
>       memcg: dirty-set limiting and filtered writeback
>       memcg: track shared inodes with dirty pages
>       percpu_ratelimit: high-performance ratelimiting counter
>       delay-injection: resource management via procrastination
>       memcg: filesystem bandwidth controller
> 
> 
>  block/blk-core.c                 |    2 
>  fs/direct-io.c                   |    2 
>  fs/fs-writeback.c                |   22 ++
>  fs/inode.c                       |    1 
>  include/linux/backing-dev.h      |    1 
>  include/linux/fs.h               |   14 +
>  include/linux/memcontrol.h       |   27 +++
>  include/linux/percpu_ratelimit.h |   45 ++++
>  include/linux/sched.h            |    7 +
>  include/linux/writeback.h        |    1 
>  include/trace/events/sched.h     |    7 +
>  include/trace/events/writeback.h |    1 
>  kernel/sched/core.c              |   66 +++++++
>  kernel/sched/fair.c              |   12 +
>  lib/Makefile                     |    1 
>  lib/percpu_ratelimit.c           |  168 +++++++++++++++++
>  mm/memcontrol.c                  |  381 ++++++++++++++++++++++++++++++++++++++
>  mm/page-writeback.c              |   32 +++
>  mm/readahead.c                   |    2 
>  mm/truncate.c                    |    1 
>  mm/vmscan.c                      |    4 
>  21 files changed, 787 insertions(+), 10 deletions(-)
>  create mode 100644 include/linux/percpu_ratelimit.h
>  create mode 100644 lib/percpu_ratelimit.c
> 
> --
> Signature
-- 
Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
SUSE Labs, CR
