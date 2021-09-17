From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: KCSAN: data-race in cgroup_rstat_flush_locked /
 cgroup_rstat_updated
Date: Fri, 17 Sep 2021 18:41:23 +0200
Message-ID: <20210917164123.GA13346@blackbody.suse.cz>
References: <CACkBjsbPVdkub=e-E-p1WBOLxS515ith-53SFdmFHWV_QMo40w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631896884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HwaqMdctCtkMhcrq7X60eNjofQ9lWwgd/iusn9WBbEA=;
        b=PbJoSdNsPCqlSw0D7Sh3n5rTllj5/wyXxBazr+qWOZMoQQlBybauEnqI8Gm8V/sIq94w/D
        Lcp7rqPruJvO6LS5nLeXi8LvYc/Ap59lR/G+GBU1X9xN+Ig4Ea3rZYKd4MMetz4fi95PKC
        R0JnTVpP0tBXTFhSmBy091qmE2UTVcI=
Content-Disposition: inline
In-Reply-To: <CACkBjsbPVdkub=e-E-p1WBOLxS515ith-53SFdmFHWV_QMo40w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hello Hao.

On Thu, Sep 16, 2021 at 09:53:55PM +0800, Hao Sun <sunhao.th-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> KCSAN reported the following data race during the kernel booting when
> using Healer to fuzz the latest Linux kernel.
> [...]
>  cgroup_rstat_cpu_pop_updated kernel/cgroup/rstat.c:139 [inline]
>  [...]
>  cgroup_rstat_updated+0x53/0x1b0 kernel/cgroup/rstat.c:38

FWIW, it's a "safe" race between updaters and flushers (possibly
missing the latest update(s)). This is expected as explained in
cgroup_rstat_updated() comment.

Michal
