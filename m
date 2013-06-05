From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 06/10] cpuset: record old_mems_allowed in struct cpuset
Date: Wed, 5 Jun 2013 12:45:22 -0700
Message-ID: <20130605194522.GG10693@mtj.dyndns.org>
References: <51AF0183.8070602@huawei.com>
 <51AF01E8.8080205@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=DUd27EILgV9EGma4PzT464RV96zW19HN9eZ0M+RSe+4=;
	b=bfAPK+QqwUGYodKk/fGxT3QctlBoFtUhLUY4+5gSuVAiiElpTL6N1J0hf50VJvhxTA
	kSKlUExY/cd9w1/GkReRKP4weab1g2aMPG1OUZYe+fy7N6NexcTfdzRkqRSbU3Zw6Lb3
	bc6T9gMtELRLfBp4uDlhcFwA1744SX1kJGsCswLbaMY7XmHJhoWk3m3g/yn+VyGDDmAT
	eh9/P9E0g527EYHRhZW8PLoLRX16ZkD0OPUR/POG2d35ak9++qvfR+dIKpZU0Af7SJ8/
	H/1CgwQJlcDUJ8Mo75KhOVh11DO441wpZBuFDC5jPH0YGVS/vbLJ33NHE0Owhm8rNv0D
	U30g==
Content-Disposition: inline
In-Reply-To: <51AF01E8.8080205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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

Hello, Li.

On Wed, Jun 05, 2013 at 05:16:24PM +0800, Li Zefan wrote:
> @@ -1425,7 +1435,6 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
>  	 * Change mm, possibly for multiple threads in a threadgroup. This is
>  	 * expensive and may sleep.
>  	 */
> -	cpuset_attach_nodemask_to = cs->mems_allowed;
>  	mm = get_task_mm(leader);
>  	if (mm) {
>  		mpol_rebind_mm(mm, &cpuset_attach_nodemask_to);

This looks a bit suspicious to me.  Now we're setting mm's nodemask to
guarantee_online_mems() output rather than cs->mems_allowed.  Is this
change intended?  If so, it probably deserves an explanation in the
description?

Thanks.

-- 
tejun
