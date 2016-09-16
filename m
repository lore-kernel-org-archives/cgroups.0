From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cpuset: fix non static symbol warning
Date: Fri, 16 Sep 2016 11:47:45 -0400
Message-ID: <20160916154745.GA26371@htj.duckdns.org>
References: <1474030957-6589-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/0GeRaVgygQuvA+rXn7JNn1FPbtU6mnw15T35yWg+CM=;
        b=TlQBNc34NdVX8bdshpMHuOLuVDUwD0KxH5/i+zw/8h+7nREBjs+e2S8O2d1fH7TiCc
         VUfxCF/qnFQnvJm2SVL7JI3GsbcuM8LBIDKRBPg0wRSp59FKMvcX+mjS88kN3LzTe3UF
         2FlylHfJuOtAoMSxhEu6QB4BTwSWzR3CsrIf2Xv7HgpzgqJ2hZxiSSIvyqh/g5m0ZtRj
         uBJzE6WgqexSbFkWjPB3yM6LMzK+LTsXD1tIz2rs/ijLwUS449n1Je6aJy9GGgHfcYa0
         CN7xlBl4v4ukrT5pX+wVZw5ycf3L2yxxGncSDThC7I6HmaZme9EIWsutr6ieN286Qm7V
         PU6Q==
Content-Disposition: inline
In-Reply-To: <1474030957-6589-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 16, 2016 at 01:02:37PM +0000, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Fixes the following sparse warning:
> 
> kernel/cpuset.c:2088:6: warning:
>  symbol 'cpuset_fork' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-4.8-fixes.

Thanks.

-- 
tejun
