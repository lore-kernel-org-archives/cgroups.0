From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Date: Sun, 30 Jun 2013 20:38:38 +0200
Message-ID: <20130630183838.GB23731@dhcp22.suse.cz>
References: <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org>
 <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org>
 <20130628150513.GD5125@dhcp22.suse.cz>
 <20130628180155.GD16483@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=N8Sf5aasIuDM4sukO2+3rUX8AxjDXajZp+edVSr07q4=;
        b=U53Jo4i1yleTczyGI719rUNc95tNnHcfhK4WjhcoYiWw049nmHTfSj/u/eyfFoliAh
         jndEQv2jrYubjyFCGpRyjbNt1Aqi6iVIkqa3ISZ30Dutc+5S1ijB1BlYCSmfNJM4uiLO
         GLkS3b/H0jK0v4/ucr0KFgU+o67XURr5xrGeRnYH/uDJdQx1AM+1U0wPg6fv0pGAwzPY
         w4JptzygjadrYJkPgpo9o5saYF3zxtiUtdTZ2+d0NPJiP5zFHXsKmyQLGlZirTHd80XO
         6CQo8yyyrUJRG0X/+sYYU8P12Begm936syGCjIGMKgVzDml4fEw2nb2YMRdkyRrhLB6N
         hYTw==
Content-Disposition: inline
In-Reply-To: <20130628180155.GD16483-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Mike Galbraith <bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, lpoetter <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, workman-devel <workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dhaval.giani" <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, bsingharora <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri 28-06-13 14:01:55, Vivek Goyal wrote:
> On Fri, Jun 28, 2013 at 05:05:13PM +0200, Michal Hocko wrote:
[...]
> > OK, so libcgroup's rules daemon will still work and place my tasks in
> > appropriate cgroups?
> 
> Do you use that daemon in practice?

I am not but my users do. And that is why I care.

> For user session logins, I think systemd has plans to put user
> sessions in a cgroup (kind of making pam_cgroup redundant).
> 
> Other functionality rulesengined was providing moving tasks automatically
> in a cgroup based on executable name. I think that was racy and not
> many people had liked it.

It doesn't make sense for short lived processes, all right, but it can
be useful for those that live for a long time.
 
> IIUC, systemd can't disable access to cgroupfs from other utilities.

The previous messages read otherwise. And that is why this rised the red
flag at many fronts.

> So most likely rulesengined should contine to work. But having both
> systemd and libcgroup might not make much sense though.
> 
> Thanks
> Vivek

-- 
Michal Hocko
SUSE Labs
