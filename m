From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: print pretty format in /proc/cgroups
Date: Tue, 15 Apr 2014 08:51:11 -0400
Message-ID: <20140415125111.GG1863@htj.dyndns.org>
References: <1397566065-3028-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=6clrVouoduOaPGIvcLqPv6OUE0//g7YKmpeUegmi88w=;
	b=Eh3Y4w3gcReNsQF8sWXbevlqP3wHJTM2kXd5uTJrxfwAi7Ar9C2XfSCUdgCpV01RgB
	ADYEruvx7phNzmJp5Bqboq/IVRRL1kl5WKmUkTaVusZSLImZn6QW81ifPoAwTBhffYnA
	ySMEJVsSkConnbVsa8pGMJ8yyFmkEyyvv3ncLXIrr/ua517YEcBfd//1ZiT7yf+t2o1P
	DrqJVGR07TDv6pq4vf63B+5pO+R9nIau6I2vdbjRjAdxaiffJm7RDTXaxGmnlqw8bnHW
	xBIz+RkT5hAGzruyRhOLMyOE5VSX/AZorllY7PH/r+JlDgHX9WFCHEJr6C+zmxDN7bH7
	hW1g==
Content-Disposition: inline
In-Reply-To: <1397566065-3028-1-git-send-email-nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

On Tue, Apr 15, 2014 at 08:47:45PM +0800, Jianyu Zhan wrote:
> I found that /proc/cgroups printed format has ugly alignment(see below).
> 
> This patch confines every field in fixed-width(16 actually) range.
> Though MAX_CGROUP_TYPE_NAMELEN is 32, but currently no subsystem
> has name width more than 10, so 16 is a moderate width; besides, 16
> figures could accomandate enormous huge number, so no need to worry
> that these fields would clobber each other.

The problem there is that there could be programs / scripts parsing it
assuming single tab between entries.  It surely is ugly but do we
care?

Thanks.

-- 
tejun
