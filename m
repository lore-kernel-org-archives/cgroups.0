From: David Rientjes <rientjes@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Fri, 15 Sep 2017 12:55:55 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1709151249290.76069@chino.kir.corp.google.com>
References: <20170911131742.16482-1-guro@fb.com> <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com> <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz> <20170913215607.GA19259@castle> <20170914134014.wqemev2kgychv7m5@dhcp22.suse.cz>
 <20170914160548.GA30441@castle> <20170915105826.hq5afcu2ij7hevb4@dhcp22.suse.cz> <20170915152301.GA29379@castle>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=1grN1eaQ2sL9AUQBk8BvmjvEG4dfsF2KhU+vbzkqc60=;
        b=WwlVdAVV4ekl5+f9wZBSZ5psDIK4+3/76QKaCITW3nNzxb9Q2eEG22TrqOza8mUtZi
         HVKkBzkmWuRDB4SQ/fNmtBMI4JGkYSTgvvXqrurA1dTGrJRHYAIqKPLuAHjyGpIS0k6K
         JoD0BPDz/de2IFeM6gOxXxljHwb8FbCydk5zuDZHR77IDcbqTQwX46EdAhFx4PMOVbKR
         eM/8iNP1EjI3etbJDJHJMT5QnccvRTWyEaIja4f/xMNXXCk0nbJtUojrARkLsVpDROBI
         0DWqQLqTkWPtSh5mUKOArOsNom4x7R8NtcpBVvfO860Wk2/jsZFsxc1c5C/EKW6iqvM1
         UZVQ==
In-Reply-To: <20170915152301.GA29379@castle>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 15 Sep 2017, Roman Gushchin wrote:

> > But then you just enforce a structural restriction on your configuration
> > because
> > 	root
> >         /  \
> >        A    D
> >       /\   
> >      B  C
> > 
> > is a different thing than
> > 	root
> >         / | \
> >        B  C  D
> >
> 
> I actually don't have a strong argument against an approach to select
> largest leaf or kill-all-set memcg. I think, in practice there will be
> no much difference.
> 
> The only real concern I have is that then we have to do the same with
> oom_priorities (select largest priority tree-wide), and this will limit
> an ability to enforce the priority by parent cgroup.
> 

Yes, oom_priority cannot select the largest priority tree-wide for exactly 
that reason.  We need the ability to control from which subtree the kill 
occurs in ancestor cgroups.  If multiple jobs are allocated their own 
cgroups and they can own memory.oom_priority for their own subcontainers, 
this becomes quite powerful so they can define their own oom priorities.   
Otherwise, they can easily override the oom priorities of other cgroups.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
