From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH v4 18/21] fuse: Add support for pid namespaces
Date: Wed, 20 Jul 2016 07:52:01 -0500
Message-ID: <20160720125201.GA52079@ubuntu-hedt>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
 <1461699396-33000-19-git-send-email-seth.forshee@canonical.com>
 <CA+2rt426_pshAauQizcxkfAq16vmEpB4sJ4genW_ucosH3j=zQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GKJc6vFFWaOGRrU5Un9ZmH54/Hytp+GZN2+OSbGSzCA=;
        b=QkSDKPXABg2oMZxkcvSE8Dk6BRmupBDNMiPW1Rd/MCerbnw0FZ4Z6O+EAzyyd6yPpx
         07mQj3XLKNTJ2VT6XjUx/rS4hS2M9PsCswEYRIsIGupDn7VOHRc21qo9QlCspjmGxkeb
         hQDv6Yq7L/pHOLwHBiIOCSQRxJe1druGj6/ga4K2ljdPpKhJdDI4ffObVwY0Mr/M7Z2R
         WavF3PJEvJE9f9A1txNWNjAhNOiL+f9058nQaSiUtpkb7d4dXe5qyHbkF9uM0cEry5KV
         Ti7kRuFJnKcNr54YYkCZCIkL9ukzp8xDye8Te0kHWkQ+Z4phqTCneu6zULwHhjsIi6EY
         Z+Zg==
Content-Disposition: inline
In-Reply-To: <CA+2rt426_pshAauQizcxkfAq16vmEpB4sJ4genW_ucosH3j=zQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sheng Yang <sheng-bA7cAZRAfhAdnm+yROfE0A@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 19, 2016 at 07:44:11PM -0700, Sheng Yang wrote:
> On Tue, Apr 26, 2016 at 12:36 PM, Seth Forshee
> <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org> wrote:
> > When the userspace process servicing fuse requests is running in
> > a pid namespace then pids passed via the fuse fd are not being
> > translated into that process' namespace. Translation is necessary
> > for the pid to be useful to that process.
> >
> > Since no use case currently exists for changing namespaces all
> > translations can be done relative to the pid namespace in use
> > when fuse_conn_init() is called. For fuse this translates to
> > mount time, and for cuse this is when /dev/cuse is opened. IO for
> > this connection from another namespace will return errors.
> >
> > Requests from processes whose pid cannot be translated into the
> > target namespace are not permitted, except for requests
> > allocated via fuse_get_req_nofail_nopages. For no-fail requests
> > in.h.pid will be 0 if the pid translation fails.
> 
> Hi Seth,
> 
> This patch caused a regression in our major container use case with
> FUSE in Ubuntu 16.04, as patch was checked in as Ubuntu Sauce in
> Ubuntu 4.4.0-6.21 kernel.
> 
> The use case is:
> 1. Create a Docker container.
> 2. Inside the container, start the FUSE backend, and mounted fs.
> 3. Following step 2 in the container, create a loopback device to map
> a file in the mounted fuse to create a block device, which will be
> available to the whole system.
> 
> It works well before this commit.
> 
> The use case is broken because no matter which namespace losetup runs,
> the real request from loopback device seems always come from init ns,
> thus it will be in different ns running fuse backend. So the request
> will got denied, because the ns running fuse won't able to see the
> things from higher level(level 0 in fact) pid namespace.
> 
> I think since init pid ns has ability to access any process in the
> system, it should able to access the fuse mounted by any pid namespace
> process as well.
> 
> What you think?

It sounds like we need to remove the restriction on accessing the
filesystem from a different pid namespace. I don't think this poses a
security problem. However there's no pid mapping that is usable by the
userspace fuse process, so what do we put in the fuse request? Probably
the only candidates are 0 and 0xffffffff.

So a question for the fuse developers - is one value or the other
preferrable for fuse_in_header.pid when the pid cannot be mapped, and is
this going to cause problems for any fuse filesystems? I suspect that
few filesystems actually look at the pid anyway, and already for a
filesystem mounted in a pid namespace the values being given to
userspace won't be correct for the namespace of the fuse process.

Seth
