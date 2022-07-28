From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Skip subtree root in
 cgroup_update_dfl_csses()
Date: Thu, 28 Jul 2022 07:26:05 -1000
Message-ID: <YuLGrXyXj6a2yigJ@slm.duckdns.org>
References: <20220728005815.1715522-1-longman@redhat.com>
 <20220728005815.1715522-2-longman@redhat.com>
 <20220728144426.GA26631@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc;
        bh=yPjjAlHvkDbffFb+wNaNKaLJK2amB18Tv3U4RxiGxog=;
        b=ejdELvaM315ArBoL4nBGJKiTx05RJpFOTrByKL0vtASdXa4d3m9POeYXVINfmdTV3Q
         bgp0vNy+cRh4ZauFeqHTGWaUfJwD0cfZGRNbdiY16zWcAn9QbdmrIbjWGiqUP/VNLDW0
         SYSkW2RT7FuEEIEgPGYQySBWnwjHrM+pkSUp8sm9UuAYl7KdjmNxst0wTF1W6eyRhHc/
         iOdEygDMIi7uGGHfRzBu8/KVrkh0hSL+gtvUf1IqpY/YsBdItP84W/40tzv8ejvtpvOX
         WTukcr84KeTz+8ZF6+t/tYSB+5S6UqWC+1PmlgGkqLno1Nq8oQGsZB6yQg5vLHGPYtJ9
         WizQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220728144426.GA26631-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 28, 2022 at 04:44:26PM +0200, Michal Koutn=FD wrote:
> On Wed, Jul 27, 2022 at 08:58:15PM -0400, Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
> > The cgroup_update_dfl_csses() function updates css associations when a
> > cgroup's subtree_control file is modified. Any changes made to a cgroup=
's
> > subtree_control file, however, will only affect its descendants but not
> > the cgroup itself.=20
>=20
> I find this correct.
>=20
> > So there is no point in migrating csses associated with that cgroup.
> > We can skip them instead.
>=20
> Alone it's not such a big win but it componds with the recent Tejun's
> threadgroup_rwsem elision.

The chance is that if you're writing to a cgroup's subtree_control, that
cgroup is gonna be empty. The only case I can think of that this would make
a difference is w/ threaded cgroups, but it does make sense.

Thanks.

--=20
tejun
