From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] bfq: Fix use-after-free with cgroups
Date: Mon, 13 Dec 2021 15:52:31 +0100
Message-ID: <20211213145231.GD14044@quack2.suse.cz>
References: <20211201133439.3309-1-jack@suse.cz>
 <20211207190843.GA40898@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1639407151; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=43M2it8+IRN7ztvN3MVNcuqsPzC82xu3mXqH42vHp/w=;
        b=Bha888jUF49BJg0Yx/Q2f/dGOpxdG07cUjW1uJEJAbPnAhE5vYIuAMYgFDrCLxrUFVgn5k
        2m0DLn6v0cYFG+CBwFFnAxOnkQ5BkSuRMuZHfgymNj2+XcGIGBpiWwQlZOHOeSh6bjzYjb
        mioZYYjS/7OFMlp6W0oRsML6QT48u5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1639407151;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=43M2it8+IRN7ztvN3MVNcuqsPzC82xu3mXqH42vHp/w=;
        b=7a+4nkwTbIc+ynCyI7UiIhiu18ei2lYqSvxWypfGadh8I+0X1w4tkbpz4vsa0cVIkLIYuT
        jzUxR55YuV4L5uBg==
Content-Disposition: inline
In-Reply-To: <20211207190843.GA40898@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Jan Kara <jack@suse.cz>, Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, fvogt@suse.de, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, stable@vger.kernel.org, Fabian Vogt <fvogt@suse.com>

On Tue 07-12-21 20:08:43, Michal Koutn=FD wrote:
> On Wed, Dec 01, 2021 at 02:34:39PM +0100, Jan Kara <jack@suse.cz> wrote:
> > After some analysis we've found out that the culprit of the problem is
> > that some task is reparented from cgroup G to the root cgroup and G is
> > offlined.
>=20
> Just sharing my interpretation for context -- (I saw this was a system
> using the unified cgroup hierarchy, io_cgrp_subsys_on_dfl_key was
> enabled) and what was observed could also have been disabling the io
> controller on given level -- that would also manifest similarly -- the
> task is migrated to parent and the former blkcg is offlined.

Yes, that's another possibility.

> > +static void bfq_reparent_children(struct bfq_data *bfqd, struct bfq_gr=
oup *bfqg)
> > [...]
> > -	bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);
> > [...]
> > +	hlist_for_each_entry_safe(bfqq, next, &bfqg->children, children_node)
> > +		bfq_bfqq_move(bfqd, bfqq, bfqd->root_group);
>=20
> Here I assume root_group is (representing) the global blkcg root and
> this reparenting thus skips all ancestors between the removed leaf and
> the root. IIUC the associated io_context would then be treated as if it
> was running in the root blkcg.
> (Admittedly, this isn't a change from this patch but it may cause some
> surprises if the given process runs after the operation.)

Yes, this is what happens in bfq_reparent_children() and basically
preserves what BFQ was already doing for a subset of bfq queues.

> Reparenting to the immediate ancestors should be safe as cgroup core
> should ensure children are offlined before parents. Would it make sense
> to you?

I suppose yes, it makes more sense to reparent just to immediate parents
instead of the root of the blkcg hierarchy. Initially when developing the
patch I was not sure whether parent has to be still alive but as you write
it should be safe. I'll modify the patch to:

static void bfq_reparent_children(struct bfq_data *bfqd, struct bfq_group *=
bfqg)
{
        struct bfq_queue *bfqq;
        struct hlist_node *next;
        struct bfq_group *parent;

        parent =3D bfqg_parent(bfqg);
        if (!parent)
                parent =3D bfqd->root_group;

        hlist_for_each_entry_safe(bfqq, next, &bfqg->children, children_nod=
e)
                bfq_bfqq_move(bfqd, bfqq, parent);
}

=20
> > @@ -897,38 +844,17 @@ static void bfq_pd_offline(struct blkg_policy_dat=
a *pd)
> > [...]
> > -		 * It may happen that some queues are still active
> > -		 * (busy) upon group destruction (if the corresponding
> > -		 * processes have been forced to terminate). We move
> > -		 * all the leaf entities corresponding to these queues
> > -		 * to the root_group.
>=20
> This comment is removed but it seems to me it assumed that the
> reparented entities are only some transitional remainings of terminated
> tasks but they may be the processes migrated upwards with a long (IO
> active) life ahead.

Yes, this seemed to be a misconception of the old code...

								Honza

--=20
Jan Kara <jack@suse.com>
SUSE Labs, CR
