From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Date: Mon, 2 Jun 2014 14:51:38 -0400
Message-ID: <20140602185138.GD8912@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <538926F6.7080409@kernel.dk>
 <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
 <20140602172454.GA8912@htj.dyndns.org>
 <538CB515.3090700@kernel.dk>
 <20140602174250.GC8912@htj.dyndns.org>
 <538CB87C.7030600@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BNGZlai9/91WIGhN+5OqUJ0ia4x3SQq9SshhuoyS1P0=;
        b=avYORpeQ9m3hUVSQ0bnqKhRrv0g+XNoVZ/1LgQO06Y9p1N2/yivCzn2WuQgiOn52As
         r7mFiohOWQ8c1SmCDARbqAeNbJ/re0Er4d2+pFzstTVoKCdQ7Pu0DlYNJR7OL/1EsoKD
         nq4gkQBSiROpv7U5ANIMtRF+ZhpiXyxXSiaY00QZSPZw7cr/ioXoqgZaDFceOyOHA+xM
         3rc2MQCA46+ZWTXfrcIcdnqQhnTNTveeg0WOjppjSeMR4ragW5EHpaQkRg0Vz8ip3kaO
         ag6ox8OE0vXe/gpdFNK4xw5sDoPRhu+9oHQTCEqVVXA/Zg8sg8Muymzg96CIkoZKQhLH
         WOSw==
Content-Disposition: inline
In-Reply-To: <538CB87C.7030600-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Paolo Valente <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paolo Valente <posta_paolo-whZMOeQn8C0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Mon, Jun 02, 2014 at 11:46:36AM -0600, Jens Axboe wrote:
> But blk-mq will potentially drive anything, so it might not be out of
> the question with a more expensive scheduling variant, if it makes any
> sense to do of course. At least until there's no more rotating stuff out
> there :-). But it's not a priority at all to me yet. As long as we have
> coexisting IO paths, it'd be trivial to select the needed one based on
> the device characteristics.

Hmmm... yeah, moving rotating devices over to blk-mq doesn't really
seem beneficial to me.  I think there are fundamental behavioral
differences for rotating rusts and newer solid state devices to share
single code path for things like scheduling and selecting the
appropriate path depending on the actual devices sounds like a much
better plan even in the long term.

Thanks.

-- 
tejun
