From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: remove BUG_ON in uncharge_list
Date: Wed, 8 Jun 2016 17:06:54 +0200
Message-ID: <20160608150653.GP22570@dhcp22.suse.cz>
References: <1465369248-13865-1-git-send-email-roy.qing.li@gmail.com>
 <20160608072554.GD22570@dhcp22.suse.cz>
 <20160608145833.GA6727@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160608145833.GA6727-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org

On Wed 08-06-16 10:58:33, Johannes Weiner wrote:
> On Wed, Jun 08, 2016 at 09:25:54AM +0200, Michal Hocko wrote:
> > On Wed 08-06-16 15:00:48, roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > > From: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > 
> > > when call uncharge_list, if a page is transparent huge, and not need to
> > > BUG_ON about non-transparent huge, since nobody should be be seeing the
> > > page at this stage and this page cannot be raced with a THP split up
> > 
> > Johannes do you remember why you have kept this bug on even after
> > 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API")?
> 
> No, I just copied it over without thinking too much about it. That
> patch was pretty drastic, so why not keep the sanity checks in case
> one of the many assumptions it made were flawed...

Yeah the VM_BUG_ON made sense before because the charge could have gone
away while the page could be visible, thus split.
 
> But it's probably okay to drop it at this point.

Thanks for double checking. I was just not sure I didn't miss anything.
I am always a bit nervous when bug_ons a removed.

> > > Signed-off-by: Li RongQing <roy.qing.li-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

With the reference to the rewrite which made it pointless
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
-- 
Michal Hocko
SUSE Labs
