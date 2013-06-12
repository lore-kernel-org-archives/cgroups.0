From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 2/2] memcg: do not sleep on OOM waitqueue with full
 charge context
Date: Wed, 12 Jun 2013 22:37:05 +0200
Message-ID: <20130612203705.GB17282@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1306052058340.25115@chino.kir.corp.google.com>
 <20130606053315.GB9406@cmpxchg.org>
 <20130606173355.GB27226@cmpxchg.org>
 <alpine.DEB.2.02.1306061308320.9493@chino.kir.corp.google.com>
 <20130606215425.GM15721@cmpxchg.org>
 <alpine.DEB.2.02.1306061507330.15503@chino.kir.corp.google.com>
 <20130607000222.GT15576@cmpxchg.org>
 <alpine.DEB.2.02.1306111454030.4803@chino.kir.corp.google.com>
 <20130612082817.GA6706@dhcp22.suse.cz>
 <alpine.DEB.2.02.1306121309500.23348@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=haDWoOmjHMkofhTjamG/zF4VL6azFyVK9+Zek4EHA6c=;
        b=JeM67OiNb4MpyT77RxZSkf6BGn79b5F1baJ7JP2n6DYPPv18hl1x3dXKVDe2Ye1Tb0
         MVeESeKLNu5f6BcaEvjCLCiXh8rx3aph+A9RTLh//XJ470CxVCwx8pHeVnuAJBcs3qYl
         3q6UheR/K0+z+vNwWjQMxCtWdFTS6KL8pmQPUwpoBjWvI6vLygvoOXX3CCv4rHc9sjxC
         GLSic0n2PWexK/KrsAnHjr4oAbPzoFesnGq3T/38Kz0LZMBzFu1ICQ/LN0a248UTKbbS
         UlPCS9VVG0HXD9ga4aNrybgM/DuAhmezIv8GOgnbuvUu20GknnD8xUZoxaeqmyC8GWFw
         nLSw==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1306121309500.23348@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed 12-06-13 13:12:09, David Rientjes wrote:
> On Wed, 12 Jun 2013, Michal Hocko wrote:
> 
> > > > > > > > Reported-by: Reported-by: azurIt <azurit@pobox.sk>
> > > 
> > > Ok, so the key here is that azurIt was able to reliably reproduce this 
> > > issue and now it has been resurrected after seven months of silence since 
> > > that thread.  I also notice that azurIt isn't cc'd on this thread.  Do we 
> > > know if this is still a problem?
> > 
> > I have backported the patch for his 3.2 and waiting for his feedback.
> > 
> 
> Ok, thanks.  I thought this was only going seven months back when it was 
> reported, I missed that the issue this patch is trying to address goes 
> back a 1 1/2 years to 3.2 and nobody else has reported it.  I think his 
> feedback would be the key, specifically if he can upgrade to a later 
> kernel first.

The patch is a big improvement with a minimum code overhead. Blocking
any task which sits on top of an unpredictable amount of locks is just
broken. So regardless how many users are affected we should merge it and
backport to stable trees. The problem is there since ever. We seem to
be surprisingly lucky to not hit this more often.

I am not quite sure I understand your reservation about the patch to be
honest. Andrew still hasn't merged this one although 1/2 is in.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
