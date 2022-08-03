From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v6 4/8] bpf: Introduce cgroup iter
Date: Wed, 3 Aug 2022 00:44:00 -0700
Message-ID: <c018a834-e834-270c-24b1-2c726b38b729@fb.com>
References: <20220801175407.2647869-1-haoluo@google.com>
 <20220801175407.2647869-5-haoluo@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bjJGCrhUBCXr8ln00Sd9xbn9iQiz3Al/MXTsFVr+irE=;
 b=Kf1SUDK1PZsteCSW/3O932ZTiFP+ujt4DbbL3MdqXz+VG2vfUiYD4k9rYpQB8hmc1jUN
 SgFFKZawDIarZm83NFd5SS25xcVirmslQ7/o/4LRcv9QneBcs9FIcVU0aPwEzn38AJ9r
 OtMwaKzGf6tvCPZwoeNaCz3bsdzv2VU6vvA= 
Content-Language: en-US
In-Reply-To: <20220801175407.2647869-5-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hao Luo <haoluo@google.com>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>



On 8/1/22 10:54 AM, Hao Luo wrote:
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
> 
>   - walking a cgroup's descendants in pre-order.
>   - walking a cgroup's descendants in post-order.
>   - walking a cgroup's ancestors.
> 
> When attaching cgroup_iter, one can set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor and
> serves as the starting point of the walk. If no cgroup is specified,
> the starting point will be the root cgroup.
> 
> For walking descendants, one can specify the order: either pre-order or
> post-order. For walking ancestors, the walk starts at the specified
> cgroup and ends at the root.
> 
> One can also terminate the walk early by returning 1 from the iter
> program.
> 
> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> program is called with cgroup_mutex held.
> 
> Currently only one session is supported, which means, depending on the
> volume of data bpf program intends to send to user space, the number
> of cgroups that can be walked is limited. For example, given the current
> buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> be walked is 512. This is a limitation of cgroup_iter. If the output
> data is larger than the buffer size, the second read() will signal
> EOPNOTSUPP. In order to work around, the user may have to update their

'the second read() will signal EOPNOTSUPP' is not true. for bpf_iter,
we have user buffer from read() syscall and kernel buffer. The above
buffer size like 8 * PAGE_SIZE refers to the kernel buffer size.

If read() syscall buffer size is less than kernel buffer size,
the second read() will not signal EOPNOTSUPP. So to make it precise,
we can say
   If the output data is larger than the kernel buffer size, after
   all data in the kernel buffer is consumed by user space, the
   subsequent read() syscall will signal EOPNOTSUPP.

> program to reduce the volume of data sent to output. For example, skip
> some uninteresting cgroups. In future, we may extend bpf_iter flags to
> allow customizing buffer size.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   include/linux/bpf.h                           |   8 +
>   include/uapi/linux/bpf.h                      |  31 ++
>   kernel/bpf/Makefile                           |   3 +
>   kernel/bpf/cgroup_iter.c                      | 268 ++++++++++++++++++
>   tools/include/uapi/linux/bpf.h                |  31 ++
>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>   6 files changed, 343 insertions(+), 2 deletions(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 20c26aed7896..09b5c2167424 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -48,6 +48,7 @@ struct mem_cgroup;
>   struct module;
>   struct bpf_func_state;
>   struct ftrace_ops;
> +struct cgroup;
>   
>   extern struct idr btf_idr;
>   extern spinlock_t btf_idr_lock;
> @@ -1730,7 +1731,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>   	int __init bpf_iter_ ## target(args) { return 0; }
>   
>   struct bpf_iter_aux_info {
> +	/* for map_elem iter */
>   	struct bpf_map *map;
> +
> +	/* for cgroup iter */
> +	struct {
> +		struct cgroup *start; /* starting cgroup */
> +		int order;
> +	} cgroup;
>   };
>   
>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 59a217ca2dfd..b8e0644bf43c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
>   	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
>   };
>   
> +enum bpf_iter_cgroup_traversal_order {
> +	BPF_ITER_CGROUP_PRE = 0,	/* pre-order traversal */
> +	BPF_ITER_CGROUP_POST,		/* post-order traversal */
> +	BPF_ITER_CGROUP_PARENT_UP,	/* traversal of ancestors up to the root */
> +};
> +
>   union bpf_iter_link_info {
>   	struct {
>   		__u32	map_fd;
>   	} map;
> +
> +	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> +	 * ancestors of a given cgroup.
> +	 */
> +	struct {
> +		/* Cgroup file descriptor. This is root of the subtree if walking
> +		 * descendants; it's the starting cgroup if walking the ancestors.
> +		 * If it is left 0, the traversal starts from the default cgroup v2
> +		 * root. For walking v1 hierarchy, one should always explicitly
> +		 * specify the cgroup_fd.
> +		 */
> +		__u32	cgroup_fd;
> +		__u32	traversal_order;
> +	} cgroup;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6134,11 +6154,22 @@ struct bpf_link_info {
>   		struct {
>   			__aligned_u64 target_name; /* in/out: target_name buffer ptr */
>   			__u32 target_name_len;	   /* in/out: target_name buffer len */
> +
> +			/* If the iter specific field is 32 bits, it can be put
> +			 * in the first or second union. Otherwise it should be
> +			 * put in the second union.
> +			 */
>   			union {
>   				struct {
>   					__u32 map_id;
>   				} map;
>   			};
> +			union {
> +				struct {
> +					__u64 cgroup_id;
> +					__u32 traversal_order;
> +				} cgroup;
> +			};
>   		} iter;
>   		struct  {
>   			__u32 netns_ino;
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 057ba8e01e70..00e05b69a4df 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -24,6 +24,9 @@ endif
>   ifeq ($(CONFIG_PERF_EVENTS),y)
>   obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
>   endif
> +ifeq ($(CONFIG_CGROUPS),y)
> +obj-$(CONFIG_BPF_SYSCALL) += cgroup_iter.o
> +endif
>   obj-$(CONFIG_CGROUP_BPF) += cgroup.o
>   ifeq ($(CONFIG_INET),y)
>   obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> new file mode 100644
> index 000000000000..e56178fbcc85
> --- /dev/null
> +++ b/kernel/bpf/cgroup_iter.c
> @@ -0,0 +1,268 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2022 Google */
> +#include <linux/bpf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/cgroup.h>
> +#include <linux/kernel.h>
> +#include <linux/seq_file.h>
> +
> +#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and cgroup_is_dead */
> +
> +/* cgroup_iter provides three modes of traversal to the cgroup hierarchy.
> + *
> + *  1. Walk the descendants of a cgroup in pre-order.
> + *  2. Walk the descendants of a cgroup in post-order.
> + *  2. Walk the ancestors of a cgroup.
> + *
> + * For walking descendants, cgroup_iter can walk in either pre-order or
> + * post-order. For walking ancestors, the iter walks up from a cgroup to
> + * the root.
> + *
> + * The iter program can terminate the walk early by returning 1. Walk
> + * continues if prog returns 0.
> + *
> + * The prog can check (seq->num == 0) to determine whether this is
> + * the first element. The prog may also be passed a NULL cgroup,
> + * which means the walk has completed and the prog has a chance to
> + * do post-processing, such as outputing an epilogue.
> + *
> + * Note: the iter_prog is called with cgroup_mutex held.
> + *
> + * Currently only one session is supported, which means, depending on the
> + * volume of data bpf program intends to send to user space, the number
> + * of cgroups that can be walked is limited. For example, given the current
> + * buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> + * cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> + * be walked is 512. This is a limitation of cgroup_iter. If the output data
> + * is larger than the buffer size, the second read() will signal EOPNOTSUPP.
> + * In order to work around, the user may have to update their program to

same here as above for better description.

> + * reduce the volume of data sent to output. For example, skip some
> + * uninteresting cgroups.
> + */
> +
> +struct bpf_iter__cgroup {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct cgroup *, cgroup);
> +};
> +
> +struct cgroup_iter_priv {
> +	struct cgroup_subsys_state *start_css;
> +	bool visited_all;
> +	bool terminate;
> +	int order;
> +};
> +
> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct cgroup_iter_priv *p = seq->private;
> +
> +	mutex_lock(&cgroup_mutex);
> +
> +	/* cgroup_iter doesn't support read across multiple sessions. */
> +	if (*pos > 0) {
> +		if (p->visited_all)
> +			return NULL;

This looks good. thanks!

> +
> +		/* Haven't visited all, but because cgroup_mutex has dropped,
> +		 * return -EOPNOTSUPP to indicate incomplete iteration.
> +		 */
> +		return ERR_PTR(-EOPNOTSUPP);
> +	}
> +
> +	++*pos;
> +	p->terminate = false;
> +	p->visited_all = false;
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(NULL, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(NULL, p->start_css);
> +	else /* BPF_ITER_CGROUP_PARENT_UP */
> +		return p->start_css;
> +}
> +
[...]
