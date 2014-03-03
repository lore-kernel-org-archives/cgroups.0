From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: use rcu_read_lock() to protect task_cs()
Date: Mon, 3 Mar 2014 17:31:19 -0500
Message-ID: <20140303223119.GA26523@mtj.dyndns.org>
References: <53144223.6000302@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ovG5nS3V5aqYQabbgluVBs7ViWFqxtx/pFn0w3s0LEE=;
        b=DzV+wtSNK46SNZUQoD0OE0QZLWTi4S28EHshNtv7g6p61MlxdwUbVXzHgIdqZGDFLS
         w0VNWOT9wAVAj2kwSqLn7NoM7/DVZpBBJwrckCGjN77r16NtDq0FqW+Z6xswYD7xw5dE
         p8INmJnxJQt8iYqkhYleBuTJ3IUrg4K91SMiMhyaAOAyCoCyGft4Rbg0NYPmFmckTaL0
         nXXgJtu7dwRp80mAZ6r1B0Fw5fB6J6ZvYyORuz7PW5fA0CF9uEmnXLgaKuYP62MSM8XJ
         be8Owew30zT/UULX0CMDz3B1JDqat4TZfdaIl0CEDxZMP9hj4UX7tDvbPuk7WxjqjFYw
         Hw3Q==
Content-Disposition: inline
In-Reply-To: <53144223.6000302-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Mon, Mar 03, 2014 at 04:49:39PM +0800, Li Zefan wrote:
> We no longer use task_lock() to protect tsk->cgroups.
> 
> Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to for-3.15 (do we need this for 3.14-fixes?).

Thanks.

-- 
tejun
