From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to use
 freezable_schedule()
Date: Fri, 26 Oct 2012 14:29:09 -0700
Message-ID: <20121026212909.GW11442@htj.dyndns.org>
References: <20121023153919.GA16201@redhat.com>
 <20121026180149.GA22421@redhat.com>
 <2566006.UzAQbpOjNQ@vostro.rjw.lan>
 <2718983.vORnrfWdbE@vostro.rjw.lan>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7LyAbWoc2HiwSTVv2eEl4dG5DQ9gTqgkNtFgQLfaChY=;
        b=G1oCsOsgM3ZYtOVFMdZUjNSGDCdf99a2+08jix0V+24P0x/umiUz931ySVi6LRA0aW
         djxmDp5HQOJhdJkYVigWm8yGOiBbjQog4P+1cxkcqmUg4SZNTayYfWSVMDrN6dmVTIKb
         JZerSyHTpzrCxOgfBu/EMLUhwTSDt8xZQ3qwu6OvTx1DatUdilUqgsV/xrC43zZ/LY45
         H/7ckXtHSGUZSBdou7kAMPiQaGBJrPSzBamqrYcjp8pWTUuPKzlj8D3QW1nCvvyDfYn1
         NdM5htSggUhISwQ5gvdvPWe3x+NwF8xGGxNCmt/nHHTlIQi/rTtwfzOTQc2P6NbuQ56W
         tebg==
Content-Disposition: inline
In-Reply-To: <2718983.vORnrfWdbE-sKB8Sp2ER+y1GS7QM15AGw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Oct 26, 2012 at 11:29:56PM +0200, Rafael J. Wysocki wrote:
> Actually, what tree is it supposed to apply to?
> 
> The change in kernel/cgroup_freezer.c doesn't look like anything in
> the current Linus' tree to me.

Ooh, right.  This depends on the earlier cgroup_freezer changes.
Sorry about the confusion.  I'll apply it to the following branch (the
same one used for the previous cgroup_freezer updates).

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git cgroup-freezer

Thanks.

-- 
tejun
