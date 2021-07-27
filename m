From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v3 0/9] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Tue, 27 Jul 2021 17:14:27 -0400
Message-ID: <b2f49b2e-d5a4-1504-bd0c-0bd82943d855@redhat.com>
References: <20210720141834.10624-1-longman@redhat.com>
 <YP9ChFvrGrDMGzbe@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627420471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HTTYyPAE0g/if8d0gvKRc9AYw/duV58RDsVIEQdGHsg=;
        b=MmkBaBOuV1AUKpXcAGXaLo/TeoW4gQqCDymf0l637stY7WqPGA86SYbuh+wtcQ7hpYt7MT
        hUTp6iLOSanU7p/9clCUsJ64XRMc4aaHAO4uHlGU6ffxKiELIorxd9ypOLe7sYtp8sfOpx
        n04zqWTT+p13i3Tbjb2ksU5G5lD4PYQ=
In-Reply-To: <YP9ChFvrGrDMGzbe@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 7/26/21 7:17 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Jul 20, 2021 at 10:18:25AM -0400, Waiman Long wrote:
>> v3:
>>   - Add two new patches (patches 2 & 3) to fix bugs found during the
>>     testing process.
>>   - Add a new patch to enable inotify event notification when partition
>>     become invalid.
>>   - Add a test to test event notification when partition become invalid.
> I applied parts of the series. I think there was a bit of miscommunication.
> I meant that we should use the invalid state as the only way to indicate
> errors as long as the error state is something which can be reached through
> hot unplug or other uncontrollable changes, and require users to monitor the
> state transitions for confirmation and error handling.

Yes, that is the point of adding the event notification patch.

In the current code, direct write to cpuset.cpus.partition are strictly 
controlled and invalid transitions are rejected. However, changes to 
cpuset.cpus that do not break the cpu exclusivity rule or cpu hot plug 
may cause a partition to changed to invalid. What is currently done in 
this patchset is to add extra guards to reject those cpuset.cpus change 
that cause the partition to become invalid since changes that break cpu 
exclusivity rule will be rejected anyway. I can leave out those extra 
guards and allow those invalid cpuset.cpus change to go forward and 
change the partition to invalid instead if this is what you want.

However, if we have a complicated partition setup with multiple child 
partitions. Invalid cpuset.cpus change in a parent partition will cause 
all the child partitions to become invalid too. That is the scenario 
that I don't want to happen inadvertently. Alternatively, we can 
restrict those invalid changes if a child partition exist and let it 
pass through and make it invalid if it is a standalone partition.

Please let me know which approach do you want me to take.

Cheers,
Longman



