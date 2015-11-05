From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cgroup:test-merge-for-4.4 1/1] mm/vmscan.c:178:6: error:
 implicit declaration of function 'cgroup_on_dfl'
Date: Thu, 5 Nov 2015 09:06:23 +0100
Message-ID: <20151105080622.GA12990@dhcp22.suse.cz>
References: <201511040637.nB1K9bmQ%fengguang.wu@intel.com>
 <20151104085630.GD29607@dhcp22.suse.cz>
 <20151104172238.GJ5749@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151104172238.GJ5749-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed 04-11-15 12:22:38, Tejun Heo wrote:
> On Wed, Nov 04, 2015 at 09:56:30AM +0100, Michal Hocko wrote:
> > Ohh, this seems because CONFIG_CGROUP_WRITEBACK depends on BLK_CGROUP
> > and MEMCG and none of it depends on CGROUP. Dang. The patch is below
> > I haven't checked other controllers yet.
> 
> They are inside if CGROUPS block.

I managed to completely miss that. Sorry about the noise

-- 
Michal Hocko
SUSE Labs
