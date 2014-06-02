From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
	Scheduler
Date: Mon, 2 Jun 2014 13:33:32 -0400
Message-ID: <20140602173332.GB8912@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
	<1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
	<20140530160712.GG24871@htj.dyndns.org>
	<464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it>
	<20140530232804.GA5057@htj.dyndns.org>
	<20140602111432.GA3737@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=kc+HeLkwGNd2YOcoQV3s0QtBkkISvLiRI1jx5cxkPQs=;
	b=lmeCpoNmh2RGMiAQMVgQScv9wey43pyviR3MJ9Q0qigYFWFR0vSpcnRk99LaD3IWBq
	1uiH1ZjAwUCghRGW2uYjSfua7skNEEKJiV6SsORby4WAO9ljqvoPt0ci6MfIqzHxxRi7
	eOOWy6IGVQvWnZykELF3ZoiGmFbAp3IED0MRCEarOSsZgCidGxH/hXHSGA8o3Wl9IFQw
	Aqp3VMw023eMNpj3813z+KVDq88CWXjG/zcHuNNLlJEeLxETcw4YUnXG8Q7+NLDnIhOS
	9sLWXEJukxFBnAgb7H7rmdtaax+6pBCgxgtIpb1B7HNUtA/CZYnfUtUGki5Id5GqK7Ep
	WGsQ==
Content-Disposition: inline
In-Reply-To: <20140602111432.GA3737-tWAi6jLit6GreWDznjuHag@public.gmane.org>
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
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Pavel.

On Mon, Jun 02, 2014 at 01:14:33PM +0200, Pavel Machek wrote:
> Now.. I see it is more work for storage maintainers, because there'll
> be more code to maintain in the interim. But perhaps user advantages
> are worth it?

I'm quite skeptical about going that route.  Not necessarily because
of the extra amount of work but more the higher probability of getting
into situation where we can neither push forward or back out.  It's
difficult to define clear deadline and there will likely be unforeseen
challenges in the planned convergence of the two schedulers,
eventually, it isn't too unlikely to be in a situation where we have
to admit defeat and just keep both schedulers.  Note that developer
overhead isn't the only factor here.  Providing two slightly different
alternatives inevitably makes userland grow dependencies on subtleties
of both and there's a lot less pressure to make judgement calls and
take appropriate trade-offs, which have fairly high chance of
deadlocking progress towards any direction.

Thanks.

-- 
tejun
