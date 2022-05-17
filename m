From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: Issue with 252c651a4c85 ("blk-cgroup: stop using seq_get_buf")
Date: Tue, 17 May 2022 08:11:52 +0200
Message-ID: <20220517061152.GA4789@lst.de>
References: <CACGdZYK3iLc8u+YuyteaWqLRCHUJvR10Gem6MFyx36wP4Z2y2Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACGdZYK3iLc8u+YuyteaWqLRCHUJvR10Gem6MFyx36wP4Z2y2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Khazhy Kumykov <khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, w.bumiller-YTcQvvOqK21BDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, May 12, 2022 at 03:42:54PM -0700, Khazhy Kumykov wrote:
> I can see in the latest tip, if we have devices with no statistics,
> we'll print the maj:min and then nothing else, which can end up
> looking weird, (e.g. like below.) I see that in older kernels, we
> avoided printing the device name at all if there were no stats, and it
> looks like this behavior was silently broken by 252c651a4c85
> ("blk-cgroup: stop using seq_get_buf"), where before we prepared the
> whole line then decided at the end whether to commit it or not.
> 
> I do see a patch "blk-cgroup: always terminate io.stat lines" that
> addresses this by just unconditionally printing the newline (though it
> looks like that patch never landed).

It should really go in, I just sent a ping for it.
