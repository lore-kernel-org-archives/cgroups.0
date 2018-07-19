From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v11 7/9] cpuset: Expose cpus.effective and mems.effective
 on cgroup v2 root
Date: Thu, 19 Jul 2018 15:52:24 +0200
Message-ID: <20180719135224.GE2494@hirez.programming.kicks-ass.net>
References: <1529825440-9574-1-git-send-email-longman@redhat.com>
 <1529825440-9574-8-git-send-email-longman@redhat.com>
 <20180702165322.GI533219@devbig577.frc2.facebook.com>
 <bc59aa0a-70fd-583f-452d-9a947757cb69@redhat.com>
 <20180703155823.GS533219@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9y3ZpgYtdHV1f5BZq6DQpPBciG7Ugn3PjPKzl3567fA=; b=WrG0IRrJDAoztD1ygNlKx0ZMy
        H4cajpz3fEjWshpAWul5YTB+vvRw2sl+8Wqp+j/CqSN8K8U9bQ9QnPWQ0AUAKi10+KrRmu2vRDbw7
        sO/4dh2KBbnwmWG3tWPINmKMNG9q9lLF/a2B4TUJXDU+2npeNJ7db91ABeBAioZqGB7kzldpesq9P
        NwT/N7vgtbzyD9cl9C9WuIpzaPvPdoCX2FuS6Hehq10QPf8dcwrfzB8uYauKoJlWfxBwU3op3h1j+
        3Qmgwp7L9cS3OCKzyrvmvWUBKPCN4tUVC064E3G2LOWV2p5tJ4hRSpA9Rb7z2kU//Dfv8l8XUILDi
      
Content-Disposition: inline
In-Reply-To: <20180703155823.GS533219@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

On Tue, Jul 03, 2018 at 08:58:23AM -0700, Tejun Heo wrote:
> Hello, Waiman.
> 
> On Tue, Jul 03, 2018 at 08:41:31AM +0800, Waiman Long wrote:
> > > So, effective changing when enabling partition on a child feels wrong
> > > to me.  It's supposed to contain what's actually allowed to the cgroup
> > > from its parent and that shouldn't change regardless of how those
> > > resources are used.  It's still given to the cgroup from its parent.
> > 
> > Another way to work around this issue is to expose the reserved_cpus in
> > the parent for holding CPUs that can taken by a chid partition. That
> > will require adding one more cpuset file for those cgroups that are
> > partition roots.
> 
> Yeah, that should work.
> 
> > I don't mind restricting that to the first level children for now. That
> > does restrict where we can put the container root if we want a separate
> > partition for a container. Let's hear if others have any objection about
> > that.
> 
> As currently implemented, partioning locks away the cpus which should
> be a system level decision, not container level, so it makes sense to
> me that it is only available to system root.

I'm terribly confused, what?!

Why would a container not be allowed to create partitions for its
various RT workloads?
