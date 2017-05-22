From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v2 11/17] cgroup: Implement new thread mode semantics
Date: Mon, 22 May 2017 13:32:20 -0400
Message-ID: <71ce8f1c-3d92-64f2-085d-8900b8576d25@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-12-git-send-email-longman@redhat.com>
 <20170519202624.GA15279@wtj.duckdns.org>
 <b1d02881-f522-8baa-5ebe-9b1ad74a03e4@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com E31E530C426
In-Reply-To: <b1d02881-f522-8baa-5ebe-9b1ad74a03e4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org

On 05/22/2017 01:13 PM, Waiman Long wrote:
> On 05/19/2017 04:26 PM, Tejun Heo wrote:
>>> @@ -2982,22 +3010,48 @@ static int cgroup_enable_threaded(struct cgroup *cgrp)
>>>  	LIST_HEAD(csets);
>>>  	struct cgrp_cset_link *link;
>>>  	struct css_set *cset, *cset_next;
>>> +	struct cgroup *child;
>>>  	int ret;
>>> +	u16 ss_mask;
>>>  
>>>  	lockdep_assert_held(&cgroup_mutex);
>>>  
>>>  	/* noop if already threaded */
>>> -	if (cgrp->proc_cgrp)
>>> +	if (cgroup_is_threaded(cgrp))
>>>  		return 0;
>>>  
>>> -	/* allow only if there are neither children or enabled controllers */
>>> -	if (css_has_online_children(&cgrp->self) || cgrp->subtree_control)
>>> +	/*
>>> +	 * Allow only if it is not the root and there are:
>>> +	 * 1) no children,
>>> +	 * 2) no non-threaded controllers are enabled, and
>>> +	 * 3) no attached tasks.
>>> +	 *
>>> +	 * With no attached tasks, it is assumed that no css_sets will be
>>> +	 * linked to the current cgroup. This may not be true if some dead
>>> +	 * css_sets linger around due to task_struct leakage, for example.
>>> +	 */
>> It doesn't look like the code is actually making this (incorrect)
>> assumption.  I suppose the comment is from before
>> cgroup_is_populated() was added?
> Yes, it is a bug. I should have checked the tasks_count instead of using
> cgroup_is_populated. Thanks for catching that.

Sorry, I would like to take it back. I think cgroup_is_populated() will
be set if there is any task attached to the cgroup. So I think it is
doing the right thing with regard to (3).

Cheers,
Longman
