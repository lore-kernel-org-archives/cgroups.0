From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] memcg: Do not hang on OOM when killed by userspace OOM
 access to memory reserves
Date: Mon, 20 Jan 2014 22:13:21 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401202158411.21729@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com> <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org> <20140108103319.GF27937@dhcp22.suse.cz> <20140109143048.GE27538@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401091335450.31538@chino.kir.corp.google.com> <20140110082302.GD9437@dhcp22.suse.cz> <alpine.DEB.2.02.1401101327430.21486@chino.kir.corp.google.com> <20140115142603.GM8782@dhcp22.suse.cz> <alpine.DEB.2.02.1401151304430.10727@chino.kir.corp.google.com>
 <20140116101214.GD28157@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=QaaKb13h9cr6Z9afyoCTcgtkdgT7QCUiIPFCDelY0i4=;
        b=QMKRPO1JtMAB7XFYPYhdIehse/XSFFLk35U6GnNWKz6jGIPUX1XM4lLq0z765jKhzH
         Aj6cMmIYZ7FH0lB29RNt8d6GnJCHcz+OrS2CMLxxReqJlR5QC2hI9IpAO/d8+ZUjbxqc
         qy4TNC4f9yXAlVzbMDfqop/t4Pv471RgTbGP6skGg0yudT/whY0CFEH48Ipnpn/RmCxN
         wOyOnPrps3BhfAbUJYHaspyqh1AFuNFO6gOupHCICJEADaAqlGi+dxUR3BippEpPwhcu
         VB59uSVdEZbVDCXJSlaoOSQEU6dgkaOXZNLap/mrY9MCa/iSUWVGjueCBqnxa+N4enHh
         KJXA==
In-Reply-To: <20140116101214.GD28157@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Thu, 16 Jan 2014, Michal Hocko wrote:

> > The heuristic may have existed for ages, but the proposed memcg 
> > configuration for preserving memory such that userspace oom handlers may 
> > run such as
> > 
> > 			 _____root______
> > 			/		\
> > 		    user		 oom
> > 		   /	\		/   \
> > 		   A	B	 	a   b
> > 
> > where user/memory.limit_in_bytes == [amount of present RAM] + 
> > oom/memory.limit_in_bytes - [some fudge] causes all bypasses to be 
> > problematic, including Johannes' buggy bypass for charges in memcgs with 
> > pending memcgs that has since been fixed after I identified it.  This 
> > bypass is included.  Processes attached to "a" and "b" are userspace oom 
> > handlers for processes attached to "A" and "B", respectively.
> > 
> > The amount of memory you're talking about is proportional to the number of 
> > processes that have pending SIGKILLs (and now those with PF_EXITING set), 
> > the former of which is obviously more concerning since they could be 
> > charging memory at any point in the kernel that would succeed. 
> 
> I understand your concerns. Yes, excessive charges might be dangerous. I
> haven't dismissed that when you mentioned it earlier. I am just
> repeatedly asking how much memory are we talking about, how real is the
> issue and what are all the other conseqeunces. And for some reason you
> are not providing that information (or maybe I am just not seeing that
> in your responses) and that is why we are stuck in circle.
> 

Wtf are you talking about?  You're adding a bypass in this patch and then 
you're asking me to go and see how much memory it could potentially bypass 
and take away from oom handlers under the above memcg configuration?  This 
seems like something you should provide before throwing out patches that 
nobody has tested if you want to make the argument that the above memcg 
configuration is valid for handling userspace oom notifications.

And you certainly have dismissed what I've mentioned earlier when I said 
that anybody can add memory allocation to the exit path later on and 
nobody is going to think about how much memory this is going to bypass to 
the root memcg and potentially take away from userspace oom handlers.

There's two possible ways to forward this:

 - avoid bypass to the root memcg in every possible case such that the
   above memcg configuration actually makes a guarantee to userspace oom
   handlers attached to it, or

 - provide per-memcg memory reserves such that userspace oom handlers can
   allocate and charge memory without the above memcg configuration so 
   there is a guarantee.

What's not acceptable, now or ever, is suggesting a solution to a problem 
that is supposed to guarantee some resource and then allow under some 
circumstances that resource to be completely depleted such that the 
solution never works.

> Yes, and apart from GFP_NOFAIL we are allowing to bypass only those that
> should terminate in a short time. I think that having a setup with a
> guarantee of never triggering the global OOM is too ambitious and I am
> even skeptical it would be achievable.
> 

"Short time" is meaningless if the memory allocation causes memory to not 
be available to userspace oom handlers.  If allocations are allowed to be 
charged because you're in the exit() path or because you have SIGKILL, 
that can result in a system oom condition that would prevent userspace 
from being able to handle them.

> > I'm debating both fatal_signal_pending() and PF_EXITING here since they 
> > are now both bypasses, we need to remove fatal_signal_pending().  My 
> > simple question with your patch: how do you guarantee memory to processes 
> > attached to "a" and "b"?
> 
> The only way you can get that _guarantee_ is to account all the memory
> allocations. And that is not implemented and I would even question
> whether it is worthwhile. So we still have to live with a possibility
> of triggering the global OOM killer. That's why I believe we need to be
> able to tell the kernel what is the user policy for oom killer (that is
> a different discussion though).
> 

So you're saying that Tejun's suggested userspace oom handler 
configuration is pointless, correct?  We can certainly provide a guarantee 
if memory is reserved specifically for userspace oom handling like I 
proposed, the same way that memory reserves are guaranteed for oom killed 
processes.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
