From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Mon, 12 Mar 2012 16:09:49 -0700
Message-ID: <20120312230949.GN23255@google.com>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <20120312223113.GB18359@tango.0pointer.de>
 <20120312230020.GL23255@google.com>
 <1331593367.18960.66.camel@twins>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mAUnXriq5tXCo+abYFOZVVPHxEi9bwtKNjP5QBMjDm0=;
        b=OZ+Q3NqaGU+kMzUAn0o9NK6tifnew4ypLo2KXtqD0bF1nZg/SV2hyiIFD8Fwlpk5Ls
         14rUyhGHC3i5YBpkRTLYsknGurdYC5eZOgFMSCJnixRd9h1UG2rmilM3khLBf+TPoYPO
         hD3D5aHxrE/MN9wUQeGExWU+vusnrU4tyMNXNNpaUJrAQ8tW6BaTsj/i6JNN3gMHe+CV
         rohCdtMGFFFmlMeSZpsH95Brc9mQQhoxiZ81CPiOzhsn9PsaaMFeJGXatYy03BSBrW1b
         OQRGhfa+8ZTWmRcwuU2Q1KgtIv2Oj/NxDKd86GYIy75I/zkTsuSf/OTx3ZwNM4kTxKgh
         qyWA==
Content-Disposition: inline
In-Reply-To: <1331593367.18960.66.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Peter.

On Tue, Mar 13, 2012 at 12:02:47AM +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-12 at 16:00 -0700, Tejun Heo wrote:
> > 
> > Ooh, both will be available to choose from.  I was trying to explain
> > that there can be configuration only at one layer for any task so that
> > it can be mapped to flat hierarchy.  Where to apply the config will be
> > selected by the user (or system tool). 
> 
> Thus in effect this is a false choice, since Lennart and assorted idiots
> conspire against sanity by pushing systemd into our every orifice, and
> since he just said systemd requires one of the two, the choice will be
> made for us, lest we forfeit wanting to boot our system.

I think it should be fine as long as systemd or whatever system cgroup
manager can be told to stay aside about limits.  Everyone doing their
own thing and ending up competing directly under /sys/fs/cgroup/
worries me more.  cgroup config fs doesn't have enough flexibility or
proper provisions for sharing while encouraging direct usage.  That's
not a good combination.

Thanks.

-- 
tejun
