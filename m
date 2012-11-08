From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/9] cgroup_freezer: add ->post_create() and
 ->pre_destroy() and track online state
Date: Thu, 8 Nov 2012 09:17:42 -0800
Message-ID: <20121108171742.GJ12973@htj.dyndns.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
 <1351931915-1701-9-git-send-email-tj@kernel.org>
 <20121108132306.GH31821@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=7FWPXDMalA71f9HUOPwTZ8nPpx3lVd6aPE8SLoIYOss=;
        b=jSbREIg8909n+igy0cKT5/NWYu1ymizrjVuFD3MqF8hl5ZTEKOGV2FHvdYK3uv7XuY
         x/3xtmvGTdBPEoL+DNaliPR4/tIrV9Zr2isXCZKYwUjkmY+mY9fpOyxUPqs0s0U6cBV0
         IwF0pRS1hl0kIPl+u57dDvkVQ/ba6ymwaGSIR1wmsO0WBC2q2sHTQHHvSrMNcxNMT0vg
         dc4nDvljpooUNMIGUAKCnV+nqFXHDoaXTK9vtIAUu/Z+pxJSIiA15cwVT4F9SxwIH5wq
         4yljkYjOuwj5Ei+SX5w+iqZplZsFIx5hf0Hb4wGc+7qwLw8gN3iuiPZ+4KGz1JFHmdWH
         zRug==
Content-Disposition: inline
In-Reply-To: <20121108132306.GH31821-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Hello,

On Thu, Nov 08, 2012 at 02:23:06PM +0100, Michal Hocko wrote:
> On Sat 03-11-12 01:38:34, Tejun Heo wrote:
> > A cgroup is online and visible to iteration between ->post_create()
> > and ->pre_destroy().  This patch introduces CGROUP_FREEZER_ONLINE and
> > toggles it from the newly added freezer_post_create() and
> > freezer_pre_destroy() while holding freezer->lock such that a
> > cgroup_freezer can be reilably distinguished to be online.  This will
> > be used by full hierarchy support.
> 
> I am thinking whether freezer_pre_destroy is really needed. Once we
> reach pre_destroy then there are no tasks nor any children in the group
> so there is nobody to wake up if the group was frozen and the destroy
> callback is called after synchronize_rcu so the traversing should be
> safe.

Yeah, it might be true, but I'd still like to keep the offlining in
->pre_destroy() so that it's symmetrical w/ ->post_create().  I'll
rename and document the ops so that the roles of each are clearer.

Thanks.

-- 
tejun
