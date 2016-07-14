From: Shayan Pooya <shayan@liveve.org>
Subject: Re: bug in memcg oom-killer results in a hung syscall in another
 process in the same cgroup
Date: Thu, 14 Jul 2016 08:35:25 -0700
Message-ID: <CABAubTh_5aLxaEYYyFivoatJLN35K8Gy1fHKG=8FL8XFrv61Sw@mail.gmail.com>
References: <CABAubThf6gbi243BqYgoCjqRW36sXJuJ6e_8zAqzkYRiu0GVtQ@mail.gmail.com>
 <20160711064150.GB5284@dhcp22.suse.cz> <CABAubThHfngHTQW_AEuW71VCvLyD_9b5Z05tSud5bf8JKjuA9Q@mail.gmail.com>
 <CABAubTjGhUXMeAnFgW8LGck1tgvtu12Zb9fx5BRhDWNjZ7SYLQ@mail.gmail.com>
 <20160712071927.GD14586@dhcp22.suse.cz> <CABAubTg91qrUd4DO7T2SiJQBK9ypuhP0+F-091ZxtmonjaaYWg@mail.gmail.com>
 <57851224.2020902@yandex-team.ru> <CABAubTiVb8j8wEbcr16FAJnBxxS7QzghpPiJUcmV+=Ji=QgL=A@mail.gmail.com>
 <20160714132258.GA1333@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=liveve-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=eT1ZEFkCpYB87IWc7HNd7gvyt/v2T/QhAR00871Sw1w=;
        b=TliFuDRpu0r3NUcmKBi10hO2UCRCGkI1LhlbNIrwVrkWZmNigAxaRw+h7MdE15NSr3
         XW8hVOI/5za3PwEg3+HHvy+6+kgQ0uY4hNsKHUXw7PQk9Byg5KTGOJAWm0e+vUfJxjrH
         jnsOR9lCYYmlAa9P1gsgs/twwDHj6lpUnVysLIUTOJdHB2psaDbtrm2f4XaU2S0FJSjs
         ZDWdkfdhzZkEFpVYM6yNGurBpQxTDZLgfzP23KqTM4xoeTNfZHJOPjy/TFEzCa+Kj0ke
         Fe//kc/Wzjsz5RtinQEfmRwlnWNqnXZiFQXcauAHHpwLHp7a80hS6+aLAEbxuYZ8QlPz
         D8Yg==
In-Reply-To: <20160714132258.GA1333@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Michal Hocko <mhocko@kernel.org>, Konstantin Khlebnikov <koct9i@gmail.com>, cgroups mailinglist <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org

> Well, but we can't do this. And "as expected" is actually just wrong. I still
> think that the whole FAULT_FLAG_USER logic is not right. This needs another email.

I meant as expected from the content of the patch :) I think
Konstantin agrees that this patch cannot be merged upstream.

> fork() should not fail because there is a memory hog in the same memcg. Worse,
> pthread_create() can kill the caller by the same reason. And we have the same
> or even worse problem with ->clear_child_tid, pthread_join() can hang forever.
> Unlikely we want to kill the application in this case ;)
>
> And in fact I think that the problem has nothing to do with set/claer_child_tid
> in particular.
>
> I am just curious... can you reproduce the problem reliably? If yes, can you try
> the patch below ? Just in case, this is not the real fix in any case...

Yes. It deterministically results in hung processes in vanilla kernel.
I'll try this patch.


> --- x/kernel/sched/core.c
> +++ x/kernel/sched/core.c
> @@ -2793,8 +2793,11 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
>         balance_callback(rq);
>         preempt_enable();
>
> -       if (current->set_child_tid)
> +       if (current->set_child_tid) {
> +               mem_cgroup_oom_enable();
>                 put_user(task_pid_vnr(current), current->set_child_tid);
> +               mem_cgroup_oom_disable();
> +       }
>  }
>
>  /*
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
