From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup
	removal optional
Date: Fri, 18 May 2012 10:55:48 -0700
Message-ID: <20120518175548.GM19388@google.com>
References: <20120330223423.GJ28934@google.com>
	<20120330223606.GK28934@google.com> <4F77B6BA.4070207@huawei.com>
	<20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
	<CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=FPRBHtjjcf7Uxkh2ST5lnZ8KB0j5I9yGi9KIjAmUG4E=;
	b=Yd+NW3h71Vs3fyTvZmVbK9QITxq5mJf/UC5zGEK2Xh4BHDp4ULk2cS/N34cp0YVVXQ
	F99UaYjodgRcAfiKDqFsO638m0WSQbMX5G9xMSDxvbWLeBjNUH9WK6WwnP5tsPRXkW86
	ztjuYtztcuPuEiERs8IIVSLu2kOXsafOUYMbdcCtDQgazbXk6vMVcMGjx03SsSwTZ0m2
	0A9I9KrVUslDRYGcUlgUqdhOBY0Q2IRSku9/4CXLaC9vkOizJL92Fj66owIsNAnGEkG7
	T8DTsmIVl0p10rHOsl5A1M89aS5UheD3fDm3vLUGxH5HoYjAYb1d4auJzVuGFTp3AF+p
	ychw==
Content-Disposition: inline
In-Reply-To: <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, May 17, 2012 at 12:33:05AM +0200, Sasha Levin wrote:
> Hi Tejun,
> 
> On Sun, Apr 1, 2012 at 8:54 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > Hello, Li.
> >
> > On Sun, Apr 01, 2012 at 10:00:26AM +0800, Li Zefan wrote:
> >> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >>
> >> Both patches look good.
> >>
> >> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> >
> > Alright, adding the patches to cgroup/for-3.5.
> 
> This patch allows for race when removing a cgroup since one of the
> css's may still have a dentry ref when the cgroup is removed, no? Is
> there a plan to deal with that before this patch gets pushed into 3.5?

Can you please elaborate?

Thanks.

-- 
tejun
