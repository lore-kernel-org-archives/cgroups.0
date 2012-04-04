From: Tao Ma <tm-d1IQDZat3X0@public.gmane.org>
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight
 to cfq)
Date: Thu, 05 Apr 2012 00:06:14 +0800
Message-ID: <4F7C7176.5090504@tao.ma>
References: <4F7A261A.9000200@tao.ma> <20120402222504.GA2672@redhat.com> <4F7A2B21.5000907@tao.ma> <20120403153736.GI5913@redhat.com> <4F7B2708.6080504@tao.ma> <20120403164959.GJ5913@redhat.com> <4F7B32AE.7050900@tao.ma> <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com> <20120404133705.GB12676@redhat.com> <CANejiEVD6nFVqX8Jf_hmRHg8YyBvPxbTVjgEif3mO1aa925KkQ@mail.gmail.com> <20120404151014.GD12676@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tao.ma; s=default;
	h=Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Subject:CC:To:MIME-Version:From:Date:Message-ID; bh=Z1UFeLIHVymGTFf+H4UzOpbggnMH4aCl17YR/czTa9s=;
	b=zSzh+rsGaEVRu+jFXER07SOMSW7scEVt7wDQVeOBpvcFRtIFWFDil4Vzqf7MN3EQOCv9x7RBtlY5E48bfssTsH4UGgGlwf1nECXMKljl/n477RYLbr3rOgxn2GnwvO0c;
In-Reply-To: <20120404151014.GD12676-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On 04/04/2012 11:10 PM, Vivek Goyal wrote:
> On Wed, Apr 04, 2012 at 07:52:24AM -0700, Shaohua Li wrote:
> 
> [..]
>> Agreed, we can tweak cfq to make it support iops fairness because the two
>> are conceptually the same. The problem is if this is a mess. CFQ is quite
>> complicated already. In iops mode, a lot of code isn't required, like idle,
>> queue merging, thinktime/seek detection and so on, as the scheduler
>> will be only for ssd. With recent iocontext cleanup, the iops scheduler
>> code is quite short actually.
> 
> Ok, this is somewhat a better reason to have a separate scheduler. I guess
> we need to look that actual iops code and that can help decide whether
> to keep it as a separate scheduler.
yes, actually I am afraid of making any *big* changes to cfq since it is
stable and complicated. It would be terrible for our customer which uses
sata and sas most of their time. So iops based scheduler is only used
for ssds.
> 
> One question is still unanswered though. What real workload benefits
> from it? If you are not doing idling in iops based scheduler, I doubt
> you are doing to see much service differentiation on fast SSDs. As for
> service differentiation IO queues have to be continuously backlogged and
> total IOPS needed by applications need to be more than what disk can
> offer. It becomes very hard to produe continuously backlogged queues
> because real applications tend to read some data, proces data and then
> generate more IO. 
OK, I guess I can describe our workload somehow. Yes, for very fast
SSDs, it would not help since the io depth is too high and we can't fill
in enough requests. But for some not that fast SSDs(say intel's x25m
series), it can only have tens of thousands iops, and it would help us
if we can have this type of ssd work as proportional. Yes, in most case,
the ssd will be idle, but we do have times that the disk is very busy
and we need the proportional iops to fit our customer's need.

Thanks
Tao
