From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Wed, 17 Apr 2013 09:29:32 +0800
Message-ID: <516DFAFC.1030101@huawei.com>
References: <20130406012159.GA17159@mtj.dyndns.org> <516D333D.4040703@huawei.com> <20130416171056.GA2874@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130416171056.GA2874-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/4/17 1:10, Tejun Heo wrote:
> Hello, Li.
> 
> On Tue, Apr 16, 2013 at 07:17:17PM +0800, Li Zefan wrote:
> ...
>>> hot-unplug).  It currently transfers all its tasks to the nearest
>>> ancestor with executing resources, which is an irreversible process
>>> which would affect all other co-mounted controllers.  We probably want
>>> it to just take on the masks of the ancestor until its own executing
>>> resources become online again, and the new behavior should be gated
>>> behind a switch (Li, can you please look into this?).
>>>
>>
>> Sure, I'll be working on sane hierarchy behavior for cpuset.
> 
> Great, it'd be great if you can share how it's gonna be done once the
> basic design gets settled before full implementation.
> 

The basic idea is, when a cpuset becomes empty due to hotplug, we don't
move the tasks in it, but instead we update tasks' cpumask/nodemask using
the nearest non-empty acestor cpuset's cpus_allowed and mems_allowed.

- then it's allowed to move those tasks from the empty cpuset to another
cpuset

- when this acestor cpuset's cpumask/nodemask is changed (either by writing
cpuset.cpus/mems or hotplug), not only the tasks in it but also tasks in
the empty cpuset will be updated.

- it's allowed to move a task to an empty cpuset, and the task's cpumask/nodemask
will be updated according to the nearst non-empty acestor, no matter if this
empty cpuset is exclusive or not.

- if a previously offlined cpu becomes online again, the emtpy cpuset won't
get this cpu resource automatically, which is the current behavior.

How does this sound?
