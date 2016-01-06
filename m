From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv1 3/6] rdmacg: implements rdma cgroup
Date: Thu, 7 Jan 2016 05:03:07 +0530
Message-ID: <CAG53R5UjsDa+JK_afrQ5pMpiDPrc+a+yCOOH3X105pTmU_a53A@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<1452020286-9508-4-git-send-email-pandit.parav@gmail.com>
	<20160105220128.GJ5995@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=fM1cM26LN/wpTBAjR/l/8PXA4jv04z6+1esZw+uVlJc=;
        b=GorwLsZoFtY2nuJO905BFVZyBaDX6H2ErboJplns8Afr39BnZFlUIsDVRwFsL4ALmE
         OPJlcvoxrjAt7Oz7FYakddQ6gZ8TTLXMEAj9+xdXmNFz9yXJB7vNPCe97tctfva3U3A0
         WQch64BcbLW8eCVWdVIMahtGc+07JWW98Qf2ASnzA4MvDZ9+9KYbsPi1BWLYBeDvVMNj
         U3iibHtCNgs2olgPQVO4YWx9MVGQBlvWHHANV20kJ0IStHzYaxZImbbnqKzWHcQsY4cL
         bwU/JsLhRQRlApKLuZq33gwE8NPgDrKmdgd/KAJ/R9fDetHXmBx2GJKCrZ/P4DPLbr+6
         6zZA==
In-Reply-To: <20160105220128.GJ5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 6, 2016 at 3:31 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Jan 06, 2016 at 12:28:03AM +0530, Parav Pandit wrote:
>> +/* hash table to keep map of tgid to owner cgroup */
>> +DEFINE_HASHTABLE(pid_cg_map_tbl, 7);
>> +DEFINE_SPINLOCK(pid_cg_map_lock);    /* lock to protect hash table access */
>> +
>> +/* Keeps mapping of pid to its owning cgroup at rdma level,
>> + * This mapping doesn't change, even if process migrates from one to other
>> + * rdma cgroup.
>> + */
>> +struct pid_cg_map {
>> +     struct pid *pid;                /* hash key */
>> +     struct rdma_cgroup *cg;
>> +
>> +     struct hlist_node hlist;        /* pid to cgroup hash table link */
>> +     atomic_t refcnt;                /* count active user tasks to figure out
>> +                                      * when to free the memory
>> +                                      */
>> +};
>
> Ugh, there's something clearly wrong here.  Why does the rdma
> controller need to keep track of pid cgroup membership?
>
Rdma resource can be allocated by parent process, used and freed by
child process.
Child process could belong to different rdma cgroup.
Parent process might have been terminated after creation of rdma
cgroup. (Followed by cgroup might have been deleted too).
Its discussed in https://lkml.org/lkml/2015/11/2/307

In nutshell, there is process that clearly owns the rdma resource.
So to keep the design simple, rdma resource is owned by the creator
process and cgroup without modifying the task_struct.

>> +static void _dealloc_cg_rpool(struct rdma_cgroup *cg,
>> +                           struct cg_resource_pool *rpool)
>> +{
>> +     spin_lock(&cg->cg_list_lock);
>> +
>> +     /* if its started getting used by other task,
>> +      * before we take the spin lock, then skip,
>> +      * freeing it.
>> +      */
>
> Please follow CodingStyle.
>
>> +     if (atomic_read(&rpool->refcnt) == 0) {
>> +             list_del_init(&rpool->cg_list);
>> +             spin_unlock(&cg->cg_list_lock);
>> +
>> +             _free_cg_rpool(rpool);
>> +             return;
>> +     }
>> +     spin_unlock(&cg->cg_list_lock);
>> +}
>> +
>> +static void dealloc_cg_rpool(struct rdma_cgroup *cg,
>> +                          struct cg_resource_pool *rpool)
>> +{
>> +     /* Don't free the resource pool which is created by the
>> +      * user, otherwise we miss the configured limits. We don't
>> +      * gain much either by splitting storage of limit and usage.
>> +      * So keep it around until user deletes the limits.
>> +      */
>> +     if (atomic_read(&rpool->creator) == RDMACG_RPOOL_CREATOR_DEFAULT)
>> +             _dealloc_cg_rpool(cg, rpool);
>
> I'm pretty sure you can get away with an fixed length array of
> counters.  Please keep it simple.  It's a simple hard limit enforcer.
> There's no need to create a massive dynamic infrastrucure.
>
Every resource pool for verbs resource is fixed length array. Length
of the array is defined by the IB stack modules.
This array is per cgroup, per device.
Its per device, because we agreed that we want to address requirement
of controlling/configuring them on per device basis.
Devices appear and disappear. Therefore they are allocated dynamically.
Otherwise this array could be static in cgroup structure.



> Thanks.
>
> --
> tejun
