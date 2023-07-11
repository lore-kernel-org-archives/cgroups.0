From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4 0/9] cgroup/cpuset: Support remote partitions
Date: Mon, 10 Jul 2023 20:33:11 -0400
Message-ID: <305038a0-1db8-3d0d-3447-48be1f03d41c@redhat.com>
References: <20230627143508.1576882-1-longman@redhat.com>
 <ZKxzTrN2yiKfXndI@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689035598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2jCZmfZzjejGxfBXjkcFRYAyVQ6S1vH30csYuUaEOJU=;
        b=Vir5G9FA0zcka2wPLOucbm06WgO47HkZYR62ZNKhOJWbMiU8oaPTw9Lsyc7orGrZeU8+zs
        EPlozDn4GidPTjNyNSV7KT+87AFjNGJC2u3+ZxPt/nsnsBF/msdrKl47hVmQumo6yJsvkl
        yafBID8sv23oCUg5fynQn6IHMYGypSg=
Content-Language: en-US
In-Reply-To: <ZKxzTrN2yiKfXndI@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

On 7/10/23 17:08, Tejun Heo wrote:
> Hello, Waiman.
>
> I applied the prep patches. They look good on their own.
>
> On Tue, Jun 27, 2023 at 10:34:59AM -0400, Waiman Long wrote:
> ...
>> cpuset. Unlike "cpuset.cpus", invalid input to "cpuset.cpus.exclusive"
>> will be rejected with an error. This new control file has no effect on
> We cannot maintain this as an invariant tho, right? For example, what
> happens when a parent cgroup later wants to withdraw a CPU from its
> cpuset.cpus which should always be allowed regardless of what its
> descendants are doing? Even with cpus.exclusive itself, I think it'd be
> important to always allow ancestors to be able to withdraw from the
> commitment as with other resources. I suppose one can argue that giving
> exclusive access to CPUs is a special case which doesn't follow this rule
> but cpus.exclusive having to be nested inside cpus which is subject to that
> rule makes that combination too contorted.
>
> Would it be difficult to follow how isolation modes behave when the target
> configuration can't be achieved?

I would like to clarify that withdrawal of CPUs from 
cpuset.cpus.exclusive is always allowed. It is the addition of CPUs not 
presents in cpuset.cpus that will be rejected. The invariant is that 
cpuset.cpus.exclusive must always be a subset of cpuset.cpus. Any change 
that violates this rule is not allowed. Alternately I can silently 
dropped the offending CPUs without returning an error, but that may 
surprise users.

BTW, withdrawal of CPUs from cpuset.cpus will also withdraw them from 
cpuset.cpus.exclusive, if present. This allows the partition code to use 
cpuset.cpus.exclusive directly to determine the allowable exclusive CPUs 
without doing an intersection with cpuset.cpus each time it is used.

Please let me know if you want a different behavior.

Cheers,
Longman

