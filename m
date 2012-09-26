From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Wed, 26 Sep 2012 13:16:29 -0700
Message-ID: <20120926201629.GB20342@google.com>
References: <20120926163648.GO16296@google.com>
 <50633D24.6020002@parallels.com>
 <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com>
 <50634105.8060302@parallels.com>
 <20120926180124.GA12544@google.com>
 <50634FC9.4090609@parallels.com>
 <20120926193417.GJ12544@google.com>
 <50635B9D.8020205@parallels.com>
 <20120926195648.GA20342@google.com>
 <50635F46.7000700@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=EmfBnrekeXsQTapFNmaKEnfwFalpnQ3FzK+/R6MDFDI=;
        b=VaLffgcNyWETN8iivl9+QgAG4VfCmyt5ZafmfnOhyrqpJ7RdcblPsLTXG5bvvfueV9
         MK2rdPWgiRklPPtaw0Wr3P+tihTwfakDH/VXZrn4W3aOdgDZKoroOXXg7/cLnDAvo9tQ
         wVmV3EA2RWDRR9f9FoDKP4yRu1P14Q8wPA/tUGO5X3pl/BLPjCBmsjqN5nooDQ/5mlhC
         G4/HSe8EJnBYlS/Hc5PC8k9k27sk8vxIYwwH2076Wt9cNsJsf7SSXNXcKhP3adtd0tmJ
         KoBTMckqP4hdOK/FkKMkl/nFnPqYkKUljIN/GeOT08FE7SJHb3yHm+Ut39+PIxqafbBc
         9nnQ==
Content-Disposition: inline
In-Reply-To: <50635F46.7000700-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Thu, Sep 27, 2012 at 12:02:14AM +0400, Glauber Costa wrote:
> But think in terms of functionality: This thing here is a lot more
> similar to swap than use_hierarchy. Would you argue that memsw should be
> per-root ?

I'm fairly sure you can make about the same argument about
use_hierarchy.  There is a choice to make here and one is simpler than
the other.  I want the additional complexity justified by actual use
cases which isn't too much to ask for especially when the complexity
is something visible to userland.

So let's please stop arguing semantics.  If this is definitely
necessary for some use cases, sure let's have it.  If not, let's
consider it later.  I'll stop responding on "inherent differences."  I
don't think we'll get anywhere with that.

Michal, Johannes, Kamezawa, what are your thoughts?

Thanks.

-- 
tejun
