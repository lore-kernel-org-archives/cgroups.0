From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] mm, memcg: introduce memory.events.local
Date: Mon, 20 May 2019 13:05:28 -0400
Message-ID: <20190520170528.GC11665@cmpxchg.org>
References: <20190518001818.193336-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4ZOI+jnwXBptD9UIpostnVMZFPCwcvxnpKvL3qurL40=;
        b=Rg3JGm7cAcDM+AZNutQuRwGkJ3ubXbt1UCwOCgZnkJntyOzhCrWnunCiEjWY7ROSIZ
         kVmBbyBsGGB57A5oVMp546xpWJgwU/oSoyDYqohN31no/hHulLW0cV3TFXQxHRGm3Arh
         oZI0B0sNElaQefwHOOurYmhojHza1z+7f0MdJSYwJgf0UX78I0BFmHNhkkyTJP+ysJgA
         1oq4KvyqLM9FGoFmGF0bhA3gzuw3Xcn/MOZUKRVRWJpoiE+3D/NOeDKnUVfhlEhq8tFr
         ACelj15Q04D4dmGoY8dB6fOkc4qS2Hmb9f4IVHnDWYoNGwTJItV3oZNqdJ6Lf+b5E2oC
         /1IA==
Content-Disposition: inline
In-Reply-To: <20190518001818.193336-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, May 17, 2019 at 05:18:18PM -0700, Shakeel Butt wrote:
> The memory controller in cgroup v2 exposes memory.events file for each
> memcg which shows the number of times events like low, high, max, oom
> and oom_kill have happened for the whole tree rooted at that memcg.
> Users can also poll or register notification to monitor the changes in
> that file. Any event at any level of the tree rooted at memcg will
> notify all the listeners along the path till root_mem_cgroup. There are
> existing users which depend on this behavior.
> 
> However there are users which are only interested in the events
> happening at a specific level of the memcg tree and not in the events in
> the underlying tree rooted at that memcg. One such use-case is a
> centralized resource monitor which can dynamically adjust the limits of
> the jobs running on a system. The jobs can create their sub-hierarchy
> for their own sub-tasks. The centralized monitor is only interested in
> the events at the top level memcgs of the jobs as it can then act and
> adjust the limits of the jobs. Using the current memory.events for such
> centralized monitor is very inconvenient. The monitor will keep
> receiving events which it is not interested and to find if the received
> event is interesting, it has to read memory.event files of the next
> level and compare it with the top level one. So, let's introduce
> memory.events.local to the memcg which shows and notify for the events
> at the memcg level.
> 
> Now, does memory.stat and memory.pressure need their local versions.
> IMHO no due to the no internal process contraint of the cgroup v2. The
> memory.stat file of the top level memcg of a job shows the stats and
> vmevents of the whole tree. The local stats or vmevents of the top level
> memcg will only change if there is a process running in that memcg but
> v2 does not allow that. Similarly for memory.pressure there will not be
> any process in the internal nodes and thus no chance of local pressure.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

This looks reasonable to me. Thanks for working out a clear use case
and also addressing how it compares to the stats and pressure files.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
