From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC RESEND 00/14] New version of the BFQ I/O Scheduler
Date: Fri, 30 May 2014 13:59:37 -0400
Message-ID: <20140530175937.GK24871@htj.dyndns.org>
References: <1401194558-5283-1-git-send-email-paolo.valente@unimore.it>
 <20140530153228.GE16605@redhat.com>
 <20140530161650.GH24871@htj.dyndns.org>
 <20140530170958.GF16605@redhat.com>
 <20140530172609.GI24871@htj.dyndns.org>
 <20140530175527.GH16605@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=USa14YWcHzUyZKMNymg0SIy3hEaegq95THsa6O2xVdI=;
        b=UXHaBNuP1ohu13XLcbr1QA5cgwtZYYrEhXF6c8LIfMwaQ751uDUjrm+zsGrOtRU8AS
         ra44IPGXMz8gczfJWcq1SDgoE4xD3t/9w6p3ZPgLuawNTMkazVLiDHmUXKHkGLYruxdu
         g4LYJ2p3sr/GU/20mSve+32lEps0VkBsLZxKT7pT1mUGziOetM3Yipz1pWc6Hb49HnHN
         ePhiQBjttPYg2MBwsgw3B6JOloFkd+AHf8uyvz4Y1+N0tjZ/Ry2ee7T8hIkJrOjsgvBI
         rQM9Qi9BQb4ExcuJ6t/JlqjvRPSREbqzDq9sfkVlWB3YhaMaZKh7pFv4xiTFr+4aeKH0
         nqNQ==
Content-Disposition: inline
In-Reply-To: <20140530175527.GH16605-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: paolo <paolo.valente-rcYM44yAMweonA0d6jMUrA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Fabio Checconi <fchecconi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Arianna Avanzini <avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paolo Valente <posta_paolo-whZMOeQn8C0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hey, Vivek.

On Fri, May 30, 2014 at 01:55:27PM -0400, Vivek Goyal wrote:
> Now CFQ also dynamically adjusts the slice length based on the how
> many queues are ready to do IO. One problem with fixed slice lenth
> round robin was that if there are lot of queues doing IO, then after
> serving one queue, same queue will get time slice after a long time.
> 
> Corrado Zoccolo did work in this area in an attempt to improve latency.
> Now slice length is calculated dynamically in an attempt to achieve
> better latency.

Consdier it a better version of that.

> Ok, so you prefer to have another IO scheduler instead of improving
> CFQ?

As I wrote in another reply, I think the best approach would be
morphing cfq to accomodate the scheduling algorithm and heristics of
bfq.

> Tejun, I have spent significant amount of time on BFQ few years ago. And
> that's the reason I have not read it again yet. My understanding was
> that there was nothing which would not be done in CFQ (atleast things
> which mattered).

THERE IS A NEW PAPER.

> Looks like you prefer introducing a new scheduler instead of improving
> CFQ. My preference is to improve CFQ. Borrow good ideas from BFQ and
> implement them in CFQ.

LOOKS LIKE YOU ARE NOT READING ANYTHING AND JUST WRITING IRRELEVANT
SHIT.

> So why not improve CFQ instead of carrying and maintaining another 
> scheduler. And then have a discussion that what's the default scheduler.

For fuck's sake, I'm out.  This is total waste of time.  You don't
read what others are writing and refuse to study what's right there.
What are you doing?

-- 
tejun
