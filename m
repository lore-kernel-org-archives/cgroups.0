From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] cgroup: implement task_cgroup_path_from_hierarchy()
Date: Sun, 14 Apr 2013 20:48:25 -0700
Message-ID: <20130415034825.GL3050@htj.dyndns.org>
References: <1365964619-14762-1-git-send-email-tj@kernel.org>
 <1365964619-14762-5-git-send-email-tj@kernel.org>
 <516B7753.9060503@huawei.com>
 <20130415034613.GK3050@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=39Pafr7UH0pVagPZKO8RJe6EcwqtYTSM7H3Pl1Z1LlQ=;
        b=awKpHapqb4ef7uMv8VyzLYwE93Up+NUVudSOiPFNyoo8zBomHl44uKSE7MB6I4sfIo
         lkXTdLn3EThFhOWUJeK/jId/3UJoiTCI/6J3vdnn9Msus65fH3EcMXa+hcelGxzp/CB9
         G0vNA0dEeiQF+LkH/5EUbPyntGgsPaouFL5f772f1iomvFA7/cOIyFs6BK/DRPHUTpWL
         1R7uXT3akbtUss3wp9iFJvuhKUjDYNatQm0lkze0jD14C1x6hvCTIYi4PcwvDDDOUV1V
         3V14hmPGwecFNVyi8T25oe3f/ArtkrgogMzHHt4Q/wQr+o/ELf9l5G49IhcfHPDWruUH
         kfsA==
Content-Disposition: inline
In-Reply-To: <20130415034613.GK3050-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kay-tD+1rO4QERM@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org

On Sun, Apr 14, 2013 at 08:46:13PM -0700, Tejun Heo wrote:
> On Mon, Apr 15, 2013 at 11:43:15AM +0800, Li Zefan wrote:
> > > +int task_cgroup_path_from_hierarchy(struct task_struct *task, int hierarchy_id,
> > > +				    char *buf, size_t buflen)
> > > +{
> > > +	struct cgroupfs_root *root;
> > > +	struct cgroup *cgrp = NULL;
> > > +	int ret = -ENOENT;
> > > +
> > > +	mutex_lock(&cgroup_mutex);
> > > +
> > > +	root = idr_find(&cgroup_hierarchy_idr, hierarchy_id);
> > > +	if (root) {
> > > +		cgrp = task_cgroup_from_root(task, root);
> > 
> > task_cgroup_from_root() will never return NULL, and there's a BUG_ON(!res) in it.
> 
> @hierarchy_id may come from userland, so we probably should update
> task_cgroup_from_root() to return NULL if the id is invalid.  Will add
> a patch.

For some reason, I thought you were talking about hierarchy lookup.
Yeap, task_cgroup_from_root() can't be NULL for a valid hierarchy.
Will drop the if.

-- 
tejun
