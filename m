From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Sun, 12 Jan 2014 14:10:49 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com> <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com> <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org> <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org>
 <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com> <20140110221432.GD6963@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=IDdKsIQYcXoO9R0maTxonCcftDAVnGT3+UsrA0Tcc4Q=;
        b=Xo6KPMmiyWf8bSn8600upOugq7wHovKXxIKsjF+ZzLFmrCZGHFpD9H6xKjPcEuMWQI
         elGOfugKHDRy6fCzzY/0EmdCdOKdWFTDFjiP1immqshtJjG6T2gVMdbd1lvgm908ld/0
         p9ZRETYlUQYhSJlNKzvcufTTX0uF5W8DubrfL+JRAuR5+joJCty2+LGqeSgsg8IM53Lw
         cUFUO0/i3HdMFKZE/1r6jUoasoNsyam5A7EFtpMvnlaXFAHVci1uZtqniNp6HzmqbsAH
         Wr/QcvvC33DNAI3+yT1zXqSVyXLPGOPVvMYTPf0OSJcke9V3s4sJfzsY+F0B52UvnK85
         XOYg==
In-Reply-To: <20140110221432.GD6963@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Fri, 10 Jan 2014, Johannes Weiner wrote:

> > > > It was acked-by Michal.
> 
> Michal acked it before we had most of the discussions and now he is
> proposing an alternate version of yours, a patch that you are even
> discussing with him concurrently in another thread.  To claim he is
> still backing your patch because of that initial ack is disingenuous.
> 

His patch depends on mine, Johannes.

> > Johannes is arguing for the same semantics that VMPRESSURE_CRITICAL and/or 
> > memory thresholds provides, which disagrees from the list of solutions 
> > that Documentation/cgroups/memory.txt gives for userspace oom handler 
> > wakeups and is required for any sane implementation.
> 
> No, he's not and I'm sick of you repeating refuted garbage like this.
> 
> You have convinced neither me nor Michal that your problem is entirely
> real and when confronted with doubt you just repeat the same points
> over and over.
> 

The conditional to check if current needs access to memory reserves to 
make forward progress and avoid oom killing anything else is done after 
the memcg notification.  It's real per section 6.8.4 of the C99 standard 
which defines how a conditional works.  We do not want a userspace 
notification in such a case because userspace testing of whether the 
condition is actionable would be unreliable.  This is not dead code, it 
does get executed.

> The one aspect of your change that we DO agree is valid is now fixed
> by Michal in a separate attempt because you could not be bothered to
> incorporate feedback into your patch.
> 

I suggested his patch, Johannes, but his patch depends on mine.  I'm 
hoping he can rebase his patch and it's done and merged into -mm before 
the merge window for 3.14 as I've stated.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
