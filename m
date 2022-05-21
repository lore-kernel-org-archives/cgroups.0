From: Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Date: Fri, 20 May 2022 17:59:21 -0700
Message-ID: <5b301151-0a65-df43-3a3a-6d57e10cfc2d@fb.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
 <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
 <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
 <Yogc0Kb5ZVDaQ0oU@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JYu9SA2HKPHuyf2nTdzvIr2BKdjhVNQKHE819MgcQSQ=;
 b=YiDSniia/6BMbsMJXG7fFQw7DifadFkJWqSiozbxMTV1sd/LK/w3UYeKyWyCospP8dYJ
 m2VAj60N+1t2FUcZDbojCDGDlqeXCsD464v5aB+kpeaQU+IOoYHl7kbI7HckXOuehzRa
 KD0IAPuSihCxQeUEJ6lwkXz1J69IWuB9+vs= 
Content-Language: en-US
In-Reply-To: <Yogc0Kb5ZVDaQ0oU-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bpf <>



On 5/20/22 3:57 PM, Tejun Heo wrote:
> Hello,
> 
> On Fri, May 20, 2022 at 03:19:19PM -0700, Alexei Starovoitov wrote:
>> We have bpf_map iterator that walks all bpf maps.
>> When map iterator is parametrized with map_fd the iterator walks
>> all elements of that map.
>> cgroup iterator should have similar semantics.
>> When non-parameterized it will walk all cgroups and their descendent
>> depth first way. I believe that's what Yonghong is proposing.
>> When parametrized it will start from that particular cgroup and
>> walk all descendant of that cgroup only.
>> The bpf prog can stop the iteration right away with ret 1.
>> Maybe we can add two parameters. One -> cgroup_fd to use and another ->
>> the order of iteration css_for_each_descendant_pre vs _post.
>> wdyt?
> 
> Sounds perfectly reasonable to me.

This works for me too. Thanks!

> 
> Thanks.
> 
