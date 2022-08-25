From: Yonghong Song <yhs@fb.com>
Subject: Re: [RESEND PATCH bpf-next v9 1/5] bpf: Introduce cgroup iter
Date: Thu, 25 Aug 2022 16:00:17 -0700
Message-ID: <9edbddb7-4a3b-f8d1-777c-66e5f8efc977@fb.com>
References: <20220824233117.1312810-1-haoluo@google.com>
 <20220824233117.1312810-2-haoluo@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OmkLj5Myh3hymJJK14gqPoKd6G2/AMi3OtGulds5Ajg=;
 b=FLVKHXt4oQnuiQ7qlJsWvp/E8EzXUijLI+wANoL8Zh3W+xMHdhuwzTTLFvlsxmvGI8Rw
 tOw5ee1o0wwJlGUpVMNqHjvXb9ZuuXcUqC8z6VKgOSfRVxZwC8u87gHxYMltTwIM14ip
 z7H8oCleLk62p3qhpQ7YhbjdeQpFf7cbgh4= 
Content-Language: en-US
In-Reply-To: <20220824233117.1312810-2-haoluo@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hao Luo <haoluo@google.com>, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, KP Singh <kpsingh@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, John Fastabend <john.fastabend@gmail.com>, Jiri Olsa <jolsa@kernel.org>, Michal Koutny <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Shakeel Butt <shakeelb@google.com>, Yosry Ahmed <yosryahmed@google.com>



On 8/24/22 4:31 PM, Hao Luo wrote:
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in four modes:
> 
>   - walking a cgroup's descendants in pre-order.
>   - walking a cgroup's descendants in post-order.
>   - walking a cgroup's ancestors.
>   - process only the given cgroup.
> 
> When attaching cgroup_iter, one can set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor
> or cgroup id and serves as the starting point of the walk. If no
> cgroup is specified, the starting point will be the root cgroup v2.
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
> data is larger than the kernel buffer size, after all data in the
> kernel buffer is consumed by user space, the subsequent read() syscall
> will signal EOPNOTSUPP. In order to work around, the user may have to
> update their program to reduce the volume of data sent to output. For
> example, skip some uninteresting cgroups. In future, we may extend
> bpf_iter flags to allow customizing buffer size.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>   include/linux/bpf.h                           |   8 +
>   include/uapi/linux/bpf.h                      |  30 ++
>   kernel/bpf/Makefile                           |   3 +
>   kernel/bpf/cgroup_iter.c                      | 284 ++++++++++++++++++
>   tools/include/uapi/linux/bpf.h                |  30 ++
>   .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>   6 files changed, 357 insertions(+), 2 deletions(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 99fc7a64564f..9c1674973e03 100644
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
> +		enum bpf_cgroup_iter_order order;
> +	} cgroup;
>   };
>   
>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 644600dbb114..0f61f09f467a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,29 @@ struct bpf_cgroup_storage_key {
>   	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
>   };
>   
> +enum bpf_cgroup_iter_order {
> +	BPF_ITER_ORDER_UNSPEC = 0,
> +	BPF_ITER_SELF_ONLY,		/* process only a single object. */
> +	BPF_ITER_DESCENDANTS_PRE,	/* walk descendants in pre-order. */
> +	BPF_ITER_DESCENDANTS_POST,	/* walk descendants in post-order. */
> +	BPF_ITER_ANCESTORS_UP,		/* walk ancestors upward. */
> +};
> +
>   union bpf_iter_link_info {
>   	struct {
>   		__u32	map_fd;
>   	} map;
> +	struct {
> +		enum bpf_cgroup_iter_order order;
> +
> +		/* At most one of cgroup_fd and cgroup_id can be non-zero. If
> +		 * both are zero, the walk starts from the default cgroup v2
> +		 * root. For walking v1 hierarchy, one should always explicitly
> +		 * specify cgroup_fd.
> +		 */
> +		__u32	cgroup_fd;
> +		__u64	cgroup_id;
> +	} cgroup;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6176,11 +6195,22 @@ struct bpf_link_info {
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
> +					__u32 order;
> +				} cgroup;
> +			};
>   		} iter;
>   		struct  {
>   			__u32 netns_ino;

Hao, we missed the bpftool dump part for the above bpf_link_info so
a followup is needed.
Please take a look at tools/bpf/bpftool/link.c searching 'map_id'
for an example.
