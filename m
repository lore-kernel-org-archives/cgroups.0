From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/8] cgroup: use cgroup_lock_live_group(parent) in
 cgroup_create()
Date: Wed, 31 Oct 2012 10:04:31 -0700
Message-ID: <20121031170431.GF2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-4-git-send-email-tj@kernel.org>
 <20121031155514.GD22809@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=a0TZ+3vmb96pP+6ucrqVzmhcRGUIRvc94rgssRz0qcI=;
        b=bCaqTbKNsNOoLMAUadUnoi7br3whdj9SM1zM/+xpl1C58LZSKFPKWEYfJq43mh3nGx
         ekQsWeXz98FbRme+uf3uDuO6H/1WHlNwNsU3jQ0wSDDEaeblSSCeimqsOv+3YMojFmeJ
         OcMLAzTTjtpV7j60wtta1M3NzNXE/lPYE+PkbpndGhutI2KUWjJNFbA8c8b6l7W+KPbp
         m87pARXeXPf+jyb6xjwgxT0EPTntg4oa6d5B4dSEWoLR758RZqkiO70LS+tYoahitIh8
         ivH09MPfcVcOx67LjdBxXKAMUZH5P5Yw3oDrCk6xv4yEFoDDVfI9rIEdmD81d7KHYwWE
         YFHg==
Content-Disposition: inline
In-Reply-To: <20121031155514.GD22809-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Michal.

On Wed, Oct 31, 2012 at 04:55:14PM +0100, Michal Hocko wrote:
> > +	/*
> > +	 * Only live parents can have children.  Note that the liveliness
> > +	 * check isn't strictly necessary because cgroup_mkdir() and
> > +	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
> > +	 * anyway so that locking is contained inside cgroup proper and we
> > +	 * don't get nasty surprises if we ever grow another caller.
> > +	 */
> > +	if (!cgroup_lock_live_group(parent)) {
> > +		err = -ENODEV;
> > +		goto err_free;
> > +	}
> > +
> 
> I think this should be moved up before we try to allocate any memory.
> Or is your motivation to keep cgroup_lock held for shorter time?
> I could agree with that but a small comment would be helpful.

Then I have to change the error out path more and I'm not sure I wanna
call deactivate_super() under cgroup_mutex.  It's just simpler this
way.

Thanks.

-- 
tejun
