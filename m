From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 block/for-linus] writeback: flush inode cgroup wb
 switches instead of pinning super_block
Date: Tue, 1 Mar 2016 12:50:19 -0500
Message-ID: <CAOS58YO5vTBnM561np7gpXKGQELrT169bYqmcfvAvsquBJK5yw@mail.gmail.com>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
	<20160215210047.GN3965@htj.duckdns.org>
	<CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
	<20160216182457.GO3741@mtj.duckdns.org>
	<20160217205721.GE14140@quack.suse.cz>
	<20160217210744.GA6479@mtj.duckdns.org>
	<20160217223009.GN14140@quack.suse.cz>
	<CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
	<20160217230231.GC6479@mtj.duckdns.org>
	<20160229204724.GV3965@htj.duckdns.org>
	<20160229232853.GD3965@htj.duckdns.org>
	<56D5D592.2020800@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc;
        bh=1RVJBj0F1aEyAflDG3sBJUfxn3fZRIDYO0jeW8+6tq4=;
        b=dJu8edTSMZa1Oc4t1evkCf2DF1MZCUdPQyJSiaRtZo5yAK3z2W+I7vNOphDGf+KSrh
         VzBoXcDJhTcvR3jN0dcyiQJ/w+RgSXTzdf2ED3o8QRdhmJoD0Hev86xXxQYtKnS9J0Ls
         62tg1G77J41rhIJntcgxFcZWZk5p+Yu+F7V+l6+CcYw8OPGcKHd4GZgZSTeWeyL0Wrgt
         Xf7bYgtoTNq4YqLCHLTIVQc/83jv3PnRBw6YNz2/9MgXpVm5cBPosS2Y/acFSy958lWa
         T79NMSD7fWPGc+BHM3UlTy41qk0CsBnwAcrrQWsnGLzpvHUPgZsnZqgFVUr8BtnpHElJ
         lbcQ==
In-Reply-To: <56D5D592.2020800-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

Hello, Jens.

On Tue, Mar 1, 2016 at 12:46 PM, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org> wrote:
> I queued this up for 4.5, but I'm feeling a bit uneasy about it. But it's
> either that, or revert 5ff8eaac1636 and fix it for real in 4.6. Jan/Tejun,
> what do you think?

Given that this only matters for cgroup writeback cases, this should
still be fairly low impact, so I don't think it'd matter too much
whether we fix this in this cycle or for 4.6. However, that also means
that we're not risking much by doing it in this cycle, so I'd vote for
doing it now.

Thanks.

-- 
tejun
