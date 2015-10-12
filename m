From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/14] cgroup: add cgroup_subsys->free() method and use it
 to fix pids controller
Date: Mon, 12 Oct 2015 21:29:14 +1100
Message-ID: <CAOviyaj_xi1h0m1Os6FjR4DTY-qs049eGauJUL6nhbfeaaZk8w@mail.gmail.com>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
	<1444570210-15640-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444570210-15640-4-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

> pids controller is completely broken in that it uncharges when a task
> exits allowing zombies to escape resource control.  With the recent
> updates, cgroup core now maintains cgroup association till task free
> and pids controller can be fixed by uncharging on free instead of
> exit.

Looks good to me. Out of interest, is there any reason why we still
have ->exit(), given the zombie process edge case? Surely the zombie
process edge case would cause issues with kmemcg and similar
controllers, if they use ->exit() and not ->free()?

-- 
Aleksa Sarai (cyphar)
www.cyphar.com
