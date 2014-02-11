From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: convert to kernfs
Date: Tue, 11 Feb 2014 11:57:38 -0500
Message-ID: <20140211165738.GG24490@htj.dyndns.org>
References: <1390953285-16360-1-git-send-email-tj@kernel.org>
	<52F9EC39.40504@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=q4cRp+e3ZnIqlHbWTGFYJUByEUy3yZGXFFwhTwcWEec=;
	b=Q5RKloQ7hKaFwTWHlC9wSl10E55GEssC9osTv6QAu4cmPIQMl2R/d5qKbpu8EWx52w
	iG+elRNEa5kJWdfixrng9d6Z6AHNRmG+mip82It1qK6i/stuyAbktsbp1yHhgmI2x8Yg
	2HBxXVPN4ZZBK3aNcpmealuqUiuc4UX+YJxeFKrjoSbvCfNyo8UTI4oojs0AlvPL6s6K
	C2ywsxqJECtQSpYkuvgTWs65OVtNnsjheBiBjub3mxJZAsLu/zK7jk759zys+oPei636
	b7ErIoqis8PVQgRZpd6LF6hTJGVT+2vdQwyIhn4Laa7YtG8wc0MKihyN9CJiU411cN/Z
	UuRw==
Content-Disposition: inline
In-Reply-To: <52F9EC39.40504-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 11, 2014 at 05:24:09PM +0800, Li Zefan wrote:
> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Updated the patches so that they apply on top of the idr locking fix
and applied the series to cgroup/for-3.15.

Thanks!

-- 
tejun
