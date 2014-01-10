From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Thu, 9 Jan 2014 16:01:15 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com>
References: <20131210103827.GB20242@dhcp22.suse.cz> <alpine.DEB.2.02.1312101655430.22701@chino.kir.corp.google.com> <20131211095549.GA18741@dhcp22.suse.cz> <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com> <20131212103159.GB2630@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com> <20131217162342.GG28991@dhcp22.suse.cz> <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com> <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org> <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=5bhNjbCZ+JKEzbmzOS106s2+4d60/5SvyjyG1OzJNvc=;
        b=J2CTRKrcxB3GGUhzFdc0pO+b0NWoq6iayseC96Nr8E0oKq/qRuIrHxk4iptwNkPzPA
         Ud8KVkapMf/Ti8jwypE8kx43A2WZ1z+J25u+GpHwIOxmxYVbBZ6e+g4Kqgkl7waSwHhU
         tc/6q6Xb7NNecF0HzxOkANoZvxqz3iN4wzHy+ProJb2tbknd2pssoBjDkgitOQAn+u1o
         aAEienxKQHS39SjN+chZU1Q7+2/Io37Vr9RPf10Ica6W3Tp0ZeDAB1tCosBzM6kyfMii
         bGvFIOIheF4c7kOs4FovkNaCcdampN38U/ifCMGJyujDIv8JHdDj6r2A+4J+bXfF4AeY
         CRig==
In-Reply-To: <20140109144757.e95616b4280c049b22743a15@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Thu, 9 Jan 2014, Andrew Morton wrote:

> > I'm not sure why this was dropped since it's vitally needed for any sane 
> > userspace oom handler to be effective.
> 
> It was dropped because the other memcg developers disagreed with it.
> 

It was acked-by Michal.

> I'd really prefer not to have to spend a great amount of time parsing
> argumentative and repetitive emails to make a tie-break decision which
> may well be wrong anyway.
> 
> Please work with the other guys to find an acceptable implementation. 
> There must be *something* we can do?
> 

We REQUIRE this behavior for a sane userspace oom handler implementation.  
You've snipped my email quite extensively, but I'd like to know 
specifically how you would implement a userspace oom handler described by 
Section 10 of Documentation/cgroups/memory.txt without this patch?

Are you suggesting that userspace is supposed to wait for successive 
wakeups over some arbitrarily defined period of time to determine whether 
memory freeing (i.e. a process in the exit() path or with a pending 
SIGKILL making forward progress to free its memory) can be done or whether 
it needs to do something to free memory?  If not, how else is userspace 
supposed to know that it should act?

How do you prevent unnecessary oom killing if the userspace oom handler 
wakes up and kills something concurrent with the process triggering the 
notification getting access to memory reserves, exiting, and freeing its 
memory?  Userspace just killed a process unnecessarily.  This is the exact 
reason why the kernel oom killer doesn't do a damn thing in these 
conditions, because it's NOT ACTIONABLE by the oom killer, a process 
simply needs to exit.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
