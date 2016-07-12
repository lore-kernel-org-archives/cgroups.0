From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
	process in the same cgroup
Date: Tue, 12 Jul 2016 18:52:16 +0200
Message-ID: <20160712165215.GB4557@redhat.com>
References: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com> <20160711064150.GB5284@dhcp22.suse.cz> <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com> <CABAubTjGhUXMeAnFgW8LGck1tgvtu12Zb9fx5BRhDWNjZ7SYLQ@mail.gmail.com> <20160712071927.GD14586@dhcp22.suse.cz> <CABAubTg91qrUd4DO7T2SiJQBK9ypuhP0+F-091ZxtmonjaaYWg@mail.gmail.com> <57851224.2020902@yandex-team.ru>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <57851224.2020902@yandex-team.ru>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Shayan Pooya <shayan@liveve.org>, Michal Hocko <mhocko@kernel.org>, koct9i@gmail.com, cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

On 07/12, Konstantin Khlebnikov wrote:
>
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2808,8 +2808,9 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
>         balance_callback(rq);
>         preempt_enable();
>
> -       if (current->set_child_tid)
> -               put_user(task_pid_vnr(current), current->set_child_tid);
> +       if (current->set_child_tid &&
> +           put_user(task_pid_vnr(current), current->set_child_tid))
> +               force_sig(SIGSEGV, current);
>  }
>
> Add Oleg into CC. IIRR he had some ideas how to fix this. =)

Heh. OK, OK, thank you Konstantin ;)

I'll try to recall tomorrow, but iirc I only have some ideas of how
we can happily blame the FAULT_FLAG_USER logic.

d, in this particular case, perhaps glibc/set_child_tid too because
(again, iirc) it would nice to simply kill it, it is only used for
some sanity checks...

Oleg.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
