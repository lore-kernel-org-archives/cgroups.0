From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: first step towards hierarchical controller
Date: Tue, 26 Jun 2012 15:14:52 -0700
Message-ID: <20120626221452.GA15811@google.com>
References: <1340725634-9017-1-git-send-email-glommer@parallels.com>
 <1340725634-9017-3-git-send-email-glommer@parallels.com>
 <20120626180451.GP3869@google.com>
 <20120626220809.GA4653@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=rCyhkuSGAjpsQ7g50mv9r9zgkQKYj2j9pNUYDS7KOXA=;
        b=fS6rZksvbiIjTK2l4JXK0LwczuzVOiFw8xlFLkZWGIDKGZThA3LyTB7ePmcAf0Wwvu
         2nKsUTE2Flhp4K7HHCOEdikFEqXNRANuSND7xKiaTp1ircvoLREyN0ZDIGLIeOw25JwR
         1fezFFGqa0nNOv+2ZtS8IdBENtdKJIaXeEggLEqu0RoQaG95AWw+nrBPY791NfBxm84I
         2rldh4g8nCXY05l47EQlb6W2jEjyAoG4AcSv32wOIK/SdLiGtBYn+JCtLA1nWrXLBG0E
         F/RnoGcS/BvjrJPENGaDwfXyJJthTEYt+pPQb5ldnHlM0HPJn6y4DPMCVbvvm3iLHbQP
         J1bQ==
Content-Disposition: inline
In-Reply-To: <20120626220809.GA4653-VqjxzfR4DlwKmadIfiO5sKVXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello, Michal.

On Wed, Jun 27, 2012 at 12:08:09AM +0200, Michal Hocko wrote:
> According to my experience, people usually create deeper subtrees
> just because they want to have memcg hierarchy together with other
> controller(s) and the other controller requires a different topology
> but then they do not care about memory.* attributes in parents.
> Those cases are not affected by this change because parents are
> unlimited by default.
> Deeper subtrees without hierarchy and independent limits are usually
> mis-configurations, and we would like to hear about those to help to fix
> them, or they are unfixable usecases which we want to know about as well
> (because then we have a blocker for the unified cgroup hierarchy, don't
> we).

Yeah, this is something I'm seriously considering doing from cgroup
core.  ie. generating a warning message if the user nests cgroups w/
controllers which don't support full hierarchy.

> >   Note that the default should still be flat hierarchy.
> > 
> > 2. Mark flat hierarchy deprecated and produce a warning message if
> >    memcg is mounted w/o hierarchy option for a year or two.
> 
> I would agree with you on this with many kernel configurables but
> this one doesn't fall in. There is a trivial fallback (set root to
> use_hierarchy=0) so the mount option seems like an overkill - yet
> another API to keep for some time...

Just disallow clearing .use_hierarchy if it was mounted with the
option?  We can later either make the file RO 1 for compatibility's
sake or remove it.

> So in short, I do think we should go the sanity path and end up
> with hierarchical trees and sooner we start the better.

I do agree with you in principle, but I still don't think we can
switch the default behavior underneath the users.

Thanks.

-- 
tejun
