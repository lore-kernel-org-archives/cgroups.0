From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 2/3] sched: add a macro to define bitops for task
 atomic flags
Date: Mon, 22 Sep 2014 23:37:17 -0700
Message-ID: <CAGXu5jJKNJ=PsTtkPaoMyCNf2fK07szP-hv4NdaiDVx4tHacQw@mail.gmail.com>
References: <54210D3F.2090409@huawei.com>
	<54210D7B.8030103@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=vOa6xm5mnYQl1HnT9VraaK17a7F8kEqTLpjNlVLnH28=;
        b=kMsSzXiCDtQU37Jo9FUTwwdWTrGOBwds7KB5LTGWNJZUlk1XYUob2GiPXgaB7ro23V
         oqFUUjd3W0JWNhUmZbqsskL0OYcHCpvNJ03ARxhsyXmVrGH9bM2MLZK24vVUnwXakZlH
         bM6eG1Kv6/ffCLwlCAE/kyA4y02bsQ2WB+dR/Qi4rw1MI/POPpTTrAbUta8MU5tc6NOY
         Pqa2MIb1a7iGWJhvJd+mLGCyQFoq11uISBLF7XAZ3y1xNMSqDjth1zIYixAPqXa34e9m
         4IxQyHE7GR4nIg82TFKqV6PBi3jT786LiEqktF4GfkGv2LHxRYN/FrfBeOlVC45EY8mj
         KbsQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=vOa6xm5mnYQl1HnT9VraaK17a7F8kEqTLpjNlVLnH28=;
        b=CIkxGtkAMG+fkXgCVUJLTg3vAOkx654W4KMvV0zyi9PQK/gPGRVrvr+csm+ChOEKxn
         HWzue1tr+w+p2tGBd0CGQIvfmYYUEmnDTN10M2RXW29oEWgUmSR+sOFpuGLQN4nXqotg
         BWsbs+SGwxXhbpGJz01zlLjJRb1RLTaseRTGU=
In-Reply-To: <54210D7B.8030103-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Sep 22, 2014 at 11:04 PM, Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> This will simplify code when we add new flags.
>
> v2:
> - updated scripts/tags.sh, suggested by Peter
>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Miao Xie <miaox-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Cc: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/sched.h | 20 +++++++++++---------
>  scripts/tags.sh       |  6 ++++++
>  2 files changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4557765..04a2ae2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1959,15 +1959,17 @@ static inline void memalloc_noio_restore(unsigned int flags)
>  /* Per-process atomic flags. */
>  #define PFA_NO_NEW_PRIVS 0     /* May not gain new privileges. */
>
> -static inline bool task_no_new_privs(struct task_struct *p)
> -{
> -       return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
> -}
> -
> -static inline void task_set_no_new_privs(struct task_struct *p)
> -{
> -       set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
> -}
> +#define TASK_PFA_BITOPS(name, func)                            \
> +static inline bool task_##func(struct task_struct *p)          \
> +{ return test_bit(PFA_##name, &p->atomic_flags); }             \
> +                                                               \
> +static inline void task_set_##func(struct task_struct *p)      \
> +{ set_bit(PFA_##name, &p->atomic_flags); }                     \
> +                                                               \
> +static inline void task_clear_##func(struct task_struct *p)    \
> +{ clear_bit(PFA_##name, &p->atomic_flags); }
> +
> +TASK_PFA_BITOPS(NO_NEW_PRIVS, no_new_privs)

One thing I don't like about this is that task_clear_no_new_privs()
ends up getting defined, and it should absolutely never be used. NNP
should never be cleared or there could be security issues. I realize
this isn't a very useful nit-pick, but I'd rather the function wasn't
even available for someone to accidentally use. Maybe break up the
macro with some kind of "write only" version like:

#define TASK_PFA_BITOPS_WO(name, func)                            \
static inline bool task_##func(struct task_struct *p)          \
{ return test_bit(PFA_##name, &p->atomic_flags); }             \
static inline void task_set_##func(struct task_struct *p)      \
{ set_bit(PFA_##name, &p->atomic_flags); }

#define TASK_PFA_BITOPS(name, func)                            \
TASK_PFA_BITOPS_WO(name, func);          \
static inline void task_clear_##func(struct task_struct *p)    \
{ clear_bit(PFA_##name, &p->atomic_flags); }

TASK_PFA_BITOPS_WO(NO_NEW_PRIVS, no_new_privs)

And then all the new users can use TASK_PFA_BITOPS() normally since
they expect to use "clear"?

-Kees

>
>  /*
>   * task->jobctl flags
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index cbfd269..8591b57 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -197,6 +197,9 @@ exuberant()
>         --regex-c++='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'          \
>         --regex-c++='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'      \
>         --regex-c++='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
> +       --regex-c++='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_\1/'     \
> +       --regex-c++='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_set_\1/' \
> +       --regex-c++='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_clear_\1/'  \
>         --regex-c='/PCI_OP_READ\((\w*).*[1-4]\)/pci_bus_read_config_\1/' \
>         --regex-c='/PCI_OP_WRITE\((\w*).*[1-4]\)/pci_bus_write_config_\1/' \
>         --regex-c='/DEFINE_(MUTEX|SEMAPHORE|SPINLOCK)\((\w*)/\2/v/'     \
> @@ -260,6 +263,9 @@ emacs()
>         --regex='/SETPCGFLAG\(([^,)]*).*/SetPageCgroup\1/'      \
>         --regex='/CLEARPCGFLAG\(([^,)]*).*/ClearPageCgroup\1/'  \
>         --regex='/TESTCLEARPCGFLAG\(([^,)]*).*/TestClearPageCgroup\1/' \
> +       --regex='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_\1/' \
> +       --regex='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_set_\1/'     \
> +       --regex='/TASK_PFA_BITOPS\([^,]*,\s*([^)]*)\)/task_clear_\1/'   \
>         --regex='/_PE(\([^,)]*\).*/PEVENT_ERRNO__\1/'           \
>         --regex='/PCI_OP_READ(\([a-z]*[a-z]\).*[1-4])/pci_bus_read_config_\1/' \
>         --regex='/PCI_OP_WRITE(\([a-z]*[a-z]\).*[1-4])/pci_bus_write_config_\1/'\
> --
> 1.8.0.2
>



-- 
Kees Cook
Chrome OS Security
