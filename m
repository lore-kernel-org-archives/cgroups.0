From: Roman Gushchin <guro@fb.com>
Subject: Re: [RFC PATCH v2 1/7] mm, oom: refactor select_bad_process() to
 take memcg as an argument
Date: Thu, 8 Jun 2017 16:59:57 +0100
Message-ID: <20170608155957.GA13161@castle>
References: <1496342115-3974-1-git-send-email-guro@fb.com>
 <1496342115-3974-2-git-send-email-guro@fb.com>
 <alpine.DEB.2.10.1706041550290.24226@chino.kir.corp.google.com>
 <20170606162007.GB752@castle>
 <alpine.DEB.2.10.1706061339410.23608@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=SCMEti1LggjJ1a48MKJKMj+osojAU8AByYG96rQLyDo=;
 b=kylPA70ojzL0Rkhp3K84dFWb/QR1mx6ImJ0Yxm+y13FgHy5Fiy+//QCMOTs8a0o5vxnh
 Ewip/vs6ny2sI6RG9volnLUSvuMBEhG5mC5tDuDnEIGbKTOH6KK83oQQXgN9m8ATcKcf
 xz4SC+ol2jbXi5cmxHjN+3sGdBi7Qjs5+JA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SCMEti1LggjJ1a48MKJKMj+osojAU8AByYG96rQLyDo=;
 b=VCY/7+R5qUfAVrxhYjdDeRO6iHdFnemtSFRq/w8Sg/FsI3o2eahZNyJzrpPO+VZnUesPDmf9htEdCvg36k+Hzl/DiQ7OqSv3+2MinnnJ4oSP8ohucCQ26+1G4aRJnxrGzpw6sf1LUTq/mfJLmm86S2wUolBlqPmdzdkzYYjUZd8=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1706061339410.23608@chino.kir.corp.google.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jun 06, 2017 at 01:42:29PM -0700, David Rientjes wrote:
> On Tue, 6 Jun 2017, Roman Gushchin wrote:
> 
> > Hi David!
> > 
> > Thank you for sharing this!
> > 
> > It's very interesting, and it looks like,
> > it's not that far from what I've suggested.
> > 
> > So we definitily need to come up with some common solution.
> > 
> 

Hi David,

> Yes, definitely.  I could post a series of patches to do everything that 
> was listed in my email sans the fully inclusive kmem accounting, which may 
> be pursued at a later date, if it would be helpful to see where there is 
> common ground?
> 
> Another question is what you think about userspace oom handling?  We 
> implement our own oom kill policies in userspace for both the system and 
> for user-controlled memcg hierarchies because it often does not match the 
> kernel implementation and there is some action that can be taken other 
> than killing a process.  Have you tried to implement functionality to do 
> userspace oom handling, or are you considering it?  This is the main 
> motivation behind allowing an oom delay to be configured.

cgroup v2 memory controller is built on the idea of preventing OOMs
by using the memory.high limit. This allows an userspace app to get notified
before OOM happens (by looking at memory.events control), so there is (hopefully)
no need in things like oom delay.

Actually, I'm trying to implement some minimal functionality in the kernel,
which will simplify and make more consistent the userspace part of the job.
But, of course, the main goal of the patchset is to fix the unfairness
of the current victim selection.

Thanks!

Roman
