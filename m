From: yong w <yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] mm: Add configuration to control whether vmpressure
 notifier is enabled
Date: Sun, 22 Aug 2021 17:46:08 +0800
Message-ID: <CAOH5QeDUUqrMnuws6cnBDU_oub4cK6KsHeX39p7Eikr4Bcjcnw@mail.gmail.com>
References: <1629417219-74853-1-git-send-email-wang.yong12@zte.com.cn>
 <YR+Rc9HC6OqlEq4I@dhcp22.suse.cz> <CAOH5QeCfwF0hX3XpoThEtwnddtOFEU9Jtp0Hoj+Q37D4Q6HC0Q@mail.gmail.com>
 <YR/NRJEhPKRQ1r22@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0e3vNQgHPFxuVsKWr/oiMNC9HxWPWcJlOWQMgnCyZR0=;
        b=fc7l3zQQBiTvLtZ8kw7ugWuyAEkBM9yOfrxUda3mcyP2YOK/iuevz3ldkBdbTGAFLR
         NjU2QWLhmeb4es1ZtlCij3Ejl4pkK4OIqFC1XRUgurK338ndY3KSx9Ql/OZeNNPQ0LRs
         srT8tXDwVj5+QHv0uUcPx9Vn7se2owBwg+f4hXjPxOx9gKWu8t7LY/ycUcicpxdPei5r
         VKO9/Qm5WAZshb3BK5bPL2m6uAtiVFURCJ5iD97XSPCW2mc1sai0KIr3XVgvPUzeBCFB
         Gblig3buVPTC0GFSM7kZXGvulIrou6p8bsvPfTNH9k/SwYk/E6YhPasCoj9jpPr6utP+
         T09g==
In-Reply-To: <YR/NRJEhPKRQ1r22-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hui Su <sh_def-9Onoh4P/yGk@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

> All those reasons should be a part of the changelog.
>....
> I am not sure these are sufficient justifications but that is something
> to discuss. And hence it should be a part of the changelog.
>
OK, These reasons will be added to the patch notesin later versions.

> > 3. In the case where the user does not need vmpressure,  vmpressure
> > calculation is additional overhead.
>
> You should quantify that and argue why that overhead cannot be further
> reduced without config/boot time knobs.
>
The test results of the previously used PFT tool may not be obvious.
Is there a better way to quantify it?

> > In some special scenes with tight memory, vmpressure will be executed
> > frequently.we use "likely" and "inline"
> > to improve the performance of the kernel, why not reduce some
> > unnecessary calculations?
>
> I am all for improving the code. Is it possible to do it by other means?
> E.g. reduce a potential overhead when there no events registered?
Yes, the method you mentioned may be feasible, but it does not conflict
with this patch.

Thanks.
