From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: memcg: softlimit on internal nodes
Date: Fri, 19 Apr 2013 17:42:21 -0700
Message-ID: <20130420004221.GB17179@mtj.dyndns.org>
References: <20130420002620.GA17179@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=ttqU7NJkgtrM/0tEOIUFmwCJNv0KNaieLr9no4wg/y8=;
        b=jjzkD4UPJsxogFSqxv2Psqz3KA7eBGYsfwejR4fabUnjLjko84MeKDOVH+ZSxTbfx7
         cYwgPmQNzIHlkFwXCRavB64B4Sm6BxRPwzc3z9+BoeiPDDI77OQLgl5Qbax+MViLgr7a
         TIfiT19zuDMTHHYJMepLajg/YhIRkiPTmRKIlrdTssxXaLb9aL3k59z/oxhbKC/v9DzW
         0Fxyrw9/Zl9IfDPt2DaRfi1aRi8wKQmNeMHb+/V+7U4ieZBnUKT8KfPaHalP5TruJKP3
         D4We0el1Y4lC/+XNPaT/zlph6XJagtxQZIJErt9Ll/LxExThkJ1YHGImYrMlQKJ0/lQF
         CIUQ==
Content-Disposition: inline
In-Reply-To: <20130420002620.GA17179-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Apr 19, 2013 at 05:26:20PM -0700, Tejun Heo wrote:
> If such actual soft limit is desired (I don't know, it just seems like
> a very fundamental / logical feature to me), please don't try to
> somehow overload "softlimit".  They are two fundamentally different
> knobs, both make sense in their own ways, and when you stop confusing
> the two, there's nothing ambiguous about what what each knob means in
> hierarchical situations.  This goes the same for the "untrusted" flag
> Ying told me, which seems like another confused way to overload two
> meanings onto "softlimit".  Don't overload!

As for how actually to clean up this yet another mess in memcg, I
don't know.  Maybe introduce completely new knobs - say,
oom_threshold, reclaim_threshold, and reclaim_trigger - and alias
hardlimit to oom_threshold and softlimit to recalim_trigger?  BTW,
"softlimit" should default to 0.  Nothing else makes any sense.

Maybe you can gate it with "sane_behavior" flag or something.  I don't
know.  It's your mess to clean up.  :P

Thanks.

-- 
tejun
