From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Workman-devel] cgroup: status-quo and userland efforts
Date: Fri, 28 Jun 2013 15:43:10 -0700
Message-ID: <20130628224310.GF18889@mtj.dyndns.org>
References: <1372311907.5871.78.camel@marge.simpson.net>
 <20130627180143.GD5599@mtj.dyndns.org>
 <1372391198.5989.110.camel@marge.simpson.net>
 <20130628040930.GC2500@htj.dyndns.org>
 <1372394950.5989.128.camel@marge.simpson.net>
 <20130628050138.GD2500@htj.dyndns.org>
 <20130628150513.GD5125@dhcp22.suse.cz>
 <20130628180155.GD16483@redhat.com>
 <20130628195917.GG2507@redhat.com>
 <20130628224053.GA9426@tp>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FWPE8v0X7x1jfdVqxE64Y1oL6w3VF90D14vbF6xuILs=;
        b=G8F9K/KYfQxZ6mIj0Fw6adu/MVHYKW4ximXXQs9aMS6HfkES2xcwlElxxp8XiYiC1q
         AArq0lkUFwMvIe2HHK/RODNUF3EdLu0ewbaXANoys10ogDvBuL3ZYHwlhCOw253ZPWk7
         z2JTygmOtuN/MZylotnWr3qRPgZnfY6rSr1EPvLpjLvakLgLUR5tmveMwZpWhvXmJyDF
         UMiH7RTtDzHwuVarKEGKC2a2DCC5ZO7bdl7bjfHcrwUOeS6ijpVHEolwBkvTvJUhTxTO
         dab5lqfKE21EAFAQ3qeG436UpNovcF8z7PBJ12ZHmIx7j2GjY+hSfIpuIdlbe2s50Qxm
         9TbQ==
Content-Disposition: inline
In-Reply-To: <20130628224053.GA9426@tp>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Mike Galbraith <bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lpoetter <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, "dhaval.giani" <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, workman-devel <workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Jun 28, 2013 at 05:40:53PM -0500, Serge Hallyn wrote:
> > The kernel can exposed a knob that would allow systemd to lock that
> > down
> 
> Gah - why would you give him that idea?  :)

That's one of the ideas I had from the beginning.

> But yes, I'd sort of assume that was coming, eventually.

But I think we'll probably settle with a mechanism to find out whether
someone else is touching the hierarchy, which will be generally useful
for other consumers of cgroup too.

Thanks.

-- 
tejun
