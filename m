From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/10] cpuset: re-structure update_cpumask() a bit
Date: Wed, 5 Jun 2013 13:57:21 -0700
Message-ID: <20130605205721.GJ10693@mtj.dyndns.org>
References: <51AF0183.8070602@huawei.com>
 <51AF01CF.1070706@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=lPVEbN5gg7V2N3psqUZqC8/edCT7IQwIy/9e0GuVk54=;
	b=m8dk7IZPIZI2A+LSIOLJxxKIYEfbEKSanMbStcLOEkoWsmYWiva2ZhMKVPdSIyIsi0
	1feIc1OXRLfV9pe54crk2kju9IuecMyG5irPdxX1Q34xbw0oH66cVkKMMAp9ZUCIoaT8
	Bn/A8FqnT7xsSRjOY8RAYqrV/vkRkPwIY+r0T1bPv/a1VGgxq924MRm21sSOvXpyCebV
	0g+WY21LYSYFV7nJVx7prElBqDGGCepLGMi7jnplYnloNrAbsxZmO3m0nQKbpUyW6bbf
	NjGR3GDP7Pgxy+d6le+L5f9zgU8+N6QU5t5wNQaeT8v6tYgRI4WluH9yzwUawWbkbPib
	CKvw==
Content-Disposition: inline
In-Reply-To: <51AF01CF.1070706-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jun 05, 2013 at 05:15:59PM +0800, Li Zefan wrote:
> Check if cpus_allowed is to be changed before calling validate_change().
> 
> This won't change any behavior, but later it will allow us to do this:
> 
>  # mkdir /cpuset/child
>  # echo $$ > /cpuset/child/tasks	/* empty cpuset */
>  # echo > /cpuset/child/cpuset.cpus	/* do nothing, won't fail */
> 
> Without this patch, the last operation will fail.
> 
> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-5 to cgroup/for-3.11-cpuset.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.11-cpuset

Thanks.

-- 
tejun
