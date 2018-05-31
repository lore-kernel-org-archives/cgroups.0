From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cpuset: Enforce that a child's cpus must be a subset of
 the parent
Date: Thu, 31 May 2018 18:38:26 +0200
Message-ID: <20180531163826.GO12180@hirez.programming.kicks-ass.net>
References: <1527687991-1431-1-git-send-email-longman@redhat.com>
 <5B0F4F09.9050100@huawei.com>
 <5B0FAE72.1090204@huawei.com>
 <20180531082613.GF12180@hirez.programming.kicks-ass.net>
 <5B0FB58C.9030705@huawei.com>
 <4dc718bc-4bd5-4998-853b-9c6ba67b89a0@redhat.com>
 <20180531155807.GU1351649@devbig577.frc2.facebook.com>
 <20180531161645.GN12180@hirez.programming.kicks-ass.net>
 <20180531161942.GW1351649@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4rK4IzXCiPVSROPJKAT+5rH4BeY0bOW4blMqoXnQbuc=; b=nMuWzVE4wnl5a6kjxd2/7Duzj
        QWnd8TCfhKaVdIxkGeykVz12bVapDyM17O4Bm13UjK5meBFEy/I3sbEhxDnOdfBx+XrmKBfDIaJbG
        zYdcFOwLfi49C5cr86FwBbM0yEyaq4EtjXjTSnDhTCt56zcmjlfNVuCzBBd+VBE8rbHQHua9D27XZ
        k3hLSjsOyl8aHeaOhu/eqT1lV4FsP90JNbL0z+ivGrEtGzcBSiQcKVaXh03iEUhcLbgJpaOa5A3Ws
        xE7A3a46mEwqk7RdrCqQz3pY/S5lOenjFwdMaAW4kVW5akLpRoO67YZ864j5w+6xX8lsZh3B1wGhg
    
Content-Disposition: inline
In-Reply-To: <20180531161942.GW1351649@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Zefan Li <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Thu, May 31, 2018 at 09:19:42AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, May 31, 2018 at 06:16:45PM +0200, Peter Zijlstra wrote:
> > > So, let's please stay away from it even if that means a bit of
> > > overhead in terms of interface.
> > 
> > Urgh, that again :/
> 
> Yeah, well, it's pretty important.
> 
> > I'm still not convinced by your arguments though. The root container can
> > access all the sub-groups anyway and can grub around in them to take
> > away resources if it really wants to.
> 
> That's really messy and if you delegated away a subtree, you can't
> walk the subtree in a race free way, not easily anyway.

Messy perhaps, but taking away resources you gave out earlier isn't
particularly nice either way around.

Not sure the races matter, if you win, the delegate can't undo it, if
you loose, you try again until you win.

It's not like cgroup stuff gets changed often, so a conflict causing you
to loose should be very rare indeed.

> > For cpuset in particular randomly restricting on the ancestor level can
> > create an unrecoverable trainwreck inside a container. Affinities are
> > not recoverable. Once a runnable task ends up with an empty set, its
> > affinities are reset and the smaller (empty) set is lost.
> 
> Yeah, for cpuset, it's messier, but it isn't different from hotunplug
> scenario, right?  I think the best we can do there is putting ancestor
> operation on an equal footing as hotplug ops.

Right, but hotplug is exceedingly rare, while I get the impression you
think it is perfectly fine to recind on your resource grants.
