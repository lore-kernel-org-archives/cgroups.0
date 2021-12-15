From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v9 3/7] cgroup/cpuset: Refining features and constraints
 of a partition
Date: Wed, 15 Dec 2021 11:29:41 -0500
Message-ID: <98887e63-51de-f5ad-8fb8-56269aaf4bcf@redhat.com>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-4-longman@redhat.com>
 <20211215144944.GE16798@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639585790;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yxhcniv4Juf9tUgebwGdqHHxd7keYoCASjyNhDtoduY=;
        b=gI8ESY4cyiR0X5xovd+kC+eahAE9gNGGgKypPnjGw/X97357HLoNhD9zIeEqcUDVKmD7o/
        DxjAbPE7sMkmdS4nuZvuMOkGAZ4fQ5u8bM9tCeF07r6hGn5MfLDNQSV30yJ8/23s0JFM2V
        55CBFUnAmP6GkLLH/PEJ0UXLqXT2pn8=
Content-Language: en-US
In-Reply-To: <20211215144944.GE16798@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>


On 12/15/21 09:49, Michal Koutn=C3=BD wrote:
> On Sun, Dec 05, 2021 at 01:32:16PM -0500, Waiman Long <longman@redhat.com=
> wrote:
>> @@ -1455,34 +1450,16 @@ static void update_cpumasks_hier(struct cpuset *=
cs, struct tmpmasks *tmp)
>>   			switch (parent->partition_root_state) {
>> [...]
>> -
>>   			case PRS_ENABLED:
>> -				if (update_parent_subparts_cpumask(cp, partcmd_update, NULL, tmp))
>> -					update_tasks_cpumask(parent);
>> +				update_parent =3D true;
>> [...]
>> +		if (update_parent) {
>> +			if (update_parent_subparts_cpumask(cp, partcmd_update, NULL, tmp))
>> +				update_tasks_cpumask(parent);
>> +			/*
>> +			 * The cpuset partition_root_state may be changed
>> +			 * to PRS_ERROR. Capture it.
>> +			 */
>> +			new_prs =3D cp->partition_root_state;
>> +		}
> IIUC, this ensures that when a parent becomes partition root again, this
> would propagate downwards to invalidated children.
>
> However, the documentation says:
>
>> +       Changing a partition root (valid or invalid) to "member" is
>> +       always allowed.  If there are child partition roots underneath
>> +       it, they will become invalid and unrecoverable.  So care must
>> +       be taken to double check for this condition before disabling
>> +       a partition root.
> I.e. it suggests a child can be trapped in the unrecoverable state (i.e.
> not fixable by writing into cpuset.cpus.partition).
> But this does not happen, right?

There are additional checks for the member to partition transition which=20
requires that the target cpuset shouldn't have child cpuset. That=20
prevents the recovering of a invalid partition root under a member=20
cpuset. We could certainly remove that restriction by adding additional=20
code as well as additional tests to verify it works. I haven't done that=20
simply to avoid adding more complexity to the current code.

Cheers,
Longman

