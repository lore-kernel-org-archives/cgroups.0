From: Alexei Starovoitov <alexei.starovoitov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/5] net: add udp limit to net cgroup
Date: Fri, 12 Aug 2016 21:35:37 -0700
Message-ID: <20160813043535.GB55856@ast-mbp.thefacebook.com>
References: <1470876798-4024-1-git-send-email-anaravaram@google.com>
 <1470876798-4024-4-git-send-email-anaravaram@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gA4ifge25llI5KaUH15w8xonQqPGjF9S/ei/rd7K16I=;
        b=sxe5BDxONrQ01AcQ0fUrAeOv3ZoF5XwofPtGusoW2nXyjmpwULxtjMSU+SjGA+hCV7
         43qQuKASNWqljR5VcR7CttJbj0dHll+g0XNqBZhGVSZqfRGQchmyHCLForX+4u7p+K4Z
         8rJeLhP7/aNa/1pwkG/mfrZXcR3UKgWtRXx0IHwNSs7c2eVCJpaO5iPj2iMjfXX3uJQ9
         CgypUkN+UI62GJTwQaeuRTfoXkWieHOWtkwOsYV34pigA6flK4Wtns0AM8H0kexmnoos
         q9D0gPFHnbJadHvze9K2ryRO5/9pN54Ow+A/92t/KeRNVwonzgittKWKJ94Q389m3Ylg
         utdg==
Content-Disposition: inline
In-Reply-To: <1470876798-4024-4-git-send-email-anaravaram-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anoop Naravaram <anaravaram-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: corbet-T1hC0tSOHrs@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org, kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, maheshb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, weiwan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tom-BjP2VixgY4xUbtYUoyoikg@public.gmane.org

On Wed, Aug 10, 2016 at 05:53:16PM -0700, Anoop Naravaram wrote:
> udp port limit
> --------------
> This property controls the limit of udp ports that can be used by the
> processes in a cgroup. The controller manages udp statistics (usage,
> limit, etc) for each cgroup. Every cgroup also keeps track of the udp
> ports acquired by its descendants. If a process tries to acquire a port
> when its cgroup has already reached its limit, it will fail with error
> EACCES. It will also fail if one of the cgroup's ancestors has reached its
> limit. There are 5 files exposed to userspace to configure this property:
> 
> * 'net.udp_usage': Reading this file gives the number of udp ports used by
> processes in this cgroup and all its descendants.
> * 'net.udp_limit': Writing this file sets the total number of udp ports
> that can be used by processes in this cgroup and all
> its descendants. This file can also be read.
> * 'net.udp_maxusage': Reading this file gives the highest value of
> net.udp_usage that has been seen for this cgroup.
> * 'net.udp_failcnt': Reading this file gives the number of times a
> process in this cgroup or one of its descendants has attempted to acquire
> a udp port but failed because the limit of this cgroup was reached.
> * 'net.udp_underflowcnt': Reading this file gives the number of times a
> process in this cgroup or one of its descendants released a udp port when
> the usage value of this cgroup was 0.

I have similar concern here. I don't think we should bloat the kernel by
trying implement every possible port restriction combination and count.
For the same reasons we don't do all possible tcp stats that research
community finds useful. This additional code is a maintenance headache.
