From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/2] cgroup: get rid of populate for memcg
Date: Tue, 10 Apr 2012 10:05:48 -0700
Message-ID: <20120410170548.GA21311@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1334010994-23301-1-git-send-email-glommer@parallels.com>
 <1334010994-23301-3-git-send-email-glommer@parallels.com>
 <4F839E73.1000204@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6adI3YMm6XQr/WwoebC+zqjZ1y/J74/WhZ+E8ZQu+xA=;
        b=arMizBTHpYQs7BZ2aGUQdg/4Se2bkz9BE8h6hm+OU7OZN0HnIgLBcdrVpNJc4q9CkL
         /qCqX4Q6FYMZTYuclPwO+h8jnkKxNM0QGRUlptYTCQ7/B30C9VWQj5OnvPmwWyzFatgp
         mjl4DwHbs1f4OXFwXA3Og0UGvcdneFPoxitIbD3YVZT1LZ8I98Hzvno+9lt0w5tTo82k
         l3hdZp9Z2kq1y4d3i8KUxWL9ubpfMaswpvQkHomPisrAuNus1myJeMBWNtvxzUq6Rfng
         OtzR34xD+N7XavlbibmMrud53h0Gnb1cBmbZB7vRfMpb10UELAlNWhoky1O76AXkysWG
         7GLg==
Content-Disposition: inline
In-Reply-To: <4F839E73.1000204-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

On Tue, Apr 10, 2012 at 11:44:03AM +0900, KAMEZAWA Hiroyuki wrote:
> (2012/04/10 7:36), Glauber Costa wrote:
> 
> > The last man standing justifying the need for populate() is the
> > sock memcg initialization functions. Now that we are able to pass
> > a struct mem_cgroup instead of a struct cgroup to the socket
> > initialization, there is nothing that stops us from initializing
> > everything in create().
> > 
> > Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> > CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > CC: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Applied to cgroup/for-3.5.  Thanks.

-- 
tejun
