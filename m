From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Tue, 23 Apr 2013 17:13:20 +0400
Message-ID: <517688F0.7010407@parallels.com>
References: <20130421022321.GE19097@mtj.dyndns.org> <CANN689GuN_5QdgPBjr7h6paVmPeCvLHYfLWNLsJMWib9V9G_Fw@mail.gmail.com> <20130422042445.GA25089@mtj.dyndns.org> <20130422153730.GG18286@dhcp22.suse.cz> <20130422154620.GB12543@htj.dyndns.org> <20130422155454.GH18286@dhcp22.suse.cz> <CANN689Hz5A+iMM3T76-8RCh8YDnoGrYBvtjL_+cXaYRR0OkGRQ@mail.gmail.com> <51765FB2.3070506@parallels.com> <20130423114020.GC8001@dhcp22.suse.cz> <CANN689FaGBi+LmdoSGBf3D9HmLD8Emma1_M3T1dARSD6=75B0w@mail.gmail.com> <20130423130627.GG8001@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130423130627.GG8001-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 04/23/2013 05:06 PM, Michal Hocko wrote:
> On Tue 23-04-13 05:51:36, Michel Lespinasse wrote:
> [...]
>> The issue I see is that even when people configure soft limits B+C <
>> A, your current proposal still doesn't "leave the other alone" as
>> Glauber and I think we should.
> 
> If B+C < A then B resp. C get reclaimed only if A is over the limit
> which means that it couldn't reclaimed enough to get bellow the limit
> when we bang on it before B and C. We can update the implementation
> later to be more clever in situations like this but this is not that
> easy because once we get away from the round robin over the tree then we
> might end up having other issues - like unfairness etc... That's why I
> wanted to have this as simple as possible.
> 
Nobody is opposing this, Michal.

What people are opposing is you saying that the children should be
reclaimed *regardless* of their softlimit when the parent is over their
soft limit. Someone, specially you, saying this, highly threatens
further development in this direction.

It doesn't really matter if your current set is doing this, simply
everybody already agreed that you are moving in a good direction.

If you believe that it is desired to protect the children from reclaim
in situation in which the offender is only one of the children and that
can be easily identified, please state that clearly.

Since nobody is really opposing your patchset, that is enough for the
discussion to settle. (Can't say how others feel, but can say about
myself, and guess about others)
