From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] cgroup: mount cgroupns-root when inside non-init
 cgroupns
Date: Mon, 30 Nov 2015 10:09:38 -0500
Message-ID: <20151130150938.GF3535@mtj.duckdns.org>
References: <1447703505-29672-1-git-send-email-serge@hallyn.com>
 <1447703505-29672-8-git-send-email-serge@hallyn.com>
 <20151124171610.GS17033@mtj.duckdns.org>
 <20151127051745.GA24521@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vrM0QXNX/vGDUsvRwY2w0v0clmyQy46RE7eTeTK+dEk=;
        b=Hr76qPp2FlKkLch5lYfqr4TJCzjXcDHoBS5JcMJO5CmrHBxovyuY/Ztrn2ycTuqQ3W
         1RY8fXDP/GbE8KpYgd55+8BO36y9bj1zY3cjN4bFoPM0oSDyfHAIqrtKuWaLU4FhGHnJ
         gF9rmSBoDrcOReqP1sLHIuplFsbYJ5i0CufzGHTG5EHlB7uz58GoWztlb8YpmZvjgrMd
         yuSbcSbsCsMcFIlyBvfYQlmC6MgTWJgFF0ilr5vYrWQgkjeV8A8AJ6MUR5icLnx4JmZZ
         9OZArPbF3/XTwIYbb85/nGXJigdcg301kr9KP4sBXxu6kdnZPpEMVYNj9mKZNo1LASPk
         1WBQ==
Content-Disposition: inline
In-Reply-To: <20151127051745.GA24521-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lxc-devel-cunTk1MwBs9qMoObBWhMNEqPaTDuhLve2LY78lusg7I@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org

Hello, Serge.

On Thu, Nov 26, 2015 at 11:17:45PM -0600, Serge E. Hallyn wrote:
> > Wouldn't it be simpler to walk dentry from kernfs root than
> > duplicating dentry instantiation?
> 
> Sorry I don't think I'm following.  Are you suggesting walking the
> kn->parent chain backward and doing d_lookup() at each point starting
> with sb->s_root?

Yeah, something like that.  I wonder whether there are already code
paths doing that.  What we need is a straight path walk.  I could be
wrong but it shouldn't be that complex and if it works out we can
avoid introducing another instantiation / lookup path.

Thanks.

-- 
tejun
