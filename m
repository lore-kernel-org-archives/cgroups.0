From: Michal Hocko <mhocko@kernel.org>
Subject: Re: + memcg-do-not-report-racy-no-eligible-oom-tasks.patch added to
 -mm tree
Date: Mon, 28 Jan 2019 19:43:26 +0100
Message-ID: <20190128184326.GT18811@dhcp22.suse.cz>
References: <20190109190306.rATpT%akpm@linux-foundation.org>
 <20190125165624.GA17719@cmpxchg.org>
 <20190125172416.GB20411@dhcp22.suse.cz>
 <20190128102616.d7d63f8e1ecdf176bc313f8a@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190128102616.d7d63f8e1ecdf176bc313f8a@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, mm-commits@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Mon 28-01-19 10:26:16, Andrew Morton wrote:
> On Fri, 25 Jan 2019 18:24:16 +0100 Michal Hocko <mhocko@kernel.org> wrote:
> 
> > > >     out_of_memory
> > > >       select_bad_process # no task
> > > > 
> > > > If Thread1 didn't race it would bail out from try_charge and force the
> > > > charge.  We can achieve the same by checking tsk_is_oom_victim inside the
> > > > oom_lock and therefore close the race.
> > > > 
> > > > [1] http://lkml.kernel.org/r/bb2074c0-34fe-8c2c-1c7d-db71338f1e7f@i-love.sakura.ne.jp
> > > > Link: http://lkml.kernel.org/r/20190107143802.16847-3-mhocko@kernel.org
> > > > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > > > Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > 
> > > It looks like this problem is happening in production systems:
> > > 
> > > https://www.spinics.net/lists/cgroups/msg21268.html
> > > 
> > > where the threads don't exit because they are trapped writing out the
> > > oom messages to a slow console (running the reproducer from this email
> > > thread triggers the oom flooding).
> > > 
> > > So IMO we should put this into 5.0 and add:
> > 
> > Please note that Tetsuo has found out that this will not work with the
> > CLONE_VM without CLONE_SIGHAND cases and his http://lkml.kernel.org/r/01370f70-e1f6-ebe4-b95e-0df21a0bc15e@i-love.sakura.ne.jp
> > should handle this case as well. I've only had objections to the
> > changelog but other than that the patch looked sensible to me.
> 
> So I think you're saying that 
> 
> mm-oom-marks-all-killed-tasks-as-oom-victims.patch
> and
> memcg-do-not-report-racy-no-eligible-oom-tasks.patch
> 
> should be dropped and that "[PATCH v2] memcg: killed threads should not
> invoke memcg OOM killer" should be redone with some changelog
> alterations and should be merged instead?

Yup.

-- 
Michal Hocko
SUSE Labs
