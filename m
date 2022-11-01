From: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: clarification about misc controller and capacity vs. max
Date: Tue, 1 Nov 2022 07:05:45 -1000
Message-ID: <Y2FR6SYazbxyK5nj@slm.duckdns.org>
References: <2f7b7d6b10bdcbc9a73ea449d3636575124afa25.camel@intel.com>
 <Y2FPSqOaQGnISvXu@slm.duckdns.org>
 <14c21f13ebbcdbd0ea4f75b7fff790b31a05a5aa.camel@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPK2zn5iH+4/8Do8MqFipb61XMSTHdDc79uVt62ln2c=;
        b=dSy2+/kvn81Hhe3kSpPj6p+kwaeinfvOAuvg9QTW2spXOeF25dVN22tLddv56zUVqw
         IgNtM75ja/S/MqrzUEWIwRxjWFZRi2VcPkjfLXIwzEM1xT2Iur7vVC53xhvIxWZQMBQ6
         rvrs4a8iHc77jpbfqQuR96nC8vpVAmUFX+ZFVvfaYoFQdWNYswpXGk//ZBC6348LZv+E
         n6WzzoB219LjIMBcOtuglzD0jrt9+MLfOnH1d7BeUgM+66sNrQjaulQUs0NLZam/j+vA
         VrxKKVju/WzX6UXoQkwxYoDrmhRgO4YNwANfei3cayl/pR/OSv3aWz4rWVZUxSLfPx8s
         9WRw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14c21f13ebbcdbd0ea4f75b7fff790b31a05a5aa.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Accardi, Kristen C" <kristen.c.accardi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Nov 01, 2022 at 05:03:25PM +0000, Accardi, Kristen C wrote:
> So to be clear, if I have this:
> 
> /sys/fs/cgroup/misc.capacity
> some_res 10
> 
> and this:
> /sys/fs/cgroup/test
> 
> test.current will never be allowed to exceed 10.

Yes, but test.max can be whatever. So, the resources themselves can't be
over-committed. The max limits (ie. the promises) can be.

Thanks.

-- 
tejun
