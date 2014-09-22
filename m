From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/3] sched: add a macro to define bitops for task atomic
 flags
Date: Mon, 22 Sep 2014 13:45:39 +0200
Message-ID: <20140922114539.GC2832@worktop.localdomain>
References: <541F9C96.10705@huawei.com>
 <541F9CD4.5040407@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <541F9CD4.5040407-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>

On Mon, Sep 22, 2014 at 11:51:48AM +0800, Zefan Li wrote:
> This will simplify code when we add new flags.
> 
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  include/linux/sched.h | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4557765..04a2ae2 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1959,15 +1959,17 @@ static inline void memalloc_noio_restore(unsigned int flags)
>  /* Per-process atomic flags. */
>  #define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
>  
> -static inline bool task_no_new_privs(struct task_struct *p)
> -{
> -	return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
> -}
> -
> -static inline void task_set_no_new_privs(struct task_struct *p)
> -{
> -	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
> -}
> +#define TASK_PFA_BITOPS(name, func)				\
> +static inline bool task_##func(struct task_struct *p)		\
> +{ return test_bit(PFA_##name, &p->atomic_flags); }		\
> +								\
> +static inline void task_set_##func(struct task_struct *p)	\
> +{ set_bit(PFA_##name, &p->atomic_flags); }			\
> +								\
> +static inline void task_clear_##func(struct task_struct *p)	\
> +{ clear_bit(PFA_##name, &p->atomic_flags); }
> +
> +TASK_PFA_BITOPS(NO_NEW_PRIVS, no_new_privs)

This could really do with a corresponding script/tags.sh update.

	--regex-c++='TASK_PFA_BITOPS\([^,]*,([^)]*)\)/task_\1/'
	--regex-c++='TASK_PFA_BITOPS\([^,]*,([^)]*)\)/task_set_\1/'
	--regex-c++='TASK_PFA_BITOPS\([^,]*,([^)]*)\)/task_clear_\1/'

For exhuberant and matching bits for emacs.
