From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Phishing Risk] [External] Re: [PATCH] cgroup/cpuset: Add a new
 isolated mems.policy type.
Date: Tue, 6 Sep 2022 07:19:21 -1000
Message-ID: <YxeBGeOaQxvlPLzo@slm.duckdns.org>
References: <20220902063303.1057-1-hezhongkun.hzk@bytedance.com>
 <YxT/liaotbiOod51@slm.duckdns.org>
 <c05bdeac-b354-0ac7-3233-27f8e5cbb38a@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=DLlnc6RmTg0BKq5WkTFW6Fs5pUb+s+A4h9B4fzKjhrI=;
        b=csTIT6mI2KzzjqaY8cqY1Odnetkmo9YoZgm1ta/V1CfQXFGHrNl5ID11UWr9EwdqWT
         ybdIbatthK94dyrnSRNDRzDCley5Yk5BpAeFv0jlVOckHWFPIroZTDp8BT8QYEWrvkct
         BA4eS1H6rJQxAfoCXt7ExiwOLg+VBwXu131zL1best+97Y5E8nYjpo+rR0a96WS+Wzv7
         MjQLtS57kFrjmK6AclQeajykuyehhqAxxl6b2xCpvmumWgksYXgKSp//v3sHRcowshtU
         cRIDx7lZIZpbAiQjffFScK2mWcqYWBLsFSVHgLV9dxsr6wqBZCCZBcPK/KMRw6ofIq1L
         5hEw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c05bdeac-b354-0ac7-3233-27f8e5cbb38a-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Sep 05, 2022 at 06:30:38PM +0800, Zhongkun He wrote:
> We usually use numactl to set the memory policy, but it cannot be changed
> dynamically. In addition, the mempolicy of cpuset can provide a more
> convenient interface for management and control panel.

But you can write a better tool easily in userspace to do whatever you wanna
do, right? If you're worried about racing against forks, you can freeze the
cgroup, iterate all pids applying whatever new policy and then unfreeze. We
can probably improve the freezer interface so that multiple users don't
conflict with each other but that shouldn't be too difficult to do and is
gonna be useful generically.

I don't see much point in adding something which can be almost trivially
implemented in userspace as a built-in kernel feature.

> Sorry,I don't quite understand the meaning of "don't enforce anything
> resource related". Does it mean mempolicy, such as "prefer:2" must specify
> node? Or "cpuset.mems.policy" need to specify a default value?
> (cpuset.mems.policy does not require a default value.)

In that there's no real resource being distributed hierarchically like cpu
cycles or memory capacities. All it's doing is changing attributes for a
group of processes, which can be done from userspace all the same.

Thanks.

-- 
tejun
