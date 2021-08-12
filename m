From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] cgroup/cpuset: Enable memory migration for cpuset v2
Date: Thu, 12 Aug 2021 09:08:49 -0400
Message-ID: <YRUdYQzxj8rswNyz@cmpxchg.org>
References: <20210811195707.30851-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xs8EmBt7Wwwk0rDo3WH++ioTrTW94g/xJg4dS2VTU70=;
        b=B5u5MqvyKhZf+vJdh29wKQ5uSD8KVQ0z4A9dz5siLPjFNEs9Fu1QKsbl48q8OWNNvx
         X4ln3uTu9KiU3bN7egPX0wn4rWzwnfWkD4P/g0gFBxGIu9O1Sf6TYSlH8mdfIAz8mErj
         6/PWaHr3fn5iEEtxLtwNcIJeYC4V2tN09GGiDZBWut3fVYh8EYt2ccqvTrlQ5K+ifegP
         zuYsHO0Nxi7bVcC2bq4BgAnOB6jAhAvKK9q6TdUr1otRZFE0dUqedOfPUNXl6r1YTguv
         vzFlBzPdQoSt6hcHDg2ohSM7NHejJkya7sFheFmnpVXUhaFzy2qGyo66NHt9MGVM9GaM
         Q/yA==
Content-Disposition: inline
In-Reply-To: <20210811195707.30851-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org

On Wed, Aug 11, 2021 at 03:57:07PM -0400, Waiman Long wrote:
> When a user changes cpuset.cpus, each task in a v2 cpuset will be moved
> to one of the new cpus if it is not there already. For memory, however,
> they won't be migrated to the new nodes when cpuset.mems changes. This is
> an inconsistency in behavior.
> 
> In cpuset v1, there is a memory_migrate control file to enable such
> behavior by setting the CS_MEMORY_MIGRATE flag. Make it the default
> for cpuset v2 so that we have a consistent set of behavior for both
> cpus and memory.
> 
> There is certainly a cost to make memory migration the default, but it
> is a one time cost that shouldn't really matter as long as cpuset.mems
> isn't changed frequenty.  Update the cgroup-v2.rst file to document the
> new behavior and recommend against changing cpuset.mems frequently.
> 
> Since there won't be any concurrent access to the newly allocated cpuset
> structure in cpuset_css_alloc(), we can use the cheaper non-atomic
> __set_bit() instead of the more expensive atomic set_bit().
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

LGTM.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
