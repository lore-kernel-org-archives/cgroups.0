From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Tue, 16 Apr 2013 19:17:17 +0800
Message-ID: <516D333D.4040703@huawei.com>
References: <20130406012159.GA17159@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130406012159.GA17159-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/4/6 9:21, Tejun Heo wrote:
> Hello, guys.
> 
>  Status-quo
>  ==========
> 
> It's been about a year since I wrote up a summary on cgroup status quo
> and future plans.  We're not there yet but much closer than we were
> before.  At least the locking and object life-time management aren't
> crazy anymore and most controllers now support proper hierarchy
> although not all of them agree on how to treat inheritance.
> 
> IIRC, the yet-to-be-converted ones are blk-throttle and perf.  cpu
> needs to be updated so that it at least supports a similar mechanism
> as cfq-iosched for configuring ratio between tasks on an internal
> cgroup and its children.  Also, we really should update how cpuset
> handles a cgroup becoming empty (no cpus or memory node left due to
> hot-unplug).  It currently transfers all its tasks to the nearest
> ancestor with executing resources, which is an irreversible process
> which would affect all other co-mounted controllers.  We probably want
> it to just take on the masks of the ancestor until its own executing
> resources become online again, and the new behavior should be gated
> behind a switch (Li, can you please look into this?).
> 

Sure, I'll be working on sane hierarchy behavior for cpuset.
