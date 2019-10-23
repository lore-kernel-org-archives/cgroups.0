From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/8] mm: vmscan: naming fixes: global_reclaim() and
 sane_reclaim()
Date: Wed, 23 Oct 2019 12:02:03 -0400
Message-ID: <20191023160203.GC366316@cmpxchg.org>
References: <20191022144803.302233-1-hannes@cmpxchg.org>
 <20191022144803.302233-5-hannes@cmpxchg.org>
 <20191022194048.GA22721@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HuBYZtMC/2ECcAW9w0F4WSDn6CrA0ouxLYzbuT3eoqw=;
        b=Oujg9zCLBa9tQBIQTqDCy+i0l78T+gT/9d9EP49uk5MYfABKpewjiVNaP2E51x00IF
         Zwa7biWZoVIokr9BcQV12H0SY+DHOyTJFqUPIkCdvErh0OOUxCuNFwHu6JmrefXpXyQO
         r+G9PTaKYYtfsDyyXi98xwGM1BTpJbl82AiO0le0fp8E7JK4GAUEFEV3BbmG1Ef+VN34
         mf+wyT1VlkemxsFj6d+wViItcmVvBSWBKf0SeWoDPLuKEKTV3iGGmHmUORBnh3nFDPs9
         eeKXtpD+iKjBBUFZM8dxAFOjGZu5V0COBfwX/KRqHA2+aNYJf1QM0G27Pk5p6blzlXmR
         1q2A==
Content-Disposition: inline
In-Reply-To: <20191022194048.GA22721@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Oct 22, 2019 at 07:40:52PM +0000, Roman Gushchin wrote:
> On Tue, Oct 22, 2019 at 10:47:59AM -0400, Johannes Weiner wrote:
> > Seven years after introducing the global_reclaim() function, I still
> > have to double take when reading a callsite. I don't know how others
> > do it, this is a terrible name.
> > 
> > Invert the meaning and rename it to cgroup_reclaim().
> > 
> > [ After all, "global reclaim" is just regular reclaim invoked from the
> >   page allocator. It's reclaim on behalf of a cgroup limit that is a
> >   special case of reclaim, and should be explicit - not the reverse. ]
> > 
> > sane_reclaim() isn't very descriptive either: it tests whether we can
> > use the regular writeback throttling - available during regular page
> > reclaim or cgroup2 limit reclaim - or need to use the broken
> > wait_on_page_writeback() method. Use "writeback_throttling_sane()".
> > 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/vmscan.c | 38 ++++++++++++++++++--------------------
> >  1 file changed, 18 insertions(+), 20 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 622b77488144..302dad112f75 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -239,13 +239,13 @@ static void unregister_memcg_shrinker(struct shrinker *shrinker)
> >  	up_write(&shrinker_rwsem);
> >  }
> >  
> > -static bool global_reclaim(struct scan_control *sc)
> > +static bool cgroup_reclaim(struct scan_control *sc)
> >  {
> > -	return !sc->target_mem_cgroup;
> > +	return sc->target_mem_cgroup;
> >  }
> 
> Isn't targeted_reclaim() better?
> 
> cgroup_reclaim() is also ok to me, but it sounds a bit like we reclaim
> from this specific cgroup. Also targeted/global is IMO a better opposition
> than cgroup/global (the latter reminds me days when there were global
> and cgroup LRUs).

I think "targeted" is quite a bit less descriptive when you come at
the page replacement algorithm without cgroups in mind.

> The rest of the patch looks good!
> 
> Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks!
