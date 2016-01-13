From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: memcontrol: cgroup2 memory statistics
Date: Wed, 13 Jan 2016 14:49:16 -0800
Message-ID: <20160113144916.03f03766e201b6b04a8a47cc@linux-foundation.org>
References: <1452722469-24704-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452722469-24704-1-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, 13 Jan 2016 17:01:07 -0500 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> Hi Andrew,
> 
> these patches add basic memory statistics so that new users of cgroup2
> have some inkling of what's going on, and are not just confronted with
> a single number of bytes used.
> 
> This is very short-notice, but also straight-forward. It would be cool
> to get this in along with the lifting of the cgroup2 devel flag.
> 
> Michal, Vladimir, what do you think? We'll also have to figure out how
> we're going to represent and break down the "kmem" consumers.
> 

It would be nice to see example output, and a description of why this
output was chosen: what was included, what was omitted, why it was
presented this way, what units were chosen for displaying the stats and
why.  Will the things which are being displayed still be relevant (or
even available) 10 years from now.  etcetera.

And the interface should be documented at some point.  Doing it now
will help with the review of the proposed interface.

Because this stuff is forever and we have to get it right.
