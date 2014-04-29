From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: Protection against container fork bombs [WAS: Re: memcg with
 kmem limit doesn't recover after disk i/o causes limit to be hit]
Date: Tue, 29 Apr 2014 13:30:39 -0400
Message-ID: <20140429133039.162d9dd7@oracle.com>
References: <20140422200531.GA19334@alpha.arachsys.com>
	<535758A0.5000500@yuhu.biz>
	<20140423084942.560ae837@oracle.com>
	<20140428180025.GC25689@ubuntumail>
	<20140429072515.GB15058@dhcp22.suse.cz>
	<20140429130353.GA27354@ubuntumail>
	<20140429154345.GH15058@dhcp22.suse.cz>
	<CAO_RewYZDGLBAKit4CudTbqVk+zfDRX8kP0W6Zz90xJh7abM9Q@mail.gmail.com>
	<20140429165114.GE6129@localhost.localdomain>
	<CAO_Rewa20dneL8e3T4UPnu2Dkv28KTgFJR9_YSmRBKp-_yqewg@mail.gmail.com>
	<20140429170639.GA25609@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140429170639.GA25609@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: Tim Hockin <thockin@google.com>, Richard Davies <richard@arachsys.com>, Vladimir Davydov <vdavydov@parallels.com>, David Rientjes <rientjes@google.com>, Marian Marinov <mm@yuhu.biz>, Max Kellermann <mk@cm4all.com>, Tim Hockin <thockin@hockin.org>, Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.linux-foundation.org, Serge Hallyn <serge.hallyn@ubuntu.com>, Glauber Costa <glommer@parallels.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, William Dauchy <wdauchy@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Daniel Walsh <dwalsh@redhat.com>

On Tue, 29 Apr 2014 19:06:39 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Tue 29-04-14 09:59:30, Tim Hockin wrote:
> > Here's the reason it doesn't work for us: It doesn't work. 
> 
> There is a "simple" solution for that. Help us to fix it.
> 
> > It was something like 2 YEARS since we first wanted this, and it
> > STILL does not work.
> 
> My recollection is that it was primarily Parallels and Google asking
> for the kmem accounting. The reason why I didn't fight against
> inclusion although the implementation at the time didn't have a
> proper slab shrinking implemented was that that would happen later.
> Well, that later hasn't happened yet and we are slowly getting there.
> 
> > You're postponing a pretty simple request indefinitely in
> > favor of a much more complex feature, which still doesn't really
> > give me what I want. 
> 
> But we cannot simply add a new interface that will have to be
> maintained for ever just because something else that is supposed to
> workaround bugs.
> 
> > What I want is an API that works like rlimit but per-cgroup, rather
> > than per-UID.
> 
> You can use an out-of-tree patchset for the time being or help to get
> kmem into shape. If there are principal reasons why kmem cannot be
> used then you better articulate them.

Is there a plan to separately account/limit stack pages vs kmem in
general? Richard would have to verify, but I suspect kmem is not currently
viable as a process limiter for him because icache/dcache/stack is all
accounted together.

> > On Tue, Apr 29, 2014 at 9:51 AM, Frederic Weisbecker
> > <fweisbec@gmail.com> wrote:
> > > On Tue, Apr 29, 2014 at 09:06:22AM -0700, Tim Hockin wrote:
> > >> Why the insistence that we manage something that REALLY IS a
> > >> first-class concept (hey, it has it's own RLIMIT) as a side
> > >> effect of something that doesn't quite capture what we want to
> > >> achieve?
> > >
> > > It's not a side effect, the kmem task stack control was partly
> > > motivated to solve forkbomb issues in containers.
> > >
> > > Also in general if we can reuse existing features and code to
> > > solve a problem without disturbing side issues, we just do it.
> > >
> > > Now if kmem doesn't solve the issue for you for any reason, or it
> > > does but it brings other problems that aren't fixable in kmem
> > > itself, we can certainly reconsider this cgroup subsystem. But I
> > > haven't yet seen argument of this kind yet.
> > >
> > >>
> > >> Is there some specific technical reason why you think this is a
> > >> bad idea?
> > >> I would think, especially in a more unified hierarchy world,
> > >> that more cgroup controllers with smaller sets of responsibility
> > >> would make for more manageable code (within limits, obviously).
> > >
> > > Because it's core code and it adds complications and overhead in
> > > the fork/exit path. We just don't add new core code just for the
> > > sake of slightly prettier interfaces.
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
