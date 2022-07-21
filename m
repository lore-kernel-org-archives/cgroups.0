From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v3 4/8] bpf: Introduce cgroup iter
Date: Thu, 21 Jul 2022 11:15:34 -0700
Message-ID: <6935de9f-49da-7703-55ae-241a8b838c6c@fb.com>
References: <20220709000439.243271-1-yosryahmed@google.com>
 <20220709000439.243271-5-yosryahmed@google.com>
 <370cb480-a427-4d93-37d9-3c6acd73b967@fb.com>
 <a6d048b8-d017-ea7e-36f0-1c4f88fc4399@fb.com>
 <CA+khW7gmVmXMg4YP4fxTtgqNyAr4mQqnXbP=z0nUeQ8=hfGC3g@mail.gmail.com>
 <2a26b45d-6fab-b2a2-786e-5cb4572219ea@fb.com>
 <CA+khW7jp+0AadVagqCcV8ELNRphP47vJ6=jGyuMJGnTtYynF+Q@mail.gmail.com>
 <3f3ffe0e-d2ac-c868-a1bf-cdf1b58fd666@fb.com>
 <CA+khW7ihQmjwGuVPCEuZ5EXMiMWWaxiAatmjpo1xiaWokUNRGw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=yenDaMJACw314ACpk5AfWcDFiqjGF+wzXyECwIp9jlo=;
 b=O9wpPQ3l+Dd0dqVVwJTULXVV/o4UVHB1l9kcH1pYv7kQHURM25po6pwDb+wUuYEzqYMG
 oXOkE/CrSLfVLnnTqJIxLr3upeamFuWfN71pb7CLCe/uTPmJKNgryp3D6i1NqQaGcf7+
 3hucQD319Vi7STrXzEfk60PyeoZOMcalxFc= 
Content-Language: en-US
In-Reply-To: <CA+khW7ihQmjwGuVPCEuZ5EXMiMWWaxiAatmjpo1xiaWokUNRGw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hao Luo <haoluo@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>, KP Singh <kpsingh@kernel.org>, Benjamin Tissoires <benjamin.tissoires@redhat.com>, John Fastabend <john.fastabend@gmail.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Stanislav Fomichev <sdf@google.com>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>



On 7/21/22 10:21 AM, Hao Luo wrote:
> On Thu, Jul 21, 2022 at 9:15 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 7/20/22 5:40 PM, Hao Luo wrote:
>>> On Mon, Jul 11, 2022 at 8:45 PM Yonghong Song <yhs@fb.com> wrote:
>>>>
>>>> On 7/11/22 5:42 PM, Hao Luo wrote:
>>> [...]
>>>>>>>> +
>>>>>>>> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
>>>>>>>> +{
>>>>>>>> +    struct cgroup_iter_priv *p = seq->private;
>>>>>>>> +
>>>>>>>> +    mutex_lock(&cgroup_mutex);
>>>>>>>> +
>>>>>>>> +    /* support only one session */
>>>>>>>> +    if (*pos > 0)
>>>>>>>> +        return NULL;
>>>>>>>
>>>>>>> This might be okay. But want to check what is
>>>>>>> the practical upper limit for cgroups in a system
>>>>>>> and whether we may miss some cgroups. If this
>>>>>>> happens, it will be a surprise to the user.
>>>>>>>
>>>>>
>>>>> Ok. What's the max number of items supported in a single session?
>>>>
>>>> The max number of items (cgroups) in a single session is determined
>>>> by kernel_buffer_size which equals to 8 * PAGE_SIZE. So it really
>>>> depends on how much data bpf program intends to send to user space.
>>>> If each bpf program run intends to send 64B to user space, e.g., for
>>>> cpu, memory, cpu pressure, mem pressure, io pressure, read rate, write
>>>> rate, read/write rate. Then each session can support 512 cgroups.
>>>>
>>>
>>> Hi Yonghong,
>>>
>>> Sorry about the late reply. It's possible that the number of cgroup
>>> can be large, 1000+, in our production environment. But that may not
>>> be common. Would it be good to leave handling large number of cgroups
>>> as follow up for this patch? If it turns out to be a problem, to
>>> alleviate it, we could:
>>>
>>> 1. tell users to write program to skip a certain uninteresting cgroups.
>>> 2. support requesting large kernel_buffer_size for bpf_iter, maybe as
>>> a new bpf_iter flag.
>>
>> Currently if we intend to support multiple read() for cgroup_iter,
>> the following is a very inefficient approach:
>>
>> in seq_file private data structure, remember the last cgroup visited
>> and for the second read() syscall, do the traversal again (but not
>> calling bpf program) until the last cgroup and proceed from there.
>> This is inefficient and probably works. But if the last cgroup is
>> gone from the hierarchy, that the above approach won't work. One
>> possibility is to remember the last two cgroups. If the last cgroup
>> is gone, check the 'next' cgroup based on the one before the last
>> cgroup. If both are gone, we return NULL.
>>
> 
> I suspect in reality, just remembering the last cgroup (or two
> cgroups) may not be sufficient. First, I don't want to hold
> cgroup_mutex across multiple sessions. I assume it's also not safe to
> release cgroup_mutex in the middle of walking cgroup hierarchy.
> Supporting multiple read() can be nasty for cgroup_iter.

Right, holding cgroup_mutex across sessions is not bad idea
and I didn't recommend it either.

I am aware of remembering last (one or two) cgroups are not
100% reliable. All other iters have similar issues w.r.t.
across multiple sessions. But the idea is to find a
*reasonable* start for the second and later session.
For example, for task related iter, the previous session
last tid can be remember and the next session starts
with next tid after last tid based on idr. Some old
processes might be gone, but we got a reasonable
approximation. But cgroup is different, holding
the cgroup pointer with an additional reference
across sessions is not good. but holding cgroup
id requires to traverse the cgroup hierarchy
again and this is not efficient. Maybe other people
has a better idea how to do this.

> 
>> But in any case, if there are additional cgroups not visited,
>> in the second read(), we should not return NULL which indicates
>> done with all cgroups. We may return EOPNOTSUPP to indicate there
>> are missing cgroups due to not supported.
>>
>> Once users see EOPNOTSUPP which indicates there are missing
>> cgroups, they can do more filtering in bpf program to avoid
>> large data volume to user space.
>>
> 
> Makes sense. Yonghong, one question to confirm, if the first read()
> overflows, does the user still get partial data?

Yes, the first read() and subsequent read()'s will be okay
until user space receives all 8KB data where 8KB is the
kernel buffer size. For example, if user provides 1KB buffer
size, the first 8 read() syscalls will return proper data
to user space.

After that, read() should return
EOPNOTSUPP instead of return 0 where '0' indicates
no more data.


> 
> I'll change the return code to EOPNOTSUPP in v4 of this patchset.
> 
>> To provide a way to truely visit *all* cgroups,
>> we can either use bpf_iter link_create->flags
>> to increase the buffer size as your suggested in the above so
>> user can try to allocate more kernel buffer size. Or implement
>> proper second read() traversal which I don't have a good idea
>> how to do it efficiently.
> 
> I will try the buffer size increase first. Looks more doable. Do you
> mind putting this support as a follow-up?

If we cannot finalize the solution to completely support
arbitrary user output for cgroup_iter, we need to support
EOPNOTSUPP so user knows it should adjust the bpf program
to have less data to user space through seq_file. For example,
they can put data into mmap-ed array map. Please explain
such a limitation and how to workaround this in commit
message clearly.

So yes, to support buffer size increase through link_create
flags or to support a better way to start iteration after 8KB
user data can be a followup.

> 
>>>
>>> Hao
>>>
>>>>>
>>> [...]
>>>>>>> [...]
