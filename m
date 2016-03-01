From: Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH block/for-linus] writeback: flush inode cgroup wb switches
 instead of pinning super_block
Date: Tue, 1 Mar 2016 05:39:47 -0800
Message-ID: <CAAeU0aPXTWSO776giVFtUWgPvFiT_ofA=kW23KUkFawA-EYjMQ@mail.gmail.com>
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
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=VmP0y4e11Isbp3IegFuFcxJt5CjNZnSNfHmOafe14Hg=;
        b=ot/JfvLnB7JefAvKf3pGppb41xjDbulkf+33xQx5Parqf5DrO0ytJxwfVc0vJrAbRy
         5G8vAFrzZ87tElqJ/OLjsM4LPyq7ijJ+gGa+sDHPlh7AyxSVfadZ1PlKbrCFrNJ4mBJv
         /iGhMn37bR5u+shdXD/l0NphhsanQT9O3YulpBMaBv/cjZB0gGi3hJ1uui/pgJyFvhVJ
         MGByi1hX9s1QGY0Jt1F4I1GL1Yc4Wa8Lpruweiv1nkkT2RAIJZTq1SzYn3g5oHSnNzn/
         UC72UF1Y6sjaUA+x4dureLVsWGQTmXbMLy9K3wlEzMTOotBuIhYmOxIj0QjNjLnAgFse
         PHPQ==
In-Reply-To: <20160229204724.GV3965@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Nauman Rafique <nauman@google.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Feb 29, 2016 at 12:47 PM, Tejun Heo <tj@kernel.org> wrote:
> Tahsin, can you please verify that this removes the asynchronous
> behavior while still avoiding the original issue?
>

I verified that this fixes the original issue and also removes the
asynchronous umount behavior.

Thanks a lot for the fix.
