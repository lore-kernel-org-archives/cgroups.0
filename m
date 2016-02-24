From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 24 Feb 2016 21:46:32 +0530
Message-ID: <CAG53R5Uof+Ve7CndWy=BrgtxxCisQpzP_Ls0kw=Q270DhoEsZw@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
	<56CDAC7A.6030206@mellanox.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=foxtPekTa20Ph762TmR9ukZmQMQf41rOInjvM5LbNdw=;
        b=qVg41hoW0SWZxqT5G9RCy8qwwgeRQUycZr14NzN39cmMuzYCQQs35GLuq6csUHNrCJ
         YvI7P6Ag5Ojv7s0xwDZiklayyKHVR+KT/W7OFM4F2IDCYm8VziV419SPAZqoXQJ6laUI
         rUPYAu592kdQxygZvLcthsUBK9R8mo1qQme+sw5mhcxUJE0Dh2N1DIgykNbIU3unaGN/
         VhzaGI6GlN2qW+wqs3S/jE6/W1b0bYFuVV8xzbYH+zAIWVolhtApdnhCsBVQPwositCS
         QKA7NxFj2i9iP7H/krd89RQJHxC4l8hCDXzjiU6KCqHFEsqyenFR4cd6lL0QQR6sI2vi
         4ogQ==
In-Reply-To: <56CDAC7A.6030206-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 24, 2016 at 6:43 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hi,
>
> Overall I the patch looks good to me. I have a few comments below.
>
Thanks for the review. Addressing most comments one.
Some comments inline.


> Its -> It's
Ok.

>> +void rdmacg_query_limit(struct rdmacg_device *device,
>> +                     int *limits, int max_count);
> You can drop the max_count parameter, and require the caller to
> always provide pool_info->table_len items, couldn't you?
>
Done.

>> +       can result into resource unavailibility to other consumers.
> unavailibility -> unavailability
Done.

>> +     struct rdmacg_resource_pool *rpool;
>> +     struct rdmacg_pool_info *pool_info = &device->pool_info;
>> +
>> +     spin_lock(&cg->rpool_list_lock);
>> +     rpool = find_cg_rpool_locked(cg, device);
> Is it possible for rpool to be NULL?
>
Unlikely, unless we have but in cgroup implementation.
It may be worth to add WARN_ON and return from here to avoid kernel crash.

>> +static int charge_cg_resource(struct rdma_cgroup *cg,
>> +                           struct rdmacg_device *device,
>> +                           int index, int num)
>> +{
>> +     struct rdmacg_resource_pool *rpool;
>> +     s64 new;
>> +     int ret = 0;
>> +
>> +retry:
>> +     spin_lock(&cg->rpool_list_lock);
>> +     rpool = find_cg_rpool_locked(cg, device);
>> +     if (!rpool) {
>> +             spin_unlock(&cg->rpool_list_lock);
>> +             ret = alloc_cg_rpool(cg, device);
>> +             if (ret)
>> +                     goto err;
>> +             else
>> +                     goto retry;
> Instead of retrying after allocation of a new rpool, why not just return the
> newly allocated rpool (or the existing one) from alloc_cg_rpool?

It can be done, but locking semantics just becomes difficult to
review/maintain with that where alloc_cg_rpool will unlock and lock
conditionally later on.
This path will be hit anyway on first allocation typically. Once
application is warm up, it will be unlikely to enter here.
I should change if(!rpool) to if (unlikely(!rpool)).


>
>> +     }
>> +     new = num + rpool->resources[index].usage;
>> +     if (new > rpool->resources[index].max) {
>> +             ret = -EAGAIN;
>> +     } else {
>> +             rpool->refcnt++;
>> +             rpool->resources[index].usage = new;
>> +     }
>> +     spin_unlock(&cg->rpool_list_lock);
>> +err:
>> +     return ret;
>> +}
>
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
> This limits the number of resources to 64. Sounds fine to me, but I think
> there should be a check somewhere (maybe in rdmacg_register_device()?) to
> make sure someone doesn't pass too many resources.
Right. Such check is in place in rdmacg_register_device which return
EINVAL when more than 64 resources are requested.

>> +     spin_lock(&cg->rpool_list_lock);
>> +     rpool = find_cg_rpool_locked(cg, device);
>> +     if (!rpool) {
>> +             spin_unlock(&cg->rpool_list_lock);
>> +             ret = alloc_cg_rpool(cg, device);
>> +             if (ret)
>> +                     goto opt_err;
>> +             else
>> +                     goto retry;
> You can avoid the retry here too. Perhaps this can go into a function.
>
In v5 I had wrapper around code which used to similar hiding using
get_cg_rpool and put_cg_rpool helper functions.
But Tejun was of opinion that I should have locks outside of all those
functions. With that approach, this is done.
So I think its ok. to have it this way.

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
>> +     if (rpool->refcnt == 0 &&
>> +         rpool->num_max_cnt == pool_info->table_len) {
>> +             /*
>> +              * No user of the rpool and all entries are
>> +              * set to max, so safe to delete this rpool.
>> +              */
>> +             list_del(&rpool->cg_list);
>> +             spin_unlock(&cg->rpool_list_lock);
>> +             free_cg_rpool(rpool);
>> +     } else {
>> +             spin_unlock(&cg->rpool_list_lock);
>> +     }
> You should consider putting this piece of code in a function (the
> check of the reference counts and release of the rpool).
>
Yes. I did. Same as above comment. Also this function will have to
unlock. Its usually better to lock/unlock from same function level,
instead of locking at one level and unlocking from inside the
function.
Or
I should have
cg_rpool_cond_free_unlock() for above code (check of the reference
counts and release of the rpool)?

>> +static int print_rpool_values(struct seq_file *sf,
> This can return void.
Done.
