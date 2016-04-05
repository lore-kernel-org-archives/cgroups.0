From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Mon, 4 Apr 2016 19:22:38 -0700
Message-ID: <CAG53R5Xs9nB_g7pDu6G260EY+iu6hi=fs6eV1ggyk=NwO32oRg@mail.gmail.com>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
	<1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
	<20160404193640.GA7822@mtj.duckdns.org>
	<CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
	<20160405012504.GG24661@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=wGhjJ0pwxid6sTN7+LEBLMqOm6+l0Qa0iUlNbiyQ994=;
        b=x7pZ5xytW/0izAniwaXq6DmPjMfrdSDIkjYBN4sRUpgeiG9jWO2B0m86CgHYsaJkA1
         obz8FoeYHDdTrVCej8ba9u61qFN7pCEQ+0Mzgq06leGbPhrmVBW6tTtnXjOL5D8v2Uxc
         xl7ps3FhKy2tp1hvMgrDo89x9V/uIM6ahNQmIMkkDu8MOHHMkaKGGYY2h3J05Nr25Wjr
         W7+wJ6VJy/HQrW+csIprj9dg/i+fryv+c1eJ7s/UTH5hpSBVVOlGSMaZgeCX/308k1J1
         kPUznPfuzgU//Kg0sUsj2c9HkopaKcp/bggNu5yaRAeUPmjjp2OLodqJgDm491j4BQ6/
         PS0g==
In-Reply-To: <20160405012504.GG24661@htj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Tejun,

On Mon, Apr 4, 2016 at 6:25 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Mon, Apr 04, 2016 at 03:50:54PM -0700, Parav Pandit wrote:
>> 2nd advantage is, it allows avoiding lot of rework, in bundling kernel
>> modules with different kernel versions. So it is certainly valuable
>> feature with almost nil complexity cost of code or memory that solves
>> two problems with approach.
>> If there two kernel versions with different type of resources and
>> kernel modules with different resources, it gets ugly to maintain that
>> kind of compatibility using compat.h. This approach avoid all such
>> cases.
>
> Is it actually customary to have rdma core module updated more
> frequently separate from the kernel?  Out-of-tree modules being
> updated separately happens quite a bit but this is an in-kernel
> module, which usually is tightly coupled with the rest of the kernel.
>
Yes.
rdma core module is compiled as kernel module.
Its often updated for new features, fixes.
So kernel version can be one but RDMA core module(s) get updated more
frequently than kernel.

>
> I don't remember the details well but the code was vastly more complex
> back then and the object lifetime management was muddy at best.  If I
> reviewed in a contradicting way, my apologies, but given the current
> code, it'd be better to have objects creation upfront.

Do you mean,
try_charge() should
lock()
run loop to allocate in hierarchy, if not allocated.
run loop again to charge.
unlock()

If so, I prefer to run the loop once.

If you mean, objects creating upfront when cgroup is created, or when
device is created - than we have talked of that approach in past, that
its more complex than what is being done today. I would certainly want
to avoid that in this patch as above approach has two advantages.
(a) its simpler
(b) doesn't require extra parent pointer, which is already available from cgroup

>
>> > So, with each pool linking to its parent, instead of looking up at
>> > each level, it can just follow ->parent recursively.
>>
>> No. Lookup is being done for the rpool for that device and not the cgroup.
>> doing recursively using ->parent would require additional pointer of
>> rpool type to be maintained which is not necessary because we already
>> have cgroup level parent.
>
> Yes, I meant adding pool->parent field.  Hierarchical operations
> become far simpler with the invariant that parent always exists.

>
>> Adding ->parent would make it little faster compare to traversing 1 to
>> 4 node entry list. However this is not hot path, so keeping existing
>> code to traverse is more desirable than adding ->parent of rpool type,
>> which also saves memory for large number of cgroup instances.
>
> It isn't necessarily about speed.  It makes clear that the parent
> always should exist and makes the code easier to read and update.

It doesn't have to exist. It can get allocated when charging occurs.
Otherwise even if rdma resources are not used, it ends up allocating
rpool in hierarchy. (We talked this before)

>
>> >> +     /*
>> >> +      * A negative count (or overflow) is invalid,
>> >> +      * it indicates a bug in the rdma controller.
>> >> +      */
>> >> +     WARN_ON_ONCE(rpool->resources[index].usage < 0);
>> >> +     rpool->usage_sum--;
>> >
>> > What guarantees that this count wouldn't overflow?  More on this
>> > later.
>>
>> Are you suggesting to add WARN_ON for usage_sum variable for debugging?
>> I believe 1st warning is sufficient?
>
> I mean that it isn't particularly difficult to overflow a s32 when
> adding up multiple usages into one.
Possible,but resources are not really in range of 2G range, at least
not any hardware that I am aware of.
But I can make it u64.

>
>> >> +static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
>> >> +                                    char *buf, size_t nbytes, loff_t off)
>> >> +{
>> >> +     struct rdma_cgroup *cg = css_rdmacg(of_css(of));
>> >> +     const char *dev_name;
>> >> +     struct rdmacg_resource_pool *rpool;
>> >> +     struct rdmacg_device *device;
>> >> +     char *options = strstrip(buf);
>> >> +     struct rdmacg_pool_info *pool_info;
>> >> +     u64 enables = 0;
>> >> +     int *new_limits;
>> >> +     int i = 0, ret = 0;
>> >> +
>> >> +     /* extract the device name first */
>> >> +     dev_name = strsep(&options, " ");
>> >> +     if (!dev_name) {
>> >> +             ret = -EINVAL;
>> >> +             goto err;
>> >> +     }
>> >> +
>> >> +     /* acquire lock to synchronize with hot plug devices */
>> >> +     mutex_lock(&dev_mutex);
>> >> +
>> >> +     device = rdmacg_get_device_locked(dev_name);
>> >> +     if (!device) {
>> >> +             ret = -ENODEV;
>> >> +             goto parse_err;
>> >> +     }
>> >> +
>> >> +     pool_info = &device->pool_info;
>> >> +
>> >> +     new_limits = kcalloc(pool_info->table_len, sizeof(int), GFP_KERNEL);
>> >> +     if (!new_limits) {
>> >> +             ret = -ENOMEM;
>> >> +             goto parse_err;
>> >> +     }
>> >
>> > Hmm... except for new_limits allocation and alloc_cg_rpool()
>> > invocation, both of which can be done at the head of the function,
>> > nothing seems to require a mutex here.  If we move them to the head of
>> > the function, can we get rid of dev_mutex entirely?
>>
>> No. As described in comment where lock is taken,
>> it ensures that if device is being removed while configuration is
>> going on, it protects against those race condition.
>> So will keep it as it is.
>
> Yeah, sure, it needs protection.  I was wondering why it needed to be
> a separate mutex.  The only sleeping operations seem to be the ones
> which can be done before or with acquiring rpool_list_lock, no?

I will just make one mutex lock now.

>
>> >> +     if (rpool->usage_sum == 0 &&
>> >> +         rpool->num_max_cnt == pool_info->table_len) {
>> >> +             /*
>> >> +              * No user of the rpool and all entries are set to max, so
>> >> +              * safe to delete this rpool.
>> >> +              */
>> >> +             list_del(&rpool->cg_list);
>> >> +             spin_unlock(&rpool_list_lock);
>> >> +
>> >> +             free_cg_rpool(rpool);
>> >
>> > Can't we just count the number of resources which either have !max
>> > setting or !0 usage?
>> >
>> What you have described here is done above. Instead of running loop to
>> find that out for every resource,
>
> You're summing up all usages instead of counting the number of !0
> usages.

I see now. Yeah, I will change that as well to make is consistent like
!max_entries.

>
>> as you suggested last time, keeping two counters for usage and max to
>> find out this condition.
>
> So, whether the counters are separate or not doesn't matter that much
> but it's awkward that it's counting the number of !max entries for
> limits while summing the actual usages (instead of counting the number
> of !0 usages) especially given that it gets summed into an int
> counter.  Wouldn't counting !max limit && !0 usage be more consistent?

>
>> >> +static u32 *get_cg_rpool_values(struct rdma_cgroup *cg,
>> >> +                             struct rdmacg_device *device,
>> >> +                             enum rdmacg_file_type sf_type,
>> >> +                             int count)
>> >> +{
>> >> +     struct rdmacg_resource_pool *rpool;
>> >> +     u32 *value_tbl;
>> >> +     int i, ret;
>> >> +
>> >> +     value_tbl = kcalloc(count, sizeof(u32), GFP_KERNEL);
>> >> +     if (!value_tbl) {
>> >> +             ret = -ENOMEM;
>> >> +             goto err;
>> >> +     }
>> >
>> > Do we need this type of interface?
>> Yes
>> > Why not let the caller look up the
>> > target pool and call this function with pool and resource index?
>>
>> I can move value_tbl allocation out of this function, but what is the
>> problem in current code?
>> I don't see any difference in moving loop count specific code outside
>> of get_cg_rpool_values() function other than doing rework. What gain
>> you are looking forward to by doing so?
>
> I meant you don't need the allocation at all.
>
>         lock;
>         for_each_dev() {
>                 pool = lookup_pool();
>                 for_each_field()
>                         seq_printf(sf, "%s ", name, pool_val(pool, index));
>         }
>         unlock;
>
> I don't know why you end up missing basic patterns so badly.  It's
> making the review and iteration process pretty painful.  Please don't
> be confrontational and try to read the review comments assuming good
> will.
>
My understanding of seq_printf() being blocking call and accessing
pool_info in spin lock context, made me allocate memory to get all
values upfront through allocation.
Now that the lock is going away, I can do what you have described above.



> Thanks.
>
> --
> tejun
