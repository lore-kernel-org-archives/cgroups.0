From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
Date: Mon, 11 Jul 2022 16:20:08 -0700
Message-ID: <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com>
 <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/WhxfDpH50Sb2qh5TYOpSPqv54bg2xPOrEmDshi5FjY=;
 b=SPfZw5k9zQoE6Wc0aeHuzJVOMCE4vTNRF+/u4Dr3cvWBHgHzX6XD2set6pCoIn0C8MgL
 fFuEaJ1w4qXPjP5P8nPnxz7YxIkA33SC2ZjBts56Aqc0TCkzMzal7nO5cLyjhQDOnccw
 m8MCkOSUR35THppnW5Cpf8Xb1OcNoSKZQMM= 
Content-Language: en-US
In-Reply-To: <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org



On 7/10/22 5:19 PM, Yonghong Song wrote:
> 
> 
> On 7/8/22 5:04 PM, Yosry Ahmed wrote:
>> From: Hao Luo <haoluo@google.com>
>>
>> Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
>>
>>   - walking a cgroup's descendants in pre-order.
>>   - walking a cgroup's descendants in post-order.
>>   - walking a cgroup's ancestors.
>>
>> When attaching cgroup_iter, one can set a cgroup to the iter_link
>> created from attaching. This cgroup is passed as a file descriptor and
>> serves as the starting point of the walk. If no cgroup is specified,
>> the starting point will be the root cgroup.
>>
>> For walking descendants, one can specify the order: either pre-order or
>> post-order. For walking ancestors, the walk starts at the specified
>> cgroup and ends at the root.
>>
>> One can also terminate the walk early by returning 1 from the iter
>> program.
>>
>> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
>> program is called with cgroup_mutex held.
>>
>> Signed-off-by: Hao Luo <haoluo@google.com>
>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>> Acked-by: Yonghong Song <yhs@fb.com>
>> ---
>>   include/linux/bpf.h                           |   8 +
>>   include/uapi/linux/bpf.h                      |  21 ++
>>   kernel/bpf/Makefile                           |   3 +
>>   kernel/bpf/cgroup_iter.c                      | 242 ++++++++++++++++++
>>   tools/include/uapi/linux/bpf.h                |  21 ++
>>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>>   6 files changed, 297 insertions(+), 2 deletions(-)
>>   create mode 100644 kernel/bpf/cgroup_iter.c
>>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 2b21f2a3452ff..5de9de06e2551 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -47,6 +47,7 @@ struct kobject;
>>   struct mem_cgroup;
>>   struct module;
>>   struct bpf_func_state;
>> +struct cgroup;
>>   extern struct idr btf_idr;
>>   extern spinlock_t btf_idr_lock;
>> @@ -1714,7 +1715,14 @@ int bpf_obj_get_user(const char __user 
>> *pathname, int flags);
>>       int __init bpf_iter_ ## target(args) { return 0; }
>>   struct bpf_iter_aux_info {
>> +    /* for map_elem iter */
>>       struct bpf_map *map;
>> +
>> +    /* for cgroup iter */
>> +    struct {
>> +        struct cgroup *start; /* starting cgroup */
>> +        int order;
>> +    } cgroup;
>>   };
>>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 379e68fb866fc..6f5979e221927 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -87,10 +87,27 @@ struct bpf_cgroup_storage_key {
>>       __u32    attach_type;        /* program attach type (enum 
>> bpf_attach_type) */
>>   };
>> +enum bpf_iter_cgroup_traversal_order {
>> +    BPF_ITER_CGROUP_PRE = 0,    /* pre-order traversal */
>> +    BPF_ITER_CGROUP_POST,        /* post-order traversal */
>> +    BPF_ITER_CGROUP_PARENT_UP,    /* traversal of ancestors up to the 
>> root */
>> +};
>> +
>>   union bpf_iter_link_info {
>>       struct {
>>           __u32    map_fd;
>>       } map;
>> +
>> +    /* cgroup_iter walks either the live descendants of a cgroup 
>> subtree, or the ancestors
>> +     * of a given cgroup.
>> +     */
>> +    struct {
>> +        /* Cgroup file descriptor. This is root of the subtree if for 
>> walking the
>> +         * descendants; this is the starting cgroup if for walking 
>> the ancestors.
> 
> Adding comment that cgroup_fd 0 means starting from root cgroup?
> Also, if I understand correctly, cgroup v1 is also supported here, 
> right? If this is the case, for cgroup v1 which root cgroup will be
> used for cgroup_fd? It would be good to clarify here too.
> 
>> +         */
>> +        __u32    cgroup_fd;
>> +        __u32    traversal_order;
>> +    } cgroup;
>>   };
>>   /* BPF syscall commands, see bpf(2) man-page for more details. */
>> @@ -6134,6 +6151,10 @@ struct bpf_link_info {
>>                   struct {
>>                       __u32 map_id;
>>                   } map;
>> +                struct {
>> +                    __u32 traversal_order;
>> +                    __aligned_u64 cgroup_id;
>> +                } cgroup;
> 
> We actually has a problem here although I don't have a solution yet.
> 
> Without this patch, for bpf_link_info structure, the output of pahole,
> 
>                  struct {
> 
>                          __u64              target_name 
> __attribute__((__aligned__(8))); /*     0     8 */
>                          __u32              target_name_len;      /* 
>   8     4 */
>                          union {
> 
>                                  struct {
> 
>                                          __u32 map_id;            /* 
> 12     4 */
>                                  } map;                           /* 
> 12     4 */
>                          };                                       /* 
> 12     4 */
>                          union {
>                                  struct {
>                                          __u32      map_id;   /*     
> 0     4 */
>                                  } map;   /*     0     4 */
>                          };
> 
>                  } iter;
> 
> You can see map_id has the offset 12 from the beginning of 'iter' 
> structure.
> 
> With this patch,
> 
>                  struct {
>                          __u64              target_name 
> __attribute__((__aligned__(8))); /*     0     8 */
>                          __u32              target_name_len;      /* 
>   8     4 */
> 
>                          /* XXX 4 bytes hole, try to pack */
> 
>                          union {
>                                  struct {
>                                          __u32 map_id;            /* 
> 16     4 */
>                                  } map;                           /* 
> 16     4 */
>                                  struct {
>                                          __u32 traversal_order;   /* 
> 16     4 */
> 
>                                          /* XXX 4 bytes hole, try to 
> pack */
> 
>                                          __u64 cgroup_id;         /* 
> 24     8 */
>                                  } cgroup;                        /* 
> 16    16 */
>                          };                                       /* 
> 16    16 */
>                          union {
>                                  struct {
>                                          __u32      map_id;   /*     
> 0     4 */
>                                  } map;   /*     0     4 */
>                                  struct {
>                                          __u32      traversal_order;   
> /*     0     4 */
> 
>                                          /* XXX 4 bytes hole, try to 
> pack */
> 
>                                          __u64      cgroup_id;   /*     
> 8     8 */
>                                  } cgroup;   /*     0    16 */
>                          };
> 
>                  } iter;
> 
> There is a 4 byte hole after member 'target_name_len'. So map_id will
> have a offset 16 from the start of structure 'iter'.
> 
> 
> This will break uapi. We probably won't be able to change the existing
> uapi with adding a ':32' after member 'target_name_len'. I don't have
> a good solution yet, but any suggestion is welcome.
> 
> Also, for '__aligned_u64 cgroup_id', '__u64 cgroup_id' is enough.
> '__aligned_u64' mostly used for pointers.

Briefly discussed with Alexei, the following structure iter definition
should work. Later on, if we need to addition fields for other iter's,
for a single __u32, the field can be added to either the first or the
second union. If fields are more than __u32, they can be placed
in the second union.

                 struct {
                         __aligned_u64 target_name; /* in/out: 
target_name buffer ptr */
                         __u32 target_name_len;     /* in/out: 
target_name buffer len */
                         union {
                                 struct {
                                         __u32 map_id;
                                 } map;
                         };
                         union {
                                 struct {
                                         __u64 cgroup_id;
                                         __u32 traversal_order;
                                 } cgroup;
                         };
                 } iter;


> 
> 
>>               };
>>           } iter;
>>           struct  {
>> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
>> index 057ba8e01e70f..00e05b69a4df1 100644
>> --- a/kernel/bpf/Makefile
>> +++ b/kernel/bpf/Makefile
>> @@ -24,6 +24,9 @@ endif
>>   ifeq ($(CONFIG_PERF_EVENTS),y)
>>   obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
>>   endif
>> +ifeq ($(CONFIG_CGROUPS),y)
>> +obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
>> +endif
>>   obj-$(CONFIG_CGROUP_BPF) += cgroup.o
>>   ifeq ($(CONFIG_INET),y)
>>   obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
>> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
>> new file mode 100644
>> index 0000000000000..8f50b326016e6
>> --- /dev/null
>> +++ b/kernel/bpf/cgroup_iter.c
>> @@ -0,0 +1,242 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (c) 2022 Google */
>> +#include <linux/bpf.h>
>> +#include <linux/btf_ids.h>
>> +#include <linux/cgroup.h>
>> +#include <linux/kernel.h>
>> +#include <linux/seq_file.h>
>> +
>> +#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and 
>> cgroup_is_dead */
>> +
>> +/* cgroup_iter provides three modes of traversal to the cgroup 
>> hierarchy.
>> + *
>> + *  1. Walk the descendants of a cgroup in pre-order.
>> + *  2. Walk the descendants of a cgroup in post-order.
>> + *  2. Walk the ancestors of a cgroup.
>> + *
>> + * For walking descendants, cgroup_iter can walk in either pre-order or
>> + * post-order. For walking ancestors, the iter walks up from a cgroup to
>> + * the root.
>> + *
>> + * The iter program can terminate the walk early by returning 1. Walk
>> + * continues if prog returns 0.
>> + *
>> + * The prog can check (seq->num == 0) to determine whether this is
>> + * the first element. The prog may also be passed a NULL cgroup,
>> + * which means the walk has completed and the prog has a chance to
>> + * do post-processing, such as outputing an epilogue.
>> + *
>> + * Note: the iter_prog is called with cgroup_mutex held.
>> + */
>> +
>> +struct bpf_iter__cgroup {
>> +    __bpf_md_ptr(struct bpf_iter_meta *, meta);
>> +    __bpf_md_ptr(struct cgroup *, cgroup);
>> +};
>> +
>> +struct cgroup_iter_priv {
>> +    struct cgroup_subsys_state *start_css;
>> +    bool terminate;
>> +    int order;
>> +};
>> +
>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
>> +{
>> +    struct cgroup_iter_priv *p = seq->private;
>> +
>> +    mutex_lock(&cgroup_mutex);
>> +
>> +    /* support only one session */
>> +    if (*pos > 0)
>> +        return NULL;
> 
> This might be okay. But want to check what is
> the practical upper limit for cgroups in a system
> and whether we may miss some cgroups. If this
> happens, it will be a surprise to the user.
> 
>> +
>> +    ++*pos;
>> +    p->terminate = false;
>> +    if (p->order == BPF_ITER_CGROUP_PRE)
>> +        return css_next_descendant_pre(NULL, p->start_css);
>> +    else if (p->order == BPF_ITER_CGROUP_POST)
>> +        return css_next_descendant_post(NULL, p->start_css);
>> +    else /* BPF_ITER_CGROUP_PARENT_UP */
>> +        return p->start_css;
>> +}
>> +
>> +static int __cgroup_iter_seq_show(struct seq_file *seq,
>> +                  struct cgroup_subsys_state *css, int in_stop);
>> +
>> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
>> +{
>> +    /* pass NULL to the prog for post-processing */
>> +    if (!v)
>> +        __cgroup_iter_seq_show(seq, NULL, true);
>> +    mutex_unlock(&cgroup_mutex);
>> +}
>> +
> [...]
