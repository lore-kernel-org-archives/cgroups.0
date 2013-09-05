From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 0/7] improve memcg oom killer robustness v2
Date: Thu, 5 Sep 2013 13:17:42 +0200
Message-ID: <20130905111742.GC9702@dhcp22.suse.cz>
References: <20130830215852.3E5D3D66@pobox.sk>
 <20130902123802.5B8E8CB1@pobox.sk>
 <20130903204850.GA1412@cmpxchg.org>
 <20130904114523.A9F0173C@pobox.sk>
 <20130904115741.GA28285@dhcp22.suse.cz>
 <20130904141000.0F910EFA@pobox.sk>
 <20130904122632.GB28285@dhcp22.suse.cz>
 <20130905111430.CB1392B4@pobox.sk>
 <20130905095331.GA9702@dhcp22.suse.cz>
 <20130905121700.546B5881@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130905121700.546B5881-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 05-09-13 12:17:00, azurIt wrote:
> >[...]
> >> My script detected another freezed cgroup today, sending stacks. Is
> >> there anything interesting?
> >
> >3 tasks are sleeping and waiting for somebody to take an action to
> >resolve memcg OOM. The memcg oom killer is enabled for that group?  If
> >yes, which task has been selected to be killed? You can find that in oom
> >report in dmesg.
> >
> >I can see a way how this might happen. If the killed task happened to
> >allocate a memory while it is exiting then it would get to the oom
> >condition again without freeing any memory so nobody waiting on the
> >memcg_oom_waitq gets woken. We have a report like that: 
> >https://lkml.org/lkml/2013/7/31/94
> >
> >The issue got silent in the meantime so it is time to wake it up.
> >It would be definitely good to see what happened in your case though.
> >If any of the bellow tasks was the oom victim then it is very probable
> >this is the same issue.
> 
> Here it is:
> http://watchdog.sk/lkml/kern5.log

$ grep "Killed process \<103[168]\>" kern5.log
$

So none of the sleeping tasks has been killed previously.

> Processes were killed by my script

OK, I am really confused now. The log contains a lot of in-kernel memcg
oom killer messages:
$ grep "Memory cgroup out of memory:" kern5.log | wc -l
809

This suggests that the oom killer is not disabled. What exactly has you
script done?

> at about 11:05:35.

There is an oom killer striking at 11:05:35:
Sep  5 11:05:35 server02 kernel: [1751856.433101] Task in /1066/uid killed as a result of limit of /1066
[...]
Sep  5 11:05:35 server02 kernel: [1751856.539356] [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
Sep  5 11:05:35 server02 kernel: [1751856.539745] [ 1046]  1066  1046   228537    95491   3       0             0 apache2
Sep  5 11:05:35 server02 kernel: [1751856.539894] [ 1047]  1066  1047   228604    95488   6       0             0 apache2
Sep  5 11:05:35 server02 kernel: [1751856.540043] [ 1050]  1066  1050   228470    95452   5       0             0 apache2
Sep  5 11:05:35 server02 kernel: [1751856.540191] [ 1051]  1066  1051   228592    95521   6       0             0 apache2
Sep  5 11:05:35 server02 kernel: [1751856.540340] [ 1052]  1066  1052   228594    95546   5       0             0 apache2
Sep  5 11:05:35 server02 kernel: [1751856.540489] [ 1054]  1066  1054   228470    95453   5       0             0 apache2
Sep  5 11:05:35 server02 kernel: [1751856.540646] Memory cgroup out of memory: Kill process 1046 (apache2) score 1000 or sacrifice child

And this doesn't list any of the tasks sleeping and waiting for oom
resolving so they must have been created after this OOM. Is this the
same group?
-- 
Michal Hocko
SUSE Labs
