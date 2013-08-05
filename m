From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/5] cgroup: export __cgroup_from_dentry() and
 __cgroup_dput()
Date: Mon, 5 Aug 2013 11:40:16 -0400
Message-ID: <20130805154016.GE19631@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <1375632446-2581-3-git-send-email-tj@kernel.org>
 <51FF14C5.4040003@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=t96jMq4jwdB+Mz3XOlm2QIqNIVaH1WzAn1vqIkTaBiM=;
        b=LHnunHiVcagY8z+ZV+ilsB8kFmOXgNtrZV7aitKLMwZ5VNO/5GhUh8lql85rARNdWz
         LRxPw8GmaeMi4IilMxk3QzEzlJ8kY1sdc2b51ftBaytlh1SYfcX3YqkkfqEBenXb+xJ8
         FPCmqkuuR6OI30I923jzfUBK94GYqW0ESek8UlE6WRK5unYqOnrJLK0dykOQXXTP9Q7h
         wGKXmjCKyYfoQ/ER9akD2RQpHO6q2nxywYvJCU9yjSmoGTqrYIVaC45AuCmsnaM4b8Ng
         jlRizwllif6XzFseFjhQl9p6enSYCi6S2T6XJTi42M/Od374FhaOWZdbcJBu5wopudv1
         Pmjg==
Content-Disposition: inline
In-Reply-To: <51FF14C5.4040003-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 05, 2013 at 10:58:13AM +0800, Li Zefan wrote:
> > +struct cgroup *__cgroup_from_dentry(struct dentry *dentry, struct cftype **cftp)
> >  {
> > -	if (file_inode(file)->i_fop != &cgroup_file_operations)
> > -		return ERR_PTR(-EINVAL);
> > -	return __d_cft(file->f_dentry);
> > +	if (!dentry->d_inode ||
> > +	    dentry->d_inode->i_op != &cgroup_file_inode_operations)
> > +		return NULL;
> > +
> > +	if (cftp)
> > +		*cftp = __d_cft(dentry);
> > +	return __d_cgrp(dentry->d_parent);
> >  }
> > +EXPORT_SYMBOL_GPL(__cgroup_from_dentry);
> 
> As we don't expect new users, why export this symbol? memcg can't be
> built as a module.

Yeah, I for some reason was thinking memcg could be bulit as module.
Brainfart.  Dropped.

Thanks.

-- 
tejun
