From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 1/1] sched/psi: use kernfs polling functions for PSI
 trigger polling
Date: Thu, 6 Jul 2023 10:16:51 +0200
Message-ID: <20230706081651.GF2833176@hirez.programming.kicks-ass.net>
References: <20230630005612.1014540-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ic9S92rG11eB3Mil6OSX84uIjeGI6KbMJWkDNWokDEY=; b=na4q44nbMfZC7izyi5ajSs6ppq
        bGmiaPfc5VPM0or3kB8A+OGoTRZ98DRuhWkPwu9v+PIv4Nl5Y7fwiSkmzoIYr19nFqpFZpqgweKaM
        TzyDub1JFUHz/W1M4AluZuqG+Ahlzdsy9itfLqsHqSnfFKmz6jzkQdD+ocNiKOr84TKlIRGquRitq
        a/nfcmQFW2VM86l23s2BxHC0p1Ix49+Y7CSgMcqpgH91ENR0Kwrs0NDHq1NKKZFbAwcVlLfvY8/xb
        Bj5iXoVeTwgb4jtHYlz0bpJPun29kzy8VGtAJ6+jOzFeTR7A64MG6OhfhHVT68MUU75SD/5Oqk0C9
        OOa76p+g==;
Content-Disposition: inline
In-Reply-To: <20230630005612.1014540-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Thu, Jun 29, 2023 at 05:56:12PM -0700, Suren Baghdasaryan wrote:
> Destroying psi trigger in cgroup_file_release causes UAF issues when
> a cgroup is removed from under a polling process. This is happening
> because cgroup removal causes a call to cgroup_file_release while the
> actual file is still alive. Destroying the trigger at this point would
> also destroy its waitqueue head and if there is still a polling process
> on that file accessing the waitqueue, it will step on the freed pointer:
> 
> do_select
>   vfs_poll
>                            do_rmdir
>                              cgroup_rmdir
>                                kernfs_drain_open_files
>                                  cgroup_file_release
>                                    cgroup_pressure_release
>                                      psi_trigger_destroy
>                                        wake_up_pollfree(&t->event_wait)
> // vfs_poll is unblocked
>                                        synchronize_rcu
>                                        kfree(t)
>   poll_freewait -> UAF access to the trigger's waitqueue head
> 
> Patch [1] fixed this issue for epoll() case using wake_up_pollfree(),
> however the same issue exists for synchronous poll() case.
> The root cause of this issue is that the lifecycles of the psi trigger's
> waitqueue and of the file associated with the trigger are different. Fix
> this by using kernfs_generic_poll function when polling on cgroup-specific
> psi triggers. It internally uses kernfs_open_node->poll waitqueue head
> with its lifecycle tied to the file's lifecycle. This also renders the
> fix in [1] obsolete, so revert it.
> 
> [1] commit c2dbe32d5db5 ("sched/psi: Fix use-after-free in ep_remove_wait_queue()")
> 
> Fixes: 0e94682b73bf ("psi: introduce psi monitor")
> Reported-by: Lu Jialin <lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Closes: https://lore.kernel.org/all/20230613062306.101831-1-lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Thanks, I'll stuff it in sched/urgent after -rc1.
