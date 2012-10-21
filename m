From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/7] cgroup: cgroup_subsys->fork() should be called after
 the task is added to css_set
Date: Sun, 21 Oct 2012 12:22:22 -0700
Message-ID: <20121021192222.GB5951@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-2-git-send-email-tj@kernel.org>
 <20121021191141.GA26218@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=lseV9BY291gRktRHo2n6b8P+YlqMlsvxW/IJzH1nTNw=;
        b=SZJ8tkeT+j/XMqYzyor1Q0xlctQjaDLAvkBVCCn0wrUh83lvS7Hoaq6hEBW/l7wCAQ
         qFB1RCDBLMacNBfq0XUONxoL1pytiIO8IlrumrunxvXFCQehPCsr0dTu8FwJveIikrOk
         w9t7OJ7YM2m0Zgrw4Q9LlUWWjuadgbI8BVc1kYCHp2GDMOFVS0YcuvkzkWRyNMEC+NhX
         +EVI2QuBVO4BZcu8bq6K3LsodkKVy1x0GJ9u+NQAEy3S9N2YvFtpQ9Ts8hovq/GgvW2X
         SnZ4shqq8bwNiOfrS2eV9GlqfG+LftUuLxxrafFpI4rehY05uRE8+WI5gOAX61ol1PTp
         ioCQ==
Content-Disposition: inline
In-Reply-To: <20121021191141.GA26218-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Oleg.

On Sun, Oct 21, 2012 at 09:11:41PM +0200, Oleg Nesterov wrote:
> A couple of off-topic questions. With or without this patch I do not
> understand cgroup_fork,
> 
> 	/*
> 	 * We don't need to task_lock() current because current->cgroups
> 	 * can't be changed concurrently here. The parent obviously hasn't
> 	 * exited and called cgroup_exit(), and we are synchronized against
> 	 * cgroup migration through threadgroup_change_begin().
> 	 */
> 	child->cgroups = current->cgroups;
> 	get_css_set(child->cgroups);
> 
> How so? threadgroup_change_begin() is only called if CLONE_THREAD.
> So in theory this copy + atomic_add looks racy...

It's a bug.  Revert patches to restore task_lock() are already queued
in cgroup/for-3.7-fixes.

> And it seems that fork() can race with cgroup iterator. post_fork
> will notice use_task_css_set_links, but until then the child belongs
> to the parent's css and it is not "visible" to iterator (and right
> after cgroup_fork() it is not visible to do_each_thread() if
> use_task_css_set_links is not set).
> 
> For example. Suppose that the child migrates to another cgroup after
> copy_process() makes it visible to the user-space. Then update_if_frozen
> sets CGROUP_FROZEN (again, cgroup_iter_next do not see this child).
> 
> Now, post_fork calls freezer_fork() and hits BUG_ON(CGROUP_FROZEN).
> 
> But again, I do not blame this patch.

I'm planning to update it to,

* Clear ->cgroup to %NULL during copy_process().  A new task isn't
  considered to be cgroup-wise active at this point.  Userland is not
  allowed to migrate it and none of cgroup callbacks will be called.

* Do all the initialization in post_fork so that a task is only allowd
  to be migrated and operated on cgroup-wise after ->fork() is
  complete.

> I am starting to think again about a big-rw-lock around copy_process.
> Recently I tried to add one around dup_mmap for uprobes, but perhaps
> cgroups can use it too...

If some other subsystems need it, maybe just make threadgroup locking
coarser?  I *think* I can make cgroup work correctly without a agiant
rwlock there but if someone else needs it we can definitely hitch.

Thanks.

--
tejun
