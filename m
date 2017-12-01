From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v13 5/7] mm, oom: add cgroup v2 mount option for
 cgroup-aware OOM killer
Date: Fri, 1 Dec 2017 14:31:45 +0100
Message-ID: <20171201133145.w4b4cekruklcgtol@dhcp22.suse.cz>
References: <20171130152824.1591-1-guro@fb.com>
 <20171130152824.1591-6-guro@fb.com>
 <20171201084113.47lnuo3diwxts732@dhcp22.suse.cz>
 <20171201131530.GA7741@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171201131530.GA7741@castle.DHCP.thefacebook.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Fri 01-12-17 13:15:38, Roman Gushchin wrote:
[...]
> So, maybe we just need to return -EAGAIN (or may be -ENOTSUP) on any read/write
> attempt if option is not enabled?

Yes, that would work as well. ENOTSUP sounds better to me.
-- 
Michal Hocko
SUSE Labs
