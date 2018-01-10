From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Wed, 10 Jan 2018 06:02:39 -0800
Message-ID: <20180110140239.GX3668920@devbig577.frc2.facebook.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
 <CAKgNAkhk-527Rh6tGYJO-U3UXgwBC1+t5nB+5JEq62nTO2p15A@mail.gmail.com>
 <20180110124407.GA26913@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yQF67ZK9IQemej0hbqoy/Xx5GyzzSmbdw4YUexGgqmE=;
        b=DpbOMcLlD7pRN9yj6NMTwYz6IiDNogZAOchy1zdjqN7ILcChFvmHA34pSFUqyWYKO1
         57ygBXGNCmNG6FPzzTCtP6RGgP0ycjQkvN2JxKtRoUASFoe+3WAifV4C53dCApggK+EC
         EFZX5dM9xfti1BEbf9sVEEWI9ce4YdipWfYKBipxcknc6yEETbwffhiYgfiTYQ25/pxd
         eMM1FnFXqQnj0fw7QVwbfjpExRNcRYF9rOZf9xyotj6edx4/6zlVxl8EUjIA3hRJU7m1
         SyoSeUfAZ75QKQMWH5bAjg1477DM7Vjcybk2DT+uVxS3M3IJ1UGbEOpSSJTDOsMwYIY7
         Jhwg==
Content-Disposition: inline
In-Reply-To: <20180110124407.GA26913-B3w7+ongkCiLfgCeKHXN1g2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Wed, Jan 10, 2018 at 04:44:14AM -0800, Roman Gushchin wrote:
> cgroup.threads is not listed because it's not delegatable (doesn't have
> CFTYPE_NS_DELEGATABLE flag set). I don't know if it was intended or just
> an accident (I believe the latter).

So, thread mode isn't delegatble.  Marking a cgroup as threaded turns
that subtree threaded and join the parent's domain, so we can't allow
delegation roots to be turned threaded - just like we can't mark the
root cgroup threaded, and I'm not really not sure what it means to
delegate a portion of threaded subtree.

Thanks.

-- 
tejun
