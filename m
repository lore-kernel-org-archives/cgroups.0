From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm 3/4] mm, memcg: replace memory.oom_group with policy
 tunable
Date: Wed, 17 Jan 2018 14:18:33 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801171415200.86895@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com> <alpine.DEB.2.10.1801161814130.28198@chino.kir.corp.google.com> <20180117154155.GU3460072@devbig577.frc2.facebook.com> <20180117160004.GH2900@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=1xu2uHkFKAmEO6Vq8yHfLTa3gqLWd/JCI0iEM8/yBVY=;
        b=dmYbZK20s17u3VGwKiUGyxWSpudirGTC4sVVhMfeDhArZgVVijBnYtngpcYq2s7nLb
         xTPE18QoRSA7xWX5lOnvcELZSjIo+e3z4FEfTuuPA5qT1Waa1tAwFPWBpDZqXgU8if3o
         OEmKjEZVce0G3nRmJeklwdMHI5HmKHADJeU6xnzSOqT8RBYbAjBZlUJKWPqAnb4+adfg
         GuHXfZgfOdtEeEDsDJ8CDKH/YaU0rUDToEWbec33eqTmyQaCMNwAC0pctpEctNbAKMWu
         3yB0732pTxDFjQL/AqvDHP1Upy4lspE6JkEe7ETcsZkD6yMWX8UCMaEQiL5Z0UkYYZsH
         dZrQ==
In-Reply-To: <20180117160004.GH2900@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, 17 Jan 2018, Michal Hocko wrote:

> Absolutely agreed! And moreover, there are not all that many ways what
> to do as an action. You just kill a logical entity - be it a process or
> a logical group of processes. But you have way too many policies how
> to select that entity. Do you want to chose the youngest process/group
> because all the older ones have been computing real stuff and you would
> lose days of your cpu time? Or should those who pay more should be
> protected (aka give them static priorities), or you name it...
> 

That's an argument for making the interface extensible, yes.

> I am sorry, I still didn't grasp the full semantic of the proposed
> soluton but the mere fact it is starting by conflating selection and the
> action is a no go and a wrong API. This is why I've said that what you
> (David) outlined yesterday is probably going to suffer from a much
> longer discussion and most likely to be not acceptable. Your patchset
> proves me correct...

I'm very happy to change the API if there are better suggestions.  That 
may end up just being an memory.oom_policy file, as this implements, and 
separating out a new memory.oom_action that isn't a boolean value to 
either do a full group kill or only a single process.  Or it could be what 
I suggested in my mail to Tejun, such as "hierarchy killall" written to
memory.oom_policy, which would specify a single policy and then an 
optional mechanism.  With my proposed patchset, there would then be three 
policies: "none", "cgroup", and "tree" and one possible optional 
mechanism: "killall".

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
