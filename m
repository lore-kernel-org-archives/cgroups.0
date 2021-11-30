From: Jan Kara <jack@suse.cz>
Subject: Re: Use after free with BFQ and cgroups
Date: Tue, 30 Nov 2021 12:50:10 +0100
Message-ID: <20211130115010.GF7174@quack2.suse.cz>
References: <20211125172809.GC19572@quack2.suse.cz>
 <20211126144724.GA31093@blackbody.suse.cz>
 <YaUKCoK39FlZK9m5@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1638273018; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3g3Z2MHUwUd1U35Ol3NxlY4iDKazpPykX0gbbPMrAWY=;
        b=j4vu2nuSB4Pk+hKkNIuqa7F6LZdF7W1GGIWqnax9L/VHC/0fyfYcOTDJl4j5sH6CJsJzKh
        VJ69Xlqk6w6rpEDZ5ZwBqlDBFKt/5ICKSnHIchMp8pQ/eexjcGzUKq6Zo3hBtrXkv3bL/a
        ZT1YlOGtfNoYRjatIyx9onATTlp4s1Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1638273018;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3g3Z2MHUwUd1U35Ol3NxlY4iDKazpPykX0gbbPMrAWY=;
        b=ehUdP68vAtmSHTHJYSSDA5CqwkeARFhp8yhXfq1ZRbaz2ccFKhGOo1QmtlPepq2JBM8fuF
        lnxvddYgPR/UMZBA==
Content-Disposition: inline
In-Reply-To: <YaUKCoK39FlZK9m5@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Jan Kara <jack@suse.cz>, Paolo Valente <paolo.valente@linaro.org>, linux-block@vger.kernel.org, fvogdt@suse.de, cgroups@vger.kernel.org

On Mon 29-11-21 07:12:42, Tejun Heo wrote:
> On Fri, Nov 26, 2021 at 03:47:24PM +0100, Michal Koutn=FD wrote:
> > The question here is how long would stay the offlined blkcgs around if
> > they were directly pinned upon the IO submission. If it's unbound, then
> > reparenting makes more sense.
>=20
> It should be fine to pin whatever's necessary while related IOs are in
> flight and percpu_ref used for css refcnting isn't gonna make any noticea=
ble
> difference in terms of overhead.

Yes, holding cgroup ref from IO would be fine. But that is not really our
problem.

The problem is bfq_queue associated with a task effectively holds a
reference to the potentially dead cgroup and the reference can stay there
until the task (that itself got reparented to the root cgroup) exits. So I
think we need to reparent these bfq_queue structures as well to avoid
holding cgroup in zombie state excessively long.

								Honza
--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
