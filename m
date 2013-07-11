From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [OFFLIST] status of devcg
Date: Thu, 11 Jul 2013 08:51:06 -0700
Message-ID: <20130711155106.GB9229@mtj.dyndns.org>
References: <20130710184655.GB16979@mtj.dyndns.org>
	<20130710195001.GW14011@redhat.com>
	<20130711093405.GC2377@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=7A5JHL1mKZXVDCFwFZher/3eFNCLEeTVihyCFvIk3eY=;
	b=h1jU74FYiNY0C1naXmbRjrorScJdn3FZFV5kcC5s7SXOhG/Spy5r4cA8xf8ViDzC/E
	v9Wzg/CBu8wkmAv2ImnXs1WkqfNNJZQkN0pJxvhUOwCZYnbpnkV+Izmxi2U2MClj8qbB
	cypP9V5JVsVOe7TTXflc92g+NmGXrwsLp3W1SnKwsbKEakjJlFzHGJUK4eBghQcVSXuN
	CdZDMB+YvG41KMYmwK0ynhC+VZHznrm/Rhs6Ewfz+8BwbPwxE9zs2cSRwp/0fE4xzXx2
	rgTCd06OWgcmLzTHHiqVkE61oG+0wWi8NSE/XR67nd/RYADkFvEXf6cRA2R+oB73Odn+
	uPmw==
Content-Disposition: inline
In-Reply-To: <20130711093405.GC2377-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Kay Sievers <kay-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 11, 2013 at 10:34:05AM +0100, Daniel P. Berrange wrote:
> FWIW, libvirt's usage of devcg is to deny all by default, allow major 136
> (for all /dev/pts/*), followed by allow (major,minor) pair for each specific
> whitelisted devices. As such we don't have anything that relies on ordering
> of rules in devcg.

I'd personally much prefer something very simple - allow all by
default, allow only the specified if explicitly specified.  I really
don't want full iptables like facility inside devcg.

Thanks.

-- 
tejun
