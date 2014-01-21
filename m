From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Mon, 20 Jan 2014 22:08:09 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1401202204510.21729@chino.kir.corp.google.com>
References: <20140109144757.e95616b4280c049b22743a15@linux-foundation.org> <alpine.DEB.2.02.1401091551390.20263@chino.kir.corp.google.com> <20140109161246.57ea590f00ea5b61fdbf5f11@linux-foundation.org> <alpine.DEB.2.02.1401091613560.22649@chino.kir.corp.google.com>
 <20140110221432.GD6963@cmpxchg.org> <alpine.DEB.2.02.1401121404530.20999@chino.kir.corp.google.com> <20140115143449.GN8782@dhcp22.suse.cz> <alpine.DEB.2.02.1401151319580.10727@chino.kir.corp.google.com> <20140116093220.GC28157@dhcp22.suse.cz>
 <alpine.DEB.2.02.1401202155410.21729@chino.kir.corp.google.com> <20140121060428.GA19037@kroah.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=9xdSrgGBVlTEp4OP7Tt8Gg5Ld5R11L1bFh8OKwtOl98=;
        b=YS+KMTX8K5hgJ8s4G0dvsmZZXuT57xRVeRnQ6FDAvrtPN+5H0LUx4Uy5HNAkg3v5Ap
         UR2Hoa/dB2xnrASe1iucJ5etX0cODg+mpSWTWcwVwRNIn04eNKXAW003SKYFt04h5o0N
         V8c0ic4WgLWt35FlCw2KOcqDKNnU0zFUrusUNc512DDSHj+hQPeHsSQ2NbW9/gl8UAmV
         rGskh5GJ4ZPiA0xfM045ln7SGCZ1aoZxstz//zYfV1/QxRF79UGnkTfU+5wvOwJtEhSG
         NoV/d4OnO8ahq6DVYHVkpL7kQb1JpQFwwIJzX2N51vDlCTv40H2coiOLo0kY6uBlha8u
         s5Lg==
In-Reply-To: <20140121060428.GA19037-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartmann <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

On Mon, 20 Jan 2014, Greg Kroah-Hartmann wrote:

> > The patches getting proposed through -mm for stable boggles my mind
> > sometimes.
> 
> Do you have any objections to patches that I have taken for -stable?  If
> so, please let me know.
> 

You've haven't taken the ones that I outlined in 
http://marc.info/?l=linux-kernel&m=138580717728759, so I'm happy that 
those could be prevented.  I'm identifying another patch here that is 
pending in -mm that obviously violates the stable kernel rules and I don't 
believe it should be annotated in a way that you'll scoop it up later.

The patch in question hasn't been tested by anybody and I don't think you 
want such things to ever be merged into a stable kernel series.
