From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v6 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Thu, 9 Jun 2022 00:14:14 +0200
Message-ID: <YqEfNgUc8jxlAq8D@blackbook>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-4-longman@redhat.com>
 <20220608165732.GB19399@blackbody.suse.cz>
 <506eaa3d-be84-c51e-3252-2979847054fe@redhat.com>
 <YqEQ1cudjZmUU7rs@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1654726456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bYRBaqQ5xfDUzDMhvL/gENcLA6nTCJt7le5LzsPSniY=;
        b=E8LMadkm3oV0PagrJYsbb9CJD02ZCJKLnfI+SV3wWkspNytEU+mEt9e0Xfr8NDYsFmKi1k
        D0IIgWsaHyT4g/EnsJ4cTeMnDvFPy7xV3TgWjpVp9blE6TuD1CCF4okKm/Q7cb2YPuJpLw
        RtRxhJxH2wDE05ScRVzlUNeWWaswivo=
Content-Disposition: inline
In-Reply-To: <YqEQ1cudjZmUU7rs@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On Wed, Jun 08, 2022 at 11:12:55PM +0200, Michal Koutn=FD <mkoutny@suse.com=
> wrote:
> Wouldn't that mean submitting a bio from offlined blkcg?
> blkg_tryget_closest() should prevent that.

Self-correction -- no, forgot blkg_tryget_closest() gets any non-zero
reference, not just a live one (percpu_ref_tryget_live()), furthermore,
I can see that offlined blkcg may still issue writeback bios for
instance.

> > I guess one possible solution may be to abandon the llist and revert
> > back to list iteration when offline. I need to think a bit more about
> > that.

Since blkcg stats are only used for io.stat of an online blkcg, the
update may be skipped on an offlined blkcg. (Which of course breaks when
something starts to depend on the stats of an offlined blkcg.)

Michal
