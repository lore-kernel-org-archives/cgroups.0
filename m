From: Roman Gushchin <guro@fb.com>
Subject: Re: [v3 5/6] mm, oom: don't mark all oom victims tasks with
 TIF_MEMDIE
Date: Thu, 29 Jun 2017 14:45:13 -0400
Message-ID: <20170629184513.GA27714@castle>
References: <1498079956-24467-1-git-send-email-guro@fb.com>
 <1498079956-24467-6-git-send-email-guro@fb.com>
 <20170629085357.GF31603@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=XcTxE1uPRHk8hp2pv7bhIF0zFoI7O37p0HS/D2HE4AY=;
 b=FAaubxU1s1jp8TzINH8oBNxrR0ITYV1k5s53JIFN7L+LfO9l7DQ/ovbjmBrJ11V+3hx+
 7hlxsgIO6K4FfOYS/1K7YzLk/of+N3FsXP3vDBXCeedzbrf2D6HVPFw4f6II9fuoi4RF
 TyeaZ2yrVG3llfP1ky+iHnYLMhC+a2NCu1A= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XcTxE1uPRHk8hp2pv7bhIF0zFoI7O37p0HS/D2HE4AY=;
 b=NQ04TibBnR6BL1XPIq+Pj8GMzBwgnDlMGjVBejrO0V3KOBPdzFtM8KzrvsmHR7yYgvAPowrPhRid8pDz+SdkY/nXrNjEPIEBnsjVL4TuzhAlQ/XwK05jwWC0p3IHMwOK7lcxG53Ihny/JjtRaayLo2y56LY6YpTJQdSKuu8nolE=
Content-Disposition: inline
In-Reply-To: <20170629085357.GF31603@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jun 29, 2017 at 10:53:57AM +0200, Michal Hocko wrote:
> On Wed 21-06-17 22:19:15, Roman Gushchin wrote:
> > We want to limit the number of tasks which are having an access
> > to the memory reserves. To ensure the progress it's enough
> > to have one such process at the time.
> > 
> > If we need to kill the whole cgroup, let's give an access to the
> > memory reserves only to the first process in the list, which is
> > (usually) the biggest process.
> > This will give us good chances that all other processes will be able
> > to quit without an access to the memory reserves.
> 
> I don't like this to be honest. Is there any reason to go the reduced
> memory reserves access to oom victims I was suggesting earlier [1]?
> 
> [1] http://lkml.kernel.org/r/http://lkml.kernel.org/r/1472723464-22866-2-git-send-email-mhocko@kernel.org

I've nothing against your approach. What's the state of this patchset?
Do you plan to bring it upstream?

Roman

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
