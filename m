From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] misc_cgroup: add support for nofile limit
Date: Tue, 27 Jul 2021 11:18:00 +0800
Message-ID: <b2ff6f80-8ec6-e260-ec42-2113e8ce0a18@gmail.com>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
 <YP8ovYqISzKC43mt@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BkpKJMj8n2tdrlAotNsD2n9oh289k/hxpaSEx0/2fUg=;
        b=gClIL7RqcSfXHukQYD9GBLkJ5ekF74p/wtUCDp6gVra+KFApFR/73C09AhdgVrIwrT
         D0/JYWqPoCVnbHlIyWzWbCfUa130s1dDr1A7IfJEhCpoRRFhUhlE9v9z9HKXgcMlMOQX
         4kjHirEqaVL9lk+vlRNvQpF8q8RExMDX4aPwfy0Y/GyoX5CvFVffxMKq3OoFwk6ODcwm
         /T28KX7ISkGoqJ31UyWZXYmTOdUMTJVztqa2yLVlxI/JFI7kLejlrdRcMhgLi3cBK1gv
         0i08p53OxpYSC6uZt9ycuqOG1UrZEWsZYUcB1Saf5BOLGH9wOKawTK2tIkg64YCE28AD
         PlCg==
In-Reply-To: <YP8ovYqISzKC43mt-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


Thanks for your time.

Tejun Heo wrote on 2021/7/27 5:27:
> On Thu, Jul 22, 2021 at 11:20:17PM +0800, brookxu wrote:
>> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>>
>> Since the global open files are limited, in order to avoid the
>> abnormal behavior of some containers from generating too many
>> files, causing other containers to be unavailable, we need to
>> limit the open files of some containers.
>>
>> v2: fix compile error while CONFIG_CGROUP_MISC not set.
>>
>> Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>> Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> This is different from pid in that there's no actual limit on how many open
> files there can be in the system other than the total amount of available
> memory. I don't see why this would need a separate limit outside of memory
> control. A couple machines I looked at all have file-max at LONG_MAX by
> default too.

According to files_maxfiles_init(), we only allow about 10% of free memory to
create filps, and each filp occupies about 1K of cache. In this way, on a 16G
memory machine, the maximum usable filp is about 1,604,644. In general
scenarios, this may not be a big problem, but if the task is abnormal, it will
very likely become a bottleneck and affect other modules. 

> Thanks.
> 
