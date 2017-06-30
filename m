From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v3 5/6] mm, oom: don't mark all oom victims tasks with
 TIF_MEMDIE
Date: Fri, 30 Jun 2017 10:25:51 +0200
Message-ID: <20170630082551.GB22917@dhcp22.suse.cz>
References: <1498079956-24467-1-git-send-email-guro@fb.com>
 <1498079956-24467-6-git-send-email-guro@fb.com>
 <20170629085357.GF31603@dhcp22.suse.cz>
 <20170629184513.GA27714@castle>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170629184513.GA27714@castle>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 29-06-17 14:45:13, Roman Gushchin wrote:
> On Thu, Jun 29, 2017 at 10:53:57AM +0200, Michal Hocko wrote:
> > On Wed 21-06-17 22:19:15, Roman Gushchin wrote:
> > > We want to limit the number of tasks which are having an access
> > > to the memory reserves. To ensure the progress it's enough
> > > to have one such process at the time.
> > > 
> > > If we need to kill the whole cgroup, let's give an access to the
> > > memory reserves only to the first process in the list, which is
> > > (usually) the biggest process.
> > > This will give us good chances that all other processes will be able
> > > to quit without an access to the memory reserves.
> > 
> > I don't like this to be honest. Is there any reason to go the reduced
> > memory reserves access to oom victims I was suggesting earlier [1]?
> > 
> > [1] http://lkml.kernel.org/r/http://lkml.kernel.org/r/1472723464-22866-2-git-send-email-mhocko@kernel.org
> 
> I've nothing against your approach. What's the state of this patchset?
> Do you plan to bring it upstream?

Just the specific patch I have linked should be sufficient for what you
need here. The patchset had some issues which I didn't have time to fix
and as such the need for the above patch was not a high priority as
well.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
