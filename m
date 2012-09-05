From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 02:11:40 -0700
Message-ID: <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
 <20120904214602.GA9092@dhcp-172-17-108-109.mtv.corp.google.com>
 <5047074D.1030104@parallels.com>
 <20120905081439.GC3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470A87.1040701@parallels.com>
 <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <50470EBF.9070109@parallels.com>
 <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com>
 <1346835993.2600.9.camel@twins>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=pZ62LlHGOIiPW4wMhy5G+KVp/i3omi6EnvyF6ogOTNU=;
        b=g6tcryjJ3RRfZ+ARQwT5jqZ2oUGs/gP91NS+NTzwJESdORJlDPd4XHnCr9QMZ4qd93
         RHX2FfmrX7OHo5MHPb1/3mQRGoIpJ7CAs3Ajo3CApDdjwVxyKTaGjxu+pbkfZKoFsq+U
         6YIFELf89ADcMTedTtjb5izf4I908LO7Zma1yRI6+uYEBtdhcw/T9Xfl+vJyfetwlKlr
         hITupbFKONm4mEJnjcny1WoIbEoVQ4y8zuGoYAMcbyqNnr9tfvlI70ATWC22GruuC1u6
         lR8hA2i/bUkCVGPcA7zy0UH8k4QRXkIhjMJkPXgXnstV1LnPIYEB6g82mn+z7CcOjOkG
         nQZQ==
Content-Disposition: inline
In-Reply-To: <1346835993.2600.9.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org

Hello, Peter.

On Wed, Sep 05, 2012 at 11:06:33AM +0200, Peter Zijlstra wrote:
> *confused* I always thought that was exactly what you meant with unified
> hierarchy.

No, I never counted out differing granularity.

> Doing all this runtime is just going to make the mess even bigger,
> because now we have to deal with even more stupid cases.
> 
> So either we go and try to contain this mess as proposed by Glauber or
> we go delete controllers.. I've had it with this crap.

If cpuacct can really go away, that's great, but I don't think the
problem at hand is unsolvable, so let's not jump it.  cpuacct and cpu
aren't the onlfy problem cases after all.  We need to solve it for
other controllers too.

Thanks.

-- 
tejun
