From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
Date: Tue, 26 Jun 2012 02:05:47 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206260203400.16020@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-12-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252157000.30072@chino.kir.corp.google.com> <4FE96358.6080601@parallels.com>
 <alpine.DEB.2.00.1206260143450.16020@chino.kir.corp.google.com> <4FE9765D.2050301@parallels.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=5JDWEOXy4oKmfwHdscneGI1jGOj3OK5OX/GHG8qInao=;
        b=LErZdMRptw27uidol6LaSY5XUgvmITb8O26iELO+a5gJKuTMo27DVM8mfVIzD6leYO
         g8CuxYJXpwl6P6DC4YuuH2/B8qY8J+aQtFlZ2IAbnr6AvwDjXXvHB/4SoiPvHNqAos1w
         mGYz/szXgA0DaQwWXzSi5VInDI4rtBArcehtN/zrIfwtGe5XwnXblIhzcku7F5wm/XMX
         TCUBiN/eBPnkdEa4Z5Lx2pXwRJkSnea1u1Msuf1yZoKqSHSTidF/+eA+Jk6/MF8kY1vL
         86mO/9Pemc8/ahvkh4tOW0fatnZiPNRRvBW8+lC7k00DqwBt5a5+J9yK8lXhZrjDa3Ye
         g5zQ==
In-Reply-To: <4FE9765D.2050301@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@redhat.com>

On Tue, 26 Jun 2012, Glauber Costa wrote:

> > Right, because I'm sure that __GFP_KMEMCG will be used in additional
> > places outside of this patchset and it will be a shame if we have to
> > always add #ifdef's.  I see no reason why we would care if __GFP_KMEMCG
> > was used when CONFIG_CGROUP_MEM_RES_CTLR_KMEM=n with the semantics that it
> > as in this patchset.  It's much cleaner by making it 0x0 when disabled.
> > 
> 
> What I can do, instead, is to WARN_ON conditionally to the config option in
> the page allocator, and make sure no one is actually passing the flag in that
> case.
> 

I don't think adding a conditional to the page allocator's fastpath when 
CONFIG_CGROUP_MEM_RES_CTLR_KMEM=n is appropriate.  I don't understand why 
this can't be 0x0 for such a configuration, __GFP_KMEM certainly means 
nothing when we don't have it enabled so how is this different at all from 
kmemcheck?
