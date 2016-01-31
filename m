From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Sun, 31 Jan 2016 16:11:54 +0530
Message-ID: <CAG53R5WOLA_=gD9qVnsVk_oPs0iyacL3M+1qD+RAbrnciVXEOA@mail.gmail.com>
References: <1454167387-31260-1-git-send-email-pandit.parav@gmail.com>
	<1454167387-31260-2-git-send-email-pandit.parav@gmail.com>
	<20160130183015.GP32380@htj.duckdns.org>
	<CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
	<20160131100237.GS32380@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=01EY5FoJnTOPTGiujJeGa0wlFybT/HV6IDVb68BCZuM=;
        b=i7gOedhyBu2GCFXKW0cOd2GxpayLpe9VwAQp84HOcjaJjuyFDLHFIYxRN+UqtoUWgU
         DeAqymB3nj4h+cBZ+nfLtyUU/GfnI0ePb/NLP5SG8Kg39EGqDWyEAU8//kg/GsX1hoPy
         cO+5kMFx6JBRzc5h7CDbEdmbJcWj6K2iqhHOiOQKfehCKnyviGyhmVp3jGDp/S1fT8hU
         QM1kfoOrisuLEyUqikt/pMJVfoWcI3+AHtyet29yvkJilkg7wkRk4E5oqoH1FY64UXbm
         yoGgIl+s3lGF8qeZfSvxoADQxmEP0HwJ95Q4Ll+KXCD8S+6owhZ2EdmdWnYg1PyiCr19
         YcaQ==
In-Reply-To: <20160131100237.GS32380-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Jan 31, 2016 at 3:32 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Sun, Jan 31, 2016 at 02:14:13AM +0530, Parav Pandit wrote:
> ...
>> V1 patch had IB resources defined in the header file of rdmacg, which
>> I believe is very restrictive model with evolving rdma stack and
>> features.
>
> Wasn't this the model that we agreed upon?  Besides, even if the
> resources are to be supplied by the driver, a better way would be
> letting it specify the tables of resources.  There's no reason for
> indirection through a callback.

No. We agreed that let IB stack define in the header file that rdmacg
can include.
However when I started with that I realized that, such design has
basic flaw that IB stack is compiled as loadable modules.
cgroup which is compiled along with kernel, cannot rely on the header
file of the loadable module, as it will lead to incompatibly and
possible crash.
Therefore its defined as indirect table. So instead of a callback, it
can be further simplified to return as pointer to data structure
stored in the rdmacg_device (similar to the name field).
Would that be reasonable?

>
>> Therefore it will be kept as defined in v3 patch in IB headers (non
>> compile time for rdma cgroup). So support infrastructure APIs will
>> continue.
>
> So, what we discussed before just went out the window?

No. As explained above, structure size and num fields are constant, so
lets do above way, without a callback function.

>> > The only thing necessary is each device
>> > declaring which resources are to be used.
>> >
>> Thats what rpool_ops structure does, allowing to query name strings
>> and type of it by utilizing the match tokens.
>
> Keep the resource types in an array in minimal way and match with the
> information from core side.  It doesn't make any sense to use match
> tokens in defining resources when the resource type is always fixed.
>
Match token is being used in other places also typically where user
configuration is involved.
so Match token infrastructure APIs help to avoid rewriting parser.
What exactly is the issue in using match token?
Resource type is fixed - sure it is with given version of loadable
module. But if new feature/resource is added in IB stack, at that
point new token will be added in the array.

>> > Why is this necessary?
>> >
>> User can unset the configured limit by writing "remove" for a given
>> device, instead of writing max values for all the resources.
>> As I explained in cover note and other comment, when its marked for
>> remove, the resource pool is marked as of default type so that it can
>> be freed. When all resources are freed, we don't free the rpool
>> because it holds the configured limit.
>
> I still don't get it.  Why isn't this tied to the lifetime of the
> device?
Let me try to take example.
Say there is one device and 100 cgroups, with single hierarchy.
Out of which 15 are active cgroups allocating rdma resources, rest 85
are not active in terms of rdma resource usage.
So rpool object is created for those 15 cgroups (regardless of user
has configured limits or not).

In this design its not tied to the lifetime of the device. At the
sametime if device goes away, those 15 will be freed anyway because
device doesn't exist.

Now coming to remove command's need.
If user has previously configured limit of say mr=15. Now if wants to
remove that configuration and don't want to bother for the limit.
So the way, its done is by issuing "remove" command.
Should I name is "reset".
When user issues "remove" command it could still happen that there are
active rdma resources. So we cannot really free the rpool object.
That is freed when last resource is uncharged.
Make sense?

>
>> >> +enum rpool_creator {
>> >> +     RDMACG_RPOOL_CREATOR_DEFAULT,
>> >> +     RDMACG_RPOOL_CREATOR_USR,
>> >> +};
>> >
>> > Why does this matter?
>> As you got in later comment and as I explained above, basically
>> resource marked as of user type is not freed, until either device goes
>> away or either user wants to clear the configuration.
>
> You're re-stating the same thing without explaining the reasoning
> behind it.  Why is this different from other controllers?  What's the
> justification?

As in above example of 15-85, if we keep it or create is we will end
up allocating rpool objects for all the 100 cgroups, which might not
be necessary. If it happens to be multi level hierarchy, it will end
up having in each level.
So therefore its allocated and freed dynamically.

>
>> >> +static void dealloc_cg_rpool(struct rdma_cgroup *cg,
>> >> +                          struct cg_resource_pool *rpool)
>> >> +{
>> >> +     /* Don't free the resource pool which is created by the
>> >> +      * user, otherwise we lose the configured limits. We don't
>> >> +      * gain much either by splitting storage of limit and usage.
>> >> +      * So keep it around until user deletes the limits.
>> >> +      */
>> >> +     if (atomic_read(&rpool->creator) == RDMACG_RPOOL_CREATOR_DEFAULT)
>> >> +             _dealloc_cg_rpool(cg, rpool);
>> >> +}
>> >
>> > The config is tied to the device.  If the device goes away, all its
>> > pools go away.  If the device stays, all configs stay.
>> >
>> config stays, until the resources are allocated. If device is there,
>> we don't create resource pool for all the created cgroups to save
>> memory with this little extra code.
>
> Yeah, create on demand all you want but why is the end of lifetime
> tied to who created?
>
If its created by user configuration, and if we free the rpool object
when last resource is freed which is holding the configuration,
user configuration is lost.
Also it doesn't make much sense to have two different allocation for
limit and usage configuration. Pointer storing overhead is more than
the actual content.

>> >> +static struct cg_resource_pool*
>> >> +     _get_cg_rpool(struct rdma_cgroup *cg,
>> >> +                   struct rdmacg_device *device,
>> >> +                   enum rdmacg_resource_pool_type type)
>> >> +{
>> >> +     struct cg_resource_pool *rpool;
>> >> +
>> >> +     spin_lock(&cg->cg_list_lock);
>> >> +     rpool = find_cg_rpool(cg, device, type);
>> >> +     if (rpool)
>> >> +             goto found;
>> >> +found:
>> >
>> > That's one extremely silly way to write noop.
>> >
>> >> +     spin_unlock(&cg->cg_list_lock);
>> >> +     return rpool;
>> >> +}
>> >
>> > This function doesn't make any sense.  Push locking to the caller and
>> > use find_cg_rpool().
>>
>> This is nice wrapper around find_cg_rpool to write clean code. I would
>> like to keep it for code readability.
>> if(rpool) check can be removed, because for this function its going to
>> be true always.
>
> No, the locking scheme doesn't make any sense.  Except for some
> special cases, sequence like the following indicates that the code is
> buggy or at least silly.
>
Help me to understand, silly means - unacceptable?
I am still trying to understand why a wrapper function makes the code buggy.

>         lock;
>         obj = find_refcnted_obj();
>         unlock;
>         return obj;
>
> In this particular case, just push out locking to the users.
>

>> >> +static struct cg_resource_pool*
>> >> +     get_cg_rpool(struct rdma_cgroup *cg,
>> >> +                  struct rdmacg_device *device,
>> >> +                  enum rdmacg_resource_pool_type type)
>> >> +{
>> >> +     struct cg_resource_pool *rpool, *other_rpool;
>> >> +     struct rdmacg_pool_info *pool_info;
>> >> +     struct rdmacg_resource_pool_ops *ops;
>> >> +     int ret = 0;
>> >> +
>> >> +     spin_lock(&cg->cg_list_lock);
>> >> +     rpool = find_cg_rpool(cg, device, type);
>> >> +     if (rpool) {
>> >> +             atomic_inc(&rpool->refcnt);
>> >> +             spin_unlock(&cg->cg_list_lock);
>> >> +             return rpool;
>> >> +     }
>> >
>> > Why does it need refcnting?  Things stay if the device is there.
>> > Things go away if the device goes away.  No?
>>
>> No. If there is one device and 100 cgroups, we create resource pools
>> when there is actually any of the process wants to perform charging.
>> (Instead of creating 100 resource pools just because cgroup exists).
>> So reference count of the rpool checks that when last resource is
>> freed, it frees the resource pool, if its allocated as default pool.
>> If user has configured the pool, than it stays (until device goes away).
>
> Just create on demand and keep it around till the device is
> unregistered.
>
Why you don't want them to be freed when there are no requester
allocating the resource?
Device usually stays for longer time, but applications go way and come
back more often, so freeing them makes more sense when not in use.
What exactly is the problem in freeing when uncharing occurs, due to
which I should defer it to device unregistration stage?

>> What you have described is done in little different way in the
>> loadable kernel module as explained earlier to let it defined by the
>> IB stack.
>> Otherwise this needs to be defined in rdma cgroup header file like my
>> v0 patch, which I certainly want to avoid.
>
> IIRC, I clearly objected to delegating resource definition to
> individual drivers.
>
I understand that. Instead of individual driver, it can be well
abstracted out at IB stack level that drivers will use.
So that it will be in cgroup.c or other file, but with that I don't
anticipate a design change.
I have not received review comments from Sean Hefty or any of the
Intel folks who requested this feature.
So I will keep this feature around for a while. I will ping him as
well to finish his reviews and if there is any resource definitions
that they can spell out.
In absence of those inputs, other possibility is to just define verb
level resource. I am keeping doors open for more review comments from
IB folks on how do they see this.

> As it currently stands,
>
>  Nacked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
No problem. Lets resolve these review comments for v6.

> Thanks.
>
> --
> tejun
