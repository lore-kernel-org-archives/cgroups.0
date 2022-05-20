From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Date: Fri, 20 May 2022 09:16:08 -0700
Message-ID: <eca39189-9258-b1cc-0a1d-a0d7e6027861@fb.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com>
 <fa3b35a6-5c3c-42a1-23f0-a8143b4eaa57@fb.com>
 <CAJD7tkanipJ7-9H_L6KMUjpD2qS29-YCrnMXw+8BAKfbOk5P9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GdUOKWmVt9m0KIJSZ3CC+cIpGap1EgsTEd69z2s+Ykc=;
 b=LtbSbSLjETccjyBS8U6yxSUHMti+13Ht/251D63BsG/k13ut24a02Z3GB1cRSy2PmZ7V
 ekEj8B2wdup4VCCQAW5Tfd3fxUzS6kRxcBs3wCPGga4jnuFDUa7GHu8hSNhvwxZdlehz
 +ce90Bz5WS8cnAu2sjVLxMtxab0UTeiHzWc= 
Content-Language: en-US
In-Reply-To: <CAJD7tkanipJ7-9H_L6KMUjpD2qS29-YCrnMXw+8BAKfbOk5P9Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>



On 5/20/22 9:08 AM, Yosry Ahmed wrote:
> On Fri, May 20, 2022 at 8:15 AM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>>
>>
>>
>> On 5/19/22 6:21 PM, Yosry Ahmed wrote:
>>> Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
>>> tracing programs. bpf programs that make use of rstat can use these
>>> functions to inform rstat when they update stats for a cgroup, and when
>>> they need to flush the stats.
>>>
>>> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>    kernel/cgroup/rstat.c | 35 ++++++++++++++++++++++++++++++++++-
>>>    1 file changed, 34 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
>>> index e7a88d2600bd..a16a851bc0a1 100644
>>> --- a/kernel/cgroup/rstat.c
>>> +++ b/kernel/cgroup/rstat.c
>>> @@ -3,6 +3,11 @@
>>>
>>>    #include <linux/sched/cputime.h>
>>>
>>> +#include <linux/bpf.h>
>>> +#include <linux/btf.h>
>>> +#include <linux/btf_ids.h>
>>> +
>>> +
>>>    static DEFINE_SPINLOCK(cgroup_rstat_lock);
>>>    static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
>>>
>>> @@ -141,7 +146,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
>>>        return pos;
>>>    }
>>>
>>> -/* A hook for bpf stat collectors to attach to and flush their stats */
>>> +/*
>>> + * A hook for bpf stat collectors to attach to and flush their stats.
>>> + * Together with providing bpf kfuncs for cgroup_rstat_updated() and
>>> + * cgroup_rstat_flush(), this enables a complete workflow where bpf progs that
>>> + * collect cgroup stats can integrate with rstat for efficient flushing.
>>> + */
>>>    __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
>>>                                     struct cgroup *parent, int cpu)
>>>    {
>>> @@ -476,3 +486,26 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
>>>                   "system_usec %llu\n",
>>>                   usage, utime, stime);
>>>    }
>>> +
>>> +/* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush() */
>>> +BTF_SET_START(bpf_rstat_check_kfunc_ids)
>>> +BTF_ID(func, cgroup_rstat_updated)
>>> +BTF_ID(func, cgroup_rstat_flush)
>>> +BTF_SET_END(bpf_rstat_check_kfunc_ids)
>>> +
>>> +BTF_SET_START(bpf_rstat_sleepable_kfunc_ids)
>>> +BTF_ID(func, cgroup_rstat_flush)
>>> +BTF_SET_END(bpf_rstat_sleepable_kfunc_ids)
>>> +
>>> +static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
>>> +     .owner          = THIS_MODULE,
>>> +     .check_set      = &bpf_rstat_check_kfunc_ids,
>>> +     .sleepable_set  = &bpf_rstat_sleepable_kfunc_ids,
>>
>> There is a compilation error here:
>>
>> kernel/cgroup/rstat.c:503:3: error: ‘const struct btf_kfunc_id_set’ has
>> no member named ‘sleepable_set’; did you mean ‘release_set’?
>>       503 |  .sleepable_set = &bpf_rstat_sleepable_kfunc_ids,
>>           |   ^~~~~~~~~~~~~
>>           |   release_set
>>     kernel/cgroup/rstat.c:503:19: warning: excess elements in struct
>> initializer
>>       503 |  .sleepable_set = &bpf_rstat_sleepable_kfunc_ids,
>>           |                   ^
>>     kernel/cgroup/rstat.c:503:19: note: (near initialization for
>> ‘bpf_rstat_kfunc_set’)
>>     make[3]: *** [scripts/Makefile.build:288: kernel/cgroup/rstat.o] Error 1
>>
>> Please fix.
> 
> This patch series is rebased on top of 2 patches in the mailing list:
> - bpf/btf: also allow kfunc in tracing and syscall programs
> - btf: Add a new kfunc set which allows to mark a function to be
>    sleepable
> 
> I specified this in the cover letter, do I need to do something else
> in this situation? Re-send the patches as part of my series?

At least put a link in the cover letter for the above two patches?
This way, people can easily find them to double check.

> 
> 
> 
>>
>>> +};
>>> +
>>> +static int __init bpf_rstat_kfunc_init(void)
>>> +{
>>> +     return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
>>> +                                      &bpf_rstat_kfunc_set);
>>> +}
>>> +late_initcall(bpf_rstat_kfunc_init);
