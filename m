From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 0/6] Backport rework of deadline bandwidth restoration for
 5.10.y
Date: Sun, 20 Aug 2023 12:24:33 -0400
Message-ID: <883a5a4f-b34e-689c-2fbd-7bf03db532eb@redhat.com>
References: <20230820152144.517461-1-qyousef@layalina.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692548683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LTIIx7UvbdXxFhLIfELCeFcfxNRehzpT464zSPyQ1Nc=;
        b=I4QGbJwgxrqg7W8nQY0Czb1vHfAHboztEBAd/aDBFXAjFBC2cot8E+SWKLC/qNX7FugPHv
        g0ta0rDHJHhFYfMrwRez5UxItpdKMyp+JgE8fBmZuXcRrRnqXeXxSFzmMYDtufhFiZtxoA
        /6d07RpaiY3BAInoaHytP8+AUSQXuC8=
Content-Language: en-US
In-Reply-To: <20230820152144.517461-1-qyousef@layalina.io>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Qais Yousef <qyousef@layalina.io>, stable@vger.kernel.org
Cc: Juri Lelli <juri.lelli@redhat.com>, Tejun Heo <tj@kernel.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Peter Zijlstra <peterz@infradead.org>, Vincent Guittot <vincent.guittot@linaro.org>, Ingo Molnar <mingo@kernel.org>, Hao Luo <haoluo@google.com>, John Stultz <jstultz@google.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


On 8/20/23 11:21, Qais Yousef wrote:
> This is a backport of the series that fixes the way deadline bandwidth
> restoration is done which is causing noticeable delay on resume path. It also
> converts the cpuset lock back into a mutex which some users on Android too.
> I lack the details but AFAIU the read/write semaphore was slower on high
> contention.

Note that it was a percpu rwsem before this patch series. It was not a 
regular rwsem. Percpu rwsem isn't designed to handle high write lock 
contention. A regular rwsem should be similar to mutex in performance 
when handling high write lock contention.

Cheers,
Longman

