From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Sun, 31 Jan 2016 05:02:37 -0500
Message-ID: <20160131100237.GS32380@htj.duckdns.org>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
 <1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
 <20160130183015.GP32380@htj.duckdns.org>
 <CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lVX9s79ss9Fr6uxMslcb/UYNX4EyMNb9oc3xWTSNBQE=;
        b=CV3wNrvIo1vTUsYbEYiisePQZsEz7k4IbdfbRYc1+DYtaeYt+a3x8cc6fk2CsaSEFn
         pASp/rNYKIeZSaZhklprSJ141xd0/MXoxCVUx8BjQZw68pdnKo/bODAG6MsXY5pWAtzI
         iQu7omhPUnYBr3YMqZ05nzQqmk0fWJoipyrnJBcF8sX387p9GF7HhJYLyKTNpgsXj5cZ
         RAuUAGWf2A0P5sekpk1Se9JvimCwwG8R44gcS1qK/2pRc6J8cHsrfdx0ppjQDJdquLMq
         DldxNfTYzD3YRLm0rrOder0wqxnKedMHrwab0iUgKj6Zgk5v6Wdb9W6HWOlSiOXK+Weo
         Y0KQ==
Content-Disposition: inline
In-Reply-To: <CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Parav.

On Sun, Jan 31, 2016 at 02:14:13AM +0530, Parav Pandit wrote:
...
> V1 patch had IB resources defined in the header file of rdmacg, which
> I believe is very restrictive model with evolving rdma stack and
> features.

Wasn't this the model that we agreed upon?  Besides, even if the
resources are to be supplied by the driver, a better way would be
letting it specify the tables of resources.  There's no reason for
indirection through a callback.

> Therefore it will be kept as defined in v3 patch in IB headers (non
> compile time for rdma cgroup). So support infrastructure APIs will
> continue.

So, what we discussed before just went out the window?

> > The only thing necessary is each device
> > declaring which resources are to be used.
> >
> Thats what rpool_ops structure does, allowing to query name strings
> and type of it by utilizing the match tokens.

Keep the resource types in an array in minimal way and match with the
information from core side.  It doesn't make any sense to use match
tokens in defining resources when the resource type is always fixed.

> > Why is this necessary?
> >
> User can unset the configured limit by writing "remove" for a given
> device, instead of writing max values for all the resources.
> As I explained in cover note and other comment, when its marked for
> remove, the resource pool is marked as of default type so that it can
> be freed. When all resources are freed, we don't free the rpool
> because it holds the configured limit.

I still don't get it.  Why isn't this tied to the lifetime of the
device?

> >> +enum rpool_creator {
> >> +     RDMACG_RPOOL_CREATOR_DEFAULT,
> >> +     RDMACG_RPOOL_CREATOR_USR,
> >> +};
> >
> > Why does this matter?
> As you got in later comment and as I explained above, basically
> resource marked as of user type is not freed, until either device goes
> away or either user wants to clear the configuration.

You're re-stating the same thing without explaining the reasoning
behind it.  Why is this different from other controllers?  What's the
justification?

> >> +static void dealloc_cg_rpool(struct rdma_cgroup *cg,
> >> +                          struct cg_resource_pool *rpool)
> >> +{
> >> +     /* Don't free the resource pool which is created by the
> >> +      * user, otherwise we lose the configured limits. We don't
> >> +      * gain much either by splitting storage of limit and usage.
> >> +      * So keep it around until user deletes the limits.
> >> +      */
> >> +     if (atomic_read(&rpool->creator) == RDMACG_RPOOL_CREATOR_DEFAULT)
> >> +             _dealloc_cg_rpool(cg, rpool);
> >> +}
> >
> > The config is tied to the device.  If the device goes away, all its
> > pools go away.  If the device stays, all configs stay.
> >
> config stays, until the resources are allocated. If device is there,
> we don't create resource pool for all the created cgroups to save
> memory with this little extra code.

Yeah, create on demand all you want but why is the end of lifetime
tied to who created?

> >> +static struct cg_resource_pool*
> >> +     _get_cg_rpool(struct rdma_cgroup *cg,
> >> +                   struct rdmacg_device *device,
> >> +                   enum rdmacg_resource_pool_type type)
> >> +{
> >> +     struct cg_resource_pool *rpool;
> >> +
> >> +     spin_lock(&cg->cg_list_lock);
> >> +     rpool = find_cg_rpool(cg, device, type);
> >> +     if (rpool)
> >> +             goto found;
> >> +found:
> >
> > That's one extremely silly way to write noop.
> >
> >> +     spin_unlock(&cg->cg_list_lock);
> >> +     return rpool;
> >> +}
> >
> > This function doesn't make any sense.  Push locking to the caller and
> > use find_cg_rpool().
> 
> This is nice wrapper around find_cg_rpool to write clean code. I would
> like to keep it for code readability.
> if(rpool) check can be removed, because for this function its going to
> be true always.

No, the locking scheme doesn't make any sense.  Except for some
special cases, sequence like the following indicates that the code is
buggy or at least silly.

	lock;
	obj = find_refcnted_obj();
	unlock;
	return obj;

In this particular case, just push out locking to the users.

> >> +static struct cg_resource_pool*
> >> +     get_cg_rpool(struct rdma_cgroup *cg,
> >> +                  struct rdmacg_device *device,
> >> +                  enum rdmacg_resource_pool_type type)
> >> +{
> >> +     struct cg_resource_pool *rpool, *other_rpool;
> >> +     struct rdmacg_pool_info *pool_info;
> >> +     struct rdmacg_resource_pool_ops *ops;
> >> +     int ret = 0;
> >> +
> >> +     spin_lock(&cg->cg_list_lock);
> >> +     rpool = find_cg_rpool(cg, device, type);
> >> +     if (rpool) {
> >> +             atomic_inc(&rpool->refcnt);
> >> +             spin_unlock(&cg->cg_list_lock);
> >> +             return rpool;
> >> +     }
> >
> > Why does it need refcnting?  Things stay if the device is there.
> > Things go away if the device goes away.  No?
> 
> No. If there is one device and 100 cgroups, we create resource pools
> when there is actually any of the process wants to perform charging.
> (Instead of creating 100 resource pools just because cgroup exists).
> So reference count of the rpool checks that when last resource is
> freed, it frees the resource pool, if its allocated as default pool.
> If user has configured the pool, than it stays (until device goes away).

Just create on demand and keep it around till the device is
unregistered.

> What you have described is done in little different way in the
> loadable kernel module as explained earlier to let it defined by the
> IB stack.
> Otherwise this needs to be defined in rdma cgroup header file like my
> v0 patch, which I certainly want to avoid.

IIRC, I clearly objected to delegating resource definition to
individual drivers.

As it currently stands,

 Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
