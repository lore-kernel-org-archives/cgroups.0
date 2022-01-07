From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 2/2] block: cancel all throttled bios in del_gendisk()
Date: Fri, 7 Jan 2022 11:18:47 -1000
Message-ID: <YdiuN9kv5OvE/Rtf@slm.duckdns.org>
References: <20211210083143.3181535-1-yukuai3@huawei.com>
 <20211210083143.3181535-3-yukuai3@huawei.com>
 <20220107150519.GA26824@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+mr+pZW4rtkqx4SLZE7ugT/NQ4UbxX8mOU3Dn6TRB6E=;
        b=ZuF6bOWd6HtMcHA/bmJB1Shy2xxq6HYD6KqDZeTxu750fya3OiGetfqbVr2CUYNqbA
         AnEyOYmA4HDVuAXKWGU4om1OHTDuf9bVVL9ZJd23rN4X/C2DjSEZg3SgRmMK0g5mBXg1
         c5an3csi7XL+F6f1NicQH8YOUasfa2gWNBpW1XXIgYMDvOAwrE8koHzN1h02gbtMe0lw
         I9ZJB59fM4queKy4VeG0J2GhXboceIkj0Zbyr7WfYTBtHRxmRdf19WKeHoAXo/Axy5iU
         cFWUrrYcwe//r7iVsP9TWzOfqxpHZCg1N5yQn36Gnd1hMP5SClcAtkj7v9ID8c3XyhVo
         BRPA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220107150519.GA26824-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "Paul E. McKenney" <paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hello,

On Fri, Jan 07, 2022 at 04:05:19PM +0100, Michal Koutn=FD wrote:
> On Fri, Dec 10, 2021 at 04:31:43PM +0800, Yu Kuai <yukuai3-hv44wF8Li93QT0=
dZR+AlfA@public.gmane.org> wrote:
> > +	 * queue_lock is held, rcu lock is not needed here.
> > +	 */
> > +	blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)
> > +		tg_drain_bios(&blkg_to_tg(blkg)->service_queue);
>=20
> FTR, I acknowledge this can work due to RCU peculiarities, however, I
> don't understand why is it preferred against more robust explict
> rcu_read_lock().
>=20
> (All in all, this isn't a deal breaker and I'm not confident evaluating
> the rest of the patch.)

Cc'ing Paul for RCU. Paul, this nit is around whether or not to use
rcu_read_lock() in an irq disabled section. I can see both sides of the
arguments - it's weird to put in an extra rcu_read_lock() when technically
unnecessary but it's also nice to have something explicit and structured to
mark parts which require RCU protection. Putting in a comment is okay but
consistency is difficult to achieve that way.

Maybe all these are unnecessary as lockdep would be able to catch them
anyway, or maybe we'd want something to explicitly mark RCU protected
sections. I don't know but whichever way, I think we need to establish a
convention.

Thanks.

--=20
tejun
