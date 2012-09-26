From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 22:56:09 +0400
Message-ID: <50634FC9.4090609@parallels.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-5-git-send-email-glommer@parallels.com> <20120926140347.GD15801@dhcp22.suse.cz> <20120926163648.GO16296@google.com> <50633D24.6020002@parallels.com> <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com> <50634105.8060302@parallels.com> <20120926180124.GA12544@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120926180124.GA12544-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 09/26/2012 10:01 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Sep 26, 2012 at 09:53:09PM +0400, Glauber Costa wrote:
>> I understand your trauma about over flexibility, and you know I share of
>> it. But I don't think there is any need to cap it here. Given kmem
>> accounted is perfectly hierarchical, and there seem to be plenty of
>> people who only care about user memory, I see no reason to disallow a
>> mixed use case here.
>>
>> I must say that for my particular use case, enabling it unconditionally
>> would just work, so it is not that what I have in mind.
> 
> So, I'm not gonna go as far as pushing for enabling it unconditionally
> but would really like to hear why it's necessary to make it per node
> instead of one global switch.  Maybe it has already been discussed to
> hell and back.  Care to summarize / point me to it?
> 

For me, it is the other way around: it makes perfect sense to have a
per-subtree selection of features where it doesn't hurt us, provided it
is hierarchical. For the mere fact that not every application is
interested in this (Michal is the one that is being so far more vocal
about this not being needed in some use cases), and it is perfectly
valid to imagine such applications would coexist.

So given the flexibility it brings, the real question is, as I said,
backwards: what is it necessary to make it a global switch ?
