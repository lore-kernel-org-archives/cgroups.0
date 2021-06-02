From: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/6] sched,timer: Use __set_current_state()
Date: Wed, 2 Jun 2021 16:06:09 +0100
Message-ID: <20210602150609.GD31179@willie-the-truck>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.524487671@infradead.org>
Mime-Version: 1.0
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622646382;
        bh=BP0oFnLplpQzbCvalvHpB7NqrdywR5DFEAfyxB1g9Jw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jt/JfwEGGlSy3hTqeZO3M/TRZGRYdN+uS6BuUDgGWYc5+7OM1jehc/I9GyTKk2giU
         x8Fz6MywEP2GyftaSPZuTT4frUE4LJJFTbKNlFpWaV8FNSJBHs39bu4E9I4SLfLcqO
         HMHRVnWqIqa56gxBT11Ofr79h6KJWIenXTFIjgotpx1WoRwxUuESzepF3f2J82onWW
         6KmGn6d5Bc6iSjd3ikJm06ctf56Aqa5WONxHcW0SvlYtFWsSxXD7djl+hbn3SCVIAR
         qZZg4puE8ocBtV+bfRn446ajL6ZLJwoZfD6XNzRQcxu8UqCMnHwciVTCXlxPOmPFq8
         KdRM+B30YEPFA==
Content-Disposition: inline
In-Reply-To: <20210602133040.524487671-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <t>

On Wed, Jun 02, 2021 at 03:12:30PM +0200, Peter Zijlstra wrote:
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> ---
>  kernel/time/timer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -1879,7 +1879,7 @@ signed long __sched schedule_timeout(sig
>  			printk(KERN_ERR "schedule_timeout: wrong timeout "
>  				"value %lx\n", timeout);
>  			dump_stack();
> -			current->state = TASK_RUNNING;
> +			__set_current_state(TASK_RUNNING);

Acked-by: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Will
