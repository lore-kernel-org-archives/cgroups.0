From: Qais Yousef <qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] sched/cpuset: Keep track of SCHED_DEADLINE tasks
 in cpusets
Date: Wed, 15 Mar 2023 19:25:44 +0000
Message-ID: <20230315192544.44ufekpbebs2ysub@airbuntu>
References: <20230315121812.206079-1-juri.lelli@redhat.com>
 <20230315121812.206079-3-juri.lelli@redhat.com>
 <20230315144927.624cbwc3yep3fwor@airbuntu>
 <ZBH+AaJV36y/HNXk@localhost.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678908347;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zDY1niEs3y45VnBldMysocOzffvLzvPaTI8pzH+DNnY=;
        b=oTI0TkVK0nNqU/zoKTrAJNGzJsgn3Ec3xL6T/YTI/OGOYUwiXI+Zea7W9JQ37PN9mK
         Fri6RhTmi800wCaByug5NppNgFk3745pN3yCoAJbr9MVc5doFqgVAye9nBAB8Tjq2yFT
         ikfxJfmqWJyBZtZjurB6GVbT4S50M7mLzR6f/IVy6nuQHLL+EkYjtwjPRLF7LIy7EU6b
         ehnzJCmvkIv4w1SifZk28nmcRa/qfYHSJl8bRG7IzM2S9Qxx0PCN5ipkC2vY4TUHWRlm
         1S/NnH0cBrf95jL1XpbM+hJ+t9gnX1p8zdtqBbmsos9x+wXJxB7ajX2m7v6y7CWhXGl3
         aBrg==
Content-Disposition: inline
In-Reply-To: <ZBH+AaJV36y/HNXk-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org, tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Wei Wang <wvw-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rick Yiu <rickyiu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Quentin Perret <qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <hca-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Vasily Gorbik <gor-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Alexander Gordeev <agordeev-tEXmvtCZX7AyHOaXKfS9Lw@public.gmane.org>

On 03/15/23 17:18, Juri Lelli wrote:
> On 15/03/23 14:49, Qais Yousef wrote:
> > On 03/15/23 12:18, Juri Lelli wrote:
> 
> ...
> 
> > > +void inc_dl_tasks_cs(struct task_struct *p)
> > > +{
> > > +	struct cpuset *cs = task_cs(p);
> > 
> > nit:
> > 
> > I *think* task_cs() assumes rcu_read_lock() is held, right?
> > 
> > Would it make sense to WARN_ON(!rcu_read_lock_held()) to at least
> > annotate the deps?
> 
> Think we have that check in task_css_set_check()?

Yes you're right, I didn't go forward enough in the call stack.

It seems to depend on PROVE_RCU, which sounds irrelevant, but I see PROVE_RCU
is actually an alias for PROVE_LOCKING.


Cheers
