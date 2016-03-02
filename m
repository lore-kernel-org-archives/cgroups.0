From: Nikolay Borisov <n.borisov@siteground.com>
Subject: Re: [PATCH] block: transfer source bio's cgroup tags to
 clone via bio_associate_blkcg() (was: Re: blkio cgroups controller doesn't
 work with LVM?)
Date: Wed, 2 Mar 2016 21:59:13 +0200
Message-ID: <CAJFSNy7E9b06JQOdjzKDpz5Ehks4ZZ1disfN2U-RQxJnSwyqZw@mail.gmail.com>
References: <56CDF283.9010802@windriver.com> <56CEB1BC.4000005@kyup.com>
	<20160225145314.GA20699@redhat.com>
	<20160302160649.GB29826@mtj.duckdns.org>
	<20160302175656.GA59991@redhat.com>
	<CAJFSNy6hni1-NWDs0z=Hq223=DfcjsNPoAb7GRAGEPCUXh4Q9w@mail.gmail.com>
	<20160302191827.GC3476@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4811560372323770672=="
Return-path: <dm-devel-bounces@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=siteground-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to
	:cc; bh=TIEhKjS6zgxR53T/41vUkPNBB8ZILUCnz8YInh3B4qM=;
	b=Wgd0YgPxE0ZeRRhzpvlJa2eddVtoWFmO9ZEPHC5iN+AaKtouaIwxiCclSG+utDFcQo
	u5dC7w3OB7EfXagq82unuZrq7WvEkl8m5LYID4ujFyY7JuvREC2piGDd0cJ9Fvqhwiy2
	d0nXdGfWzYLjjI8saD/pbJq20lBWXzu0PDp8BA8hc7A0icXZBwbSqpOxg+LGAPprh6Ho
	nRxGrT4bZWoBqgOe5bMwUHOtjEDU9vhRS3gp+7xDkLfz1ybIv4HnjfK7C1BC5M23sKCd
	b91MqpwULpUdkq/quUEJr4uvC6JdfWaJxTCjDfDecdKNTIyD7a3asq0o0sCTbtxaDra9
	Qp7g==
In-Reply-To: <20160302191827.GC3476@redhat.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, SiteGround Operations <operations@siteground.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Nikolay Borisov <kernel@kyup.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Chris Friesen <chris.friesen@windriver.com>

--===============4811560372323770672==
Content-Type: multipart/alternative; boundary=089e0112d014eb0b40052d1650c9

--089e0112d014eb0b40052d1650c9
Content-Type: text/plain; charset=UTF-8

On Wednesday, March 2, 2016, Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Mar 02, 2016 at 08:03:10PM +0200, Nikolay Borisov wrote:
> > Thanks for the patch I will likely have time to test this sometime next
> week.
> > But just to be sure - the expected behavior would be that processes
> > writing to dm-based devices would experience the fair-shair
> > scheduling of CFQ (provided that the physical devices that back those
> > DM devices use CFQ), correct?
>
> Nikolay,
>
> I am not sure how well it will work with CFQ of underlying device. It will
> get cgroup information right for buffered writes. But cgroup information


 Right, what's your definition of  buffered writes? My mental model is that
when a process submits a write request to a dm device , the bio is going to
be put on a devi e workqueue which would then  be serviced by a background
worker thread and later the submitter notified. Do you refer to this whole
gamut of operations as buffered writes?

for reads and direct writes will come from submitter's context and if dm
> layer gets in between, then many a times submitter might be a worker
> thread and IO will be attributed to that worker's cgroup (root cgroup).


Be that as it may, proivded that the worker thread is in the  'correct'
cgroup,  then the appropriate babdwidth policies should apply, no?

>
> Give it a try anyway.


Most certainly I will :)


>
> Thanks
> Vivek
>

--089e0112d014eb0b40052d1650c9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>On Wednesday, March 2, 2016, Vivek Goyal &lt;<a href=3D"mailto:vgoy=
al@redhat.com">vgoyal@redhat.com</a>&gt; wrote:<br><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex">On Wed, Mar 02, 2016 at 08:03:10PM +0200, Nikolay Borisov wrote:<br>
&gt; Thanks for the patch I will likely have time to test this sometime nex=
t week.<br>
&gt; But just to be sure - the expected behavior would be that processes<br=
>
&gt; writing to dm-based devices would experience the fair-shair<br>
&gt; scheduling of CFQ (provided that the physical devices that back those<=
br>
&gt; DM devices use CFQ), correct?<br>
<br>
Nikolay,<br>
<br>
I am not sure how well it will work with CFQ of underlying device. It will<=
br>
get cgroup information right for buffered writes. But cgroup information</b=
lockquote><div><br></div><div>=C2=A0Right, what&#39;s your definition of =
=C2=A0buffered writes? My mental model is that when a process submits a wri=
te request to a dm device , the bio is going to be put on a devi e workqueu=
e which would then =C2=A0be serviced by a background worker thread and late=
r the submitter notified. Do you refer to this whole gamut of operations as=
 buffered writes?</div><div><br></div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
for reads and direct writes will come from submitter&#39;s context and if d=
m<br>
layer gets in between, then many a times submitter might be a worker<br>
thread and IO will be attributed to that worker&#39;s cgroup (root cgroup).=
</blockquote><div><br></div><div>Be that as it may, proivded that the worke=
r thread is in the =C2=A0&#39;correct&#39; cgroup, =C2=A0then the appropria=
te babdwidth policies should apply, no?=C2=A0</div><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex">
<br>
Give it a try anyway.</blockquote><div><br></div><div>Most certainly I will=
 :)</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Thanks<br>
Vivek<br>
</blockquote>

--089e0112d014eb0b40052d1650c9--


--===============4811560372323770672==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4811560372323770672==--
