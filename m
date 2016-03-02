From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 3 Mar 2016 01:28:55 +0530
Message-ID: <CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
	<1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
	<20160302173949.GG29826@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=UK8HCYynYNAXYPqEUuncYnDJBO4QZfNOAGVRa1TBPe0=;
        b=faAS5mUDx0vTpcMnYapGBnDGryI+uCdaPO288hBMOxCbZCU/hxy0tzZO1zvebrkSTC
         IAzmCZeZPBjwSEJb/fkZG/K5ohmVel5EU8yWCWmz3YtihOtcPQQNW4QOydDkMK1k8c8s
         3KjJvb8yw4NpItHSF8iiSxL+4YjURabzDygI/8PDE+XDPRsrM4xfHCZ9mb/7dg8pLHT3
         bUClJyxCteFRUgTyNz4BAwWJITPW96Er7VV57LafBFHvPgVrxrQWqjNgXz4l/+LSRTeQ
         ejHyZzJQ5vjHWFHuPRLzHIBCkGc2m1dzv7ZXGk8geqyU7hhtKJbf6pxvTP5SP1okJvxz
         S9hg==
In-Reply-To: <20160302173949.GG29826@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Wed, Mar 2, 2016 at 11:09 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
>> +struct rdma_cgroup {
>> +     struct cgroup_subsys_state      css;
>> +
>> +     spinlock_t rpool_list_lock;     /* protects resource pool list */
>> +     struct list_head rpool_head;    /* head to keep track of all resource
>> +                                      * pools that belongs to this cgroup.
>> +                                      */
>
> I think we usually don't tail wing these comments.

ok. I will put comments in separate line.

>
>> +};
>> +
>> +struct rdmacg_pool_info {
>> +     const char **resource_name_table;
>> +     int table_len;
>
> Align fields consistently?  I've said this multiple times now but
> please make the available resources constant and document them in
> Documentation/cgroup-v2.txt.

o.k. I will align them.
o.k. I will document the resource constants defined by IB stack in
cgroup-v2.txt.

>> +
>> +/* APIs for RDMA/IB stack to publish when a device wants to
>> + * participate in resource accounting
>> + */
>
> Please follow CodingStyle.  Wasn't this pointed out a couple times
> already?
Yes. You did. I fixed at few places. I missed this out. Sorry. I am doing now.

>
>> +enum rdmacg_file_type {
>> +     RDMACG_RESOURCE_MAX,
>> +     RDMACG_RESOURCE_STAT,
>> +};
>
> Heh, usually not a good sign.  If you're using this to call into a
> common function and then switch out on the file type, just switch out
> at the method level and factor out common part into helpers.
>
Methods for both the constants are same. Code changes between two file
type is hardly 4 lines of code.
So there is no need of additional helper functions.
So in currently defined functions rdmacg_resource_read() and
rdmacg_resource_set_max() works on file type.

>> +/* resource tracker per resource for rdma cgroup */
>> +struct rdmacg_resource {
>> +     int max;
>> +     int usage;
>> +};
>
> Align fields?

Above one seems to be aligned. Not sure what am I missing.
I am aligning all the structures anyways.

>
>> +/**
>
> The above indicates kerneldoc comments, which this isn't.
Fixed for this comment.

>
>> + * resource pool object which represents, per cgroup, per device
>> + * resources. There are multiple instance
>> + * of this object per cgroup, therefore it cannot be embedded within
>> + * rdma_cgroup structure. It is maintained as list.
>
> Consistent paragraph fill?
Fixed.

>

>> + */
>> +struct rdmacg_resource_pool {
>> +     struct list_head cg_list;
>> +     struct list_head dev_list;
>> +
>> +     struct rdmacg_device *device;
>> +     struct rdmacg_resource *resources;
>> +     struct rdma_cgroup *cg; /* owner cg used during device cleanup */
>> +
>> +     int     refcnt;         /* count active user tasks of this pool */
>> +     int     num_max_cnt;    /* total number counts which are set to max */
>> +};
>
> Formatting.

Aligning all the fields now in next patch.

>
>> +static inline void set_resource_limit(struct rdmacg_resource_pool *rpool,
>> +                                   int index, int new_max)
>
> Is inline necessary?  Compiler can figure out these.
Yes. Removed.

>
>> +static struct rdmacg_resource_pool*
>                                      ^
>                                      space
>
>> +find_cg_rpool_locked(struct rdma_cgroup *cg,
>> +                  struct rdmacg_device *device)
> ...
>> +static void uncharge_cg_resource(struct rdma_cgroup *cg,
>> +                              struct rdmacg_device *device,
>> +                              int index, int num)
>> +{
> ...
>> +     rpool->refcnt--;
>> +     if (rpool->refcnt == 0 && rpool->num_max_cnt == pool_info->table_len) {
>
> If the caller charges 2 and then uncharges 1 two times, the refcnt
> underflows?  Why not just track how many usages are zero?
>
This is certainly must fix bug. Changed refcnt to usage_sum and changed to do
usage_sum -= num during uncharging
and
usage_sum += num during charing.

> ...
>> +void rdmacg_uncharge(struct rdma_cgroup *cg,
>> +                  struct rdmacg_device *device,
>> +                  int index, int num)
>> +{
>> +     struct rdma_cgroup *p;
>> +
>> +     for (p = cg; p; p = parent_rdmacg(p))
>> +             uncharge_cg_resource(p, device, index, num);
>> +
>> +     css_put(&cg->css);
>> +}
>> +EXPORT_SYMBOL(rdmacg_uncharge);
>
> So, I suppose the code is trying to save lock contention with
> fine-grained locking;
Yes.
> however, as the code is currently structured,
> it's just increasing the number of lock ops and it'd be highly likely
> to cheaper to simply use a single lock.

Single lock per subsystem? I understood that you were ok to have per
cgroup fine grain lock.

> If you're working up the tree
> grabbing lock at each level, per-node locking doesn't save you
> anything.  Also, it introduces conditions where charges are spuriously
> denied when there are racing requestors.  If scalability becomes an
> issue, the right way to address is adding percpu front cache.
>
>> +void rdmacg_query_limit(struct rdmacg_device *device,
>> +                     int *limits)
>> +{
>> +     struct rdma_cgroup *cg, *p;
>> +     struct rdmacg_resource_pool *rpool;
>> +     struct rdmacg_pool_info *pool_info;
>> +     int i;
>> +
>> +     cg = task_rdmacg(current);
>> +     pool_info = &device->pool_info;
>
> Nothing seems to prevent @cg from going away if this races with
> @current being migrated to a different cgroup.  Have you run this with
> lockdep and rcu debugging enabled?  This should have triggered a
> warning.
No. debugging was disabled. I will enable and run.
Help me little to understand,
Even if above function races with migration, do you mean cg can be
freed before css_get is executed?
If yes, than I guess I need subsystem level lock under which I need to
perform css_get()?
If not, whatever cg was returned, that should be ok as long as cg
reference is hold.
May be I am missing something here.

>
> ...
>> +     for (p = cg; p; p = parent_rdmacg(p)) {
>> +             spin_lock(&cg->rpool_list_lock);
>> +             rpool = find_cg_rpool_locked(cg, device);
>> +             if (rpool) {
>> +                     for (i = 0; i < pool_info->table_len; i++)
>> +                             limits[i] = min_t(int, limits[i],
>> +                                     rpool->resources[i].max);
>
> So, the O complexity wise, things like the above are pretty bad and
> the above pattern is used in hot paths.
No. Its hot path. Typically applications do query configuration once
is their life cycle and allocate resources more often.

> I suppose there can only be a handful of devices per system?
Right. I have described that in the document as well. Typically there
are 1 to 4 devices in system and since the lock is per cgroup, though
this loop appears to be heavy on O complexity wise, its not that bad.
Hierarchical limit honoring is anyway default behavior we are adhering to.

>
> Thanks.
>
> --
> tejun
