From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v2 3/8] bpf, iter: Fix the condition on p when
 calling stop.
Date: Fri, 24 Jun 2022 10:46:17 -0700
Message-ID: <dc5aca8d-16c4-a1fd-a2f1-fd3008c10e02@fb.com>
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-4-yosryahmed@google.com>
 <ee47c4af-aa4f-3ede-74b9-5d952df2fb1e@fb.com>
 <CA+khW7jU=Fqt49jxG8y5n2YtRu4_C1gFUW-PqZGY_Rt8PGrGEg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=OyNrN6EyO8Pf4UvdxqWA8vntjORPiHd3hLyWhsOiVsg=;
 b=bSwKBPVzbcWI0bA7Rrsx2p+C6Ba7QGdDnjzUU0VNgxGVlXPFNu4COkvNkoaCrK/l7B/R
 bHR0W18zvw6wqclwDf+2UvT7P8Eh8qb08uPw3VK64vosa+WuE7BhOlBcjjRQJ+WM4ivg
 QOpQ9Pc1xUsjLUdrTKnk2hKVLz1mzI3LgP4= 
Content-Language: en-US
In-Reply-To: <CA+khW7jU=Fqt49jxG8y5n2YtRu4_C1gFUW-PqZGY_Rt8PGrGEg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 6/21/22 12:25 AM, Hao Luo wrote:
> On Mon, Jun 20, 2022 at 11:48 AM Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org> wrote:
>>
>> On 6/10/22 12:44 PM, Yosry Ahmed wrote:
>>> From: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>>
>>> In bpf_seq_read, seq->op->next() could return an ERR and jump to
>>> the label stop. However, the existing code in stop does not handle
>>> the case when p (returned from next()) is an ERR. Adds the handling
>>> of ERR of p by converting p into an error and jumping to done.
>>>
>>> Because all the current implementations do not have a case that
>>> returns ERR from next(), so this patch doesn't have behavior changes
>>> right now.
>>>
>>> Signed-off-by: Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>
>> Acked-by: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
> 
> Yonghong, do you want to get this change in now, or you want to wait
> for the whole patchset? This fix is straightforward and independent of
> other parts. Yosry and I can rebase.

Sorry for delay. Let me review other patches as well before your next 
version.

BTW, I would be great if you just put the prerequisite patch
 
https://lore.kernel.org/bpf/20220421140740.459558-5-benjamin.tissoires-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
as the first patch so at least BPF CI will be able to test
your patch set. It looks like KP's bpf_getxattr patch set already did this.
 
https://lore.kernel.org/bpf/20220624045636.3668195-2-kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/T/#u

