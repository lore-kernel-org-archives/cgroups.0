From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom notifications
 to access reserves
Date: Wed, 4 Dec 2013 17:49:04 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
References: <20131119131400.GC20655@dhcp22.suse.cz> <20131119134007.GD20655@dhcp22.suse.cz> <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com> <20131120152251.GA18809@dhcp22.suse.cz> <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz> <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com> <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
 <20131204054533.GZ3556@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=jERALgr/AlKzC/YWshfECy/Uz+1wddcRoOrVYEhuNso=;
        b=kaXfdom+CGIxDdVhwkRX89+V93vtdOl2xC6LcX1XAdwL/B8NHuhqlZrJEXztrV20l4
         6uz+PZ3ELIrN7oICYq0+uSrfAsBBYdhDWMV9ZdAri3+WauOGtpxCf0jfDqVs7+iuVWnZ
         Uqm0WhMCzSfDFkFVfUDKkcQEstu12X9wjw3bsuuiKJ3Ze+PFj4uHgOOwyv8CgnWFd01b
         6NIsFWN/L/FWKgdFkLGgAJWZUNI09YrGQYGmccuwBy70agBtUuKY/aoSA669PmYlKhZj
         wG3ABqqkEBLTsKkuXxh4ulwOk92whHXFwfzQNi7kZwL5ns4Ye8NL4UP1vxOMxkomHmUk
         SRyQ==
In-Reply-To: <20131204054533.GZ3556@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Wed, 4 Dec 2013, Johannes Weiner wrote:

> > Now that a per-process flag is available, define it for processes that
> > handle userspace oom notifications.  This is an optimization to avoid
> > mantaining a list of such processes attached to a memcg at any given time
> > and iterating it at charge time.
> > 
> > This flag gets set whenever a process has registered for an oom
> > notification and is cleared whenever it unregisters.
> > 
> > When memcg reclaim has failed to free any memory, it is necessary for
> > userspace oom handlers to be able to dip into reserves to pagefault text,
> > allocate kernel memory to read the "tasks" file, allocate heap, etc.
> 
> The task handling the OOM of a memcg can obviously not be part of that
> same memcg.
> 

Not without memory.oom_reserve_in_bytes that this series adds, that's 
true.  Michal expressed interest in the idea of memcg oom reserves in the 
past, so I thought I'd share the series.

> On Tue, 3 Dec 2013 at 15:35:48 +0800, Li Zefan wrote:
> > On Mon, 2 Dec 2013 at 11:44:06 -0500, Johannes Weiner wrote:
> > > On Fri, Nov 29, 2013 at 03:05:25PM -0500, Tejun Heo wrote:
> > > > Whoa, so we support oom handler inside the memcg that it handles?
> > > > Does that work reliably?  Changing the above detail in this patch
> > > > isn't difficult (and we'll later need to update kernfs too) but
> > > > supporting such setup properly would be a *lot* of commitment and I'm
> > > > very doubtful we'd be able to achieve that by just carefully avoiding
> > > > memory allocation in the operations that usreland oom handler uses -
> > > > that set is destined to expand over time, extremely fragile and will
> > > > be hellish to maintain.
> > > > 

It works reliably with this patch series, yes.  I'm not sure what change 
this is referring to that would avoid memory allocation for userspace oom 
handlers, and I'd agree that it would be difficult to maintain a 
no-allocation policy for a subset of processes that are destined to handle 
oom handlers.

That's not what this series is addressing, though, and in fact it's quite 
the opposite.  It acknowledges that userspace oom handlers need to 
allocate and that anything else would be too difficult to maintain 
(thereby agreeing with the above), so we must set aside memory that they 
are exclusively allowed to access.  For the vast majority of users who 
will not use userspace oom handlers, they can just use the default value 
of memory.oom_reserve_in_bytes == 0 and they incur absolutely no side-
effects as a result of this series.

For those who do use userspace oom handlers, like Google, this allows us 
to set aside memory to allow the userspace oom handlers to kill a process, 
dump the heap, send a signal, drop caches, etc. when waking up.

> > > > So, I'm not at all excited about commiting to this guarantee.  This
> > > > one is an easy one but it looks like the first step onto dizzying
> > > > slippery slope.
> > > > 
> > > > Am I misunderstanding something here?  Are you and Johannes firm on
> > > > supporting this?
> > >
> > > Handling a memcg OOM from userspace running inside that OOM memcg is
> > > completely crazy.  I mean, think about this for just two seconds...
> > > Really?
> > >
> > > I get that people are doing it right now, and if you can get away with
> > > it for now, good for you.  But you have to be aware how crazy this is
> > > and if it breaks you get to keep the pieces and we are not going to
> > > accomodate this in the kernel.  Fix your crazy userspace.
> > 

The rest of this email communicates only one thing: someone thinks it's 
crazy.  And I agree it would be crazy if we don't allow that class of 
process to have access to a pre-defined amount of memory to handle the 
situation, which this series adds.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
