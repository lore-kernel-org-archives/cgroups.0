From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [v5 2/4] mm, oom: cgroup-aware OOM killer
Date: Tue, 15 Aug 2017 22:20:18 +1000
Message-ID: <f769d03d-5743-b794-a249-bb52b408ab0e@suse.de>
References: <20170814183213.12319-1-guro@fb.com>
 <20170814183213.12319-3-guro@fb.com>
 <alpine.DEB.2.10.1708141532300.63207@chino.kir.corp.google.com>
 <20170815121558.GA15892@castle.dhcp.TheFacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170815121558.GA15892@castle.dhcp.TheFacebook.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro@fb.com>, David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On 08/15/2017 10:15 PM, Roman Gushchin wrote:
> Generally, oom_score_adj should have a meaning only on a cgroup level,
> so extending it to the system level doesn't sound as a good idea.

But wasn't the original purpose of oom_score (and oom_score_adj) to work 
on a system level, aka "normal" OOM? Is there some peculiarity about 
memcg OOM that I'm missing?

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
