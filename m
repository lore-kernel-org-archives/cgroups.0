From: Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IPC: account for kmem usage on mqueue and msg
Date: Tue, 18 Oct 2016 22:30:21 +0300
Message-ID: <20161018193021.GA2953@p183.telecom.by>
References: <1476806075-1210-1-git-send-email-arozansk@redhat.com>
 <20161018182619.GB27792@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Rzvnxz0Vef7TLKc51RXl9wG3gbKOWcJnDUWq6ZUkqEw=;
        b=WiLA62L4CDUw1VO4oXonPJBWrcHZWFSfsCRs/NacI6rx87qlJt/Ub/C/wPkoWUs2JB
         /fZIDgtoMzgTCMxsy2XYfbiM1rdaDrz2HKTewISGGCQvrmHKkm2Y1u7lfHskEFjty1MR
         Sy5j+FnrISaZiTvdsBx+xFv1hL+hdUuwewTV9akZyVB+IzsyUzdeuC0f0/XyoJdQidHg
         Rn5tlT83dsVZUxI3v0n4EGl1STCf3Tm0CV7tXrhWnpp2BYSz3vcguljDb4HXWE0Blcb3
         5WaZmYwMXtPxFq3+HTFXHNBmLEXmvkLHLq3MOIyv1HtPCuu7QiP2xvmQa0wifr7hmWlM
         gTPA==
Content-Disposition: inline
In-Reply-To: <20161018182619.GB27792-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Stefan Schimanski <sttts-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Oct 18, 2016 at 08:26:19PM +0200, Michal Hocko wrote:
> On Tue 18-10-16 11:54:35, Aristeu Rozanski wrote:
> > When kmem accounting switched from account by default to only account if
> > flagged by __GFP_ACCOUNT, IPC mqueue and messages was left out.
> 
> I guess this was because ipv msgqueue shouldn't allow for memory
> consumption runaways. The number of message queues and messages pending
> in them is bounded and not a large amount of memory AFAIR. Anyway I do
> not see anything unreasonable about accounting the memory to the caller.

It should be accounted because receiver may not intentionally or unintentionally
consume messages.
