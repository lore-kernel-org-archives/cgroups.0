From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [v10 3/6] mm, oom: cgroup-aware OOM killer
Date: Wed, 4 Oct 2017 16:41:53 -0400
Message-ID: <20171004204153.GA2696@cmpxchg.org>
References: <20171004154638.710-1-guro@fb.com>
 <20171004154638.710-4-guro@fb.com>
 <alpine.DEB.2.10.1710041322160.67374@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wLWjk03o37nXq9jj3mDKFxKi1PNq4e0fXxx2EuupAl0=; b=GpnBd9McUn3PH65gHOWvJgEANU
        L2/toSgaLZi4kGW9JeT5FsnGUXoreDB/BJawHd+wf9q1Ghsiel37KxPj2GQ8WJnvgM4iylsasbLSI
        BPVzKCF/4ltA9W37Gh0UgkHC5LY1Pm3V7kqwR84lVh9JBvuc26z3Dia5dyeTo5qJi93w=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1710041322160.67374@chino.kir.corp.google.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 04, 2017 at 01:27:14PM -0700, David Rientjes wrote:
> By only considering leaf memcgs, does this penalize users if their memcg 
> becomes oc->chosen_memcg purely because it has aggregated all of its 
> processes to be members of that memcg, which would otherwise be the 
> standard behavior?
> 
> What prevents me from spreading my memcg with N processes attached over N 
> child memcgs instead so that memcg_oom_badness() becomes very small for 
> each child memcg specifically to avoid being oom killed?

It's no different from forking out multiple mm to avoid being the
biggest process.

It's up to the parent to enforce limits on that group and prevent you
from being able to cause global OOM in the first place, in particular
if you delegate to untrusted and potentially malicious users.
