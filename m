From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Tue, 2 May 2023 17:26:17 -0400
Message-ID: <f2bd7b1e-190e-1d08-f085-b4cae36fb5be@redhat.com>
References: <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
 <1b8d9128-d076-7d37-767d-11d6af314662@redhat.com>
 <ZDdYOI9LB87ra2t_@slm.duckdns.org>
 <9862da55-5f41-24c3-f3bb-4045ccf24b2e@redhat.com>
 <226cb2da-e800-6531-4e57-cbf991022477@redhat.com>
 <ZDmFLfII8EUX_ocY@slm.duckdns.org>
 <c61ca9d0-c514-fb07-c2f2-3629e8898984@redhat.com>
 <ZDmOjeBVsIcgSLIV@slm.duckdns.org>
 <60ec12dc-943c-b8f0-8b6f-97c5d332144c@redhat.com>
 <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
 <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683062782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1zc7E43mDugyj5NEnd93trnYdgLQsKcvQy7NWFtl2VU=;
        b=KG2lhN2AgtHVgEv322yBE61gVbiyM/zDFhmt+Frp7/B8/jAXkUT6MVBgv8RUxZJk0mEVds
        Fpb2GS58C68EEO44yLHx3LYaEqHpsU0SrSTLEcAtTLp/7xT3bxEFIKIuXhaZffxusC/XT2
        Dlo+4bKflZourDkEFrmMGqnPCzeBeu8=
Content-Language: en-US
In-Reply-To: <jqkf7jkuyxqiupmxmdbmpnbpojub2pjsz3oogwncmwqdghlsgk@phsqzirmmlyl>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>

On 5/2/23 14:01, Michal Koutný wrote:
> Hello.
>
> The previous thread arrived incomplete to me, so I respond to the last
> message only. Point me to a message URL if it was covered.
>
> On Fri, Apr 14, 2023 at 03:06:27PM -0400, Waiman Long <longman@redhat.com> wrote:
>> Below is a draft of the new cpuset.cpus.reserve cgroupfs file:
>>
>>    cpuset.cpus.reserve
>>          A read-write multiple values file which exists on all
>>          cpuset-enabled cgroups.
>>
>>          It lists the reserved CPUs to be used for the creation of
>>          child partitions.  See the section on "cpuset.cpus.partition"
>>          below for more information on cpuset partition.  These reserved
>>          CPUs should be a subset of "cpuset.cpus" and will be mutually
>>          exclusive of "cpuset.cpus.effective" when used since these
>>          reserved CPUs cannot be used by tasks in the current cgroup.
>>
>>          There are two modes for partition CPUs reservation -
>>          auto or manual.  The system starts up in auto mode where
>>          "cpuset.cpus.reserve" will be set automatically when valid
>>          child partitions are created and users don't need to touch the
>>          file at all.  This mode has the limitation that the parent of a
>>          partition must be a partition root itself.  So child partition
>>          has to be created one-by-one from the cgroup root down.
>>
>>          To enable the creation of a partition down in the hierarchy
>>          without the intermediate cgroups to be partition roots,
> Why would be this needed? Owning a CPU (a resource) must logically be
> passed all the way from root to the target cgroup, i.e. this is
> expressed by valid partitioning down to given level.
>
>>          one
>>          has to turn on the manual reservation mode by writing directly
>>          to "cpuset.cpus.reserve" with a value different from its
>>          current value.  By distributing the reserve CPUs down the cgroup
>>          hierarchy to the parent of the target cgroup, this target cgroup
>>          can be switched to become a partition root if its "cpuset.cpus"
>>          is a subset of the set of valid reserve CPUs in its parent.
> level n
> `- level n+1
>     cpuset.cpus	// these are actually configured by "owner" of level n
>     cpuset.cpus.partition // similrly here, level n decides if child is a partition
>
> I.e. what would be level n/cpuset.cpus.reserve good for when it can
> directly control level n+1/cpuset.cpus?

In the new scheme, the available cpus are still directly passed down to 
a descendant cgroup. However, isolated CPUs (or more generally CPUs 
dedicated to a partition) have to be exclusive. So what the 
cpuset.cpus.reserve does is to identify those exclusive CPUs that can be 
excluded from the effective_cpus of the parent cgroups before they are 
claimed by a child partition. Currently this is done automatically when 
a child partition is created off a parent partition root. The new scheme 
will break it into 2 separate steps without the requirement that the 
parent of a partition has to be a partition root itself.

Cheers,
Longman

claimed by a partition and will be excluded from the effective_cpus of 
the parent

