From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 0/5] cgroup/cpuset: A new "isolcpus" paritition
Date: Fri, 14 Apr 2023 15:06:27 -0400
Message-ID: <46d26abf-a725-b924-47fa-4419b20bbc02@redhat.com>
References: <e38f72aa-9705-cf0c-a565-fb790f16c53e@redhat.com>
 <ZDdG1K0kTETZMTCu@slm.duckdns.org>
 <cd4c3f92-4a01-e636-7390-8c6a3d0cfe6c@redhat.com>
 <ZDdNy2NAfj2_1CbW@slm.duckdns.org>
 <1b8d9128-d076-7d37-767d-11d6af314662@redhat.com>
 <ZDdYOI9LB87ra2t_@slm.duckdns.org>
 <9862da55-5f41-24c3-f3bb-4045ccf24b2e@redhat.com>
 <226cb2da-e800-6531-4e57-cbf991022477@redhat.com>
 <ZDmFLfII8EUX_ocY@slm.duckdns.org>
 <c61ca9d0-c514-fb07-c2f2-3629e8898984@redhat.com>
 <ZDmOjeBVsIcgSLIV@slm.duckdns.org>
 <60ec12dc-943c-b8f0-8b6f-97c5d332144c@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681499190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dkAMl7zGu0d47GwL2c/7Q7hgpJNswSuiV5ht7dE8kSA=;
        b=RTijqkqTM1yF69857H0nl10+IABH8jBP0U2d3bFfuSQvKEawMkE0VfsWo6TOxTzEXtrD9Z
        HVywdTRVLg11l7/TloWjs9zEw8DwXihu+PUsS7pJiyz3tsz0gMsb+6SNu2uPpZ56lczwNk
        rrX1YaXFikZj3+oojNxg6/1FT7YvfSc=
Content-Language: en-US
In-Reply-To: <60ec12dc-943c-b8f0-8b6f-97c5d332144c@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>

On 4/14/23 13:38, Waiman Long wrote:
> On 4/14/23 13:34, Tejun Heo wrote:
>> On Fri, Apr 14, 2023 at 01:29:25PM -0400, Waiman Long wrote:
>>> On 4/14/23 12:54, Tejun Heo wrote:
>>>> On Thu, Apr 13, 2023 at 09:22:19PM -0400, Waiman Long wrote:
>>>>> I now have a slightly different idea of how to do that. We already 
>>>>> have an
>>>>> internal cpumask for partitioning - subparts_cpus. I am thinking 
>>>>> about
>>>>> exposing it as cpuset.cpus.reserve. The current way of creating
>>>>> subpartitions will be called automatic reservation and require a 
>>>>> direct
>>>>> parent/child partition relationship. But as soon as a user write 
>>>>> anything to
>>>>> it, it will break automatic reservation and require manual 
>>>>> reservation going
>>>>> forward.
>>>>>
>>>>> In that way, we can keep the old behavior, but also support new 
>>>>> use cases. I
>>>>> am going to work on that.
>>>> I'm not sure I fully understand the proposed behavior but it does 
>>>> sound more
>>>> quirky.
>>> The idea is to use the existing subparts_cpus for cpu reservation 
>>> instead of
>>> adding a new cpumask for that purpose. The current way of partition 
>>> creation
>>> does cpus reservation (setting subparts_cpus) automatically with the
>>> constraint that the parent of a partition must be a partition root 
>>> itself.
>>> One way to relax this constraint is to allow a new manual 
>>> reservation mode
>>> where users can set reserve cpus manually and distribute them down the
>>> hierarchy before activating a partition to use those cpus.
>>>
>>> Now the question is how to enable this new manual reservation mode. 
>>> One way
>>> to do it is to enable it whenever the new cpuset.cpus.reserve file is
>>> modified. Alternatively, we may enable it by a cgroupfs mount option 
>>> or a
>>> boot command line option.
>> It'd probably be best if we can keep the behavior within cgroupfs if
>> possible. Would you mind writing up the documentation section 
>> describing the
>> behavior beforehand? I think things would be clearer if we look at it 
>> from
>> the interface documentation side.
>
> Sure, will do that. I need some time and so it will be early next week.

Just kidding :-)

Below is a draft of the new cpuset.cpus.reserve cgroupfs file:

   cpuset.cpus.reserve
         A read-write multiple values file which exists on all
         cpuset-enabled cgroups.

         It lists the reserved CPUs to be used for the creation of
         child partitions.  See the section on "cpuset.cpus.partition"
         below for more information on cpuset partition.  These reserved
         CPUs should be a subset of "cpuset.cpus" and will be mutually
         exclusive of "cpuset.cpus.effective" when used since these
         reserved CPUs cannot be used by tasks in the current cgroup.

         There are two modes for partition CPUs reservation -
         auto or manual.  The system starts up in auto mode where
         "cpuset.cpus.reserve" will be set automatically when valid
         child partitions are created and users don't need to touch the
         file at all.  This mode has the limitation that the parent of a
         partition must be a partition root itself.  So child partition
         has to be created one-by-one from the cgroup root down.

         To enable the creation of a partition down in the hierarchy
         without the intermediate cgroups to be partition roots, one
         has to turn on the manual reservation mode by writing directly
         to "cpuset.cpus.reserve" with a value different from its
         current value.  By distributing the reserve CPUs down the cgroup
         hierarchy to the parent of the target cgroup, this target cgroup
         can be switched to become a partition root if its "cpuset.cpus"
         is a subset of the set of valid reserve CPUs in its parent. The
         set of valid reserve CPUs is the set that are present in all
         its ancestors' "cpuset.cpus.reserve" up to cgroup root and
         which have not been allocated to another valid partition yet.

         Once manual reservation mode is enabled, a cgroup administrator
         must always set up "cpuset.cpus.reserve" files properly before
         a valid partition can be created. So this mode has more
         administrative overhead but with greater flexibility.

Cheers,
Longman

