From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: disallow disabled controllers on the default
 hierarchy
Date: Thu, 5 Jun 2014 09:53:29 -0400
Message-ID: <20140605135329.GB21607@htj.dyndns.org>
References: <5390356E.70305@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lkJEsRjy9eiGY62R2vzVGlJe7E18fcOGrhUzKun5dUA=;
        b=cRQIhyOqd34OwVO9U1U3Ud4wcFxMWujWyPhTY36BjhfTyGzI930YXv4ZfdcWeeU9He
         bfxHWQziQSreXOP1SDMg4HmvAhwUPohWPHRD9zG4U66d6ucJoOp98+Hw6GXiugLHBNY3
         ed4OGlTFcmZvx3cTJMWEUwXr/GUnuhz3PO8r5xLMngY0ucg6Vnwnt0FkJUevJKJGnGqx
         U0JntLrLHOf7UBSoCVNfOMIz8YAMvwZfQf+H8gaR8m5nlQBZuqwlG1YCtEViOKuS2LRM
         6NORnpUuXtVaHcw3R4rM77+tXjzCtulj8hGJd8rD9fIrkGE7l+x6yOorYSPMq7jMSB9x
         YZsQ==
Content-Disposition: inline
In-Reply-To: <5390356E.70305-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Thu, Jun 05, 2014 at 05:16:30PM +0800, Li Zefan wrote:
> After booting with cgroup_disable=memory, I still saw memcg files
> in the default hierarchy, and I can write to them, though it won't
> take effect.
> 
>   # dmesg
>   ...
>   Disabling memory control group subsystem
>   ...
>   # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
>   # ls /cgroup
>   ...
>   memory.failcnt                   memory.move_charge_at_immigrate
>   memory.force_empty               memory.numa_stat
>   memory.limit_in_bytes            memory.oom_control
>   ...
>   # cat /cgroup/memory.usage_in_bytes
>   0
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.16 w/ minor comment update.

Thanks.

-- 
tejun
