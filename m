From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Mon, 4 Apr 2016 21:25:04 -0400
Message-ID: <20160405012504.GG24661@htj.duckdns.org>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
 <1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
 <20160404193640.GA7822@mtj.duckdns.org>
 <CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lCqsP8j6VNEQ3Vd7hE/fpotEf8jk8E7L/ezJ3WVmybs=;
        b=bfvmeTicQd3j32Pe3Yj1cW31Btl9sg3AatarmaTizDj/nI/dNDeEbpOXJUCughjPLP
         hbf4T228CBvnCDtkYJ+qF3/aWjV1UH/gmYv5VIqo5EEOA9Tjmi3IJ9xmoJDrk8a3oQxW
         TRs+TXmtZejTOC7Zp7Mtn8EqosMsf6njJbdIsuzjOjYBvdo5WhoNMhd9eFViCUnOfSUd
         uA5P8gSWRQXMbb8bCMG9qulxbmASpXukp75u37anpXuHesNrJALmpT2wjzI+LvzVYIU1
         321NkTI89F/l0/bazq8j5i8fzyCSUfris4CKxuZmnCmJ/YzwjQLPjbqjbZJxOT5ZLQOG
         9BOw==
Content-Disposition: inline
In-Reply-To: <CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello,

On Mon, Apr 04, 2016 at 03:50:54PM -0700, Parav Pandit wrote:
> 2nd advantage is, it allows avoiding lot of rework, in bundling kernel
> modules with different kernel versions. So it is certainly valuable
> feature with almost nil complexity cost of code or memory that solves
> two problems with approach.
> If there two kernel versions with different type of resources and
> kernel modules with different resources, it gets ugly to maintain that
> kind of compatibility using compat.h. This approach avoid all such
> cases.

Is it actually customary to have rdma core module updated more
frequently separate from the kernel?  Out-of-tree modules being
updated separately happens quite a bit but this is an in-kernel
module, which usually is tightly coupled with the rest of the kernel.

> > * It's usually a good idea to have hierarchical objects to be created
> >   all the way to the root when a leaf node is requested and link
> >   parent at each level.  That way, when a descendant object is looked
> >   up, the caller can always deref its ->parent pointer till it reaches
> >   the top.
> 
> This is interesting comment. I cannot recall, but I think its v4 or v5
> was exactly doing same.
> Allocating resource pool first in one loop and charging them in another.
> In event of failure, uncharging them in 3rd.
> And you gave comment that time is to move away from that approach for
> simplicity!
> That I had refcnt on each object.

I don't remember the details well but the code was vastly more complex
back then and the object lifetime management was muddy at best.  If I
reviewed in a contradicting way, my apologies, but given the current
code, it'd be better to have objects creation upfront.

> > So, with each pool linking to its parent, instead of looking up at
> > each level, it can just follow ->parent recursively.
> 
> No. Lookup is being done for the rpool for that device and not the cgroup.
> doing recursively using ->parent would require additional pointer of
> rpool type to be maintained which is not necessary because we already
> have cgroup level parent.

Yes, I meant adding pool->parent field.  Hierarchical operations
become far simpler with the invariant that parent always exists.

> Adding ->parent would make it little faster compare to traversing 1 to
> 4 node entry list. However this is not hot path, so keeping existing
> code to traverse is more desirable than adding ->parent of rpool type,
> which also saves memory for large number of cgroup instances.

It isn't necessarily about speed.  It makes clear that the parent
always should exist and makes the code easier to read and update.

> >> +     /*
> >> +      * A negative count (or overflow) is invalid,
> >> +      * it indicates a bug in the rdma controller.
> >> +      */
> >> +     WARN_ON_ONCE(rpool->resources[index].usage < 0);
> >> +     rpool->usage_sum--;
> >
> > What guarantees that this count wouldn't overflow?  More on this
> > later.
> 
> Are you suggesting to add WARN_ON for usage_sum variable for debugging?
> I believe 1st warning is sufficient?

I mean that it isn't particularly difficult to overflow a s32 when
adding up multiple usages into one.

> >> +static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
> >> +                                    char *buf, size_t nbytes, loff_t off)
> >> +{
> >> +     struct rdma_cgroup *cg = css_rdmacg(of_css(of));
> >> +     const char *dev_name;
> >> +     struct rdmacg_resource_pool *rpool;
> >> +     struct rdmacg_device *device;
> >> +     char *options = strstrip(buf);
> >> +     struct rdmacg_pool_info *pool_info;
> >> +     u64 enables = 0;
> >> +     int *new_limits;
> >> +     int i = 0, ret = 0;
> >> +
> >> +     /* extract the device name first */
> >> +     dev_name = strsep(&options, " ");
> >> +     if (!dev_name) {
> >> +             ret = -EINVAL;
> >> +             goto err;
> >> +     }
> >> +
> >> +     /* acquire lock to synchronize with hot plug devices */
> >> +     mutex_lock(&dev_mutex);
> >> +
> >> +     device = rdmacg_get_device_locked(dev_name);
> >> +     if (!device) {
> >> +             ret = -ENODEV;
> >> +             goto parse_err;
> >> +     }
> >> +
> >> +     pool_info = &device->pool_info;
> >> +
> >> +     new_limits = kcalloc(pool_info->table_len, sizeof(int), GFP_KERNEL);
> >> +     if (!new_limits) {
> >> +             ret = -ENOMEM;
> >> +             goto parse_err;
> >> +     }
> >
> > Hmm... except for new_limits allocation and alloc_cg_rpool()
> > invocation, both of which can be done at the head of the function,
> > nothing seems to require a mutex here.  If we move them to the head of
> > the function, can we get rid of dev_mutex entirely?
> 
> No. As described in comment where lock is taken,
> it ensures that if device is being removed while configuration is
> going on, it protects against those race condition.
> So will keep it as it is.

Yeah, sure, it needs protection.  I was wondering why it needed to be
a separate mutex.  The only sleeping operations seem to be the ones
which can be done before or with acquiring rpool_list_lock, no?

> >> +     if (rpool->usage_sum == 0 &&
> >> +         rpool->num_max_cnt == pool_info->table_len) {
> >> +             /*
> >> +              * No user of the rpool and all entries are set to max, so
> >> +              * safe to delete this rpool.
> >> +              */
> >> +             list_del(&rpool->cg_list);
> >> +             spin_unlock(&rpool_list_lock);
> >> +
> >> +             free_cg_rpool(rpool);
> >
> > Can't we just count the number of resources which either have !max
> > setting or !0 usage?
> >
> What you have described here is done above. Instead of running loop to
> find that out for every resource,

You're summing up all usages instead of counting the number of !0
usages.

> as you suggested last time, keeping two counters for usage and max to
> find out this condition.

So, whether the counters are separate or not doesn't matter that much
but it's awkward that it's counting the number of !max entries for
limits while summing the actual usages (instead of counting the number
of !0 usages) especially given that it gets summed into an int
counter.  Wouldn't counting !max limit && !0 usage be more consistent?

> >> +static u32 *get_cg_rpool_values(struct rdma_cgroup *cg,
> >> +                             struct rdmacg_device *device,
> >> +                             enum rdmacg_file_type sf_type,
> >> +                             int count)
> >> +{
> >> +     struct rdmacg_resource_pool *rpool;
> >> +     u32 *value_tbl;
> >> +     int i, ret;
> >> +
> >> +     value_tbl = kcalloc(count, sizeof(u32), GFP_KERNEL);
> >> +     if (!value_tbl) {
> >> +             ret = -ENOMEM;
> >> +             goto err;
> >> +     }
> >
> > Do we need this type of interface?
> Yes
> > Why not let the caller look up the
> > target pool and call this function with pool and resource index?
> 
> I can move value_tbl allocation out of this function, but what is the
> problem in current code?
> I don't see any difference in moving loop count specific code outside
> of get_cg_rpool_values() function other than doing rework. What gain
> you are looking forward to by doing so?

I meant you don't need the allocation at all.

	lock;
	for_each_dev() {
		pool = lookup_pool();
		for_each_field()
			seq_printf(sf, "%s ", name, pool_val(pool, index));
	}
	unlock;

I don't know why you end up missing basic patterns so badly.  It's
making the review and iteration process pretty painful.  Please don't
be confrontational and try to read the review comments assuming good
will.

Thanks.

-- 
tejun
