From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/15] cfq-iosched: Properly name all references to IO
 class
Date: Wed, 3 Oct 2012 09:06:13 -0400
Message-ID: <20121003130613.GC20376@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-2-git-send-email-vgoyal@redhat.com>
 <20121003005429.GA15806@localhost>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121003005429.GA15806@localhost>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Oct 03, 2012 at 09:54:29AM +0900, Tejun Heo wrote:

[..]
> > -	return cfqg->service_trees[wl][ASYNC_WORKLOAD].count
> > -		+ cfqg->service_trees[wl][SYNC_NOIDLE_WORKLOAD].count
> > -		+ cfqg->service_trees[wl][SYNC_WORKLOAD].count;
> > +	return cfqg->service_trees[wl_class][ASYNC_WORKLOAD].count
> > +		+ cfqg->service_trees[wl_class][SYNC_NOIDLE_WORKLOAD].count
> > +		+ cfqg->service_trees[wl_class][SYNC_WORKLOAD].count;
> 
> While at it, maybe move the operator to the end of the preceding line
> like everybody else?

Ok, will do.

Thanks
Vivek
