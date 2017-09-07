From: Roman Gushchin <guro@fb.com>
Subject: Re: [v7 5/5] mm, oom: cgroup v2 mount option to disable cgroup-aware
 OOM killer
Date: Thu, 7 Sep 2017 15:52:39 +0100
Message-ID: <20170907145239.GA19022@castle.DHCP.thefacebook.com>
References: <20170904142108.7165-1-guro@fb.com>
 <20170904142108.7165-6-guro@fb.com>
 <20170905134412.qdvqcfhvbdzmarna@dhcp22.suse.cz>
 <20170905143021.GA28599@castle.dhcp.TheFacebook.com>
 <20170905151251.luh4wogjd3msfqgf@dhcp22.suse.cz>
 <20170905191609.GA19687@castle.dhcp.TheFacebook.com>
 <20170906084242.l4rcx6n3hdzxvil6@dhcp22.suse.cz>
 <20170906174043.GA12579@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.10.1709061355001.70553@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1709070939340.19539@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=RIUfvpn6UqCVo3tlIFs3gGOn/1pp3GzIX35kTziaB8E=;
 b=KG/jFhq2VePSyZm/fiZE82SHDvge39HpozuUiVxTxKhalK57ykPocYASPvX0eiQwNXD3
 RdRd7X6QVXHgNzSFgBnzdkni4WLIXvHTWIERYkyEUH1Mjo24QJXuGzaP71Ofz1lnIPrC
 lCUjSU9Jm+PQLOg3nRrDULVnVy8OlyUN3c0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RIUfvpn6UqCVo3tlIFs3gGOn/1pp3GzIX35kTziaB8E=;
 b=exmJUlR5lwnTJSmAIYccvJqirvGUtdY6FLj+CBbEtdrFg+nmT9YTchMSWz6Hv/gI3CosU+vqitfY8NEjKVsh0ZA6Jpvh/Wj36jym/9kEZxCCv9PI9ICpPIf9V8q08rzdvBvaiMd1CF7H9NuMeiI0BqB3FkK0QzrwmC2yDP1+rdo=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1709070939340.19539@nuc-kabylake>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, nzimmer@sgi.com, holt@sgi.com, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, sivanich@sgi.com

On Thu, Sep 07, 2017 at 09:43:30AM -0500, Christopher Lameter wrote:
> On Wed, 6 Sep 2017, David Rientjes wrote:
> 
> > > The oom_kill_allocating_task sysctl which causes the OOM killer
> > > to simple kill the allocating task is useless. Killing the random
> > > task is not the best idea.
> > >
> > > Nobody likes it, and hopefully nobody uses it.
> > > We want to completely deprecate it at some point.
> > >
> >
> > SGI required it when it was introduced simply to avoid the very expensive
> > tasklist scan.  Adding Christoph Lameter to the cc since he was involved
> > back then.
> 
> Really? From what I know and worked on way back when: The reason was to be
> able to contain the affected application in a cpuset. Multiple apps may
> have been running in multiple cpusets on a large NUMA machine and the OOM
> condition in one cpuset should not affect the other. It also helped to
> isolate the application behavior causing the oom in numerous cases.
> 
> Doesnt this requirement transfer to cgroups in the same way?

We have per-node memory stats and plan to use them during the OOM victim
selection. Hopefully it can help.

> 
> Left SGI in 2008 so adding Dimitri who may know about the current
> situation. Robin Holt also left SGI as far as I know.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
