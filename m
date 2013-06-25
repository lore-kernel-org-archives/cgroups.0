From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.11 2/3] cgroup: fix RCU accesses around
	task->cgroups
Date: Tue, 25 Jun 2013 11:50:07 -0700
Message-ID: <20130625185007.GD20051@mtj.dyndns.org>
References: <20130621225116.GC3949@htj.dyndns.org>
	<20130621225204.GD3949@htj.dyndns.org>
	<51C8FA3E.9020104@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=ceG14aR/jPS6QW/1cWvYwZwW0GlRfp37x9j0x3koO3o=;
	b=RWuv3Svosu81br5zV9ZgU+WrZkK+QNVCeDcWC253wYU6RtEgpphyqTfGWx3kWfH4Hq
	is+5HO0MxvT66yc5NAdUp5xl3vILBN4NdwaV/Qvm1neTuM5xKdFBslOsvklF1o8E2deT
	71mbZzSirYHxFuGK0J7CoVhboRiKp47da/SVobdk6fEiv6i5ugJXxtkiZ0siZwzI+7M8
	HhVXYV7e1K0t0X+XcENGlITaP1YPsh4chKnEvUygU+C8swVElCkotXApwrFpk6a4PsPP
	/dpl8DEE/mlFwhZYDasbz8LEmdUxxb6F66yki/7gpv/k9tuMbMjD5oNYwDoOD3WTOJWQ
	/meg==
Content-Disposition: inline
In-Reply-To: <51C8FA3E.9020104-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <theo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Tue, Jun 25, 2013 at 10:02:38AM +0800, Li Zefan wrote:
> > @@ -5046,8 +5049,8 @@ static const struct file_operations proc
> >  void cgroup_fork(struct task_struct *child)
> >  {
> >  	task_lock(current);
> > +	get_css_set(task_css_set(current));
> >  	child->cgroups = current->cgroups;
> 
> While we use RCU_INIT_POINTER() in cgroup_exit(), we don't need to use it here?

Yeap, because both are RCU pointers.  There's no cross (sparse)
address space assignment going on.

Thanks.

-- 
tejun
