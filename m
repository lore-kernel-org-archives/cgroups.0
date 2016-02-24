From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv6 2/3] IB/core: added support to use rdma cgroup controller
Date: Wed, 24 Feb 2016 21:35:00 +0530
Message-ID: <CAG53R5WmLucikiKbFbwJipY936Z07UvvDtWST88S4g10HyJ2Ng@mail.gmail.com>
References: <1455966006-13774-1-git-send-email-pandit.parav@gmail.com>
	<1455966006-13774-3-git-send-email-pandit.parav@gmail.com>
	<56CDB374.602@mellanox.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=QOKw1fKFEvhZk67DKVn/dLBKwfDT6CzLLtADy4H4CjA=;
        b=rZkzcAshFGLf4ULCfXLRQZe0rtya+YnJqge3VjUvgFSut2J3qmiutI98iGsuNSd5Pk
         UZox+MNZ+4mDVXY/KcqxGvLj5v7qRWTMdBwWQ/ZNvSTh/fz95GdbYuEMO59ALrfK6CDy
         YUDYUqKoRAVe0d/UZTzgEhCjF48Jum79P3ci61Uvx2YNgoAmhnjMNDrITjUg52RaAqyt
         1cGv2yfa5J2GRmcH9TbKMiGO6zeCNpLttrVDF2AbI209EgAtt4Wdr4sTlm5czXZ0zLTF
         qLbWeQ92wKSjX+3gOeGB3A6uSppTUtN5g/af4HPiA2kQNC/WdO+9rIKCzeR8nuywc/0p
         Qh1w==
In-Reply-To: <56CDB374.602@mellanox.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haggai Eran <haggaie@mellanox.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

On Wed, Feb 24, 2016 at 7:13 PM, Haggai Eran <haggaie@mellanox.com> wrote:

>> + * all the resources are deallocated, and after a stage when any
>> + * other resource allocation of user application cannot be done
>> + * for this device to avoid any leak in accounting.
>> + * HCA drivers should clear resource pool ops after ib stack
>> + * unregisters with rdma cgroup.
> HCA drivers don't supply their own ops in this version, right?
> If so, you can update the comment.
Yes. I will update.

>> +
> I'm not sure I understand why you need to keep the PD here. Why
> don't you use the same ib_device that is used to create the QP?
> The same applies comment also applies to other uverbs commands.

My bad. Left out of previous implementation. I have changed it now.

>
>>       if (cmd->qp_type == IB_QPT_XRC_TGT) {
>>               xrcd = idr_read_xrcd(cmd->pd_handle, file->ucontext,
>>                                    &xrcd_uobj);
>> @@ -1811,8 +1891,7 @@ static int create_qp(struct ib_uverbs_file *file,
>>
>>               scq = idr_read_cq(cmd->send_cq_handle, file->ucontext, !!rcq);
>>               rcq = rcq ?: scq;
>> -             pd  = idr_read_pd(cmd->pd_handle, file->ucontext);
>> -             if (!pd || !scq) {
>> +             if (!scq) {
>>                       ret = -EINVAL;
>>                       goto err_put;
>>               }
>> @@ -1858,6 +1937,11 @@ static int create_qp(struct ib_uverbs_file *file,
>>                       goto err_put;
>>               }
>>
>> +     ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, pd->device,
>> +                                RDMA_VERB_RESOURCE_QP, 1);
>> +     if (ret)
>> +             goto err_put;
>> +
>>       if (cmd->qp_type == IB_QPT_XRC_TGT)
>>               qp = ib_create_qp(pd, &attr);
>>       else
>> @@ -1865,7 +1949,7 @@ static int create_qp(struct ib_uverbs_file *file,
>>
>>       if (IS_ERR(qp)) {
>>               ret = PTR_ERR(qp);
>> -             goto err_put;
>> +             goto err_create;
>>       }
>>
>>       if (cmd->qp_type != IB_QPT_XRC_TGT) {
>> @@ -1940,6 +2024,10 @@ err_cb:
>>  err_destroy:
>>       ib_destroy_qp(qp);
>>
>> +err_create:
>> +     ib_rdmacg_uncharge(&obj->uevent.uobject.cg_obj, device,
>> +                        RDMA_VERB_RESOURCE_QP, 1);
>> +
>>  err_put:
>>       if (xrcd)
>>               put_xrcd_read(xrcd_uobj);
>
>> @@ -3323,6 +3441,11 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
>>       obj->uevent.events_reported = 0;
>>       INIT_LIST_HEAD(&obj->uevent.event_list);
>>
>> +     ret = ib_rdmacg_try_charge(&obj->uevent.uobject.cg_obj, pd->device,
>> +                                RDMA_VERB_RESOURCE_SRQ, 1);
>> +     if (ret)
>> +             goto err_put_cq;
>> +
> I think you need a new error label to release the PD IDR but not
> uncharge.

Yes. Changed.
