From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Mon, 14 Sep 2015 11:21:13 -0400
Message-ID: <20150914152113.GA20047@mtj.duckdns.org>
References: <20150910202210.GL8114@mtj.duckdns.org>
 <CAG53R5WtuPA=J_GYPzNTAKbjB1r0K90qhXEDxLNf7vxYyxgrKA@mail.gmail.com>
 <20150911040413.GA18850@htj.duckdns.org>
 <55F25781.20308@redhat.com>
 <20150911145213.GQ8114@mtj.duckdns.org>
 <1828884A29C6694DAF28B7E6B8A82373A903A586@ORSMSX109.amr.corp.intel.com>
 <20150911194311.GA18755@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A903A5DB@ORSMSX109.amr.corp.intel.com>
 <CAG53R5XsMwnLK7L4q1mQx3_wEJNv1qthOr5TsX0o43kRWaiWrg@mail.gmail.com>
 <CAG53R5U7sYnR2w+Wrhh58Ud1HOrKLDCYxZZgK58FyAkJ8exshw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=M2vuJSALWRUS7zbPwPoMdv5epwVJSeSnT5IvBbM4iGU=;
        b=f9bSvFeFpm7n5hqxdjtr31Dd4z4iQG+gb5dDMO2JXgEDzeVue3nH8OuFtKJ69TXJjh
         0/LsCOs2hmcXifVRASOdlocISnZlKe6rXOsz3b0K0lxfEpNfLXb5QsmT4fZowM5kbPVu
         O5zYq5TS5haa+TXw07/Df98c+lkYrZEQG4AEVd57xeeR/7fnZfdthqvuq6DCyyBmTrtk
         MPicK4v/b5SmTUYBBP/dEshK1ceLnl+fvyrLCyfMiqwTbu0Hir21N+D/rY4VDTjqMXJY
         Jv1bVZaZN3AMySm7OvvaYMa5WErLNrkhzMRYO6au3faL79OTma33/vMfFh1uyc0NckXw
         Z79g==
Content-Disposition: inline
In-Reply-To: <CAG53R5U7sYnR2w+Wrhh58Ud1HOrKLDCYxZZgK58FyAkJ8exshw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Parav.

On Mon, Sep 14, 2015 at 07:34:09PM +0530, Parav Pandit wrote:
> I missed to acknowledge your point that we need both - hard limit and
> soft limit/weight. Current patchset is only based on hard limit.
> I see that weight would be another helfpul layer in chain that we can
> implement after this as incremental that makes review, debugging
> manageable?

At this point, I'm very unsure that doing this as a cgroup controller
is a good direction.  From userland interface standpoint, publishing a
cgroup controller is a big commitment.  It is true that we haven't
been doing a good job of gatekeeping or polishing controller
interfaces but we're trying hard to change that and what's being
proposed in this thread doesn't really seem to be mature enough.  It's
not even clear what's being identified as resources here are things
that the users would actually care about or if it's even possible to
implement sensible resource control in the kernel via the proposed
resource restrictions.

So, I'd suggest going back to the board and figuring out what the
actual resources are, their distribution strategies should be and at
which layer such strategies can be implemented best.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
