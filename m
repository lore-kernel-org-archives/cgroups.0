From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH] cgroup: disallow subtree controller enable/disable
 while there are tasks
Date: Mon, 4 May 2015 12:15:00 -0400
Message-ID: <20150504161500.GC1971@htj.duckdns.org>
References: <554745D1.1000206@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9c0llwqeIPz5XBcIygweVj/c2B21/Kjny/l4nQl9t1I=;
        b=qPLguQUyjztIwu3NtiOUI298+nTr2ryB/HZsnXUZVU551gEm2Qb6oi/8BJENR9G6y5
         r3g3Nrmj0fXfoP/cTkY84mv541DnrHf/OGlfH3caU5zcCeJSgPXNj1FSYz9VqGUtlfM1
         gU5sEGvMo4/wDcitpmwLB8HjHl1evIGGBmMUsCn2tP5KJoTiFAhCXZCgrzV5nueBideI
         pODKx52iq51b3DxUWIp1VZ27Jn+FxOS7pw9jgfeziisRNnSn40k5cpWGCQQRoX3uH/YH
         4a2oOBocSj4HcbA1MFL7WykCNYq3jTNGzx6PiJeJZ1icN4g8/1sgpBBcSnQQtqQZNtnS
         zygA==
Content-Disposition: inline
In-Reply-To: <554745D1.1000206-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, May 04, 2015 at 06:11:29PM +0800, Zefan Li wrote:
> It's not safe if we enable/disable some controllers while there are
> tasks in the substree, because task migration can fail.
> 
> For example rt bandwidth controller disallow having rt tasks in the
> cgroup if no bandwidth has been allocated, which is the case when
> a cgroup is just created.
> 
> A kernel warning is triggered immediately by doing:

Well, the whole thing is behind the devel flag for a reason.  Let's
see how we can resolve the RT case and then determine what to do.

Thanks.

-- 
tejun
