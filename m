From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Wed, 15 Feb 2023 15:07:05 -0400
Message-ID: <Y+0tWZxMUx/NZ3Ne@nvidia.com>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
 <Y+Fttp1ozejoSQzl@slm.duckdns.org>
 <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
 <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
 <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <Y+GMbWWP/YhtJQqe@slm.duckdns.org>
 <Y+GQB9I6MFN6BOFw@nvidia.com>
 <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
 <Y+0rxoM4w9nilUMZ@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iPKtvv9wejlbWeYQwKPPsnqj4kXcryjfYKfl+hr2pg=;
 b=AmsVkfhLYYqH0rvpSbGV2zJ5uqU4MpYSdczJPgEHFtlhXeXwl6xHLMilcN52vZjKAB7b3xmBoRkBmYCx/UybeiBqHgc5+2WWiKKmjBA+Mh3JNDzLD2ZNjA2NA1fTTfEzuXT6G4NKqbqO0UChIQ7w0TdFa0sZng4IaWFhwTT6xltCvgZMZK069V4LB+GTg6YQvVexwfozbrwMxJJoDzUqs2cexoJUQ5aljLbkfXNW/LXqu6NDAIRziq4j2v+ddPRF2JU3BLzS8eTEGkB7kZf9hlwMeTxx6mluMwVzcAPysje3TDEgoHf02xMoQ9crJJNEDN5urvDJjwoHk0Z9Yhy1xA==
Content-Disposition: inline
In-Reply-To: <Y+0rxoM4w9nilUMZ-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed, Feb 15, 2023 at 08:00:22PM +0100, Michal Hocko wrote:
> On Mon 06-02-23 14:32:37, Tejun Heo wrote:
> > Hello,
> > 
> > On Mon, Feb 06, 2023 at 07:40:55PM -0400, Jason Gunthorpe wrote:
> > > (a) kind of destroys the point of this as a sandboxing tool
> > > 
> > > It is not so harmful to use memory that someone else has been charged
> > > with allocating.
> > > 
> > > But it is harmful to pin memory if someone else is charged for the
> > > pin. It means it is unpredictable how much memory a sandbox can
> > > actually lock down.
> > > 
> > > Plus we have the double accounting problem, if 1000 processes in
> > > different cgroups open the tmpfs and all pin the memory then cgroup A
> > > will be charged 1000x for the memory and hit its limit, possibly
> > > creating a DOS from less priv to more priv
> > 
> > Let's hear what memcg people think about it. I'm not a fan of disassociating
> > the ownership and locker of the same page but it is true that actively
> > increasing locked consumption on a remote cgroup is awkward too.
> 
> One thing that is not really clear to me is whether those pins do
> actually have any "ownership".

In most cases the ownship traces back to a file descriptor. When the
file is closed the pin goes away.

> The interface itself doesn't talk about
> anything like that and so it seems perfectly fine to unpin from a
> completely different context then pinning. 

Yes, concievably the close of the FD can be in a totally different
process with a different cgroup.

> If there is no enforcement then Tejun is right and relying on memcg
> ownership is likely the only reliable way to use for tracking. The
> downside is sharing obviously but this is the same problem we
> already do deal with with shared pages.

I think this does not work well because the owner in a memcg sense is
unrelated to the file descriptor which is the true owner.

So we can get cases where the pin is charged to the wrong cgroup which
is effectively fatal for sandboxing, IMHO.

> Another thing that is not really clear to me is how the limit is
> actually going to be used in practice. As there is no concept of a
> reclaim for pins then I can imagine that it would be quite easy to
> reach the hard limit and essentially DoS any further use of pins. 

Yes, that is the purpose. It is to sandbox pin users to put some limit
on the effect they have on the full machine.

It replaces the rlimit mess that was doing the same thing.

> Cross cgroup pinning would make it even worse because it could
> become a DoS vector very easily. Practically speaking what tends to
> be a corner case in the memcg limit world would be norm for pin
> based limit.

This is why the cgroup charged for the pin must be tightly linked to
some cgroup that is obviously connected to the creator of the FD
owning the pin.

Jason
