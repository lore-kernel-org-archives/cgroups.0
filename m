From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Mon, 4 Apr 2016 15:50:54 -0700
Message-ID: <CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
	<1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
	<20160404193640.GA7822@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=rsWjoete92MPwoYI0CG+KC1x8K1Knbnd84i+xPqdxKw=;
        b=sF30LgPhOSu5nXYUU/XzVRYLRoh5n6wkCT6swrwKm7EGZQuEIawu6UghnZF1WZWuxX
         IQzVWCWI2NWNdc9XblhRkjlO+fsEJ2sd5kAyVOcoXvio3XyPhRz4Quanj7Dr50L7u3k9
         KCj1j7+tCJEg/wHOo/JM2RZ8p1N1M8EH0NQhJrbKvoQEFdO1Ddno8cYxBqVPhAAGNfef
         VoMhnSAy5u61UtU5WIcUzy0Wt/FRI3+YWR2fdLZYw/+D5FqtCRL7r1BmzcjDitPyGm+F
         eIl70FvtPOISki+JszRsGs+mwomIX3MhpR7X0nbYLkUM3L+5GpNnT2jEimKi7NoqUJMN
         dzxQ==
In-Reply-To: <20160404193640.GA7822-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

On Mon, Apr 4, 2016 at 12:36 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> Sorry about the delay.
>
Thanks for the review. Comments and answers inline.

>> +struct rdma_cgroup {
>> +     struct cgroup_subsys_state      css;
>> +
>> +     /* protects resource pool list */
>> +     spinlock_t                      rpool_list_lock;
>
> Is this lock still being used?
Nop. I should have cleaned this up, as we have the global lock. It
must got added in patch recreation time.
I will remove it.

>
>> +     /*
>> +      * head to keep track of all resource pools
>> +      * that belongs to this cgroup.
>> +      */
>> +     struct list_head                rpool_head;
>> +};
>> +
>> +struct rdmacg_pool_info {
>> +     const char      **resource_name_table;
>> +     int             table_len;
>
> It's a bit bothering that resource type defs are outside the
> controller in a way the controller can't know and assumed to have the
> same type and range.  Architecting kernel code so that allow building
> modules separately can modify behaviors usually isn't a priority and

Module cannot really change the behavior just by adding/removing
new/old resource type.
Behavior is defined by the controller as it does today.

> styling things like this makes implementing specific one-off behaviors
> cumbersome.
I agree that other controllers are not doing this way, for some good
reason in those controllers.
But its not right to impose the same restriction here.
Code is really straight forward where pool_info array length is
dynamic, instead of static structure definition.
By addressing some of the comments to change from spin lock to mutex,
will further reduce the allocation complexity.
I believe that should be sufficient.

We have discussed advantages this approach in previous patches along
with consensus from other rdma experts.
In v9 you asked to document them clearly in the Documentation
indicating that its alright to define by the module as its done in v9
and v10 patch.

>
> It now looks okay but let's say in the future someone wants to use a
> different type and/or ranges for one of the resources, given the above
> framework, that person is most likely to blow up pool_info - first
> with types and min, max values and maybe later with callback handlers
> and so on, when the only thing which would have been necessary is an
> one-off handling of that specific setting in the interface functions.
>
We can always go back to change the scope of rdma cgroup at that point
to restrict for what you have described above. At present thats not
the scope and we have reduced the requirements to what is implemented
today.

Additionally if the min,max setting might arrive for a resource in
future, than its likely that it would be applicable to multiple
resources than one resource. And in that case putting them inside the
pool_info would be appropriate as well.
rdma cgroup will have to define the new interface at that point anyway.
We have to let this interface be usable first with current coded
functionality and flexibility that is not harmful.

> Making things modular comes at the cost of complexity and ad-hoc
> flexiblity.

At this point, complexity of this architecture is not really much.
Only overheads are kmalloc and kfree are done on resource pool whose
size is decided dynamically instead of a value defined in header file
in rdma_cgroup.h.
(Instead its in ib_verbs.h)
Its fair enough to have that flexibility.

>  There are cases where such overhead is warranted but as I
> mentioned before, I don't think this is one of them.  Please look back
> on how this patchset developed.  It has been a continuous process of
> cutting down complexities which didn't need to be there which is the
> opposite of what we usually want to do - buliding up sophiscation and
> complexity as necessary from something simple.  Please cut down this
> part too.

Tejun,
To repeat the basic motivation of this functionality/architecture is:
kernel upgrades are done over period of years at customers location.
Upgrading kernel for few rdma resources is really silly.
Current implementation anyway doesn't let modules define any crazy count either.
Currently only 64 different types of resources can be defined anyway.
New resource definition anyway goes through reviews by maintainers.
So as we talked in past, I would like to continue with this approach.

2nd advantage is, it allows avoiding lot of rework, in bundling kernel
modules with different kernel versions. So it is certainly valuable
feature with almost nil complexity cost of code or memory that solves
two problems with approach.
If there two kernel versions with different type of resources and
kernel modules with different resources, it gets ugly to maintain that
kind of compatibility using compat.h. This approach avoid all such
cases.

>
>> +};
>> +
>> +struct rdmacg_device {
>> +     struct rdmacg_pool_info pool_info;
>> +     struct list_head        rdmacg_list;
>> +     struct list_head        rpool_head;
>> +     /* protects resource pool list */
>> +     spinlock_t              rpool_lock;
>
> Does this still need to be a separate lock?
>
Nop. I got to remove this.

>> +#define RDMACG_MAX_STR "max"
>> +
>> +static DEFINE_MUTEX(dev_mutex);
>
> Can you please prefix the above with rdmacg?
o.k.
I will rename to rdmacg_mutex as I intent to remove all the spin locks
and have one mutex lock for all the protections.

>
>> +static LIST_HEAD(dev_list_head);
>
> Ditto, how about rdmacg_dev_list?
>
o.k.

>> +/*
>> + * resource pool object which represents per cgroup, per device
>> + * resources. There are multiple instance of this object per cgroup,
>                                             ^s
will fix this.

>> + * therefore it cannot be embedded within rdma_cgroup structure. It
>> + * is maintained as list.
>> + */
>> +struct rdmacg_resource_pool {
>> +     struct list_head        cg_list;
>> +     struct list_head        dev_list;
>
> Isn't it more conventional to use OBJ_list or OBJs for the head and
> _node or _link for the members?
>
_head is more readable than list to me. So I will keep the _head as it
is unless this is blocker for patch acceptance.
I will replace above two _list items with _node.

>> +static int
>> +alloc_cg_rpool(struct rdma_cgroup *cg, struct rdmacg_device *device)
>> +{
>> +     struct rdmacg_resource_pool *rpool, *other_rpool;
>> +     struct rdmacg_pool_info *pool_info = &device->pool_info;
>> +     int ret;
>> +
>> +     rpool = kzalloc(sizeof(*rpool), GFP_KERNEL);
>> +     if (!rpool) {
>> +             ret = -ENOMEM;
>> +             goto err;
>> +     }
>> +     rpool->resources = kcalloc(pool_info->table_len,
>> +                                sizeof(*rpool->resources),
>> +                                GFP_KERNEL);
>> +     if (!rpool->resources) {
>> +             ret = -ENOMEM;
>> +             goto alloc_err;
>> +     }
>> +
>> +     rpool->device = device;
>> +     INIT_LIST_HEAD(&rpool->cg_list);
>> +     INIT_LIST_HEAD(&rpool->dev_list);
>> +     spin_lock_init(&device->rpool_lock);
>> +     set_all_resource_max_limit(rpool);
>> +
>> +     spin_lock(&rpool_list_lock);
>> +
>> +     other_rpool = find_cg_rpool_locked(cg, device);
>> +
>> +     /*
>> +      * if other task added resource pool for this device for this cgroup
>> +      * than free up which was recently created and use the one we found.
>> +      */
>
> * It's usually a good idea to have hierarchical objects to be created
>   all the way to the root when a leaf node is requested and link
>   parent at each level.  That way, when a descendant object is looked
>   up, the caller can always deref its ->parent pointer till it reaches
>   the top.

This is interesting comment. I cannot recall, but I think its v4 or v5
was exactly doing same.
Allocating resource pool first in one loop and charging them in another.
In event of failure, uncharging them in 3rd.
And you gave comment that time is to move away from that approach for
simplicity!
That I had refcnt on each object.

Anyways,
Few things for above comment and some of the below comments.
1. I will replace all the spin lock to single mutex
2. With that it will be, try_charge() will be,
- lock()
- For multiple levels, until null parent,
      - allocate() for a given level.
      - charge for that level.
- unlock()
3. uncharge() will be,
- lock()
- uncharge(), free() if necessary at that level.
- unlock()

With this spuriousness issue that you described will also be addressed.


>
> * Unless it's a very hot path, using a mutex which protects creation
>   of new nodes is usually simpler than doing alloc -> lock ->
>   try-insert.  The concurrency in the creation path doesn't matter and
>   even if it mattered it isn't a good idea to bang on allocation path
>   concurrently anyway.
>
>> +static void
>> +uncharge_cg_resource_locked(struct rdma_cgroup *cg,
>> +                         struct rdmacg_device *device,
>> +                         int index)
>> +{
>> +     struct rdmacg_resource_pool *rpool;
>> +     struct rdmacg_pool_info *pool_info = &device->pool_info;
>> +
>> +     rpool = find_cg_rpool_locked(cg, device);
>
> So, with each pool linking to its parent, instead of looking up at
> each level, it can just follow ->parent recursively.

No. Lookup is being done for the rpool for that device and not the cgroup.
doing recursively using ->parent would require additional pointer of
rpool type to be maintained which is not necessary because we already
have cgroup level parent.
Adding ->parent would make it little faster compare to traversing 1 to
4 node entry list. However this is not hot path, so keeping existing
code to traverse is more desirable than adding ->parent of rpool type,
which also saves memory for large number of cgroup instances.

>
>> +     /*
>> +      * A negative count (or overflow) is invalid,
>> +      * it indicates a bug in the rdma controller.
>> +      */
>> +     WARN_ON_ONCE(rpool->resources[index].usage < 0);
>> +     rpool->usage_sum--;
>
> What guarantees that this count wouldn't overflow?  More on this
> later.

Are you suggesting to add WARN_ON for usage_sum variable for debugging?
I believe 1st warning is sufficient?

>
>> +/**
>> + * rdmacg_uncharge_resource - hierarchically uncharge rdma resource count
>> + * @device: pointer to rdmacg device
>> + * @index: index of the resource to uncharge in cg in given resource pool
>> + * @num: the number of rdma resource to uncharge
>> + *
>> + */
>> +void rdmacg_uncharge(struct rdma_cgroup *cg,
>> +                  struct rdmacg_device *device,
>> +                  int index)
>> +{
>> +     struct rdma_cgroup *p;
>> +
>> +     spin_lock(&rpool_list_lock);
>> +     for (p = cg; p; p = parent_rdmacg(p))
>> +             uncharge_cg_resource_locked(p, device, index);
>> +     spin_unlock(&rpool_list_lock);
>> +
>> +     css_put(&cg->css);
>
> Hmm... what css ref is the above putting?
Its putting the reference which was taken previously during charging time using,
get_current_rdmacg() which takes using task_get_css().

>
>> +int rdmacg_try_charge(struct rdma_cgroup **rdmacg,
>> +                   struct rdmacg_device *device,
>> +                   int index)
>> +{
> ...
>> +     spin_lock(&rpool_list_lock);
>> +     for (p = cg; p; p = parent_rdmacg(p)) {
>> +retry:
>> +             rpool = find_cg_rpool_locked(p, device);
>
> Here, too, you can look up the leaf node once and walk up the
> hierarhcy.  Maybe create a helper, say rdmacg_get_pool_and_lock(),
> which looks up an existing node or creates all pools from leaf to root
> and returns with the lock held?

A explained above, I will reduce rpool_list_lock and dev_mutex to
single rdmacg_mutex.
Lookup will still continue to avoid storing extra parent, because
lookup is for rpool which can be multiple per cgroup.

>
> ...
>> +err:
>> +     spin_lock(&rpool_list_lock);
>> +     for (q = cg; q != p; q = parent_rdmacg(q))
>> +             uncharge_cg_resource_locked(q, device, index);
>
> If some resources are not very plentiful and contended, dropping lock
> before error handling like above could lead to spurious failures.  It
> looks like the above is from trying to create pool at each level while
> charging up.  Creating all necessary pools at the outset should make
> the code simpler and more robust.
Same comment as above.

>
>> +     spin_unlock(&rpool_list_lock);
>> +     css_put(&cg->css);
>
> Ditto, where is this from?

From task_get_css, called by get_current_rdmacg() during charging time.

>
>> +void rdmacg_query_limit(struct rdmacg_device *device, int *limits)
>> +{
>> +     struct rdma_cgroup *cg, *p;
>> +     struct rdmacg_resource_pool *rpool;
>> +     struct rdmacg_pool_info *pool_info;
>> +     int i;
>> +
>> +     pool_info = &device->pool_info;
>> +
>> +     for (i = 0; i < pool_info->table_len; i++)
>> +             limits[i] = S32_MAX;
>> +
>> +     cg = get_current_rdmacg();
>> +     /*
>> +      * Check in hirerchy which pool get the least amount of
>> +      * resource limits.
>> +      */
>> +     spin_lock(&rpool_list_lock);
>> +     for (p = cg; p; p = parent_rdmacg(p)) {
>> +             rpool = find_cg_rpool_locked(cg, device);
>
> Ditto with lookup here.

Same comment as above, need to have lookup.

>
>> +static struct rdmacg_device *rdmacg_get_device_locked(const char *name)
>> +{
>> +     struct rdmacg_device *device;
>
> lockdep_assert_held() would be nice.

o.k. I will add this.

>
> +
>> +static ssize_t rdmacg_resource_set_max(struct kernfs_open_file *of,
>> +                                    char *buf, size_t nbytes, loff_t off)
>> +{
>> +     struct rdma_cgroup *cg = css_rdmacg(of_css(of));
>> +     const char *dev_name;
>> +     struct rdmacg_resource_pool *rpool;
>> +     struct rdmacg_device *device;
>> +     char *options = strstrip(buf);
>> +     struct rdmacg_pool_info *pool_info;
>> +     u64 enables = 0;
>> +     int *new_limits;
>> +     int i = 0, ret = 0;
>> +
>> +     /* extract the device name first */
>> +     dev_name = strsep(&options, " ");
>> +     if (!dev_name) {
>> +             ret = -EINVAL;
>> +             goto err;
>> +     }
>> +
>> +     /* acquire lock to synchronize with hot plug devices */
>> +     mutex_lock(&dev_mutex);
>> +
>> +     device = rdmacg_get_device_locked(dev_name);
>> +     if (!device) {
>> +             ret = -ENODEV;
>> +             goto parse_err;
>> +     }
>> +
>> +     pool_info = &device->pool_info;
>> +
>> +     new_limits = kcalloc(pool_info->table_len, sizeof(int), GFP_KERNEL);
>> +     if (!new_limits) {
>> +             ret = -ENOMEM;
>> +             goto parse_err;
>> +     }
>
> Hmm... except for new_limits allocation and alloc_cg_rpool()
> invocation, both of which can be done at the head of the function,
> nothing seems to require a mutex here.  If we move them to the head of
> the function, can we get rid of dev_mutex entirely?

No. As described in comment where lock is taken,
it ensures that if device is being removed while configuration is
going on, it protects against those race condition.
So will keep it as it is.

>
>> +     ret = rdmacg_parse_limits(options, pool_info, new_limits, &enables);
>> +     if (ret)
>> +             goto opt_err;
>> +
>> +retry:
>> +     spin_lock(&rpool_list_lock);
>> +     rpool = find_cg_rpool_locked(cg, device);
>> +     if (!rpool) {
>> +             spin_unlock(&rpool_list_lock);
>> +             ret = alloc_cg_rpool(cg, device);
>> +             if (ret)
>> +                     goto opt_err;
>> +             else
>> +                     goto retry;
>> +     }
>> +
>> +     /* now set the new limits of the rpool */
>> +     while (enables) {
>> +             /* if user set the limit, enables bit is set */
>> +             if (enables & BIT(i)) {
>> +                     enables &= ~BIT(i);
>> +                     set_resource_limit(rpool, i, new_limits[i]);
>> +             }
>> +             i++;
>> +     }
>
> Maybe we can use for_each_set_bit()?
ok. I will use that API.
>
>> +     if (rpool->usage_sum == 0 &&
>> +         rpool->num_max_cnt == pool_info->table_len) {
>> +             /*
>> +              * No user of the rpool and all entries are set to max, so
>> +              * safe to delete this rpool.
>> +              */
>> +             list_del(&rpool->cg_list);
>> +             spin_unlock(&rpool_list_lock);
>> +
>> +             free_cg_rpool(rpool);
>
> Can't we just count the number of resources which either have !max
> setting or !0 usage?
>
What you have described here is done above. Instead of running loop to
find that out for every resource,
as you suggested last time, keeping two counters for usage and max to
find out this condition.

>> +static u32 *get_cg_rpool_values(struct rdma_cgroup *cg,
>> +                             struct rdmacg_device *device,
>> +                             enum rdmacg_file_type sf_type,
>> +                             int count)
>> +{
>> +     struct rdmacg_resource_pool *rpool;
>> +     u32 *value_tbl;
>> +     int i, ret;
>> +
>> +     value_tbl = kcalloc(count, sizeof(u32), GFP_KERNEL);
>> +     if (!value_tbl) {
>> +             ret = -ENOMEM;
>> +             goto err;
>> +     }
>
> Do we need this type of interface?
Yes
> Why not let the caller look up the
> target pool and call this function with pool and resource index?

I can move value_tbl allocation out of this function, but what is the
problem in current code?
I don't see any difference in moving loop count specific code outside
of get_cg_rpool_values() function other than doing rework. What gain
you are looking forward to by doing so?
