From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v11 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Sun, 12 Jun 2022 22:50:05 -0400
Message-ID: <23002f21-9dfb-31b4-c6c7-86f4e292dfea@redhat.com>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-4-longman@redhat.com>
 <YqYlCRywdgSYtwKk@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655088612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r5H0CNcahQjHmS/4jBwaskIQiBC4tSy1HTQWL7RLcJA=;
        b=PpSIueanvuGPrCF6lYAsYfLlt4TGbcGf1Zuh0ZGij9FPnHZBhIjhu7yA0G+Zi2CbMP2pS1
        Nr2JfaFwUX1ZDof9onsWRllC00P3F/L6i1iK6SXgA+BChmA7kH7CercoWQD2LIh6FU+rBj
        aRb4p3VLRt8FXHVWI2mDUxfeg1vESEw=
Content-Language: en-US
In-Reply-To: <YqYlCRywdgSYtwKk@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>


On 6/12/22 13:40, Tejun Heo wrote:
> Hello,
>
> Sorry about the long delay.
>
> On Tue, May 10, 2022 at 11:34:08AM -0400, Waiman Long wrote:
>> Once a partition with empty "cpuset.cpus.effective" is formed, no
>> new task can be moved into it until "cpuset.cpus.effective" becomes
>> non-empty.
> This is always true due to no-tasks-in-intermediate-cgroups requirement,
> right?

I seems to remember there are corner cases where a task can be moved to 
an intermediate cgroup under circumstances. I need to dig further to 
find out what it is.

Cheers,
Longman

