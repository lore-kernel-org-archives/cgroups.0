From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH ] cgroup: rename cont to cgrp
Date: Wed, 19 Jun 2013 01:23:47 -0700
Message-ID: <20130619082347.GE30681@mtj.dyndns.org>
References: <51BA8B3F.3060606@huawei.com>
 <51C109DE.8010607@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=JMKq6PJi1eNX0RAG7kgG07YXMx84zvYuq+nCEPxkARk=;
	b=VGFi5PouVbB6WkNo6AOp8kU2xu0iF7hpHsmiVoJ6sWk1J5K3H2WovtcvdIegbeZXaC
	qhLpk6aUuIhdF9Ek+nugGQR9NOPdn4G/ygS913/dA5Vo72Nqthfp172ZpuNxx54jWqt3
	UcmD5LOVyC3JnuR6NyJRX9o5w0+qKwt6DDs5zZ31c4jbflMkOnL2EUv4rLvw0ElJM2j5
	tYKgRMwizcmjA/0erIRz10dIVKIYeb2F6iCYnPs8Z0riMd2DIzTaaVE4vx8HcU1n375s
	6kcFX0Xn3AqqGBccgBjtb3u0T49e15xdT70EV2BHsnsVZ9sCheJnOtX4UBAJM8aZ0MUw
	CtZQ==
Content-Disposition: inline
In-Reply-To: <51C109DE.8010607-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

On Wed, Jun 19, 2013 at 09:31:10AM +0800, Li Zefan wrote:
> Hi Tejun,
> 
> Could you apply this patch?

Oops, I thought I applied this one.  Apparently not.

> On 2013/6/14 11:17, Li Zefan wrote:
> > Cont is short for container. control group was named process container
> > at first, but then people found container already has a meaning in
> > linux kernel.
> > 
> > Clean up the leftover variable name @cont.
> > 
> > Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.11.

Thanks.

-- 
tejun
