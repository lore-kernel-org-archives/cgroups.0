From: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IPC: account for kmem usage on mqueue and msg
Date: Tue, 18 Oct 2016 14:44:11 -0400
Message-ID: <20161018184410.GV10283@redhat.com>
References: <1476806075-1210-1-git-send-email-arozansk@redhat.com>
 <20161018182619.GB27792@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161018182619.GB27792-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stefan Schimanski <sttts-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi Michal,
On Tue, Oct 18, 2016 at 08:26:19PM +0200, Michal Hocko wrote:
> I guess this was because ipv msgqueue shouldn't allow for memory
> consumption runaways. The number of message queues and messages pending
> in them is bounded and not a large amount of memory AFAIR. Anyway I do
> not see anything unreasonable about accounting the memory to the caller.
> 
> Have you noticed this by a code inspection or you have a real world
> usecase where the missing accounting caused some problems? This would be
> a useful information for the changelog.

Stefan noticed this and filled an internal BZ and I saw it with a
test program while comparing with our 3.10 kernel. We haven't hit this
issue in production (AFAIK) but it's a concern while using containers.

Each message is up to 16MB and you can't get too many messages queued.
While it's something that won't allow a container to eat a large portion
of memory, it's significant enough to be accounted for.

-- 
Aristeu
