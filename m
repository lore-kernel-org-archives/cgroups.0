From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Sun, 12 Jan 2014 14:14:07 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401121411000.20999@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com> <20131218200434.GA4161@dhcp22.suse.cz> <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com> <20131219144134.GH10855@dhcp22.suse.cz> <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <alpine.DEB.2.02.1401091324120.31538@chino.kir.corp.google.com> <20140109144757.e95616b4280c049b22743a15@linux-foundation.org> <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140110083025.GE9437@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401101335200.21486@chino.kir.corp.google.com> <20140110223420.GE6963@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=PU8iIC3nWXmFrZEvXgn4JFa6UwIVmUzX56PvAMi5z1Q=;
        b=PCgHVZBmbN4nfw09LHAVRg99NucNBAkU645g8TL/QhZoA8Q7frpyg9FU+6SnpmuNCt
         oiE0X3lMlfkUKZbk+ZhqylWnaeyIRRgFlgCnbWv9qUpw0aRK8F1oODJyLt70j0ZW4psJ
         OoZv4/tqTUCss0TFuD9gN4bjmjNJO0wq2BlNqLuGZ0eVVjnyixmFKfmR9s5Q75DJffH6
         X/cPFqoBK5h7q3iGAvHXdRnHnNxz7yO6pALCHYzYYPxaKThGGS1VZmu/38rKdJhN9Thf
         Rf4feUhJSPVYCAQWtsXv7A5DCVMv3/q3/3MRX8tIqhZi3XuCcxI28tW0akIQ2sqid/Te
         rEIQ==
In-Reply-To: <20140110223420.GE6963@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Fri, 10 Jan 2014, Johannes Weiner wrote:

> > Your patch, which is partially based on my suggestion to move the 
> > mem_cgroup_oom_notify() and call it from two places to support both 
> > memory.oom_control == 1 and != 1, is something that I liked as you know.  
> > It's based on my patch which is now removed from -mm.  So if you want to 
> > rebase that patch and propose it, that's great, but this is yet another 
> > occurrence of where important patches have been yanked out just before the 
> > merge window when the problem they are fixing is real and we depend on 
> > them.
> 
> We tried to discuss and understand the problem, yet all we got was
> "it's OBVIOUS" and "Google has been using this patch ever since we
> switched to memcg" and flat out repetitions of the same points about
> reliable OOM notification that were already put into question.
> 
> You still have not convinced me that the problem exists as you
> described it, apart from the aspects that Michal is now fixing
> separately because you did not show any signs of cooperating.
> 

I cooperated by suggesting his patch which moves the 
mem_cgroup_oom_notify(), Johannes.  The problem is that it depends on my 
patch which was removed from -mm.  He can rebase that patch, but I'm 
hoping it is done before the merge window for inclusion in 3.14.

> None of this will change until you start working with us and actually
> address feedback and inquiries instead of just repeating your talking
> points over and over.
> 

I worked with Michal, who acked my patch, and then wrote another patch on 
top of it based partially on my suggestion, Johannes.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
