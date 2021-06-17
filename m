From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH 1/5] cgroup/cpuset: Don't call validate_change() for some
 flag changes
Date: Wed, 16 Jun 2021 22:53:44 -0400
Message-ID: <4e4da272-ae34-4ff8-18bc-253e9c14a14c@redhat.com>
References: <20210603212416.25934-1-longman@redhat.com>
 <20210603212416.25934-2-longman@redhat.com>
 <YMphhLAzmRRyD+cm@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623898432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yS1nM3ylxqu4LGWweeetnOJWhjHjFKRHgCRdFTmCJkE=;
        b=LWnI/2P1mWWpHcVVXlmMG6CZx5uMMQsX4C7mMkT7wbJrHDB5hLUxtEozVwEVi9cLiV31kb
        6triXbuKTG8jop3lH//iMvtvckh2Ofsml0ktiol6e/BzgJXsl67qQahFaftYWLZgWqIzJQ
        BQlIj6drWeh0dGWeQ4FD6erz9nc3JR4=
In-Reply-To: <YMphhLAzmRRyD+cm@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>

On 6/16/21 4:39 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Jun 03, 2021 at 05:24:12PM -0400, Waiman Long wrote:
>> The update_flag() is called with one flag bit change and without change
>> in the various cpumasks in the cpuset. Moreover, not all changes in the
>> flag bits are validated in validate_change().  In particular, the load
>> balance flag and the two spread flags are not checked there. So there
>> is no point in calling validate_change() if those flag bits change.
> The fact that it's escaping validation conditionally from caller side is
> bothersome given that the idea is to have self-contained verifier to ensure
> correctness. I'd prefer to make the validation more complete and optimized
> (ie. detect or keep track of what changed) if really necessary rather than
> escaping partially because certain conditions aren't checked.

Thanks for the comments.

You are right. I will leave out this patch. Anyway, the rests of the 
patchset don't have a strict dependency on it.

Cheers,
Longman

