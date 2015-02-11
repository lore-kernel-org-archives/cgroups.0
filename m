From: Konstantin Khlebnikov <koct9i-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Thu, 12 Feb 2015 00:22:34 +0300
Message-ID: <CALYGNiMm2VajBx0Y+XtLJ8860JS-GHfuSXQrBt32Wt0K7QpH0A@mail.gmail.com>
References: <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com>
	<20150205131514.GD25736@htj.dyndns.org>
	<xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
	<20150205222522.GA10580@htj.dyndns.org>
	<xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
	<20150206141746.GB10580@htj.dyndns.org>
	<CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
	<20150207143839.GA9926@htj.dyndns.org>
	<20150211021906.GA21356@htj.duckdns.org>
	<CAHH2K0aHM=jmzbgkSCdFX0NxWbHBcVXqi3EAr0MS-gE3Txk93w@mail.gmail.com>
	<20150211203359.GF21356@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=6unf2wOFUIFUuhpxCOb7swm3j+egHgp0QYMbIKqdWnE=;
        b=UmZymxLIqMQzC8ZMdJT/0xZYcQ6gRM/HPiSookpJ62D8jOcQDKH/7XM3C8b+9bBMIG
         p9LLdghgUOedqJ9nGhRLnsxTxFUuGIh4lVK7WkW1ijCTrsT7eFKJeZwm3ioM3ACPRH4k
         3FRXVLBAJ3bURX1VEeKS2gve+WovGVxNoKrNRs0VEQPO6D5ifo7D4RW3+UZYd/OPdeul
         IaP7fG8ZAjmoQfkv5GfevedYyzIEvNVVy7zJYTUO90DANr5gp8ACVCgKFImB9OI6EK55
         4rdb+aECvrZYkUrIFlyH3md/y0syNTQZiocHEKErQKIYnCfO2cL58A4AieEV048Kw+Ka
         sR0Q==
In-Reply-To: <20150211203359.GF21356-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Feb 11, 2015 at 11:33 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Greg.
>
> On Wed, Feb 11, 2015 at 10:28:44AM -0800, Greg Thelen wrote:
>> This seems good.  I assume that blkcg writeback would query
>> corresponding memcg for dirty page count to determine if over
>> background limit.  And balance_dirty_pages() would query memcg's dirty
>
> Yeah, available memory to the matching memcg and the number of dirty
> pages in it.  It's gonna work the same way as the global case just
> scoped to the cgroup.

That might be a problem: all dirty pages accounted to cgroup must be
reachable for its own personal writeback or balanace-drity-pages will be
unable to satisfy memcg dirty memory thresholds. I've done accounting
for per-inode owner, but there is another option: shared inodes might be
handled differently and will be available for all (or related) cgroup
writebacks.

Another side is that reclaimer now (mosly?) never trigger pageout.
Memcg reclaimer should do something if it finds shared dirty page:
either move it into right cgroup or make that inode reachable for
memcg writeback. I've send patch which marks shared dirty inodes
with flag I_DIRTY_SHARED or so.

>
>> page count to throttle based on blkcg's bandwidth.  Note: memcg
>> doesn't yet have dirty page counts, but several of us have made
>> attempts at adding the counters.  And it shouldn't be hard to get them
>> merged.
>
> Can you please post those?
>
> So, cool, we're in agreement.  Working on it.  It shouldn't take too
> long, hopefully.

Good. As I see this design is almost equal to my proposal,
maybe except that dumb first-owns-all-until-the-end rule.

>
> Thanks.
>
> --
> tejun
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
