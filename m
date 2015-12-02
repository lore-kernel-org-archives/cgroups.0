From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Wed, 2 Dec 2015 11:58:39 -0500
Message-ID: <20151202165839.GD19878@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-8-git-send-email-serge@hallyn.com>
 <20151124171610.GS17033@mtj.duckdns.org>
 <20151127051745.GA24521@mail.hallyn.com>
 <20151130150938.GF3535@mtj.duckdns.org>
 <20151201040704.GA31067@mail.hallyn.com>
 <20151201164649.GD12922@mtj.duckdns.org>
 <20151201215853.GA9153@mail.hallyn.com>
 <20151202165312.GB19878@mtj.duckdns.org>
 <20151202165637.GA20840@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QxbkxMh5IhLzwsC7E/oGQglJaOVK08g4g2sW+fTGtmY=;
        b=SMoQJffs9chsZ4LLYdgdImcNfVEo8Y6jdY/+WUiftk4C55oZj0LwoOMV62wXTJVo6q
         HIMgrIvgFY0kMo7KbmdFnNR6vGChnvTExbZ9iQd6R33EaEf3Ht1orwX1lmAhla3xjtja
         8UlksGkXMa3wQI/p8KnxKSS/O+0/Cstu5bPXJmzxl+aqj9NuY1iJ7RJLfcWguAE3CZB3
         ejLPmLvMcQUBiVocf/xSocfN2Sm4Q/Zac0AL9V/kFx9EdrYKMtjAICXjgSzKTCkDTNE6
         yuOiOHabhDqYL5pcwJJYKr7bsZ/YOogkRS+JFgM86Gw66YLIQxd7IabmY+W/1v7OzaC+
         QKgg==
Content-Disposition: inline
In-Reply-To: <20151202165637.GA20840-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org

On Wed, Dec 02, 2015 at 10:56:37AM -0600, Serge E. Hallyn wrote:
> Can it be flushed when we know that the cgroup is being pinned by
> a css_set?  (There's either a task or a cgroup_namespace pinning it
> or we wouldn't get here)

Yeap, it can be flushed.  There's no ref coming out of cgroup to the
vfs objects.

Thanks.

-- 
tejun
