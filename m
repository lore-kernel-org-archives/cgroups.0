From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Wed, 10 Jan 2018 09:33:40 -0800
Message-ID: <20180110173340.GG3668920@devbig577.frc2.facebook.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
 <CAKgNAkhk-527Rh6tGYJO-U3UXgwBC1+t5nB+5JEq62nTO2p15A@mail.gmail.com>
 <20180110124407.GA26913@castle.DHCP.thefacebook.com>
 <20180110140239.GX3668920@devbig577.frc2.facebook.com>
 <CAKgNAkhDY09gauX-1Ut4SoL9DEoxj9wJ8SjS6h-Ntc90xeWi1A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zqlEtFx2jmj4qFzEu1tpEePKgokpXowGL+qhmkhNznM=;
        b=Bqf2VddssPJFJkIVxxTS9MF3hpDBWwFgKpLrRnyTDuj5D7AaPSoX9FLl84Gc/ehP4t
         rr5XLTOZpL6e8RZWV3BrsPIUPH2E62FdBmu3QDit/f7ZyqC7BlogSfyGyogez855MfJr
         9BKJdp0Nn0DtrXqgKCSsnkADmGkd70p8r4T+jzqhA0PKohaXYWfB85HcxqvVuVsNFY06
         rLAEKfOsWJZJerqQSGFqhUUe49JfzhNE3HzMAh/hWjZpd2iWLR8KRQKlo1AopvK0flbt
         vqgsCGBM+ybffUVfgjvftON/R25T9NZcqM/gaytfMBavBXbAf2KWIETpngA4l0MK50kr
         6oJw==
Content-Disposition: inline
In-Reply-To: <CAKgNAkhDY09gauX-1Ut4SoL9DEoxj9wJ8SjS6h-Ntc90xeWi1A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Michael.

On Wed, Jan 10, 2018 at 06:31:20PM +0100, Michael Kerrisk (man-pages) wrote:
> So, I am confused. According to Documentation/cgroup-v2.txt,
> cgoup.threads is delegated:
> 
> [[
> Model of Delegation
> ~~~~~~~~~~~~~~~~~~~
> 
> A cgroup can be delegated in two ways.  First, to a less privileged
> user by granting write access of the directory and its "cgroup.procs",
> "cgroup.threads" and "cgroup.subtree_control" files to the user.
> Second, if the "nsdelegate" mount option is set, automatically to a
> cgroup namespace on namespace creation.
> ]]
> 
> So, is that a mistake in that text file?

Yes, it is.  I probably copy&pasted from an earlier version where we
were marking threaded domains instead of threaded roots.  Will fix it
right away.

Thanks.

-- 
tejun
