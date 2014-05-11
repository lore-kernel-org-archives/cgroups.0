From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH 01/14] cgroup: remove css_parent()
Date: Sat, 10 May 2014 21:47:50 -0400 (EDT)
Message-ID: <20140510.214750.1194823540790487670.davem@davemloft.net>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
	<1399671091-23867-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399671091-23867-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: Text/Plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org

From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Fri,  9 May 2014 17:31:18 -0400

> cgroup in general is moving towards using cgroup_subsys_state as the
> fundamental structural component and css_parent() was introduced to
> convert from using cgroup->parent to css->parent.  It was quite some
> time ago and we're moving forward with making css more prominent.
> 
> This patch drops the trivial wrapper css_parent() and let the users
> dereference css->parent.  While at it, explicitly mark fields of css
> which are public and immutable.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

For networking bits:

Acked-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
