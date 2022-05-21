From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 17:58:47 -0700
Message-ID: <4cbdd3e9-c6fe-d796-5560-cd09c9220868@fb.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
 <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CA+khW7iDDkO3h5WQixEA=nUL-tBmCTh7fMAf3iwNy98UfM-k9g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=KIpZs9jKbqBOvPrqHQrp3jSELXI1Phrut9mQHwVWCrA=;
 b=J/xkxKQDc2QW7jfk9g/qUIAonSVzVHwhrRW6Wt6Ii+7Q6GCmciBQJxv9RV1AtKN+U5jr
 q6jdn51i65NeFeSmQNQy+2A81Cth7gVfavnLw2PE3EQV5RvAsyZC6SGKW2bwLyB2fSyf
 9rhmH2U6kpjS+BQF4gqVMf6X5uJ+2jwoTBc= 
Content-Language: en-US
In-Reply-To: <CA+khW7iDDkO3h5WQixEA=nUL-tBmCTh7fMAf3iwNy98UfM-k9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgr



On 5/20/22 2:49 PM, Hao Luo wrote:
> Hi Tejun and Yonghong,
> 
> On Fri, May 20, 2022 at 12:42 PM Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> Hi Tejun and Yonghong,
>>
>> On Fri, May 20, 2022 at 9:45 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>> On Fri, May 20, 2022 at 09:29:43AM -0700, Yonghong Song wrote:
>>>>     <various stats interested by the user>
>>>>
>>>> This way, user space can easily construct the cgroup hierarchy stat like
>>>>                             cpu   mem   cpu pressure   mem pressure ...
>>>>     cgroup1                 ...
>>>>        child1               ...
>>>>          grandchild1        ...
>>>>        child2               ...
>>>>     cgroup 2                ...
>>>>        child 3              ...
>>>>          ...                ...
>>>>
>>>> the bpf iterator can have additional parameter like
>>>> cgroup_id = ... to only call bpf program once with that
>>>> cgroup_id if specified.
>>
>> Yep, this should work. We just need to make the cgroup_id parameter
>> optional. If it is specified when creating bpf_iter_link, we print for
>> that cgroup only. If it is not specified, we iterate over all cgroups.
>> If I understand correctly, sounds doable.
>>
> 
> Yonghong, I realized that seek() which Tejun has been calling out, can
> be used to specify the target cgroup, rather than adding a new
> parameter. Maybe, we can pass cgroup_id to seek() on cgroup bpf_iter,
> which will instruct read() to return the corresponding cgroup's stats.
> On the other hand, reading without calling seek() beforehand will
> return all the cgroups.

Currently, seek is not supported for bpf_iter.

const struct file_operations bpf_iter_fops = {
         .open           = iter_open,
         .llseek         = no_llseek,
         .read           = bpf_seq_read,
         .release        = iter_release,
};

But if seek() works, I don't mind to remove this restriction.
But not sure what to seek. Do you mean to provide a cgroup_fd/cgroup_id
as the seek() syscall parameter? This may work.

But considering we have parameterized example (map_fd) and
in the future, we may have other parameterized bpf_iter
(e.g., for one task). Maybe parameter-based approach is better.

> 
> WDYT?
