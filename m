From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] memcg: relocate charge moving from ->attach to
 ->post_attach
Date: Mon, 25 Apr 2016 15:42:49 -0400
Message-ID: <20160425194249.GG7822@mtj.duckdns.org>
References: <20160413094216.GC5774@pathway.suse.cz>
 <20160413183309.GG3676@htj.duckdns.org>
 <20160413192313.GA30260@dhcp22.suse.cz>
 <20160414175055.GA6794@cmpxchg.org>
 <20160415191719.GK12583@htj.duckdns.org>
 <20160417120747.GC21757@dhcp22.suse.cz>
 <20160421230648.GI4775@htj.duckdns.org>
 <20160421230902.GJ4775@htj.duckdns.org>
 <20160425082542.GB23933@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E/AOMqWlHIxGAuFNfxxYdBUXblgrLuccl1Oe2oag0zk=;
        b=ycpNHZu1/ifcxszn8LiEL6IDXxZDoxua7omCh9D0GS0NeE4Dh3uXUfS8ls5ikpirZP
         j+75uwcYmMX92yPZz1p49VCmLXgQRVdJz3AXPMwAAZjpD2w+uaNeOJ1XY4+aJ80kcllU
         701RoePNMiriaLnhExOtVHxoSaEBPW4c5dPISqnATU2Nv5virIJ0vVSK9AuspaInQHm7
         z9Ao6RWN0jhyxqhdB6OCB9FAC9K3Ia33IHt09Ivzm5UBKC3OdMeIzQf8p4k8V60y9h7j
         gRr14ItYRoUXTP/whv9WVRBOcpo5QCQvSuBQ9aSkP+Hll1YqFhHXfqGam2+PsZTNVfYy
         vtmQ==
Content-Disposition: inline
In-Reply-To: <20160425082542.GB23933-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Michal.

On Mon, Apr 25, 2016 at 10:25:42AM +0200, Michal Hocko wrote:
> > * move_charge_struct->mm is added and ->can_attach is now responsible
> >   for pinning and recording the target mm.  mem_cgroup_clear_mc() is
> >   updated accordingly.  This also simplifies mem_cgroup_move_task().
> > 
> > * mem_cgroup_move_task() is now called from ->post_attach instead of
> >   ->attach.
> 
> This looks much better than the previous quick&dirty workaround. Thanks
> for taking an extra step!
> 
> Sorry for being so pushy but shouldn't we at least document those
> callbacks which depend on cgroup_threadgroup_rwsem to never ever block
> on WQ directly or indirectly. Maybe even enforce they have to be
> non-blocking. This would be out of scope of this particular patch of
> course but it would fit nicely into the series.

Yeah, I'll look into whether I can annotate this dependency with
lockdep.  If that isn't doable, I'll document the requirements.
cgroup methods have changed a lot and need to be redocumented anyway.

Thanks.

-- 
tejun
