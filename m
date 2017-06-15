From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET for-4.13] cgroup: implement cgroup2 thread mode, v2
Date: Thu, 15 Jun 2017 16:16:27 -0400
Message-ID: <20170615201627.GB25445@htj.duckdns.org>
References: <20170610140351.10703-1-tj@kernel.org>
 <20170612123150.scopfxela7v26dct@hirez.programming.kicks-ass.net>
 <20170612212753.GN19206@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nrZ3/3W4e8iqXImkOFuTR2urkjYqfS3ZXORhzYvrMZY=;
        b=WiPzGVZl7voBzX7auaDSmb+nhgLNc8LQG2mAeOckgCSQamuBkWCKPli65hPkY+wubl
         QLrn+j1oPw2bkOclJ/KMTFySI0gRlDf9aXvpo1UQxvwNw6rC4psIkNxBdsNAuYqQdm+V
         RaaQNx+fa+J8yElpCQ6YOm29jULobIWp4Yh9aB5DtgV79oOW0+ES79zgsgbhJbcYDVWF
         LPaBdr8qAwcODieJtlep8WlPCBHtaKZ/XULqM3xk+5qTSIMuA4DXA9S8LD5yKC9q4k5v
         D4YMaEvvZ2Aqn1L9Uhv3GS0X0k4dZsfEig/X5MdUw60nR5aGKoNq1J5J39xugzCxcApm
         Sf4Q==
Content-Disposition: inline
In-Reply-To: <20170612212753.GN19206-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello,

On Mon, Jun 12, 2017 at 05:27:53PM -0400, Tejun Heo wrote:
> The previous iteration actually was that way, so the only thread mode
> operation was setting whether to enable thread or not as before and if
> the parent is already thread mode, it'd always join the existing
> threaded subtree.  If you like that better, I can post that version
> right away.

Just posted v3 of the patch which drops the "join" operation, but do
note that this inherently comes at the cost of losing the ability
express certain topologies.

Thanks.

-- 
tejun
