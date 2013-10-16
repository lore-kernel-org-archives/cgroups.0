From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Wed, 16 Oct 2013 10:14:06 -0400
Message-ID: <20131016141405.GE17611@redhat.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
 <20131015173252.GM31215@redhat.com>
 <CAA7+ByWjdYTi5uXT6apLYkON1RnrFEGjHU318OD1VMen2YHKOA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA7+ByWjdYTi5uXT6apLYkON1RnrFEGjHU318OD1VMen2YHKOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hong zhi guo <honkiko@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, Hong Zhiguo <zhiguohong@tencent.com>

On Wed, Oct 16, 2013 at 02:09:40PM +0800, Hong zhi guo wrote:
> Hi, Vivek,
> 
> Thanks for your careful review. I'll rename t_c to last_dispatch, it's
> much better.
> 
> For the big burst issue, I've different opinion. Let's discuss it.
> 
> Any time a big IO means a big burst. Even if it's throttled at first
> time, queued in
> the service_queue, and then waited for a while, when it's delivered
> out, it IS still
> a big burst. So throttling the bio for another while makes no sense.

If a malicious application is creating a big BIO and sending it out, then
effective IO rate as seen by application will be much higher than
throttling limit.

So yes, a burst is anyway going to happen when big IO is dispatched
to disk, but the question is when should that burst be allowed. What's
the effective IO rate application should see.
 
> 
> If a group has been idle for 5 minutes, then it owns the credit to
> deliver a big IO
> (within 300 * bps bytes). And the extra credit will be cut off after
> the delivery.

I think there are couple of issues here.

- First of all, if you think that a group is entitiled for tokens even
  when it is not doing IO, then why are you truncating the tokens after
  dispatch of a BIO.

- Second in general it does not seem right that a group is entitiled to
  tokens even when no IO is happening or group is not backlogged. That
  would mean a group will not do IO for 10 hours and then be entitiled
  to those tokens suddenly after 10 hours with a huge burst.

So I think you also agree that a group should not be entitiled to
tokens when group is not backlogged and that's why you seem to be
truncating extra tokens after dispatch of a BIO. If that's the case,
then even for first BIO, ideally a group should not be given tokens
for idle time.

Just think that an application has a huge BIO, say size 2MB. And group
has limit of say 8KB per second. Now if group has been idling long enough,
this BIO will be dispatched immediately. And effective rate a group
will be is much higher than 8KB/s. Which is not right, IMO.

If you argue that token entitilement for idle groups is not right and
doing it for first BIO in a batch is exception for simplicity reasons,
that still might be fine. But right now that does not seem to be the
case.

Thanks
Vivek
