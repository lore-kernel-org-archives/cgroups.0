From: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 14:36:29 +0200
Message-ID: <20150514123628.GA7300@rei>
References: <55536DC9.90200@kyup.com>
 <20150514092145.GA6799@dhcp22.suse.cz>
 <20150514092301.GB6799@dhcp22.suse.cz>
 <20150514103542.GB5066@rei.suse.de>
 <20150514113101.GD6799@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150514113101.GD6799-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>

Hi!
> > That would fail on older kernels without the patch, woudln't it?
> 
> Yes it will. I thought those would be using some stable release (I do
> not have much idea about the release process of ltp...). You are
> definitely right that a backward compatible way is better. I will cook
> up a patch later today.

The thing is that we do not have manpower to backport fixes to stable
releases. So the latest stable release is always recomended for testing
and because of that we have to fix testcases in backward compatible way.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
