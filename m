From: Hong zhi guo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] blk-throttle: simplify logic by token bucket algorithm
Date: Sun, 20 Oct 2013 20:08:12 +0800
Message-ID: <CAA7+ByVfuUz74NHoH+hu=Nb=TpKL0kVtn5Nsf7gs83b4Den2zw@mail.gmail.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
	<1382012272-26170-1-git-send-email-zhiguohong@tencent.com>
	<20131018155532.GD2277@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=jV3x4+rhaF+jvDZ37kvygrzaVP9xtrkZ+UBrvp6yQWU=;
        b=YzgWWkWwEf7YyG8hirpDZ6caIx/zj4Zsxa9YEcXCZTmIOp+tanrCG9IyAv9/wiT5Hz
         99BJL5p6naSSu0DsoQdUmn+qhn/4AuTxkXCjYJeIk01zGSi3V/+9LMxb/vNXFcIKMC51
         PNOqID4+B2BAjz7axn1xEbplvIDlTWM08/2fZ0IhQYiI5MLr9UQSCfEcJz4k19Zw+SNA
         5r1F6p7qOc53bowighlLwgmJzrG0qGGixu/zTOtWMRNvglrbboQax6/tXG6PDjn3zTD7
         BWc4mKE/Bac7n+fkFeI+cWlHloxO0JX2DbzSBkU2r9ybie49jm+2uVoqtbA2kjGsmqe1
         6NvQ==
In-Reply-To: <20131018155532.GD2277-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Hi, Vivek,

Thanks for your comments. I didn't realize the ancestor over-trim issue before.

Trimming of iops token is not necessary. Since a bio always costs
_one_ iops token. Trimming it won't change the fact that current iops
token is zero or not.

For hierarchical triming, as you pointed out, there's 2 issues in my v3 patch.
1) When bio climbs up, the parent group is not trimmed.
2) When bio climbs up, we should not trim groups level by level,
   that would block the bio too much time than expected.

You proposed time keeping method helps.
But how about some bios waiting on multiple child group, and climb up
in different order than they get queued on clild group? Some token is
still missed.
How does this works for multiple levels of ancestors?

I got another idea and implementation for the issues. The basic idea is:
When the bio is queued on child group, all it's ancestor groups
becomes non-idle. They should start to reserve tokens for that bio
from this moment. And tokens they reserved before should be trimmed at
this moment.

I'll also send the implementation later.

Please help to review the idea and code. Thanks.

On Fri, Oct 18, 2013 at 11:55 PM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Oct 17, 2013 at 08:17:52PM +0800, Hong Zhiguo wrote:
>
> I think same logic need to be applied to iops too?
>
> Also, how does it work in case of hierarchy? IIUC, when bio is being
> propogated upwards, we first add it to the parent, and then later
> update dispatch time which will in turn call tg_with_in_bps_limit().
>
> So by the time you come here after bio propogation, bio is already
> on service queue and it will be entitiled to *unlimited* idle tokens.
>
> On the flip side, we can't do blind truncation of idle tokens in
> parent group. Reason being that once bio got queued in child group,
> effectively it should be subjected to parent's limits too right now
> and not necessarily when it climbs up the tree.
>
> To solve this problem I had put following patch.
>
> commit 32ee5bc4787dfbdb280b4d81a338dcdd55918c1e
> Author: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Tue May 14 13:52:38 2013 -0700
>
>     blk-throttle: Account for child group's start time in parent while bio
> climb
>
>
> Above solution was not perfect but seemed like reasonable approximation.
> We might have to do something similar. I think we can keep track of time
> when an bio starts waiting in a group (gets to head of list) and then
> when that bio is dispatched, pass that time to parent group. Now
> parent can give more tokens to bio based on wait time start as passed
> by children.
>
> For example say Twaitstart is the time a bio started waiting on the head
> of queue of a group. Say Tidle is time when parent became idle. Now when
> child passes this bio to parent, it will also pass Twaitstart to parent.
> When it comes time for token calculation, parent can do following.
>
> If (time_after(Twaitstart, Tidle)
>         start_time = Twaitstart;
> else
>         start_time = Tidle;
>
> token_eligibility = (jiffies - start_time) * rate;
>
> This is far from perfect, but it should work reasonably.
>
> Thanks
> Vivek

-- 
best regards
Hong Zhiguo
