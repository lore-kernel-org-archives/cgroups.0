From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 21:07:32 +0200
Message-ID: <Y4UG9H9QsMnCvN+D@smile.fi.intel.com>
References: <20221128033057.1279383-1-longman@redhat.com>
 <d08a0059-7c0b-d65f-d184-5b0cb75c08ed@acm.org>
 <f89e922c-16d5-0bcf-7e7e-096f42793a36@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669662474; x=1701198474;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6IzE0TtuysAfUgoGUzezLoeld/EU8Trm4OQzeKfJ5oc=;
  b=nC33FJv7I7UUaafnwb7gtU7gcd48/D3HXD7kM70PnQwFq+a5WKgQFVmf
   Qpoeq4d2z6WFa4f0I/AqYXkVjmLpLwlSX31SojKnBh8zXofcvsKOYfQI2
   L5Y9XXy9t/MS7VTLzPP4JVohyx37lDBvaJEI1zZ+F2c0JJSA97uz+9xmG
   LYvax2PhFRDzixRdQxvQdIGxqot3lVmY+HOWFeGb0yqqWqAO3qO5+/2am
   v+BEpiNcjojt7fmIIUcixlr8yD9MzX6MfAKMFF4ywf+V+cBRJnkwbBFle
   4l51rj/RN1KVL2VgjQTpqG4Z3FcF5rHQ4nGovhO0wkDuA+PDhRcANyn/3
   w==;
Content-Disposition: inline
In-Reply-To: <f89e922c-16d5-0bcf-7e7e-096f42793a36@kernel.dk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Yi Zhang <yi.zhang@redhat.com>

On Mon, Nov 28, 2022 at 12:00:55PM -0700, Jens Axboe wrote:
> On 11/28/22 11:56=E2=80=AFAM, Bart Van Assche wrote:
> > On 11/27/22 19:30, Waiman Long wrote:
> >> Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction pat=
h")
> >=20
> > Has Jens' for-next branch perhaps been rebased? I see the following com=
mit ID for that patch:
> >=20
> > dae590a6c96c ("blk-cgroup: Flush stats at blkgs destruction path")
>=20
> I don't know that sha is from, not from me. for-6.2/block has not been
> rebased, for-next gets rebased whenever I need to do so as linux-next is
> continually rebased anyway. But the sha for that commit would not change
> as a result.
>=20
> I don't even have that sha in my tree, so...

$ git tag --contains dae590a6c96c
next-20221117
next-20221118
next-20221121
next-20221122
next-20221123
next-20221124
next-20221125
next-20221128

--=20
With Best Regards,
Andy Shevchenko


