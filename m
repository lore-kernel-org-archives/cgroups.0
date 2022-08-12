From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Fri, 12 Aug 2022 12:14:44 +0200
Message-ID: <YvYoFNDMdg6mdFbU@blackbook>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660299286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZbZXqZhVMx97LH/wfbkAQvfgc1/NDVE/NEBNZNQzYTU=;
        b=GiRwDUFguJx6UvwA2htp1tu/od4+/MgY/Ty7gEBk9JA03HG8yddGZJKVoyZfXc22LFyX/7
        fsAhQ/NV/xEVrOr12UZ9Skp2vUueX3AnUd8NKHbZulNBtlMuqR83lmlBIZ3GzXWqC01Kwo
        Z8akVkNyRUB1+GfFYrb6Yvt6Q8gw02w=
Content-Disposition: inline
In-Reply-To: <20220808110341.15799-10-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello Chengming.

On Mon, Aug 08, 2022 at 07:03:40PM +0800, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index dd84e34bc051..ade40506ab80 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -968,6 +968,13 @@ All cgroup core files are prefixed with "cgroup."
>  	killing cgroups is a process directed operation, i.e. it affects
>  	the whole thread-group.
>  
> +  cgroup.psi
> +	A read-write single value file that allowed values are "0" and "1".
> +	The default is "1".
> +
> +	Writing "0" to the file will disable the cgroup PSI stats accounting.
> +	Writing "1" to the file will re-enable the cgroup PSI stats accounting.
> +

I'd suggest explaining here explicitely, this control attribute is not
hierarchical (i.e. PSI accounting in a cgroup does not affect accounting
in descendants and doesn't need pass enablement via ancestors from
root). And the purpose that it "saves" cycles (where).

Regards,
Michal
