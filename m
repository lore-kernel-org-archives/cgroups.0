From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 6/6] blkcg, memcg: make blkcg depend on memcg on the
 default hierarchy
Date: Wed, 9 Jul 2014 07:57:46 -0400
Message-ID: <20140709115746.GA26504@redhat.com>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
 <1403917392-32555-7-git-send-email-tj@kernel.org>
 <20140628114907.GA10829@htj.dyndns.org>
 <20140708194226.GA18382@redhat.com>
 <20140708215351.GJ4979@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140708215351.GJ4979-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org

On Tue, Jul 08, 2014 at 05:53:51PM -0400, Tejun Heo wrote:
> Hello, Vivek.
> 
> On Tue, Jul 08, 2014 at 03:42:26PM -0400, Vivek Goyal wrote:
> > I have couple questions about new semantics. Following is my
> > understanding. Is it right?
> > 
> > - So after this change one can not use blkio controller on unified
> >   hiearchy if memory controller is mounted on some other hierarchy
> >   and is not available for mounting unified hiearchy.
> 
> Hmmm?  No, the only behavior which changes is when both blkcg and
> memcg are mounted on the unified hierarchy.  Nothing else changes.
> The dependency behavior kicks in iff memcg is available on the unified
> hierarchy.

Ok, good to know that dependency kicks in only if controlle being depended
on is available on the hierarchy.
> 
> > - If blkio controller is enabled on unified hiearchy (memory controller
> >   implicitly enabled), then one can't mount memory controller on other
> >   hierarchies without first disabling blkio controller on unified hiearchy.
> 
> Yes, blkio needs to be disabled to the root for memcg to be able to
> become free.  This is an extra restriction but I don't think it's
> anything drastic.  Once a controller starts being actively used on any
> hierarchy, nothing has been guaranteed about when the controller would
> become free again even if the whole hierarchy is reduced to the root.

Agreed. Thanks for the clarification.

Thanks
Vivek
