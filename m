From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v5 4/5] cgroup/cpuset: Documentation update for partition
Date: Wed, 2 Aug 2023 21:08:01 -0400
Message-ID: <0c019181-7e9b-0a19-c477-f8630ea98124@redhat.com>
References: <20230713172601.3285847-1-longman@redhat.com>
 <20230713172601.3285847-5-longman@redhat.com>
 <ZMrERWeIeEOGzXHO@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691024888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yNCl3TS6o3J06UrSCjbBrl21cvR06Nfa+qdUrrTWUOw=;
        b=PPBygaoBGIN+RllqEOPGnP5lT+raEyRWb//MAQuh8KsENi8lJkffn8L3VgzOr3Qww13nPg
        qvJqMaFFukEvPzugBDjhdA77VJ6hGnT5ok/ahgMJw56wolc19NtSzGjG/yxVKLW3mPzphg
        6KKbw1tQj5HT8DYKGHsusJfptsqwtCI=
Content-Language: en-US
In-Reply-To: <ZMrERWeIeEOGzXHO@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Giuseppe Scrivano <gscrivan@redhat.com>

On 8/2/23 17:01, Tejun Heo wrote:
> Hello, Waiman.
>
> On Thu, Jul 13, 2023 at 01:26:00PM -0400, Waiman Long wrote:
> ...
>> +	When a valid partition is created, the value of this file will
>> +	be automatically set to the largest subset of "cpuset.cpus"
>> +	that can be granted for exclusive access from its parent if
>> +	its value isn't explicitly set before.
>> +
>> +	Users can also manually set it to a value that is different from
>> +	"cpuset.cpus".	In this case, its value becomes invariant and
>> +	may no longer reflect the effective value that is being used
>> +	to create a valid partition if some dependent cpuset control
>> +	files are modified.
>> +
>> +	There are constraints on what values are acceptable to this
>> +	control file.  If a null string is provided, it will invalidate a
>> +	valid partition root and reset its invariant state.  Otherwise,
>> +	its value must be a subset of the cgroup's "cpuset.cpus" value
>> +	and the parent cgroup's "cpuset.cpus.exclusive" value.
> As I wrote before, the hidden state really bothers me. This is fine when
> there is one person configuring the system, but working with automated
> management and monitoring tools can be really confusing at scale when there
> are hidden states like this as there's no way to determine the current state
> by looking at what's visible at the interface level.
>
> Can't we do something like the following?
>
> * cpuset.cpus.exclusive can be set to any possible cpus. While I'm not
>    completely against failing certain writes (e.g. siblings having
>    overlapping masks is never correct or useful), expanding that to
>    hierarchical checking quickly gets into trouble around what happens when
>    an ancestor retracts a CPU.
>
>    I don't think it makes sense to reject writes if the applied rules can't
>    be invariants for the same reason given for avoiding hidden states - the
>    system can be managed by multiple agents at different delegation levels.
>    One layer changing resource configuration shouldn't affect the success or
>    failure of configuration operations in other layers.
>
> * cpuset.cpus.exclusive.effective shows what's currently available for
>    exclusive usage - ie. what'd be used for a partition if the cgroup is to
>    become a partition at that point.
>
>    This, I think, gets rid of the need for the hidden states. If .exclusive
>    of a child of a partition is empty, its .exclusive.effective can show all
>    the CPUs allowed in it. If .exclusive is set then, .exclusive.effective
>    shows the available subset.
>
> What do you think?
>
Sure, I can add cpuset.cpus.exclusive.effective and allow users to set 
cpuset.cpus.exclusive to whatever they want, just like cpuset.cpus. I 
will rework the patch series and send out a new version sometimes next 
week.

With the new cpuset.cpus.exclusive.effective file, cpuset.cpus.exclusive 
will really be invariant and become whatever the users set. 
cpuset.cpus.exclusive.effective file will only have value if 
cpuset.cpus.exclusive set or it becomes a local partition.

Hopefully this will be the final version.

Cheers,
Longman

