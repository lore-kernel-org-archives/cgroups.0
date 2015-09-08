From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 5/7] devcg: device cgroup's extension for RDMA resource.
Date: Tue, 8 Sep 2015 19:43:04 +0530
Message-ID: <CAG53R5WXcy3-eCeki-ywhLg3thfqdQ_+dpgp+0K14u0bXwEk5A@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<1441658303-18081-6-git-send-email-pandit.parav@gmail.com>
	<55EE9AE0.5030508@mellanox.com>
	<CAG53R5V9ydty2--amXFFDiDd01gGYE0Oh5jV0OhysQmfhWHDPQ@mail.gmail.com>
	<55EEE793.9020105@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=1E+T340d3cfUrRcTUPh4cdN0o11EVC193nLco0Ix+iY=;
        b=A6EEQGRZBLfZgndSDPD7H6yn3Q23+1gl7ioOSjVbB0Zeyqqhvzmvf8V5nBt0xAX83C
         hKW1bVVSYEmlG5k5TfWSHRdi+j99ExEXknacXQB6pKWto3tc2d4sSgMUvoKwmH6lxv4A
         pNTu4Wk0fyxrt5vfOqUFtUr5Jr6vNrzhxIqdsvfnrCo7ORvsJwygpVQCFi/fhKpJ+bmU
         AvHlXQ8RcYmrM/zQv7qqGsB9qXkXFbQ+ZcsrwqbAyTAgvjoikSHNMLm/2YhH0RYHuBDA
         MBF3QrMFo8KB+F53T0UxM3eyXe22uT/j/Y97wpBQlKDFAfzQsShwySl73qBm0GzKEcjK
         9sOA==
In-Reply-To: <55EEE793.9020105@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Tue, Sep 8, 2015 at 7:20 PM, Haggai Eran <haggaie@mellanox.com> wrote:
> On 08/09/2015 13:18, Parav Pandit wrote:
>>> >
>>>> >> + * RDMA resource limits are hierarchical, so the highest configured limit of
>>>> >> + * the hierarchy is enforced. Allowing resource limit configuration to default
>>>> >> + * cgroup allows fair share to kernel space ULPs as well.
>>> > In what way is the highest configured limit of the hierarchy enforced? I
>>> > would expect all the limits along the hierarchy to be enforced.
>>> >
>> In  hierarchy, of say 3 cgroups, the smallest limit of the cgroup is applied.
>>
>> Lets take example to clarify.
>> Say cg_A, cg_B, cg_C
>> Role              name                           limit
>> Parent           cg_A                           100
>> Child_level1  cg_B (child of cg_A)    20
>> Child_level2: cg_C (child of cg_B)    50
>>
>> If the process allocating rdma resource belongs to cg_C, limit lowest
>> limit in the hierarchy is applied during charge() stage.
>> If cg_A limit happens to be 10, since 10 is lowest, its limit would be
>> applicable as you expected.
>
> Looking at the code, the usage in every level is charged. This is what I
> would expect. I just think the comment is a bit misleading.
>
>>>> +int devcgroup_rdma_get_max_resource(struct seq_file *sf, void *v)
>>>> +{
>>>> +     struct dev_cgroup *dev_cg = css_to_devcgroup(seq_css(sf));
>>>> +     int type = seq_cft(sf)->private;
>>>> +     u32 usage;
>>>> +
>>>> +     if (dev_cg->rdma.tracker[type].limit == DEVCG_RDMA_MAX_RESOURCES) {
>>>> +             seq_printf(sf, "%s\n", DEVCG_RDMA_MAX_RESOURCE_STR);
>>> I'm not sure hiding the actual number is good, especially in the
>>> show_usage case.
>>
>> This is similar to following other controller same as newly added PID
>> subsystem in showing max limit.
>
> Okay.
>
>>>> +void devcgroup_rdma_uncharge_resource(struct ib_ucontext *ucontext,
>>>> +                                   enum devcgroup_rdma_rt type, int num)
>>>> +{
>>>> +     struct dev_cgroup *dev_cg, *p;
>>>> +     struct task_struct *ctx_task;
>>>> +
>>>> +     if (!num)
>>>> +             return;
>>>> +
>>>> +     /* get cgroup of ib_ucontext it belong to, to uncharge
>>>> +      * so that when its called from any worker tasks or any
>>>> +      * other tasks to which this resource doesn't belong to,
>>>> +      * it can be uncharged correctly.
>>>> +      */
>>>> +     if (ucontext)
>>>> +             ctx_task = get_pid_task(ucontext->tgid, PIDTYPE_PID);
>>>> +     else
>>>> +             ctx_task = current;
>>>> +     dev_cg = task_devcgroup(ctx_task);
>>>> +
>>>> +     spin_lock(&ctx_task->rdma_res_counter->lock);
>>> Don't you need an rcu read lock and rcu_dereference to access
>>> rdma_res_counter?
>>
>> I believe, its not required because when uncharge() is happening, it
>> can happen only from 3 contexts.
>> (a) from the caller task context, who has made allocation call, so no
>> synchronizing needed.
>> (b) from the dealloc resource context, again this is from the same
>> task context which allocated, it so this is single threaded, no need
>> to syncronize.
> I don't think it is true. You can access uverbs from multiple threads.
Yes, thats right. Though I design counter structure allocation on per
task basis for individual thread access, I totally missed out ucontext
sharing among threads. I replied in other thread to make counters
during charge, uncharge to atomic to cover that case.
Therefore I need rcu lock and deference as well.

> What may help your case here I think is the fact that only when the last
> ucontext is released you can change the rdma_res_counter field, and
> ucontext release takes the ib_uverbs_file->mutex.
>
> Still, I think it would be best to use rcu_dereference(), if only for
> documentation and sparse.

yes.

>
>> (c) from the fput() context when process is terminated abruptly or as
>> part of differed cleanup, when this is happening there cannot be
>> allocator task anyway.
>
