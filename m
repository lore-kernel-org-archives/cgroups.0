From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 02/10] memcg: enable accounting for pollfd and select
 bits arrays
Date: Tue, 27 Jul 2021 14:39:23 -0700
Message-ID: <CALvZod7e8pNhCU-o8-dFwn5v4aVoUrxxjGamfbaqK83d3UL1Mw@mail.gmail.com>
References: <6f21a0e0-bd36-b6be-1ffa-0dc86c06c470@virtuozzo.com>
 <cover.1627362057.git.vvs@virtuozzo.com> <56e31cb5-6e1e-bdba-d7ca-be64b9842363@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=586qQ0VfqS2t1FgawENmqvW9B/cgMqgnCEiHKLyzI/E=;
        b=u1/MVJO4zcfaei7PD7eWb+709nz15VrWARci7ePDMDFolJNUERP2wsbjom+4NbVKF7
         ssCxzxA0a2UMxu67QqmKkzf8Ut6ydxeIlIqw2blw57FpMzpCZ3PC+AX7TZdUAx0tipyl
         G8luFgvQvburMncuoSBNoiciSrzOHj4b5hjw5HfttQCJX69lVCqpmjGkRnGShNJwduXw
         Zh8TM0wbJKBTwe0RiYKQ6DlcLgR+hq+p9L+JSK8/8r1bCXiy6mY+G/ZI55irmnQDLRxC
         ZeISUoXD1z4L5Wyc48m90u3UbQaFELITPkCenCYevX5lJ/OgtMDHFVm6vd5w9iw29W+4
         Bw0g==
In-Reply-To: <56e31cb5-6e1e-bdba-d7ca-be64b9842363-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jul 26, 2021 at 10:33 PM Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>
> User can call select/poll system calls with a large number of assigned
> file descriptors and force kernel to allocate up to several pages of memory
> till end of these sleeping system calls. We have here long-living
> unaccounted per-task allocations.
>
> It makes sense to account for these allocations to restrict the host's
> memory consumption from inside the memcg-limited container.
>
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  fs/select.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/select.c b/fs/select.c
> index 945896d..e83e563 100644
> --- a/fs/select.c
> +++ b/fs/select.c
> @@ -655,7 +655,7 @@ int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
>                         goto out_nofds;
>
>                 alloc_size = 6 * size;
> -               bits = kvmalloc(alloc_size, GFP_KERNEL);
> +               bits = kvmalloc(alloc_size, GFP_KERNEL_ACCOUNT);

What about the similar allocation in compat_core_sys_select()? Also
what about the allocation in poll_get_entry()?

>                 if (!bits)
>                         goto out_nofds;
>         }
> @@ -1000,7 +1000,7 @@ static int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds,
>
>                 len = min(todo, POLLFD_PER_PAGE);
>                 walk = walk->next = kmalloc(struct_size(walk, entries, len),
> -                                           GFP_KERNEL);
> +                                           GFP_KERNEL_ACCOUNT);
>                 if (!walk) {
>                         err = -ENOMEM;
>                         goto out_fds;
> --
> 1.8.3.1
>
