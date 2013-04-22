From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Mon, 22 Apr 2013 09:01:12 -0700
Message-ID: <20130422160112.GE12543@htj.dyndns.org>
References: <20130420002620.GA17179@mtj.dyndns.org>
 <20130420031611.GA4695@dhcp22.suse.cz>
 <20130421022321.GE19097@mtj.dyndns.org>
 <CANN689GuN_5QdgPBjr7h6paVmPeCvLHYfLWNLsJMWib9V9G_Fw@mail.gmail.com>
 <20130422042445.GA25089@mtj.dyndns.org>
 <20130422153730.GG18286@dhcp22.suse.cz>
 <20130422154620.GB12543@htj.dyndns.org>
 <20130422155454.GH18286@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=KIVDXywgXHUaCdsimfJrdNOUU7oFB9lG56LbaGa9QPA=;
        b=k36jE01XFAJXyzoTiIAtjrKYC0IcRRPs/WR4RM/KsucHIXlBYfrPIBsRcnJQwfGaXl
         18WYY+1tC/oxkuwzjODLo4kOZvmxV07K2OlhMDhopjLbuELjYSN2pib7VTs2PybS76Sw
         mB/62FGL+alAr8BFjp0MUiZ5ruJU8JGh11LAm+X5d65M6qwNcVILT9Dt/kTEmDEoypnL
         SHpp/2WZdDEOBEz23azMGd3CWF3Eys4TsfcKAAGC89Qk7F3+4RzxB1PW11FADASVZKIu
         NybJY+P/3atT1hGTtl8M0ShBmVKcedFLTZ3qnb8cO82kt40XJZ/MVLDEHIle+tLJr5XW
         sPcg==
Content-Disposition: inline
In-Reply-To: <20130422155454.GH18286-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Hey,

On Mon, Apr 22, 2013 at 05:54:54PM +0200, Michal Hocko wrote:
> > Oh, if so, I'm happy.  Sorry about being brash on the thread; however,
> > please talk with google memcg people.  They have very different
> > interpretation of what "softlimit" is and are using it according to
> > that interpretation.  If it *is* an actual soft limit, there is no
> > inherent isolation coming from it and that should be clear to
> > everyone.
> 
> We have discussed that for a long time. I will not speak for Greg & Ying
> but from my POV we have agreed that the current implementation will work
> for them with some (minor) changes in their layout.
> As I have said already with a careful configuration (e.i. setting the
> soft limit only where it matters - where it protects an important
> memory which is usually in the leaf nodes) you can actually achieve
> _high_ probability for not being reclaimed after the rework which was not
> possible before because of the implementation which was ugly and
> smelled.

I don't know.  I'm not sure this is a good idea.  It's still
encouraging abuse of the knob even if that's not the intention and
once the usage sticks you end up with something you can't revert
afterwards.  I think it'd be better to make it *very* clear that
"softlimit" can't be used for isolation in any reliable way.

Thanks.

-- 
tejun
