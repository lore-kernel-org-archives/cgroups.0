From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
Date: Mon, 11 Jul 2022 20:45:13 -0700
Message-ID: <2a26b45d-6fab-b2a2-786e-5cb4572219ea@fb.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com>
 <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
 <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com>
 <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qYVOeYX7y1B94pJa32fraJcqXZkWibnP56b6KL6Z3fA=;
 b=QmAafKDP6JPR7e2YJv7+u5AG0Ym/iigND39xXvVUXgD4f8UL8akjZKdSKUVf+hM3hXs0
 HTl89lVYw0N7x0Tt7zGEMJ8miOqb3gujUPQb/RRPP3JxS96yLD1Rvi2rZ7EFucSZYdVF
 V1aT8Tpei1NDeJStlf8Ayr8Ej4+okVSdTLo= 
Content-Language: en-US
In-Reply-To: <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hao Luo <haoluo@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>



On 7/11/22 5:42 PM, Hao Luo wrote:
> On Mon, Jul 11, 2022 at 4:20 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> On 7/10/22 5:19 PM, Yonghong Song wrote:
>>>
>>>
> [...]
>>>> +
>>>>    union bpf_iter_link_info {
>>>>        struct {
>>>>            __u32    map_fd;
>>>>        } map;
>>>> +
>>>> +    /* cgroup_iter walks either the live descendants of a cgroup
>>>> subtree, or the ancestors
>>>> +     * of a given cgroup.
>>>> +     */
>>>> +    struct {
>>>> +        /* Cgroup file descriptor. This is root of the subtree if for
>>>> walking the
>>>> +         * descendants; this is the starting cgroup if for walking
>>>> the ancestors.
>>>
>>> Adding comment that cgroup_fd 0 means starting from root cgroup?
> 
> Sure.
> 
>>> Also, if I understand correctly, cgroup v1 is also supported here,
>>> right? If this is the case, for cgroup v1 which root cgroup will be
>>> used for cgroup_fd? It would be good to clarify here too.
>>>
> 
> IMO, the case of cgroup_fd = 0 combined with cgroup v1 should return
> errors. It's an invalid case. If anyone wants to use cgroup_iter on
> cgroup v1 hierarchy, they could explicitly open the subsystems' root
> directory and pass the fd. With that said, Yosry and I will test and
> confirm the behavior in this situation and clarify in the comment.
> Thanks for pointing this out.

sounds good.

> 
>>>> +         */
>>>> +        __u32    cgroup_fd;
>>>> +        __u32    traversal_order;
>>>> +    } cgroup;
>>>>    };
>>>>    /* BPF syscall commands, see bpf(2) man-page for more details. */
>>>> @@ -6134,6 +6151,10 @@ struct bpf_link_info {
>>>>                    struct {
>>>>                        __u32 map_id;
>>>>                    } map;
>>>> +                struct {
>>>> +                    __u32 traversal_order;
>>>> +                    __aligned_u64 cgroup_id;
>>>> +                } cgroup;
>>>
>>> We actually has a problem here although I don't have a solution yet.
>>>
> [...]
>>>
>>> There is a 4 byte hole after member 'target_name_len'. So map_id will
>>> have a offset 16 from the start of structure 'iter'.
>>>
>>>
>>> This will break uapi. We probably won't be able to change the existing
>>> uapi with adding a ':32' after member 'target_name_len'. I don't have
>>> a good solution yet, but any suggestion is welcome.
>>>
>>> Also, for '__aligned_u64 cgroup_id', '__u64 cgroup_id' is enough.
>>> '__aligned_u64' mostly used for pointers.
>>
>> Briefly discussed with Alexei, the following structure iter definition
>> should work. Later on, if we need to addition fields for other iter's,
>> for a single __u32, the field can be added to either the first or the
>> second union. If fields are more than __u32, they can be placed
>> in the second union.
>>
>>                   struct {
>>                           __aligned_u64 target_name; /* in/out:
>> target_name buffer ptr */
>>                           __u32 target_name_len;     /* in/out:
>> target_name buffer len */
>>                           union {
>>                                   struct {
>>                                           __u32 map_id;
>>                                   } map;
>>                           };
>>                           union {
>>                                   struct {
>>                                           __u64 cgroup_id;
>>                                           __u32 traversal_order;
>>                                   } cgroup;
>>                           };
>>                   } iter;
>>
> 
> Thanks Yonghong for seeking the solution here. The solution looks
> good. I'm going to put your heads-up as comments there. One thing I'd
> like to confirm, when we query bpf_link_info for cgroup iter, do we
> also need to zero those fields for map_elem?

I think we don't need to do that. User space expected to check
target_name/target_name_len/cgroup only. For cgroup_iter, the
'map' value should be ignored.

> 
>>
>>>
>>>
>>>>                };
>>>>            } iter;
>>>>            struct  {
> [...]
>>>> +
>>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
>>>> +{
>>>> +    struct cgroup_iter_priv *p = seq->private;
>>>> +
>>>> +    mutex_lock(&cgroup_mutex);
>>>> +
>>>> +    /* support only one session */
>>>> +    if (*pos > 0)
>>>> +        return NULL;
>>>
>>> This might be okay. But want to check what is
>>> the practical upper limit for cgroups in a system
>>> and whether we may miss some cgroups. If this
>>> happens, it will be a surprise to the user.
>>>
> 
> Ok. What's the max number of items supported in a single session?

The max number of items (cgroups) in a single session is determined
by kernel_buffer_size which equals to 8 * PAGE_SIZE. So it really
depends on how much data bpf program intends to send to user space.
If each bpf program run intends to send 64B to user space, e.g., for
cpu, memory, cpu pressure, mem pressure, io pressure, read rate, write 
rate, read/write rate. Then each session can support 512 cgroups.

> 
>>>> +
>>>> +    ++*pos;
>>>> +    p->terminate = false;
>>>> +    if (p->order == BPF_ITER_CGROUP_PRE)
>>>> +        return css_next_descendant_pre(NULL, p->start_css);
>>>> +    else if (p->order == BPF_ITER_CGROUP_POST)
>>>> +        return css_next_descendant_post(NULL, p->start_css);
>>>> +    else /* BPF_ITER_CGROUP_PARENT_UP */
>>>> +        return p->start_css;
>>>> +}
>>>> +
>>>> +static int __cgroup_iter_seq_show(struct seq_file *seq,
>>>> +                  struct cgroup_subsys_state *css, int in_stop);
>>>> +
>>>> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
>>>> +{
>>>> +    /* pass NULL to the prog for post-processing */
>>>> +    if (!v)
>>>> +        __cgroup_iter_seq_show(seq, NULL, true);
>>>> +    mutex_unlock(&cgroup_mutex);
>>>> +}
>>>> +
>>> [...]
