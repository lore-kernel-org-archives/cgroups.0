From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Wed, 27 Nov 2013 22:16:10 -0500
Message-ID: <20131128031610.GL3556@cmpxchg.org>
References: <20131118154115.GA3556@cmpxchg.org>
 <20131118165110.GE32623@dhcp22.suse.cz>
 <20131122165100.GN3556@cmpxchg.org>
 <alpine.DEB.2.02.1311261648570.21003@chino.kir.corp.google.com>
 <20131127163435.GA3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271343250.9222@chino.kir.corp.google.com>
 <20131127231931.GG3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271613340.10617@chino.kir.corp.google.com>
 <20131128022804.GJ3556@cmpxchg.org>
 <alpine.DEB.2.02.1311271839290.5120@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=6pZLwGteRtpFjwJLVda/Ykln84VFpHZi7FmeXXw23G0=;
	b=t5u7DiPfLvLfrFVp9dVJI8lENJAwK/193f1T/r6dGqlo6CkXf7uq2rGYtrMsZ2OOaHPMqudkvWejeedB+1cyIqJu+ZoVFBosCwFG6x/pCmJSJ2fOqGN9yCOWKp74UBgu8iEnD5WWB2hPCw9GfWEXoAhjHGGBZitkGsngyY72zHU=;
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311271839290.5120-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 27, 2013 at 06:52:10PM -0800, David Rientjes wrote:
> On Wed, 27 Nov 2013, Johannes Weiner wrote:
> 
> > The long-standing, user-visible definition of the current line agrees
> > with me.  You can't just redefine this, period.
> > 
> > I tried to explain to you how insane the motivation for this patch is,
> > but it does not look like you are reading what I write.  But you don't
> > get to change user-visible behavior just like that anyway, much less
> > so without a sane reason, so this was a complete waste of time :-(
> > 
> 
> If you would like to leave this to Andrew's decision, that's fine.  
> Michal has already agreed with my patch and has acked it in -mm.
> 
> If userspace is going to handle oom conditions, which is possible today 
> and will be extended in the future, then it should only wakeup as a last 
> resort when there is no possibility of future memory freeing.

I'll ack a patch that accomplishes that.
