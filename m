From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
Date: Wed, 5 Sep 2012 02:32:04 -0700
Message-ID: <20120905093204.GL3195@dhcp-172-17-108-109.mtv.corp.google.com>
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
        bh=uJ9y/WYlqz74FFpQlSv5tnQ+MrHWEhF+9lHDeFOwp5Q=;
        b=uHlW0n6KDR4dbknp6RRZlzYNod46/WpG04AfvYBQf+IiU2csQMYCU4uWfsau3AS5IN
         X0r1JwgZrxSOlieVlOXpn+bpis7kBM761SzSkbx90UNxqd7T/1jW05C9CXz3zkRlznJZ
         Xgrn4cOvlk/UkhdHhdTzRmHkVYoaMy66v1a5tAXkEmacFqAbRJYkWtz+s3OXKvZH7aeE
         OlSddnd2+uuGA7zL5HIUvbENJrln/zKNIaMS/LlyPVQY77ifh+WRP6Rupdj+1SqkqsCB
         rpBDR7KbmkLq3ozlKF/xWd3nABvDoFCS/oUHU14lipBKpXUVPkXv2ntbDcakqkmEZaQZ
         wjmA==
Content-Disposition: inline
In-Reply-To: <1346835993.2600.9.camel@twins>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay.sievers-tD+1rO4QERM@public.gmane.org

Hey, again.

On Wed, Sep 05, 2012 at 11:06:33AM +0200, Peter Zijlstra wrote:
> Doing all this runtime is just going to make the mess even bigger,
> because now we have to deal with even more stupid cases.
> 
> So either we go and try to contain this mess as proposed by Glauber or
> we go delete controllers.. I've had it with this crap.

cpuacct is rather unique tho.  I think it's gonna be silly whether the
hierarchy is unified or not.

1. If they always can live on the exact same hierarchy, there's no
   point in having the two separate.  Just merge them.

2. If they need differing levels of granularity, they either need to
   do it completely separately as they do now or have some form of
   dynamic optimization if absolutely necesary.

So, I think that choice is rather separate from other issues.  If
cpuacct is gonna be kept, I'd just keep it separate and warn that it
incurs extra overhead for the current users if for nothing else.
Otherwise, kill it or merge it into cpu.

Thanks.

-- 
tejun
