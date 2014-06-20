From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH block/for-linus] blkcg: fix use-after-free in __blkg_release_rcu()
 by making blkcg_gq refcnt an atomic_t
Date: Fri, 20 Jun 2014 12:50:53 -0600
Message-ID: <53A4828D.9000200@kernel.dk>
References: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com> <20140609174708.GA31499@redhat.com> <20140609182728.GB31499@redhat.com> <20140610143906.0d2f35d0@jlaw-desktop.mno.stratus.com> <20140611163229.GA12974@redhat.com> <20140619202640.GA9814@mtj.dyndns.org> <20140619214257.GE9814@mtj.dyndns.org> <20140620143901.GC7354@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140620143901.GC7354-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Joe Lawrence <joe.lawrence-7+ureL1bLXNBDgjK7y7TUQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 06/20/2014 08:39 AM, Vivek Goyal wrote:
> On Thu, Jun 19, 2014 at 05:42:57PM -0400, Tejun Heo wrote:
>> Hello,
>>
>> So, this patch should do.  Joe, Vivek, can one of you guys please
>> verify that the oops goes away with this patch?
> 
> Hi Tejun,
> 
> This patch seems to fix the issue for me. Tried 10 times and no crash.
> 
> So now one need to hold queue lock for getting refernce on the group
> only if caller does not already have a reference and if group has been
> looked up from some tree/queue etc. I guess only such usage seems to
> be in blkg_create() where we take a reference on parent after looking
> it up.
> 
> This patch looks good to me.
> 
> Acked-by: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks. Tejun, I'll queue this up for this cycle.

-- 
Jens Axboe
