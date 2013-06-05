From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11 1/3] cgroup: mark "tasks" cgroup file as
 insane
Date: Wed, 5 Jun 2013 11:52:50 -0700
Message-ID: <20130605185250.GE10693@mtj.dyndns.org>
References: <20130604021302.GH29989@mtj.dyndns.org>
 <20130604111556.GA4963@redhat.com>
 <20130604201947.GE14916@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Fyxp6XESTKmUkHI0+4Vc3V7ANXevmYzqsFsJ3pQRNog=;
        b=pmEqchbSmjx3Z1AL5jBKvXaXHKfhBXBolOQa1r5XsxmbyDJFUe3plMXSLqy3r7NwB5
         NRBauBfvOqfZPLJNOCs9CZPDp1WNMrMevs2/BbVkFB8gmsnIAiW/4oZwsPp0n2aBR812
         Dh8vbD1zYVjyb9P4A3Davm25h/qY6gbYVXiRYn3GTC4JqF0LgrRMtr0RuhBwBupGWNSi
         xj1bEpju8kI0YtufLMwhfw2ZANM9U8t7SGDKcknpBjYrXPYTwiaH/jjHZOt516WsOmTQ
         1kSoXMlD9Ty1hOWJNaoMwqqrQgSKfVvCRIehqxpEl0a8E3cdp+2l6wx2gAw45+PFDIas
         K7Iw==
Content-Disposition: inline
In-Reply-To: <20130604201947.GE14916-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, again.

On Tue, Jun 04, 2013 at 01:19:47PM -0700, Tejun Heo wrote:
> It was never suited to that level of flexibility and it will never be
> and things like that will be clearly forbidden rather than being left
> in the current "not fully supported but kinda works" state.

I'm gonna commit these three patches.  I hope that the existing
in-process usages can move on to other mechanisms but recognize that
it's an actual use case and we may eventually decide to allow further
nesting cgroups at the leaf and allow separating threads of the same
process with only perf-task controllers.  I *strongly* hope it doesn't
come to that tho.

As __DEVEL__sane_behvior is currently the playground for testing new
stuff, I'm gonna commit these for now.  If it doesn't fan out, we can
add it back, but preferably under a new name "cgroup.tasks" and with
whole lot more restrictions.

Thanks.

-- 
tejun
