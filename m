From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] Per-cgroup page stat accounting
Date: Mon, 02 Jul 2012 15:51:02 +0800
Message-ID: <4FF152E6.70009@gmail.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <4FED6604.9080603@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=Ws2uyHkODZgENTkt6u98i7DpW8CrCzlCrf1+4gHloms=;
        b=hIp0R66I+NKtH7tsol3LAwMRepsiPTaeS0h8bMM3XYRKKmqVSTQXKKButP7NzB8i8E
         KDqaZ8VoYYNixTuITiBQUtQB+cg31CD/QuejRwpAzJxpwhsTxaoDhovVdATnfY2YdyT+
         1vsRYCAhJXXdKH4lZGs66RMi/ACmCRUHFRStPJ8ibcMepiAK5n1Rth3IdyEK48j8iYEA
         rPkH8behtk1kTAE3qB97rpuJUh3GQEDv3AKYxqv7CCqKubNtPjRLAZrm41FxkSR3F/Z2
         bTkBl7C8ZMqbsjY1ocL/YuLFkK7oaYYYYrAIrJ4rZodNfputvm14PuBJY/p8E6xM7/D8
         diyQ==
In-Reply-To: <4FED6604.9080603-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 06/29/2012 04:23 PM, Kamezawa Hiroyuki wrote:
> (2012/06/28 19:54), Sha Zhengju wrote:
>> This patch series provide the ability for each memory cgroup to have independent
>> dirty/writeback page stats. This can provide some information for per-cgroup direct
>> reclaim. Meanwhile, we add more detailed dump messages for memcg OOMs.
>>
>> Three features are included in this patch series:
>>   (0).prepare patches for page accounting
>>    1. memcg dirty page accounting
>>    2. memcg writeback page accounting
>>    3. memcg OOMs dump info
>>
>> In (0) prepare patches, we have reworked vfs set page dirty routines to make "modify
>> page info" and "dirty page accouting" stay in one function as much as possible for
>> the sake of memcg bigger lock.
>>
>> These patches are cooked based on Andrew's akpm tree.
>>
> Thank you !, it seems good in general. I'll review in detail, later.
>
> Do you have any performance comparison between before/after the series ?
> I mean, set_page_dirty() is the hot-path and we should be careful to add a new accounting.


Not yet, I sent it out as soon as I worked out this solution to check
whether it's okay.
I can test the series after most of people agree with it.


Thanks,
Sha
