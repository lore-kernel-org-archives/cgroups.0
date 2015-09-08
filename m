From: Haggai Eran <haggaie@mellanox.com>
Subject: Re: [PATCH 5/7] devcg: device cgroup's extension for RDMA resource.
Date: Tue, 8 Sep 2015 17:10:50 +0300
Message-ID: <55EEEC6A.4030702@mellanox.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
 <1441658303-18081-6-git-send-email-pandit.parav@gmail.com>
 <55EE9DF5.7030401@mellanox.com>
 <CAG53R5VkCQGE9Ufb2JJO0Ksic_nNMJzVRF4wTrATUrnh1C0taA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAG53R5VkCQGE9Ufb2JJO0Ksic_nNMJzVRF4wTrATUrnh1C0taA@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On 08/09/2015 13:50, Parav Pandit wrote:
> On Tue, Sep 8, 2015 at 2:06 PM, Haggai Eran <haggaie@mellanox.com> wrote:
>> On 07/09/2015 23:38, Parav Pandit wrote:
>>> +void devcgroup_rdma_uncharge_resource(struct ib_ucontext *ucontext,
>>> +                                   enum devcgroup_rdma_rt type, int num)
>>> +{
>>> +     struct dev_cgroup *dev_cg, *p;
>>> +     struct task_struct *ctx_task;
>>> +
>>> +     if (!num)
>>> +             return;
>>> +
>>> +     /* get cgroup of ib_ucontext it belong to, to uncharge
>>> +      * so that when its called from any worker tasks or any
>>> +      * other tasks to which this resource doesn't belong to,
>>> +      * it can be uncharged correctly.
>>> +      */
>>> +     if (ucontext)
>>> +             ctx_task = get_pid_task(ucontext->tgid, PIDTYPE_PID);
>>> +     else
>>> +             ctx_task = current;
>> So what happens if a process creates a ucontext, forks, and then the
>> child creates and destroys a CQ? If I understand correctly, created
>> resources are always charged to the current process (the child), but
>> when it is destroyed the owner of the ucontext (the parent) will be
>> uncharged.
>>
>> Since ucontexts are not meant to be used by multiple processes, I think
>> it would be okay to always charge the owner process (the one that
>> created the ucontext).
> 
> I need to think about it. I would like to avoid keep per task resource
> counters for two reasons.
> For a while I thought that native fork() doesn't take care to share
> the RDMA resources and all CQ, QP dmaable memory from PID namespace
> perspective.
> 
> 1. Because, it could well happen that process and its child process is
> created in PID namespace_A, after which child is migrated to new PID
> namespace_B.
> after which parent from the namespace_A is terminated. I am not sure
> how the ucontext ownership changes from parent to child process at
> that point today.
> I prefer to keep this complexity out if at all it exists as process
> migration across namespaces is not a frequent event for which to
> optimize the code for.
> 
> 2. by having per task counter (as cost of memory some memory) allows
> to avoid using atomic during charge(), uncharge().
> 
> The intent is to have per task (process and thread) to have their
> resource counter instance, but I can see that its broken where its
> charging parent process as of now without atomics.
> As you said its ok to always charge the owner process, I have to relax
> 2nd requirement and fallback to use atomics for charge(), uncharge()
> or I have to get rid of ucontext from the uncharge() API which is
> difficult due to fput() being in worker thread context.
> 

I think the cost of atomic operations here would normally be negligible
compared to the cost of accessing the hardware to allocate or deallocate
these resources.
