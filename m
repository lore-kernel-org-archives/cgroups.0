From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 2/2] memcg: do not sleep on OOM waitqueue with full charge
 context
Date: Wed, 12 Jun 2013 13:49:47 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1306121343500.24902@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1306052058340.25115@chino.kir.corp.google.com> <20130606053315.GB9406@cmpxchg.org> <20130606173355.GB27226@cmpxchg.org> <alpine.DEB.2.02.1306061308320.9493@chino.kir.corp.google.com> <20130606215425.GM15721@cmpxchg.org>
 <alpine.DEB.2.02.1306061507330.15503@chino.kir.corp.google.com> <20130607000222.GT15576@cmpxchg.org> <alpine.DEB.2.02.1306111454030.4803@chino.kir.corp.google.com> <20130612082817.GA6706@dhcp22.suse.cz> <alpine.DEB.2.02.1306121309500.23348@chino.kir.corp.google.com>
 <20130612203705.GB17282@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=s9MyK38ObtFd12zq5E/q9TyPiCpQQDApTy4VXv4IsRE=;
        b=gVZRSUayfI/K+PHwynazxkfsp3Kg2ckJUrsatkYFwhrYdFu/ZxkEOk5+Ea0c5LWiLX
         PTu/mLVx1vNPfMlyRwlfV0+m7HVjlevpKaU8PwFkK/lyzb2xcNJlCDAaM+h2B775PLKb
         50xkwfnAQoJ1PlFgif4EV4zaZMg0gV6a1vOF4MCfeJ8NGWDhotTHi5q+T3D1L1LQAX+t
         8EWWvA72UkzwVF9uIDCt9a+Gn5St8+k1ZCjuPhjpdr2uT7AUCz4JwNcJHh3zT+zQkwXi
         vE2G82VrkIDe6vN2Du5MAG8bTVPUXn4lghWfQn9LvkVWvM5fnN5b0kSyHXL5gb4iTk+2
         ayzQ==
In-Reply-To: <20130612203705.GB17282@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 12 Jun 2013, Michal Hocko wrote:

> The patch is a big improvement with a minimum code overhead. Blocking
> any task which sits on top of an unpredictable amount of locks is just
> broken. So regardless how many users are affected we should merge it and
> backport to stable trees. The problem is there since ever. We seem to
> be surprisingly lucky to not hit this more often.
> 

Right now it appears that that number of users is 0 and we're talking 
about a problem that was reported in 3.2 that was released a year and a 
half ago.  The rules of inclusion in stable also prohibit such a change 
from being backported, specifically "It must fix a real bug that bothers 
people (not a, "This could be a problem..." type thing)".

We have deployed memcg on a very large number of machines and I can run a 
query over all software watchdog timeouts that have occurred by 
deadlocking on i_mutex during memcg oom.  It returns 0 results.

> I am not quite sure I understand your reservation about the patch to be
> honest. Andrew still hasn't merged this one although 1/2 is in.

Perhaps he is as unconvinced?  The patch adds 100 lines of code, including 
fields to task_struct for memcg, for a problem that nobody can reproduce.  
My question still stands: can anybody, even with an instrumented kernel to 
make it more probable, reproduce the issue this is addressing?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
