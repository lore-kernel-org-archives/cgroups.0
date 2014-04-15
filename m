From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
Date: Tue, 15 Apr 2014 12:18:28 -0400
Message-ID: <20140415161828.GA30990@htj.dyndns.org>
References: <1397056052-2829-1-git-send-email-tj@kernel.org>
	<20140414213100.GA1863@htj.dyndns.org>
	<20140414222658.GA18152@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=gZzHp241J0La/LKZEjaQFLqpy9v6Pxgdx2L5RZ8hlEg=;
	b=lZcwHTV9Dv2vDBs6v3CQdpJGSv75a39BJzResvv127V0Co+ThnNa9G105J+mOmYzIl
	rjCgxPHfaxU7iSUeDhbBseUDvNs89juBx9CrXkmmIJE0oRe/3ei0cIFlzRbX981zt4MH
	nyhq7tWTgqzOfMZuVXBL2FRk83PHO3Ueu+tdmmotzfdxU0q5vc0cl9zTs7Q9+r4lXuCc
	iZHcTYBHJVz0Mv/coUTG7WAuWesJYwYY8MORocLxSpg6qrD9+JYqYOEuntwCxqKfsr2d
	WUxLCRF29Sr8PVD70cEgSy/RxEf4zmOp2FEi9PNvNHSlV3Sny12aSiXMYnBUKJK/1IfT
	yS3g==
Content-Disposition: inline
In-Reply-To: <20140414222658.GA18152-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
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
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, kay-tD+1rO4QERM@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org

Hello, Greg.

On Mon, Apr 14, 2014 at 03:26:58PM -0700, Greg KH wrote:
> Do you want me to pull this branch into my tree for 3.16 now?  I have no
> objection to you taking it, if that's easier for you, which ever is fine
> for me.

I think the best way to proceed would be applying 1-2 to
driver-core-next and then base cgroup/for-3.16 on top of it, but I'd
like to get some feedback from inotify people before proceeding.

Thanks.

-- 
tejun
