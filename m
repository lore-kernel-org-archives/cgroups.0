From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm: reduce spinlock contention in release_pages()
Date: Mon, 29 Nov 2021 13:23:19 +0000
Message-ID: <YaTUR9WcGoOG4oLo@casper.infradead.org>
References: <CA+PpKPmy-u_BxYMCQOFyz78t2+3uM6nR9mQeX+MPyH6H2tOOHA@mail.gmail.com>
 <YZ8DZHERun6Fej2P@casper.infradead.org>
 <20211125080238.GA7356@haolee.io>
 <YZ9e3pzHKmn5nev0@dhcp22.suse.cz>
 <20211125123133.GA7758@haolee.io>
 <YZ+bI1fNpKar0bSU@dhcp22.suse.cz>
 <CA+PpKP=hsuBmvv09OcD2Nct8B8Cqa03UfKFHAHzKxwE0SXGP4g@mail.gmail.com>
 <YaC7BcTSijFj+bxR@dhcp22.suse.cz>
 <20211126162623.GA10277@haolee.io>
 <YaSRtKwTCOj7JnR6@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XI+jJ4HE08vbr6cxNFwgDtnF+jXYceTPv2Cm+tg2N8U=; b=UoWSBUO0XIjErdM3Fo/kNlF2Of
        uR18Lpy94jYibhxqaRhcSl/ei022kwwzCkJQKD5zzFRQcosn/gIzXX7pC27HyZNcmpaTN2NqfLS+Q
        o26jheWS88Hu60Ibp73mem4N+F+4q3YURYA+xXfTL9j7dS/jzSXux+1JlVfHfGQjbhxbqGunYpKFZ
        x9Z0wUUtrBjfx+nbhFXvA+LKj5vfnxJ3RaSa8Bhg9dhdomEIRi+6d0N/YnFugrOCqdvciS0ETPmjh
        w5KsGNDoCSLzV94HaH5i/eUQoirZrmbPk5u4nGZS6NYMZF+16pIAYD+vx5mOk1vSZPiuTCAKlN07n
        VNem1r3w==;
Content-Disposition: inline
In-Reply-To: <YaSRtKwTCOj7JnR6-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Nov 29, 2021 at 09:39:16AM +0100, Michal Hocko wrote:
> On Fri 26-11-21 16:26:23, Hao Lee wrote:
> [...]
> > I will try Matthew's idea to use semaphore or mutex to limit the number of BE
> > jobs that are in the exiting path. This sounds like a feasible approach for
> > our scenario...
> 
> I am not really sure this is something that would be acceptable. Your
> problem is resource partitioning. Papering that over by a lock is not
> the right way to go. Besides that you will likely hit a hard question on
> how many tasks to allow to run concurrently. Whatever the value some
> workload will very likely going to suffer. We cannot assume admin to
> chose the right value because there is no clear answer for that. Not to
> mention other potential problems - e.g. even more priority inversions
> etc.

I don't see how we get priority inversions.  These tasks are exiting; at
the point they take the semaphore, they should not be holding any locks.
They're holding a resource (memory) that needs to be released, but a
task wanting to acquire memory must already be prepared to sleep.

I see this as being a thundering herd problem.  We have dozens, maybe
hundreds of tasks all trying to free their memory at once.  If we force
the herd to go through a narrow gap, they arrive at the spinlock in an
orderly manner.
