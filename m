From: Kevin Hilman <khilman-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 2/4] timer: don't migrate pinned timers
Date: Mon, 31 Mar 2014 08:56:26 -0700
Message-ID: <7htxae5plh.fsf@paris.lan>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
	<cover.1395322529.git.viresh.kumar@linaro.org>
	<3fa0ea3a19a51ae2797a25e281763451ad8d2844.1395322529.git.viresh.kumar@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3fa0ea3a19a51ae2797a25e281763451ad8d2844.1395322529.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
	(Viresh Kumar's message of "Thu, 20 Mar 2014 19:18:59 +0530")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:

> migrate_timer() is called when a CPU goes down and its timers are required to be
> migrated to some other CPU. Its the responsibility of the users of the timer to
> remove it before control reaches to migrate_timers().
>
> As these were the pinned timers, the best we can do is: don't migrate these and
> report to the user as well.
>
> That's all this patch does.
>
> Signed-off-by: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  kernel/timer.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/kernel/timer.c b/kernel/timer.c
> index fec4ab4..a7f8b99 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1606,11 +1606,22 @@ static int init_timers_cpu(int cpu)
>  static void migrate_timer_list(struct tvec_base *new_base, struct list_head *head)
>  {
>  	struct timer_list *timer;
> +	int is_pinned;
>  
>  	while (!list_empty(head)) {
>  		timer = list_first_entry(head, struct timer_list, entry);
>  		/* We ignore the accounting on the dying cpu */
>  		detach_timer(timer, false);
> +
> +		is_pinned = tbase_get_pinned(timer->base);
> +
> +		/* Check if CPU still has pinned timers */
> +		if (is_pinned) {
> +			pr_warn("%s: can't migrate pinned timer: %p, removing it\n",
> +					__func__, timer);

printk message will be confusing: removing it from what? 

Kevin


> +			continue;
> +		}
> +
>  		timer_set_base(timer, new_base);
>  		internal_add_timer(new_base, timer);
>  	}
