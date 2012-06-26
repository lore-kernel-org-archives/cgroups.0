From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] fix bad behavior in use_hierarchy file
Date: Tue, 26 Jun 2012 10:55:13 -0700
Message-ID: <20120626175513.GO3869@google.com>
References: <1340616061-1955-1-git-send-email-glommer@parallels.com>
 <20120625204908.GL3869@google.com>
 <20120626075653.GD6713@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/RBpGC7Hji/r/XTtx2NbpS8X8V1i9UMiU1AD3AHNJzA=;
        b=SqDP1uvkw6nhsa/9EDbJbCF7PB48VZnf+xwazmW+HbSMw1KPwFXaIF9VWVxSTmyetL
         aljBLzCLY8jtRq7ogj04QyxoyHjlkD7vWuEH9TIj2aHQfdN5qz41CR1ll5Vo+qn6udGZ
         9Q3xdsKMPLHo8eLl6YJuTjjktv20u9rc40nzGG72VPTuqGe7OY+QgCcOYjqf1T4l7ouj
         K4xpDbMtAHjXBNmOOlKlm88IOdcTWQb8KHWtMVutuNSf0HKBmd3+n5csq8NdXH6xUe7d
         JmzNT+xUdGFjLEcdTGwABU1A+bsF06cfhJ4RbmqcPsdc06QlmzJ+QcBDh79uMtqoJA1Y
         X07Q==
Content-Disposition: inline
In-Reply-To: <20120626075653.GD6713-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

Hello,

On Tue, Jun 26, 2012 at 09:56:53AM +0200, Michal Hocko wrote:
> [Adding Ying to CC - they are using hierarchies AFAIU in their workloads]

Ooh, I'm they. :) Asking around.... okay, so google does use
.use_hierarchy but it's a tree-wide thing and would be perfectly happy
with a global switch.

> On Mon 25-06-12 13:49:08, Tejun Heo wrote:
> [...]
> > A bit of delta but is there any chance we can either deprecate
> > .use_hierarhcy or at least make it global toggle instead of subtree
> > thing?  
> 
> So what you are proposing is to have all subtrees of the root either
> hierarchical or not, right?

Yeap.  Just make it a global switch.  Probably determined on mount
time.

> > This seems needlessly complicated. :(
> 
> Toggle wouldn't help much I am afraid. We would still have to
> distinguish (non)hierarchical cases. And I am not sure we can make
> everything hierarchical easily. 

I'm kinda confused by this paragraph.  What do you mean by "wouldn't
help much"?  Do you mean in terms of complexity?

> Most users (from my experience) ignored use_hierarchy for some reasons
> and the end results might be really unexpected for them if they used
> deeper subtrees (which might be needed due to combination with other
> controller(s)).

Oh yeah, we can't change the default behavior like that.  The
transition should be a lot more gradual.  Even if making
.use_hierarchy doesn't help much in terms of reducing complexity right
now, it would at least allow us to weed out and prevent wacky woo-hoo
mom-look-at-what-I-can-do configurations which will be a lot more
difficult to deal with for both us and such users (if we end up
forcing hierarchy).

Thanks.

-- 
tejun
