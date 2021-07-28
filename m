From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH v2 1/3] misc_cgroup: add support for nofile limit
Date: Wed, 28 Jul 2021 17:47:05 +0800
Message-ID: <ed8824d5-0557-7d38-97bd-18d6795faa55@gmail.com>
References: <3fd94563b4949ffbfe10e7d18ac1df3852b103a6.1626966339.git.brookxu@tencent.com>
 <YP8ovYqISzKC43mt@mtj.duckdns.org>
 <b2ff6f80-8ec6-e260-ec42-2113e8ce0a18@gmail.com>
 <YQA1D1GRiF9+px/s@mtj.duckdns.org>
 <ca2bdc60-f117-e917-85b1-8c9ec0c6942f@gmail.com>
 <YQEKNPrrOuyxTarN@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iPJfT32PGYt4NJ5C+bncE2oPEQUqDqGzmN3ZvuFQkGI=;
        b=SV1ILPTpHhcPVfAExOd1xUWdXjac03q3/bUhkyQX0fBdxe9DOlGsmMoBR41c+6BGS1
         Y0sIHvQZNNT2c8Zp/bCNbM/cakRjXXnx1hlcCRQ0sgtG60ew5BVyr0t+HdLCOg5F0q0u
         0BdYBhUh5aZ8EC8VgZv9MHym0Qr3Xuw3B6L/77nDLHMm4E0g09Lmvp60n6z+Xk2WXYd+
         PN+Ba6UTM+l6IIjaRK23rgFWjpBGZNDAThaEjTU0ZUhjESHHWrgL0h8QL/SBrvkHRac8
         k56RLfEk5+7t0OBQpM9yDL86L4/+8Cxt8jgkfTPPakD9A31e/UrdMnwMEOBz+csXj9HI
         5d6g==
In-Reply-To: <YQEKNPrrOuyxTarN-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



Tejun Heo wrote on 2021/7/28 3:41 下午:
> On Wed, Jul 28, 2021 at 11:17:08AM +0800, brookxu wrote:
>> Yeah we can adjust file-max through sysctl, but in many cases we adjust it according
>> to the actual load of the machine, not for abnormal tasks. Another problem is that in
>> practical applications, kmem_limit will cause some minor problems. In many cases,
>> kmem_limit is disabled. Limit_in_bytes mainly counts user pages and pagecache, which
>> may cause files_cache to be out of control. In this case, if file-max is set to MAX,
>> we may have a risk in the abnormal scene, which prevents us from recovering from the
>> abnormal scene. Maybe I missed something.
> 
> Kmem control is always on in cgroup2 and has been in wide production use for
> years now. If there are problems with it, we need to fix them. That really
> doesn't justify adding another feature.

But considering stability issues(k8s), There are still many production environments use
cgroup v1 without kmem. If kmem is enabled, due to the relatively large granularity
of kmem, this feature can also prevent the abnormal open behavior from making the entire
container unavailable? but I currently do not have this scenario.

Thanks for your time.

> Thanks.
> 
