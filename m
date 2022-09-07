From: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [Phishing Risk] Re: [Phishing Risk] [External] Re: [PATCH]
 cgroup/cpuset: Add a new isolated mems.policy type.
Date: Wed, 7 Sep 2022 20:06:30 +0800
Message-ID: <d323bd95-476b-0901-855e-14c8796d1b23@bytedance.com>
References: <20220902063303.1057-1-hezhongkun.hzk@bytedance.com>
 <YxT/liaotbiOod51@slm.duckdns.org>
 <c05bdeac-b354-0ac7-3233-27f8e5cbb38a@bytedance.com>
 <YxeBGeOaQxvlPLzo@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=0OMCYXdwR40VgBJEbCb1Ib7nAC/48wQOIhHqsm4Pyls=;
        b=HO4kjKdkDS/f97yEF+pCNPTD9Qua8BJsV2g6HRDvYYsaGXiL8d/7kvtOrUIj5FpP3u
         Do171ILfzUr9ll+GMVbtMMkKuLFktC0LuKZYHCj8Aj4GRzOmL0kbSz+a68UvVjzMcfj0
         kA6/ZHwpyBfxdjfjVvSOzG5SRoSZp9doRxmZrHtV9n6DsoCTRobj2aQgvGKLTd4t60L5
         6xaJKWiPrdjfPfveb0kURb/8K3B6ViCYRGZl8yCKYPZ354MstcHpOPR7RalIFLu5a9IO
         JqF8kEkTl/jJgocmBPv7hxEajpLVtL4HScdT5HN4ZgdHcuCinfyXB8Z7P5yPSwLct9bF
         MDDQ==
In-Reply-To: <YxeBGeOaQxvlPLzo-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> Hello,
> 
> On Mon, Sep 05, 2022 at 06:30:38PM +0800, Zhongkun He wrote:
>> We usually use numactl to set the memory policy, but it cannot be changed
>> dynamically. In addition, the mempolicy of cpuset can provide a more
>> convenient interface for management and control panel.
> 
> But you can write a better tool easily in userspace to do whatever you wanna
> do, right? If you're worried about racing against forks, you can freeze the
> cgroup, iterate all pids applying whatever new policy and then unfreeze. We
> can probably improve the freezer interface so that multiple users don't
> conflict with each other but that shouldn't be too difficult to do and is
> gonna be useful generically.
> 
> I don't see much point in adding something which can be almost trivially
> implemented in userspace as a built-in kernel feature.
> 
>> Sorry,I don't quite understand the meaning of "don't enforce anything
>> resource related". Does it mean mempolicy, such as "prefer:2" must specify
>> node? Or "cpuset.mems.policy" need to specify a default value?
>> (cpuset.mems.policy does not require a default value.)
> 
> In that there's no real resource being distributed hierarchically like cpu
> cycles or memory capacities. All it's doing is changing attributes for a
> group of processes, which can be done from userspace all the same.
> 
> Thanks.
> 
Hi Tejun, thanks for your reply.

It would be better if one process had a way to dynamically modify the
mempolicy of another process. But unfortunately there is no interface or
system call to do that in userspace.

In our use case, we hope to combine memory policy with cgroup for
better use of resources. The current implementation may not be suitable, 
I'll keep trying other approaches.

Thanks again.
