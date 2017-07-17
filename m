From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 5/6] cgroup: implement cgroup v2 thread support
Date: Mon, 17 Jul 2017 17:12:31 -0400
Message-ID: <199bfed8-de84-da6d-6623-c45524443aaa@redhat.com>
References: <20170717020721.3612468-1-tj@kernel.org>
 <20170717020721.3612468-6-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com CA8F9356ED
In-Reply-To: <20170717020721.3612468-6-tj@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On 07/16/2017 10:07 PM, Tejun Heo wrote:
>  
> +Threads
> +~~~~~~~
> +
> +cgroup v2 supports thread granularity for a subset of controllers to
> +support use cases requiring hierarchical resource distribution across
> +the threads of a group of processes.  By default, all threads of a
> +process belong to the same cgroup, which also serves as the resource
> +domain to host resource consumptions which are not specific to a
> +process or thread.  The thread mode allows threads to be spread across
> +a subtree while still maintaining the common resource domain for them.
> +
> +Controllers which support thread mode are called threaded controllers.
> +The ones which don't are called domain controllers.
> +
> +Marking a cgroup threaded makes it join the resource domain of its
> +parent as a threaded cgroup.  The parent may be another threaded
> +cgroup whose resource domain is further up in the hierarchy.  The root
> +of a threaded subtree, that is, the nearest ancestor which is not
> +threaded, is called threaded domain and serves as the resource domain
> +for the entire subtree.

The cgroup code uses the term "thread root" in quite a number of places.
So a developer may be confused when comparing the code and the
documentation. I would recommend either introducing "thread root" as an
alias for threaded domain here in the documentation or documenting that
"threaded domain = thread root" in the code.

> +  cgroup.type
> +
> +	A read-write single value file which exists on non-root
> +	cgroups.
> +
> +	When read, it indicates the current type of the cgroup, which
> +	can be one of the following values.
> +
> +	- "domain" : A normal valid domain cgroup.
> +
> +	- "domain (threaded)" : A threaded domain cgroup which is
> +          serving as the root of a threaded subtree.
> +
> +	- "domain (invalid)" : A cgroup which is in an invalid state.
> +	  It can't be populated or have controllers enabled.  It may
> +	  be allowed to become a threaded cgroup.
> +
> +	- "threaded" : A threaded cgroup which is a member of a
> +          threaded subtree.
> +
> +	A cgroup can be turned into a threaded cgroup by writing
> +	"threaded" to this file.
> +
>    cgroup.procs
>  	A read-write new-line separated values file which exists on
>  	all cgroups.

Do we need to document that cgroup.procs isn't writable in a threaded
cgroup?

> @@ -4301,6 +4606,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
>  	cgrp->self.parent = &parent->self;
>  	cgrp->root = root;
>  	cgrp->level = level;
> +	cgrp->dom_cgrp = cgrp->dom_cgrp;

It is a no-op. I think it is better to modify it to

+    cgrp->dom_cgrp = cgroup_is_threaded(parent) ? parent->dom_cgrp : cgrp;

Then we won't have an invalid domain state.

Cheers,
Longman

