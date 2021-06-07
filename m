From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 6/6] sched: Change task_struct::state
Date: Mon, 7 Jun 2021 13:10:49 +0200
Message-ID: <YL3+ucpG/LOcO35G@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.587042016@infradead.org>
 <20210607104500.sopvslejuoxwzhrs@maple.lan>
Mime-Version: 1.0
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NLj4NYDQW6SbenCIcbS9QrwkO4aohp/HPEuCGPuaREs=; b=cPnEKquwt970ZOfmptV8ZPqMgA
        nDKIN3sS9ih9nuu8IzgPQnkE+3vwyvAnDc2ZrMU9wmERzTb3IGMYGi4WE6+4lUgqF2JtL/lM/I5kJ
        eiHF9IMB2d+Y9lTFFFVOwPJJI9S76oa/nkFLOGjGCPqHZTpDXHEuTaeqYbLfHC8bQodhRsFoh+Qy8
        dTHV3vTaUZfqdQXrfYxuM6d63mJeyrNKoQ2Zm8n4XPuwlvYtbjKQlZwLanaf8FCczQxwMbK2aY9KZ
        5ZBbcHBMtWS/MR3PhHmCJk3dhHVW0UT+bEq4donFnJVNzTVZUBUUF9jUBREUKuzW6aCVhr/V5xCxL
        LVjMXPEw==;
Content-Disposition: inline
In-Reply-To: <20210607104500.sopvslejuoxwzhrs-DWWWtol72k3/PtFMR13I2A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Felipe Balbi <balbi-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Tejun Heo <t>

On Mon, Jun 07, 2021 at 11:45:00AM +0100, Daniel Thompson wrote:
> On Wed, Jun 02, 2021 at 03:12:31PM +0200, Peter Zijlstra wrote:
> > Change the type and name of task_struct::state. Drop the volatile and
> > shrink it to an 'unsigned int'. Rename it in order to find all uses
> > such that we can use READ_ONCE/WRITE_ONCE as appropriate.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > ---
> >  ...
> >  kernel/debug/kdb/kdb_support.c |   18 +++++++------
> >  ...
> > --- a/kernel/debug/kdb/kdb_support.c
> > +++ b/kernel/debug/kdb/kdb_support.c
> > @@ -609,23 +609,25 @@ unsigned long kdb_task_state_string(cons
> >   */
> >  char kdb_task_state_char (const struct task_struct *p)
> >  {
> > -	int cpu;
> > -	char state;
> > +	unsigned int p_state;
> >  	unsigned long tmp;
> > +	char state;
> > +	int cpu;
> >  
> >  	if (!p ||
> >  	    copy_from_kernel_nofault(&tmp, (char *)p, sizeof(unsigned long)))
> >  		return 'E';
> >  
> >  	cpu = kdb_process_cpu(p);
> > -	state = (p->state == 0) ? 'R' :
> > -		(p->state < 0) ? 'U' :
> > -		(p->state & TASK_UNINTERRUPTIBLE) ? 'D' :
> > -		(p->state & TASK_STOPPED) ? 'T' :
> > -		(p->state & TASK_TRACED) ? 'C' :
> > +	p_state = READ_ONCE(p->__state);
> > +	state = (p_state == 0) ? 'R' :
> > +		(p_state < 0) ? 'U' :
> 
> Looks like the U here stands for Unreachable since this patch makes it
> more obvious that this clause is (and previously was) exactly that!
> 
> Dropping the U state would be good since I guess this will show up as a
> "new" warning in some tools. However it was a preexisting problem so with
> or without this cleaned up:
> Acked-by: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Thanks!

Note that there's a second instance of this exact code in
arch/powerpc/xmon/xmon.c, with the same 'U' issue.

I'll repost this soon, as it seems I've fixed all robot failout (fingers
crossed).
