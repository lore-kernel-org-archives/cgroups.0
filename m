From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: PROBLEM: NULL pointer dereference in kernel 4.14.6
Date: Tue, 19 Dec 2017 14:37:04 -0800
Message-ID: <20171219223704.GS3919388@devbig577.frc2.facebook.com>
References: <1513628274.1378.1.camel@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Jgt2G+fppPVkfGzSjw5B479ECfeOjHC7CalJUmwtPMQ=;
        b=YyA01+Dr4iXwEnEmZ3mJWU8e0ZQ3OghGePf9VThpbwCMqXMTc0EEigucbMFSgPpL7x
         aQzS990JDZD5dYmsWPtA9210cpKCTOU39YSCvqulB2cwbY5Tnb7ca3zCKXayLKKggk2/
         WsewntPAOolhv2cX8JULT7VpnbCAK7/uKRuP9YjCVzDb5jzmn6/cX1iFw1DixOzZW6F5
         J9aO9Qxw4xbgkBJ4nw1bdzI05TTEg15KZtl9oWe71t/NXuJxAAFqRnTCOOx8Ng5ItW9z
         bQTkMxnwNiTuwJs1QbxLZmOwetPuxWNt3wP5RWmOaorxsgm9q5b9qU9fsDfYn1PfEbQs
         RtIw==
Content-Disposition: inline
In-Reply-To: <1513628274.1378.1.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: George Amanakis <gamanakis-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Dec 18, 2017 at 03:17:54PM -0500, George Amanakis wrote:
> I can replicate this on a Thinkpad X230i running archlinux with latest
> 4.14.7 kernel, without the ZFS modules.
> 
> Steps to reproduce:
> 1) create a virtual machine using libvirt (attached xml)
> 2) virsh start vm
> 3) head /sys/fs/cgroup/unified/machine.slice/machine-
> qemu\\x2d2\\x2dvm.scope/cgroup.procs

It took some massaging but I can reproduce the problem.  Will report
when I know more.

Thanks.

-- 
tejun
