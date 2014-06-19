From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Date: Wed, 18 Jun 2014 21:49:20 -0400
Message-ID: <20140619014920.GB20100@mtj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <538926F6.7080409@kernel.dk>
 <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
 <0A5218F8-0215-4B4F-959B-EE5AAEFC164A@unimore.it>
 <20140619014600.GA20100@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=A760ZKPu1fTvXw+x4O1OgopFWnSO9Jnp7vBMq85vLhc=;
        b=b0AxbGAbx8DgL1efLAHcwFQuJiQOdHSegs9kjJAY/xtSvZ79Cfgjywhs9TNPwIclXZ
         PpbTfU9rRXEN7zw6eVy0pEZLI6It/9kmuO11QaJZPAXSrDn3GaDbpWpwJWJcqDpDBDrx
         WOMyAH6ngm4es9ffQYZXLv2TOKJz91CrOYum9WXO/YgE0BY1ICguuKoTX44HBFeAb3Qi
         wms+Jj00OuiFM4kbCmZIZ389l5k7Pn7BYxY3tSy7gJNclS6ZxFmsPBbtNLCJPxW3ANKs
         nTbNCbEHZ2dHJci5R9nLO/5Ari7vvLBHG/jmNjPTCv/z22r18e949CkuqQC1QP7TXSmV
         c7GQ==
Content-Disposition: inline
In-Reply-To: <20140619014600.GA20100-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 18, 2014 at 09:46:00PM -0400, Tejun Heo wrote:
...
> So, the perfectly smooth and performant transformation is possible,
     ^
     if
> it'd be great, but I don't really think that'd be the case.  My

-- 
tejun
