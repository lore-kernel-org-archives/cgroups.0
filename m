From: Roman Gushchin <guro@fb.com>
Subject: Re: [patch v3 -mm 3/6] mm, memcg: add hierarchical usage oom policy
Date: Mon, 23 Jul 2018 14:28:58 -0700
Message-ID: <20180723212855.GA25062@castle>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1803161405410.209509@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1803221451370.17056@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1807131604560.217600@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1807131605590.217600@chino.kir.corp.google.com>
 <20180716181613.GA28327@castle>
 <alpine.DEB.2.21.1807162101170.157949@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1807231331510.105582@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=NxyWxfg7dmMBXy2NFECFNYrgn5Jc0nDS444OLRxx2eQ=;
 b=D0AKXUkorB2HF60OCTMtA9rb9IzeEMl/XozrY9mXFKMZZjzL+OTRR5JOjD+fXCys/ElL
 VOCXxySBzMEPMOUqDUfL/CfakAsyDSCRqL0rqGKNl3CnBvVUoyaaO3eF118O9MCx/ACH
 /Dr5/QEtowH92hoeuKLN4QcHlz1vlSksI4k= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxyWxfg7dmMBXy2NFECFNYrgn5Jc0nDS444OLRxx2eQ=;
 b=L0eMmfdmzSL8O1uZy+nopHmt8ax56m+XSo8KmKDHb2I6sVQq4JtOpAuCF5e+5ZHgRWP7wOJ13Y/lZso6AuoITmr6MmwqzdMFEHzvF74QKbevywBrPux2tc39brqWD8gMeha+DK9D58YMISp9qoQ7tPFYyMRxxgb4hqk+NY+0Fgk=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1807231331510.105582@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon, Jul 23, 2018 at 01:33:19PM -0700, David Rientjes wrote:
> On Mon, 16 Jul 2018, David Rientjes wrote:
> 
> > > And "tree" is different. It actually changes how the selection algorithm works,
> > > and sub-tree settings do matter in this case.
> > > 
> > 
> > "Tree" is considering the entity as a single indivisible memory consumer, 
> > it is compared with siblings based on its hierarhical usage.  It has 
> > cgroup oom policy.
> > 
> > It would be possible to separate this out, if you'd prefer, to account 
> > an intermediate cgroup as the largest descendant or the sum of all 
> > descendants.  I hadn't found a usecase for that, however, but it doesn't 
> > mean there isn't one.  If you'd like, I can introduce another tunable.
> > 
> 
> Roman, I'm trying to make progress so that the cgroup aware oom killer is 
> in a state that it can be merged.  Would you prefer a second tunable here 
> to specify a cgroup's points includes memory from its subtree?

Hi, David!

It's hard to tell, because I don't have a clear picture of what you're
suggesting now. My biggest concern about your last version was that it's hard
to tell what oom_policy really defines. Each value has it's own application
rules, which is a bit messy (some values are meaningful for OOMing cgroup only,
other are reading on hierarchy traversal).
If you know how to make it clear and non-contradictory,
please, describe the proposed interface.

> 
> It would be helpful if you would also review the rest of the patchset.

I think, that we should focus on interface semantics right now.
If we can't agree on how the things should work, it makes no sense
to discuss the implementation.

Thanks!
