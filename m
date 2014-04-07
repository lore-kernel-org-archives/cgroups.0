From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 0/8] cpusets: Isolate CPUs via sysfs using cpusets
Date: Mon, 07 Apr 2014 07:04:50 +0200
Message-ID: <1396847090.5218.9.camel@marge.simpson.net>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
	 <1396773020.11763.17.camel@marge.simpson.net>
	 <CAKohpomW3jpQEqFxD3m_br8GchJyq9-KSxW2x7JLCRqDgf4SAg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:content-transfer-encoding:mime-version;
        bh=VVgVgLcD08llijWRiwp4eIl4RsbVvewi0UykIRNtWgo=;
        b=Hig9129GLVwRUJi+9kX87d5Vqjm357aWjQ4IG/r9hOuGzk6H/viJsQBKaPa51vhgl1
         +wDr1zMe3kCIF4wQBXsJLzbu+8LPlBzV+ifnWCby6q6i6/qmfCcLWYfzhFYK+L97C3ea
         DnjSBySGrYJD8TsXnbBbQhRv649doFqTlebGU75gvhqSsZkuipTVlLprzdbuyYr81kt2
         af4qgrD17T2Wu8aCwpSxnLL9waD4JlSsu379zrBLLqAPDIW9vnz247OjjtOTfRPzT67F
         o9ErJ7xCzcKbQnHnp8xBxmtbGWvY0yQxZGlMoXjXN4pH9In7HkN64l2CTvD8vEeQUMBG
         HJqQ==
In-Reply-To: <CAKohpomW3jpQEqFxD3m_br8GchJyq9-KSxW2x7JLCRqDgf4SAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Lists linaro-kernel <linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org>, Linaro Networking <linaro-networking-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arvind Chauhan <Arvind.Chauhan-5wv7dgnIgG8@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, 2014-04-07 at 09:41 +0530, Viresh Kumar wrote: 
> Hi Mike,
> 
> On 6 April 2014 14:00, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > I wonder if adding a quiesce switch is really necessary.
> >
> > Seems to me that if you don't have load balancing turned off, you can't
> > be very concerned about perturbation, so this should be tied into the
> > load balancing on/off switch as an extension to isolating cores from the
> > #1 perturbation source, the scheduler.
> 
> Its more about not doing any background activities on these CPU which can
> be avoided. So, even if a add_timer() is issued from these isolated CPUs, it
> should goto the set chosen for doing background activity, unless add_timer_on()
> has been issued, in which case user wants that code to execute on the
> isolated core.
> 
> Probably, yes, people would be disabling load_balancing between these
> cpusets to avoid migration of tasks to isolated core as well.. Atleast we
> are using it :)

Yes, that's the whole point I'm trying to make.  If you do not have
cores isolated, there's no point to quiesce, as timers and whatnot are
the least of your worries.  Conversely, why would you bother isolating
cores if you didn't want a nice quiet environment.  Seems to me full
isolation ala killing sched domains implies that your goal is bare
metal.. or as close as you can get to that anyway.

> > I also didn't notice a check for is_cpu_exclusive() at a glance, which
> > would be a bug, but one that would go away if this additional isolation
> > were coupled to the existing isolation switch.
> 
> Yeah, there is no check for that. But I didn't got your point completely.
> Why do I need to check for exclusivity on the isolated CPUs? So, that
> same CPU isn't isolated as well as non-isolated on two separate sets?

Yes, both on and off is kinda hard to do per cpu :)

-Mike
