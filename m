From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
Date: Tue, 22 Feb 2022 13:22:13 -0500
Message-ID: <a1baa10e-2c73-1fdd-0228-820310455dd5@redhat.com>
References: <000000000000264b2a05d44bca80@google.com>
 <0000000000008f71e305d89070bb@google.com> <YhUc10UcAmot1AJK@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645554138;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wpBwJl6c6s7sx3w93zOGpJgVfvC/ipdRSEUJaReqDhs=;
        b=bLXiMZbCyFJXifWNUDQ783REY1qRW2Wstt/VIHLgRNLSLE84shDT0CKLwF2KjI/obbcDg7
        ZwYh96Q8pTwuZoxI1AWY2FErexaw4+CHNQz0ffIfIkRKZQ/Ugfb0GrAPulFI/VRxIp1ak4
        li5d5snoqiuxX73rUWpkqpvgB1Zv2uE=
Content-Language: en-US
In-Reply-To: <YhUc10UcAmot1AJK-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, syzbot <syzbot+568dc81cd20b72d4a49f-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org

On 2/22/22 12:26, Tejun Heo wrote:
> (cc'ing Waiman and quoting whole body)
>
> Hello, Waiman.
>
> It looks like it's hitting
>
>   WARN_ON(!is_in_v2_mode() && !nodes_equal(cp->mems_allowed, cp->effective_mems))
>
> Can you take a look?

My preliminary analysis is that the warning may be caused by my commit 
1f1562fcd04a ("cgroup/cpuset: Don't let child cpusets restrict parent in 
default hierarchy") since the merge branch e5313968c41b is missing the 
fix commit d068eebbd482 ("cgroup/cpuset: Make child cpusets restrict 
parents on v1 hierarchy"). I believe the problem should be gone once the 
merge branch is updated to a later upstream baseline.

Cheers,
Longman

