From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Thu, 31 Oct 2013 18:33:05 -0700 (PDT)
Message-ID: <alpine.LNX.2.00.1310311822520.3100@eggly.anvils>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de> <5257F7CE.90702@huawei.com> <CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com> <5258E584.70500@huawei.com> <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
 <525CB337.8050105@huawei.com> <CA+SBX_Ogo8HP81o+vrJ8ozSBN6gPwzc8WNOV3Uya=4AYv+CCyQ@mail.gmail.com> <CA+SBX_OJBbYzrNX5Mi4rmM2SANShXMmAvuPGczAyBdx8F2hBDQ@mail.gmail.com> <5270BFE7.4000602@huawei.com> <alpine.LNX.2.00.1310301606080.2333@eggly.anvils>
 <20131031130647.0ff6f2c7@gandalf.local.home> <alpine.LNX.2.00.1310311442030.2633@eggly.anvils> <20131031192732.2dbb14b3@gandalf.local.home>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=3uWSBnCXtEgdRul75QPt7R7sRvUArPPKZ6zl77j5tdY=;
        b=fdzax1RRW/iSKI8SqSA6pmYCQ5dhbw6dDnNbdbEjF87YPCKNYimJQKOZXH4xozmb1T
         PPDtxiIX+qyW5qon0c8P2MWbqURxWtMS84Yy6amxE5NBPN/O5jrhWheycBH+se4zXP1a
         WCLcda88EKCx0dSM3Fz7LbSsuFOlgyytNkHK3MsMTuaQYdSX7XkxfH3Fj0ZHpdunuTG/
         mCQedS4qbtCqJUlnw9UxgYvRu021+4bVPNf6igPO95NWEinooXxOrHzNXumSlhdjjC7G
         2VjXdbFZwrQVkAdzpEiw519zBN/7bkewCAsJwbXROVTo0BpYv3QmgAeINA02DZlOXU6d
         ldSA==
In-Reply-To: <20131031192732.2dbb14b3-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 31 Oct 2013, Steven Rostedt wrote:
> On Thu, 31 Oct 2013 14:46:27 -0700 (PDT)
> Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > On Thu, 31 Oct 2013, Steven Rostedt wrote:
> > > On Wed, 30 Oct 2013 19:09:19 -0700 (PDT)
> > > Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > > 
> > > > This is, at least on the face of it, distinct from the workqueue
> > > > cgroup hang I was outlining to Tejun and Michal and Steve last week:
> > > > that also strikes in mem_cgroup_reparent_charges, but in the
> > > > lru_add_drain_all rather than in mem_cgroup_start_move: the
> > > > drain of pagevecs on all cpus never completes.
> > > > 
> > > 
> > > Did anyone ever run this code with lockdep enabled? There is lockdep
> > > annotation in the workqueue that should catch a lot of this.
> > 
> > I believe I tried before, but I've just rechecked to be sure:
> > lockdep is enabled but silent when we get into that deadlock.
> 
> Interesting.
> 
> Anyway, have you posted a backtrace of the latest lockups you are
> seeing? Or possible crash it and have kdump/kexec save a core?
> 
> I'd like to take a look at this too.

The main backtrace looks like this (on a kernel without lockdep):

kworker/23:108  D ffff880c7fd72b00     0 25969      2 0x00000000
Workqueue: events cgroup_offline_fn
Call Trace:
 [<ffffffff81002e09>] schedule+0x29/0x70
 [<ffffffff8100039c>] schedule_timeout+0x1cc/0x290
 [<ffffffff810c5187>] ? wake_up_process+0x27/0x50
 [<ffffffff81001e08>] wait_for_completion+0x98/0x100
 [<ffffffff810c5120>] ? try_to_wake_up+0x2c0/0x2c0
 [<ffffffff810ad2b9>] flush_work+0x29/0x40
 [<ffffffff810ab8d0>] ? worker_enter_idle+0x160/0x160
 [<ffffffff810af61b>] schedule_on_each_cpu+0xcb/0x110
 [<ffffffff81160735>] lru_add_drain_all+0x15/0x20
 [<ffffffff811a9339>] mem_cgroup_reparent_charges+0x39/0x280
 [<ffffffff811ad23d>] ? hugetlb_cgroup_css_offline+0x9d/0x210
 [<ffffffff811a973f>] mem_cgroup_css_offline+0x5f/0x1e0
 [<ffffffff810fd348>] cgroup_offline_fn+0x78/0x1a0
 [<ffffffff810ae47c>] process_one_work+0x17c/0x410
 [<ffffffff810aeb71>] worker_thread+0x121/0x370
 [<ffffffff810aea50>] ? rescuer_thread+0x300/0x300
 [<ffffffff810b5c60>] kthread+0xc0/0xd0
 [<ffffffff810b5ba0>] ? flush_kthread_worker+0x80/0x80
 [<ffffffff81584c9c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810b5ba0>] ? flush_kthread_worker+0x80/0x80

With lots of kworker/23:Ns looking like this one:

kworker/23:2    D ffff880c7fd72b00     0 21511      2 0x00000000
Workqueue: events cgroup_offline_fn
Call Trace:
 [<ffffffff81002e09>] schedule+0x29/0x70
 [<ffffffff810030ce>] schedule_preempt_disabled+0xe/0x10
 [<ffffffff81001469>] __mutex_lock_slowpath+0x149/0x1d0
 [<ffffffff81000822>] mutex_lock+0x22/0x40
 [<ffffffff810fd30a>] cgroup_offline_fn+0x3a/0x1a0
 [<ffffffff810ae47c>] process_one_work+0x17c/0x410
 [<ffffffff810aeb71>] worker_thread+0x121/0x370
 [<ffffffff810aea50>] ? rescuer_thread+0x300/0x300
 [<ffffffff810b5c60>] kthread+0xc0/0xd0
 [<ffffffff810c005e>] ? finish_task_switch+0x4e/0xe0
 [<ffffffff810b5ba0>] ? flush_kthread_worker+0x80/0x80
 [<ffffffff81584c9c>] ret_from_fork+0x7c/0xb0
 [<ffffffff810b5ba0>] ? flush_kthread_worker+0x80/0x80

We do have kdumps of it, but I've not had time to study those -
nor shall I be sending them out!

Reminder: these hangs are not the same as those Markus is reporting;
perhaps they are related, but I've not grasped such a connection,

Thanks,
Hugh
