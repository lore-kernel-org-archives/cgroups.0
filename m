From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Wed, 13 Sep 2017 14:29:14 +0200
Message-ID: <20170913122914.5gdksbmkolum7ita@dhcp22.suse.cz>
References: <20170911131742.16482-1-guro@fb.com>
 <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1709111334210.102819@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon 11-09-17 13:44:39, David Rientjes wrote:
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
> required.

While I understand that your usecase might require priorities I do not
think this part missing is a reason to nack the cgroup based selection
and kill-all parts. This can be done on top. The only important part
right now is the current selection semantic - only leaf memcgs vs. size
of the hierarchy). I strongly believe that comparing only leaf memcgs
is more straightforward and it doesn't lead to unexpected results as
mentioned before (kill a small memcg which is a part of the larger
sub-hierarchy).

I didn't get to read the new version of this series yet and hope to get
to it soon.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
