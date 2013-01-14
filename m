From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] cgroup: remove synchronize_rcu() from
 cgroup_attach_{task|proc}()
Date: Mon, 14 Jan 2013 10:42:36 -0800
Message-ID: <20130114184236.GF27942@mtj.dyndns.org>
References: <50F3CE8E.5000402@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=ozOXR6bC8jR5SeLr8f5KXI1za5Tlg9qzID2ru/IdbZI=;
        b=ZbCGsxp/AYsLTwOPIIQGlNRIreu8p3/AcyralWi6xquYYkDAHxCmOiEzcME/48iIbn
         U5OwR8cWNuOmRvK+sTJOTABCKZKtCq9KqMe+NlmxoyFKEzmXDI6n45yEpDFzxGExzhRu
         u0KTreGMjkauNRgKGw8C+HxEcEjvvInfI8hCnCvsUYvxComHaBAIugoEI5EBGsYOPJ4F
         vvw2+70s2LA+U+qhrb9OFZpV4v7E1bVU9Y2JvDYtwjjadD/C5fxbQeYMo9EQkoBDhgbJ
         9wCGUVgJGsTS+jKLIIN7UhF607Hf3xM8jBe5pHgOHSKD3RjLIsnEECu3M674EkQmBJg5
         79ow==
Content-Disposition: inline
In-Reply-To: <50F3CE8E.5000402-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Colin Cross <ccross-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hey, Li.

On Mon, Jan 14, 2013 at 05:23:26PM +0800, Li Zefan wrote:
> These 2 syncronize_rcu()s make attaching a task to a cgroup
> quite slow, and it can't be ignored in some situations.
> 
> A real case from Colin Cross: Android uses cgroups heavily to
> manage thread priorities, putting threads in a background group
> with reduced cpu.shares when they are not visible to the user,
> and in a foreground group when they are. Some RPCs from foreground
> threads to background threads will temporarily move the background
> thread into the foreground group for the duration of the RPC.
> This results in many calls to cgroup_attach_task.
> 
> In cgroup_attach_task() it's task->cgroups that is protected by RCU,
> and put_css_set() calls kfree_rcu() to free it.
> 
> If we remove this synchronize_rcu(), there can be threads in RCU-read
> sections accessing their old cgroup via current->cgroups with
> concurrent rmdir operation, but this is safe.

Yeah, these synchronize_rcu()s are utterly confused.
synchornize_rcu() necessarily have to come between two operations to
guarantee that the changes made before it are visible to all rcu
readers before proceeding beyond it.  Here, synchornize_rcu() are at
the end of attach operations with nothing beyond it.  Duh.... its only
effect would be delaying completion of write(2) to sysfs tasks/procs
files until all rcu readers see the change, which is utterly
irrelevant.  It doesn't mean anything.

Applying to cgroup/for-3.9.

Thanks.

-- 
tejun
