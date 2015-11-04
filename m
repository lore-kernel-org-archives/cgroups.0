From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cgroup:test-merge-for-4.4 1/1] mm/vmscan.c:178:6: error:
 implicit declaration of function 'cgroup_on_dfl'
Date: Wed, 4 Nov 2015 12:22:38 -0500
Message-ID: <20151104172238.GJ5749@mtj.duckdns.org>
References: <201511040637.nB1K9bmQ%fengguang.wu@intel.com>
 <20151104085630.GD29607@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=chYHG4BT/vAFtj/IsgYADeC2rnfLPuUiVK1u1UryuvI=;
        b=wau8EUMRtzUbMJlufYiPVpZGfZzmb8cNf57t57wNQdb+yPdK20y86kgb/IBlUwRSOI
         hxKGSByqd9N5ktkSbBiUZk44GVqR7TGHQGAYgFnzpc9Oqp3zYJa94wQwZ3cvlxfPccb1
         56qRLeGFcrgkR+A3V5m4hTjHze9s+j7Y+YgPJW5xsgfhe+GWVYnSGVDizY8ZLVJKzhi3
         s8eqSDyXd38L+27VoEMvq1nStqdcC2QFQS8IczTGj6Zxd6BsU9LgM8ZEzPxBbyJhUiVB
         xBPdoghQzLpzjn3Ne5oDGfFbk3Y9QoouwmQteODRAuQJZ0drIf1TosKPqcBXvyJviphq
         aDPg==
Content-Disposition: inline
In-Reply-To: <20151104085630.GD29607-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed, Nov 04, 2015 at 09:56:30AM +0100, Michal Hocko wrote:
> Ohh, this seems because CONFIG_CGROUP_WRITEBACK depends on BLK_CGROUP
> and MEMCG and none of it depends on CGROUP. Dang. The patch is below
> I haven't checked other controllers yet.

They are inside if CGROUPS block.  It's just me not fixing up
cgroup_on_dfl() -> cgroup_subsys_on_dfl() on the test merge branch.
Please ignore.

Thanks.

-- 
tejun
