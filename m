From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Use cgroup_attach_{lock,unlock}() from
 cgroup_attach_task_all()
Date: Fri, 26 Aug 2022 11:15:06 -1000
Message-ID: <Ywk32l/GFRARpZDn@slm.duckdns.org>
References: <5ea67858-cda6-bf8d-565e-d793b608e93c@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=/r4GaceiE64/VU9cl6w/gnM+3/l95EwxcGXeU/3BkKE=;
        b=o/AKIAKsz4xMcPimPXLt137uSh8/jY5uoC1PaGLEF10bLPqupOMaPDTKxhgrNz2jk8
         B/mhoDzoQStmnj3mUeUY9GxckDDTI3pMfR3Q3dmaGscWIkwN4vcGY2lm9CeDKx6U7E4I
         Oa0tx4qUED5Jsc71/+pXNtl9/q1S5YNZ5k6N0BaytKo8w+vE6+wPPcGz/+2nK77ELfo0
         MD0N9FugW/dxedZfB3swJKGIzc3FdBHkGl1T+sxmBYZBCjCELyn/bZSY4+2sCgLhJWjc
         JlF82qnVtsx8skf2U8sTDtn9hbhMfwSsmNBBrCNufpoMYfZHr3IAb9IM1ZANytZW05Rp
         dK9g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5ea67858-cda6-bf8d-565e-d793b608e93c-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Aug 26, 2022 at 11:48:29AM +0900, Tetsuo Handa wrote:
> No behavior changes; preparing for potential locking changes in future.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>

Applied to cgroup/for-6.1.

Thanks.

-- 
tejun
