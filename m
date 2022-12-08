From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 15/18] cgroup/misc: Add per resource callbacks for css
 events
Date: Thu, 8 Dec 2022 15:15:37 +0000
Message-ID: <Y5H/mY17TsQwSx9g@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-16-kristen@linux.intel.com>
 <Y5H6ZLz7HXSaTF30@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670512542;
        bh=DmWyuGFqzQqP+2VEv1enz/dMYLRgm6/Oc/LH1ZFoggQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VCYZvUnvtyjVfPcc+ChgcW1bd1sv/15NbCHzwvHQOqXxuTWkY89fFu2u9LM87CIJ3
         HEb6QI7BOB8HeMztr3vhYFSo81m6rfJ9myzn0R54+6wOXybHgFUnpQsQashrexNKz7
         JhVoc+aWkiiNhDhP5AhABwYZIrbrzOCtWtL1+ZrDqEBrmww2KsuJvlRDpEyQ9QfBZE
         /6IrsrvXsd5zH4P3Z2bCLO1RQNFJTgAEVnM9NNc/Q465UAkIZKHJrdBCX+gBhWTQjJ
         xOH5JtucJDiGjMygTWjSaRAzY3bP0Q7n0OAKwcvw7gwmmtgjg3Qe2hmvQFYp9j0KBB
         v1JHnMMA/2rig==
Content-Disposition: inline
In-Reply-To: <Y5H6ZLz7HXSaTF30-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Thu, Dec 08, 2022 at 02:53:24PM +0000, Jarkko Sakkinen wrote:
> On Fri, Dec 02, 2022 at 10:36:51AM -0800, Kristen Carlson Accardi wrote:
> > Consumers of the misc cgroup controller might need to perform separate actions
> > in the event of a cgroup alloc, free or release call. In addition,
> > writes to the max value may also need separate action. Add the ability
> > to allow downstream users to setup callbacks for these operations, and
> > call the per resource type callback when appropriate.
> > 
> > This code will be utilized by the SGX driver in a future patch.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> I don't know what css is.

Now I know but it should be described in the commit message, i.e.
what the css is abbrevation of, and what does it mean in practice.

BR, Jarkko
