From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Date: Wed, 16 Oct 2013 12:22:06 -0400
Message-ID: <20131016162205.GF17611@redhat.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
 <20131015173252.GM31215@redhat.com>
 <CAA7+ByWjdYTi5uXT6apLYkON1RnrFEGjHU318OD1VMen2YHKOA@mail.gmail.com>
 <20131016141405.GE17611@redhat.com>
 <20131016155344.GA10012@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131016155344.GA10012-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hong zhi guo <honkiko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hong Zhiguo <zhiguohong-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

On Wed, Oct 16, 2013 at 11:53:44AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 16, 2013 at 10:14:06AM -0400, Vivek Goyal wrote:
> > - First of all, if you think that a group is entitiled for tokens even
> >   when it is not doing IO, then why are you truncating the tokens after
> >   dispatch of a BIO.
> > 
> > - Second in general it does not seem right that a group is entitiled to
> >   tokens even when no IO is happening or group is not backlogged. That
> >   would mean a group will not do IO for 10 hours and then be entitiled
> >   to those tokens suddenly after 10 hours with a huge burst.
> > 
> > So I think you also agree that a group should not be entitiled to
> > tokens when group is not backlogged and that's why you seem to be
> > truncating extra tokens after dispatch of a BIO. If that's the case,
> > then even for first BIO, ideally a group should not be given tokens
> > for idle time.
> 
> Without going into details, having token reserve is an important part
> of token based implementation.  The large the reserve could be
> debatable but that's what provides "smoothing" of allocation.  e.g. if
> you trim bucket as soon as the queue becomes empty, a queue with
> sequential access pattern can easily get disadvantaged.  Another way
> to look at it is to consider as though the IO has been issued some
> time before than actual and waited for the token - it is the same to
> external observers.
> 
> So, while how large the reserve should be is definitely debatable,
> bucket scheduling *needs* idle reserve.

Hi Tejun,

Agreed. We need some kind of smoothing and allow burst up to a limit. I
am only questioning *unlimited* tokens for the first bio in a group which
has been idle for a long time.

Thanks
Vivek
