From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Date: Mon, 6 Jan 2014 22:26:23 +0100
Message-ID: <20140106212623.GH30183@twins.programming.kicks-ass.net>
References: <20140104161050.GA24306@htj.dyndns.org>
 <1388875369.9761.25.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140104225058.GC24306@htj.dyndns.org>
 <1388899376.9761.45.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106111624.GB5623@twins.programming.kicks-ass.net>
 <1389026035.32504.3.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106164150.GQ31570@twins.programming.kicks-ass.net>
 <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106180636.GG30183@twins.programming.kicks-ass.net>
 <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1389039035.32504.35.camel-29DAm2eTeB2q+SSgkFU3IPooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Jan 06, 2014 at 08:10:45PM +0000, Waskiewicz Jr, Peter P wrote:
> There is one per logical CPU.  However, in the current generation, they
> report on the usage of the same L3 cache.  But the CPU takes care of the
> resolution of which MSR write and read comes from the logical CPU, so
> software doesn't need to lock access to it from different CPUs.

What are the rules of RMIDs, I can't seem to find that in the SDM and I
think you're tagging cachelines with them. Which would mean that in
order to (re) use them you need a complete cache (L3) wipe.

Without a wipe you keep having stale entries of the former user and no
clear indication on when your numbers are any good.

Also, is there any sane way of shooting down the entire L3?
