From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4 0/9] cgroup/cpuset: Support remote partitions
Date: Mon, 10 Jul 2023 21:38:12 -0400
Message-ID: <c0fb6438-8d19-9d75-d717-68f047465332@redhat.com>
References: <20230627143508.1576882-1-longman@redhat.com>
 <ZKxzTrN2yiKfXndI@slm.duckdns.org>
 <305038a0-1db8-3d0d-3447-48be1f03d41c@redhat.com>
 <ZKypl8cr3jxiZ6bo@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689039499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CgrK8riab39mc/l4RMQ9kP4UiPJ/E6e+0z17cQMh7m8=;
        b=TIox/Zy/4H4PFWovFcmrkpQ7xB1CAlXGXz+ecaGoJCCYiRXMoI6bfa8DEJKtV/4Qak9bSG
        FOMgXfcYlTqwusOVU+BeuxH9zxhBSZFib9hUt9VIb/RnfG7eYHABmR4G/WQ4N2bxZMZtBR
        ArjA9Xt5Vx1APa+27pb9rCfbCKwAaVg=
Content-Language: en-US
In-Reply-To: <ZKypl8cr3jxiZ6bo@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

On 7/10/23 21:00, Tejun Heo wrote:
> Hello,
>
> On Mon, Jul 10, 2023 at 08:33:11PM -0400, Waiman Long wrote:
>> I would like to clarify that withdrawal of CPUs from cpuset.cpus.exclusive
>> is always allowed. It is the addition of CPUs not presents in cpuset.cpus
>> that will be rejected. The invariant is that cpuset.cpus.exclusive must
>> always be a subset of cpuset.cpus. Any change that violates this rule is not
>> allowed. Alternately I can silently dropped the offending CPUs without
>> returning an error, but that may surprise users.
> Right, that'd be confusing.
>
>> BTW, withdrawal of CPUs from cpuset.cpus will also withdraw them from
>> cpuset.cpus.exclusive, if present. This allows the partition code to use
>> cpuset.cpus.exclusive directly to determine the allowable exclusive CPUs
>> without doing an intersection with cpuset.cpus each time it is used.
> This is kinda confusing too, I think. Changing cpuset.cpus in an ancestor
> doesn't affect the contents of the descendants' cpuset.cpus files but would
> directly modify the contents of their cpuset.cpus.exclusive files.
>
> There's some inherent friction because cpuset.cpus separates configuration
> (cpuset.cpus) and the current state (cpuset.cpus.effective) while
> cpuset.cpus.exclusive is trying to do both in the same interface file. When
> the two behavior modes collide, it becomes rather confusing. Do you think
> it'd make sense to make cpus.exclusive follow the same pattern as
> cpuset.cpus?

I don't want to add another cpuset.cpus.exclusive.effective control 
file. One possibility is to keep another effective masks in the struct 
cpuset and list both exclusive cpus set by the user and the effective 
ones side by side, like "<cpus> (<effective_cpus>)" if they differ or 
some other format. What do you think?

Regards,
Longman

