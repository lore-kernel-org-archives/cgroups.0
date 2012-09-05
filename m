From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] memcg: first step towards hierarchical controller
Date: Wed, 5 Sep 2012 13:12:38 -0700
Message-ID: <20120905201238.GE13737@google.com>
References: <5045BD25.10301@parallels.com>
 <20120904130905.GA15683@dhcp22.suse.cz>
 <504601B8.2050907@parallels.com>
 <20120904143552.GB15683@dhcp22.suse.cz>
 <50461241.5010300@parallels.com>
 <20120904145414.GC15683@dhcp22.suse.cz>
 <50461610.30305@parallels.com>
 <20120904162501.GE15683@dhcp22.suse.cz>
 <504709D4.2010800@parallels.com>
 <20120905144942.GH5388@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=k8u1v02Yx+ChY5Gi4G+DXD0jYfNf7qvg4oCmXd/umTk=;
        b=ADaw4xEulr2y4qc8lD1vxlg5P9DbfEM9f4ONyLPKfX42uPwx1ijaQswUij43BaztCC
         XyJWkeFotxqMASO2JrCD/Fl7Ehfdj4+fNW/wi6eufqVdZuDoPN/OdSh92854cFddUhEL
         w6gd1WrppDtEwDKHfTXE03twARKvWOJYSkOzaSRA4/3+0PkWotpCuBOjeLP1W73KVbWq
         Eb2RrTPU+ctypZiYHoKoXm/6KsxEImRjWBnjPs1OLi5JKK1juWATP84eD7Pq9HrnLpT6
         R1DImXe88cF7nJZwMh7ZG6TPyEW3kWrNcyi0rr7oFem3VA9XlO3k7YqznhQQXhmFt76l
         fukQ==
Content-Disposition: inline
In-Reply-To: <20120905144942.GH5388-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello, Michal.

On Wed, Sep 05, 2012 at 04:49:42PM +0200, Michal Hocko wrote:
> Can we settle on the following 3 steps?
> 1) warn about "flat" hierarchies (give it X releases) - I will push it
>    to as many Suse code streams as possible (hope other distributions
>    could do the same)

I think I'm just gonna trigger WARN from cgroup core if anyone tries
to create hierarchy with a controller which doesn't support full
hierarchy.  WARN_ON_ONCE() at first and then WARN_ON() on each
creation later on.

> 2) flip the default on the root cgroup & warn when somebody tries to
>    change it to 0 (give it another X releases) that the knob will be
>    removed
> 3) remove the knob and the whole nonsese
> 4) revert 3 if somebody really objects

If we can get to 3, I don't think 4 would be a problem.

Thanks.

-- 
tejun
