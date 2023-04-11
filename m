From: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: Re: [PATCH v4] mm: oom: introduce cpuset oom
Date: Tue, 11 Apr 2023 21:04:18 +0800
Message-ID: <aa3382b4-4046-988f-42ea-8812dba7882b@bytedance.com>
References: <20230411065816.9798-1-ligang.bdlg@bytedance.com>
 <3myr57cw3qepul7igpifypxx4xd2buo2y453xlqhdw4xgjokc4@vi3odjfo3ahc>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681218264;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TZUxjOTN3EEVrgEvX6fomzktb865tnCcQCLiDPcQhKI=;
        b=i5JVHa5eM9KbQAKWODGWgoGm8LPXMSkBcQk0PHI3WSU6doos8dY3Jdj27hKGayaVka
         Nyxor8+0DirCbLUdnpgXe6e/OvT6Y3DNmSlM3KvuyBvNlVvtatXcJt7DQ1oH7wx4x2EI
         rvWneewVZL4FIVDgP7JYRH4AWs8kHIAAhzRlt0xLvFIn+iZHhb6xelC51sIQ9yDi0K1N
         /K9eTKj3lYhrPuxELIq7vLoDzhc1C6WmpDonYb0BJCGPJrx8guObqyAqQDO/RPydGVgV
         EFAvOY83IlO434GmAkUT8YJ6cxeQ8HWch3zrSVBKhuM3ddVPMwAngocF5fsQ9I+luQA1
         njQg==
Content-Language: en-US
In-Reply-To: <3myr57cw3qepul7igpifypxx4xd2buo2y453xlqhdw4xgjokc4@vi3odjfo3ahc>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2023/4/11 20:23, Michal Koutn=C3=BD wrote:
> Hello.
>=20
> On Tue, Apr 11, 2023 at 02:58:15PM +0800, Gang Li <ligang.bdlg-EC8Uxl6Npy=
dl57MIdRCFDg@public.gmane.org> wrote:
>> +	cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
>> +		if (nodes_equal(cs->mems_allowed, task_cs(current)->mems_allowed)) {
>> +			css_task_iter_start(&(cs->css), CSS_TASK_ITER_PROCS, &it);
>> +			while (!ret && (task =3D css_task_iter_next(&it)))
>> +				ret =3D fn(task, arg);
>> +			css_task_iter_end(&it);
>> +		}
>> +	}
>> +	rcu_read_unlock();
>> +	cpuset_read_unlock();
>> +	return ret;
>> +}
>=20
> I see this traverses all cpusets without the hierarchy actually
> mattering that much. Wouldn't the CONSTRAINT_CPUSET better achieved by
> globally (or per-memcg) scanning all processes and filtering with:

Oh I see, you mean scanning all processes in all cpusets and scanning
all processes globally are equivalent.

> 	nodes_intersect(current->mems_allowed, p->mems_allowed

Perhaps it would be better to use nodes_equal first, and if no suitable
victim is found, then downgrade to nodes_intersect?

NUMA balancing mechanism tends to keep memory on the same NUMA node, and
if the selected victim's memory happens to be on a node that does not
intersect with the current process's node, we still won't be able to
free up any memory.

In this example:

A->mems_allowed: 0,1
B->mems_allowed: 1,2
nodes_intersect(A->mems_allowed, B->mems_allowed) =3D=3D true

Memory Distribution:
+=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D+
| Node0 | Node1 | Node2 |
+=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D+
| A     |       |       |
+-------+-------+-------+
|       |       |B      |
+-------+-------+-------+

Process A invoke oom, then kill B.
But A still can't get any free mem on Node0 and 1.

> (`current` triggers the OOM, `p` is the iterated task)
> ?
>=20
> Thanks,
> Michal
