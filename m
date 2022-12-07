From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: speedup memory cgroup resize
Date: Wed, 7 Dec 2022 13:18:18 +0100
Message-ID: <Y5CEisw3waf2n3Gh@dhcp22.suse.cz>
References: <1670240992-28563-1-git-send-email-lirongqing@baidu.com>
 <CALvZod7_1oq1D73EKJHG1zQpeUp+QTPHmMRsL3Ka0f6XUfO4Eg@mail.gmail.com>
 <Y48aaCkgonOlMwNu@dhcp22.suse.cz>
 <cf7f485c3e7f4238b509d9dbbd084a2f@baidu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670415499; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XsWcyBnHXfZzUpbqAQNm8GZOpQrDrOtkcxsdqceJnRU=;
        b=G2DeFspat7QSz2ZZ9Uz6dCgSiUH8CiIXIzc1F8JeFQxFgLL52BnuU+bdqmfIJ2/b+ZFUGM
        oxa9NtCDWISy7o0XuYtMG8XyoDAtNCTgsL/l9lAYtMlN7FQD5wHdoP9K3W1YRY8P0+J4Kh
        RDcN/EN307hE3diHYMhw2eWy75PplOg=
Content-Disposition: inline
In-Reply-To: <cf7f485c3e7f4238b509d9dbbd084a2f-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Li,Rongqing" <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org" <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed 07-12-22 02:31:13, Li,Rongqing wrote:
> 
> 
> > -----Original Message-----
> > From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > Sent: Tuesday, December 6, 2022 6:33 PM
> > To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Li,Rongqing <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>; linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org;
> > cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org; roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org;
> > songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org; akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
> > Subject: Re: [PATCH] mm: memcontrol: speedup memory cgroup resize
> > 
> > On Mon 05-12-22 08:32:41, Shakeel Butt wrote:
> > > On Mon, Dec 5, 2022 at 3:49 AM <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org> wrote:
> > > >
> > > > From: Li RongQing <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
> > > >
> > > > when resize memory cgroup, avoid to free memory cgroup page one by
> > > > one, and try to free needed number pages once
> > > >
> > >
> > > It's not really one by one but SWAP_CLUSTER_MAX. Also can you share
> > > some experiment results on how much this patch is improving setting
> > > limits?
> > 
> 
> If try to resize a cgroup to reclaim 50 Gb memory, and this cgroup has
> lots of children cgroups who are reading files and alloc memory, this
> patch can speed 2 or more times.

Do you have any more specific numbers including a perf profile to see
where the additional time is spent? I find 2 times speed up rather hard
to believe. The memory reclaim itself should be more CPU heavy than
additional function calls doing the same in batches.

Also is this an example of a realistic usecase?

> > Besides a clear performance gain you should also think about a potential over
> > reclaim when the limit is reduced by a lot (there might be parallel reclaimers
> > competing with the limit resize).
> > 
> 
> to avoid over claim,  how about to try to free half memory once?

We should really focus on why would a larger batch result in a
noticeably better performance.
-- 
Michal Hocko
SUSE Labs
