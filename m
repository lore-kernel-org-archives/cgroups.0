From: Roman Gushchin <guro@fb.com>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Thu, 5 Oct 2017 12:45:51 +0100
Message-ID: <20171005114551.GA6338@castle.dhcp.TheFacebook.com>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
 <CALvZod6bwyoSWTv139y0wMidpZm5HcDu8RzVjF8U7GHxAzxSQw@mail.gmail.com>
 <20171004201524.GA4174@castle>
 <CALvZod45ObeQwq-pKeqyLe2bNwfKAr0majCbNfqPOEJL+AeiNw@mail.gmail.com>
 <20171005102707.GA12982@castle.dhcp.TheFacebook.com>
 <20171005111230.i7am3patptvalcat@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=SNEvd22+l/MjYNRv4VWTkmnrOMzk11UGfS/RGMcRwFI=;
 b=gFbuezKqarGWWZQyvkMg8YuXLY9rjUtDB+7MAUWAN4pCBYTlIwGLU01A+O7LvOUXc4Q1
 V+hg3z7LkSGAfs+B1KN+Jb/RfHVSDpLch2HR5qhbz4F7rmiOJbiX0jJT0I5QItcqtzwB
 iZ7UkfUvH6KGS2BtW8DHDOgtU24rsVXXsRU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SNEvd22+l/MjYNRv4VWTkmnrOMzk11UGfS/RGMcRwFI=;
 b=USa/9Uh3QmqPSo7wVeR1FbE7ymi2MhTKhMwmyGaXCL8+iPBXCBKfATGXOlv/mxLc2HYtHsEdDKMdZFqrlgsFYoOJye9pYTiAXDntUKaNTEa/NbO2LnDbIw3xqBcUXfaVs/6hIPZU4LNJmvmOm/accLuuOX/G+fqxsJkWLXvUzUA=
Content-Disposition: inline
In-Reply-To: <20171005111230.i7am3patptvalcat@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, Linux MM <linux-mm@kvack.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Thu, Oct 05, 2017 at 01:12:30PM +0200, Michal Hocko wrote:
> On Thu 05-10-17 11:27:07, Roman Gushchin wrote:
> > On Wed, Oct 04, 2017 at 02:24:26PM -0700, Shakeel Butt wrote:
> [...]
> > > Sorry about the confusion. There are two things. First, should we do a
> > > css_get on the newly selected memcg within the for loop when we still
> > > have a reference to it?
> > 
> > We're holding rcu_read_lock, it should be enough. We're bumping css counter
> > just before releasing rcu lock.
> 
> yes
> 
> > > 
> > > Second, for the OFFLINE memcg, you are right oom_evaluate_memcg() will
> > > return 0 for offlined memcgs. Maybe no need to call
> > > oom_evaluate_memcg() for offlined memcgs.
> > 
> > Sounds like a good optimization, which can be done on top of the current
> > patchset.
> 
> You could achive this by checking whether a memcg has tasks rather than
> explicitly checking for children memcgs as I've suggested already.

Using cgroup_has_tasks() will require additional locking, so I'm not sure
it worth it.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
