From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: add cgroup->id
Date: Mon, 19 Nov 2012 23:08:51 -0800
Message-ID: <20121120070851.GG25790@mtj.dyndns.org>
References: <1353093624-22608-1-git-send-email-tj@kernel.org>
 <1353093624-22608-2-git-send-email-tj@kernel.org>
 <50AB086E.70901@jp.fujitsu.com>
 <20121120053112.GE25790@mtj.dyndns.org>
 <50AB2BCF.2050204@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=WOmC3dLYNQogEYifHfTPYt9HKO96QyWx3E6YNcV4X08=;
        b=yN9OWe3B+l+A27MtDLEazR0WyPIUTKpMpOfmZM5KXdOVuLvUyfgr3usZIZYU8M0Miz
         bkj14NdKZDzxcg0x9qZ06aS4ATR2I3DM1GtKJniP48Ikky36TIOV4uWlvGH3SaU/Jxiz
         iM3gq5aRkgqAIJQ4ETje1e9gJuI3cg3HnOj+lN/F+457LhMZSirviUCKcx0WLTxx8zoR
         QAXSiXHkbp9EjPqEtje8wq1BTG9FpfLelQ+Gf/i/MzTw0j5G1rhF3UbXHvNtBWt3QFDH
         ScCDZ+QrKEotIE3RzCZEySiKgqogelrCZHhx4pxrqMIILtdfHR0e4k5bp9/xjSgMA+jp
         jh9Q==
Content-Disposition: inline
In-Reply-To: <50AB2BCF.2050204-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org, srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Kamezawa.

On Tue, Nov 20, 2012 at 04:05:51PM +0900, Kamezawa Hiroyuki wrote:
> BTW, css's ID was limited to 65535 to be encoded in 2bytes.
> If we use INT, this will increase size of swap_cgroup.
> (2bytes per page => 4bytes per page) It's preallocated at swapon()
> because allocating memory dynamically when we swap a memory is not good.
> 
> Do we really need 4bytes for ID ? If so, swap_cgroup should be totally re-designed.

That's a memcg restriction which shouldn't have been imposed on cgroup
core from the beginning.  What memcg should do is rejecting to become
online from ->css_onilne() if cgrp->id is out of the range it can
handle.

Thanks.

-- 
tejun
