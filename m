From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 3/5] x86: finish fault error path with fatal signal
Date: Thu, 25 Jul 2013 17:50:33 -0400
Message-ID: <20130725215033.GP715@cmpxchg.org>
References: <20130714015112.FFCB7AF7@pobox.sk>
 <20130715154119.GA32435@dhcp22.suse.cz>
 <20130715160006.GB32435@dhcp22.suse.cz>
 <20130716153544.GX17812@cmpxchg.org>
 <20130716160905.GA20018@dhcp22.suse.cz>
 <20130716164830.GZ17812@cmpxchg.org>
 <20130719042124.GC17812@cmpxchg.org>
 <20130719042502.GF17812@cmpxchg.org>
 <20130724203205.GL715@cmpxchg.org>
 <51F18A99.7000306@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F18A99.7000306-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, righi.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Thu, Jul 25, 2013 at 04:29:13PM -0400, KOSAKI Motohiro wrote:
> (7/24/13 4:32 PM), Johannes Weiner wrote:
> >@@ -1189,9 +1174,17 @@ good_area:
> >  	 */
> >  	fault = handle_mm_fault(mm, vma, address, flags);
> >
> >-	if (unlikely(fault & (VM_FAULT_RETRY|VM_FAULT_ERROR))) {
> >-		if (mm_fault_error(regs, error_code, address, fault))
> >-			return;
> >+	/*
> >+	 * If we need to retry but a fatal signal is pending, handle the
> >+	 * signal first. We do not need to release the mmap_sem because it
> >+	 * would already be released in __lock_page_or_retry in mm/filemap.c.
> >+	 */
> >+	if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current))
> >+		return;
> >+
> >+	if (unlikely(fault & VM_FAULT_ERROR)) {
> >+		mm_fault_error(regs, error_code, address, fault);
> >+		return;
> >  	}
> 
> When I made the patch you removed code, Ingo suggested we need put all rare case code
> into if(unlikely()) block. Yes, this is purely micro optimization. But it is not costly
> to maintain.

Fair enough, thanks for the heads up!
