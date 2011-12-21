From: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: Q: cgroup: Questions about possible issues in cgroup locking
Date: Wed, 21 Dec 2011 11:01:02 -0800
Message-ID: <20111221190102.GE13529@google.com>
References: <20111221034334.GD17668@somewhere>
 <20111221130848.GA19679@redhat.com>
 <20111221175632.GF17668@somewhere>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        bh=sqBKfk2vu5cehicM5p1M60H7ADimA7YAzpkOEhinN5A=;
        b=qB2Nqja+r0s0Y1sk4vbt/uE0GWer+LHPjofMMekrSUQZXA/WplESO3BXzNW1bOw9u1
         s9pJyIISBSbRlC4JemyQ==
Content-Disposition: inline
In-Reply-To: <20111221175632.GF17668@somewhere>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Frederic Weisbecker (fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org) wrote:
> On Wed, Dec 21, 2011 at 02:08:48PM +0100, Oleg Nesterov wrote:
> > On 12/21, Frederic Weisbecker wrote:
> > > Hi,
> > >
> > > Starring at some parts of cgroups, I have a few questions:
> > >
> > > - Is cgroup_enable_task_cg_list()'s while_each_thread() safe
> > > against concurrent exec()? The leader may change in de_thread()
> > > and invalidate the test done in while_each_thread().
> > 
> > Yes. Oh, we need to do something with while_each_thread.
> 
> Would something like this work?
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index c0c5876..e002a00 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2293,8 +2293,12 @@ extern bool current_is_single_threaded(void);
>  #define do_each_thread(g, t) \
>  	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
>  
> -#define while_each_thread(g, t) \
> -	while ((t = next_thread(t)) != g)
> +#define while_each_thread(g, t)					\
> +	while (({						\
> +		struct task_struct *__prev = t;			\
> +		t = next_thread(t);				\
> +		t != __prev && t != g;				\

Hi,

Don't you still have an (highly unlikely) race if you exec
and then pthread_create()?

Instead of:

t != __prev && t != g;

How about:

t != t->group_leader;

Regards,
Mandeep

> +	}))
>  
>  static inline int get_nr_threads(struct task_struct *tsk)
>  {
