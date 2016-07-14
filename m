From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
 process in the same cgroup
Date: Thu, 14 Jul 2016 15:22:59 +0200
Message-ID: <20160714132258.GA1333@redhat.com>
References: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com>
 <20160711064150.GB5284@dhcp22.suse.cz>
 <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com>
 <CABAubTjGhUXMeAnFgW8LGck1tgvtu12Zb9fx5BRhDWNjZ7SYLQ@mail.gmail.com>
 <20160712071927.GD14586@dhcp22.suse.cz>
 <CABAubTg91qrUd4DO7T2SiJQBK9ypuhP0+F-091ZxtmonjaaYWg@mail.gmail.com>
 <57851224.2020902@yandex-team.ru>
 <CABAubTiVb8j8wEbcr16FAJnBxxS7QzghpPiJUcmV+=Ji=QgL=A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABAubTiVb8j8wEbcr16FAJnBxxS7QzghpPiJUcmV+=Ji=QgL=A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shayan Pooya <shayan@liveve.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Michal Hocko <mhocko@kernel.org>, koct9i@gmail.com, cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

On 07/12, Shayan Pooya wrote:
>
> > Yep. Bug still not fixed in upstream. In our kernel I've plugged it with
> > this:
> >
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -2808,8 +2808,9 @@ asmlinkage __visible void schedule_tail(struct
> > task_struct *prev)
> >         balance_callback(rq);
> >         preempt_enable();
> >
> > -       if (current->set_child_tid)
> > -               put_user(task_pid_vnr(current), current->set_child_tid);
> > +       if (current->set_child_tid &&
> > +           put_user(task_pid_vnr(current), current->set_child_tid))
> > +               force_sig(SIGSEGV, current);
> >  }
>
> I just verified that with your patch there is no hung processes and I
> see processes getting SIGSEGV as expected.

Well, but we can't do this. And "as expected" is actually just wrong. I still
think that the whole FAULT_FLAG_USER logic is not right. This needs another email.

fork() should not fail because there is a memory hog in the same memcg. Worse,
pthread_create() can kill the caller by the same reason. And we have the same
or even worse problem with ->clear_child_tid, pthread_join() can hang forever.
Unlikely we want to kill the application in this case ;)

And in fact I think that the problem has nothing to do with set/claer_child_tid
in particular.

I am just curious... can you reproduce the problem reliably? If yes, can you try
the patch below ? Just in case, this is not the real fix in any case...

Oleg.

--- x/kernel/sched/core.c
+++ x/kernel/sched/core.c
@@ -2793,8 +2793,11 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 	balance_callback(rq);
 	preempt_enable();
 
-	if (current->set_child_tid)
+	if (current->set_child_tid) {
+		mem_cgroup_oom_enable();
 		put_user(task_pid_vnr(current), current->set_child_tid);
+		mem_cgroup_oom_disable();
+	}
 }
 
 /*

