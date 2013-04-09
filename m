From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 13/12] memcg: don't need memcg->memcg_name
Date: Mon, 8 Apr 2013 20:59:07 -0700
Message-ID: <20130409035907.GA4565@mtj.dyndns.org>
References: <5162648B.9070802@huawei.com>
 <51626584.7050405@huawei.com>
 <5163868B.3020905@jp.fujitsu.com>
 <5163887D.1040809@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=pEIL9/Lodg5PGpj1nhbROg/XZdpm/SvFEDTdqIaZyhQ=;
        b=S1TLHy4jew+34ge0R5LbxT3ocgP0p8m6rJsDtsTFHl5sXRhZLVS+4lkWrsPW/qY1np
         azCqON7vhnvKim11thqjIgpQSBUWg9SopPDRQ07okeQikr4futluMeP00x9hxndTYCb1
         vdSO9Mw48qxfO8gs4KfRvqk2uCUJ9so6bHrxzgLf3Yl3mRqtCx5l46mnn78B+X5ir3dB
         zJUY3e95D+16+A4Z7Wyr5NeSuncQmthqCI3JIsLwADyk32fCLx0KlVThhkrbi/80C4W5
         23PX089/x68ckPwQcq9ZrAddOVrhiPZxZuqkiNS37xqy/R4m1Ob6EVK+3SbPsd3dhU5H
         oyNA==
Content-Disposition: inline
In-Reply-To: <5163887D.1040809-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Apr 09, 2013 at 11:18:21AM +0800, Li Zefan wrote:
> >> -		if (memcg->memcg_name)
> >> -			seq_printf(m, "%s:\n", memcg->memcg_name);
> >> +		ret = cgroup_path(memcg->css.cgroup, memcg_name, PAGE_SIZE);
> >> +		if (!ret)
> >> +			seq_printf(m, "%s:\n", memcg_name);
> >>   		else
> >>   			seq_printf(m, "%p (name lost):\n", memcg);
> >>   
> > 
> > I'm sorry for dawm question ...when this error happens ?
> > We may get ENAMETOOLONG even with PAGE_SIZE(>=4096bytes) buffer ?
> > 
> 
> It does no harm to check the return value, and we don't have to
> worry about if cgroup_path() will be changed to return some other
> errno like ENOMEM in the future.

Maybe change the function to return the length of the path regardless
of the specified buffer length?  ie. as in snprintf()?

-- 
tejun
