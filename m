From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
Date: Tue, 16 Oct 2012 12:34:28 -0700
Message-ID: <20121016193428.GE16166@google.com>
References: <20121008020000.GB2575@localhost> <20121008020138.GA4188@localhost>
	<507268AA.8050509@huawei.com> <20121008065752.GA5931@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=dXgMHgpqBI54HjN+qAe5W4VcW582o5FIQ0FCILnMYmo=;
	b=igQVM9WBmqLJ6SyfNSTFoL7KpGLS1KquLJTOX6EKXMqS1uFidaCcQvJXWSFGbtubmm
	S5n9TtbbJja6iDDscSPU41CxMfCBbDzyyA3e7pi1eeEWE0MZjHtswjB64+i5hyY3CLse
	gQxD6RYDNAoGulXEgr7Za7HT0qHlGNuVPV7fFuOc0aHgtE1jEXsOxY88Je66Q4qe3fP1
	WsK0evSd4GYoI6sIKw+iqegfG7VaVgHrwpp3sQ8poKi6GAxZWDT7Pwrzyzg+uoIcLEJw
	FGEjBK8m7ral2JFAvVbksFjvdp8cXTbnA+WRMgc+EhtBudiO7klPtlRousEodNzQykzO
	U0CQ==
Content-Disposition: inline
In-Reply-To: <20121008065752.GA5931@localhost>
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
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Oct 08, 2012 at 03:57:52PM +0900, Tejun Heo wrote:
> Hello, Li, Frederic.
> 
> On Mon, Oct 08, 2012 at 01:46:18PM +0800, Li Zefan wrote:
> > You're right. threadgroup lock is held unconditionally in attach_task_py_pid(),
> > but it's held only for CLONE_THREAD in fork path, which I guess I overlooked
> > when reviewing the patch.
> > 
> > > Also, please note that task_lock is likely to be hot on local CPU at
> > > that point and avoiding it there might not really buy much.
> > 
> > Reverting that commit should be fine.
> 
> There are other commits which perform similar optimization
> 
>  7e3aa30ac8 ("cgroup: Remove task_lock() from cgroup_post_fork()")
>  c84cdf75cc ("cgroup: Remove unnecessary task_lock before fetching css_set on migration")
> 
> Are they wrong too?

Frederic, Li, Ping?

Thanks.

-- 
tejun
