From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/10] memcg kmem limitation - slab.
Date: Tue, 31 Jul 2012 18:30:31 +0200
Message-ID: <20120731163027.GE17078@somewhere.redhat.com>
References: <1343227101-14217-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=nmdNQNGr0nfV8Do7/qRmH1rU3mccD737lGBW3enPVqc=;
        b=cTkG0dtjifgXKw+krniYwr9QrRBZRMxuIDUwxcMpCwOa1/iO9ANTmJnbOPD6eN6dHh
         FbSZEz0G0n96M/WcoFM2kNtnAx6GNM5ouofG52KyZmpOgbV2OCmuhckEAkyecKSBM/EB
         IDfukbHE9HjkzQ0raYPYELa3D3cen0htoWNtDPPiAOlW283MD+I1/H6WVvr3UieMs6vs
         eF1mrTfM5z77PUFTmI8n2PWoOWj/LIyD8yM7ozTmtvEa0wyjFsm66b2szBGqwW770voQ
         fhVuWYNLVj/8rbXXYqcyzoo2dX3YZ67DABCtrGsThuIbWoZ/tMbKS9U7ZbeYNs6Iinzq
         Y9Kg==
Content-Disposition: inline
In-Reply-To: <1343227101-14217-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 25, 2012 at 06:38:11PM +0400, Glauber Costa wrote:
> Hi,
> 
> This is the slab part of the kmem limitation mechanism in its last form.  I
> would like to have comments on it to see if we can agree in its form. I
> consider it mature, since it doesn't change much in essence over the last
> forms. However, I would still prefer to defer merging it and merge the
> stack-only patchset first (even if inside the same merge window). That patchset
> contains most of the infrastructure needed here, and merging them separately
> would not only reduce the complexity for reviewers, but allow us a chance to
> have independent testing on them both. I would also likely benefit from some
> extra testing, to make sure the recent changes didn't introduce anything bad.

What is the status of the stack-only limitation patchset BTW? Does anybody oppose
to its merging?

Thanks.
