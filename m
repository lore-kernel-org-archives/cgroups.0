From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] cgroup: convert from per-cgroup id to per-subsys id
Date: Tue, 22 Apr 2014 16:36:32 -0400
Message-ID: <20140422203632.GF2314@mtj.dyndns.org>
References: <cover.1398147734.git.nasa4836@gmail.com>
	<f478e92038bfbc1da2d03082641804e8acfdfad3.1398153537.git.nasa4836@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=6bVj6mQDl4RPMM/qGGAc+8UiXf5htU6KT7nupMhx7J0=;
	b=SYo+hhEVZQsAEK60P+wzOsxGHw0DY4J6dHHfAdTXvqSBxFrZRNJa6UR6Iqy3quxrIS
	aCenTm89UpobspIqa7MVrl/4f1tlw/VTZCpLvzEXpUNCpCILpxnCSexjkbJxwU7sRwMK
	QsAqclGHSZJLh4A2l1G4plBl+FLdrd41By2Hnbvrn5O15A4xodKgpawBjJ1bC9Xb75g4
	/EyTlKLim8u006XXQx/8tlo1AMYdeqvDVHsfbljAvrqRAowt9gpxpuUTpomipVUvQbMD
	/0ahTqlAaeG95xnLTglsVIYHND8s+8C3VK99qZ+g2Mvl2jwzcCNKtGnuiXkG6NjiNYAq
	bFpQ==
Content-Disposition: inline
In-Reply-To: <f478e92038bfbc1da2d03082641804e8acfdfad3.1398153537.git.nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
To: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 22, 2014 at 04:03:31PM +0800, Jianyu Zhan wrote:
> Hi, all.
> 
> Sorry, previous patch has a minor fault, and cause a unitialized variable warning.
> I've fixed it up in this.
> 
> Renewed patch:
> ---
> 
> Currently, cgrp->id is only used to look up css's.  As cgroup and
> css's lifetimes is now decoupled, it should be made per-subsystem
> and moved to css->css_id so that lookups are successful until the
> target css is released.

So, css ID can't replace cgroup ID as whole.  It's just that there are
cases where we're currently using cgroup IDs where we should be using
css IDs.  Also, we need to update css creation error path RCU safe so
that idr lookup is always RCU safe.  I already had patches queued for
posting.  Will post them soon.

Thanks.

-- 
tejun
