From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v7 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Fri, 27 Aug 2021 17:19:31 -0400
Message-ID: <d22ea3be-2429-5923-a80c-5af3b384def9@redhat.com>
References: <20210825213750.6933-1-longman@redhat.com>
 <20210825213750.6933-6-longman@redhat.com> <YSfQ0mYWs2zUyqGY@mtj.duckdns.org>
 <32e27fcc-32f1-b26c-ae91-9e03f7e433af@redhat.com>
 <YShjb2WwvuB4s4gX@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630099177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U1joG16srsSQx+ASNF6WUB8jVFgT0G7DpTPaFt49UTk=;
        b=DXN2dRTvX6QWbIqjQ9YAAcbsKUkSYxZZs4me7wK1rdCY994MdltPNBtRk60TKmtCOAK5ro
        1dWlFe5ePx8kdJ//XpMUuw3uta9uQr7OapSjqPUwvZHnd4yMgjQmsmWvbk9UNDYKid6BLk
        iaFB83vgdb7LYx4hdC3qK4TXtVbcrZ0=
In-Reply-To: <YShjb2WwvuB4s4gX@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Waiman Long <llong@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 8/27/21 12:00 AM, Tejun Heo wrote:
> Hello,
>
> On Thu, Aug 26, 2021 at 11:01:30PM -0400, Waiman Long wrote:
>> What I am doing here is setting a high bar for transitioning from member to
>> either "root" or "isolated". Once it becomes a partition, there are multiple
>> ways that can make it invalid. I am fine with that. However, I am not sure
>> it is a good idea to allow users to echo "root" to cpuset.cpus.partition
>> anywhere in the cgroup hierarchy and require them to read it back to see if
>> it succeed.
> The problem is that the "high" bar is rather arbitrary. It might feel like a
> good idea to some but not to others. There are no clear technical reasons or
> principles for rules to be set this particular way.
>
>> All the checking are done with cpuset_rwsem held. So there shouldn't be any
>> racing. Of course, a hotplug can immediately follow and make the partition
>> invalid.
> Imagine a system which dynamically on/offlines its cpus based on load or
> whatever and also configures partitions for cases where the needed cpus are
> online. If the partitions are set up while the cpus are online, it'd work as
> expected - partitions are in effect when the system can support them and
> ignored otherwise. However, if the partition configuration is attempted
> while the cpus happen to be offline, the configuration will fail, and there
> is no guaranteed way to make that configuration stick short of disabling
> hotplug operations. This is a pretty jarring brekage happening exactly
> because the behavior is an inconsistent amalgam.
>
> It's usually not a good sign if interface restrictions can be added or
> removed because how one feels without clear functional reasons and often
> indicates that there's something broken, which seems to be the case here
> too.

Well, that is a valid point. The cpus may have been offlined when a 
partition is being created. I can certainly relent on this check in 
forming a partition. IOW, cpus_allowed can contain some or all offline 
cpus and a valid (some are online) or invalid (all are offline) 
partition can be formed. I can also allow an invalid child partition to 
be formed with an invalid parent partition. However, the cpu exclusivity 
rules will still apply.

Other than that, do you envision any other circumstances where we should 
allow an invalid partition to be formed?

Cheers,
Longman


