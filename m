From: Gang Li <ligang.bdlg@bytedance.com>
Subject: Re: Re: Re: [PATCH v4] mm: oom: introduce cpuset oom
Date: Tue, 11 Apr 2023 21:17:27 +0800
Message-ID: <e6ff9768-f41d-553c-e858-1b244a461526@bytedance.com>
References: <20230411065816.9798-1-ligang.bdlg@bytedance.com>
 <3myr57cw3qepul7igpifypxx4xd2buo2y453xlqhdw4xgjokc4@vi3odjfo3ahc>
 <aa3382b4-4046-988f-42ea-8812dba7882b@bytedance.com>
 <ZDVcwuiu3rWEFiTE@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681219053;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NYzMqMQLWwJeC6OGUwmJWcqketmIRYbxIgkEUyuEFt4=;
        b=P1erKL2EU4UpxT3LNTe4A5/bZ8blCn0k9bzNo/S562ki4ed2xT7q7WtfsuY1bJt4rs
         X+hWnFXwZSOGMWe53hmqw4kufYfrMOQrJ0Bd8zld2rnQv0a9JIyOX9mii3aPzX3mAX2F
         HcLbqqUFZmx74vhjdKoyBNgwTuz838ddshZe2qotABo4tHJH1B8sqN/fq/b5Mb6M+u5u
         0LvNHchxcevPWHmxTzgk6xauQkC0R9cI6ZyJt+Zv9rVp0N8TZcaFBeNGTWHEKo6msBkI
         KERk1aC60cvZl3R3KieEsJZKgCwW9UoBCNMScvmIPUmywUUl2gVLQ4aiVpld2gEuyqcr
         jFfQ==
Content-Language: en-US
In-Reply-To: <ZDVcwuiu3rWEFiTE@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Michal Hocko <mhocko@suse.com>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com, Zefan Li <lizefan.x@bytedance.com>, linux-kernel@vger.kernel.org



On 2023/4/11 21:12, Michal Hocko wrote:
> On Tue 11-04-23 21:04:18, Gang Li wrote:
>>
>>
>> On 2023/4/11 20:23, Michal Koutn=C3=BD wrote:
>>> Hello.
>>>
>>> On Tue, Apr 11, 2023 at 02:58:15PM +0800, Gang Li <ligang.bdlg@bytedanc=
e.com> wrote:
>>>> +	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
>>>> +		if (nodes_equal(cs->mems_allowed, task_cs(current)->mems_allowed)) {
>>>> +			css_task_iter_start(&(cs->css), CSS_TASK_ITER_PROCS, &it);
>>>> +			while (!ret && (task =3D css_task_iter_next(&it)))
>>>> +				ret =3D fn(task, arg);
>>>> +			css_task_iter_end(&it);
>>>> +		}
>>>> +	}
>>>> +	rcu_read_unlock();
>>>> +	cpuset_read_unlock();
>>>> +	return ret;
>>>> +}
>>>
>>> I see this traverses all cpusets without the hierarchy actually
>>> mattering that much. Wouldn't the CONSTRAINT_CPUSET better achieved by
>>> globally (or per-memcg) scanning all processes and filtering with:
>>
>> Oh I see, you mean scanning all processes in all cpusets and scanning
>> all processes globally are equivalent.
>=20
> Why cannot you simple select a process from the cpuset the allocating
> process belongs to? I thought the whole idea was to handle well
> partitioned workloads.
>

Yes I can :) It's much easier.

>>> 	nodes_intersect(current->mems_allowed, p->mems_allowed
>>
>> Perhaps it would be better to use nodes_equal first, and if no suitable
>> victim is found, then downgrade to nodes_intersect?
>=20
> How can this happen?
>=20
>> NUMA balancing mechanism tends to keep memory on the same NUMA node, and
>> if the selected victim's memory happens to be on a node that does not
>> intersect with the current process's node, we still won't be able to
>> free up any memory.
>=20
> AFAIR NUMA balancing doesn't touch processes with memory policies.

