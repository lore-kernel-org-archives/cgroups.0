From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 17:52:24 -0700
Message-ID: <b181f363-f66b-d74f-2251-c49877ac4b18@fb.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=RTeQWk2uEdnNz7G7Y/KJAeI2aPGMBpJrhLcIXKIx3Ls=;
 b=eUH/+QawHUtXDPUm8GIZeDcQUDGSa1FnL1qbfWGD+Xx/ssVlT3rklTD2uCY4rYiaCczh
 GMXcuTQ1Ad0I7Wf5ryWMLBUoO0tgUdxXZzxEK+xjDXnOp1VBe+rz4tE7wCuzygsRbTJe
 ObiUjybOiXXi/EurPhtFDVEVnTyh+cl3bps= 
Content-Language: en-US
In-Reply-To: <YofFli6UCX4J5YnU-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <>



On 5/20/22 9:45 AM, Tejun Heo wrote:
> Hello, Yonghong.
> 
> On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
>> Maybe you can have a bpf program signature like below:
>>
>> int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup *cgrp,
>> struct cgroup *parent_cgrp)
>>
>> parent_cgrp is NULL when cgrp is the root cgroup.
>>
>> I would like the bpf program should send the following information to
>> user space:
>>     <parent cgroup dir name> <current cgroup dir name>
> 
> I don't think parent cgroup dir name would be sufficient to reconstruct the
> path given that multiple cgroups in different subtrees can have the same
> name. For live cgroups, userspace can find the path from id (or ino) without
> traversing anything by constructing the fhandle, open it open_by_handle_at()
> and then reading /proc/self/fd/$FD symlink -
> https://lkml.org/lkml/2020/12/2/1126. This isn't available for dead cgroups
> but I'm not sure how much that'd matter given that they aren't visible from
> userspace anyway.

passing id/ino to user space and then get directory name in userspace
should work just fine.

> 
>>     <various stats interested by the user>
>>
>> This way, user space can easily construct the cgroup hierarchy stat like
>>                             cpu   mem   cpu pressure   mem pressure ...
>>     cgroup1                 ...
>>        child1               ...
>>          grandchild1        ...
>>        child2               ...
>>     cgroup 2                ...
>>        child 3              ...
>>          ...                ...
>>
>> the bpf iterator can have additional parameter like
>> cgroup_id = ... to only call bpf program once with that
>> cgroup_id if specified.
>>
>> The kernel part of cgroup_iter can call cgroup_rstat_flush()
>> before calling cgroup_iter bpf program.
>>
>> WDYT?
> 
> Would it work to just pass in @cgrp and provide a group of helpers so that
> the program can do whatever it wanna do including looking up the full path
> and passing that to userspace?

I am not super familiar with cgroup internals, I guess with cgroup + 
helpers to retrieve stats, or directly expose stats data structure
to bpf program. Either one is okay to me as long as we can get
desired results.

> 
> Thanks.
> 
