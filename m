From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/6] sched: Change task_struct::state
Date: Wed, 2 Jun 2021 16:10:11 +0100
Message-ID: <20210602151010.GE31179@willie-the-truck>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.587042016@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622646628;
        bh=MmmB5edNPbRN/+c+2On4lV0BgwteW7Cw405ip5Z8YuI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eoW8oxXoywj95HF19beDzh3Wa+WhWkiyj9FjvvSEw7ScJ8OuGQbEy6+2TGjP0xVYN
         XSSJAJXvhI5MOj1+GRdHIbg46k9rJSpJMlo/HDJefXpEwJPCDFcYn8COIR/VQO5DZl
         47yzM30C6QaWLqEpy6LeVNCLBHEk+aKjfkrC6CQ5ViDR3bMQ0fCKMIt+zFjJNZMY+v
         SNl2CwOo9QKvwQF6AUEFLQH9ccSyIziiULTl3YApDUWutkiYOLv0+Q04TM9wwWdkfx
         bdsysjlbcoFBsmj9C1l84fr+oHwMhBsnHonyI6jC2MFd17CoX0BlIS16/UkYyFRS6U
         MochfZ+/mAepQ==
Content-Disposition: inline
In-Reply-To: <20210602133040.587042016-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <t>

On Wed, Jun 02, 2021 at 03:12:31PM +0200, Peter Zijlstra wrote:
> Change the type and name of task_struct::state. Drop the volatile and
> shrink it to an 'unsigned int'. Rename it in order to find all uses
> such that we can use READ_ONCE/WRITE_ONCE as appropriate.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  block/blk-mq.c                 |    2 -
>  drivers/md/dm.c                |    6 ++--
>  fs/binfmt_elf.c                |    8 +++---
>  fs/userfaultfd.c               |    4 +--
>  include/linux/sched.h          |   31 +++++++++++------------
>  include/linux/sched/debug.h    |    2 -
>  include/linux/sched/signal.h   |    2 -
>  init/init_task.c               |    2 -
>  kernel/cgroup/cgroup-v1.c      |    2 -
>  kernel/debug/kdb/kdb_support.c |   18 +++++++------
>  kernel/fork.c                  |    4 +--
>  kernel/hung_task.c             |    2 -
>  kernel/kthread.c               |    4 +--
>  kernel/locking/mutex.c         |    6 ++--
>  kernel/locking/rtmutex.c       |    4 +--
>  kernel/locking/rwsem.c         |    2 -
>  kernel/ptrace.c                |   12 ++++-----
>  kernel/rcu/rcutorture.c        |    4 +--
>  kernel/rcu/tree_stall.h        |   12 ++++-----
>  kernel/sched/core.c            |   53 +++++++++++++++++++++--------------------
>  kernel/sched/deadline.c        |   10 +++----
>  kernel/sched/fair.c            |   11 +++++---
>  lib/syscall.c                  |    4 +--
>  net/core/dev.c                 |    2 -
>  24 files changed, 108 insertions(+), 99 deletions(-)

I think this makes the code a _lot_ easier to understand, so:

Acked-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

on the assumption that you'll fix get_wchan() for !x86 as well.

Cheers,

Will
