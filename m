From: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 2/6] arch: mm: do not invoke OOM killer on kernel fault
 OOM
Date: Mon, 29 Jul 2013 14:58:05 -0400
Message-ID: <51F6BB3D.6000700@gmail.com>
References: <1374791138-15665-1-git-send-email-hannes@cmpxchg.org> <1374791138-15665-3-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=8H2jMA4SFXl/H9XJv9jUPRz+GMNPY/tczbyLx5LKfRQ=;
        b=XaDOlq2Lhzoklo5eSGTSxjBkNxVc4CWVKNDVFot4B10klG/CXP+CDAJMk/1Wca5Ktp
         AkVGRQ+5UUd2cYACwQXDrD10uE2DWqJA/AbH4LJviPvhumvqROf69ghW2EyB4XTEOpo2
         VtDP8IgG58ft08rLjfopypyl06BMf9OdX7VHYskfsCB2/PQFIBilFcp9MxV+rgaMIwEJ
         xFltSFz6dvokauZqi8/efgKSBXRxrBbYxWjXN4j11zLHHaeV88IQsjixtsU70/xBrGB2
         2kbUa84u1KDr37ccNJVqsMt8sPdzkMXNTLAEEMB/pEbTqt2ylAKRQUV+O50zylLzapE6
         siDg==
In-Reply-To: <1374791138-15665-3-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

(7/25/13 6:25 PM), Johannes Weiner wrote:
> Kernel faults are expected to handle OOM conditions gracefully (gup,
> uaccess etc.), so they should never invoke the OOM killer.  Reserve
> this for faults triggered in user context when it is the only option.
> 
> Most architectures already do this, fix up the remaining few.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

OK. but now almost all arch have the same page fault handler. So, I think
we can implement arch generic page fault handler in future. Ah, ok, never
mind if you are not interest.

Acked-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
