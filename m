From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 00/16] slab accounting for memcg
Date: Fri, 21 Sep 2012 13:46:19 -0700
Message-ID: <20120921204619.GR7264@google.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=sCsJZ7Ci6KanKlI4FaMgG10hJx3Qp5IgCD1gq01hm7A=;
        b=KWsW8ix3MayizJfCccRWLjbSTHBDIr2AKK6KrB0vKNNEOZwGRbl5Gm4+i1UrkAsh6b
         qTyMqRIwrqoYWFIMDKC15KGOkt5YK97e5506J5Ob9EzBtcOJVM/LOCiVP8irs9+hzthU
         h5J6g6NEGY3fkz0Oo//cbjPio43SLWBB9aGuxTnCANlxmGhAn3Td4NsJUlHh6FAnGhGA
         z1bNZLXTa6yC8WB30Peh7UUJj7F/dgp+wi0Imy0NYjD1s9tuUw46bwYxPppOiFgPSWBQ
         g2H1D6k6ltR5MGWiQzuYBaWgjoK2OTLC6U3YsCtsuK+bXjonkW/oxfPttu+G4QWTlvpS
         O5LA==
Content-Disposition: inline
In-Reply-To: <1347977530-29755-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hello,

On Tue, Sep 18, 2012 at 06:11:54PM +0400, Glauber Costa wrote:
> This is a followup to the previous kmem series. I divided them logically
> so it gets easier for reviewers. But I believe they are ready to be merged
> together (although we can do a two-pass merge if people would prefer)
> 
> Throwaway git tree found at:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/glommer/memcg.git kmemcg-slab
> 
> There are mostly bugfixes since last submission.
> 
> For a detailed explanation about this series, please refer to my previous post
> (Subj: [PATCH v3 00/13] kmem controller for memcg.)

In general, things look good to me.  I think the basic approach is
manageable and does a decent job of avoiding introducing complications
on the usual code paths.

Pekka seems generally happy with the approach too.  Christoph, what do
you think?

Thanks.

-- 
tejun
