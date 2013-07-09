From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 09 Jul 2013 18:35:54 +0400
Message-ID: <51DC1FCA.3060904@openvz.org>
References: <20130708100046.14417.12932.stgit@zurg> <20130708170047.GA18600@mtj.dyndns.org> <20130708175201.GB9094@redhat.com> <20130708175607.GB18600@mtj.dyndns.org> <51DBC99F.4030301@openvz.org> <20130709125734.GA2478@htj.dyndns.org> <51DC0CE2.2050906@openvz.org> <20130709131605.GB2478@htj.dyndns.org> <20130709131646.GC2478@htj.dyndns.org> <51DC136E.6020901@openvz.org> <20130709134558.GD2478@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=N4ForFMut+ekygglr1WKbLjKm6nRKZZ/BuXnhqBTNNs=;
        b=C/i1iP5ZF6YUjj80ozJKO+eRIdtFGsvvQwPuvkkbAcADtmWxGMmRLs4r5FFKqq13aZ
         iV7xtnULstD7zIfk5J1NQx9RK8ypd29lWODmtLR+Q7XnfvrDfuohCMK331NpmpaacVvh
         xq3KcBfadR1gLau7L/UWjpC00f7F/yLq4CUOS7C4ewzA0g6rXqm/qdBhGBGNZHEVxU86
         Eo53ijmSWZu47Xhb+bQb7g0JbQbKVW1HcVGp4nGKxxPSC8NY8440KiYFWDkTeAt9CH/w
         BSAdrVbp3J16XCgkJkffBFqlGS0lIjSxYB3778hTo5P7+9YpiRqxPd8ZUIQI5fN7bhIc
         Ph6w==
In-Reply-To: <20130709134558.GD2478-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Tejun Heo wrote:
> On Tue, Jul 09, 2013 at 05:43:10PM +0400, Konstantin Khlebnikov wrote:
>> My concept it cgroup which would control io operation on vfs layer
>> for all filesystems.  It will account and manage IO operations. I've
>> found really lightweight technique for accounting and throttling
>> which don't introduce new locks or priority inversions (which is
>> major problem in all existing throttlers, including cpu cgroup rate
>> limiter) So, I've tried to keep code smaller, cleaner and saner as
>> possible while you guys are trying to push me into the block layer
>> =)
>
> You're trying to implement QoS in the place where you don't have
> control of the queue itself.  You aren't even managing the right type
> of resource for disks which is time slice rather than iops or
> bandwidth and by the time you implemented proper hierarchy support and
> proportional control, yours isn't gonna be that simple either.  The
> root problem is bdi failing to propagate pressure from the actual
> queue upwards.  Fix that.
>

I'm not interested in QoS or proportional control. Let schedulers do it.
I want just bandwidth control. I don't want to write a new scheduler
or extend some of existing one. I want implement simple and lightweight
accounting and add couple of throttlers on top of that.
It can be easily done without violation of that hierarchical design.

The same problem already has happened with cpu scheduler. It has really
complicated rate limiter which is actually useless in the real world because
it triggers all possible priority inversions since it puts bunch of tasks into
deep sleep while some of them may hold kernel locks. Perfect.

QoS and scheduling policy are good thing, but rate-limiting must be separated
and done only in places where it doesn't leads to these problems.
