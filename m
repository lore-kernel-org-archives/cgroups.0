From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
Date: Mon, 11 Jun 2012 02:23:13 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1206110220290.6843@chino.kir.corp.google.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <alpine.DEB.2.00.1205241436180.24113@chino.kir.corp.google.com> <20120527202848.GC7631@skywalker.linux.vnet.ibm.com>
 <87lik920h8.fsf@skywalker.in.ibm.com> <20120608160612.dea6d1ce.akpm@linux-foundation.org> <4FD56C19.4060307@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=tueExIPfwGEV50H38UdtvIxwzbE9ucslob6k0jVVctE=;
        b=MWe88+LXWT0qx39CSKtc0/a9oVR96PpRcKXegXfeawh9zar3f2oevtPdHM4jC5F/7X
         xN0xIMTLMNbMAWO8uJ2uoV2A+wd9clCciLUNKLqJhcKRvabQgFDO9wtjc+ZcUKrDtyBS
         ihDALpNF/RI0CqBGORXEG0JT9C8WlqiawBvcmH1ooj/f8ie5R+fhzRQongpRChX4QQDw
         dKfDUvWhPcT95k20GeUzM5ZLpqcASp3DiSmnBefF2xJ27h7zKpTNcSkOmqwDCgkOAc1E
         +05C+XlF1bc3o2il307FReA29N6IUxIxdw63nIzYBSshFsqtf5PYutI7DWtTRAXiIVDL
         ijLQ==
In-Reply-To: <4FD56C19.4060307-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, 11 Jun 2012, Kamezawa Hiroyuki wrote:

> Now, I think...
> 
>   1. I need to agree that overhead is _not_ negligible.
> 
>   2. THP should be the way rather than hugetlb for my main target platform.
>      (shmem/tmpfs should support THP. we need study.)
>      user-experience should be fixed by THP+tmpfs+memcg.
> 
>   3. It seems Aneesh decided to have independent hugetlb cgroup.
> 
> So, now, I admit to have independent hugetlb cgroup.
> Other opinions ?
> 

I suggested the seperate controller in the review of the patchset so I 
obviously agree with your conclusion.  I don't think we should account for 
hugetlb pages in memory.usage_in_bytes and enforce memory.limit_in_bytes 
since 512 4K pages is not the same as 1 2M page which may be a sacred 
resource if fragmentation is high.

Many thanks to Aneesh for continuing to update the patchset and working 
toward a resolution on this, I love the direction its taking.
