From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] cgroup: minor cleanup for cgroup_local_stat_show()
Date: Thu, 3 Aug 2023 10:05:33 -0700
Message-ID: <20230803100533.a9bdac370de2e8e4bee0f33a@linux-foundation.org>
References: <20230803113123.577023-1-linmiaohe@huawei.com>
        <20230803142758.GC219857@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691082334;
        bh=mKXYwoVy5HfvYiKywnPPMjvSi6Q9LzPXn0QPxBh7klc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sR/84AOqkNrlcyI3Mg///cmnKs9K7ETOFfWUvoe1dfQx5DKvUhLK0PQV/VfacxYKJ
         c9FskuPuzEyD0/Tut7Eg8+l/huwAJp84RU/+2om1L2s6CgrKvpPktF5KRDDNtb/hjd
         y3DtIqnBfSiziLpvk1Mk36RNcIEzzVBWcY1gLVII=
In-Reply-To: <20230803142758.GC219857-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, 3 Aug 2023 10:27:58 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> > @@ -3686,8 +3686,9 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
> >  	return ret;
> >  }
> >  
> > -static int __maybe_unused cgroup_local_stat_show(struct seq_file *seq,
> > -						 struct cgroup *cgrp, int ssid)
> > +#ifdef CONFIG_CGROUP_SCHED
> > +static int cgroup_local_stat_show(struct seq_file *seq,
> > +				  struct cgroup *cgrp, int ssid)
> 
> Andrew, this is based on "sched: add throttled time stat for throttled
> children" in -next (coming in from -tip). Hence the routing through
> you rather than the cgroup tree.

Since switching to the more gitty workflow I have lost the power to
carry patches against -next.  I could regain that power I guess, but
this is the first time the requirement has come up.

So for now I'll save this patch away for the next -rc cycle.
