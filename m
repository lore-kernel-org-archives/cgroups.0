From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Add a new isolated mems.policy type.
Date: Mon, 5 Sep 2022 08:45:25 +0200
Message-ID: <YxWbBYZKDTrkmlOe@dhcp22.suse.cz>
References: <20220904040241.1708-1-hezhongkun.hzk@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662360325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mPt2cENEN10WmmgHREJgk8hsqDksK88YmLcQYRTdLds=;
        b=CEJnFxSe55CXW/6IMWShpBBfRLm1buiiB2ggpdNYYoBCOu0aMDuAed1Xd5WMZm32NhtNYZ
        XJe8aqLvx3S4TOVWUOzw2N13lVuCDbBUuKwoLKkgnhyxbLXBwtcB2TLtmk+mxCIFFsTptM
        WJN/ylYgngESJjmvw+4/KkBAt6x9SPM=
Content-Disposition: inline
In-Reply-To: <20220904040241.1708-1-hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hezhongkun <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

On Sun 04-09-22 12:02:41, hezhongkun wrote:
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

What is the hierarchical behavior of the policy? Say parent has a
stronger requirement (say bind) than a child (prefer)?
 
> How to use the mempolicy interface:
> 	echo prefer:2 > /sys/fs/cgroup/zz/cpuset.mems.policy
> 	echo bind:1-3 > /sys/fs/cgroup/zz/cpuset.mems.policy
>         echo interleave:0,1,2,3 >/sys/fs/cgroup/zz/cpuset.mems.policy

Am I just confused or did you really mean to combine all these
together?
-- 
Michal Hocko
SUSE Labs
