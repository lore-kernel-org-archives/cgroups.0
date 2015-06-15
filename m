From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] writeback, blkio: add documentation for cgroup
 writeback support
Date: Mon, 15 Jun 2015 13:28:23 -0400
Message-ID: <20150615172823.GA5783@redhat.com>
References: <1434146254-26220-1-git-send-email-tj@kernel.org>
 <1434146254-26220-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434146254-26220-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 12, 2015 at 04:57:34PM -0500, Tejun Heo wrote:
> Update Documentation/cgroups/blkio-controller.txt to reflect the
> recently added cgroup writeback support.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  Documentation/cgroups/blkio-controller.txt | 83 ++++++++++++++++++++++++++++--

Hi Tejun,

This looks good to me. Thanks.

IIRC, I had run into the issues with two fsync running into two cgroups.
One cgroup was of really small limit and other was unlimited. At that
point of time I think conclusion was that multiple transactions could
not make progress at the same time. So slower cgroup had blocked unlimited
cgroup process from opening a transaction (as IO from slower group was
stuck inside throttling later). 

For some reason, in my limited testing I have not noticed it with your
branch. May be things have changed since or I am just hazy on details.
I will do some more testing.

Thanks
Vivek

>  1 file changed, 78 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index cd556b9..68b6a6a 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -387,8 +387,81 @@ groups and put applications in that group which are not driving enough
>  IO to keep disk busy. In that case set group_idle=0, and CFQ will not idle
>  on individual groups and throughput should improve.
>  
> -What works
> -==========
> -- Currently only sync IO queues are support. All the buffered writes are
> -  still system wide and not per group. Hence we will not see service
> -  differentiation between buffered writes between groups.
> +Writeback
> +=========
> +
> +Page cache is dirtied through buffered writes and shared mmaps and
> +written asynchronously to the backing filesystem by the writeback
> +mechanism.  Writeback sits between the memory and IO domains and
> +regulates the proportion of dirty memory by balancing dirtying and
> +write IOs.
> +
> +On traditional cgroup hierarchies, relationships between different
> +controllers cannot be established making it impossible for writeback
> +to operate accounting for cgroup resource restrictions and all
> +writeback IOs are attributed to the root cgroup.
> +
> +If both the blkio and memory controllers are used on the v2 hierarchy
> +and the filesystem supports cgroup writeback, writeback operations
> +correctly follow the resource restrictions imposed by both memory and
> +blkio controllers.
> +
> +Writeback examines both system-wide and per-cgroup dirty memory status
> +and enforces the more restrictive of the two.  Also, writeback control
> +parameters which are absolute values - vm.dirty_bytes and
> +vm.dirty_background_bytes - are distributed across cgroups according
> +to their current writeback bandwidth.
> +
> +There's a peculiarity stemming from the discrepancy in ownership
> +granularity between memory controller and writeback.  While memory
> +controller tracks ownership per page, writeback operates on inode
> +basis.  cgroup writeback bridges the gap by tracking ownership by
> +inode but migrating ownership if too many foreign pages, pages which
> +don't match the current inode ownership, have been encountered while
> +writing back the inode.
> +
> +This is a conscious design choice as writeback operations are
> +inherently tied to inodes making strictly following page ownership
> +complicated and inefficient.  The only use case which suffers from
> +this compromise is multiple cgroups concurrently dirtying disjoint
> +regions of the same inode, which is an unlikely use case and decided
> +to be unsupported.  Note that as memory controller assigns page
> +ownership on the first use and doesn't update it until the page is
> +released, even if cgroup writeback strictly follows page ownership,
> +multiple cgroups dirtying overlapping areas wouldn't work as expected.
> +In general, write-sharing an inode across multiple cgroups is not well
> +supported.
> +
> +Filesystem support for cgroup writeback
> +---------------------------------------
> +
> +A filesystem can make writeback IOs cgroup-aware by updating
> +address_space_operations->writepage[s]() to annotate bio's using the
> +following two functions.
> +
> +* wbc_init_bio(@wbc, @bio)
> +
> +  Should be called for each bio carrying writeback data and associates
> +  the bio with the inode's owner cgroup.  Can be called anytime
> +  between bio allocation and submission.
> +
> +* wbc_account_io(@wbc, @page, @bytes)
> +
> +  Should be called for each data segment being written out.  While
> +  this function doesn't care exactly when it's called during the
> +  writeback session, it's the easiest and most natural to call it as
> +  data segments are added to a bio.
> +
> +With writeback bio's annotated, cgroup support can be enabled per
> +super_block by setting MS_CGROUPWB in ->s_flags.  This allows for
> +selective disabling of cgroup writeback support which is helpful when
> +certain filesystem features, e.g. journaled data mode, are
> +incompatible.
> +
> +wbc_init_bio() binds the specified bio to its cgroup.  Depending on
> +the configuration, the bio may be executed at a lower priority and if
> +the writeback session is holding shared resources, e.g. a journal
> +entry, may lead to priority inversion.  There is no one easy solution
> +for the problem.  Filesystems can try to work around specific problem
> +cases by skipping wbc_init_bio() or using bio_associate_blkcg()
> +directly.
> -- 
> 2.4.2
