From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Date: Wed, 4 Dec 2013 00:45:33 -0500
Message-ID: <20131204054533.GZ3556@cmpxchg.org>
References: <20131119131400.GC20655@dhcp22.suse.cz>
 <20131119134007.GD20655@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311192352070.20752@chino.kir.corp.google.com>
 <20131120152251.GA18809@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311201917520.7167@chino.kir.corp.google.com>
 <20131128115458.GK2761@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312021504170.13465@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=/OZ+3BiQfwiEKX5eLxThyOTTZwgJTSfPQrXZOgf0S1s=;
	b=L9pGF7+TNRq6T4eNa+gqZ3mKouZH8x4633R0M9gpx4HcmPCcPduzjNxqESSQLDFpfkL+Yc5OrXMKSRzftmJMera2LFhv2sc6+XVGT5PFXWpxm03yCNnOINhVKG0gOwLXujrc6kZLEt/ksiivfgZ1Ns8pQtc8f0wHpxNWGaS9CJ8=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Tue, Dec 03, 2013 at 09:20:17PM -0800, David Rientjes wrote:
> Now that a per-process flag is available, define it for processes that
> handle userspace oom notifications.  This is an optimization to avoid
> mantaining a list of such processes attached to a memcg at any given time
> and iterating it at charge time.
> 
> This flag gets set whenever a process has registered for an oom
> notification and is cleared whenever it unregisters.
> 
> When memcg reclaim has failed to free any memory, it is necessary for
> userspace oom handlers to be able to dip into reserves to pagefault text,
> allocate kernel memory to read the "tasks" file, allocate heap, etc.

The task handling the OOM of a memcg can obviously not be part of that
same memcg.

I've said this many times in the past, but here is the most recent
thread from Tejun, me, and Li on this topic:

---

On Tue, 3 Dec 2013 at 15:35:48 +0800, Li Zefan wrote:
> On Mon, 2 Dec 2013 at 11:44:06 -0500, Johannes Weiner wrote:
> > On Fri, Nov 29, 2013 at 03:05:25PM -0500, Tejun Heo wrote:
> > > Whoa, so we support oom handler inside the memcg that it handles?
> > > Does that work reliably?  Changing the above detail in this patch
> > > isn't difficult (and we'll later need to update kernfs too) but
> > > supporting such setup properly would be a *lot* of commitment and I'm
> > > very doubtful we'd be able to achieve that by just carefully avoiding
> > > memory allocation in the operations that usreland oom handler uses -
> > > that set is destined to expand over time, extremely fragile and will
> > > be hellish to maintain.
> > > 
> > > So, I'm not at all excited about commiting to this guarantee.  This
> > > one is an easy one but it looks like the first step onto dizzying
> > > slippery slope.
> > > 
> > > Am I misunderstanding something here?  Are you and Johannes firm on
> > > supporting this?
> >
> > Handling a memcg OOM from userspace running inside that OOM memcg is
> > completely crazy.  I mean, think about this for just two seconds...
> > Really?
> >
> > I get that people are doing it right now, and if you can get away with
> > it for now, good for you.  But you have to be aware how crazy this is
> > and if it breaks you get to keep the pieces and we are not going to
> > accomodate this in the kernel.  Fix your crazy userspace.
> 
> +1

---

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
