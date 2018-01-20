From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch -mm 3/4] mm, memcg: replace memory.oom_group with policy
 tunable
Date: Sat, 20 Jan 2018 04:32:51 -0800
Message-ID: <20180120123251.GB1096857@devbig577.frc2.facebook.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801161814130.28198@chino.kir.corp.google.com>
 <20180117154155.GU3460072@devbig577.frc2.facebook.com>
 <alpine.DEB.2.10.1801171348190.86895@chino.kir.corp.google.com>
 <alpine.DEB.2.10.1801191251080.177541@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QKAO+sySSh47OvkXRYpc1pYjzk3Ze42qmkL6LiGc4j8=;
        b=T/K2glxAfwcqkL1EMXP7P+F38kHk2/nCaR37GiLeH5KvJTakaRQ3RfqYCOdLCcpSb7
         JShNoppAEaL9InunpKnVzvTVDBvNai7NKjOG3qpgASSJLJSxRlfGjArauWkYCwyk3/qp
         Uq7EKtOWVRH0vl9n/TTXzkpkBJFMFpiHHS1Vhs+kqdaaPlPviUdfdkWKFQZf9I3DWx/E
         UFyRKy0denMygLe2OdnsCt0xFQtwXVj6oA7q9GnDRvNL5+sQWzG918UBa2VDjn480wh6
         nd7JSa3nVGA1WTfCLRsdfUIuyoqecin9Hhd7pp2/9YVzryTAGS+V7Pv8GGUat9SPlRU9
         gGeA==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1801191251080.177541-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello, David.

On Fri, Jan 19, 2018 at 12:53:41PM -0800, David Rientjes wrote:
> Hearing no response, I'll implement this as a separate tunable in a v2 
> series assuming there are no better ideas proposed before next week.  One 
> of the nice things about a separate tunable is that an admin can control 
> the overall policy and they can delegate the mechanism (killall vs one 
> process) to a user subtree.  I agree with your earlier point that killall 
> vs one process is a property of the workload and is better defined 
> separately.

If I understood your arguments correctly, the reasons that you thought
your selectdion policy changes must go together with Roman's victim
action were two-fold.

1. You didn't want a separate knob for group oom behavior and wanted
   it to be combined with selection policy.  I'm glad that you now
   recognize that this would be the wrong design choice.

2. The current selection policy may be exploited by delegatee and
   strictly hierarchical seleciton should be available.  We can debate
   the pros and cons of different heuristics; however, to me, the
   followings are clear.

   * Strictly hierarchical approach can't replace the current policy.
     It doesn't work well for a lot of use cases.

   * OOM victim selection policy has always been subject to changes
     and improvements.

I don't see any blocker here.  The issue you're raising can and should
be handled separately.

In terms of interface, what makes an interface bad is when the
purposes aren't crystalized enough and different interface pieces fail
to clearnly encapsulate what's actually necessary.

Here, whether a workload can survive being killed piece-wise or not is
an inherent property of the workload and a pretty binary one at that.
I'm not necessarily against changing it to take string inputs but
don't see rationales for doing so yet.

Thanks.

-- 
tejun
