From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: 3.6-rc5 cgroups blkio throttle + md regression
Date: Thu, 20 Sep 2012 02:28:05 +1000
Message-ID: <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

CC'ing Vivek.

On 17 September 2012 03:31, Joseph Glanville
<joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org> wrote:
> Hi,
>
> When using cgroups blkio controller with bio throttling my shell hangs
> attempting to write limits for md devices.
> Standard sd devices work as expected but md devices cause the shell to
> hang on io_wait.
>
> For example:
>
> echo 9:0 0 > blkio.throttle.read_bps_device
>
> Where 9:0 => /dev/md0
>
> I haven't started trying to narrow down when this occured yet, it
> works fine on 3.2 and I will try out 3.5 etc shortly to see if I can
> bisect where it stopped working.
>
> Joseph.
>
> --
> CTO | Orion Virtualisation Solutions | www.orionvm.com.au
> Phone: 1300 56 99 52 | Mobile: 0428 754 846

Hi,

I have found some more time to bisect this but unfortunately my test
system fails to boot as it gets into the last ~40 revisions.
I am not sure if this is a Xen related bug so I might be able to
continue on baremetal and I might give that a go shortly.

These are the remaining commits in git bisect view:

ff26eaa blkcg: tg_stats_alloc_lock is an irq lock
0b7877d Merge tag 'v3.4-rc5' into for-3.5/core
bd1a68b vmsplice: relax alignement requirements for SPLICE_F_GIFT
a637120 blkcg: use radix tree to index blkgs from blkcg
496fb78 blkcg: fix blkcg->css ref leak in __blkg_lookup_create()
aaf7c68 block: fix elvpriv allocation failure handling
29e2b09 block: collapse blk_alloc_request() into get_request()
f9fcc2d blkcg: collapse blkcg_policy_ops into blkcg_policy
f95a04a blkcg: embed struct blkg_policy_data in policy specific data
3c79839 blkcg: mass rename of blkcg API
36558c8 blkcg: style cleanups for blk-cgroup.h
54e7ed1 blkcg: remove blkio_group->path[]
c94bed89 blkcg: blkg_rwstat_read() was missing inline
6d18b00 blkcg: shoot down blkgs if all policies are deactivated
3c96cb3 blkcg: drop stuff unused after per-queue policy activation update
a2b1693 blkcg: implement per-queue policy activation
03d8e11 blkcg: add request_queue->root_blkg
b82d4b1 blkcg: make request_queue bypassing on allocation
80fd997 blkcg: make sure blkg_lookup() returns %NULL if @q is bypassing
da8b066 blkcg: make blkg_conf_prep() take @pol and return with queue lock held
8bd435b blkcg: remove static policy ID enums
ec39934 blkcg: use @pol instead of @plid in update_root_blkg_pd() and
blkcg_print_blkgs()
bc0d650 blkcg: kill blkio_list and replace blkio_list_lock with a mutex
f48ec1d cfq: fix build breakage & warnings
5bc4afb blkcg: drop BLKCG_STAT_{PRIV|POL|OFF} macros
d366e7e blkcg: pass around pd->pdata instead of pd itself in prfill functions
af133ce blkcg: move blkio_group_conf->iops and ->bps to blk-throttle
3381cb8 blkcg: move blkio_group_conf->weight to cfq
8a3d261 blkcg: move blkio_group_stats_cpu and friends to blk-throttle.c
155fead blkcg: move blkio_group_stats to cfq-iosched.c
9ade5ea blkcg: add blkio_policy_ops operations for exit and stat reset
41b38b6 blkcg: cfq doesn't need per-cpu dispatch stats
629ed0b blkcg: move statistics update code to policies
2ce4d50 cfq: collapse cfq.h into cfq-iosched.c
60c2bc2 blkcg: move conf/stat file handling code to policies
44ea53d blkcg: implement blkio_policy_type->cftypes
829fdb5 blkcg: export conf/stat helpers to prepare for reorganization
726fa69 blkcg: simplify blkg_conf_prep()
3a8b31d blkcg: restructure blkio_group configruation setting
c4682ae blkcg: restructure configuration printing
627f29f blkcg: drop blkiocg_file_write_u64()
d3d32e6 blkcg: restructure statistics printing
edcb072 blkcg: introduce blkg_stat and blkg_rwstat
2aa4a15 blkcg: BLKIO_STAT_CPU_SECTORS doesn't have subcounters
aaec55a blkcg: remove unused @pol and @plid parameters
959d851 Merge branch 'for-3.5' of ../cgroup into block/for-3.5/core-merged
a556793 blkcg: change a spin_lock() to spin_lock_irq()

If anything it narrows it down to being a blkcg problem rather than
having anything to do with md.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
