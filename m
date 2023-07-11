From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v4 8/9] cgroup/cpuset: Documentation update for partition
Date: Mon, 10 Jul 2023 23:24:37 -0400
Message-ID: <82aeb5aa-7d69-78dd-bb26-60a51dc8a839@redhat.com>
References: <20230627143508.1576882-1-longman@redhat.com>
 <20230627143508.1576882-9-longman@redhat.com>
 <ZKx4ZJowRhRtjZxB@slm.duckdns.org>
 <6d5aee58-f558-868c-76e0-0b58f8332110@redhat.com>
 <ZKyljsbJgLNpsBLI@slm.duckdns.org>
 <a429e60a-fc4f-60b0-3978-71596fed9542@redhat.com>
 <ZKyrP74UzVb4Ltwi@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689045883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bj1nFMlX6IrlygC3UiCib90ggxtKBa1bC1e3kuNGIGw=;
        b=ERZd20PHFlCLw41TA4Sm/fTbcFdPDLOEqHqg5R9wA5caotV0O8/W4HWqQe/WFbmf3G7M5j
        JqaSkRmDQ0B30IgV4JHmjHtC0XbVrzZ2VVFXC9LcoyHBP+x7zEwZUmwm4MJd9Tk584dOQ5
        p01bKcdUgeM9TD/RzF2h6PG14XT7uAg=
Content-Language: en-US
In-Reply-To: <ZKyrP74UzVb4Ltwi@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

On 7/10/23 21:07, Tejun Heo wrote:
> Hello,
>
> On Mon, Jul 10, 2023 at 08:53:18PM -0400, Waiman Long wrote:
>> For local partition, it doesn't make sense to have a cpust.cpus.exclusive
>> that is not the same as cpuset.cpus as it artificially reduce the set of
>> CPUs that can be used in a partition. In the case of a remote partition, the
> Yeah, I was wondering about local partitions. "Automatic but can be
> overridden" behavior becomes confusing if it's difficult for the user to
> easily tell which part is automatic when. I wonder whether it'd be better to
> make the condition static - e.g. for a partition cgroup, cpus.exclusive
> always contains all bits in cpus no matter what value is written to it. Or,
> if we separate out cpus.exclusive and cpus.exclusive.effective, no matter
> what cpus.exclusive is set, a partition root's cpus.exclusive.effective
> always includes all bits in cpus.effective.

With no offline CPUs, cpus.effective should be the same as 
cpus.exclusive.effective for a valid partition root. Here 
cpus.exclusive.effective is a bit different from cpus.effective as it 
can contain offline cpus. It also mean that adding 
cpus.exclusive.effective can be redundant.

As said before, I try to avoid adding new cpuset control file unless 
absolutely necessary. I now have a slight different proposal. Once 
manually set, I can keep cpuset.cpus.exclusive invariant. I do need to 
do a bit more work when enabling a partition root to find out the 
effective set of exclusive CPUs to be used or make the partition invalid 
if no exclusive CPU is available. I still want to do a initial check 
when setting cpuset.cpus.exclusive to make sure that the value is at 
least valid at the beginning.

Do you think this is an acceptable compromise?

Thanks,
Longman

