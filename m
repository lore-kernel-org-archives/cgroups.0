From: Michal Hocko <mhocko@suse.cz>
Subject: Re: process hangs on do_exit when oom happens
Date: Tue, 23 Oct 2012 12:15:00 +0200
Message-ID: <20121023101500.GE15397@dhcp22.suse.cz>
References: <op.wmbi5kbrn27o5l@gaoqiang-d1.corp.qihoo.net>
 <20121019160425.GA10175@dhcp22.suse.cz>
 <CAKWKT+ZRMHzgCLJ1quGnw-_T1b9OboYKnQdRc2_Z=rdU_PFVtw@mail.gmail.com>
 <CAKTCnzkMQQXRdx=ikydsD9Pm3LuRgf45_=m7ozuFmSZyxazXyA@mail.gmail.com>
 <CAKWKT+bYOf0cEDuiibf6eV2raMxe481y-D+nrBgPWR3R+53zvg@mail.gmail.com>
 <20121023095028.GD15397@dhcp22.suse.cz>
 <CAKWKT+b2s4E7Nne5d0UJwfLGiCXqAUgrCzuuZi6ZPdjszVSmWg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKWKT+b2s4E7Nne5d0UJwfLGiCXqAUgrCzuuZi6ZPdjszVSmWg@mail.gmail.com>
Sender: linux-mmc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Gao <gaoqiangscut@gmail.com>
Cc: Balbir Singh <bsingharora@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Tue 23-10-12 18:10:33, Qiang Gao wrote:
> On Tue, Oct 23, 2012 at 5:50 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Tue 23-10-12 15:18:48, Qiang Gao wrote:
> >> This process was moved to RT-priority queue when global oom-killer
> >> happened to boost the recovery of the system..
> >
> > Who did that? oom killer doesn't boost the priority (scheduling class)
> > AFAIK.
> >
> >> but it wasn't get properily dealt with. I still have no idea why where
> >> the problem is ..
> >
> > Well your configuration says that there is no runtime reserved for the
> > group.
> > Please refer to Documentation/scheduler/sched-rt-group.txt for more
> > information.
> >
[...]
> maybe this is not a upstream-kernel bug. the centos/redhat kernel
> would boost the process to RT prio when the process was selected
> by oom-killer.

This still looks like your cpu controller is misconfigured. Even if the
task is promoted to be realtime.
-- 
Michal Hocko
SUSE Labs
