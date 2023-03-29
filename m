From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 6/7] cgroup/cpuset: Protect DL BW data against parallel
 cpuset_attach()
Date: Wed, 29 Mar 2023 12:05:20 -0400
Message-ID: <0eae9e7c-8bfc-6e89-c4ad-e1cd40ec03b5@redhat.com>
References: <20230329125558.255239-1-juri.lelli@redhat.com>
 <20230329160240.2093277-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680105928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BK4E10sij+UjBr4h6hMh56nRJwsX+E/yiWATUoPCWNU=;
        b=A1Z6QAD8mwzAEuiqGjwBXcJt8T04RhYf9xMsoFjxa+MzOOW8peDIivymCBWgZEoaOJcn5Z
        pZYFEqDcPQoAlBqfHLa5VICq3Xu47kDfo8TKcSxUuU2OYCjfJdtwBVBmo3Zp0PRXsk9h9P
        nsMnS89Toz/40Jz6CmRKuIycXBikYPA=
Content-Language: en-US
In-Reply-To: <20230329160240.2093277-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Juri Lelli <juri.lelli@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Qais Yousef <qyousef@layalina.io>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Sudeep Holla <sudeep.holla@arm.com>

On 3/29/23 12:02, Waiman Long wrote:
> It is possible to have parallel attach operations to the same cpuset in
> progress. To avoid possible corruption of single set of DL BW data in
> the cpuset structure, we have to disallow parallel attach operations if
> DL tasks are present. Attach operations can still proceed in parallel
> as long as no DL tasks are involved.
>
> This patch also stores the CPU where DL BW is allocated and free that BW
> back to the same CPU in case cpuset_can_attach() is called.
>
> Signed-off-by: Waiman Long <longman@redhat.com>

Juri, this patch is an addendum to your series to address the issues 
that I found from the cpuset point of view.

Cheers,
Longman

