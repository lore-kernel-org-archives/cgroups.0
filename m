From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] nfs: include xattr.h from fs/nfs/nfs3proc.c
Date: Mon, 3 Feb 2014 15:45:00 -0500
Message-ID: <20140203204500.GJ30250@htj.dyndns.org>
References: <20140203193107.GH30250@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=orDI5Ra91YMLIwPAdiqGsc55JAl4i3UgNsdTfcbWLVA=;
        b=gt+d3AEXWnHQyNm4Zn6R53wkaKAbY9FYhYFrBG+/U6CMGVrXEIPsobmXtGFSWObqMb
         qvgl4q7n4ewuOkM2pBUJr53yFIvdzGP2a206oriAUi6ytZMdqhgpjcA4mbsyZYAXJO3l
         LR7/RREarmSP2pvD9ml/2t2fUQwPi8la4SDaiSJwNKcH9GrCv09r2E/r5Ab2VyZsjqkj
         DX4VJfihp4i1JjFVM08AIsPgwUklVgcMtUcj1l9MW5vXBRc3890Tuj+a4XbvRKnWu1nr
         Y9ej4AxakQxWcxUB1+j6EknOqXO3eKxaThdhKoP9nzRpF/a4qvDhW5+zrJXyVa2sfgRf
         2rPg==
Content-Disposition: inline
In-Reply-To: <20140203193107.GH30250-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

On Mon, Feb 03, 2014 at 02:31:07PM -0500, Tejun Heo wrote:
> fs/nfs/nfs3proc.c is making use of xattr but was getting linux/xattr.h
> indirectly through linux/cgroup.h, which will soon drop the inclusion
> of xattr.h.  Explicitly include linux/xattr.h from nfs3proc.c so that
> compilation doesn't fail when linux/cgroup.h drops linux/xattr.h.
> 
> As the following cgroup changes will depend on these changes, it
> probably would be easier to route this through cgroup branch.  Would
> that be okay?
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
> Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Applied to cgroup/for-3.14-fixes w/ Trond's ack added.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
