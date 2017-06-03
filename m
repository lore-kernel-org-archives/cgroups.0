From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH] mm/memcontrol: exclude @root from checks in
 mem_cgroup_low
Date: Sat, 3 Jun 2017 22:15:53 +0300
Message-ID: <20170603191553.GG15130@esperanza>
References: <1496434412-21005-1-git-send-email-sean.j.christopherson@intel.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rIk3VB+6rJIpNg3nfuKRPU0QFqLYdIyKcoDPDuiXJAI=;
        b=KhZP6KT8wfjbHqITVuZBtqAXy+7AUQI6fhPA03ai5NUMo3CJWo8o1966h4bBWlM349
         LlTGtHuSLTwmwvl4so35j1N3ZPWN0U49l+Zd8msg1vjt1updqyXZLZpA5Md/cNhwPREM
         H2oXX5lfNf/ekNQwAlewHi4gVswNSSTcseWDGffgKgSquDE9OVaa5JwtyZ2Q7/jWXyqV
         QS1Oj8iHDSQIVz7pDTflyafGfcMSPYSBglssZ/HrWysnDZTEHl9PBFlnCWC4aEmXfcAV
         /tKDNgiSmH21YBdgbQQgMwQ2mqWuQKts1c/wK9EuzYfcooUdhsasp0PQ2IUdPmuVrsWs
         gFWg==
Content-Disposition: inline
In-Reply-To: <1496434412-21005-1-git-send-email-sean.j.christopherson@intel.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: mhocko@kernel.org, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Fri, Jun 02, 2017 at 01:13:32PM -0700, Sean Christopherson wrote:
> Make @root exclusive in mem_cgroup_low; it is never considered low
> when looked at directly and is not checked when traversing the tree.
> In effect, @root is handled identically to how root_mem_cgroup was
> previously handled by mem_cgroup_low.
> 
> If @root is not excluded from the checks, a cgroup underneath @root
> will never be considered low during targeted reclaim of @root, e.g.
> due to memory.current > memory.high, unless @root is misconfigured
> to have memory.low > memory.high.
> 
> Excluding @root enables using memory.low to prioritize memory usage
> between cgroups within a subtree of the hierarchy that is limited by
> memory.high or memory.max, e.g. when ROOT owns @root's controls but
> delegates the @root directory to a USER so that USER can create and
> administer children of @root.
> 
> For example, given cgroup A with children B and C:
> 
>     A
>    / \
>   B   C
> 
> and
> 
>   1. A/memory.current > A/memory.high
>   2. A/B/memory.current < A/B/memory.low
>   3. A/C/memory.current >= A/C/memory.low
> 
> As 'A' is high, i.e. triggers reclaim from 'A', and 'B' is low, we
> should reclaim from 'C' until 'A' is no longer high or until we can
> no longer reclaim from 'C'.  If 'A', i.e. @root, isn't excluded by
> mem_cgroup_low when reclaming from 'A', then 'B' won't be considered
> low and we will reclaim indiscriminately from both 'B' and 'C'.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  mm/memcontrol.c | 50 ++++++++++++++++++++++++++++++++------------------
>  1 file changed, 32 insertions(+), 18 deletions(-)

Good catch, wonder why it hasn't been reported before.
IMO the patch looks good - it makes the mem_cgroup_low()
code easier to follow.

Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
