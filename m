From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Add a new isolated mems.policy type.
Date: Sun, 4 Sep 2022 09:42:14 -1000
Message-ID: <YxT/liaotbiOod51@slm.duckdns.org>
References: <20220902063303.1057-1-hezhongkun.hzk@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=f6y6RxJIYsgqs5sNLTn4Q3lZDib3LF1nipty1Lvv/4o=;
        b=Mga6r3qCMXMLYKA2zTcaYD3QN6xJBj3aaSKs0buxConQZ1B6lPPzqk5xmwDbuZVxkJ
         DMcSRs9ugt2FJ8neiNn6Q53KhDker+chdZV8Wg+N9hgvDYSL0xtt2UWVuj1hasFcyBT5
         O6e4d+6UwQ+k3S58tcktgIesJzoVb1FfakKT/6PT1kGSPFl0PurKXyjz6c8aYQGq/7r+
         uu9devDAYW6+5VXE7ytS1debDyOuzIqysQcPS7159aczGKjxML3HijsqUav+VoSSwEhd
         qrp9Kd17/yyj1hUCtXkY/S81Kf4JBTKBtljSdiQM6iH7mulFTMohQkikplbmC+GaGQxo
         PtnA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220902063303.1057-1-hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Sep 02, 2022 at 02:33:03PM +0800, hezhongkun wrote:
> From: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Mempolicy is difficult to use because it is set in-process
> via a system call. We want to make it easier to use mempolicy
> in cpuset, and  we can control low-priority cgroups to
> allocate memory in specified nodes. So this patch want to
> adds the mempolicy interface in cpuset.
> 
> The mempolicy priority of cpuset is lower than the task.
> The order of getting the policy is:
> 	1) vma mempolicy
> 	2) task->mempolicy
> 	3) cpuset->mempolicy
> 	4) default policy.
> 
> cpuset's policy is owned by itself, but descendants will
> get the default mempolicy from parent.
> 
> How to use the mempolicy interface:
> 	echo prefer:2 > /sys/fs/cgroup/zz/cpuset.mems.policy
> 	echo bind:1-3 > /sys/fs/cgroup/zz/cpuset.mems.policy
>         echo interleave:0,1,2,3 >/sys/fs/cgroup/zz/cpuset.mems.policy
> Show the policy:
> 	cat /sys/fs/cgroup/zz/cpuset.mems.policy
> 		prefer:2
> 	cat /sys/fs/cgroup/zz/cpuset.mems.policy
> 		bind:1-3
> 	cat /sys/fs/cgroup/zz/cpuset.mems.policy
> 		interleave:0-3
> Clear the policy:
> 	echo default > /sys/fs/cgroup/zz/cpuset.mems.policy

So, I'm a fan of adding cgroup functionalities which don't enforce anything
resource related. What you're proposing can easily be achieved with userland
tooling, right?

Thanks.

-- 
tejun
