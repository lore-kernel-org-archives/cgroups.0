From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH REPOST 2/2] cgroup, perf_event: make perf_event
 controller work on cgroup2 hierarchy
Date: Mon, 30 Jan 2017 10:07:33 -0500
Message-ID: <20170130150733.GA4568@htj.duckdns.org>
References: <1456351975-1899-1-git-send-email-tj@kernel.org>
 <1456351975-1899-3-git-send-email-tj@kernel.org>
 <20170129193520.GA18336@mtj.duckdns.org>
 <20170130140541.GG9082@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pCqiNMs6bU2i62SZI7fSvO2LEsX48ICK+o+M7ATqFLQ=;
        b=SYJPr1o3zOUHb+m8rYlKPDY+Y4FOD/eh5ynCgskqBujp0jsTKMseX3Lp7EdYCvaE+E
         zqiyT4oXi0f5gBvrsRoisHHF2PL+ToevnD55I90Xe/7459VU11dtbjWO3ut891iPvRen
         F4fzdrUSM9FS+TRoHMPl9ob0ISiVlo53E4WSpRh1Hl75pyyXw9GQuiq4qrpTL5q0IgzS
         WK5zIAoNPuaqmwRkOTSMVrYG1BWN9Czir4qcgzzLpgtCY7GfDJmnBxPT6ZTlMZQia3ib
         56N1y9ctRh2P6EAQP3T9f6yg+PWV21U/lgHzXsVKcX2jtlmqMVLvyHDuHB1KojgN4OY/
         h8ow==
Content-Disposition: inline
In-Reply-To: <20170130140541.GG9082-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Mon, Jan 30, 2017 at 11:05:41AM -0300, Arnaldo Carvalho de Melo wrote:
> > This was posted months ago and acked by Peter.  I thought it was
> > applied but apparently wasn't.  Peter asked Arnaldo whether the
> > userspace part looked which didn't get replied and that probably was
> > how it slipped through the crack.
> > 
> > Peter, Arnanldo, how should we proceed?  Should I route this through
> > the cgroup tree?
> 
> It looks ok, haven't tested it tho. I don't have a problem for it to go
> thru the cgroup tree. The change is small and restrictred to cgroup
> glue in tools/perf/.

Alright, thanks.  Will apply it to cgroup/for-4.11 in a couple days.
If there's any objection, please holler.

Thanks.

-- 
tejun
