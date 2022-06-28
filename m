From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Date: Mon, 27 Jun 2022 21:14:18 -0700
Message-ID: <40114462-d5e2-ab07-7af9-5e60180027f9@fb.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VoaGov6hKjpcuuyFinFnNspQtMbN34D3FaR0W1CPW7c=;
 b=YEPesEry/ll09FQiLJN1Da8Pwg7kuWBA6Jdc675jfhCAWiZ+UqqGTSN9n422clgSyM9K
 hq9HZZMqXddjA0Z6Tq/PxlYLqb1qd7ODORWTgBgFOypcZ8APEBYxXLwU3EsM2UyGP8Sx
 suEZpRgnFS+cFXLRGncsuw+Q1Apvs2sZqJk= 
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
[...]
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

Do we need to do anything special to ensure bpf program gets
up-to-date stat from ctx.cgroup?

> +
> +	/* if prog returns > 0, terminate after this element. */
> +	if (ret != 0)
> +		p->terminate = true;
> +
> +	return 0;
> +}
> +
[...]
