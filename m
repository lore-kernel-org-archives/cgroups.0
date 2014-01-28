From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: update MAINTAINERS entry
Date: Mon, 27 Jan 2014 22:33:40 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401272232150.17436@chino.kir.corp.google.com>
References: <52E72405.7070402@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=WVRf8nXEZd9/dPc3ktQ7KjPs477tFQis+W9t98LLk3Q=;
        b=lgVbvefOL+Kc+RDUTl/WJ0UDGTRW33rV15qU1Ux72C9yB969m0IAbKyBsH8CfIJWlN
         aWUJcIcIOqnbXXfBnHr5/DIY0tKVTjt7yPPyCluYwCwXoGAx5thfWJhovTWT1JtRMOjl
         Oqp9RsuH3Bd1TyvcJh/mHS8BcSKQ+SKSqlhjBelCYNDWTu4sXOK3CFkW8A7xebYSBbih
         hv+WFePjan2ljIfVOhfOkEMu9F/ec5pNDre8KoQmW70JJcdC/37hi0cAtzA9ydeekCEs
         LZZJTrrP6ye5C9uC0PPOrU5XJCilteK4ek6ZwrMoc14iJhLzLpvtVUZ49J9HNT4FICfK
         DJpw==
In-Reply-To: <52E72405.7070402-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, 28 Jan 2014, Li Zefan wrote:

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8285ed4..81bcbe0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2376,8 +2376,10 @@ F:	tools/power/cpupower/
>  
>  CPUSETS
>  M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> +L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  W:	http://www.bullopensource.org/cpuset/
>  W:	http://oss.sgi.com/projects/cpusets/
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
>  S:	Maintained
>  F:	Documentation/cgroups/cpusets.txt
>  F:	include/linux/cpuset.h

It seems like Tejun would obviously be a maintainer as well?
