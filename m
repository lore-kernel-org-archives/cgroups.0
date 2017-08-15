From: Roman Gushchin <guro@fb.com>
Subject: Re: [v5 2/4] mm, oom: cgroup-aware OOM killer
Date: Tue, 15 Aug 2017 13:57:50 +0100
Message-ID: <20170815125750.GB15892@castle.dhcp.TheFacebook.com>
References: <20170814183213.12319-1-guro@fb.com>
 <20170814183213.12319-3-guro@fb.com>
 <alpine.DEB.2.10.1708141532300.63207@chino.kir.corp.google.com>
 <20170815121558.GA15892@castle.dhcp.TheFacebook.com>
 <f769d03d-5743-b794-a249-bb52b408ab0e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=54LxoXejWSp4+V3wZ1MiQ8q55rFhOC2bRbDJ+zIYCH8=;
 b=meh8w1t0Ksbnmv9ROoTPqR6t/mLSpotTMjcXIa/Qm4th5v6EWYzlBg7RrmJX8j3b3Uxf
 I1/yb8ZbvnRfzMFi0bivHPCtle0XQo/GGkoGtOs/bwUMufQ85iAzuEdV9caBxFjyKfbb
 Qyfu0aEYukjYtBfa+kxQhLNv/SPzNxjTAL0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=54LxoXejWSp4+V3wZ1MiQ8q55rFhOC2bRbDJ+zIYCH8=;
 b=ASl3VcYfsZFiE4Ms0ne0msy8jPj7UaXayXaya5KanUdmeuV60J4dLOSveU3+Ck5P0lTVSNgPV31QGVdZNuzrqH2qZVUQjaTH7Hs7+mb1VKauURVJoed/4Sx/1VQil1HqZ2nYwe4VPL6+kE1TbLqlI6c7sF6TWbBwtkR/wqBxWJQ=
Content-Disposition: inline
In-Reply-To: <f769d03d-5743-b794-a249-bb52b408ab0e@suse.de>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai@suse.de>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Aug 15, 2017 at 10:20:18PM +1000, Aleksa Sarai wrote:
> On 08/15/2017 10:15 PM, Roman Gushchin wrote:
> > Generally, oom_score_adj should have a meaning only on a cgroup level,
> > so extending it to the system level doesn't sound as a good idea.
> 
> But wasn't the original purpose of oom_score (and oom_score_adj) to work on
> a system level, aka "normal" OOM? Is there some peculiarity about memcg OOM
> that I'm missing?

I'm sorry, if it wasn't clear from my message, it's not about
the system-wide OOM vs the memcg-wide OOM, it's about the isolation.

In general, decision is made on memcg level first (based on oom_priority
and size), and only then on a task level (based on size and oom_score_adj).

Oom_score_adj affects which task inside the cgroup will be killed,
but we never compare tasks from different cgroups. This is what I mean,
when I'm saying, that oom_score_adj should not have a system-wide meaning.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
