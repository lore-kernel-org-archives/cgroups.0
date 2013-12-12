From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Date: Thu, 12 Dec 2013 13:45:06 -0500
Message-ID: <20131212184506.GK32683@htj.dyndns.org>
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
 <20131212153536.GD32683@htj.dyndns.org>
 <20131212155523.GF32683@htj.dyndns.org>
 <52AA026C.3040605@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=c7MZTeWlfvLrmUlH2d+IK0BaD0pjU5uS/UhNk5qbDIk=;
        b=aRhNmuMB+PXIMxVu6TZQWsi8zwJpmLB2/4cJMgtuVjpzEat+ojq9CqKTZkoNQJ5r7G
         YSbaQf/iWLTWVxiV4gN0NDeGVoi/qk6C5sc4KEb3WQTXSyV2GjuvtUljV0yGQBoHwSZQ
         wLdU1f6d09TYricAHtsI5/iNoVpFgYMcJS2dXs/t5L6jnYut66RWUROMMFzC0BQC6RNN
         IPitRTVnK56k/wcBwLODr3V6CUun6do7cMNE60AeCcivlLE8l66TH5jNbmSdEVKYSrgh
         KdpSw1hIJmA/PxBBjckZwzqORUCNkaEMxLH7ub91R+wdVUXrLfLX00IpA/RXCNBZuOmb
         rsdA==
Content-Disposition: inline
In-Reply-To: <52AA026C.3040605-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Thu, Dec 12, 2013 at 10:37:32PM +0400, Vladimir Davydov wrote:
> If so, I don't mind, but why? cgroup_unload_subsys() should never be
> called without properly initialized css.

Hmm.... I think it's generally preferable to reuse normal exit path
for error handling as much as possible.  Plus, the normal cgroup init
failure path behaves that way.  That said, it's more of a preference
and if you have technical argument, I'd be happy to give in. :)

Thanks.

-- 
tejun
