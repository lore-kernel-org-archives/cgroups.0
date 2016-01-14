From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] cpu subsystem for unified hierarchy.
Date: Thu, 14 Jan 2016 16:57:49 -0500
Message-ID: <20160114215749.GE3520@mtj.duckdns.org>
References: <1452674420-31603-1-git-send-email-yangds.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=tfcXuNg0sLq9AoLWumCg5eX9VG28I71QBQIa8GbC3Ms=;
        b=VgfcD+9/k5PXX0Wx47czOFmZqAwh07Oq4UBXkQhqbUm2lQ89dkn/KiqvUXWsf15bdA
         ODhchBEab8GNRFCibw9K7gbPAx7vaHjJRW8za5BtlivXrOMV+xerO7dB7Mrdvgr1Xuvj
         +kKIb2EGARFfucAeKZAso1U/6bK2EJi5nJb7JIz/y22pDWIkkg6tlcUHEuUu9GD32cG3
         lUljSzNugQeld2w2R9J7qTxb0UFG/2a84vdTzYDK++MCi3poKRJvhggapyq6zKPQH03P
         yfydAwazn6RdlqgpRm1HRxds/+ZL2kP9fW+kr3XX6EDOZZUuz2soNJIcM84Lv84aQUEQ
         qsRw==
Content-Disposition: inline
In-Reply-To: <1452674420-31603-1-git-send-email-yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Dongsheng.

On Wed, Jan 13, 2016 at 04:40:18PM +0800, Dongsheng Yang wrote:
> Hi TJ,
> 	When I want to improve cpuacct subsystem, you said we are going
> to combine cpuacct and cpu subsystem. Then I am here to try to implement
> cpu subsystem in unified hierarchy and squash cpuacct in it.

There's already a patchset pending.

  http://lkml.kernel.org/g/20160105164758.GD5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org

Thanks.

-- 
tejun
