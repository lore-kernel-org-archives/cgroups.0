From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RESEND PATCH] cgroup: use tsk->in_iowait instead of
 delayacct_is_task_waiting_on_io()
Date: Fri, 16 Apr 2021 16:49:47 -0400
Message-ID: <YHn4a4Xdtm6212Wy@slm.duckdns.org>
References: <7fee39d482a783254379f2419a00b9a9f32d7f2e.1618275776.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DexHDhL9tcMwui87pn8whVm0iHnYGKNPOz+fZd4UKq0=;
        b=ZHYlqzjKQo+Kf3LZ9lccJtG0B9f4KjhrWnl90sg0iUobj4YCXpTt9TmJp/ASfF2cnh
         tQqTjcR7IfEnUIdM5WfF+XFkS9m0ti/SRTKzfNzdYsA5kCkFhToO2z1SiLIVJ0oxzUsW
         LvMOXRMqQangaKL6AvDOCXU/UenN4wSmrg2Q1OtZvspeTfPgRU3EbHxjH0hlgfgEYUjn
         wkACiS3NUWYlPY8pCI0PhjHSm+Dw6Lml22r+BIdgbqOdp8yENG124sHZ4aR6gwDHUMNC
         oggMzSM0hDaXGI7lggG1ltlMxML6lbgkPI35zakvgksUHQvLvwHtSjD/CH5Va6yeMAos
         Z0sg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7fee39d482a783254379f2419a00b9a9f32d7f2e.1618275776.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 13, 2021 at 09:39:05AM +0800, brookxu wrote:
> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
> 
> If delayacct is disabled, then delayacct_is_task_waiting_on_io()
> always returns false, which causes the statistical value to be
> wrong. Perhaps tsk->in_iowait is better.
> 
> Signed-off-by: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Applied to cgroup/for-5.13.

Thanks.

-- 
tejun
