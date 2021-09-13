From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: Fix incorrect warning from
 cgroup_apply_control_disable()
Date: Mon, 13 Sep 2021 08:40:33 -1000
Message-ID: <YT+bIW/CSOlZQlY0@slm.duckdns.org>
References: <20210910024256.7615-1-longman@redhat.com>
 <YT+TA6ItnF9xM3cR@slm.duckdns.org>
 <125c4202-68d1-1a4e-03d6-2b18f0794ba4@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wB2kZQi2yYu38ZGIaOL/8KKQVA5tStMoy5uDjSp6HHE=;
        b=BPIn3x2JdlanyUdxqvocPhIYYwHV4UVqewuwhwqBZIvRdSMO0Ij+uDxQwD8iunjp1+
         1O8kc+OmXlpuWy8/OjK0NEDpAUC4rnueJV/D9thIZvCY82XXtk3kcU9A7sMsM8nkWxtN
         DphBLOHfA03swEEEoHzBJautvvpUcQ3lr0GSe2gCVKa/Kt6cyUW+i7olZxDBclR80l+q
         MpfVMV86cbC/fVENokzOUo3e6pzOne97XXduvt55l5y4HaP6pwFcv/chgGYnIsY/ig4g
         MR3oNkhLDZl5s6fxzLR6LHkaRS7wUkXXh2IgjRM/fgDzvaR4TN1pfNg3/4D9gU6HkLWE
         CWBg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <125c4202-68d1-1a4e-03d6-2b18f0794ba4-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Sep 13, 2021 at 02:35:03PM -0400, Waiman Long wrote:
> The problem with percpu_ref_is_dying() is the fact that it becomes true
> after percpu_ref_exit() is called in css_free_rwork_fn() which has an RCU
> delay. If you want to catch the fact that kill_css() has been called, we can
> check the CSS_DYING flag which is set in kill_css() by commit 33c35aa481786
> ("cgroup: Prevent kill_css() from being called more than once"). Will that
> be an acceptable alternative?

So, it's checking that cgroup_lock_and_drain_offline() which is used by
cgroup_lock_and_drain_offline() actually waited for csses which are in the
process of going offline because some operations aren't safe when racing
against them. I think the right solution here is making sure that [u]mount
path drains the offlining cgroups rather than getting rid of the warning. I
think the warning is pointing out an actual problem.

Thanks.

-- 
tejun
