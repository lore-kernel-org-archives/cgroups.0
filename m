From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Date: Mon, 27 Jun 2022 21:09:35 -0700
Message-ID: <f6c0274d-73c4-e05b-6405-4062230c4a14@fb.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=y8R8QjI/IO7WcZLSPuHH65aIJX1yMCW8tgsdBONth+c=;
 b=IpsLLvZti/0u3OvwRL3yWoUf4x3f6HhcGK9931KvR6a433frDx6ZTX5z2nAoEhy4Jx6C
 35d6ffywKp9pa29E1ShBq1A5XIsC8tGPwjMzrGFVUR3ErVbBXxSQZ7zCKaB55IoEw3HZ
 7BED0qVWlwq2W7VUKJaSHXRgeofZpWykrbM= 
Content-Language: en-US
In-Reply-To: <20220610194435.2268290-5-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in two modes:
> 
>   - walking a cgroup's descendants.
>   - walking a cgroup's ancestors.

The implementation has another choice, BPF_ITER_CGROUP_PARENT_UP.
We should add it here as well.

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

Overall looks good to me with a few nits below.

Acked-by: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>

> 
> Signed-off-by: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>   include/linux/bpf.h            |   8 ++
>   include/uapi/linux/bpf.h       |  21 +++
>   kernel/bpf/Makefile            |   2 +-
>   kernel/bpf/cgroup_iter.c       | 235 +++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h |  21 +++
>   5 files changed, 286 insertions(+), 1 deletion(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 8e6092d0ea956..48d8e836b9748 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -44,6 +44,7 @@ struct kobject;
>   struct mem_cgroup;
>   struct module;
>   struct bpf_func_state;
> +struct cgroup;
>   
>   extern struct idr btf_idr;
>   extern spinlock_t btf_idr_lock;
> @@ -1590,7 +1591,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
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
> index f4009dbdf62da..4fd05cde19116 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,27 @@ struct bpf_cgroup_storage_key {
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
> +	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the ancestors
> +	 * of a given cgroup.
> +	 */
> +	struct {
> +		/* Cgroup file descriptor. This is root of the subtree if for walking the
> +		 * descendants; this is the starting cgroup if for walking the ancestors.
> +		 */
> +		__u32	cgroup_fd;
> +		__u32	traversal_order;
> +	} cgroup;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6050,6 +6067,10 @@ struct bpf_link_info {
>   				struct {
>   					__u32 map_id;
>   				} map;
> +				struct {
> +					__u32 traversal_order;
> +					__aligned_u64 cgroup_id;
> +				} cgroup;
>   			};
>   		} iter;
>   		struct  {
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 057ba8e01e70f..9741b9314fb46 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -8,7 +8,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
>   
>   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
> -obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
> +obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o cgroup_iter.o
>   obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
>   obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
>   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> new file mode 100644
> index 0000000000000..88deb655efa71
> --- /dev/null
> +++ b/kernel/bpf/cgroup_iter.c
> @@ -0,0 +1,235 @@
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
> +/* cgroup_iter provides two modes of traversal to the cgroup hierarchy.
> + *
> + *  1. Walk the descendants of a cgroup.
> + *  2. Walk the ancestors of a cgroup.

three modes here?

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
> + */
> +
> +struct bpf_iter__cgroup {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct cgroup *, cgroup);
> +};
> +
> +struct cgroup_iter_priv {
> +	struct cgroup_subsys_state *start_css;
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
> +	/* support only one session */
> +	if (*pos > 0)
> +		return NULL;
> +
> +	++*pos;
> +	p->terminate = false;
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(NULL, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(NULL, p->start_css);
> +	else /* BPF_ITER_CGROUP_PARENT_UP */
> +		return p->start_css;
> +}
> +
> +static int __cgroup_iter_seq_show(struct seq_file *seq,
> +				  struct cgroup_subsys_state *css, int in_stop);
> +
> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
> +{
> +	/* pass NULL to the prog for post-processing */
> +	if (!v)
> +		__cgroup_iter_seq_show(seq, NULL, true);
> +	mutex_unlock(&cgroup_mutex);
> +}
> +
> +static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct cgroup_subsys_state *curr = (struct cgroup_subsys_state *)v;
> +	struct cgroup_iter_priv *p = seq->private;
> +
> +	++*pos;
> +	if (p->terminate)
> +		return NULL;
> +
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(curr, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(curr, p->start_css);
> +	else
> +		return curr->parent;
> +}
> +
> +static int __cgroup_iter_seq_show(struct seq_file *seq,
> +				  struct cgroup_subsys_state *css, int in_stop)
> +{
> +	struct cgroup_iter_priv *p = seq->private;
> +	struct bpf_iter__cgroup ctx;
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +	int ret = 0;
> +
> +	/* cgroup is dead, skip this element */
> +	if (css && cgroup_is_dead(css->cgroup))
> +		return 0;
> +
> +	ctx.meta = &meta;
> +	ctx.cgroup = css ? css->cgroup : NULL;
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, in_stop);
> +	if (prog)
> +		ret = bpf_iter_run_prog(prog, &ctx);
> +
> +	/* if prog returns > 0, terminate after this element. */
> +	if (ret != 0)
> +		p->terminate = true;
> +
> +	return 0;
> +}
> +
> +static int cgroup_iter_seq_show(struct seq_file *seq, void *v)
> +{
> +	return __cgroup_iter_seq_show(seq, (struct cgroup_subsys_state *)v,
> +				      false);
> +}
> +
> +static const struct seq_operations cgroup_iter_seq_ops = {
> +	.start  = cgroup_iter_seq_start,
> +	.next   = cgroup_iter_seq_next,
> +	.stop   = cgroup_iter_seq_stop,
> +	.show   = cgroup_iter_seq_show,
> +};
> +
> +BTF_ID_LIST_SINGLE(bpf_cgroup_btf_id, struct, cgroup)
> +
> +static int cgroup_iter_seq_init(void *priv, struct bpf_iter_aux_info *aux)
> +{
> +	struct cgroup_iter_priv *p = (struct cgroup_iter_priv *)priv;
> +	struct cgroup *cgrp = aux->cgroup.start;
> +
> +	p->start_css = &cgrp->self;
> +	p->terminate = false;
> +	p->order = aux->cgroup.order;
> +	return 0;
> +}
> +
> +static const struct bpf_iter_seq_info cgroup_iter_seq_info = {
> +	.seq_ops                = &cgroup_iter_seq_ops,
> +	.init_seq_private       = cgroup_iter_seq_init,
> +	.seq_priv_size          = sizeof(struct cgroup_iter_priv),
> +};
> +
> +static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> +				  union bpf_iter_link_info *linfo,
> +				  struct bpf_iter_aux_info *aux)
> +{
> +	int fd = linfo->cgroup.cgroup_fd;
> +	struct cgroup *cgrp;
> +
> +	if (fd)
> +		cgrp = cgroup_get_from_fd(fd);
> +	else /* walk the entire hierarchy by default. */
> +		cgrp = cgroup_get_from_path("/");
> +
> +	if (IS_ERR(cgrp))
> +		return PTR_ERR(cgrp);
> +
> +	aux->cgroup.start = cgrp;
> +	aux->cgroup.order = linfo->cgroup.traversal_order;

The legality of traversal_order should be checked.

> +	return 0;
> +}
> +
> +static void bpf_iter_detach_cgroup(struct bpf_iter_aux_info *aux)
> +{
> +	cgroup_put(aux->cgroup.start);
> +}
> +
> +static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
> +					struct seq_file *seq)
> +{
> +	char *buf;
> +
> +	buf = kzalloc(PATH_MAX, GFP_KERNEL);
> +	if (!buf) {
> +		seq_puts(seq, "cgroup_path:\n");

This is a really unlikely case. maybe "cgroup_path:<unknown>"?

> +		goto show_order;
> +	}
> +
> +	/* If cgroup_path_ns() fails, buf will be an empty string, cgroup_path
> +	 * will print nothing.
> +	 *
> +	 * Path is in the calling process's cgroup namespace.
> +	 */
> +	cgroup_path_ns(aux->cgroup.start, buf, PATH_MAX,
> +		       current->nsproxy->cgroup_ns);
> +	seq_printf(seq, "cgroup_path:\t%s\n", buf);
> +	kfree(buf);
> +
> +show_order:
> +	if (aux->cgroup.order == BPF_ITER_CGROUP_PRE)
> +		seq_puts(seq, "traversal_order: pre\n");
> +	else if (aux->cgroup.order == BPF_ITER_CGROUP_POST)
> +		seq_puts(seq, "traversal_order: post\n");
> +	else /* BPF_ITER_CGROUP_PARENT_UP */
> +		seq_puts(seq, "traversal_order: parent_up\n");
> +}
> +
[...]
