From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove obsolete comment above struct cgroupstats
Date: Fri, 14 Jul 2023 08:45:05 -1000
Message-ID: <ZLGXsYTmjj5Owbj4@slm.duckdns.org>
References: <20230713115938.177428-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689360307; x=1691952307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f6U7VZRuaLKxLmESL63dysq0/fq4KpyMaA9hEtA1d7I=;
        b=S88eaq7uGIfp4hAWvAnKu/7lHNW5XvbYuDFd3ZRgJfNNbZGOo1Z97yWIFOqlv5QVwG
         iIby0UcSrXcCGkgehrqt+o4jciKEVb8bB+BdcoYXKSpqThQwLff6adlOzh+3NEh5hmbS
         DwQB/whjHkpbiYLqtZeFIDq/FgxPeyT6DcaJ9a4S9y0l3vvHKvcBMo++9N1wULSca2hj
         /5U4QjaIKPUYqcHGEEAa067+IavekfLuk4txR56TJ6qteetfy+yia7/Wc49dUaNB0R+n
         SGVFBKBK3oHRBZDxkxuNHDsKyNgAsO3IucqTAUYsTH26OMrz1lBBqe0+/ugKwXGf+IEd
         uWqQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230713115938.177428-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 13, 2023 at 07:59:38PM +0800, Miaohe Lin wrote:
> There's no flag in the delay accounting structure indicates that the task
> is waiting on IO since commit 1193829da1a6 ("delayacct: cleanup flags in
> struct task_delay_info and functions use it"). So remove the comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
