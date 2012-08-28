From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 0/4] cgroup: add xattr support
Date: Tue, 28 Aug 2012 09:15:22 -0700
Message-ID: <20120828161522.GD14812@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120823205327.237533518@napanee.usersys.redhat.com>
 <20120824225839.GM21325@google.com>
 <20120827130525.GI18688@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=B8aaKid3ct9gMDlNn9UkIg+4znsm4djdbaRGlv/rov0=;
        b=hEcyKbT4hTCwRskY4Zm0DCDfvouVbpWFUrzOrlZFTVhHvIHlK7lY0akhv1o0pMpqFi
         2aF73Bx1aIf2IX6G0F0zgZmMKexggcCW9AnO7K6PDyAZd/049CY+QLw2xj57k2lh5+r9
         3XviBpdNvWPZuRfLKz7ws6lkRg4vgPv6AFqHAqWcQlHE6mek2pu8xU8b2e4OLfZqZnmZ
         PyPmj1QK/zoN6yv4h9dzaJc3/J9S5pDQjdBC0QUdKMBhAq948bPiNy/Jwhf50mcC9THl
         Dtnm06isUazjOMDhyGnSKg/Ux16ZmNKd0sEAh+qrXUD/SQe8Y43av6joncxZCsGWNIFb
         P+rg==
Content-Disposition: inline
In-Reply-To: <20120827130525.GI18688-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lennart Poettering <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Mon, Aug 27, 2012 at 09:05:25AM -0400, Aristeu Rozanski wrote:
> Hi Tejun,
> On Fri, Aug 24, 2012 at 03:58:39PM -0700, Tejun Heo wrote:
> > On Thu, Aug 23, 2012 at 04:53:27PM -0400, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > > This series are a refreshed version of a patchset submitted by Li Zefan back
> > > in march:
> > > 	https://lkml.org/lkml/2012/3/1/13
> > 
> > Applied to cgroup/for-3.7 w/ "Original-Patch-by: Li Zefan" added for
> > the first three patches.
> > 
> > * Can you please update MTA setting so that the From: header contains
> >   your full name?  Importing the series to git ended up with
> >   "aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>".
> 
> sure, will repost with that fixed and including "Original-Patch-by: Li
> Zefan" on the first three patches

Ooh, I already fixed it up myself.  I was mentioning for future
patches.

> > * Can you please add some comments and documentation regarding this?
> 
> about what exactly?

What xattr support in cgroup does and for what supposed purposes with
what kind of restrictions and some comments explaining the
implementation, I suppose.

Thanks.

-- 
tejun
