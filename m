From: Don Morris <don.morris-VXdhtT5mjnY@public.gmane.org>
Subject: Re: 3.10.16 cgroup css_set_lock deadlock
Date: Fri, 15 Nov 2013 09:53:14 -0500
Message-ID: <5286355A.9060509@hp.com>
References: <20131114232529.GB16725@sbohrermbp13-local.rgmadvisors.com> <20131115081929.GA11530@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131115081929.GA11530-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>

On 11/15/2013 03:19 AM, Tejun Heo wrote:
> On Thu, Nov 14, 2013 at 05:25:29PM -0600, Shawn Bohrer wrote:
>> In trying to reproduce the cgroup_mutex deadlock I reported earlier
>> in https://lkml.org/lkml/2013/11/11/574 I believe I encountered a
>> different issue that I'm also unable to understand. This machine
>> started out reporting some soft lockups that look to me like they are
>> on a read_lock(css_set_lock):
>>
> ...
>> RIP: 0010:[<ffffffff8109253c>]  [<ffffffff8109253c>] cgroup_attach_task+0xdc/0x7a0
> ...
>>  [<ffffffff81092e87>] attach_task_by_pid+0x167/0x1a0
>>  [<ffffffff81092ef3>] cgroup_tasks_write+0x13/0x20

I've been getting this hang intermittently with the numad daemon
running on CentOS/Fedora while running numa balancing tests. Started
around 3.9 or so.

> 
> Most likely the bug fixed by ea84753c98a7 ("cgroup: fix to break the
> while loop in cgroup_attach_task() correctly").  3.10.19 contains the
> backported fix.
> 
> Thanks.
> 

Yes, that definitely looks like the right change -- and I ran
post-3.12-rc6 for over a week without hitting the issue again.
I'm willing to call that verified by since previously I couldn't
go more than 2 days without encountering the bug.

Ok, stupid question time since I stared at that loop several
times while trying to figure out how things got stuck there.
Apologies in advance if I'm just thick today -- but I'd
really like to grok this bug.

Are we getting some other thread from while_each_task()
repeatedly keeping us in the loop? Or is there something
else going on? The gut instinct is that calling something
like while_each_task() on an exiting thread would either
reliably give other threads in the group or quit [if the
thread is the only one left in the group or if an exiting
thread is no longer part of the group], but since that would
make the continue work, obviously I'm missing something.

Mel, I don't know how much time you've given to this since the
last email, but this clears it up. Thanks for your time.

Don Morris
