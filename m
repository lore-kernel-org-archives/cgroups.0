From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 12/12] cpuset: export effective masks to userspace
Date: Wed, 9 Jul 2014 16:15:49 -0400
Message-ID: <20140709201549.GD21090@htj.dyndns.org>
References: <53BD0174.4060002@huawei.com>
 <53BD0215.8060305@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=w8Gw6WIR+yjZrXOXt69zXp3Txu5KbbcAXuS7a9v0reY=;
        b=EwanjwnAQk2FzI7KTS9n/brRPYi/9Jx68HmpiH08Lra3PUMlWa6POKEv2JA8HD9ww1
         75olKquSt4Ejaly+sI0lGaOhz+tz7/v7A7Uk7vtEXWPU5rvbLP4frX+iBpQDdSS4RYlk
         J8y3mJwoBZ5W5u+la//x56w0VuNLGm6rGwFJXiWSkblG5DAfH8b00Xz4JlyyIuiGz7QA
         TjZM1TGvuRimpJGa9QsoOaV5yr77XjMGi/E2GKhA29K5kTCYmaxPDuTQ8CoXSa5F7eKl
         u7sbeauGq3HWNGGDO7T1+fgqxkif3tQGb5Gn11C1lmznQdlGLvHChSJJGke3ExbJyvPs
         /rAg==
Content-Disposition: inline
In-Reply-To: <53BD0215.8060305-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jul 09, 2014 at 04:49:25PM +0800, Li Zefan wrote:
> cpuset.cpus and cpuset.mems are the configured masks, and we need
> to export effective masks to userspace, so users know the real
> cpus_allowed and mems_allowed that apply to the tasks in a cpuset.
> 
> v2:
> - export those masks unconditionally, suggested by Tejun.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

I applied this patch but there's a pending patchset to split legacy
and dfl cftype arrays, so maybe doing it separately makes more sense
now, I'm not sure.  Anyways, we need to review cpuset interface for
the default hierarchy anyway.  At least the memory pressure knobs
should go.  It's measuring something which is completely
implementation dependent.

Thanks.

-- 
tejun
