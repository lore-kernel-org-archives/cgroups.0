From: David Rientjes <rientjes@google.com>
Subject: Re: [v5 2/4] mm, oom: cgroup-aware OOM killer
Date: Wed, 23 Aug 2017 16:13:26 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708231611390.68096@chino.kir.corp.google.com>
References: <20170814183213.12319-1-guro@fb.com> <20170814183213.12319-3-guro@fb.com> <20170822170344.GA13547@cmpxchg.org> <20170823162031.GA13578@castle.dhcp.TheFacebook.com> <20170823172441.GA29085@cmpxchg.org>
 <20170823174603.GA26190@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=etFuoYM/OsGtiDfKvsg1hMo8JeNKJW1UvsieTzUE6y0=;
        b=cf8tRJUyYww8cYJ/u2eTd6g3GJFaGqBalCmtjaXx5r32OrgB3xaAXEXAGDeRe8WKdd
         X2r64I+TFKD28OI+Gg2nE0/CJ4VJ5I/pLOkNu4xXPF8Rm49j4LEvDQZRvMBlDogPvc/S
         hZUPUXQwLFhjOSDgajQ0IDxkmqbTvAesOzCO0wEkRuYzafhB8Mrcn/1EU8MEDzJCLO4o
         S1xZtAhUrrQl1d7TZqeq9C6q2SPnnFGvWeLrSxHdVIilxp6Ykw1C3UNwYhB4pBQK1fHX
         wT3E2nHV+ZnwxbDS3IGr07pEoz4k//TOefATHbXW3YT2RHD2iuEMfunvXsckXcXs/Cec
         sMHg==
In-Reply-To: <20170823174603.GA26190@castle.DHCP.thefacebook.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 23 Aug 2017, Roman Gushchin wrote:

> > It's better to have newbies consult the documentation once than making
> > everybody deal with long and cumbersome names for the rest of time.
> > 
> > Like 'ls' being better than 'read_and_print_directory_contents'.
> 
> I don't think it's a good argument here: realistically, nobody will type
> the knob's name often. Your option is shorter only by 3 characters :)
> 
> Anyway, I'm ok with memory.oom_group too, if everybody else prefer it.
> Michal, David?
> What's your opinion?
> 

I'm probably the worst person in the world for succinctly naming stuff, 
but I at least think the knob should have the word "kill" in it to 
describe the behavior.  ("oom_group", out of memory group, what exactly is 
that?)
