From: Ofir Gal <ofir.gal-83CFe9096HFBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] nvmet: allow associating port to a cgroup via configfs
Date: Thu, 29 Jun 2023 18:21:34 +0300
Message-ID: <79894bd9-03c7-8d27-eb6a-5e1336550449@volumez.com>
References: <20230627100215.1206008-1-ofir.gal@volumez.com>
 <30d03bba-c2e1-7847-f17e-403d4e648228@grimberg.me>
 <90150ffd-ba2d-6528-21b7-7ea493cd2b9a@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p+MMVO/dqjwV1A2wjcuyWZSsEAaTmHE1YpSZ36251Ow=;
 b=cVWPtNYHz7p684ZEBKwTZQ9DcofpySGBTp2bbB18aRRdVX38FJ7qkSme+1IsbiwV44wDakL8epTryohyrm9lD/U8nThZZsRKdVpeRvubvZDjvmmZaZPGXwxZWG/1yFz0QnKimmDG1bAAgFH5VO1XYArEYitJEK+K7wKOQcbmIyM6gr6YfJpnoSdncC1RrwTbuITI3UTC7j0Fd3pgwQWrAA+x+ZYVC/QGLGwf5u4iydjgwd9kOd5XZyV+xkW0FHDqAvpF0HZ3EfIXjcUxy4KLe8KRg+UT/5gUSUjNQ5TcuGrcxFwhtQNch4Ox1BnntFKX8Mg0068KcEJUzStePuJukg==
Content-Language: en-US
In-Reply-To: <90150ffd-ba2d-6528-21b7-7ea493cd2b9a-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hey Sagi and Chaitanya,

On 28/06/2023 5:33, Chaitanya Kulkarni wrote:
> On 6/27/23 14:13, Sagi Grimberg wrote:
>> Hey Ofir,
>>
>>> Currently there is no way to throttle nvme targets with cgroup v2.
>>
>> How do you do it with v1?
With v1 I would add a blkio rule at the cgroup root level. The bio's
that the nvme target submits aren't associated to a specific cgroup,
which makes them follow the rules of the cgroup root level.

V2 doesn't allow to set rules at the root level by design.

>>> The IOs that the nvme target submits lack associating to a cgroup,
>>> which makes them act as root cgroup. The root cgroup can't be throttled
>>> with the cgroup v2 mechanism.
>>
>> What happens to file or passthru backends? You paid attention just to
>> bdev. I don't see how this is sanely supported with files. It's possible
>> if you convert nvmet to use its own dedicated kthreads and infer the
>> cg from the kthread. That presents a whole other set of issues.
>>
> 
> if we are doing it for one back-end we cannot leave other back-ends out ...
> 
>> Maybe the cleanest way to implement something like this is to implement
>> a full blown nvmet cgroup controller that you can apply a whole set of
>> resources to, in addition to I/O.

Thorttiling files and passthru isn't possible with cgroup v1 as well,
cgroup v2 broke the abillity to throttle bdevs. The purpose of the patch
is to re-enable the broken functionality.

There was an attempt to re-enable the functionality by allowing io
throttle on the root cgroup but it's against the cgroup v2 design.
Reference:
https://lore.kernel.org/r/20220114093000.3323470-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/

A full blown nvmet cgroup controller may be a complete solution, but it
may take some time to achieve, while the feature is still broken.

>>
>>> Signed-off-by: Ofir Gal <ofir.gal-83CFe9096HFBDgjK7y7TUQ@public.gmane.org>
>>> ---
>>>   drivers/nvme/target/configfs.c    | 77 +++++++++++++++++++++++++++++++
>>>   drivers/nvme/target/core.c        |  3 ++
>>>   drivers/nvme/target/io-cmd-bdev.c | 13 ++++++
>>>   drivers/nvme/target/nvmet.h       |  3 ++
>>>   include/linux/cgroup.h            |  5 ++
>>>   kernel/cgroup/cgroup-internal.h   |  5 --
>>
>> Don't mix cgroup and nvmet changes in the same patch.

Thanks for claryfing I wansn's sure if it's nessecary I would split the
patch for v2.

>>
>>>   6 files changed, 101 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/nvme/target/configfs.c 
>>> b/drivers/nvme/target/configfs.c
>>> index 907143870da5..2e8f93a07498 100644
>>> --- a/drivers/nvme/target/configfs.c
>>> +++ b/drivers/nvme/target/configfs.c
>>> @@ -12,6 +12,7 @@
>>>   #include <linux/ctype.h>
>>>   #include <linux/pci.h>
>>>   #include <linux/pci-p2pdma.h>
>>> +#include <linux/cgroup.h>
>>>   #ifdef CONFIG_NVME_TARGET_AUTH
>>>   #include <linux/nvme-auth.h>
>>>   #endif
>>> @@ -281,6 +282,81 @@ static ssize_t 
>>> nvmet_param_pi_enable_store(struct config_item *item,
>>>   CONFIGFS_ATTR(nvmet_, param_pi_enable);
>>>   #endif
>>>   +static ssize_t nvmet_param_associated_cgroup_show(struct 
>>> config_item *item,
>>> +        char *page)
>>> +{
>>> +    struct nvmet_port *port = to_nvmet_port(item);
>>> +    ssize_t len = 0;
>>> +    ssize_t retval;
>>> +    char *suffix;
>>> +
>>> +    /* No cgroup has been set means the IOs are assoicated to the 
>>> root cgroup */
>>> +    if (!port->cgrp)
>>> +        goto root_cgroup;
>>> +
>>> +    retval = cgroup_path_ns(port->cgrp, page, PAGE_SIZE,
>>> +                         current->nsproxy->cgroup_ns);
>>> +    if (retval >= PATH_MAX || retval >= PAGE_SIZE)
>>> +        return -ENAMETOOLONG;
>>> +
>>> +    /* No cgroup found means the IOs are assoicated to the root 
>>> cgroup */
>>> +    if (retval < 0)
>>> +        goto root_cgroup;
>>> +
>>> +    len += retval;
>>> +
>>> +    suffix = cgroup_is_dead(port->cgrp) ? " (deleted)\n" : "\n";
>>> +    len += snprintf(page + len, PAGE_SIZE - len, suffix);
>>> +
>>> +    return len;
>>> +
>>> +root_cgroup:
>>> +    return snprintf(page, PAGE_SIZE, "/\n");
>>> +}
>>> +
>>> +static ssize_t nvmet_param_associated_cgroup_store(struct 
>>> config_item *item,
>>> +        const char *page, size_t count)
>>> +{
>>> +    struct nvmet_port *port = to_nvmet_port(item);
>>> +    struct cgroup_subsys_state *blkcg;
>>> +    ssize_t retval = -EINVAL;
>>> +    struct cgroup *cgrp;
>>> +    char *path;
>>> +    int len;
>>> +
>>> +    len = strcspn(page, "\n");
>>> +    if (!len)
>>> +        return -EINVAL;
>>> +
>>> +    path = kmemdup_nul(page, len, GFP_KERNEL);
>>> +    if (!path)
>>> +        return -ENOMEM;
>>> +
>>> +    cgrp = cgroup_get_from_path(path);
>>> +    kfree(path);
>>> +    if (IS_ERR(cgrp))
>>> +        return -ENOENT;
>>> +
>>> +    blkcg = cgroup_get_e_css(cgrp, &io_cgrp_subsys);
>>> +    if (!blkcg)
>>> +        goto out_put_cgroup;
>>> +
>>> +    /* Put old cgroup */
>>> +    if (port->cgrp)
>>> +        cgroup_put(port->cgrp);
>>> +
>>> +    port->cgrp = cgrp;
>>> +    port->blkcg = blkcg;
>>> +
>>> +    return count;
>>> +
>>> +out_put_cgroup:
>>> +    cgroup_put(cgrp);
>>> +    return retval;
>>> +}
>>
>> I'm not at all convinced that nvmet ratelimiting does not
>> require a dedicated cgroup controller... Rgardles, this doesn't
>> look like a port attribute, its a subsystem attribute.
> 
> +1 here, can you please explain the choice of port ?

In cgroup threads/processes are associated to a specific control group.
Each control group may have different rules to throttle various devices.
For example we may have 2 applications both using the same bdev.
By associating the apps to different cgroups, we can create a different
throttling rule for each app.
Throttling is done by echoing "MAJOR:MINOR rbps=X wiops=Y" to "io.max"
of the cgroup.

Associating a subsystem to a cgroup will only allow us to create a
single rule for each namespace (bdev) in this subsystem.
When associating the nvme port to the cgroup it acts as the "thread"
that handles the IO for the target, which aligns with the cgroup design.

Regardless if the attribute is part of the port or the subsystem, the
user needs to specify constraints per namespace. I see no clear value in
setting the cgroup attribute on the subsystem.

On the other hand, by associating a port to a cgroup we could have
multiple constraints per namespace. It will allow the user to have more
control of the behavior of his system.
For example a system with a RDMA port and a TCP port that are connected
to the same subsystem's can apply different limits for each port.

This could be complimentary to NVMe ANA for example, where the target
could apply different constraints for optimized and non-optimized paths

To elaborate, such approach fits nicely into NVMe controller model.
Controllers report namespace's ANA group and different controllers may
report different ANA groups for the same namespace.
So, namespace's ANA group is basically a property of controller and not
a property of subsystem.
Further, the controller is associated with port and thus might inherit
some of its properties.

> also for cgroup related changes I think you need to CC Tejun who's
> the author of the cgroup_is_dead() and whatever the right mailing list ..
> 
> -ck

Thanks for clarifying I wasn't sure if it's necessary or not.

>> +
>> +CONFIGFS_ATTR(nvmet_, param_associated_cgroup);
>> +
>>   static ssize_t nvmet_addr_trtype_show(struct config_item *item,
>>   		char *page)
>>   {
>> @@ -1742,6 +1818,7 @@ static struct configfs_attribute *nvmet_port_attrs[] = {
>>   	&nvmet_attr_addr_trsvcid,
>>   	&nvmet_attr_addr_trtype,
>>   	&nvmet_attr_param_inline_data_size,
>> +	&nvmet_attr_param_associated_cgroup,
>>   #ifdef CONFIG_BLK_DEV_INTEGRITY
>>   	&nvmet_attr_param_pi_enable,
>>   #endif
>> diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
>> index 3935165048e7..b63996b61c6d 100644
>> --- a/drivers/nvme/target/core.c
>> +++ b/drivers/nvme/target/core.c
>> @@ -376,6 +376,9 @@ void nvmet_disable_port(struct nvmet_port *port)
>>   	port->enabled = false;
>>   	port->tr_ops = NULL;
>>   
>> +	if (port->cgrp)
>> +		cgroup_put(port->cgrp);
>> +
>>   	ops = nvmet_transports[port->disc_addr.trtype];
>>   	ops->remove_port(port);
>>   	module_put(ops->owner);
>> diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
>> index c2d6cea0236b..eb63a071131d 100644
>> --- a/drivers/nvme/target/io-cmd-bdev.c
>> +++ b/drivers/nvme/target/io-cmd-bdev.c
>> @@ -8,6 +8,8 @@
>>   #include <linux/blk-integrity.h>
>>   #include <linux/memremap.h>
>>   #include <linux/module.h>
>> +#include <linux/cgroup.h>
>> +#include <linux/blk-cgroup.h>
>>   #include "nvmet.h"
>>   
>>   void nvmet_bdev_set_limits(struct block_device *bdev, struct nvme_id_ns *id)
>> @@ -285,6 +287,8 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
>>   	bio->bi_iter.bi_sector = sector;
>>   	bio->bi_private = req;
>>   	bio->bi_end_io = nvmet_bio_done;
>> +	if (req->port->blkcg)
>> +		bio_associate_blkg_from_css(bio, req->port->blkcg);
>>   
>>   	blk_start_plug(&plug);
>>   	if (req->metadata_len)
>> @@ -308,6 +312,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
>>   			bio = bio_alloc(req->ns->bdev, bio_max_segs(sg_cnt),
>>   					opf, GFP_KERNEL);
>>   			bio->bi_iter.bi_sector = sector;
>> +			bio_clone_blkg_association(bio, prev);
>>   
>>   			bio_chain(bio, prev);
>>   			submit_bio(prev);
>> @@ -345,6 +350,8 @@ static void nvmet_bdev_execute_flush(struct nvmet_req *req)
>>   		 ARRAY_SIZE(req->inline_bvec), REQ_OP_WRITE | REQ_PREFLUSH);
>>   	bio->bi_private = req;
>>   	bio->bi_end_io = nvmet_bio_done;
>> +	if (req->port->blkcg)
>> +		bio_associate_blkg_from_css(bio, req->port->blkcg);
>>   
>>   	submit_bio(bio);
>>   }
>> @@ -397,6 +404,9 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
>>   	if (bio) {
>>   		bio->bi_private = req;
>>   		bio->bi_end_io = nvmet_bio_done;
>> +		if (req->port->blkcg)
>> +			bio_associate_blkg_from_css(bio, req->port->blkcg);
>> +
>>   		if (status)
>>   			bio_io_error(bio);
>>   		else
>> @@ -444,6 +454,9 @@ static void nvmet_bdev_execute_write_zeroes(struct nvmet_req *req)
>>   	if (bio) {
>>   		bio->bi_private = req;
>>   		bio->bi_end_io = nvmet_bio_done;
>> +		if (req->port->blkcg)
>> +			bio_associate_blkg_from_css(bio, req->port->blkcg);
>> +
>>   		submit_bio(bio);
>>   	} else {
>>   		nvmet_req_complete(req, errno_to_nvme_status(req, ret));
>> diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
>> index dc60a22646f7..3e5c9737d07e 100644
>> --- a/drivers/nvme/target/nvmet.h
>> +++ b/drivers/nvme/target/nvmet.h
>> @@ -20,6 +20,7 @@
>>   #include <linux/blkdev.h>
>>   #include <linux/radix-tree.h>
>>   #include <linux/t10-pi.h>
>> +#include <linux/cgroup.h>
>>   
>>   #define NVMET_DEFAULT_VS		NVME_VS(1, 3, 0)
>>   
>> @@ -163,6 +164,8 @@ struct nvmet_port {
>>   	int				inline_data_size;
>>   	const struct nvmet_fabrics_ops	*tr_ops;
>>   	bool				pi_enable;
>> +	struct cgroup				*cgrp;
>> +	struct cgroup_subsys_state	*blkcg;
>>   };
>>   
>>   static inline struct nvmet_port *to_nvmet_port(struct config_item *item)
>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>> index 885f5395fcd0..47e2a7cdc31e 100644
>> --- a/include/linux/cgroup.h
>> +++ b/include/linux/cgroup.h
>> @@ -562,6 +562,11 @@ static inline bool cgroup_is_populated(struct cgroup *cgrp)
>>   		cgrp->nr_populated_threaded_children;
>>   }
>>   
>> +static inline bool cgroup_is_dead(const struct cgroup *cgrp)
>> +{
>> +	return !(cgrp->self.flags & CSS_ONLINE);
>> +}
>> +
>>   /* returns ino associated with a cgroup */
>>   static inline ino_t cgroup_ino(struct cgroup *cgrp)
>>   {
>> diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
>> index 367b0a42ada9..8c5c83e9edd7 100644
>> --- a/kernel/cgroup/cgroup-internal.h
>> +++ b/kernel/cgroup/cgroup-internal.h
>> @@ -181,11 +181,6 @@ extern struct list_head cgroup_roots;
>>   	for ((ssid) = 0; (ssid) < CGROUP_SUBSYS_COUNT &&		\
>>   	     (((ss) = cgroup_subsys[ssid]) || true); (ssid)++)
>>   
>> -static inline bool cgroup_is_dead(const struct cgroup *cgrp)
>> -{
>> -	return !(cgrp->self.flags & CSS_ONLINE);
>> -}
>> -
>>   static inline bool notify_on_release(const struct cgroup *cgrp)
>>   {
>>   	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);


