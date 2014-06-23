From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Date: Mon, 23 Jun 2014 15:20:22 -0400
Message-ID: <20140623192022.GA19660@mtj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <538926F6.7080409@kernel.dk>
 <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
 <0A5218F8-0215-4B4F-959B-EE5AAEFC164A@unimore.it>
 <20140619014600.GA20100@mtj.dyndns.org>
 <53A24B1C.1070004@kernel.dk>
 <8F719638-0CD7-4BD2-8F4F-088913A0EE2D@unimore.it>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xhpiW5ljGQB9YAcPRZKijR189HlYY2/p15dbDodL0NE=;
        b=C5OBG9LNSp2Iw+Trxt00jTiB3vc/7O/CgYw4zlQdarYEfAmspPRoQD2Q8yudE1g9O9
         mhmIrCH7r0uN4N1X9SiRnwboGJK9mlffnCj88CoRbtkG6XFvQdB7dBHLULyKz9SpnGd/
         iHDW/5J7NUs6Tb/a76QzB/gZs7zU9EHdICpyk2d2mgnmHGpZPicNzQlMZM12zu0mdYeD
         XxJmW731XhSM81KnTP6JCK03DdNe6lPwtPu7b/faNRHB747hhH7LImmVXzL31ErUfgWy
         k0lFvS7+U4kuMRGmjALcu5REEKJ+mzAcvCNsev2Klu/zbwng/H+1GQwxtcQtpKsEclgR
         B65A==
Content-Disposition: inline
In-Reply-To: <8F719638-0CD7-4BD2-8F4F-088913A0EE2D-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jun 23, 2014 at 03:53:09PM +0200, Paolo Valente wrote:
> I will wait shortly for a possible feedback on this proposal, and,
> then, if nothing has still to be changed or refined, silently start
> the process.

We'll prolly end up doing a few iterations but overall it sounds good
to me.

Thanks.

-- 
tejun
