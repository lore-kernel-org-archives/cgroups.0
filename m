From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4 3/3] cgroup: replace unified-hierarchy.txt
 with a proper cgroup v2 documentation
Date: Fri, 23 Oct 2015 08:16:47 -0400
Message-ID: <20151023121647.GA22547@redhat.com>
References: <20151022012212.GA20931@mtj.duckdns.org>
 <20151022012302.GB20931@mtj.duckdns.org>
 <20151022012354.GC20931@mtj.duckdns.org>
 <20151022143427.GC20847@redhat.com>
 <20151022143605.GE30579@mtj.duckdns.org>
 <20151023011807.GB5442@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151023011807.GB5442-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Oct 23, 2015 at 10:18:07AM +0900, Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 22, 2015 at 11:36:05PM +0900, Tejun Heo wrote:
> > It works with ext2 and 4 and btrfs.  Will document it.  Thanks.
> 
> Updated to include all writeback information from
> blkio-controller.txt.
> 

Thanks Tejun. Looks good.

Vivek

> 5-3-2. Writeback
> 
> Page cache is dirtied through buffered writes and shared mmaps and
> written asynchronously to the backing filesystem by the writeback
> mechanism.  Writeback sits between the memory and IO domains and
> regulates the proportion of dirty memory by balancing dirtying and
> write IOs.
> 
> The io controller, in conjunction with the memory controller,
> implements control of page cache writeback IOs.  The memory controller
> defines the memory domain that dirty memory ratio is calculated and
> maintained for and the io controller defines the io domain which
> writes out dirty pages for the memory domain.  Both system-wide and
> per-cgroup dirty memory states are examined and the more restrictive
> of the two is enforced.
> 
> cgroup writeback requires explicit support from the underlying
> filesystem.  Currently, cgroup writeback is implemented on ext2, ext4
> and btrfs.  On other filesystems, all writeback IOs are attributed to
> the root cgroup.
> 
> There are inherent differences in memory and writeback management
> which affects how cgroup ownership is tracked.  Memory is tracked per
> page while writeback per inode.  For the purpose of writeback, an
> inode is assigned to a cgroup and all IO requests to write dirty pages
> from the inode are attributed to that cgroup.
> 
> As cgroup ownership for memory is tracked per page, there can be pages
> which are associated with different cgroups than the one the inode is
> associated with.  These are called foreign pages.  The writeback
> constantly keeps track of foreign pages and, if a particular foreign
> cgroup becomes the majority over a certain period of time, switches
> the ownership of the inode to that cgroup.
> 
> While this model is enough for most use cases where a given inode is
> mostly dirtied by a single cgroup even when the main writing cgroup
> changes over time, use cases where multiple cgroups write to a single
> inode simultaneously are not supported well.  In such circumstances, a
> significant portion of IOs are likely to be attributed incorrectly.
> As memory controller assigns page ownership on the first use and
> doesn't update it until the page is released, even if writeback
> strictly follows page ownership, multiple cgroups dirtying overlapping
> areas wouldn't work as expected.  It's recommended to avoid such usage
> patterns.
> 
> The sysctl knobs which affect writeback behavior are applied to cgroup
> writeback as follows.
> 
>   vm.dirty_background_ratio
>   vm.dirty_ratio
> 
> 	These ratios apply the same to cgroup writeback with the
> 	amount of available memory capped by limits imposed by the
> 	memory controller and system-wide clean memory.
> 
>   vm.dirty_background_bytes
>   vm.dirty_bytes
> 
> 	For cgroup writeback, this is calculated into ratio against
> 	total available memory and applied the same way as
> 	vm.dirty[_background]_ratio.
> 
> 
> P. Information on Kernel Programming
> 
> This section contains kernel programming information in the areas
> where interacting with cgroup is necessary.  cgroup core and
> controllers are not covered.
> 
> 
> P-1. Filesystem Support for Writeback
> 
> A filesystem can support cgroup writeback by updating
> address_space_operations->writepage[s]() to annotate bio's using the
> following two functions.
> 
>   wbc_init_bio(@wbc, @bio)
> 
> 	Should be called for each bio carrying writeback data and
> 	associates the bio with the inode's owner cgroup.  Can be
> 	called anytime between bio allocation and submission.
> 
>   wbc_account_io(@wbc, @page, @bytes)
> 
> 	Should be called for each data segment being written out.
> 	While this function doesn't care exactly when it's called
> 	during the writeback session, it's the easiest and most
> 	natural to call it as data segments are added to a bio.
> 
> With writeback bio's annotated, cgroup support can be enabled per
> super_block by setting SB_I_CGROUPWB in ->s_iflags.  This allows for
> selective disabling of cgroup writeback support which is helpful when
> certain filesystem features, e.g. journaled data mode, are
> incompatible.
> 
> wbc_init_bio() binds the specified bio to its cgroup.  Depending on
> the configuration, the bio may be executed at a lower priority and if
> the writeback session is holding shared resources, e.g. a journal
> entry, may lead to priority inversion.  There is no one easy solution
> for the problem.  Filesystems can try to work around specific problem
> cases by skipping wbc_init_bio() or using bio_associate_blkcg()
> directly.
> 
> -- 
> tejun
