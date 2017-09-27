From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Wed, 27 Sep 2017 09:43:19 +0200
Message-ID: <20170927074319.o3k26kja43rfqmvb@dhcp22.suse.cz>
References: <20170925122400.4e7jh5zmuzvbggpe@dhcp22.suse.cz>
 <20170925170004.GA22704@cmpxchg.org>
 <20170925181533.GA15918@castle>
 <20170925202442.lmcmvqwy2jj2tr5h@dhcp22.suse.cz>
 <20170926105925.GA23139@castle.dhcp.TheFacebook.com>
 <20170926112134.r5eunanjy7ogjg5n@dhcp22.suse.cz>
 <20170926121300.GB23139@castle.dhcp.TheFacebook.com>
 <20170926133040.uupv3ibkt3jtbotf@dhcp22.suse.cz>
 <20170926172610.GA26694@cmpxchg.org>
 <CAAAKZws88uF2dVrXwRV0V6AH5X68rWy7AfJxTxYjpuiyiNJFWA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAAKZws88uF2dVrXwRV0V6AH5X68rWy7AfJxTxYjpuiyiNJFWA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin@hockin.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue 26-09-17 20:37:37, Tim Hockin wrote:
[...]
> I feel like David has offered examples here, and many of us at Google
> have offered examples as long ago as 2013 (if I recall) of cases where
> the proposed heuristic is EXACTLY WRONG.

I do not think we have discussed anything resembling the current
approach. And I would really appreciate some more examples where
decisions based on leaf nodes would be EXACTLY WRONG.

> We need OOM behavior to kill in a deterministic order configured by
> policy.

And nobody is objecting to this usecase. I think we can build a priority
policy on top of leaf-based decision as well. The main point we are
trying to sort out here is a reasonable semantic that would work for
most workloads. Sibling based selection will simply not work on those
that have to use deeper hierarchies for organizational purposes. I
haven't heard a counter argument for that example yet.
-- 
Michal Hocko
SUSE Labs
