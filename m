From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: lockdep trace from prepare_bprm_creds
Date: Thu, 7 Mar 2013 10:21:40 -0800
Message-ID: <20130307182140.GF29601@htj.dyndns.org>
References: <20130306223657.GA7392@redhat.com>
 <20130307172545.GA10353@redhat.com>
 <20130307180139.GD29601@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=/FOamfGbp37OxwPWDX8xf0MX+Lf3LN0T//EQIU+Vevc=;
        b=Q+MKa1YRCKDbxJSc6cR8R/7tRatA4u7NagBtH5oEHcTBqsLHWYJwFdoSaWqpt4SLbm
         ovu8mHhbm7M+4hGn1F2uIdPg+8a087oTRoYXfA9NGD/Vyn32GoHYXXbCvX+aIVczGvwu
         V4RIy0dVwSOnlIhbCFSAalGeAwsONaZLVgWfSnXB9FSwxwJE9eoKF//CJl2ErbwQcxix
         SIUYlju9VBdKJq6nEB36O37+bPF/jr3ODGSQC0+JAO5kZzMyn8O2ucN4mcGAcrqYqA32
         bH/AZW0BxWGvrCvT4fXnvIJQz+9o29HXZthehN3k/X/TSFvzlqXDRSgg+EzxQHVIWFRT
         fAbQ==
Content-Disposition: inline
In-Reply-To: <20130307180139.GD29601-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Mar 07, 2013 at 10:01:39AM -0800, Tejun Heo wrote:
> Hello, Oleg.
> 
> On Thu, Mar 07, 2013 at 06:25:45PM +0100, Oleg Nesterov wrote:
> > > [  944.011126] Chain exists of:
> > >   &sb->s_type->i_mutex_key#9 --> cgroup_mutex --> &sig->cred_guard_mutex
> > >
> > > [  944.012745]  Possible unsafe locking scenario:
> > >
> > > [  944.013617]        CPU0                    CPU1
> > > [  944.014280]        ----                    ----
> > > [  944.014942]   lock(&sig->cred_guard_mutex);
> > > [  944.021332]                                lock(cgroup_mutex);
> > > [  944.028094]                                lock(&sig->cred_guard_mutex);
> > > [  944.035007]   lock(&sb->s_type->i_mutex_key#9);
> > > [  944.041602]
> > 
> > And cgroup_mount() does i_mutex -> cgroup_mutex...
> 
> Hmmm...
> 
> > Add cc's. I do not think we can move open_exec() outside of cred_guard_mutex.
> > We can change do_execve_common(), but binfmt->load_binary() does open() too.
> > 
> > And it is not easy to avoid ->cred_guard_mutex in threadgroup_lock(), we can't
> > change de_thread() to do threadgroup_change_begin/end...
> > 
> > Or perhaps we can? It doesn't need to sleep under ->group_rwsem, we only
> > need it around ->group_leader changing. Otherwise cgroup_attach_proc()
> > can rely on do_exit()->threadgroup_change_begin() ?
> 
> Using cred_guard_mutex was mostly to avoid adding another locking in
> de_thread() path as it already had one.  We can add group_rwsem
> locking deeper inside and avoid this problem.
> 
> > But perhaps someone can suggest another fix in cgroup.c.
> 
> Another possibility is moving cgroup_lock outside threadgroup_lock(),
> which was impossible before because of cgroup_lock abuses in specific
> controller implementations but most of that have been updated and we
> should now be pretty close to being able to make cgroup_lock outer to
> most other locks.  Appending a completely untested patch below.

This probably doesn't help as the dependency involves i_mutex.  I
think Oleg's proposed patch should work.

Thanks.

-- 
tejun
