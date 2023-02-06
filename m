From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Using cgroup membership for resource access control?
Date: Mon, 6 Feb 2023 13:30:47 -1000
Message-ID: <Y+GNp4VA1T9pV6nM@slm.duckdns.org>
References: <Y+FvQbfTdcTe9GVu@agluck-desk3.sc.intel.com>
 <Y+F0NA9iI0zlONz7@slm.duckdns.org>
 <Y+F0mXS9z0flDhf7@slm.duckdns.org>
 <SJ1PR11MB6083C61BCA70A31F8C0F12ECFCDA9@SJ1PR11MB6083.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3I5S/XPIxpUgoBauf/+NPXEdSiTaYk3UCKZzofjtfLA=;
        b=Qj9V0ZBwFT0n8JqROyha9p0R+tnoKGnpJ2YXkenvZLANWuEAxElz5cGVevZ7f5Myef
         0dylM8kF3S19N3Ni4NJuD6qvsa+pW/u8S20R52FOceFhlvhzWu0EBHhlbVONcQGVtpes
         57ULIludUKISxLgdmzzcnTQzOppdr1sv/VEwzmQ46HAggY83MvMOD+qekM/RSRL1aeNe
         mJLaJ37mXRbSKxQqSW1JIUOnh0CvmQk9NiLb5JSPtgkTNcRIDDh8c2nMi1lmCIOqyD96
         GzD6WA0vrYg2bdd1Q9RvBqreOpxawJEbsaJYzuefMr5NaWQzNsvyG3v2MVoscZSJcTnc
         TAgg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083C61BCA70A31F8C0F12ECFCDA9-0NYKzF1JBnQoAmWoDslVMJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Thomas, Ramesh" <ramesh.thomas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hello,

On Mon, Feb 06, 2023 at 10:18:11PM +0000, Luck, Tony wrote:
> Imagine some AI training application with one process running per core on
> a server with a hundred or so cores. Each of these processes wants periodically
> to share work so far on a subset of the problem with one or more other processes.
> The "virtual windows" allow an accelerator device to copy data between a region
> in the source process (the owner of the virtual window) and another process that
> needs to access/supply updates.
> 
> Process tree is easy if the test is just "do these two tasks have the same getppid()?"
> Seems harder if the process tree is more complex and I want "Are these two processes
> both descended from a particular common ancestor?"
> 
> Using fd passing would involve an O(N^2) step where each process talks to each
> other process in turn to complete a link in the mesh of connections. This would need
> to be repeated if additional processes are started.

Wouldn't it be more usual for the parent to create the fd and let all the
children share through it? Even if not necessarily the parent, there can
always be a main process that can send the fd to whoever needs it.

> It would be much nicer to have an operation that matches what the applications
> want to do, namely "I want to broadcast-share this with all my peers".
>
> [N.B. I've suggested that these folks should just re-write their applications to
> simply attach to a giant blob of shared memory, and thus avoid all of this. But
> that doesn't fit for various reasons]

I'm not sure it'd be a good idea to introduce a whole new mode of access
control for this when it's something which can be addressed with more
conventional mechanisms. Maybe it's a bit more upfront work but one-off
security / naming mechanism feels like they'd have a reasonable chance to
cause long term headaches.

Thanks.

-- 
tejun
