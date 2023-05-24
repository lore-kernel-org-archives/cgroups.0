From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] blk-cgroup: Flush stats before releasing blkcg_gq
Date: Wed, 24 May 2023 12:21:53 +0800
Message-ID: <ZG2Q4f2eL1vCTWEd@ovpn-8-17.pek2.redhat.com>
References: <20230524011935.719659-1-ming.lei@redhat.com>
 <CAJD7tkZkbro4H-QC=RJx_dfCdGQ5c=4NJhbFrcEmQSidaaMOmg@mail.gmail.com>
 <ZG14VnHl20lt9jLc@ovpn-8-17.pek2.redhat.com>
 <cfef97ec-bb77-4ccb-a0b2-8f1eb66afeb6@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684902131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8RThbuZCrca9ja7PWjTCEifSQrfusG35C3xzRTql4Rg=;
        b=cYNb0sAiu/W6R/ezsJOfoKzDhh0X6MACnGi3jNBPawLquYmEKzuQglKuJLI1ipnDP//yu2
        vQ6jZoIftNOKDum5JTEkAvlHuYxy+YHW3jg+L1SSEQUGTx4+yQ5vum5yp1Z6m4ByYdqlaa
        e3AosYOaBk21sqAe9VIJITh787uhq7g=
Content-Disposition: inline
In-Reply-To: <cfef97ec-bb77-4ccb-a0b2-8f1eb66afeb6@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Linux-MM <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, mkoutny@suse.com, ming.lei@redhat.com

On Wed, May 24, 2023 at 12:10:55AM -0400, Waiman Long wrote:
>=20
> On 5/23/23 22:37, Ming Lei wrote:
> > Hi Yosry,
> >=20
> > On Tue, May 23, 2023 at 07:06:38PM -0700, Yosry Ahmed wrote:
> > > Hi Ming,
> > >=20
> > > On Tue, May 23, 2023 at 6:21=E2=80=AFPM Ming Lei <ming.lei@redhat.com=
> wrote:
> > > > As noted by Michal, the blkg_iostat_set's in the lockless list
> > > > hold reference to blkg's to protect against their removal. Those
> > > > blkg's hold reference to blkcg. When a cgroup is being destroyed,
> > > > cgroup_rstat_flush() is only called at css_release_work_fn() which
> > > > is called when the blkcg reference count reaches 0. This circular
> > > > dependency will prevent blkcg and some blkgs from being freed after
> > > > they are made offline.
> > > I am not at all familiar with blkcg, but does calling
> > > cgroup_rstat_flush() in offline_css() fix the problem?
> > Except for offline, this list needs to be flushed after the associated =
disk
> > is deleted.
> >=20
> > > or can items be
> > > added to the lockless list(s) after the blkcg is offlined?
> > Yeah.
> >=20
> > percpu_ref_*get(&blkg->refcnt) still can succeed after the percpu refcnt
> > is killed in blkg_destroy() which is called from both offline css and
> > removing disk.
>=20
> As suggested by Tejun, we can use percpu_ref_tryget(&blkg->refcnt) to make
> sure that we can only take a reference when the blkg is online. I think it
> is a bit safer to take a percpu refcnt to avoid use after free. My other

blkg_release() does guarantee that no new stat associated with this
blkg can be added any more, so what is the use-after-free?

> concern about your patch is that the per cpu list iterations will be done
> multiple times when a blkcg is destroyed if many blkgs are attached to the

Yeah, but is it one big deal? The percpu list should be flushed just in one
of blkg's release handler.

> blkcg. I still prefer to do it once in blkcg_destroy_blkgs(). I am going =
to

Problem is that new stat still may be added to this list after
percpu_ref_kill() returns.

To be honest, I really hate to grab/put blkg refcnt for adding/consuming
state, and this way is too fragile.

Thanks,
Ming

