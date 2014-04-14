From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH RFC] blkcg: prepare blkcg knobs for default hierarchy
Date: Mon, 14 Apr 2014 14:08:24 -0400
Message-ID: <20140414180824.GB9552@redhat.com>
References: <20140413013209.GC26252@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140413013209.GC26252@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

On Sat, Apr 12, 2014 at 09:32:09PM -0400, Tejun Heo wrote:
> Hello,
> 
> Unified hierarchy has finally been posted.
> 
>   http://thread.gmane.org/gmane.linux.kernel.containers/27601
> 
> It took a lot longer than I originally anticipated and over the course
> quite a few aspects of the initial design have changed, hopefully, for
> the better.  One of the areas which has seen major redirection is
> internal tasks competing against child cgroups.  The original plan was
> implementing an implicit leaf node for each cgroup so that internal
> tasks compete as an implicit child against other children.  cfq was
> chosen as the first one to try the strategy and the result was
> leaf_weight[_device] knobs.  This, unfortunately, doesn't seem to be
> the right direction.
> 
> The strategy complicates the controller interface and implementation,
> and ends up adding an extra layer of nesting at leaves.  Also,
> initially, it was thought that internal tasks are problematic only for
> weight based controllers; however, it turns out it also is a problem
> for absolute limit based ones like memory, which means that we'd need
> to complicate more controllers.
> 
> As the problem is something fundamental in most resource controllers,
> the implemented unified hierarchy now enforces structural constraint
> which prevents competion between internal tasks and child cgroups from
> the get-go making leaf_weight[_device] mechanism unnecessary.
> 
> In addition, blkio interface is generally a bit messy and all cfq
> knobs are missing "cfq." prefix.  As unified hierarchy involves
> noticeable changes in usage, this patch takes the chance and make
> blkio present more consistent and concise interface on unified
> hierarchy
> 
> I'm currently preparing a doc describing the design and rationales of
> unified hierarchy and most of the above information will be present in
> the documentation.
> 
> Thanks.

Hi Tejun,

Can you please also update Documentation/block/cfq-iosched.txt and
Documentation/cgroup/blkio-controller.txt to reflect these new
changes.

So now we have tree modes?

- Orignal multi hierachy mode
- Multi hierarchy with sane flag
	- Sane flag modifies behavior of throttling.
- Unified hierarchy
	- Changes tunables.
> 
> ------ 8< ------
> Some blkcg knobs don't make sense on unified hierarchy.  This patch
> makes the following changes for unified hierarchy.

Looks like some of the changes are related to sane flag and others
are related to unified hierarchy. Will it make sense to break it down
int two patches.

> 
> * reset_stats never made much sense outside developement and
>   debugging.  Omit it.
> 

Agreed. Lets get rid of it.

> * As unified hierarchy excludes internal tasks competing against child
>   cgroups, cfq's leaf_weight[_device] knobs are no longer necessary.
>   Omit it.

Agreed. All this leaf_weight logic was little magic. Happy to see it go.

> 
> * For cfq, weight[_device] behave inherently differently from the same
>   knobs on !root cgroups as root cgroup is treated as parallel to
>   immediate children.  Let's omit it for now.

So now root cgroup will not have any cfq, weight[_device] knobs but
non root cgroups will have one? What's the harm in providing one for
root too for the sake of uniformity. That's a differnt thing thet root
does not have a competitor so value in that knob does not matter.

> 
> * cfq's time stats reports the total time slice consumed but its unit
>   is in jiffies and it's not reported per-device like all other stats.
>   Omit it for now.  If slice time is actually necessary, let's add it
>   in the form consistent with other stats.

To me this knob is also for debugging purposes. CFQ divides disk time
proportionally. And if one wants to see how disk time is being divided
among cgroups, this knob helps. This is more to verify whether our
algorithm is working fine or not and if disk time is being divided
in proportion to weights or not.

But again, I am not particular about this knob. Sounds more like
debugging stuff.

> 
> * cfq's io_queued reporting is different from all other stats in that
>   it's a snapshot value rather than accumulated value and is mostly
>   meaningful only for debugging.  Omit it.

io_queued shows number of IOs queued currently in cgroup. So this was
never supposed to be an accumulated value. Accumulated value will not
make sense here, I think.

Google folks wanted all these knobs. And they said that they have lot
of more knobs which they carry internally.

Personally I think io_queued might be a useful knob because it can
show current backlog on a particular cgroup and some tool might want
to dynamically monitor the queue lenghts of various cgroups and adjust
weights dynamically.

So this one might be worth retaining.

> 
> * As unified hierarchy doesn't allow internal tasks, non-recursive
>   stats are largely irrelevant.  Omit them.

Makes sense. So this is more of a unified hierarchy related cleanup.

> 
> * cfq adds a number of stats knobs if CONFIG_DEBUG_BLK_CGROUP.  If
>   these are actually for debugging, they shouldn't show up by default
>   (ie. should be gated by kernel param or something).  If userland
>   already developed dependency on them, we need to take them out of
>   CONFIG_DEBUG_BLK_CGROUP.  Skip them for now.  We can add back the
>   relevant ones later.

I am fine with this. Again Google folks intorduced those. Not sure
if they still use those. Less stats are better.

> 
> * Prefix the remaining cfq knobs with "cfq." and make the names
>   consistent.

Looks good. This makes it consistent with blkio.throttle.* knobs.

> 
>   weight_device			-> cfq.weight_device
>   weight			-> cfq.weight
>   sectors_recursive		-> cfq.sectors
>   io_service_bytes_recursive	-> cfq.bytes

throttling has correspnding knob as throttle.io_service_bytes. So either
we can change the name of throttling knob to throttle.bytes or
chnage keep this one as it is (cfq.io_service_bytes) for the sake of
consistency.

>   io_serviced_recursive		-> cfq.serviced

throttling layer uses throttle.io_serviced.

Given the fact that throttling layer counts bios and CFQ counts requests
may be we can keep throttle.bio_serviced  and cfq.rq_serviced as names.

Or may be just throttle.bios and cfq.requests respectively.

>   io_merged_recursive		-> cfq.merged
>   io_service_time_recursive	-> cfq.io_time
>   io_wait_time_recursive	-> cfq.wait_time
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-cgroup.c  |    1 
>  block/cfq-iosched.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 86 insertions(+), 4 deletions(-)
> 
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -761,6 +761,7 @@ EXPORT_SYMBOL_GPL(blkg_conf_finish);
>  struct cftype blkcg_files[] = {
>  	{
>  		.name = "reset_stats",
> +		.flags = CFTYPE_INSANE,
>  		.write_u64 = blkcg_reset_stats,

So this knob will not be user visible with unified hierarchy as well as with
sane behavior?

So this looks like a cleanup independent of unified hiearchy.

[..]
> +	/* files for default hierarchy, properly prefixed with cfq */
> +	{
> +		.name = "cfq.weight_device",
> +		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
> +		.seq_show = cfqg_print_weight_device,
> +		.write_string = cfqg_set_weight_device,
> +	},
> +	{
> +		.name = "cfq.weight",
> +		.flags = CFTYPE_ONLY_ON_DFL | CFTYPE_NOT_ON_ROOT,
> +		.seq_show = cfq_print_weight,
> +		.write_u64 = cfq_set_weight,
> +	},
> +

What't the harm in providing these knobs for root too?

Thanks
Vivek
