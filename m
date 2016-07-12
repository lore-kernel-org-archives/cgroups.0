From: Shayan Pooya <shayan@liveve.org>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
 process in the same cgroup
Date: Tue, 12 Jul 2016 15:57:50 -0700
Message-ID: <CABAubTiVb8j8wEbcr16FAJnBxxS7QzghpPiJUcmV+=Ji=QgL=A@mail.gmail.com>
References: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com>
 <20160711064150.GB5284@dhcp22.suse.cz> <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com>
 <CABAubTjGhUXMeAnFgW8LGck1tgvtu12Zb9fx5BRhDWNjZ7SYLQ@mail.gmail.com>
 <20160712071927.GD14586@dhcp22.suse.cz> <CABAubTg91qrUd4DO7T2SiJQBK9ypuhP0+F-091ZxtmonjaaYWg@mail.gmail.com>
 <57851224.2020902@yandex-team.ru>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=liveve-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=bhGOE4fXXiwTg/UdhTgfRqjUrqIhRjgDFxiVUxy/sKo=;
        b=nPTcnNBv14hR/3I6vvcwyeIkxmetRVJtSjvRnKPWHBHRnGIpsLthj6ySZ33k6PMWwJ
         fC/d4OvIYqqts1cBDLpbbrB0cqWWVNo7s+ikrW4KV2RkUU2NjQ9oLgTdndDOH7mfinKM
         ZDXtCLoCQVx+QFvPTWefxBGbMcxAKi32RfnryYw37YQIJx1BwYzGMgA/tCFiS0H41P3n
         AX32P8xZmIPHD6MykvhhmVi6dQpT2GxQo6rB/nZXHJKfvh3mJQ0cZiqxmQ4VX0gLMgW6
         pCYJfCQZeoJXv/mx5PB5qPezjqSAQH9XDNpCigrk222W7PFc+wmfNArKj8PXYPH1XMGk
         DyOg==
In-Reply-To: <57851224.2020902@yandex-team.ru>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>, koct9i@gmail.com, cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Oleg Nesterov <oleg@redhat.com>

> Yep. Bug still not fixed in upstream. In our kernel I've plugged it with
> this:
>
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2808,8 +2808,9 @@ asmlinkage __visible void schedule_tail(struct
> task_struct *prev)
>         balance_callback(rq);
>         preempt_enable();
>
> -       if (current->set_child_tid)
> -               put_user(task_pid_vnr(current), current->set_child_tid);
> +       if (current->set_child_tid &&
> +           put_user(task_pid_vnr(current), current->set_child_tid))
> +               force_sig(SIGSEGV, current);
>  }

I just verified that with your patch there is no hung processes and I
see processes getting SIGSEGV as expected.
Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
