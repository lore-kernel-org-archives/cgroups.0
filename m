From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 09:29:43 -0700
Message-ID: <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fGsFNDkNpkR6u/tuKX6mNBPRx9n46xT/nZMY0JZx3HE=;
 b=lHu7coBS/AJOnzW88jaIAct8BD0AW9O6nfHUuSnAooLwH4jc+9zGJtF1FsJUOLeH1PA5
 uLfKhGeakcZd9ZVnZMN+3yRf0rBRlCSLw/2wnHSfVwNBaGU8ht5+ZaziCGGXDokam7hn
 mEehEMRHz3jtJ4UjDqqK7gmooGYIIKRE/b8= 
Content-Language: en-US
In-Reply-To: <YodNLpxut+Zddnre@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yosry Ahmed <yosryahmed@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, Stanislav Fomichev <sdf@google.com>, David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Cgroups <cgroups@vg>



On 5/20/22 1:11 AM, Tejun Heo wrote:
> Hello,
> 
> On Fri, May 20, 2022 at 12:58:52AM -0700, Yosry Ahmed wrote:
>> On Fri, May 20, 2022 at 12:41 AM Tejun Heo <tj@kernel.org> wrote:
>>>
>>> On Fri, May 20, 2022 at 01:21:31AM +0000, Yosry Ahmed wrote:
>>>> From: Hao Luo <haoluo@google.com>
>>>>
>>>> Introduce a new type of iter prog: cgroup. Unlike other bpf_iter, this
>>>> iter doesn't iterate a set of kernel objects. Instead, it is supposed to
>>>> be parameterized by a cgroup id and prints only that cgroup. So one
>>>> needs to specify a target cgroup id when attaching this iter. The target
>>>> cgroup's state can be read out via a link of this iter.
>>>>
>>>> Signed-off-by: Hao Luo <haoluo@google.com>
>>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>>
>>> This could be me not understanding why it's structured this way but it keeps
>>> bothering me that this is adding a cgroup iterator which doesn't iterate
>>> cgroups. If all that's needed is extracting information from a specific
>>> cgroup, why does this need to be an iterator? e.g. why can't I use
>>> BPF_PROG_TEST_RUN which looks up the cgroup with the provided ID, flushes
>>> rstat, retrieves whatever information necessary and returns that as the
>>> result?
>>
>> I will let Hao and Yonghong reply here as they have a lot more
>> context, and they had previous discussions about cgroup_iter. I just
>> want to say that exposing the stats in a file is extremely convenient
>> for userspace apps. It becomes very similar to reading stats from
>> cgroupfs. It also makes migrating cgroup stats that we have
>> implemented in the kernel to BPF a lot easier.
> 
> So, if it were upto me, I'd rather direct energy towards making retrieving
> information through TEST_RUN_PROG easier rather than clinging to making
> kernel output text. I get that text interface is familiar but it kinda
> sucks in many ways.
> 
>> AFAIK there are also discussions about using overlayfs to have links
>> to the bpffs files in cgroupfs, which makes it even better. So I would
>> really prefer keeping the approach we have here of reading stats
>> through a file from userspace. As for how we go about this (and why a
>> cgroup iterator doesn't iterate cgroups) I will leave this for Hao and
>> Yonghong to explain the rationale behind it. Ideally we can keep the
>> same functionality under a more descriptive name/type.
> 
> My answer would be the same here. You guys seem dead set on making the
> kernel emulate cgroup1. I'm not gonna explicitly block that but would
> strongly suggest having a longer term view.
> 
> If you *must* do the iterator, can you at least make it a proper iterator
> which supports seeking? AFAICS there's nothing fundamentally preventing bpf
> iterators from supporting seeking. Or is it that you need something which is
> pinned to a cgroup so that you can emulate the directory structure?

The current bpf_iter for cgroup is for the google use case
per previous discussion. But I think a generic cgroup bpf iterator
should help as well.

Maybe you can have a bpf program signature like below:

int BPF_PROG(dump_vmscan, struct bpf_iter_meta *meta, struct cgroup 
*cgrp, struct cgroup *parent_cgrp)

parent_cgrp is NULL when cgrp is the root cgroup.

I would like the bpf program should send the following information to
user space:
    <parent cgroup dir name> <current cgroup dir name>
    <various stats interested by the user>

This way, user space can easily construct the cgroup hierarchy stat like
                            cpu   mem   cpu pressure   mem pressure ...
    cgroup1                 ...
       child1               ...
         grandchild1        ...
       child2               ...
    cgroup 2                ...
       child 3              ...
         ...                ...

the bpf iterator can have additional parameter like
cgroup_id = ... to only call bpf program once with that
cgroup_id if specified.

The kernel part of cgroup_iter can call cgroup_rstat_flush()
before calling cgroup_iter bpf program.

WDYT?

> 
> Thanks.
> 
