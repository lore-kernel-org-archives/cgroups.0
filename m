From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm] mm, memcg: evaluate root and leaf memcgs fairly on
 oom
Date: Thu, 15 Mar 2018 13:01:35 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803151259450.44030@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803131720470.247949@chino.kir.corp.google.com> <20180314121700.GA20850@castle.DHCP.thefacebook.com> <alpine.DEB.2.20.1803141337110.163553@chino.kir.corp.google.com>
 <20180315164646.GA1853@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=g9aHvVfh2Hn2VmMQr0Z9PWKkY6CtZe63QVmCowY4kIY=;
        b=r3KOP7qKlJglALfrUbypQlAMeHck9PLY9dsaWxiWMnsVdNBlAhkdONxpJiJSngwJfV
         bVTHy3vAjz6orpte1igQuq4rc7qqOa3cPpA2GsJKpCE7Sp/6T83oRNow9sgSd9KQt82u
         VCmGjdoYzBcA42dyQznYn5FswoBwfwn6X0TvKJSaEeQGTtw0yVJThP1XZKx2F5OhxW7J
         qxInysNOHdC+kKiX446MOlrntljOO4rJl470JX38S2j9tFeb7T9Rwus9/b2CoyY304YC
         qBBI9kCcqwxES8o0yOM7TRfZ2rhk0AxtJj/FxjWqkQ9mDS+6JeiVp39yjvzZvQkz56P6
         6+dw==
In-Reply-To: <20180315164646.GA1853@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu, 15 Mar 2018, Roman Gushchin wrote:

> > Seems like it was dropped from the patch somehow.  It is intended to do 
> > atomic_long_add(nr_pages) in mem_cgroup_charge_skmem() and 
> > atomic_long_add(-nr_pages) mem_cgroup_uncharge_skmem().
> > 
> > > I also doubt that global atomic variable can work here,
> > > we probably need something better scaling.
> > > 
> > 
> > Why do you think an atomic_long_add() is too expensive when we're already 
> > disabling irqs and dong try_charge()?
> 
> Hard to say without having full code :)
> try_charge() is batched, if you'll batch it too, it will probably work.
> 

The full code is what's specified above: it does the 
atomic_long_add(nr_pages) in mem_cgroup_charge_skmem() and 
atomic_long_add(-nr_pages) mem_cgroup_uncharge_skmem().

The patch is comparing the root mem cgroup and leaf mem cgroups fairly.  
For this, it requires that we have stats that can be directly compared or 
at least very close approximations.  We don't want to get in a situation 
where root and leaf mem cgroups are being compared based on different 
stats.
