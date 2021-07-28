From: brookxu <brookxu.cn@gmail.com>
Subject: Re: [RFC PATCH v2 1/3] misc_cgroup: add support for nofile limit
Date: Wed, 28 Jul 2021 11:17:08 +0800
Message-ID: <ca2bdc60-f117-e917-85b1-8c9ec0c6942f@gmail.com>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
 <YP8ovYqISzKC43mt@mtj.duckdns.org>
 <b2ff6f80-8ec6-e260-ec42-2113e8ce0a18@gmail.com>
 <YQA1D1GRiF9+px/s@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I4bD52HQNVCYUp+mhhWgz8FNJ8BrE2vk1IbUNpEx9mc=;
        b=O8vdbtiSSnF7huzNnfIfptHg4BK2bgYcoQEclIsnGfmOOra4Xdk/QITTy+84+9kitx
         BYp/Sh5ewo+8bf4AJC/P0Q3U71IPe5HMptnSED42dGXWQLpHDPAIPhX1bguUnlZBnKgB
         aB2kecaHynHcaIXmEvnRg/G+0aET27nYjz9g3UGIpLWkw1q0dbTRHfXC/5CfsCDz4uXW
         ewgCEvqemZc+Ov93GmBN5AB9uTpFGRjHiUqfyqI16jZ8Czu3kW1dAmstrpgNb4SF+kqX
         oO1KbPFuqiSo1ZH3QZGC0coDcFt4AnZXvxc37pSgmdHNPlAsBCVh4BPL96npS4gCVwAJ
         nVsw==
In-Reply-To: <YQA1D1GRiF9+px/s@mtj.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: viro@zeniv.linux.org.uk, lizefan.x@bytedance.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org



Tejun Heo wrote on 2021/7/28 12:32 上午:
> Hello,
> 
> On Tue, Jul 27, 2021 at 11:18:00AM +0800, brookxu wrote:
>> According to files_maxfiles_init(), we only allow about 10% of free memory to
>> create filps, and each filp occupies about 1K of cache. In this way, on a 16G
>> memory machine, the maximum usable filp is about 1,604,644. In general
>> scenarios, this may not be a big problem, but if the task is abnormal, it will
>> very likely become a bottleneck and affect other modules. 
> 
> Yeah but that can be configured trivially through sysfs. The reason why the
> default limit is lowered is because we wanna prevent a part of system to
> consume all the memory through fds. With cgroups, we already have that
> protection and at least some systems already configure file-max to maximum,
> so I don't see a point in adding another interface to subdivide the
> artificial limit.
> 

Yeah we can adjust file-max through sysctl, but in many cases we adjust it according
to the actual load of the machine, not for abnormal tasks. Another problem is that in
practical applications, kmem_limit will cause some minor problems. In many cases,
kmem_limit is disabled. Limit_in_bytes mainly counts user pages and pagecache, which
may cause files_cache to be out of control. In this case, if file-max is set to MAX,
we may have a risk in the abnormal scene, which prevents us from recovering from the
abnormal scene. Maybe I missed something.

> Thanks.
> 
