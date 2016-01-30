From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Sun, 31 Jan 2016 02:14:13 +0530
Message-ID: <CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
	<1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
	<20160130183015.GP32380@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=9N4SPVDXq8/e43sZL4L7Rzxm0Vde5wA2QvfRgeS/bXo=;
        b=a7tryKUynWeeW0mufasqvMMQQ2mxTw1aPoX7ImsjtiOfNM/Vx3Ey26k83gUgqqN1lY
         DypnHQx9z8gnH7mSkjrcfMD+vuxhCfO+DAlSCtkUOSkjZ44owk0bi7lxfa6sI2dQCRxG
         e5f1YNvcsOYpQdaKb9bAKC/+VN7SJeQF8EdgbQubOLjIPKvcHNahak2jfHGI0EquV/sq
         xqLr7sdKyYvuX1thF57sPJ11i2aINLMGkvDpjR/koXUPk4eGnaYi1/6lABxrrSTwYIV9
         kOJ2lMUdHpb9L8axQBgjvxBJtWZ7ANWuzy8hm698Dg2d6/U/ikgoBqQ2J1xT2a8k5zjf
         UqFA==
In-Reply-To: <20160130183015.GP32380@htj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Tejun,

On Sun, Jan 31, 2016 at 12:00 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Sat, Jan 30, 2016 at 08:53:05PM +0530, Parav Pandit wrote:
>> +#ifdef CONFIG_CGROUP_RDMA
>> +#define RDMACG_MAX_RESOURCE_INDEX (64)
>
> The list of resources are known at compile time.  Why is this separate
> fixed number necessary?
>
Its not necessary. It was carry forwarded from older design. I will
remove in v4.

>> +struct match_token;
>
> There's no circular dependency issue here.  Include the appropriate
> header.

o.k. I will fix it.

>
>> +struct rdmacg_device;
>> +
>> +struct rdmacg_pool_info {
>> +     struct match_token *resource_table;
>> +     int resource_count;
>> +};
>> +
>> +struct rdmacg_resource_pool_ops {
>> +     struct rdmacg_pool_info*
>> +             (*get_resource_pool_tokens)(struct rdmacg_device *);
>> +};
>
> Why does it need external op table?  The types of resources are gonna
> be fixed at compile time.
IB modules are kernel loadable modules which are defining the resource.
So array size and their names are not defined at compile time of rdma
cgroup code.
Kernel code also cannot depend on loadable module file either via
inclusion as that in v2 patch.
That leads to crash when loadable modules are upgraded.
V1 patch had IB resources defined in the header file of rdmacg, which
I believe is very restrictive model with evolving rdma stack and
features.
Therefore it will be kept as defined in v3 patch in IB headers (non
compile time for rdma cgroup). So support infrastructure APIs will
continue.

> The only thing necessary is each device
> declaring which resources are to be used.
>
Thats what rpool_ops structure does, allowing to query name strings
and type of it by utilizing the match tokens.


>> +struct rdmacg_device {
>> +     struct rdmacg_resource_pool_ops
>> +                             *rpool_ops[RDMACG_RESOURCE_POOL_TYPE_MAX];
>> +     struct list_head        rdmacg_list;
>> +     char                    *name;
>> +};
>> +
>> +/* APIs for RDMA/IB stack to publish when a device wants to
>> + * participate in resource accounting
>> + */
>
> Please read CodingStyle.
>
Sorry about it. I will add the initial blank line. From driver
background I was avoiding it.

>> +config CGROUP_RDMA
>> +     bool "RDMA controller"
>> +     help
>> +       Provides enforcement of RDMA resources at RDMA/IB verb level and
>> +       enforcement of any RDMA/IB capable hardware advertized resources.
>                                                       ^^^^^^^^^?
>> +       Its fairly easy for applications to exhaust RDMA resources, which
>           ^^^
>> +       can result into kernel consumers or other application consumers of
>                      ^ in ^ just say "consumers"?
>> +       RDMA resources left with no resources. RDMA controller is designed
>           ^ The sentence doesn't read well.
>> +       to stop this from happening.
>> +       Attaching existing processes with active RDMA resources to the cgroup
>> +       hierarchy will be allowed even if can cross the hierarchy's limit.
>                                          ^^^^^?
>
Fixed them. Please review them in next patch.

>> +#define RDMACG_USR_CMD_REMOVE "remove"
>
> Why is this necessary?
>
User can unset the configured limit by writing "remove" for a given
device, instead of writing max values for all the resources.
As I explained in cover note and other comment, when its marked for
remove, the resource pool is marked as of default type so that it can
be freed. When all resources are freed, we don't free the rpool
because it holds the configured limit.

>> +/* resource tracker per resource for rdma cgroup */
>> +struct cg_resource {
>> +     int max;
>> +     atomic_t usage;
>> +};
>
> rdmacg_resource?  Also, wouldn't it be better to use u64?
>
I will change to rdmacg_resource. As present we have 24-bit wide resources.
64-bit might not needed in near future. If there are inputs comes from
Intel/Mellanox for this I will bump to 64-bit.
Otherwise I prefer to keep it 32-bit.

>> +/**
>> + * pool type indicating either it got created as part of default
>> + * operation or user has configured the group.
>> + * Depends on the creator of the pool, its decided to free up
>> + * later or not.
>> + */
>> +enum rpool_creator {
>> +     RDMACG_RPOOL_CREATOR_DEFAULT,
>> +     RDMACG_RPOOL_CREATOR_USR,
>> +};
>
> Why does this matter?
As you got in later comment and as I explained above, basically
resource marked as of user type is not freed, until either device goes
away or either user wants to clear the configuration.

>
>> +/**
>> + * resource pool object which represents, per cgroup, per device,
>> + * per resource pool_type resources. There are multiple instance
>> + * of this object per cgroup, therefore it cannot be embedded within
>> + * rdma_cgroup structure. Its maintained as list.
>> + */
>> +struct cg_resource_pool {
>> +     struct list_head cg_list;
>> +     struct rdmacg_device *device;
>> +     enum rdmacg_resource_pool_type type;
>> +
>> +     struct cg_resource *resources;
>> +
>> +     atomic_t refcnt;        /* count active user tasks of this pool */
>> +     atomic_t creator;       /* user created or default type */
>
> Why the hell would creator need to be an atomic?  You're just using
> set and read on the field.  What's going on?

Yes, I can make creator non atomic.

> static struct rdmacg_resource_pool_ops *
> get_pool_ops(...)
ok. Will fix it.

>
>> +{
>> +     return device->rpool_ops[pool_type];
>> +}
> ...
>> +static void _dealloc_cg_rpool(struct rdma_cgroup *cg,
>> +                           struct cg_resource_pool *rpool)
>> +{
>
> Ugh... please refrain from single underscore prefixed names.  It's
> best to give it a proper name.  e.g. if the function assumes lock is
> grabbed by the user use _locked postfix and so on.
>
o.k. For this particular one, I merged them to single function.

>> +     spin_lock(&cg->cg_list_lock);
>> +
>> +     /* if its started getting used by other task, before we take the
>> +      * spin lock, then skip freeing it.
>> +      */
>
> Again, CodingStyle.

I will fix it.

>
>> +static void dealloc_cg_rpool(struct rdma_cgroup *cg,
>> +                          struct cg_resource_pool *rpool)
>> +{
>> +     /* Don't free the resource pool which is created by the
>> +      * user, otherwise we lose the configured limits. We don't
>> +      * gain much either by splitting storage of limit and usage.
>> +      * So keep it around until user deletes the limits.
>> +      */
>> +     if (atomic_read(&rpool->creator) == RDMACG_RPOOL_CREATOR_DEFAULT)
>> +             _dealloc_cg_rpool(cg, rpool);
>> +}
>
> The config is tied to the device.  If the device goes away, all its
> pools go away.  If the device stays, all configs stay.
>
config stays, until the resources are allocated. If device is there,
we don't create resource pool for all the created cgroups to save
memory with this little extra code.

>> +static struct cg_resource_pool*
>> +     find_cg_rpool(struct rdma_cgroup *cg,
>> +                   struct rdmacg_device *device,
>> +                   enum rdmacg_resource_pool_type type)
>> +
>> +{
>> +     struct cg_resource_pool *pool;
>> +
>
> lockdep_assert_held(...)
>
>> +     list_for_each_entry(pool, &cg->rpool_head, cg_list)
>> +             if (pool->device == device && pool->type == type)
>> +                     return pool;
>> +
>> +     return NULL;
>> +}
>> +
>> +static struct cg_resource_pool*
>> +     _get_cg_rpool(struct rdma_cgroup *cg,
>> +                   struct rdmacg_device *device,
>> +                   enum rdmacg_resource_pool_type type)
>> +{
>> +     struct cg_resource_pool *rpool;
>> +
>> +     spin_lock(&cg->cg_list_lock);
>> +     rpool = find_cg_rpool(cg, device, type);
>> +     if (rpool)
>> +             goto found;
>> +found:
>
> That's one extremely silly way to write noop.
>
>> +     spin_unlock(&cg->cg_list_lock);
>> +     return rpool;
>> +}
>
> This function doesn't make any sense.  Push locking to the caller and
> use find_cg_rpool().

This is nice wrapper around find_cg_rpool to write clean code. I would
like to keep it for code readability.
if(rpool) check can be removed, because for this function its going to
be true always.

>
>> +static struct cg_resource_pool*
>> +     get_cg_rpool(struct rdma_cgroup *cg,
>> +                  struct rdmacg_device *device,
>> +                  enum rdmacg_resource_pool_type type)
>> +{
>> +     struct cg_resource_pool *rpool, *other_rpool;
>> +     struct rdmacg_pool_info *pool_info;
>> +     struct rdmacg_resource_pool_ops *ops;
>> +     int ret = 0;
>> +
>> +     spin_lock(&cg->cg_list_lock);
>> +     rpool = find_cg_rpool(cg, device, type);
>> +     if (rpool) {
>> +             atomic_inc(&rpool->refcnt);
>> +             spin_unlock(&cg->cg_list_lock);
>> +             return rpool;
>> +     }
>
> Why does it need refcnting?  Things stay if the device is there.
> Things go away if the device goes away.  No?

No. If there is one device and 100 cgroups, we create resource pools
when there is actually any of the process wants to perform charging.
(Instead of creating 100 resource pools just because cgroup exists).
So reference count of the rpool checks that when last resource is
freed, it frees the resource pool, if its allocated as default pool.
If user has configured the pool, than it stays (until device goes away).

> Can device go away while resources are allocated?
No. Thats ensured by the IB stack as following correct sequence of destruction.

>
>> +     spin_unlock(&cg->cg_list_lock);
>> +
>> +     /* ops cannot be NULL at this stage, as caller made to charge/get
>> +      * the resource pool being aware of such need and invoking with
>> +      * because it has setup resource pool ops.
>> +      */
>> +     ops = get_pool_ops(device, type);
>> +     pool_info = ops->get_resource_pool_tokens(device);
>> +     if (!pool_info) {
>> +             ret = -EINVAL;
>> +             goto err;
>> +     }
>
> Please just do
>
> enum {
>         RDMA_RES_VERB_A,
>         RDMA_RES_VERB_B,
>         ...
>         RDMA_RES_VERB_MAX,
>
>         RDMA_RES_HW_BASE = RDMA_RES_VERB_MAX,
>         RDMA_RES_HW_A = RDMA_RES_HW_BASE,
>         RDMA_RES_HW_B,
>         ...
>         RDMA_RES_HW_MAX,
> };
>
> static const char rdma_res_name[] = {
>         [RDMA_RES_VERB_A]       = "...",
>         ...
> };

What you have described is done in little different way in the
loadable kernel module as explained earlier to let it defined by the
IB stack.
Otherwise this needs to be defined in rdma cgroup header file like my
v0 patch, which I certainly want to avoid.
>
> And then let each device specify bitmap of resources that it supports
> on registration.
>
>> +     if (pool_info->resource_count == 0 ||
>> +         pool_info->resource_count > RDMACG_MAX_RESOURCE_INDEX) {
>> +             ret = -EINVAL;
>> +             goto err;
>> +     }
>> +
>> +     /* allocate resource pool */
>> +     rpool = alloc_cg_rpool(cg, device, pool_info->resource_count, type);
>> +     if (IS_ERR_OR_NULL(rpool))
>> +             return rpool;
>> +
>> +     /* cgroup lock is held to synchronize with multiple
>> +      * resource pool creation in parallel.
>> +      */
>> +     spin_lock(&cg->cg_list_lock);
>> +     other_rpool = find_cg_rpool(cg, device, type);
>> +     /* if other task added resource pool for this device for this cgroup
>> +      * free up which was recently created and use the one we found.
>> +      */
>> +     if (other_rpool) {
>> +             atomic_inc(&other_rpool->refcnt);
>> +             spin_unlock(&cg->cg_list_lock);
>> +             _free_cg_rpool(rpool);
>> +             return other_rpool;
>> +     }
>> +
>> +     atomic_inc(&rpool->refcnt);
>> +     list_add_tail(&rpool->cg_list, &cg->rpool_head);
>> +
>> +     spin_unlock(&cg->cg_list_lock);
>> +     return rpool;
>> +
>> +err:
>> +     spin_unlock(&cg->cg_list_lock);
>> +     return ERR_PTR(ret);
>> +}
>
> You're grabbing the lock anyway.  Why bother with atomics at all?
> Just grab the lock on entry, look up the entry and then do normal
> integer ops.
While we free the entry, we don't grab the lock if the refcnt is not
reached zero.
Please refer to put_cg_rpool that does that.

>
> The whole thing is still way more complex than it needs to be.  Please
> slim it down.  It really shouldn't take half as much code.  Keep it
> simple, please.

I have tried to keep as simple as possible.
If you have specific comments like above, I can certainly address them.

>
> Thanks.
>
> --
> tejun
