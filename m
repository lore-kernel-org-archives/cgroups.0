From: Roman Gushchin <guro@fb.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Wed, 13 Sep 2017 14:56:07 -0700
Message-ID: <20170913215607.GA19259@castle>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
 <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=l0tJla9PsmXJ23sPQOS+E2P5bAAo21wsTmaLqMyXisg=;
 b=dAyMp6kp8T/qSqHnvug+v+GbnX+SUdSEGzXWZyA/SAW7uaYtbV8B6F/ASTpSTfNqoLC5
 mgIMclg0O4ledL4EudYtQRbNGahRBAMPZOSKM3LZWJU7I7O1L+AzrpPNqHN5aHD4B13H
 HcoFyfwzeKspk/ndHd7S2FnUHYFM+2BMJaQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=l0tJla9PsmXJ23sPQOS+E2P5bAAo21wsTmaLqMyXisg=;
 b=b5035xWC+hwbddl8vPkHT1s5s0juQWVl23d70wJ6k2vvKvbViiMA10TNCIGXYcbKZr2URlp1xiWTLwO6wl/HWolSusgD+q0GL1GqiNPznsWkJGLYXbn4MTwLt/7LO9/Zi5QkllDGbTbm/argD76IGftlol53Q7Yu6Wpz1TAxvmU=
Content-Disposition: inline
In-Reply-To: <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 13, 2017 at 02:29:14PM +0200, Michal Hocko wrote:
> On Mon 11-09-17 13:44:39, David Rientjes wrote:
> > On Mon, 11 Sep 2017, Roman Gushchin wrote:
> > 
> > > This patchset makes the OOM killer cgroup-aware.
> > > 
> > > v8:
> > >   - Do not kill tasks with OOM_SCORE_ADJ -1000
> > >   - Make the whole thing opt-in with cgroup mount option control
> > >   - Drop oom_priority for further discussions
> > 
> > Nack, we specifically require oom_priority for this to function correctly, 
> > otherwise we cannot prefer to kill from low priority leaf memcgs as 
> > required.
> 
> While I understand that your usecase might require priorities I do not
> think this part missing is a reason to nack the cgroup based selection
> and kill-all parts. This can be done on top. The only important part
> right now is the current selection semantic - only leaf memcgs vs. size
> of the hierarchy).

I agree.

> I strongly believe that comparing only leaf memcgs
> is more straightforward and it doesn't lead to unexpected results as
> mentioned before (kill a small memcg which is a part of the larger
> sub-hierarchy).

One of two main goals of this patchset is to introduce cgroup-level
fairness: bigger cgroups should be affected more than smaller,
despite the size of tasks inside. I believe the same principle
should be used for cgroups.

Also, the opposite will make oom_semantics more weird: it will mean
kill all tasks, but also treat memcg as a leaf cgroup.

> 
> I didn't get to read the new version of this series yet and hope to get
> to it soon.

Thanks!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
