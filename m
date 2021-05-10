From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: inline cgroup_task_freeze()
Date: Mon, 10 May 2021 14:54:31 -0400
Message-ID: <YJmBZ3IVCiAK7WF+@slm.duckdns.org>
References: <20210510184556.946798-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qhr+PGYEagAJ8E92KKnVFnuFMoTrCUOtPClJNlbWd8c=;
        b=XDAkuaG3qMxQY7dLWJcvjZbjFutrp6S4uxZbqDVUVlsSSlv67pOxqGEMAsZEbwqLpm
         pCRp4m2d8A0+I0Gkk2olVBRLnUZBEc5ttuj8I2oy5s0FzSAP2wVS4GyJwoadxXHVgqqn
         Pgqw1/hbpWDzLZSrL+Hxdj+7XFk1z5MBMATmjmZZ+lDD/kYWKSA7GWeNbQqJrLn4rhgd
         PlkdwnMbSwf4IK3m3EHT7PmAHSlE9iO13AOyBBWG9En1y+48k1Rn91QsOu2Y/wUAdv5A
         +7m3+AVAd4dngN6iUbJCOV5dWMVYZ7gqt96zpShP50K+Rq5F5CaCkrv/58L02mrQ/qwd
         IbKw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210510184556.946798-1-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, May 10, 2021 at 11:45:56AM -0700, Roman Gushchin wrote:
> After the introduction of the cgroup.kill there is only one call site
> of cgroup_task_freeze() left: cgroup_exit(). cgroup_task_freeze() is
> currently taking rcu_read_lock() to read task's cgroup flags, but
> because it's always called with css_set_lock locked, the rcu protection
> is excessive.
> 
> Simplify the code by inlining cgroup_task_freeze().
> 
> Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Applied to cgroup/for-5.14.

Thanks.

-- 
tejun
