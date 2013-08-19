From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.12 1/2] cgroup: fix subsystem file accesses
 on the root cgroup
Date: Mon, 19 Aug 2013 09:57:39 -0400
Message-ID: <20130819135739.GD6176@htj.dyndns.org>
References: <20130815154236.GG14606@htj.dyndns.org>
 <521181AD.7090700@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1RYBTuimt0rq+P7kHXw3md4+kTicI+nt8E4cmFCLKzQ=;
        b=JXMvhSt1xMq22m1qQizMei7t0gdfV8i4x6fL/RRL5JcjPZcA2teBtC8EKP0aTwn03Q
         NM9LtxebmQmqfA7n97S5usN0Z7udldTXm3X3VSkb+QOSsW0MMikgk0vkcaAEnDHqF5Kx
         7dHbQ5J105CmfXyBaKzMShjV7GP8Zq1OoF2sxVxqXFefDp9Un5yYbEa/YHeoCbCCr9Us
         lDl+TAzBj/Qy44tCWaRyed+XC2XCrSjoTK9FPspk3s/S8/MK5SqegQfj7zJe1WjMjNnE
         3w7QZsjsvF5y4GvLc6uRPVRSSdsLAhtTNUkx+yVpIYeJND/YEZbz9Bc//P3veswwqTbg
         DZPQ==
Content-Disposition: inline
In-Reply-To: <521181AD.7090700-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 19, 2013 at 10:23:41AM +0800, Li Zefan wrote:
> > 105347ba5 ("cgroup: make cgroup_file_open() rcu_read_lock() around
> > cgroup_css() and add cfent->css") added cfent->css to cache the
> > associted cgroup_subsys_state across file operations.
> > 
> > A cfent is associated with single css throughout its lifetime and the
> > origimal commit initialized the cache pointer during cgroup_add_file()
> > and verified that it matches the actual one in cgroup_file_open().
> > While this works fine for !root cgroups, it's broken for root cgroups
> > as files in a root cgroup are created before the css's are associated
> > with the cgroup and thus cgroup_css() call in cgroup_add_file()
> > returns NULL associating all cfents in the root cgroup with NULL css.
> > This makes cgroup_file_open() trigger WARN and fail with -ENODEV for
> > all !core subsystem files in the root cgroups.
> > 
> > There's no reason to initialize cfent->css separately from
> > cgroup_add_file().  As the association never changes,
> > cgroup_file_open() can set it unconditionally every time and
> > containing the logic in cgroup_file_open() makes more sense anyway as
> > the only reason it's necessary is file->private_data being already
> > occupied.
> > 
> > Fix it by setting cfent->css unconditionally from cgroup_file_open().
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
