From: Daniel Thompson <daniel.thompson@linaro.org>
Subject: Re: [PATCH 6/6] sched: Change task_struct::state
Date: Mon, 7 Jun 2021 11:45:00 +0100
Message-ID: <20210607104500.sopvslejuoxwzhrs@maple.lan>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.587042016@infradead.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aqlB3nweefXMBd+1n3TfVg5Imk7mqG7GGko5Cn1Ypjk=;
        b=fokBrG+2G1fkq/XmZlW8Qn8gNsGVee/kxIBq16SYHHcihUEHhxAiLiYioDzjZCKPWV
         9QEZOxcXx7fkFSqzCPab9ejYwiSWHFrBFKIvS4T83XVPbmSdXZpWw/7QLttpVgGupn7M
         FoWs2xbakjWUMbWyKY9toPvBiRJY2NSMoomhdLwJgft1TVJGXI1KGV/tNqHpK+0t4K/c
         ssThtjIQ5Gd6U2Vgt07NOm/v5UajEDZu6QDpCKD4dz0UaryRPm6OwVwk+zBYdDwhZepP
         9jCgvqxA0rUhD0TtVGl/Sk+NMb0qRwm6JS3LOkQ+swNNoK5wt0XeTzNUgGulkw29L99w
         ZQaw==
Content-Disposition: inline
In-Reply-To: <20210602133040.587042016@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Felipe Balbi <balbi@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Tejun Heo <t>

On Wed, Jun 02, 2021 at 03:12:31PM +0200, Peter Zijlstra wrote:
> Change the type and name of task_struct::state. Drop the volatile and
> shrink it to an 'unsigned int'. Rename it in order to find all uses
> such that we can use READ_ONCE/WRITE_ONCE as appropriate.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> ---
>  ...
>  kernel/debug/kdb/kdb_support.c |   18 +++++++------
>  ...
> --- a/kernel/debug/kdb/kdb_support.c
> +++ b/kernel/debug/kdb/kdb_support.c
> @@ -609,23 +609,25 @@ unsigned long kdb_task_state_string(cons
>   */
>  char kdb_task_state_char (const struct task_struct *p)
>  {
> -	int cpu;
> -	char state;
> +	unsigned int p_state;
>  	unsigned long tmp;
> +	char state;
> +	int cpu;
>  
>  	if (!p ||
>  	    copy_from_kernel_nofault(&tmp, (char *)p, sizeof(unsigned long)))
>  		return 'E';
>  
>  	cpu = kdb_process_cpu(p);
> -	state = (p->state == 0) ? 'R' :
> -		(p->state < 0) ? 'U' :
> -		(p->state & TASK_UNINTERRUPTIBLE) ? 'D' :
> -		(p->state & TASK_STOPPED) ? 'T' :
> -		(p->state & TASK_TRACED) ? 'C' :
> +	p_state = READ_ONCE(p->__state);
> +	state = (p_state == 0) ? 'R' :
> +		(p_state < 0) ? 'U' :

Looks like the U here stands for Unreachable since this patch makes it
more obvious that this clause is (and previously was) exactly that!

Dropping the U state would be good since I guess this will show up as a
"new" warning in some tools. However it was a preexisting problem so with
or without this cleaned up:
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>


Daniel.

> +		(p_state & TASK_UNINTERRUPTIBLE) ? 'D' :
> +		(p_state & TASK_STOPPED) ? 'T' :
> +		(p_state & TASK_TRACED) ? 'C' :
>  		(p->exit_state & EXIT_ZOMBIE) ? 'Z' :
>  		(p->exit_state & EXIT_DEAD) ? 'E' :
> -		(p->state & TASK_INTERRUPTIBLE) ? 'S' : '?';
> +		(p_state & TASK_INTERRUPTIBLE) ? 'S' : '?';
>  	if (is_idle_task(p)) {
>  		/* Idle task.  Is it really idle, apart from the kdb
>  		 * interrupt? */
