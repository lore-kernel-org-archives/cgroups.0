From: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: Re: [RFC PATCH v1] mm: oom: introduce cpuset oom
Date: Mon, 26 Sep 2022 11:38:10 +0800
Message-ID: <b3ff8456-fe0e-95a0-cccd-e94025a82560@bytedance.com>
References: <20220921064710.89663-1-ligang.bdlg@bytedance.com>
 <18621b07-256b-7da1-885a-c96dfc8244b6@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date;
        bh=6Kb4i0mm6v9pZwbBNK1La/6ffxmbjpXjTkCflKZS3Mw=;
        b=M7KqJY/7x2gd1PCsMuoLwDKeICBqKrtnRWM2bztZmkzd/A+6MHl1gbKPWdDuJbBakh
         PObbN+N9EUBGqIsKWMx5ikDS+Lg/xwj5vIkhB+Ekifcxg5SwEyOECa5ZhL2uiNwOLRci
         I1z2OHsX/u7lOEzhLt3eP6aJGMfsOzEGSYm816K66IK3mR5+12u6qLR1NROPV3tEPvH2
         l2t3XatAqMc58mSloeRlA1DCry7YZhVa27mKiNC9holgSmDdk3FmwjTTuwYhwiF+/Rai
         rgsPtkZSy0uc70R9npGAOlByKBHXm3mbYJOD1ieitPokI7+2RpmYhYIsBt/KxG5Xb+Zz
         9HMw==
Content-Language: en-US
In-Reply-To: <18621b07-256b-7da1-885a-c96dfc8244b6-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org


On 2022/9/23 03:18, David Rientjes wrote:
> On Wed, 21 Sep 2022, Gang Li wrote:
> 
>> cpuset confine processes to processor and memory node subsets.
>> When a process in cpuset triggers oom, it may kill a completely
>> irrelevant process on another numa node, which will not release any
>> memory for this cpuset.
>>
>> It seems that `CONSTRAINT_CPUSET` is not really doing much these
>> days. Using CONSTRAINT_CPUSET, we can easily achieve node aware oom
>> killing by selecting victim from the cpuset which triggers oom.
>>
>> Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
>> Signed-off-by: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Hmm, is this the right approach?
> 
> If a cpuset results in a oom condition, is there a reason why we'd need to
> find a process from within that cpuset to kill?  I think the idea is to
> free memory on the oom set of nodes (cpuset.mems) and that can happen by
> killing a process that is not a member of this cpuset.
> 
Hi,

My last patch implemented this idea[1][2]. But it needs to inc/dec a per 
mm_struct counter on every page allocation/release/migration.

As the Unixbench show, this takes 0%-3% performance loss on different 
workloads[2]. So Michal Hocko inspired me to use cpuset[3].

[1]. 
https://lore.kernel.org/all/20220512044634.63586-1-ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
[2]. 
https://lore.kernel.org/all/20220708082129.80115-1-ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org/
[3]. https://lore.kernel.org/all/YoJ%2FioXwGTdCywUE-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/

> I understand the challenges of creating a NUMA aware oom killer to target
> memory that is actually resident on an oom node, but this approach doesn't
> seem right and could actually lead to pathological cases where a small
> process trying to fork in an otherwise empty cpuset is repeatedly oom
> killing when we'd actually prefer to kill a single large process.
> 

I think there are three ways to achieve NUMA aware oom killer:

1. Count every page operations, which cause performance loss[2].
2. Iterate over pages(like show_numa_map) for all processes, which may 
stuck oom.
3. Select victim in a cpuset, which may leads to pathological kill.(this 
patch)

None of them are perfect and I'm getting stuck, do you have any ideas?
