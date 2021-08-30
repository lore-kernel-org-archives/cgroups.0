From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v7 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 30 Aug 2021 19:59:43 +0200
Message-ID: <YS0cj+0thCHmXw/M@blackbook>
References: <20210825213750.6933-1-longman@redhat.com>
 <20210825213750.6933-6-longman@redhat.com>
 <YSfQ0mYWs2zUyqGY@mtj.duckdns.org>
 <32e27fcc-32f1-b26c-ae91-9e03f7e433af@redhat.com>
 <YShjb2WwvuB4s4gX@slm.duckdns.org>
 <d22ea3be-2429-5923-a80c-5af3b384def9@redhat.com>
 <YSlY0H/qeXQIGOfk@slm.duckdns.org>
 <392c3724-f583-c7fc-cfa1-a3f1665114c9@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630346385; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fjtm8tVefXUCT0rdTzMn/o5zpc91NrF6pXy1z50nDUM=;
        b=TyI+3u+QEneileBnDmwJhe/7GU/cZ4f+Sj8PsvZ9ugakdDVaT8ur0+WioUJKotS8fyURo0
        Mm12eWM1b0hCFWGb0F0M+ECUj56MCl6ARx+3TzD2Y8ZHaqgpxOq8DgRVIyvlvXxef349Py
        dUMXeDS74InyxljMGcbhds/MtAMoLJk=
Content-Disposition: inline
In-Reply-To: <392c3724-f583-c7fc-cfa1-a3f1665114c9@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

Hello.

On Fri, Aug 27, 2021 at 06:50:10PM -0400, Waiman Long <llong@redhat.com> wrote:
> So the new rules will be:

When I followed the thread, it seemed to me you're talking past each
other a bit. I'd suggest the following terminology:

- config space: what's written by the user and saved,

- reality space: what's currently available (primarily subject to
  on-/offlinng but I think it'd be helpful to consider here also what's
  given by the parent),

- effect space: what's actually possible and happening.

Not all elements of config_space x reality_space (Cartesian product) can
be represented in the effect_space (e.g. root partition with no
(effective) cpus).

IIUC, Waiman's "high bar" is supposed to be defined over transitions in
the config_space. However, there can be independent changes in the
reality_space so the rules should be actually formulated in the
effect_space:

The conditions for being a valid partition root rewritten into the effect
space:

> 1) The "cpuset.cpus" is not empty and the list of CPUs are exclusive.
- effective CPUs are non-empty and exclusive wrt siblings
- (E.g. setting empty cpuset.cpus might be possible but it invalidates
  the partition root, same as offlining or removal by an ancestor.)

> 2) The parent cgroup is a partition root (can be an invalid one).
- parent cgroup is a (valid) partition
- (Being valid partition means owning "stolen" cpus from the parent, if
  the parent is not valid partition itself, you can't steal what is not
  owned.)
- (And I think it's OK that: "the child partitions will stay invalid
  forever unless the parent become a valid partition again" [1].)

> 3) The "cpuset.cpus" is a subset of the parent's cpuset.cpus.allowed.
- I'm not sure what is the use of this condition (together with the
  rewrite of the 1st condition which covers effective cpus). I think it
  would make sense if being a valid parition root guaranteed that all
  configured cpuset.cpus will be available, however, that's not the case
  IIUC (e.g. due to offlining).

> 4) No child cgroup with cpuset enabled.
- A child cgroup with cpuset enabled is OK in the effect space
  (achievable by switching first and creating children later).
- For technical reasons this may be a condition on the transitions in
  the config_space.

Generally, most config changes should succeed and user should check (or
watch) how they landed in combination with the reality_space.

Regards,
Michal

[1] This follows the general model where ancestors can "preempt"
resources from their subtree.
