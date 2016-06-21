From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: Add pids controller event when fork fails
 because of pid limit
Date: Wed, 22 Jun 2016 02:07:09 +1000
Message-ID: <CAOviyaic6iwon=OavFhR21fYA30ND7nQwAyQ9xFQ5U=0q6Rk+g@mail.gmail.com>
References: <20160621044429.GA19501@cmpxchg.org> <1466524894-3303517-1-git-send-email-kennyyu@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cyphar-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=q6ZTTkp/VC8z5rL15zh4YuB7ysLkZ2jXmX7TjCT9sKM=;
        b=E8L4NUmXmMhG5d/gGHfDERYDqOAAbpRW3baUEnIGaIzjlsTVYyRb8rVlx77s0cIG6z
         zT0dqcsI8GJE1Iyr9K4zZuy8JLcqX2VkTG6gPSCPYvJA9bUBiis+TADz5Ut8Cgg6jhTd
         ThiawBp8nS3Cz8WPFxGk03Mlb+H42qQQBQa3Svisq/UCRprl8y5ptTa3lLuN+uYPzaNQ
         /fsi6A8qwB5kfA8o3edtsMvcyEkYT5NqObew0wMNjcpAlxThjrtOT6ge9dmKxrr4fd7T
         WiTztl/HSTlOVqj7XF5oTBXGlsNWnDcYaQAk22bx8WTWO1jQv4o/BKQiTPgS5K69XbEB
         E8Sw==
In-Reply-To: <1466524894-3303517-1-git-send-email-kennyyu-b10kYP2dOMg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kenny Yu <kennyyu-b10kYP2dOMg@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

> @@ -213,10 +227,21 @@ static int pids_can_fork(struct task_struct *task)
>  {
>         struct cgroup_subsys_state *css;
>         struct pids_cgroup *pids;
> +       int err;
>
>         css = task_css_check(current, pids_cgrp_id, true);
>         pids = css_pids(css);
> -       return pids_try_charge(pids, 1);
> +       err = pids_try_charge(pids, 1);
> +       if (err) {
> +               atomic64_inc(&pids->events_limit);
> +               cgroup_file_notify(&pids->events_file);
> +               if (!atomic_xchg(&pids->events_limit_logged, 1)) {
> +                       pr_info("cgroup: fork rejected by pids controller in ");
> +                       pr_cont_cgroup_path(task_cgroup(current, pids_cgrp_id));
> +                       pr_cont("\n");
> +               }
> +       }
> +       return err;
>  }

Why are we logging this? Isn't the pids.events file enough
information? I feel like you could remove a lot of logic if you don't
log this.

And even if we do end up logging it, why have the boolean flag (the
counter always increases, just log if the counter is currently 0 and
you're incrementing it).

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
