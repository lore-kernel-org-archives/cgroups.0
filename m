From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 4/8] cgroup, block: implement task_get_css() and use
 it in bio_associate_current()
Date: Tue, 19 May 2015 13:05:01 +1000
Message-ID: <CAOviyagxp32_kr30+O2ATFarvyjuASBy0j9xuXORkwrXahZ79g@mail.gmail.com>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
	<1431960667-26593-5-git-send-email-cyphar@cyphar.com>
	<20150518215907.GJ24861@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150518215907.GJ24861-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, richard-/L3Ra7n9ekc@public.gmane.org, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi Tejun,

> Applied 1-4 but skipped bio_associate_current() changes from this
> patch.  I'll route that part through a different patchset.

Do you want the updated versions of 6-8 of the patchset to be based on
your tree's for-next?

--
Aleksa Sarai (cyphar)
www.cyphar.com
