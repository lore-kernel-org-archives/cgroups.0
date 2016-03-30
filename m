From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] cgroup namespaces: add a 'nsroot=' mountinfo field
Date: Wed, 30 Mar 2016 14:58:24 -0400
Message-ID: <20160330185824.GR7822@mtj.duckdns.org>
References: <20160321234133.GA22463@mail.hallyn.com>
 <20160329011203.GA8974@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tW/7XofJ2JykOdo27CRkuvTuVJvLqotmVpPDoZSpjVw=;
        b=Xxej2qpNBoXWSM3H44C7Ej0eQSxiJ9pMJgnB+riTVBkGAOuGbeTmcq8lOxwBywVxJJ
         Su+xF9lX+0GWOu2dy8U2zVIX7b7iQsYpwKn76wXW73F2mIwBqTIEIRXOI0e9yjI5C5IG
         zvbtND7pXEDTGYLkrt4eLrGZpOYheN/GNE1fMuUc3s4M/xcGNOc/s3Kj1Bvdfo9KUlAu
         OM/pj8Pbl6aJ/3/6XFspCeLlAXuS5bP3WElew3i4LFQc/cCnn398EmtSHAkhKNfW4Btu
         wsYl9v9PEb2Dezv+nZwHLtZCnlvFmhbq1xCdb8Ie97YwlTT4M47GxOBT2RYKjRU6uttL
         oN8Q==
Content-Disposition: inline
In-Reply-To: <20160329011203.GA8974-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-qjLDD68F18O7TbgM5vRIOg@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello, Serge.

On Mon, Mar 28, 2016 at 08:12:03PM -0500, Serge E. Hallyn wrote:
> Quoting Serge E. Hallyn (serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org):
> > One practical problem I've found with cgroup namespaces is that there
> > is no way to disambiguate between a cgroupfs mount which was done in
> > a cgroup namespace, and a bind mount of a cgroupfs directory.  So
> > whether I do
> > 
> > unshare --cgroup -- bash -c "mount -t cgroup -o freezer f /mnt; cat /proc/self/mountinfo"
> > 
> > or whether I just
> > 
> > mount --bind /sys/fs/cgroup/freezer/$(awk -F: '/freezer/ { print $3 }' /proc/self/cgroup) /mnt
> > 
> > 'mount root' field (field 3) in /proc/self/mountinfo will show the
> > same thing, the result of awk -F: '/freezer/ { print $3 }' /proc/self/cgroup.
> > 
> > This patch adds a 'nsroot=' field to cgroup mountinfo entries, so that
> > userspace can distinguish a mount made in a cgroup namespace from a bind
> > mount from a cgroup subdirectory.
> 
> no rush on the patch itself, I don't mind if i have to rewrite it from
> scratch, but I'd like to get the patch into docker/libcontainer using it,
> so can we decide on whether the syntax as shown here is ok?

Yeah, I think the syntax is fine.

Thanks.

-- 
tejun
