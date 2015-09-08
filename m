From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/7] devcg: device cgroup's extension for RDMA resource.
Date: Tue, 8 Sep 2015 16:20:17 +0530
Message-ID: <CAG53R5VkCQGE9Ufb2JJO0Ksic_nNMJzVRF4wTrATUrnh1C0taA@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<1441658303-18081-6-git-send-email-pandit.parav@gmail.com>
	<55EE9DF5.7030401@mellanox.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=x4k6qbRslzK3CXVenca7st9+HFf1bq5pIQuLB9e2Ny0=;
        b=r/fVhO0POmE+cAjiz7Rwnb/6ApKhu0OVV3aOuEfY4peL2f111wgFDx/gCJh90nP/85
         Yy0DxudsRc7+GvHZwuTBrF/0ixTTQz3XGn8EDJFI97eLwXdwdNX/S+U42hwfCz0DmSfC
         fL4S+KhU8QJa1BFaxXhvnjagdyz5PilJJeToWc+AAWfrZTLbnUYl6DIESnBDy25gadc5
         nkFbKvHx7UsE/BQhYPjsWG5vHyZuXCN2COpmCCcQ9QXdzRO+WDCNvpkvDms4c/XDbosJ
         u4ZKhxqYHW0dZosUzAgYjM3OUoi1pJRziO8yxyrjPDd92B4asxsv5eUIFO1oN33cCn5F
         /skw==
In-Reply-To: <55EE9DF5.7030401-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Sep 8, 2015 at 2:06 PM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 07/09/2015 23:38, Parav Pandit wrote:
>> +void devcgroup_rdma_uncharge_resource(struct ib_ucontext *ucontext,
>> +                                   enum devcgroup_rdma_rt type, int num)
>> +{
>> +     struct dev_cgroup *dev_cg, *p;
>> +     struct task_struct *ctx_task;
>> +
>> +     if (!num)
>> +             return;
>> +
>> +     /* get cgroup of ib_ucontext it belong to, to uncharge
>> +      * so that when its called from any worker tasks or any
>> +      * other tasks to which this resource doesn't belong to,
>> +      * it can be uncharged correctly.
>> +      */
>> +     if (ucontext)
>> +             ctx_task = get_pid_task(ucontext->tgid, PIDTYPE_PID);
>> +     else
>> +             ctx_task = current;
> So what happens if a process creates a ucontext, forks, and then the
> child creates and destroys a CQ? If I understand correctly, created
> resources are always charged to the current process (the child), but
> when it is destroyed the owner of the ucontext (the parent) will be
> uncharged.
>
> Since ucontexts are not meant to be used by multiple processes, I think
> it would be okay to always charge the owner process (the one that
> created the ucontext).

I need to think about it. I would like to avoid keep per task resource
counters for two reasons.
For a while I thought that native fork() doesn't take care to share
the RDMA resources and all CQ, QP dmaable memory from PID namespace
perspective.

1. Because, it could well happen that process and its child process is
created in PID namespace_A, after which child is migrated to new PID
namespace_B.
after which parent from the namespace_A is terminated. I am not sure
how the ucontext ownership changes from parent to child process at
that point today.
I prefer to keep this complexity out if at all it exists as process
migration across namespaces is not a frequent event for which to
optimize the code for.

2. by having per task counter (as cost of memory some memory) allows
to avoid using atomic during charge(), uncharge().

The intent is to have per task (process and thread) to have their
resource counter instance, but I can see that its broken where its
charging parent process as of now without atomics.
As you said its ok to always charge the owner process, I have to relax
2nd requirement and fallback to use atomics for charge(), uncharge()
or I have to get rid of ucontext from the uncharge() API which is
difficult due to fput() being in worker thread context.

>
>> +     dev_cg = task_devcgroup(ctx_task);
>> +
>> +     spin_lock(&ctx_task->rdma_res_counter->lock);
>> +     ctx_task->rdma_res_counter->usage[type] -= num;
>> +
>> +     for (p = dev_cg; p; p = parent_devcgroup(p))
>> +             uncharge_resource(p, type, num);
>> +
>> +     spin_unlock(&ctx_task->rdma_res_counter->lock);
>> +
>> +     if (type == DEVCG_RDMA_RES_TYPE_UCTX)
>> +             rdma_free_res_counter(ctx_task);
>> +}
>> +EXPORT_SYMBOL(devcgroup_rdma_uncharge_resource);
>
