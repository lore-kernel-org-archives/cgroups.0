From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
	process in the same cgroup
Date: Mon, 18 Jul 2016 15:53:10 +0200
Message-ID: <20160718135309.GC25380@redhat.com>
References: <20160711064150.GB5284@dhcp22.suse.cz> <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com> <CABAubTjGhUXMeAnFgW8LGck1tgvtu12Zb9fx5BRhDWNjZ7SYLQ@mail.gmail.com> <20160712071927.GD14586@dhcp22.suse.cz> <CABAubTg91qrUd4DO7T2SiJQBK9ypuhP0+F-091ZxtmonjaaYWg@mail.gmail.com> <57851224.2020902@yandex-team.ru> <CABAubTiVb8j8wEbcr16FAJnBxxS7QzghpPiJUcmV+=Ji=QgL=A@mail.gmail.com> <20160714132258.GA1333@redhat.com> <CABAubTh_5aLxaEYYyFivoatJLN35K8Gy1fHKG=8FL8XFrv61Sw@mail.gmail.com> <CABAubTjjD6nmAtMNze5O6-bE-ivMmb24Jd4u2mMpBZFBFR1CnA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CABAubTjjD6nmAtMNze5O6-bE-ivMmb24Jd4u2mMpBZFBFR1CnA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shayan Pooya <shayan-UQzSddOuLosdnm+yROfE0A@public.gmane.org>
Cc: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On 07/15, Shayan Pooya wrote:
>
> >> --- x/kernel/sched/core.c
> >> +++ x/kernel/sched/core.c
> >> @@ -2793,8 +2793,11 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
> >>         balance_callback(rq);
> >>         preempt_enable();
> >>
> >> -       if (current->set_child_tid)
> >> +       if (current->set_child_tid) {
> >> +               mem_cgroup_oom_enable();
> >>                 put_user(task_pid_vnr(current), current->set_child_tid);
> >> +               mem_cgroup_oom_disable();
> >> +       }
> >>  }
> >>
> >>  /*
>
> I tried this patch and I still see the same stuck processes (assuming
> that's what you were curious about).

Of course. Because I am stupid. Firtsly, I forgot to include another
change in fault.c. And now I see that change was wrong anyway.

I'll try to make another debugging patch today later, but let me repeat
that it won't fix the real problem anyway.

Thanks, and sorry for wasting your time.

Oleg.
