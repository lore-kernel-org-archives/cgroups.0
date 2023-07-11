From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/9] cgroup/cpuset: Support remote partitions
Date: Mon, 10 Jul 2023 15:00:07 -1000
Message-ID: <ZKypl8cr3jxiZ6bo@slm.duckdns.org>
References: <20230627143508.1576882-1-longman@redhat.com>
 <ZKxzTrN2yiKfXndI@slm.duckdns.org>
 <305038a0-1db8-3d0d-3447-48be1f03d41c@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689037210; x=1691629210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iOeAkeIhbm63YH/6Gh4MSzxEDTnuHBi8ou4wGcdJFeM=;
        b=QCUFSSTuYfpZ4zZwxQRpvBHWwVt6JX2r4IaQWToH7ZnW53vdjoDh7gN1os71joy4CM
         WCD33PWj9Qn9jM4ckCcNXsxJ1CPVRzuOTB7VAabbKy3CGCk6p42MNquaIwRFww9tP8ax
         dn2jG4J5piZFk/emDQSQXbHAptZU0jKpXztCYa3P0qBfDSxsP3w+lP/kWJKSqY9THOUt
         W8pdf4e7FFt9H3itZ3WqcjwYEevNXyoCqCwspcLeDZqAH6AabUSFw1LNx6R+SpiwMhga
         o6nfXDNIU/o3RuD4GS2JH4AYYH9Hv+uUMJeCCMvJrPVRrPtI/Rj7HSH51WjI4OxP1czG
         ve7w==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <305038a0-1db8-3d0d-3447-48be1f03d41c@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

Hello,

On Mon, Jul 10, 2023 at 08:33:11PM -0400, Waiman Long wrote:
> I would like to clarify that withdrawal of CPUs from cpuset.cpus.exclusive
> is always allowed. It is the addition of CPUs not presents in cpuset.cpus
> that will be rejected. The invariant is that cpuset.cpus.exclusive must
> always be a subset of cpuset.cpus. Any change that violates this rule is not
> allowed. Alternately I can silently dropped the offending CPUs without
> returning an error, but that may surprise users.

Right, that'd be confusing.

> BTW, withdrawal of CPUs from cpuset.cpus will also withdraw them from
> cpuset.cpus.exclusive, if present. This allows the partition code to use
> cpuset.cpus.exclusive directly to determine the allowable exclusive CPUs
> without doing an intersection with cpuset.cpus each time it is used.

This is kinda confusing too, I think. Changing cpuset.cpus in an ancestor
doesn't affect the contents of the descendants' cpuset.cpus files but would
directly modify the contents of their cpuset.cpus.exclusive files.

There's some inherent friction because cpuset.cpus separates configuration
(cpuset.cpus) and the current state (cpuset.cpus.effective) while
cpuset.cpus.exclusive is trying to do both in the same interface file. When
the two behavior modes collide, it becomes rather confusing. Do you think
it'd make sense to make cpus.exclusive follow the same pattern as
cpuset.cpus?

Thanks.

-- 
tejun
