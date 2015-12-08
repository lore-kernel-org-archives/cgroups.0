From: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: cgroup pids controller -- WARN_ON_ONCE triggering
Date: Tue, 8 Dec 2015 17:05:21 +0000
Message-ID: <20151208170521.GK9837@bark>
References: <20151208145851.GJ9837@bark>
 <20151208152428.GJ9175@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208152428.GJ9175-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Pitt <martin.pitt-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Tue, Dec 08, 2015 at 10:24:28AM -0500, Tejun Heo wrote:
> Hello, Andy.
> 
> On Tue, Dec 08, 2015 at 02:58:51PM +0000, Andy Whitcroft wrote:
> > Converting this to a printk I was able to obtain confirmation that we are
> > indeed seeing this go negative in some cases.
> > 
> > Reverting the above commit seems to resolve the early boot issues in
> > my testing.
> 
> Fix already queued in the following git branch.  Pushing it out as we
> speak.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.4-fixes
> 
> Thanks.

Cool, thanks.  That seems to fix me up here.

-apw
