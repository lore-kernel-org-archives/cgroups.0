From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv6 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 25 Feb 2016 14:03:13 +0200
Message-ID: <56CEED81.7010507@mellanox.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
 <1455966006-13774-2-git-send-email-pandit.parav@gmail.com>
 <56CDAC7A.6030206@mellanox.com>
 <CAG53R5Uof+Ve7CndWy=BrgtxxCisQpzP_Ls0kw=Q270DhoEsZw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oUE6OngXryCnEbWXfLkFwurDzNK1ZDlHSztDTJvGhkg=;
 b=iwz3EqIMpKskNGR9DkQbCHu+k9nehs7WwjFP7ln+VflXVUiYBQMUXxcjKFJVzDWqD1JLUVoIJ3w11LEDhDsItcSCPjLguU/LIB17/NMxTOzUPUsWPVqq8dMWvxjfiGmsmOqX1nMtfJ2dzffcZkN1TRDTp28EZy+1moQeWtFlurc=
In-Reply-To: <CAG53R5Uof+Ve7CndWy=BrgtxxCisQpzP_Ls0kw=Q270DhoEsZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 24/02/2016 18:16, Parav Pandit wrote:
>>> +     struct rdmacg_resource_pool *rpool;
>>> +     struct rdmacg_pool_info *pool_info = &device->pool_info;
>>> +
>>> +     spin_lock(&cg->rpool_list_lock);
>>> +     rpool = find_cg_rpool_locked(cg, device);
>> Is it possible for rpool to be NULL?
>>
> Unlikely, unless we have but in cgroup implementation.
> It may be worth to add WARN_ON and return from here to avoid kernel crash.
Sounds good.

>>> +static int charge_cg_resource(struct rdma_cgroup *cg,
>>> +                           struct rdmacg_device *device,
>>> +                           int index, int num)
>>> +{
>>> +     struct rdmacg_resource_pool *rpool;
>>> +     s64 new;
>>> +     int ret = 0;
>>> +
>>> +retry:
>>> +     spin_lock(&cg->rpool_list_lock);
>>> +     rpool = find_cg_rpool_locked(cg, device);
>>> +     if (!rpool) {
>>> +             spin_unlock(&cg->rpool_list_lock);
>>> +             ret = alloc_cg_rpool(cg, device);
>>> +             if (ret)
>>> +                     goto err;
>>> +             else
>>> +                     goto retry;
>> Instead of retrying after allocation of a new rpool, why not just return the
>> newly allocated rpool (or the existing one) from alloc_cg_rpool?
> 
> It can be done, but locking semantics just becomes difficult to
> review/maintain with that where alloc_cg_rpool will unlock and lock
> conditionally later on.
Maybe I'm missing something, but couldn't you simply lock rpool_list_lock
inside alloc_cg_rpool()? It already does that around its call to 
find_cg_rpool_locked() and the insertion to cg_list.

> This path will be hit anyway on first allocation typically. Once
> application is warm up, it will be unlikely to enter here.
> I should change if(!rpool) to if (unlikely(!rpool)).
Theoretically the new allocated rpool can be released again by the time you
get to the second call to find_cg_rpool_locked().

>>> +     spin_lock(&cg->rpool_list_lock);
>>> +     rpool = find_cg_rpool_locked(cg, device);
>>> +     if (!rpool) {
>>> +             spin_unlock(&cg->rpool_list_lock);
>>> +             ret = alloc_cg_rpool(cg, device);
>>> +             if (ret)
>>> +                     goto opt_err;
>>> +             else
>>> +                     goto retry;
>> You can avoid the retry here too. Perhaps this can go into a function.
>>
> In v5 I had wrapper around code which used to similar hiding using
> get_cg_rpool and put_cg_rpool helper functions.
> But Tejun was of opinion that I should have locks outside of all those
> functions. With that approach, this is done.
> So I think its ok. to have it this way.
I thought that was about functions that only locked the lock, called the 
find function, and released the lock. What I'm suggesting is to have one
function that does "lock + find + allocate if needed + unlock", and another
function that does (under caller's lock) "check ref count + check max count +
release rpool".

>>> +     }
>>> +
>>> +     /* now set the new limits of the rpool */
>>> +     while (enables) {
>>> +             /* if user set the limit, enables bit is set */
>>> +             if (enables & BIT(i)) {
>>> +                     enables &= ~BIT(i);
>>> +                     set_resource_limit(rpool, i, new_limits[i]);
>>> +             }
>>> +             i++;
>>> +     }
>>> +     if (rpool->refcnt == 0 &&
>>> +         rpool->num_max_cnt == pool_info->table_len) {
>>> +             /*
>>> +              * No user of the rpool and all entries are
>>> +              * set to max, so safe to delete this rpool.
>>> +              */
>>> +             list_del(&rpool->cg_list);
>>> +             spin_unlock(&cg->rpool_list_lock);
>>> +             free_cg_rpool(rpool);
>>> +     } else {
>>> +             spin_unlock(&cg->rpool_list_lock);
>>> +     }
>> You should consider putting this piece of code in a function (the
>> check of the reference counts and release of the rpool).
>>
> Yes. I did. Same as above comment. Also this function will have to
> unlock. Its usually better to lock/unlock from same function level,
> instead of locking at one level and unlocking from inside the
> function.
> Or
> I should have
> cg_rpool_cond_free_unlock() for above code (check of the reference
> counts and release of the rpool)?
It is confusing to lock and unlock in different contexts. Why not lock
in the caller context? free_cg_rpool() can be called under rpool_list_lock,
couldn't it? It locks device->rpool_lock, but uncharge_cg_resource() also
locks both in the same order.

Thanks,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
