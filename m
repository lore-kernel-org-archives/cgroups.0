From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
Date: Thu, 24 Jan 2013 11:04:34 +0100
Message-ID: <20130124100434.GD26351@gmail.com>
References: <5100D4FE.9080205@huawei.com>
 <5100D518.8000103@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=FMezeD8hfG6ooCyqPhV1pPqNWtClBY2XD4tSyIMgtjs=;
        b=U2iri0iG3I3vMm/L/tCl8ncMW5QhUJHCXKZjOhMRFb7xZwhwhaQV2p6uDAn9Rp7vkn
         2m27Bbwv02ie5A1J89yjDT9tKozzT3B25dAb02ies1gg9B/Lga5HbcsfckLTJp+eWQ+3
         y//yHb7OyGEXWQv+1Uq9ELDpTZ5ppKwNZE4nCaFbk7sqTXzyOkO5w2z+nRCHWBsXQC57
         /f0ViMMs5TyBYkLr4qoqiTbrlPCuPGMSlL9VjuSltl841RbsON23QOqp922TreMggcen
         Y8Xfp8K3CGJTbTJBQigDAPxlFecZj8E9io+68GIsDVT6abTrBVhOoIxp8ZS4fDOPrQk3
         F2zg==
Content-Disposition: inline
In-Reply-To: <5100D518.8000103-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


* Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:

>  extern struct task_group *sched_create_group(struct task_group *parent);
> +extern void sched_online_group(struct task_group *tg,
> +			       struct task_group *parent);
>  extern void sched_destroy_group(struct task_group *tg);
> +extern void sched_offline_group(struct task_group *tg);

Btw., a rename of these APIs might be in order, along the usual 
patterns:

  sched_task_group_create()
  sched_task_group_online()
  sched_task_group_offline()
  sched_task_group_destroy()

  etc.

that way the naming is more hierarchical and there's no clash 
with the sched_group concept which is about something else.

(In a separate patch.)

Thanks,

	Ingo
