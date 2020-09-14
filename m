From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH] mm: memcontrol: Fix out-of-bounds on the
 buf returned by memory_stat_format
Date: Mon, 14 Sep 2020 12:02:33 +0800
Message-ID: <CAMZfGtXNg31+8QLbUMj7f61Yg1Jgt0rPB7VTDE7qoopGCANGjA@mail.gmail.com>
References: <20200912155100.25578-1-songmuchun@bytedance.com> <20200912174241.eeaa771755915f27babf9322@linux-foundation.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dWdl+yaQbYEtdR4On3P7CGGpC+OD3QLDLkmMq6+C9k0=;
        b=CqIfTLtozQ3xvA/KXFvjkKb1zYdS2iyiXoVFEvA0vmD2FVJ2slyMgvSYQ00c8x7ytj
         mx61VL523WNZigppR8w4h/OfvHx0V+eROTHrLyDK0xMG3Q16At3IMZVLEVrm6smf4LQj
         Hm2mKdquGXG4js/HGAiwxp+2xYuFK3YPdudZHFzhQszumUV3IJSRZXKjZiuVessize+V
         ceqaoE/OpxcPAb+ASWwOkBOjlZ2MFCpWp48AaphS6mTD39B20SZQ+OCgYZ6qytmaRPnu
         A2P4M7baDBpOgQzsToSWLad01UMxaRUgCxc8NUQeTxn+66zGl7EL2Ao3fNh+GKSwaLUX
         c4zw==
In-Reply-To: <20200912174241.eeaa771755915f27babf9322-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun, Sep 13, 2020 at 8:42 AM Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> On Sat, 12 Sep 2020 23:51:00 +0800 Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
>
> > The memory_stat_format() returns a format string, but the return buf
> > may not including the trailing '\0'. So the users may read the buf
> > out of bounds.
>
> That sounds serious.  Is a cc:stable appropriate?
>

Yeah, I think we should cc:stable.

-- 
Yours,
Muchun
