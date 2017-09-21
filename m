From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Thu, 21 Sep 2017 10:21:07 -0400
Message-ID: <20170921142107.GA20109@cmpxchg.org>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eKpuI3W/nhMAsYjDcNcC/h27pMC1wKBhBojQyj8U0y4=; b=gmuhHd5+NM4jvacf6M6q7vpnOf
	Mg+WbtmtlHABOQMSlx9iHKyuKCIpXv2mXcD5g51bLdm8/7W5lRNGxXZ1hcLGNEbzIKGUh+kEQ4aHl
	IlkZlok49O8y/B/4+MamGmVYQnr6SfCSmfsTEYg8qQG9sIrLz2LaFep0HefLLR4cvaEg=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Sep 11, 2017 at 01:44:39PM -0700, David Rientjes wrote:
> On Mon, 11 Sep 2017, Roman Gushchin wrote:
> 
> > This patchset makes the OOM killer cgroup-aware.
> > 
> > v8:
> >   - Do not kill tasks with OOM_SCORE_ADJ -1000
> >   - Make the whole thing opt-in with cgroup mount option control
> >   - Drop oom_priority for further discussions
> 
> Nack, we specifically require oom_priority for this to function correctly, 
> otherwise we cannot prefer to kill from low priority leaf memcgs as 
> required.  v8 appears to implement new functionality that we want, to 
> compare two memcgs based on usage, but without the ability to influence 
> that decision to protect important userspace, so now I'm in a position 
> where (1) nothing has changed if I don't use the new mount option or (2) I 
> get completely different oom kill selection with the new mount option but 
> not the ability to influence it.  I was much happier with the direction 
> that v7 was taking, but since v8 causes us to regress without the ability 
> to change memcg priority, this has to be nacked.

That's a ridiculous nak.

The fact that this patch series doesn't solve your particular problem
is not a technical argument to *reject* somebody else's work to solve
a different problem. It's not a regression when behavior is completely
unchanged unless you explicitly opt into a new functionality.

So let's stay reasonable here.

The patch series has merit as it currently stands. It makes OOM
killing in a cgrouped system fairer and less surprising. Whether you
have the ability to influence this in a new way is an entirely
separate discussion. It's one that involves ABI and user guarantees.

Right now Roman's patches make no guarantees on how the cgroup tree is
descended. But once we define an interface for prioritization, it
locks the victim algorithm into place to a certain extent.

It also involves a discussion about how much control userspace should
have over OOM killing in the first place. It's a last-minute effort to
save the kernel from deadlocking on memory. Whether that is the time
and place to have userspace make clever resource management decisions
is an entirely different thing than what Roman is doing.

But this patch series doesn't prevent any such future discussion and
implementations, and it's not useless without it. So let's not
conflate these two things, and hold the priority patch for now.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
