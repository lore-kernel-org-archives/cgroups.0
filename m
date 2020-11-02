From: Kenny Ho <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Add BPF_PROG_TYPE_CGROUP_IOCTL
Date: Mon, 2 Nov 2020 14:23:02 -0500
Message-ID: <CAOWid-d=a1Q3R92s7GrzxWhXx7_dc8NQvQg7i7RYTVv3+jHxkQ@mail.gmail.com>
References: <20201007152355.2446741-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=O2roJi9bc81755qLfSnTnaxoncu2lW7arGJfQBREeHQ=;
 b=JkGQpaWd1s/vPA4IEkUtKBWlxS3b7yQ+yKb7GeJMlngkRkYiBFWwEZWbqSysn/ZaUR
 B6/RA+g2sLJKTMLGzhBpeyRrBsKKfGRUucEzWiL3pZj2sgtlmJrPWDFq37QFVgZMsqoX
 TVtqMSFkpb1g5+qIk3z6ICzJlIzA8/SlQRiBcDQNS7/43Q9uIH5Ufz3urzVBdxKhgIMd
 jcZqf7rsQEnRTmCmZUaS855Zt67hBOj1U7ni7bZOAxGitjeIbLPWCZd1pFdVKBFtcWUr
 kRlxvtdGaFpBp9yigbLofCcg6gdhbBZkwa2v7EFRLtBTO0ixyqcO4pXSuJpi8c0TcdJT
 KA1g==
In-Reply-To: <20201007152355.2446741-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
To: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, Andrii Nakryiko <andriin-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>, amd-gfx list <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

Adding a few more emails from get_maintainer.pl and bumping this
thread since there hasn't been any comments so far.  Is this too
crazy?  Am I missing something fundamental?

Regards,
Kenny


On Wed, Oct 7, 2020 at 11:24 AM Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org> wrote:
>
> This is a skeleton implementation to invite comments and generate
> discussion around the idea of introducing a bpf-cgroup program type to
> control ioctl access.  This is modelled after
> BPF_PROG_TYPE_CGROUP_DEVICE.  The premise is to allow system admins to
> write bpf programs to block some ioctl access, potentially in conjunction
> with data collected by other bpf programs stored in some bpf maps and
> with bpf_spin_lock.
>
> For example, a bpf program has been accumulating resource usaging
> statistic and a second bpf program of BPF_PROG_TYPE_CGROUP_IOCTL would
> block access to previously mentioned resource via ioctl when the stats
> stored in a bpf map reaches certain threshold.
>
> Like BPF_PROG_TYPE_CGROUP_DEVICE, the default is permissive (i.e.,
> ioctls are not blocked if no bpf program is present for the cgroup.) to
> maintain current interface behaviour when this functionality is unused.
>
> Performance impact to ioctl calls is minimal as bpf's in-kernel verifier
> ensure attached bpf programs cannot crash and always terminate quickly.
>
> TODOs:
> - correct usage of the verifier
> - toolings
> - samples
> - device driver may provide helper functions that take
> bpf_cgroup_ioctl_ctx and return something more useful for specific
> device
>
> Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
> ---
>  fs/ioctl.c                 |  5 +++
>  include/linux/bpf-cgroup.h | 14 ++++++++
>  include/linux/bpf_types.h  |  2 ++
>  include/uapi/linux/bpf.h   |  8 +++++
>  kernel/bpf/cgroup.c        | 66 ++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c       |  7 ++++
>  kernel/bpf/verifier.c      |  1 +
>  7 files changed, 103 insertions(+)
>
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 4e6cc0a7d69c..a3925486d417 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -19,6 +19,7 @@
>  #include <linux/falloc.h>
>  #include <linux/sched/signal.h>
>  #include <linux/fiemap.h>
> +#include <linux/cgroup.h>
>
>  #include "internal.h"
>
> @@ -45,6 +46,10 @@ long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>         if (!filp->f_op->unlocked_ioctl)
>                 goto out;
>
> +       error = BPF_CGROUP_RUN_PROG_IOCTL(filp, cmd, arg);
> +       if (error)
> +               goto out;
> +
>         error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
>         if (error == -ENOIOCTLCMD)
>                 error = -ENOTTY;
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 64f367044e25..a5f0b0a8f82b 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -134,6 +134,9 @@ int __cgroup_bpf_run_filter_sock_ops(struct sock *sk,
>  int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
>                                       short access, enum bpf_attach_type type);
>
> +int __cgroup_bpf_check_ioctl_permission(struct file *filp, unsigned int cmd, unsigned long arg,
> +                                       enum bpf_attach_type type);
> +
>  int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
>                                    struct ctl_table *table, int write,
>                                    void **buf, size_t *pcount, loff_t *ppos,
> @@ -346,6 +349,16 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
>         __ret;                                                                 \
>  })
>
> +#define BPF_CGROUP_RUN_PROG_IOCTL(filp, cmd, arg)                            \
> +({                                                                           \
> +       int __ret = 0;                                                        \
> +       if (cgroup_bpf_enabled)                                               \
> +               __ret = __cgroup_bpf_check_ioctl_permission(filp, cmd, arg,   \
> +                                                           BPF_CGROUP_IOCTL);\
> +                                                                             \
> +       __ret;                                                                \
> +})
> +
>  int cgroup_bpf_prog_attach(const union bpf_attr *attr,
>                            enum bpf_prog_type ptype, struct bpf_prog *prog);
>  int cgroup_bpf_prog_detach(const union bpf_attr *attr,
> @@ -429,6 +442,7 @@ static inline int bpf_percpu_cgroup_storage_update(struct bpf_map *map,
>                                        optlen, max_optlen, retval) ({ retval; })
>  #define BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock, level, optname, optval, optlen, \
>                                        kernel_optval) ({ 0; })
> +#define BPF_CGROUP_RUN_PROG_IOCTL(type,major,minor,access) ({ 0; })
>
>  #define for_each_cgroup_storage_type(stype) for (; false; )
>
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index a52a5688418e..3055e7e4918c 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -56,6 +56,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl,
>               struct bpf_sysctl, struct bpf_sysctl_kern)
>  BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt,
>               struct bpf_sockopt, struct bpf_sockopt_kern)
> +BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_IOCTL, cg_ioctl,
> +             struct bpf_cgroup_ioctl_ctx, struct bpf_cgroup_ioctl_ctx)
>  #endif
>  #ifdef CONFIG_BPF_LIRC_MODE2
>  BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b6238b2209b7..6a908e13d3a3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -197,6 +197,7 @@ enum bpf_prog_type {
>         BPF_PROG_TYPE_EXT,
>         BPF_PROG_TYPE_LSM,
>         BPF_PROG_TYPE_SK_LOOKUP,
> +       BPF_PROG_TYPE_CGROUP_IOCTL,
>  };
>
>  enum bpf_attach_type {
> @@ -238,6 +239,7 @@ enum bpf_attach_type {
>         BPF_XDP_CPUMAP,
>         BPF_SK_LOOKUP,
>         BPF_XDP,
> +       BPF_CGROUP_IOCTL,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -4276,6 +4278,12 @@ struct bpf_cgroup_dev_ctx {
>         __u32 minor;
>  };
>
> +struct bpf_cgroup_ioctl_ctx {
> +       __u64 filp;
> +       __u32 cmd;
> +       __u32 arg;
> +};
> +
>  struct bpf_raw_tracepoint_args {
>         __u64 args[0];
>  };
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 83ff127ef7ae..0958bae3b0b7 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -1203,6 +1203,72 @@ const struct bpf_verifier_ops cg_dev_verifier_ops = {
>         .is_valid_access        = cgroup_dev_is_valid_access,
>  };
>
> +int __cgroup_bpf_check_ioctl_permission(struct file *filp, unsigned int cmd, unsigned long arg,
> +                                     enum bpf_attach_type type)
> +{
> +       struct cgroup *cgrp;
> +       struct bpf_cgroup_ioctl_ctx ctx = {
> +               .filp = filp,
> +               .cmd = cmd,
> +               .arg = arg,
> +       };
> +       int allow = 1;
> +
> +       rcu_read_lock();
> +       cgrp = task_dfl_cgroup(current);
> +       allow = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx,
> +                                  BPF_PROG_RUN);
> +       rcu_read_unlock();
> +
> +       return !allow;
> +}
> +
> +static const struct bpf_func_proto *
> +cgroup_ioctl_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> +{
> +       return cgroup_base_func_proto(func_id, prog);
> +}
> +
> +static bool cgroup_ioctl_is_valid_access(int off, int size,
> +                                      enum bpf_access_type type,
> +                                      const struct bpf_prog *prog,
> +                                      struct bpf_insn_access_aux *info)
> +{
> +       const int size_default = sizeof(__u32);
> +
> +       if (type == BPF_WRITE)
> +               return false;
> +
> +       if (off < 0 || off + size > sizeof(struct bpf_cgroup_ioctl_ctx))
> +               return false;
> +       /* The verifier guarantees that size > 0. */
> +       if (off % size != 0)
> +               return false;
> +
> +       switch (off) {
> +       case bpf_ctx_range(struct bpf_cgroup_ioctl_ctx, filp):
> +               bpf_ctx_record_field_size(info, size_default);
> +               if (!bpf_ctx_narrow_access_ok(off, size, size_default))
> +                       return false;
> +               break;
> +       case bpf_ctx_range(struct bpf_cgroup_ioctl_ctx, cmd):
> +       case bpf_ctx_range(struct bpf_cgroup_ioctl_ctx, arg):
> +       default:
> +               if (size != size_default)
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +const struct bpf_prog_ops cg_ioctl_prog_ops = {
> +};
> +
> +const struct bpf_verifier_ops cg_ioctl_verifier_ops = {
> +       .get_func_proto         = cgroup_ioctl_func_proto,
> +       .is_valid_access        = cgroup_ioctl_is_valid_access,
> +};
> +
>  /**
>   * __cgroup_bpf_run_filter_sysctl - Run a program on sysctl
>   *
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 86299a292214..6984a62c96f4 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2054,6 +2054,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
>         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>         case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>         case BPF_PROG_TYPE_CGROUP_SYSCTL:
> +       case BPF_PROG_TYPE_CGROUP_IOCTL:
>         case BPF_PROG_TYPE_SOCK_OPS:
>         case BPF_PROG_TYPE_EXT: /* extends any prog */
>                 return true;
> @@ -2806,6 +2807,8 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>                 return BPF_PROG_TYPE_SOCK_OPS;
>         case BPF_CGROUP_DEVICE:
>                 return BPF_PROG_TYPE_CGROUP_DEVICE;
> +       case BPF_CGROUP_IOCTL:
> +               return BPF_PROG_TYPE_CGROUP_IOCTL;
>         case BPF_SK_MSG_VERDICT:
>                 return BPF_PROG_TYPE_SK_MSG;
>         case BPF_SK_SKB_STREAM_PARSER:
> @@ -2878,6 +2881,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
>         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>         case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>         case BPF_PROG_TYPE_CGROUP_SYSCTL:
> +       case BPF_PROG_TYPE_CGROUP_IOCTL:
>         case BPF_PROG_TYPE_SOCK_OPS:
>                 ret = cgroup_bpf_prog_attach(attr, ptype, prog);
>                 break;
> @@ -2915,6 +2919,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
>         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>         case BPF_PROG_TYPE_CGROUP_SOCKOPT:
>         case BPF_PROG_TYPE_CGROUP_SYSCTL:
> +       case BPF_PROG_TYPE_CGROUP_IOCTL:
>         case BPF_PROG_TYPE_SOCK_OPS:
>                 return cgroup_bpf_prog_detach(attr, ptype);
>         default:
> @@ -2958,6 +2963,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
>         case BPF_CGROUP_SYSCTL:
>         case BPF_CGROUP_GETSOCKOPT:
>         case BPF_CGROUP_SETSOCKOPT:
> +       case BPF_CGROUP_IOCTL:
>                 return cgroup_bpf_prog_query(attr, uattr);
>         case BPF_LIRC_MODE2:
>                 return lirc_prog_query(attr, uattr);
> @@ -3914,6 +3920,7 @@ static int link_create(union bpf_attr *attr)
>         case BPF_PROG_TYPE_CGROUP_DEVICE:
>         case BPF_PROG_TYPE_CGROUP_SYSCTL:
>         case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> +       case BPF_PROG_TYPE_CGROUP_IOCTL:
>                 ret = cgroup_bpf_link_attach(attr, prog);
>                 break;
>         case BPF_PROG_TYPE_TRACING:
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index ef938f17b944..af68f463e828 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7419,6 +7419,7 @@ static int check_return_code(struct bpf_verifier_env *env)
>         case BPF_PROG_TYPE_CGROUP_DEVICE:
>         case BPF_PROG_TYPE_CGROUP_SYSCTL:
>         case BPF_PROG_TYPE_CGROUP_SOCKOPT:
> +       case BPF_PROG_TYPE_CGROUP_IOCTL:
>                 break;
>         case BPF_PROG_TYPE_RAW_TRACEPOINT:
>                 if (!env->prog->aux->attach_btf_id)
> --
> 2.25.1
>
