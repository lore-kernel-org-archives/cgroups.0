From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
Date: Thu, 24 Jan 2013 11:01:34 +0100
Message-ID: <20130124100134.GC26351@gmail.com>
References: <5100D4FE.9080205@huawei.com>
 <5100D518.8000103@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=ai6TvIwE3wdSm+ThKBulfDxyXgSqxNy4vRwExUefjKs=;
        b=P4BES0wOjQL/2SjbNDJ/PKH7bIsRuKhMdJI7KUY8FRrKcVOCmeXtaV3rQYwqgCtaSn
         KoRUkPHJSkWub5HPBldirCNFdznf9+vT5GddzU95hCxyLE+hNPd7/gbxzRa6Bylz9HJk
         3ZKY4YdspV7MYmPSud8yW2SUBaaNyNR6jcLQM/z//uTMncMVlMHD6n536Hu4aUu2cTUX
         KTtxhofybxSOKtXO/n5NRaD0dXeV5m23jES50ClfYQlcasEEfLc8Ps0xWX3puBFs4oqj
         QFBC6et9WPYUcShAEdq6XSehfSu6d/5XHSx7gbvPGZbEjOYbIAqkRclNpz9JxtaKRb4k
         PcbA==
Content-Disposition: inline
In-Reply-To: <5100D518.8000103-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


* Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:

> This is a preparaton for later patches.
> 
> - What do we gain from cpu_cgroup_css_online():
> 
> After ss->css_alloc() and before ss->css_online(), there's a small
> window that tg->css.cgroup is NULL. With this change, tg won't be seen
> before ss->css_online(), where it's added to the global list, so we're
> guaranteed we'll never see NULL tg->css.cgroup.
> 
> - What do we gain from cpu_cgroup_css_offline():
> 
> tg is freed via RCU, so is cgroup. Without this change, This is how
> synchronization works:
> 
> cgroup_rmdir()
>   no ss->css_offline()
> diput()
>   syncornize_rcu()
>   ss->css_free()       <-- unregister tg, and free it via call_rcu()
>   kfree_rcu(cgroup)    <-- wait possible refs to cgroup, and free cgroup
> 
> We can't just kfree(cgroup), because tg might access tg->css.cgroup.
> 
> With this change:
> 
> cgroup_rmdir()
>   ss->css_offline()    <-- unregister tg
> diput()
>   synchronize_rcu()    <-- wait possible refs to tg and cgroup
>   ss->css_free()       <-- free tg
>   kfree_rcu(cgroup)    <-- free cgroup
> 
> As you see, kfree_rcu() is redundant now.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks,

	Ingo
