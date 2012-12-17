From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Date: Mon, 17 Dec 2012 20:55:10 +0100
Message-ID: <20121217195510.GA16375@dhcp22.suse.cz>
References: <20121205141722.GA9714@dhcp22.suse.cz>
 <20121206012924.FE077FD7@pobox.sk>
 <20121206095423.GB10931@dhcp22.suse.cz>
 <20121210022038.E6570D37@pobox.sk>
 <20121210094318.GA6777@dhcp22.suse.cz>
 <20121210111817.F697F53E@pobox.sk>
 <20121210155205.GB6777@dhcp22.suse.cz>
 <20121217023430.5A390FD7@pobox.sk>
 <20121217163203.GD25432@dhcp22.suse.cz>
 <20121217192301.829A7020@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dM1v33DKUG/40/PGm1k9sSd6COs87ISoDF6r2JBNq3o=;
        b=dbe9V5owOzox+Rdd0fL4glrPB9i7NqIn1zJl+nxyt7yBXT/fFTJjrcZcJMbvRuLC5/
         8lAfmE24AnFqD0/Rnw7M0vZjgmwj70xsQr/Uw1/herLZ064nu+RzGyBLRXWdTceFbJBw
         w/h+NhnOpLND5eJgz0+CNJzbMEAufOyABn+cfOmBNGDmEs/NOaYK5K7dct763Q7uvg7l
         BEW4vqBpqTo/IrRIviSDEOrpCVuhFb0reO46iR1+YFwsHg8TBoAW5m3vrs4hzigiVBLc
         QnflWIMcVFwRWTlxK9w/QuAvYJInNUTLFyOkfzrFXXB1ryjHogT8X3iDmSFhNSqOwQw7
         NvBw==
Content-Disposition: inline
In-Reply-To: <20121217192301.829A7020-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Mon 17-12-12 19:23:01, azurIt wrote:
> >[Ohh, I am really an idiot. I screwed the first patch]
> >-       bool oom = true;
> >+       bool oom = !(gfp_mask | GFP_MEMCG_NO_OOM);
> >
> >Which obviously doesn't work. It should read !(gfp_mask &GFP_MEMCG_NO_OOM).
> >  No idea how I could have missed that. I am really sorry about that.
> 
> 
> :D no problem :) so, now it should really work as expected and
> completely fix my original problem?

It should mitigate the problem. The real fix shouldn't be that specific
(as per discussion in other thread). The chance this will get upstream
is not big and that means that it will not get to the stable tree
either.

> is it safe to apply it on 3.2.35?

I didn't check what are the differences but I do not think there is
anything to conflict with it.

> Thank you very much!

HTH

-- 
Michal Hocko
SUSE Labs
