From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Date: Thu, 28 Jul 2022 11:08:16 -0700
Message-ID: <1c4bac1c-ba65-5033-6271-6f79e3ca0cb0@fb.com>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com>
 <c7ebc0c6-b301-de70-b5ae-1f62d360acb6@fb.com>
 <CA+khW7hvLgCKVA0kiKhREW-PZ4aOYvkGHoEqKAggEdyY9TRp7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VrEk5g4ZbmjxSSZPD8gGWHrSc/agOfw98W2dKSrOGvM=;
 b=NY8HR885Tbx6VCI2QHJI0UUrSDt3WDrQlSSiF0foUYalVwT2JEBD4pbs2knFwn3RcQnZ
 tk3FhW7jWGFQyi84gj2lzCpxjWjjoxUHZC/V1sR7jBrgzMBsy7389QCatpvXc5/f5s7S
 34zn/QJZkMHz76taOB1DnRgaeIZxG7EQJSs= 
Content-Language: en-US
In-Reply-To: <CA+khW7hvLgCKVA0kiKhREW-PZ4aOYvkGHoEqKAggEdyY9TRp7Q@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hao Luo <haoluo@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>



On 7/28/22 10:25 AM, Hao Luo wrote:
> On Wed, Jul 27, 2022 at 10:49 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 7/22/22 10:48 AM, Yosry Ahmed wrote:
>>> From: Hao Luo <haoluo@google.com>
>>>
>>> Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
>>>
>>>    - walking a cgroup's descendants in pre-order.
>>>    - walking a cgroup's descendants in post-order.
>>>    - walking a cgroup's ancestors.
>>>
>>> When attaching cgroup_iter, one can set a cgroup to the iter_link
>>> created from attaching. This cgroup is passed as a file descriptor and
>>> serves as the starting point of the walk. If no cgroup is specified,
>>> the starting point will be the root cgroup.
>>>
>>> For walking descendants, one can specify the order: either pre-order or
>>> post-order. For walking ancestors, the walk starts at the specified
>>> cgroup and ends at the root.
>>>
>>> One can also terminate the walk early by returning 1 from the iter
>>> program.
>>>
>>> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
>>> program is called with cgroup_mutex held.
>>>
>>> Currently only one session is supported, which means, depending on the
>>> volume of data bpf program intends to send to user space, the number
>>> of cgroups that can be walked is limited. For example, given the current
>>> buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
>>> cgroup, the total number of cgroups that can be walked is 512. This is
>>
>> PAGE_SIZE needs to be 4KB in order to conclude that the total number of
>> walked cgroups is 512.
>>
> 
> Sure. Will change that.
> 
>>> a limitation of cgroup_iter. If the output data is larger than the
>>> buffer size, the second read() will signal EOPNOTSUPP. In order to work
>>> around, the user may have to update their program to reduce the volume
>>> of data sent to output. For example, skip some uninteresting cgroups.
>>> In future, we may extend bpf_iter flags to allow customizing buffer
>>> size.
>>>
>>> Signed-off-by: Hao Luo <haoluo@google.com>
>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>> Acked-by: Yonghong Song <yhs@fb.com>
>>> ---
>>>    include/linux/bpf.h                           |   8 +
>>>    include/uapi/linux/bpf.h                      |  30 +++
>>>    kernel/bpf/Makefile                           |   3 +
>>>    kernel/bpf/cgroup_iter.c                      | 252 ++++++++++++++++++
>>>    tools/include/uapi/linux/bpf.h                |  30 +++
>>>    .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>>>    6 files changed, 325 insertions(+), 2 deletions(-)
>>>    create mode 100644 kernel/bpf/cgroup_iter.c
>>
>> This patch cannot apply to bpf-next cleanly, so please rebase
>> and post again.
>>
> 
> Sorry about that. Will do.
> 
>>>
>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>> index a97751d845c9..9061618fe929 100644
>>> --- a/include/linux/bpf.h
>>> +++ b/include/linux/bpf.h
>>> @@ -47,6 +47,7 @@ struct kobject;
>>>    struct mem_cgroup;
>>>    struct module;
>>>    struct bpf_func_state;
>>> +struct cgroup;
>>>
>>>    extern struct idr btf_idr;
>>>    extern spinlock_t btf_idr_lock;
>>> @@ -1717,7 +1718,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>>>        int __init bpf_iter_ ## target(args) { return 0; }
>>>
>>>    struct bpf_iter_aux_info {
>>> +     /* for map_elem iter */
>>>        struct bpf_map *map;
>>> +
>>> +     /* for cgroup iter */
>>> +     struct {
>>> +             struct cgroup *start; /* starting cgroup */
>>> +             int order;
>>> +     } cgroup;
>>>    };
>>>
>>>    typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index ffcbf79a556b..fe50c2489350 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
>>>        __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
>>>    };
>>>
>>> +enum bpf_iter_cgroup_traversal_order {
>>> +     BPF_ITER_CGROUP_PRE = 0,        /* pre-order traversal */
>>> +     BPF_ITER_CGROUP_POST,           /* post-order traversal */
>>> +     BPF_ITER_CGROUP_PARENT_UP,      /* traversal of ancestors up to the root */
>>> +};
>>> +
>>>    union bpf_iter_link_info {
>>>        struct {
>>>                __u32   map_fd;
>>>        } map;
>>> +
>>> +     /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
>>> +      * ancestors of a given cgroup.
>>> +      */
>>> +     struct {
>>> +             /* Cgroup file descriptor. This is root of the subtree if walking
>>> +              * descendants; it's the starting cgroup if walking the ancestors.
>>> +              * If it is left 0, the traversal starts from the default cgroup v2
>>> +              * root. For walking v1 hierarchy, one should always explicitly
>>> +              * specify the cgroup_fd.
>>> +              */
>>
>> I did see how the above cgroup v1/v2 scenarios are enforced.
>>
> 
> Do you mean _not_ see? Yosry and I experimented a bit. We found even

Ya, I mean 'not see'...

> on systems where v2 is not enabled, cgroup v2 root always exists and
> can be attached to, and can be iterated on (only trivially). We didn't
> find a way to tell v1 and v2 apart and deemed a comment to instruct v1
> users is fine?

So, cgroup_fd = 0, start from cgroup v2 root.
     cgroup_fd != 0, start from that particular cgroup (cgroup_v1 or v2)
Okay, since cgroup v2 root is always available and can be iterated,
I think comments should be okay.

> 
>>> +             __u32   cgroup_fd;
>>> +             __u32   traversal_order;
>>> +     } cgroup;
>>>    };
>>>
>>>    /* BPF syscall commands, see bpf(2) man-page for more details. */
[...]
