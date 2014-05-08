From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.16] cgroup: rename css_tryget*() to
 css_tryget_online*()
Date: Thu, 8 May 2014 14:36:22 -0400
Message-ID: <20140508183622.GR19914@cmpxchg.org>
References: <20140507160429.GE26540@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=5NMZSHqNT0ESRV5tAMBy1D9TRlE1kmYzVrLXHUDn9tE=;
	b=sADf3c47qDbAmx9/0jHAPOklL7VJyEYMVcHiuX6cf/OPdC71a+FmjcpeMzsc0UYscCY3eVFIbMSfYka2F29p+A2BQKH2Y2HZeDwPN0IEUeTIWRM4XJ2gAkYXIAAU8uwwxCr2wFJvwEEULe+loAaaDC0EyKGMnbTMjvaLTKrx4Gg=;
Content-Disposition: inline
In-Reply-To: <20140507160429.GE26540-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 07, 2014 at 12:04:29PM -0400, Tejun Heo wrote:
> Unlike the more usual refcnting, what css_tryget() provides is the
> distinction between online and offline csses instead of protection
> against upping a refcnt which already reached zero.  cgroup is
> planning to provide actual tryget which fails if the refcnt already
> reached zero.  Let's rename the existing trygets so that they clearly
> indicate that they're onliness.
> 
> I thought about keeping the existing names as-are and introducing new
> names for the planned actual tryget; however, given that each
> controller participates in the synchronization of the online state, it
> seems worthwhile to make it explicit that these functions are about
> on/offline state.
> 
> Rename css_tryget() to css_tryget_online() and css_tryget_from_dir()
> to css_tryget_online_from_dir().  This is pure rename.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
> Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
