From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes] cgroup: make css_set pin its css's
 to avoid use-afer-free
Date: Tue, 24 Nov 2015 09:59:45 -0500
Message-ID: <20151124145945.GF17033@mtj.duckdns.org>
References: <20151123195541.GA19072@mtj.duckdns.org>
 <56543C76.2050008@bmw-carit.de>
 <20151124144418.GB17033@mtj.duckdns.org>
 <56547B22.2020802@bmw-carit.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=uJ2lqUuO8/ebjKyk9yvtzloR5TJ5lMciTtZC2rvBVdw=;
        b=iMPJq4ZgRt4pvBZ3v28stCxMLqjSEN4gJdfcESbPdoKINqgTGSdunSvX4N3WMrhn+N
         cpHsNpoRKOy4YilVe1HF6bEX3FP2nYpZDPvppsxnANw8SrMVYrrLi+A6DNFgHkI3pG6m
         8FJCoZ4BxS/A6zB3CBOFYtZrwO8CCCvWiCFuGuqcxBh0MrhXGhyx5uumeKpefGkymARw
         bK1dTZZC9g2JoO3u5iDT3zkC3C0FLom+e5ngqlw9KPE15L+EySAaPbGuUatcBQKyeIAC
         Gtxb7CSr85I4i+AV8Dso4oTt4cjryqj9+dYkdDVkXnWb2m7OXXHPrF/EsK94wNQz5tLb
         TMoA==
Content-Disposition: inline
In-Reply-To: <56547B22.2020802-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

Hello,

On Tue, Nov 24, 2015 at 03:58:42PM +0100, Daniel Wagner wrote:
> I start a not so updated rawhide image with some funky kernel options.
> They are more less some left overs from debugging:
> 
> $QEMU -gdb tcp::1235 -enable-kvm -machine accel=kvm \
>       -m 2G -cpu Haswell \
>       -smp sockets=1,cores=2,threads=2 \
>       -hda ~/vm-images/rawhide-big.qcow2\
>       -net nic,model=virtio \
>       -net user,hostfwd=tcp::7777-:22 \
>       -monitor telnet:127.0.0.1:1234,server,nowait \
>       -serial stdio -display none \
>       -append "root=/dev/sda1 console=ttyS0 audit=0 isolcpus=3 systemd.unified_cgroup_hierarchy=1" \
>       -kernel arch/x86_64/boot/bzImage $@
> 
> After starting the image I just wait for a few seconds and I'll get it.
> No interaction needed.
> 
> > If you have a qemu image which reproduces this, I'd be happy to take
> > a look at it.
> 
> I'll upload it, though it will take a while... the fun of living
> with asymmetric connectivity.

Great, thanks a lot!

-- 
tejun
