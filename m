From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/5] cgroup/cpuset: Skip task update if hotplug doesn't
 affect current cpuset
Date: Tue, 14 Mar 2023 14:20:53 -0400
Message-ID: <176a4cfd-2902-16a2-b9e7-cb66e1c5b49c@redhat.com>
References: <20230306200849.376804-1-longman@redhat.com>
 <20230306200849.376804-2-longman@redhat.com>
 <20230314165030.beu2ywtvqa3p45ta@blackpad>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678818062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mZu0RzwIJilde3oJZLOmJNiQa9ScwZN4JDJCiFaDOu0=;
        b=fzjg0E2UfHFJbVqEnPqoPSzynwKZdmbEbuEz1e9/2QKr0AiA3zPKMpQ0uMUiaxuc997aoy
        EgV5koipdUBTSYJ2Fd6LnCI6Cp9p7WByUAl6eIEuEJfD50pW1QkrrWdXf3V8LjUGbFeNKs
        mV9eDzi/hFWj368GliV1UHBr+CBiYEQ=
Content-Language: en-US
In-Reply-To: <20230314165030.beu2ywtvqa3p45ta@blackpad>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>


On 3/14/23 12:50, Michal Koutn=C3=BD wrote:
> On Mon, Mar 06, 2023 at 03:08:45PM -0500, Waiman Long <longman@redhat.com=
> wrote:
>> If a hotplug event doesn't affect the current cpuset, there is no point
>> to call hotplug_update_tasks() or hotplug_update_tasks_legacy(). So
>> just skip it.
> This skips "insane" modification of cs->cpus_allowed in
> hotplug_update_tasks_legacy() but assuming cs->cpus_allowed is kept in
> sync with cs->effective_cpus on v1, it is OK to skip the update based
> only on effective_cpus check.

Yes, effective_cpus is equivalent to cpus_allowed in v1 unless you mount=20
the cpuset with the cpuset_v2_mode flag which will behave more like v2=20
where effective_cpus is still the key.

Cheers,
Longman

