From: Stephane Eranian <eranian-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] perf: remove include of cgroup.h from perf_event.h
Date: Tue, 5 Mar 2013 09:33:57 +0100
Message-ID: <CABPqkBTTn6E=FS6WiCWopcScHDVa9F6bu5-pw8Ma7TK2aunkvQ@mail.gmail.com>
References: <513568A0.6020804@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=OXSTqhRxZXMDfeEO/UllcvtYjX57uiYo6xYiW1Tkohg=;
        b=OC0E9FxQGb1DooJjnrmQoAkZrIx06gcMOSTXxY2NmP+b43D0C+Wx1J+ya2jpKmpGry
         j0C1R4PeYYA0jv+HGwuFkBWVZhuw8emjE1+nKogLvi4okVrMPamBXT5VwvUHJTrMetyo
         Ons18zSvzOqamHHbTcOke0GM3X9laXKtEBUNdBOMakySKvFopEkjcGylrVXs4oknJQ3y
         NFiMBfAAw50u3sX22cQ3TWlXgmblCby1lzTppr30PAf6EMuM++D2ozljru2LEVZc5Lmx
         iqxZd7+KnNRUc7M0fM3KABbd20E3ZB/SJ1hwxXAjKQQO95Gd09MY90p7ERBGbJhdgzoK
         68Mg==
In-Reply-To: <513568A0.6020804-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, Mar 5, 2013 at 4:38 AM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> Move struct perf_cgroup_info and perf_cgroup to kernel/perf/core.c,
> and then we can remove include of cgroup.h.
>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/perf_event.h | 18 +-----------------
>  kernel/events/core.c       | 15 +++++++++++++++
>  2 files changed, 16 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index e47ee46..8737e1c 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -21,7 +21,6 @@
>   */
>
>  #ifdef CONFIG_PERF_EVENTS
> -# include <linux/cgroup.h>
>  # include <asm/perf_event.h>
>  # include <asm/local64.h>
>  #endif
> @@ -299,22 +298,7 @@ struct swevent_hlist {
>  #define PERF_ATTACH_GROUP      0x02
>  #define PERF_ATTACH_TASK       0x04
>
> -#ifdef CONFIG_CGROUP_PERF
> -/*
> - * perf_cgroup_info keeps track of time_enabled for a cgroup.
> - * This is a per-cpu dynamically allocated data structure.
> - */
> -struct perf_cgroup_info {
> -       u64                             time;
> -       u64                             timestamp;
> -};
> -
> -struct perf_cgroup {
> -       struct                          cgroup_subsys_state css;
> -       struct                          perf_cgroup_info *info; /* timing info, one per cpu */
> -};
> -#endif
> -
> +struct perf_cgroup;

The problem is that you have struct perf_cgroup in the struct perf_event
structure. Today, this field is not referenced outside of kernel/events/core.c
But it is available outside this file. If someday the field is reference, your
changes will have to do reverted. So I am wondering what is the point
of the change right now?


>  struct ring_buffer;
>
>  /**
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index b0cd865..5976a2a 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -37,6 +37,7 @@
>  #include <linux/ftrace_event.h>
>  #include <linux/hw_breakpoint.h>
>  #include <linux/mm_types.h>
> +#include <linux/cgroup.h>
>
>  #include "internal.h"
>
> @@ -234,6 +235,20 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
>  #ifdef CONFIG_CGROUP_PERF
>
>  /*
> + * perf_cgroup_info keeps track of time_enabled for a cgroup.
> + * This is a per-cpu dynamically allocated data structure.
> + */
> +struct perf_cgroup_info {
> +       u64                             time;
> +       u64                             timestamp;
> +};
> +
> +struct perf_cgroup {
> +       struct cgroup_subsys_state      css;
> +       struct perf_cgroup_info         *info;
> +};
> +
> +/*
>   * Must ensure cgroup is pinned (css_get) before calling
>   * this function. In other words, we cannot call this function
>   * if there is no cgroup event for the current CPU context.
> --
> 1.8.0.2
>
