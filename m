From: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 0/6] cgroup, blkcg: prevent dirty inodes to pin dying
 memory cgroups
Date: Sat, 5 Jun 2021 21:37:37 +0000
Message-ID: <YLvuofB0xMuz/wz9@google.com>
References: <20210604013159.3126180-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210604013159.3126180-1-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Thu, Jun 03, 2021 at 06:31:53PM -0700, Roman Gushchin wrote:
> When an inode is getting dirty for the first time it's associated
> with a wb structure (see __inode_attach_wb()). It can later be
> switched to another wb (if e.g. some other cgroup is writing a lot of
> data to the same inode), but otherwise stays attached to the original
> wb until being reclaimed.
> 
> The problem is that the wb structure holds a reference to the original
> memory and blkcg cgroups. So if an inode has been dirty once and later
> is actively used in read-only mode, it has a good chance to pin down
> the original memory and blkcg cgroups forewer. This is often the case with
> services bringing data for other services, e.g. updating some rpm
> packages.
> 
> In the real life it becomes a problem due to a large size of the memcg
> structure, which can easily be 1000x larger than an inode. Also a
> really large number of dying cgroups can raise different scalability
> issues, e.g. making the memory reclaim costly and less effective.
> 
> To solve the problem inodes should be eventually detached from the
> corresponding writeback structure. It's inefficient to do it after
> every writeback completion. Instead it can be done whenever the
> original memory cgroup is offlined and writeback structure is getting
> killed. Scanning over a (potentially long) list of inodes and detach
> them from the writeback structure can take quite some time. To avoid
> scanning all inodes, attached inodes are kept on a new list (b_attached).
> To make it less noticeable to a user, the scanning and switching is performed
> from a work context.
> 
> Big thanks to Jan Kara, Dennis Zhou and Hillf Danton for their ideas and
> contribution to this patchset.
> 
> v7:
>   - shared locking for multiple inode switching
>   - introduced inode_prepare_wbs_switch() helper
>   - extended the pre-switch inode check for I_WILL_FREE
>   - added comments here and there
> 
> v6:
>   - extended and reused wbs switching functionality to switch inodes
>     on cgwb cleanup
>   - fixed offline_list handling
>   - switched to the unbound_wq
>   - other minor fixes
> 
> v5:
>   - switch inodes to bdi->wb instead of zeroing inode->i_wb
>   - split the single patch into two
>   - only cgwbs maintain lists of attached inodes
>   - added cond_resched()
>   - fixed !CONFIG_CGROUP_WRITEBACK handling
>   - extended list of prohibited inodes flag
>   - other small fixes
> 
> 
> Roman Gushchin (6):
>   writeback, cgroup: do not switch inodes with I_WILL_FREE flag
>   writeback, cgroup: switch to rcu_work API in inode_switch_wbs()
>   writeback, cgroup: keep list of inodes attached to bdi_writeback
>   writeback, cgroup: split out the functional part of
>     inode_switch_wbs_work_fn()
>   writeback, cgroup: support switching multiple inodes at once
>   writeback, cgroup: release dying cgwbs by switching attached inodes
> 
>  fs/fs-writeback.c                | 302 +++++++++++++++++++++----------
>  include/linux/backing-dev-defs.h |  20 +-
>  include/linux/writeback.h        |   1 +
>  mm/backing-dev.c                 |  69 ++++++-
>  4 files changed, 293 insertions(+), 99 deletions(-)
> 
> -- 
> 2.31.1
> 

I too am a bit late to the party. Feel free to add mine as well to the
series.

Acked-by: Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I left my one comment on the last patch regarding a possible future
extension.

Thanks,
Dennis
