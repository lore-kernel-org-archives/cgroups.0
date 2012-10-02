From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/15] cfq-iosched: More renaming to better represent
 wl_class and wl_type
Date: Tue, 2 Oct 2012 09:25:00 -0400
Message-ID: <20121002132500.GA758@redhat.com>
References: <1349119976-26837-1-git-send-email-vgoyal@redhat.com>
 <1349119976-26837-3-git-send-email-vgoyal@redhat.com>
 <x49r4phj4rm.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <x49r4phj4rm.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, tj@kernel.org, cgroups@vger.kernel.org

On Mon, Oct 01, 2012 at 04:50:37PM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Also at places I have got rid of keyword "serving" as it is obivious.
> 
> I don't agree with getting rid of serving.  After your patch, it looks
> as though a cfqd has a static workload class and type.  It reads better
> to me the way it is.

It is also about the length of name. To me now a days CFQ code looks
pretty messy with very long names or lines at many a places.

So yes, "cfqd->serving_wl_class" and "cfqd->serving_wl_type" is more
readable than "cfqd->wl_class" and "cfqd->wl_type". But it also 
increases the string length significantly.

I don't know. Some of the strings seem too long and code spills into
multiple lines for a single statement.

Anyway, for this I guess I will retain "serving" keyword.

Thanks
Vivek
